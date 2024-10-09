Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B275383A5
	for <target-devel@vger.kernel.org>; Wed,  9 Oct 2024 01:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728437940; cv=none; b=C2Oejuh6e3de3ic1pOB4TSzOq+D0c25bVTc/eivXki+jSJmLugRzYuTL1S/wNQOEWJuH98mOSodx5JZOzcEe6/5L75YEoSbo8vyhw9KLktJQIkDKKZaXIQV3by4LcFQsk2PWp3cLIFxPIWFiF95UzydYPJnjjVSPL3oytyYqoso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728437940; c=relaxed/simple;
	bh=hjDkiw6KPqcrmXGWy+/Z9/loY454CPzA1AkMoFUvK7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBGoVT6Kfww6SsEQo6MINc/O55Ufcebx0SHHOqmWHGq9I70NaUsCIbRU9VETrbEYvAjBQ0xSBGw/7bBodoLxWP7FUnbznhHhv5QHIKmm3tET8B22Q0LY2SFGimDtE+mSnFc91hVR3LgrhEoatbhr6rgm7GHqRqxwsmswpahULEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NoGQHpsr; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NoGQHpsr"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 498Jtcj4017769;
	Wed, 9 Oct 2024 01:38:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=sayu8
	FLGBDLuJqlhBup4DpHN8ZXT0Vx3U02bGsz7N7I=; b=NoGQHpsrUJo6z1Pd0LH2N
	MRcso0MfpHDQGJn8BRC1V5m90GsRW7QGfB5fWYerFmRl7IV/L96FwjDUxALEOYF+
	hwnYvykGeET+rp+Uun29izaMk+8TNGkNDdN/auyJm/eKqKu+2KPbibcAwf9N/ez5
	l+0kPN6T2Un1kDpndyM+8aWavJDEsd2OJilQT3rfInH/gMZmeg9mfwpBhf6mX7tq
	wrCASJWmkZhBUDTPkJ4xd8uHY3DCYvUY17t1kz0fo3gfpAEN8qs8oRaBdf+/GuId
	WC6y1eX5zCNnYsKPN3rY9oBzv5QBQv/AeEtUfXy12dGu/TbpbT6EGP8IkTqu5YSL
	w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42306ef5g2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Oct 2024 01:38:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 498N7Biq011858;
	Wed, 9 Oct 2024 01:38:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 422uwe89b9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Oct 2024 01:38:52 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4991chjK024787;
	Wed, 9 Oct 2024 01:38:52 GMT
Received: from mnc-mac.us.oracle.com (dhcp-10-65-182-164.vpn.oracle.com [10.65.182.164])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 422uwe897c-8;
	Wed, 09 Oct 2024 01:38:52 +0000
From: Mike Christie <michael.christie@oracle.com>
To: stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, pbonzini@redhat.com, target-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 8/8] vhost-scsi: Reduce response iov mem use
Date: Tue,  8 Oct 2024 20:38:38 -0500
Message-ID: <20241009013839.88593-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20241009013839.88593-1-michael.christie@oracle.com>
References: <20241009013839.88593-1-michael.christie@oracle.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-08_24,2024-10-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410090009
X-Proofpoint-GUID: m1KhysPob_f_CVq0Vy44GUMJvNwp9CpX
X-Proofpoint-ORIG-GUID: m1KhysPob_f_CVq0Vy44GUMJvNwp9CpX

We have to save N iov entries to copy the virtio_scsi_cmd_resp struct
back to the guest's buffer. The difficulty is that we can't assume the
virtio_scsi_cmd_resp will be in 1 iov because older virtio specs allowed
you to break it up.

The worst case is that the guest was doing something like breaking up
the virtio_scsi_cmd_resp struct into 108 (the struct is 108 bytes)
byte sized vecs like:

iov[0].iov_base = ((unsigned char *)virtio_scsi_cmd_resp)[0]
iov[0].iov_len = 1
iov[1].iov_base =  ((unsigned char *)virtio_scsi_cmd_resp)[1]
iov[1].iov_len = 1
....
iov[107].iov_base = ((unsigned char *)virtio_scsi_cmd_resp)[107]
iov[1].iov_len = 1

Right now we allocate UIO_MAXIOV vecs which is 1024 and so for a small
device with just 1 queue and 128 commands per queue, we are wasting

1.8 MB = (1024 current entries - 108) * 16 bytes per entry * 128 cmds

