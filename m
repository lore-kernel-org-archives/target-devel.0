Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFB62B2D7
	for <target-devel@vger.kernel.org>; Wed,  9 Oct 2024 01:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728437939; cv=none; b=Vhjo6yqNyNzDZS8ryxo9n+gQB8NsSsKMjWhQPlTKwdumT/vrcao+ib/eI/jfQ4P3aSo6D+BoIyDpjiFy5U+M3ZvnKwGeRn9ffqamved81Rat5HAbHcnRpHLTXpUsziNvjt7nw2wjM+QRg/HHojGttZUs2HwdD77zv2021Glbn9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728437939; c=relaxed/simple;
	bh=d1/xKNriGjTBf7mIAvSWBijBhmpMHrDzj+x/ckTvCbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ak53Nm+z6GMGTC6+sde+x94IR9afQietDRZpk/e8VRvydw55DqANnfLRdkT4ikGVDxaTkv1BnmPH7z2ulBDhTaMT4ZsX2ZOl3/s2TG9yExLtjtNKnZy3/DZvYolbZRhBThmphca2xDHMP3wpxqqxsBXuTV3QqYFZda9FAenmtD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jloili5P; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jloili5P"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 498JtcSp003606;
	Wed, 9 Oct 2024 01:38:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=7EER9
	ZjVxn0cYFy9tOPR1omcZzmu3ecSnUZeNJIWdLc=; b=jloili5PJfUChZ5aEx50F
	3yPFvbE57fh1A2vwbrlu6RTY95W3nBIQJfyDZKhSQdRayclY9RSzug8fnMCECJuh
	RMquQC95seQafJkVTFg3zQaQTQOfyt9k1+5pheKpxeditV2faxtr88Ea9+4V5RGF
	j706Ov5RSOMpCZSsb0U/ptFgD/9GpnU8p7XCitAx3Tb5Thbx0MeK8UfmvU+o0nXc
	tGtXPefDcOFjPbTNQEggTZk/yjbjQ8uBHT8o4biZcK0N5x5/dmVseuEB0Gjywl6N
	ty9vkGWS7t0VxcX9xCOBAN2jJg6BUOjPVhqyFen0W52cMYDDsJj9zYJih+OOKhbv
	A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 423063q421-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Oct 2024 01:38:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 498NKn8J011158;
	Wed, 9 Oct 2024 01:38:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 422uwe89aj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Oct 2024 01:38:51 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4991chjG024787;
	Wed, 9 Oct 2024 01:38:50 GMT
Received: from mnc-mac.us.oracle.com (dhcp-10-65-182-164.vpn.oracle.com [10.65.182.164])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 422uwe897c-6;
	Wed, 09 Oct 2024 01:38:50 +0000
From: Mike Christie <michael.christie@oracle.com>
To: stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, pbonzini@redhat.com, target-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 6/8] vhost-scsi: Stop duplicating se_cmd fields
Date: Tue,  8 Oct 2024 20:38:36 -0500
Message-ID: <20241009013839.88593-6-michael.christie@oracle.com>
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
X-Proofpoint-ORIG-GUID: 7vCJ3Uu5_KOlCk8sRpFy0GttsUSdoYw_
X-Proofpoint-GUID: 7vCJ3Uu5_KOlCk8sRpFy0GttsUSdoYw_

