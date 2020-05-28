From: Mike Christie <michael.christie@oracle.com>
Date: Thu, 28 May 2020 20:53:46 +0000
Subject: Re: [PATCH] scsi: target: tcmu: fix size in calls to tcmu_flush_dcache_range
Message-Id: <d13df4f2-edb5-3e13-8fd9-ddd5a80c809d@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200528193108.9085-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200528193108.9085-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org



On 5/28/20 2:31 PM, Bodo Stroesser wrote:
> 1) If remaining ring space before the end of the ring is
>     smaller then the next cmd to write, tcmu writes a padding
>     entry which fills the remaining space at the end of the
>     ring.
>     Then tcmu calls tcmu_flush_dcache_range() with the size
>     of struct tcmu_cmd_entry as data length to flush.
>     If the space filled by the padding was smaller then
>     tcmu_cmd_entry, tcmu_flush_dcache_range() is called for
>     an address range reaching behind the end of the vmalloc'ed
>     ring.
>     tcmu_flush_dcache_range() in a loop calls
>        flush_dcache_page(virt_to_page(start));
>     for every page being part of the range. On x86 the line is
>     optimized out by the compiler, as flush_dcache_page() is
>     empty on x86.
>     But I assume the above can cause trouble on other
>     architectures that really have a flush_dcache_page().
>     For paddings only the header part of an entry is relevant
>     Due to alignment rules the header always fits in the
>     remaining space, if padding is needed.
>     So tcmu_flush_dcache_range() can safely be called with
>     sizeof(entry->hdr) as the length here.
> 
> 2) After it has written a command to cmd ring, tcmu calls
>     tcmu_flush_dcache_range() using the size of a struct
>     tcmu_cmd_entry as data length to flush.
>     But if a command needs many iovecs, the real size of the
>     command may be bigger then tcmu_cmd_entry, so a part of
>     the written command is not flushed then.
> 
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> ---
>   drivers/target/target_core_user.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index f769bb1e3735..cdb4848d23c6 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1026,7 +1026,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
>   		entry->hdr.cmd_id = 0; /* not used for PAD */
>   		entry->hdr.kflags = 0;
>   		entry->hdr.uflags = 0;
> -		tcmu_flush_dcache_range(entry, sizeof(*entry));
> +		tcmu_flush_dcache_range(entry, sizeof(entry->hdr));
>   
>   		UPDATE_HEAD(mb->cmd_head, pad_size, udev->cmdr_size);
>   		tcmu_flush_dcache_range(mb, sizeof(*mb));
> @@ -1084,7 +1084,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
>   	cdb_off = CMDR_OFF + cmd_head + base_command_size;
>   	memcpy((void *) mb + cdb_off, se_cmd->t_task_cdb, scsi_command_size(se_cmd->t_task_cdb));
>   	entry->req.cdb_off = cdb_off;
> -	tcmu_flush_dcache_range(entry, sizeof(*entry));
> +	tcmu_flush_dcache_range(entry, command_size);
>   
>   	UPDATE_HEAD(mb->cmd_head, command_size, udev->cmdr_size);
>   	tcmu_flush_dcache_range(mb, sizeof(*mb));
> 

Acked-by: Mike Christie <michael.christie@oracle.com>
