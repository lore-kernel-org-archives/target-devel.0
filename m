From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Tue, 26 Jun 2018 12:35:47 +0000
Subject: Re: [PATCH v3] target: add emulate_pr backstore attr to toggle PR support
Message-Id: <946c4371-c864-d3a5-d4de-a9b7d2c8bb3f@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180625185658.31141-1-ddiss@suse.de>
In-Reply-To: <20180625185658.31141-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 06/25/18 20:56, David Disseldorp wrote:
> The new emulate_pr backstore attribute allows for Persistent Reservation
> and SCSI2 RESERVE/RELEASE support to be completely disabled. This can be
> useful for scenarios such as:
> - Ensuring ATS (Compare & Write) usage on recent VMware ESXi initiators.
> - Allowing clustered (e.g. tcm-user) backends to block such requests,
>    avoiding the multi-node reservation state propagation.
>
> When explicitly disabled, PR and RESERVE/RELEASE requests receive
> Invalid Command Operation Code response sense data.

Currently I'm working on changes in the same area. But in my case we
would need an attribute to optionally allow pr and alua CDBs to be
passed to user space via tcm-user transparently. I already have the
patches prepared but didn't send them yet as an important detail
still is missing. (See details below)
In general my patches change the existing 'pr/alua_support'
attributes to be writable.

If this patch and the mine would be accepted, we would have three
different modes for pr handling: the normal in stack handling, the
reject of pr CDBs and transparent pass through. The former two being
available for all backstore devices but the latter for devices using
passthrough_parse_cdb() only.

Obviously it would be great to have only one attribute to control
emulation mode. That would be easier if we had two different modes
only for any dev.

Now I'm wondering whether the "reject pr CDBs" mode does make sense
for e.g. tcm-user. Wouldn't it be enough to have the emulation
in stack and the transparent mode only? In that case userspace process
simply could use transparent mode and send a reject for these CDBs.

So I'd like to propose the following:
1) Have an attribute to switch between normal mode (pr_support active)
    and new mode (pr_support inactive).
Whether this is done via the existing pr_support attribute or via
    a new attribute is a question of flavor.
2) If pr_support is inactive, spc_parse_cdb() would reject PR CDBs
    while passthrough_parse_cdb() would pass through those CDBs to
    userspace.
3) In the "pr_support inactive" mode for devices using
passthrough_parse_cdb() the transport_flag
TRANSPORT_FLAG_PASSTHROUGH_PGR would be set. For devices using
    spc_parse_cdb() a new flag like TRANSPORT_FLAG_REJECT_PGR should be
    used. (See details below regarding dev specific transport_flags.)
4) The same could be done for ALUA also.

What do you think?

--Bodo


Details of my patches:

Currently the transport_flags are per transport template, while the
pr_support and alua_support attributes are per backstore device.
So my patches add a per se_dev copy of the transport_flags which is
initialized on device creation and which replaces all current uses
of the transport_flags.
Next I make the pr_/alua_support attributes writable, but have an
additional field in the transport template that allows to reject
changes depending on the transport. By setting bits in the additional
field of tcm-user's transport template only, changing the
pr_/alua_support attributes would be possible for tcm_user, but not
pscsi for the moment.

While the patches described above are ready, I'm still developing a
further change:
In the pr/alua transparent mode userspace processes should not only
be able to reject PR/ALUA CDBs but also to process them correctly.
Therefore userspace process optionally needs the I_T_NEXUS info for
each CDB.
My plan was to first finish this last patch before sending the entire
series. But now I could send the first part earlier.

I'm adding Mike Christie on CC, as he already gave me some very
helpful hints for my patches.

> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>   drivers/target/target_core_configfs.c | 32 ++++++++++++++++++++++++--------
>   drivers/target/target_core_device.c   | 13 +++++++++++++
>   drivers/target/target_core_pr.c       |  2 ++
>   drivers/target/target_core_spc.c      |  8 ++++++++
>   include/target/target_core_base.h     |  3 +++
>   5 files changed, 50 insertions(+), 8 deletions(-)
>
> Changes since v2:
> * handle target_pr_res_aptpl_metadata_store()
> * use common error path for spc_parse_cdb() and passthrough_parse_cdb()
>    checks
> * drop erroneous TRANSPORT_FLAG_PASSTHROUGH_PGR ->
>    TRANSPORT_FLAG_PASSTHROUGH changes
>
> Changes since v1:
> * block Reservation request passthrough when emulate_pr=0
> * fix some style issues
> * add an emulate_pr check to pgr_support_show()
>
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index 5ccef7d597fa..f7385a6950e4 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -532,6 +532,7 @@ DEF_CONFIGFS_ATTRIB_SHOW(emulate_tpu);
>   DEF_CONFIGFS_ATTRIB_SHOW(emulate_tpws);
>   DEF_CONFIGFS_ATTRIB_SHOW(emulate_caw);
>   DEF_CONFIGFS_ATTRIB_SHOW(emulate_3pc);
> +DEF_CONFIGFS_ATTRIB_SHOW(emulate_pr);
>   DEF_CONFIGFS_ATTRIB_SHOW(pi_prot_type);
>   DEF_CONFIGFS_ATTRIB_SHOW(hw_pi_prot_type);
>   DEF_CONFIGFS_ATTRIB_SHOW(pi_prot_format);
> @@ -592,6 +593,7 @@ static ssize_t _name##_store(struct config_item *item, const char *page,	\
>   DEF_CONFIGFS_ATTRIB_STORE_BOOL(emulate_fua_write);
>   DEF_CONFIGFS_ATTRIB_STORE_BOOL(emulate_caw);
>   DEF_CONFIGFS_ATTRIB_STORE_BOOL(emulate_3pc);
> +DEF_CONFIGFS_ATTRIB_STORE_BOOL(emulate_pr);
>   DEF_CONFIGFS_ATTRIB_STORE_BOOL(enforce_pr_isids);
>   DEF_CONFIGFS_ATTRIB_STORE_BOOL(is_nonrot);
>   
> @@ -1100,9 +1102,13 @@ static ssize_t pgr_support_show(struct config_item *item, char *page)
>   {
>   	struct se_dev_attrib *da = to_attrib(item);
>   	u8 flags = da->da_dev->transport->transport_flags;
> +	int pgr_support = 1;
>   
> -	return snprintf(page, PAGE_SIZE, "%d\n",
> -			flags & TRANSPORT_FLAG_PASSTHROUGH_PGR ? 0 : 1);
> +	if (!da->da_dev->dev_attrib.emulate_pr ||
> +	    (flags & TRANSPORT_FLAG_PASSTHROUGH_PGR))
> +		pgr_support = 0;
> +
> +	return snprintf(page, PAGE_SIZE, "%d\n", pgr_support);
>   }
>   
>   CONFIGFS_ATTR(, emulate_model_alias);
> @@ -1116,6 +1122,7 @@ CONFIGFS_ATTR(, emulate_tpu);
>   CONFIGFS_ATTR(, emulate_tpws);
>   CONFIGFS_ATTR(, emulate_caw);
>   CONFIGFS_ATTR(, emulate_3pc);
> +CONFIGFS_ATTR(, emulate_pr);
>   CONFIGFS_ATTR(, pi_prot_type);
>   CONFIGFS_ATTR_RO(, hw_pi_prot_type);
>   CONFIGFS_ATTR(, pi_prot_format);
> @@ -1156,6 +1163,7 @@ struct configfs_attribute *sbc_attrib_attrs[] = {
>   	&attr_emulate_tpws,
>   	&attr_emulate_caw,
>   	&attr_emulate_3pc,
> +	&attr_emulate_pr,
>   	&attr_pi_prot_type,
>   	&attr_hw_pi_prot_type,
>   	&attr_pi_prot_format,
> @@ -1427,6 +1435,9 @@ static ssize_t target_pr_res_holder_show(struct config_item *item, char *page)
>   	struct se_device *dev = pr_to_dev(item);
>   	int ret;
>   
> +	if (!dev->dev_attrib.emulate_pr)
> +		return sprintf(page, "SPC_RESERVATIONS_DISABLED\n");
> +
>   	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
>   		return sprintf(page, "Passthrough\n");
>   
> @@ -1567,12 +1578,14 @@ static ssize_t target_pr_res_type_show(struct config_item *item, char *page)
>   {
>   	struct se_device *dev = pr_to_dev(item);
>   
> +	if (!dev->dev_attrib.emulate_pr)
> +		return sprintf(page, "SPC_RESERVATIONS_DISABLED\n");
>   	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
>   		return sprintf(page, "SPC_PASSTHROUGH\n");
> -	else if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS)
> +	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS)
>   		return sprintf(page, "SPC2_RESERVATIONS\n");
> -	else
> -		return sprintf(page, "SPC3_PERSISTENT_RESERVATIONS\n");
> +
> +	return sprintf(page, "SPC3_PERSISTENT_RESERVATIONS\n");
>   }
>   
>   static ssize_t target_pr_res_aptpl_active_show(struct config_item *item,
> @@ -1580,7 +1593,8 @@ static ssize_t target_pr_res_aptpl_active_show(struct config_item *item,
>   {
>   	struct se_device *dev = pr_to_dev(item);
>   
> -	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
> +	if (!dev->dev_attrib.emulate_pr ||
> +	    (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR))
>   		return 0;
>   
>   	return sprintf(page, "APTPL Bit Status: %s\n",
> @@ -1592,7 +1606,8 @@ static ssize_t target_pr_res_aptpl_metadata_show(struct config_item *item,
>   {
>   	struct se_device *dev = pr_to_dev(item);
>   
> -	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
> +	if (!dev->dev_attrib.emulate_pr ||
> +	    (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR))
>   		return 0;
>   
>   	return sprintf(page, "Ready to process PR APTPL metadata..\n");
> @@ -1638,7 +1653,8 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
>   	u16 tpgt = 0;
>   	u8 type = 0;
>   
> -	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
> +	if (!dev->dev_attrib.emulate_pr ||
> +	    (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR))
>   		return count;
>   	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS)
>   		return count;
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index e27db4d45a9d..e443ce5bf311 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -806,6 +806,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
>   	dev->dev_attrib.emulate_tpws = DA_EMULATE_TPWS;
>   	dev->dev_attrib.emulate_caw = DA_EMULATE_CAW;
>   	dev->dev_attrib.emulate_3pc = DA_EMULATE_3PC;
> +	dev->dev_attrib.emulate_pr = DA_EMULATE_PR;
>   	dev->dev_attrib.pi_prot_type = TARGET_DIF_TYPE0_PROT;
>   	dev->dev_attrib.enforce_pr_isids = DA_ENFORCE_PR_ISIDS;
>   	dev->dev_attrib.force_pr_aptpl = DA_FORCE_PR_APTPL;
> @@ -1172,6 +1173,18 @@ passthrough_parse_cdb(struct se_cmd *cmd,
>   	}
>   
>   	/*
> +	 * With emulate_pr disabled, all reservation requests should fail,
> +	 * regardless of whether or not TRANSPORT_FLAG_PASSTHROUGH_PGR is set.
> +	 */
> +	if (!dev->dev_attrib.emulate_pr &&
> +	    ((cdb[0] = PERSISTENT_RESERVE_IN) ||
> +	     (cdb[0] = PERSISTENT_RESERVE_OUT) ||
> +	     (cdb[0] = RELEASE || cdb[0] = RELEASE_10) ||
> +	     (cdb[0] = RESERVE || cdb[0] = RESERVE_10))) {
> +		return TCM_UNSUPPORTED_SCSI_OPCODE;
> +	}
> +
> +	/*
>   	 * For PERSISTENT RESERVE IN/OUT, RELEASE, and RESERVE we need to
>   	 * emulate the response, since tcmu does not have the information
>   	 * required to process these commands.
> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> index 01ac306131c1..4ef516e168b4 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -4090,6 +4090,8 @@ target_check_reservation(struct se_cmd *cmd)
>   		return 0;
>   	if (dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE)
>   		return 0;
> +	if (!dev->dev_attrib.emulate_pr)
> +		return 0;
>   	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
>   		return 0;
>   
> diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
> index cb0461a10808..4ad05c8415c8 100644
> --- a/drivers/target/target_core_spc.c
> +++ b/drivers/target/target_core_spc.c
> @@ -1281,6 +1281,14 @@ spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
>   	struct se_device *dev = cmd->se_dev;
>   	unsigned char *cdb = cmd->t_task_cdb;
>   
> +	if (!dev->dev_attrib.emulate_pr &&
> +	    ((cdb[0] = PERSISTENT_RESERVE_IN) ||
> +	     (cdb[0] = PERSISTENT_RESERVE_OUT) ||
> +	     (cdb[0] = RELEASE || cdb[0] = RELEASE_10) ||
> +	     (cdb[0] = RESERVE || cdb[0] = RESERVE_10))) {
> +		return TCM_UNSUPPORTED_SCSI_OPCODE;
> +	}
> +
>   	switch (cdb[0]) {
>   	case MODE_SELECT:
>   		*size = cdb[4];
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index 922a39f45abc..bca3713e0658 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -87,6 +87,8 @@
>   #define DA_EMULATE_3PC				1
>   /* No Emulation for PSCSI by default */
>   #define DA_EMULATE_ALUA				0
> +/* Emulate SCSI2 RESERVE/RELEASE and Persistent Reservations by default */
> +#define DA_EMULATE_PR				1
>   /* Enforce SCSI Initiator Port TransportID with 'ISID' for PR */
>   #define DA_ENFORCE_PR_ISIDS			1
>   /* Force SPC-3 PR Activate Persistence across Target Power Loss */
> @@ -666,6 +668,7 @@ struct se_dev_attrib {
>   	int		emulate_tpws;
>   	int		emulate_caw;
>   	int		emulate_3pc;
> +	int		emulate_pr;
>   	int		pi_prot_format;
>   	enum target_prot_type pi_prot_type;
>   	enum target_prot_type hw_pi_prot_type;