When setting up the command we will initially set values like lun and
data direction on the vhost scsi command. We then pass them to LIO which
stores them again on the LIO se_cmd. The se_cmd is actually stored in
the vhost scsi command so we are storing these values twice on the same
struct. So this patch has stop duplicating the storing of SCSI values
like lun, data dir, data len, cdb, etc on the vhost scsi command and
just pass them to LIO which will store them on the se_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 95 +++++++++++++++++---------------------------
 1 file changed, 36 insertions(+), 59 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 635ca372f874..cb317bfada20 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -106,21 +106,11 @@ struct vhost_scsi_inflight {
 struct vhost_scsi_cmd {
 	/* Descriptor from vhost_get_vq_desc() for virt_queue segment */
 	int tvc_vq_desc;
-	/* virtio-scsi initiator task attribute */
-	int tvc_task_attr;
 	/* virtio-scsi response incoming iovecs */
 	int tvc_in_iovs;
-	/* virtio-scsi initiator data direction */
-	enum dma_data_direction tvc_data_direction;
-	/* Expected data transfer length from virtio-scsi header */
-	u32 tvc_exp_data_len;
-	/* The Tag from include/linux/virtio_scsi.h:struct virtio_scsi_cmd_req */
-	u64 tvc_tag;
 	/* The number of scatterlists associated with this cmd */
 	u32 tvc_sgl_count;
 	u32 tvc_prot_sgl_count;
-	/* Saved unpacked SCSI LUN for vhost_scsi_target_queue_cmd() */
-	u32 tvc_lun;
 	u32 copied_iov:1;
 	const void *saved_iter_addr;
 	struct iov_iter saved_iter;
@@ -130,16 +120,10 @@ struct vhost_scsi_cmd {
 	struct sg_table prot_table;
 	/* Pointer to response header iovec */
 	struct iovec *tvc_resp_iov;
-	/* Pointer to vhost_scsi for our device */
-	struct vhost_scsi *tvc_vhost;
 	/* Pointer to vhost_virtqueue for the cmd */
 	struct vhost_virtqueue *tvc_vq;
-	/* Pointer to vhost nexus memory */
-	struct vhost_scsi_nexus *tvc_nexus;
 	/* The TCM I/O descriptor that is accessed via container_of() */
 	struct se_cmd tvc_se_cmd;
-	/* Copy of the incoming SCSI command descriptor block (CDB) */
-	unsigned char tvc_cdb[VHOST_SCSI_MAX_CDB_SIZE];
 	/* Sense buffer that will be mapped into outgoing status */
 	unsigned char tvc_sense_buf[TRANSPORT_SENSE_BUFFER];
 	/* Completed commands list, serviced from vhost worker thread */
@@ -375,9 +359,9 @@ static void vhost_scsi_release_cmd_res(struct se_cmd *se_cmd)
 {
 	struct vhost_scsi_cmd *tv_cmd = container_of(se_cmd,
 				struct vhost_scsi_cmd, tvc_se_cmd);
-	struct vhost_scsi *vs = tv_cmd->tvc_vhost;
 	struct vhost_scsi_virtqueue *svq = container_of(tv_cmd->tvc_vq,
 				struct vhost_scsi_virtqueue, vq);
+	struct vhost_scsi *vs = svq->vs;
 	struct vhost_scsi_inflight *inflight = tv_cmd->inflight;
 	struct scatterlist *sg;
 	struct page *page;
@@ -671,24 +655,15 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 }
 
 static struct vhost_scsi_cmd *
-vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
-		   unsigned char *cdb, u64 scsi_tag, u16 lun, u8 task_attr,
-		   u32 exp_data_len, int data_direction)
+vhost_scsi_get_cmd(struct vhost_virtqueue *vq, u64 scsi_tag)
 {
 	struct vhost_scsi_virtqueue *svq = container_of(vq,
 					struct vhost_scsi_virtqueue, vq);
 	struct vhost_scsi_cmd *cmd;
-	struct vhost_scsi_nexus *tv_nexus;
 	struct scatterlist *sgl, *prot_sgl;
 	struct iovec *tvc_resp_iov;
 	int tag;
 
-	tv_nexus = tpg->tpg_nexus;
-	if (!tv_nexus) {
-		pr_err("Unable to locate active struct vhost_scsi_nexus\n");
-		return ERR_PTR(-EIO);
-	}
-
 	tag = sbitmap_get(&svq->scsi_tags);
 	if (tag < 0) {
 		pr_warn_once("Guest sent too many cmds. Returning TASK_SET_FULL.\n");
@@ -703,17 +678,9 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	cmd->sgl = sgl;
 	cmd->prot_sgl = prot_sgl;
 	cmd->tvc_se_cmd.map_tag = tag;
-	cmd->tvc_tag = scsi_tag;
-	cmd->tvc_lun = lun;
-	cmd->tvc_task_attr = task_attr;
-	cmd->tvc_exp_data_len = exp_data_len;
-	cmd->tvc_data_direction = data_direction;
-	cmd->tvc_nexus = tv_nexus;
 	cmd->inflight = vhost_scsi_get_inflight(vq);
 	cmd->tvc_resp_iov = tvc_resp_iov;
 
-	memcpy(cmd->tvc_cdb, cdb, VHOST_SCSI_MAX_CDB_SIZE);
-
 	return cmd;
 }
 
@@ -831,7 +798,8 @@ vhost_scsi_calc_sgls(struct iov_iter *iter, size_t bytes, int max_sgls)
 
 static int
 vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
-			   struct sg_table *sg_table, int sg_count)
+			   struct sg_table *sg_table, int sg_count,
+			   int data_dir)
 {
 	size_t len = iov_iter_count(iter);
 	unsigned int nbytes = 0;
@@ -839,7 +807,7 @@ vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
 	struct page *page;
 	int i, ret;
 
-	if (cmd->tvc_data_direction == DMA_FROM_DEVICE) {
+	if (data_dir == DMA_FROM_DEVICE) {
 		cmd->saved_iter_addr = dup_iter(&cmd->saved_iter, iter,
 						GFP_KERNEL);
 		if (!cmd->saved_iter_addr)
@@ -856,7 +824,7 @@ vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
 		nbytes = min_t(unsigned int, PAGE_SIZE, len);
 		sg_set_page(sg, page, nbytes, 0);
 
-		if (cmd->tvc_data_direction == DMA_TO_DEVICE &&
+		if (data_dir == DMA_TO_DEVICE &&
 		    copy_page_from_iter(page, 0, nbytes, iter) != nbytes) {
 			ret = -EFAULT;
 			goto err;
@@ -901,11 +869,10 @@ vhost_scsi_map_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
 }
 
 static int
-vhost_scsi_mapal(struct vhost_scsi_cmd *cmd,
+vhost_scsi_mapal(struct vhost_scsi *vs, struct vhost_scsi_cmd *cmd,
 		 size_t prot_bytes, struct iov_iter *prot_iter,
-		 size_t data_bytes, struct iov_iter *data_iter)
+		 size_t data_bytes, struct iov_iter *data_iter, int data_dir)
 {
-	struct vhost_scsi *vs = cmd->tvc_vhost;
 	int sgl_count, ret;
 
 	if (prot_bytes) {
@@ -951,7 +918,7 @@ vhost_scsi_mapal(struct vhost_scsi_cmd *cmd,
 					cmd->tvc_sgl_count, false);
 	if (ret == -EINVAL)
 		ret = vhost_scsi_copy_iov_to_sgl(cmd, data_iter, &cmd->table,
-						 cmd->tvc_sgl_count);
+						 cmd->tvc_sgl_count, data_dir);
 	if (ret < 0) {
 		sg_free_table_chained(&cmd->table, vs->inline_sg_cnt);
 		cmd->tvc_sgl_count = 0;
@@ -977,10 +944,13 @@ static int vhost_scsi_to_tcm_attr(int attr)
 	return TCM_SIMPLE_TAG;
 }
 
-static void vhost_scsi_target_queue_cmd(struct vhost_scsi_cmd *cmd)
+static void vhost_scsi_target_queue_cmd(struct vhost_scsi_nexus *nexus,
+					struct vhost_scsi_cmd *cmd,
+					unsigned char *cdb, u16 lun,
+					int task_attr, int data_dir,
+					u32 exp_data_len)
 {
 	struct se_cmd *se_cmd = &cmd->tvc_se_cmd;
-	struct vhost_scsi_nexus *tv_nexus;
 	struct scatterlist *sg_ptr, *sg_prot_ptr = NULL;
 
 	/* FIXME: BIDI operation */
@@ -994,15 +964,13 @@ static void vhost_scsi_target_queue_cmd(struct vhost_scsi_cmd *cmd)
 	} else {
 		sg_ptr = NULL;
 	}
-	tv_nexus = cmd->tvc_nexus;
 
 	se_cmd->tag = 0;
-	target_init_cmd(se_cmd, tv_nexus->tvn_se_sess, &cmd->tvc_sense_buf[0],
-			cmd->tvc_lun, cmd->tvc_exp_data_len,
-			vhost_scsi_to_tcm_attr(cmd->tvc_task_attr),
-			cmd->tvc_data_direction, TARGET_SCF_ACK_KREF);
+	target_init_cmd(se_cmd, nexus->tvn_se_sess, &cmd->tvc_sense_buf[0],
+			lun, exp_data_len, vhost_scsi_to_tcm_attr(task_attr),
+			data_dir, TARGET_SCF_ACK_KREF);
 
-	if (target_submit_prep(se_cmd, cmd->tvc_cdb, sg_ptr,
+	if (target_submit_prep(se_cmd, cdb, sg_ptr,
 			       cmd->tvc_sgl_count, NULL, 0, sg_prot_ptr,
 			       cmd->tvc_prot_sgl_count, GFP_KERNEL))
 		return;
@@ -1156,6 +1124,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 	struct vhost_scsi_tpg **vs_tpg, *tpg;
 	struct virtio_scsi_cmd_req v_req;
 	struct virtio_scsi_cmd_req_pi v_req_pi;
+	struct vhost_scsi_nexus *nexus;
 	struct vhost_scsi_ctx vc;
 	struct vhost_scsi_cmd *cmd;
 	struct iov_iter in_iter, prot_iter, data_iter;
@@ -1165,7 +1134,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 	u16 lun;
 	u8 task_attr;
 	bool t10_pi = vhost_has_feature(vq, VIRTIO_SCSI_F_T10_PI);
-	void *cdb;
+	u8 *cdb;
 
 	mutex_lock(&vq->mutex);
 	/*
@@ -1308,28 +1277,34 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 				scsi_command_size(cdb), VHOST_SCSI_MAX_CDB_SIZE);
 				goto err;
 		}
-		cmd = vhost_scsi_get_cmd(vq, tpg, cdb, tag, lun, task_attr,
-					 exp_data_len + prot_bytes,
-					 data_direction);
+
+		nexus = tpg->tpg_nexus;
+		if (!nexus) {
+			vq_err(vq, "Unable to locate active struct vhost_scsi_nexus\n");
+			ret = -EIO;
+			goto err;
+		}
+
+		cmd = vhost_scsi_get_cmd(vq, tag);
 		if (IS_ERR(cmd)) {
 			ret = PTR_ERR(cmd);
 			vq_err(vq, "vhost_scsi_get_tag failed %dd\n", ret);
 			goto err;
 		}
-		cmd->tvc_vhost = vs;
 		cmd->tvc_vq = vq;
 		for (i = 0; i < vc.in ; i++)
 			cmd->tvc_resp_iov[i] = vq->iov[vc.out + i];
 		cmd->tvc_in_iovs = vc.in;
 
 		pr_debug("vhost_scsi got command opcode: %#02x, lun: %d\n",
-			 cmd->tvc_cdb[0], cmd->tvc_lun);
+			 cdb[0], lun);
 		pr_debug("cmd: %p exp_data_len: %d, prot_bytes: %d data_direction:"
 			 " %d\n", cmd, exp_data_len, prot_bytes, data_direction);
 
 		if (data_direction != DMA_NONE) {
-			ret = vhost_scsi_mapal(cmd, prot_bytes, &prot_iter,
-					       exp_data_len, &data_iter);
+			ret = vhost_scsi_mapal(vs, cmd, prot_bytes, &prot_iter,
+					       exp_data_len, &data_iter,
+					       data_direction);
 			if (unlikely(ret)) {
 				vq_err(vq, "Failed to map iov to sgl\n");
 				vhost_scsi_release_cmd_res(&cmd->tvc_se_cmd);
@@ -1342,7 +1317,9 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		 * vhost_scsi_queue_data_in() and vhost_scsi_queue_status()
 		 */
 		cmd->tvc_vq_desc = vc.head;
-		vhost_scsi_target_queue_cmd(cmd);
+		vhost_scsi_target_queue_cmd(nexus, cmd, cdb, lun, task_attr,
+					    data_direction,
+					    exp_data_len + prot_bytes);
 		ret = 0;
 err:
 		/*
-- 
2.34.1

