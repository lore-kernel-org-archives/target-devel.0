From: Mike Christie <mchristi@redhat.com>
Date: Wed, 07 Nov 2018 01:54:17 +0000
Subject: Re: [PATCH v4] target: add emulate_pr backstore attr to toggle PR support
Message-Id: <5BE245C9.4060704@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20181030142643.17458-1-ddiss@suse.de>
In-Reply-To: <20181030142643.17458-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 10/30/2018 09:26 AM, David Disseldorp wrote:
> The new emulate_pr backstore attribute allows for Persistent Reservation
> and SCSI2 RESERVE/RELEASE support to be completely disabled. This can be
> useful for scenarios such as:
> - Ensuring ATS (Compare & Write) usage on recent VMware ESXi initiators.
> - Allowing clustered (e.g. tcm-user) backends to block such requests,
>   avoiding the need for multi-node reservation state propagation.
> 
> When explicitly disabled, PR and RESERVE/RELEASE requests receive
> Invalid Command Operation Code response sense data.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  drivers/target/target_core_configfs.c | 32 ++++++++++++++++++++++++--------
>  drivers/target/target_core_device.c   | 13 +++++++++++++
>  drivers/target/target_core_pr.c       |  2 ++
>  drivers/target/target_core_spc.c      |  8 ++++++++
>  include/target/target_core_base.h     |  3 +++
>  5 files changed, 50 insertions(+), 8 deletions(-)
> 
> Changes since v3:
> * rebase against current mainline
> 
> Changes since v2:
> * handle target_pr_res_aptpl_metadata_store()
> * use common error path for spc_parse_cdb() and passthrough_parse_cdb()
>   checks
> * drop erroneous TRANSPORT_FLAG_PASSTHROUGH_PGR ->
>   TRANSPORT_FLAG_PASSTHROUGH changes
> 
> Changes since v1:
> * block Reservation request passthrough when emulate_pr=0
> * fix some style issues
> * add an emulate_pr check to pgr_support_show()
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index f6b1549f4142..bacb771a333e 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -532,6 +532,7 @@ DEF_CONFIGFS_ATTRIB_SHOW(emulate_tpu);
>  DEF_CONFIGFS_ATTRIB_SHOW(emulate_tpws);
>  DEF_CONFIGFS_ATTRIB_SHOW(emulate_caw);
>  DEF_CONFIGFS_ATTRIB_SHOW(emulate_3pc);
> +DEF_CONFIGFS_ATTRIB_SHOW(emulate_pr);
>  DEF_CONFIGFS_ATTRIB_SHOW(pi_prot_type);
>  DEF_CONFIGFS_ATTRIB_SHOW(hw_pi_prot_type);
>  DEF_CONFIGFS_ATTRIB_SHOW(pi_prot_format);
> @@ -592,6 +593,7 @@ static ssize_t _name##_store(struct config_item *item, const char *page,	\
>  DEF_CONFIGFS_ATTRIB_STORE_BOOL(emulate_fua_write);
>  DEF_CONFIGFS_ATTRIB_STORE_BOOL(emulate_caw);
>  DEF_CONFIGFS_ATTRIB_STORE_BOOL(emulate_3pc);
> +DEF_CONFIGFS_ATTRIB_STORE_BOOL(emulate_pr);
>  DEF_CONFIGFS_ATTRIB_STORE_BOOL(enforce_pr_isids);
>  DEF_CONFIGFS_ATTRIB_STORE_BOOL(is_nonrot);
>  
> @@ -1100,9 +1102,13 @@ static ssize_t pgr_support_show(struct config_item *item, char *page)
>  {
>  	struct se_dev_attrib *da = to_attrib(item);
>  	u8 flags = da->da_dev->transport->transport_flags;
> +	int pgr_support = 1;
>  
> -	return snprintf(page, PAGE_SIZE, "%d\n",
> -			flags & TRANSPORT_FLAG_PASSTHROUGH_PGR ? 0 : 1);
> +	if (!da->da_dev->dev_attrib.emulate_pr ||
> +	    (flags & TRANSPORT_FLAG_PASSTHROUGH_PGR))
> +		pgr_support = 0;
> +

I think we want to keep this separate still. The file tells userspace if
PRs are supported in the backend module/device or in LIO core.

With the chunk above, if you had emulate_pr=0 and
TRANSPORT_FLAG_PASSTHROUGH_PGR is set, userspace cannot detect what the
backend supports. We would have to temporarily set emaulate_pr sow e can
read the file then clear it.
