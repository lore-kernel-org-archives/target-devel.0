From: Mike Christie <mchristi@redhat.com>
Date: Thu, 21 Jun 2018 20:25:35 +0000
Subject: Re: [PATCH v2] target: add emulate_pr backstore attr to toggle PR support
Message-Id: <5B2C09BF.6040100@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180621170508.13099-1-ddiss@suse.de>
In-Reply-To: <20180621170508.13099-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 06/21/2018 12:05 PM, David Disseldorp wrote:
> @@ -1592,7 +1606,8 @@ static ssize_t target_pr_res_aptpl_metadata_show(struct config_item *item,
>  {
>  	struct se_device *dev = pr_to_dev(item);
>  
> -	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
> +	if (!dev->dev_attrib.emulate_pr ||
> +	    (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH))
>  		return 0;


Why did you add the check here but not in
target_pr_res_aptpl_metadata_store?


>  
>  	return sprintf(page, "Ready to process PR APTPL metadata..\n");
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index e27db4d45a9d..e443ce5bf311 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -806,6 +806,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
>  	dev->dev_attrib.emulate_tpws = DA_EMULATE_TPWS;
>  	dev->dev_attrib.emulate_caw = DA_EMULATE_CAW;
>  	dev->dev_attrib.emulate_3pc = DA_EMULATE_3PC;
> +	dev->dev_attrib.emulate_pr = DA_EMULATE_PR;
>  	dev->dev_attrib.pi_prot_type = TARGET_DIF_TYPE0_PROT;
>  	dev->dev_attrib.enforce_pr_isids = DA_ENFORCE_PR_ISIDS;
>  	dev->dev_attrib.force_pr_aptpl = DA_FORCE_PR_APTPL;
> @@ -1172,6 +1173,18 @@ passthrough_parse_cdb(struct se_cmd *cmd,
>  	}
>  
>  	/*
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
>  	 * For PERSISTENT RESERVE IN/OUT, RELEASE, and RESERVE we need to
>  	 * emulate the response, since tcmu does not have the information
>  	 * required to process these commands.
> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> index 01ac306131c1..874ca3f0ee1b 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -208,6 +208,11 @@ target_scsi2_reservation_release(struct se_cmd *cmd)
>  	struct se_portal_group *tpg;
>  	int rc;
>  
> +	if (!dev->dev_attrib.emulate_pr) {
> +		pr_err("failing SCSI2 RELEASE with emulate_pr disabled\n");
> +		return TCM_UNSUPPORTED_SCSI_OPCODE;
> +	}
> +

Did you want the log message and failure points for all paths to match?
In the passthrough cdb case you fail in target_setup_cmd_from_cdb and
there is a ratelimited message specifically for this unsupported
commands. In the non passthrough cases you get messages like above and
the failure is later in target_execute_cmd.

You could put the emulate_pr checks in spc_parse_cdb and the error
messages and error code paths will be the same.

