From: Lee Duncan <lduncan@suse.com>
Date: Fri, 18 May 2018 16:26:58 +0000
Subject: Re: [PATCH V2] TCMUser: add read length support
Message-Id: <4f06c30d-5a66-dda7-b4d4-c6b2bebde1bc@suse.com>
List-Id: <target-devel.vger.kernel.org>
References: <5afea28f.J3mbAcTR1O71tkwx%bstroesser@ts.fujitsu.com>
In-Reply-To: <5afea28f.J3mbAcTR1O71tkwx%bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 05/18/2018 02:53 AM, Bodo Stroesser wrote:
> Generally target core and TCMUser seem to work fine for tape devices and
> media changers.
> But there is at least one situation, where TCMUser is not able to support
> sequential access device emulation correctly.
> 
> The situation is when an initiator sends a SCSI READ CDB with a length that is
> greater than the length of the tape block to read. We can distinguish two
> subcases:
> 
> A) The initiator sent the READ CDB with the SILI bit being set.
>    In this case the sequential access device has to transfer the data from the
>    tape block (only the length of the tape block) and transmit a good status.
>    The current interface between TCMUser and the userspace does not support
>    reduction of the read data size by the userspace program.
> 
>    The patch below fixes this subcase by allowing the userspace program to
>    specify a reduced data size in read direction.
> 
> B) The initiator sent the READ CDB with the SILI bit not being set.
>    In this case the sequential access device has to transfer the data from the
>    tape block as in A), but additionally has to transmit CHECK CONDITION with
>    the ILI bit set and NO SENSE in the sensebytes. The information field in
>    the sensebytes must contain the residual count.
> 
>    With the below patch a user space program can specify the real read data
>    length and appropriate sensebytes.
>    TCMUser then uses the se_cmd flag SCF_TREAT_READ_AS_NORMAL, to force target
>    core to transmit the real data size and the sensebytes.
>    Note: the flag SCF_TREAT_READ_AS_NORMAL is introduced by Lee Duncan's
>    patch "[PATCH v4] target: transport should handle st FM/EOM/ILI reads" from
>    Tue, 15 May 2018 18:25:24 -0700.
> 
> This patch was created for kernel 4.15.9.
> 
> 
> Changes from RFC:
> - patch now uses SCF_TREAT_READ_AS_NORMAL to fix B) also.
> - comment changed accordingly
> 
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> ---
>  drivers/target/target_core_user.c     |   40 +++++++++++++++++++++++++++-------
>  include/uapi/linux/target_core_user.h |    4 ++-
>  2 files changed, 35 insertions(+), 9 deletions(-)
> 
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -576,7 +576,7 @@ static int scatter_data_area(struct tcmu
>  }
>  
>  static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
> -			     bool bidi)
> +			     bool bidi, uint32_t *read_len)
>  {
>  	struct se_cmd *se_cmd = cmd->se_cmd;
>  	int i, dbi;
> @@ -587,6 +587,7 @@ static void gather_data_area(struct tcmu
>  	struct page *page;
>  	unsigned int data_nents;
>  	uint32_t count = 0;
> +	uint32_t len_remaining = *read_len;
>  
>  	if (!bidi) {
>  		data_sg = se_cmd->t_data_sg;
> @@ -609,7 +610,7 @@ static void gather_data_area(struct tcmu
>  	for_each_sg(data_sg, sg, data_nents, i) {
>  		int sg_remaining = sg->length;
>  		to = kmap_atomic(sg_page(sg)) + sg->offset;
> -		while (sg_remaining > 0) {
> +		while (sg_remaining > 0 && len_remaining > 0) {
>  			if (block_remaining = 0) {
>  				if (from)
>  					kunmap_atomic(from);
> @@ -621,6 +622,7 @@ static void gather_data_area(struct tcmu
>  			}
>  			copy_bytes = min_t(size_t, sg_remaining,
>  					block_remaining);
> +			copy_bytes = min_t(size_t, copy_bytes, len_remaining);

It may just be me, but I don't like this consecutive use of min_t() to
set copy_bytes. I'd prefer adding something like:

	if (len_remaining < copy_bytes)
		copy_bytes = len_remaining;

but maybe I'm old-fashioned.

>  			offset = DATA_BLOCK_SIZE - block_remaining;
>  			tcmu_flush_dcache_range(from, copy_bytes);
>  			memcpy(to + sg->length - sg_remaining, from + offset,
> @@ -628,11 +630,15 @@ static void gather_data_area(struct tcmu
>  
>  			sg_remaining -= copy_bytes;
>  			block_remaining -= copy_bytes;
> +			len_remaining -= copy_bytes;
>  		}
>  		kunmap_atomic(to - sg->offset);
> +		if (len_remaining = 0)
> +			break;
>  	}
>  	if (from)
>  		kunmap_atomic(from);
> +	*read_len -= len_remaining;
>  }
>  
>  static inline size_t spc_bitmap_free(unsigned long *bitmap, uint32_t thresh)
> @@ -947,6 +953,8 @@ static void tcmu_handle_completion(struc
>  {
>  	struct se_cmd *se_cmd = cmd->se_cmd;
>  	struct tcmu_dev *udev = cmd->tcmu_dev;
> +	bool read_len_valid = false;
> +	uint32_t read_len = 0xffffffff;

Why do you set read_len? Is it to make the compiler happy? Because it
only gets used if read_len_valid is set, in which case it is also set,
right?

>  
>  	/*
>  	 * cmd has been completed already from timeout, just reclaim
> @@ -961,13 +969,29 @@ static void tcmu_handle_completion(struc
>  		pr_warn("TCMU: Userspace set UNKNOWN_OP flag on se_cmd %p\n",
>  			cmd->se_cmd);
>  		entry->rsp.scsi_status = SAM_STAT_CHECK_CONDITION;
> -	} else if (entry->rsp.scsi_status = SAM_STAT_CHECK_CONDITION) {
> +		goto done;
> +	}
> +
> +	if ((se_cmd->se_cmd_flags & SCF_BIDI) ||
> +	    se_cmd->data_direction = DMA_FROM_DEVICE) {
> +		read_len_valid = (entry->hdr.uflags & TCMU_UFLAG_READ_LEN) &&
> +		                 entry->rsp.read_len;
> +		if (read_len_valid)
> +			read_len = entry->rsp.read_len;

Again, perhaps it's just style, but this seems harder to read than:

		if (uflags & READ_LEN && read_len) {
			read_len_valid = true;
			read_len = entry...read_len;
		}

> +	}
> +
> +	if (entry->rsp.scsi_status = SAM_STAT_CHECK_CONDITION) {
>  		transport_copy_sense_to_cmd(se_cmd, entry->rsp.sense_buffer);
> -	} else if (se_cmd->se_cmd_flags & SCF_BIDI) {
> +		if (!read_len_valid )
> +			goto done;
> +		else
> +			se_cmd->se_cmd_flags |= SCF_TREAT_READ_AS_NORMAL;
> +	}
> +	if (se_cmd->se_cmd_flags & SCF_BIDI) {
>  		/* Get Data-In buffer before clean up */
> -		gather_data_area(udev, cmd, true);
> +		gather_data_area(udev, cmd, true, &read_len);
>  	} else if (se_cmd->data_direction = DMA_FROM_DEVICE) {
> -		gather_data_area(udev, cmd, false);
> +		gather_data_area(udev, cmd, false, &read_len);
>  	} else if (se_cmd->data_direction = DMA_TO_DEVICE) {
>  		/* TODO: */
>  	} else if (se_cmd->data_direction != DMA_NONE) {
> @@ -975,7 +999,14 @@ static void tcmu_handle_completion(struc
>  			se_cmd->data_direction);
>  	}
>  
> -	target_complete_cmd(cmd->se_cmd, entry->rsp.scsi_status);
> +done:
> +	if (read_len_valid) {
> +		pr_debug("read_len = %d\n", read_len);
> +		target_complete_cmd_with_length(cmd->se_cmd,
> +					entry->rsp.scsi_status, read_len);
> +	}
> +	else

This is just wrong. don't put the else on a separate line please.

> +		target_complete_cmd(cmd->se_cmd, entry->rsp.scsi_status);
>  
>  out:
>  	cmd->se_cmd = NULL;
> @@ -1532,7 +1563,7 @@ static int tcmu_configure_device(struct
>  	/* Initialise the mailbox of the ring buffer */
>  	mb = udev->mb_addr;
>  	mb->version = TCMU_MAILBOX_VERSION;
> -	mb->flags = TCMU_MAILBOX_FLAG_CAP_OOOC;
> +	mb->flags = TCMU_MAILBOX_FLAG_CAP_OOOC | TCMU_MAILBOX_FLAG_CAP_READ_LEN;
>  	mb->cmdr_off = CMDR_OFF;
>  	mb->cmdr_size = udev->cmdr_size;
>  
> --- a/include/uapi/linux/target_core_user.h
> +++ b/include/uapi/linux/target_core_user.h
> @@ -43,6 +43,7 @@
>  #define TCMU_MAILBOX_VERSION 2
>  #define ALIGN_SIZE 64 /* Should be enough for most CPUs */
>  #define TCMU_MAILBOX_FLAG_CAP_OOOC (1 << 0) /* Out-of-order completions */
> +#define TCMU_MAILBOX_FLAG_CAP_READ_LEN (1 << 1) /* Read data length */
>  
>  struct tcmu_mailbox {
>  	__u16 version;
> @@ -70,6 +71,7 @@ struct tcmu_cmd_entry_hdr {
>  	__u16 cmd_id;
>  	__u8 kflags;
>  #define TCMU_UFLAG_UNKNOWN_OP 0x1
> +#define TCMU_UFLAG_READ_LEN   0x2
>  	__u8 uflags;
>  
>  } __packed;
> @@ -118,7 +120,7 @@ struct tcmu_cmd_entry {
>  			__u8 scsi_status;
>  			__u8 __pad1;
>  			__u16 __pad2;
> -			__u32 __pad3;
> +			__u32 read_len;
>  			char sense_buffer[TCMU_SENSE_BUFFERSIZE];
>  		} rsp;
>  	};
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Lee Duncan
SUSE Labs