The most common case is going to be where the initiator puts the entire
virtio_scsi_cmd_resp in the first iov and does not split it. We've
always done it this way for Linux and the windows driver looks like
it's always done the same. It's highly unlikely anyone has ever split
the response and if they did it might just be where they have the
sense in a second iov but that doesn't seem likely as well.

So to optimize for the common implementation, this has us only
pre-allocate the single iovec. If we do hit the split up response case
this has us allocate the needed iovec when needed.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 82 ++++++++++++++++++++++++++++++++------------
 1 file changed, 60 insertions(+), 22 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 25d59d4ee149..9d49d1577d2a 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -45,6 +45,11 @@
 #define VHOST_SCSI_PREALLOC_SGLS 2048
 #define VHOST_SCSI_PREALLOC_UPAGES 2048
 #define VHOST_SCSI_PREALLOC_PROT_SGLS 2048
+/*
+ * For the legacy descriptor case we allocate an iov per byte in the
+ * virtio_scsi_cmd_resp struct.
+ */
+#define VHOST_SCSI_MAX_RESP_IOVS sizeof(struct virtio_scsi_cmd_resp)
 
 static unsigned int vhost_scsi_inline_sg_cnt = VHOST_SCSI_PREALLOC_SGLS;
 
@@ -106,8 +111,6 @@ struct vhost_scsi_inflight {
 struct vhost_scsi_cmd {
 	/* Descriptor from vhost_get_vq_desc() for virt_queue segment */
 	int tvc_vq_desc;
-	/* virtio-scsi response incoming iovecs */
-	int tvc_in_iovs;
 	/* The number of scatterlists associated with this cmd */
 	u32 tvc_sgl_count;
 	u32 tvc_prot_sgl_count;
@@ -118,8 +121,12 @@ struct vhost_scsi_cmd {
 	struct sg_table table;
 	struct scatterlist *prot_sgl;
 	struct sg_table prot_table;
-	/* Pointer to response header iovec */
-	struct iovec *tvc_resp_iov;
+	/* Fast path response header iovec used when only one vec is needed */
+	struct iovec tvc_resp_iov;
+	/* Number of iovs for response */
+	unsigned int tvc_resp_iovs_cnt;
+	/* Pointer to response header iovecs if more than one is needed */
+	struct iovec *tvc_resp_iovs;
 	/* Pointer to vhost_virtqueue for the cmd */
 	struct vhost_virtqueue *tvc_vq;
 	/* The TCM I/O descriptor that is accessed via container_of() */
@@ -391,6 +398,8 @@ static void vhost_scsi_release_cmd_res(struct se_cmd *se_cmd)
 		sg_free_table_chained(&tv_cmd->prot_table, vs->inline_sg_cnt);
 	}
 
+	if (tv_cmd->tvc_resp_iovs != &tv_cmd->tvc_resp_iov)
+		kfree(tv_cmd->tvc_resp_iovs);
 	sbitmap_clear_bit(&svq->scsi_tags, se_cmd->map_tag);
 	vhost_scsi_put_inflight(inflight);
 }
@@ -638,8 +647,8 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 			       se_cmd->scsi_sense_length);
 		}
 
-		iov_iter_init(&iov_iter, ITER_DEST, cmd->tvc_resp_iov,
-			      cmd->tvc_in_iovs, sizeof(v_rsp));
+		iov_iter_init(&iov_iter, ITER_DEST, cmd->tvc_resp_iovs,
+			      cmd->tvc_resp_iovs_cnt, sizeof(v_rsp));
 		ret = copy_to_iter(&v_rsp, sizeof(v_rsp), &iov_iter);
 		if (likely(ret == sizeof(v_rsp))) {
 			signal = true;
@@ -662,7 +671,6 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, u64 scsi_tag)
 					struct vhost_scsi_virtqueue, vq);
 	struct vhost_scsi_cmd *cmd;
 	struct scatterlist *sgl, *prot_sgl;
-	struct iovec *tvc_resp_iov;
 	int tag;
 
 	tag = sbitmap_get(&svq->scsi_tags);
@@ -674,13 +682,11 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, u64 scsi_tag)
 	cmd = &svq->scsi_cmds[tag];
 	sgl = cmd->sgl;
 	prot_sgl = cmd->prot_sgl;
