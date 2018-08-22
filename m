From: Greg Edwards <gedwards@ddn.com>
Date: Wed, 22 Aug 2018 16:52:03 +0000
Subject: Re: [PATCH] target/iblock: split T10 PI SGL across command bios
Message-Id: <20180822165203.GA10808@psuche>
List-Id: <target-devel.vger.kernel.org>
References: <20180808193140.1463-1-gedwards@ddn.com>
In-Reply-To: <20180808193140.1463-1-gedwards@ddn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Tue, Aug 21, 2018 at 04:13:57PM -0600, Greg Edwards wrote:
> On Tue, Aug 21, 2018 at 04:07:08PM -0500, Mike Christie wrote:
>> On 08/08/2018 02:31 PM, Greg Edwards wrote:
>>> When T10 PI is enabled on a backing device for the iblock backstore, the
>>> PI SGL for the entire command is attached to the first bio only.  This
>>> works fine if the command is covered by a single bio, but results in
>>> integrity verification errors for the other bios in a multi-bio command.
>>>
>>
>> Did you hit this with a older distro kernel?
>>
>> It looks like iblock_get_bio will alloc a bio that has enough vecs for
>> the entire cmd (bi_max_vecs will equal sgl_nents). So it is not clear to
>> me how does the bio_add_page call ever return a value other than
>> sg->length, and we end up doing another iblock_get_bio call?
>
> I hit it with the tip of Linus' tree, but it depended on some other
> in-flight changes.  Those other changes are now in Linus' tree for 4.19,
> with the exception of [1].
>
> Without [1], when doing a large read I/O through vhost + iblock to a T10
> PI enabled device (I used scsi_debug), you first hit the vhost
> VHOST_SCSI_PREALLOC_PROT_SGLS limitation noted in [1].
>
> Once the limitation on I/O size is no longer gated by
> VHOST_SCSI_PREALLOC_PROT_SGLS, the next issue I hit is the one this
> patch addresses.  I should have been more precise in my commit message.
> The failure is actually a bio_integrity_alloc() failure to allocate the
> bip_vec when cmd->t_prot_nents exceeds 256 (BIO_MAX_PAGES), which
> results in the following failure on the host:
>
> [   53.780723] Unable to allocate bio_integrity_payload

Hi Mike,

Hold off on looking at this patch for the moment.  I took another look
at it this morning, and I think I've found a vhost-scsi bug that is
contributing to this (and changing VHOST_SCSI_PREALLOC_PROT_SGLS just
papers around it).  It looks like vhost-scsi should be capping the
prot_iter in vhost_scsi_handle_vq(), something like:


diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 76f8d649147b..1302869c506b 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -973,6 +973,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			if (prot_bytes) {
 				exp_data_len -= prot_bytes;
 				prot_iter = data_iter;
+				iov_iter_truncate(&prot_iter, prot_bytes);
 				iov_iter_advance(&data_iter, prot_bytes);
 			}
 			tag = vhost64_to_cpu(vq, v_req_pi.tag);


Greg
