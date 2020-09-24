From: Michael Christie <michael.christie@oracle.com>
Date: Thu, 24 Sep 2020 15:31:30 +0000
Subject: Re: [PATCH 3/8] vhost scsi: alloc cmds per vq instead of session
Message-Id: <BE3F7F89-D0BF-44BA-921A-112E104C96C5@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1600712588-9514-1-git-send-email-michael.christie@oracle.com>
 <1600712588-9514-4-git-send-email-michael.christie@oracle.com>
 <20200924022107-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200924022107-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org



> On Sep 24, 2020, at 1:22 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> 
> On Mon, Sep 21, 2020 at 01:23:03PM -0500, Mike Christie wrote:
>> We currently are limited to 256 cmds per session. This leads to problems
>> where if the user has increased virtqueue_size to more than 2 or
>> cmd_per_lun to more than 256 vhost_scsi_get_tag can fail and the guest
>> will get IO errors.
>> 
>> This patch moves the cmd allocation to per vq so we can easily match
>> whatever the user has specified for num_queues and
>> virtqueue_size/cmd_per_lun. It also makes it easier to control how much
>> memory we preallocate. For cases, where perf is not as important and
>> we can use the current defaults (1 vq and 128 cmds per vq) memory use
>> from preallocate cmds is cut in half. For cases, where we are willing
>> to use more memory for higher perf, cmd mem use will now increase as
>> the num queues and queue depth increases.
>> 
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>> drivers/vhost/scsi.c | 204 ++++++++++++++++++++++++++++++++-------------------
>> 1 file changed, 127 insertions(+), 77 deletions(-)
>> 
>> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
>> index b22adf0..13311b8 100644
>> --- a/drivers/vhost/scsi.c
>> +++ b/drivers/vhost/scsi.c
>> @@ -52,7 +52,6 @@
>> #define VHOST_SCSI_VERSION  "v0.1"
>> #define VHOST_SCSI_NAMELEN 256
>> #define VHOST_SCSI_MAX_CDB_SIZE 32
>> -#define VHOST_SCSI_DEFAULT_TAGS 256
>> #define VHOST_SCSI_PREALLOC_SGLS 2048
>> #define VHOST_SCSI_PREALLOC_UPAGES 2048
>> #define VHOST_SCSI_PREALLOC_PROT_SGLS 2048
>> @@ -189,6 +188,9 @@ struct vhost_scsi_virtqueue {
>> 	 * Writers must also take dev mutex and flush under it.
>> 	 */
>> 	int inflight_idx;
>> +	struct vhost_scsi_cmd *scsi_cmds;
>> +	struct sbitmap scsi_tags;
>> +	int max_cmds;
>> };
>> 
>> struct vhost_scsi {
>> @@ -324,7 +326,9 @@ static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
>> {
>> 	struct vhost_scsi_cmd *tv_cmd = container_of(se_cmd,
>> 				struct vhost_scsi_cmd, tvc_se_cmd);
>> -	struct se_session *se_sess = tv_cmd->tvc_nexus->tvn_se_sess;
>> +	struct vhost_scsi_virtqueue *svq = container_of(tv_cmd->tvc_vq,
>> +				struct vhost_scsi_virtqueue, vq);
>> +	struct vhost_scsi_inflight *inflight = tv_cmd->inflight;
>> 	int i;
>> 
>> 	if (tv_cmd->tvc_sgl_count) {
>> @@ -336,8 +340,8 @@ static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
>> 			put_page(sg_page(&tv_cmd->tvc_prot_sgl[i]));
>> 	}
>> 
>> -	vhost_scsi_put_inflight(tv_cmd->inflight);
>> -	target_free_tag(se_sess, se_cmd);
>> +	sbitmap_clear_bit(&svq->scsi_tags, se_cmd->map_tag);
>> +	vhost_scsi_put_inflight(inflight);
>> }
>> 
>> static u32 vhost_scsi_sess_get_index(struct se_session *se_sess)
>> @@ -566,13 +570,14 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
>> }
>> 
>> static struct vhost_scsi_cmd *
>> -vhost_scsi_get_tag(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
>> +vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
>> 		   unsigned char *cdb, u64 scsi_tag, u16 lun, u8 task_attr,
>> 		   u32 exp_data_len, int data_direction)
>> {
>> +	struct vhost_scsi_virtqueue *svq = container_of(vq,
>> +					struct vhost_scsi_virtqueue, vq);
>> 	struct vhost_scsi_cmd *cmd;
>> 	struct vhost_scsi_nexus *tv_nexus;
>> -	struct se_session *se_sess;
>> 	struct scatterlist *sg, *prot_sg;
>> 	struct page **pages;
>> 	int tag, cpu;
>> @@ -582,15 +587,14 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
>> 		pr_err("Unable to locate active struct vhost_scsi_nexus\n");
>> 		return ERR_PTR(-EIO);
>> 	}
>> -	se_sess = tv_nexus->tvn_se_sess;
>> 
>> -	tag = sbitmap_queue_get(&se_sess->sess_tag_pool, &cpu);
>> +	tag = sbitmap_get(&svq->scsi_tags, 0, false);
>> 	if (tag < 0) {
>> 		pr_err("Unable to obtain tag for vhost_scsi_cmd\n");
>> 		return ERR_PTR(-ENOMEM);
>> 	}
> 
> 
> After this change, cpu is uninitialized.

I’ve fixed this.

We don’t use the cmd’s map_cpu field anymore, so I have deleted it and the cpu var above.