-	tvc_resp_iov = cmd->tvc_resp_iov;
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->sgl = sgl;
 	cmd->prot_sgl = prot_sgl;
 	cmd->tvc_se_cmd.map_tag = tag;
 	cmd->inflight = vhost_scsi_get_inflight(vq);
-	cmd->tvc_resp_iov = tvc_resp_iov;
 
 	return cmd;
 }
@@ -1121,6 +1127,43 @@ vhost_scsi_get_req(struct vhost_virtqueue *vq, struct vhost_scsi_ctx *vc,
 	return ret;
 }
 
+static int
+vhost_scsi_setup_resp_iovs(struct vhost_scsi_cmd *cmd, struct iovec *in_iovs,
+			   unsigned int in_iovs_cnt)
+{
+	int i, cnt;
+
+	if (!in_iovs_cnt)
+		return 0;
+	/*
+	 * Initiator's normally just put the virtio_scsi_cmd_resp in the first
+	 * iov, but just in case they wedged in some data with it we check for
+	 * greater than or equal to the response struct.
+	 */
+	if (in_iovs[0].iov_len >= sizeof(struct virtio_scsi_cmd_resp)) {
+		cmd->tvc_resp_iovs = &cmd->tvc_resp_iov;
+		cmd->tvc_resp_iovs_cnt = 1;
+	} else {
+		/*
+		 * Legacy descriptor layouts didn't specify that we must put
+		 * the entire response in one iov. Worst case we have a
+		 * iov per byte.
+		 */
+		cnt = min(VHOST_SCSI_MAX_RESP_IOVS, in_iovs_cnt);
+		cmd->tvc_resp_iovs = kcalloc(cnt, sizeof(struct iovec),
+					     GFP_KERNEL);
+		if (!cmd->tvc_resp_iovs)
+			return -ENOMEM;
+
+		cmd->tvc_resp_iovs_cnt = cnt;
+	}
+
+	for (i = 0; i < cmd->tvc_resp_iovs_cnt; i++)
+		cmd->tvc_resp_iovs[i] = in_iovs[i];
+
+	return 0;
+}
+
 static u16 vhost_buf_to_lun(u8 *lun_buf)
 {
 	return ((lun_buf[2] << 8) | lun_buf[3]) & 0x3FFF;
@@ -1138,7 +1181,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 	struct iov_iter in_iter, prot_iter, data_iter;
 	u64 tag;
 	u32 exp_data_len, data_direction;
-	int ret, prot_bytes, i, c = 0;
+	int ret, prot_bytes, c = 0;
 	u16 lun;
 	u8 task_attr;
 	bool t10_pi = vhost_has_feature(vq, VIRTIO_SCSI_F_T10_PI);
@@ -1300,9 +1343,13 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			goto err;
 		}
 		cmd->tvc_vq = vq;
-		for (i = 0; i < vc.in ; i++)
-			cmd->tvc_resp_iov[i] = vq->iov[vc.out + i];
-		cmd->tvc_in_iovs = vc.in;
+
+		ret = vhost_scsi_setup_resp_iovs(cmd, &vq->iov[vc.out], vc.in);
+		if (ret) {
+			vq_err(vq, "Failed to alloc recv iovs\n");
+			vhost_scsi_release_cmd_res(&cmd->tvc_se_cmd);
+			goto err;
+		}
 
 		pr_debug("vhost_scsi got command opcode: %#02x, lun: %d\n",
 			 cdb[0], lun);
@@ -1683,7 +1730,6 @@ static void vhost_scsi_destroy_vq_cmds(struct vhost_virtqueue *vq)
 
 		kfree(tv_cmd->sgl);
 		kfree(tv_cmd->prot_sgl);
-		kfree(tv_cmd->tvc_resp_iov);
 	}
 
 	sbitmap_free(&svq->scsi_tags);
@@ -1732,14 +1778,6 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 			}
 		}
 
-		tv_cmd->tvc_resp_iov = kcalloc(UIO_MAXIOV,
-					       sizeof(struct iovec),
-					       GFP_KERNEL);
-		if (!tv_cmd->tvc_resp_iov) {
-			pr_err("Unable to allocate tv_cmd->tvc_resp_iov\n");
-			goto out;
-		}
-
 		if (vhost_has_feature(vq, VIRTIO_SCSI_F_T10_PI) &&
 		    vs->inline_sg_cnt) {
 			tv_cmd->prot_sgl = kcalloc(vs->inline_sg_cnt,
-- 
2.34.1

