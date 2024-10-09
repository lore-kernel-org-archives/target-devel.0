Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C51208AD
	for <target-devel@vger.kernel.org>; Wed,  9 Oct 2024 01:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728437931; cv=none; b=IIzjebhfBO5vQ/lLPsN/kUH9WDZba98vmb46JaxibCO5x+bjnUnDt8rZ0KnWxDdmUj1noSqjhOv0G7kLUuiW3Uz482wd8lbqpH1jV3lJAFy9kPXhCNTp1/P6zJUfBvAgj2CizkrkUMZUYgLJfg7MeQNo/ERESs4STrn5saTy2rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728437931; c=relaxed/simple;
	bh=hrsgq3gxocyiHRLNaRDJ3sCr/IMNBDwc/bTvD7a2B5A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CSW89av5UMYNHBfNWQdTBAEGjfi/hY4PuDIu2tpX5S2rJnYKV3gGSSlickxyksAsNUl4NiNnB+GnqlZ87jkKtF+p445mCfq4m+J5aE/XpAUk3UwI1/vx09Zvz09GvjM+tkqSsRlAtnytZ09ED35n55cW62V75AFdMBgQ6w6Scik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PeLhhuPS; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PeLhhuPS"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 498JtZ66022304;
	Wed, 9 Oct 2024 01:38:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2023-11-20; bh=bD+hepKSLWWk33AD4ZUihFuX7m9CX
	zPlviQ1hmcVXTw=; b=PeLhhuPSJKSDf6O0BV3YR9DQObzQ7RoIq9xWfEpNfiZgU
	YLrkO5grNt5d12y+7BjaBIgc4lSdmqhWqf9Rff9v5UPW0ZdRsg+7LrJkBnu56gzH
	aDcKnvVme8g8fj/I3Gd5uAEPdXO1hBBe6ICQPnwynkTIMmthQ0RbauWRiLnoZr3t
	2wANdJsReuJqwXuV0gv8i9PFcSqSA8+IhyjaqDB5SweXd2BaCheG9PmrRQyvKEi2
	d3zIeNHw0SdFMZYQl7eKDH6gcJH462VkDbIQ36wecY1brnLcq1GiVtvQbsNQGVSF
	hqwz5w/4CQg5XaWfJ0etjF7CimQ6LE/46+Auu/puQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 423034qcnb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Oct 2024 01:38:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 498NQoTV011392;
	Wed, 9 Oct 2024 01:38:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 422uwe8989-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Oct 2024 01:38:43 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4991chj6024787;
	Wed, 9 Oct 2024 01:38:43 GMT
Received: from mnc-mac.us.oracle.com (dhcp-10-65-182-164.vpn.oracle.com [10.65.182.164])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 422uwe897c-1;
	Wed, 09 Oct 2024 01:38:43 +0000
From: Mike Christie <michael.christie@oracle.com>
To: stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, pbonzini@redhat.com, target-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/8] vhost-scsi: Reduce mem use by moving upages to per queue
Date: Tue,  8 Oct 2024 20:38:31 -0500
Message-ID: <20241009013839.88593-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.44.0
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
X-Proofpoint-GUID: GNGgdsyJg7-tDbGf2pn_KUAPLuJTST6J
X-Proofpoint-ORIG-GUID: GNGgdsyJg7-tDbGf2pn_KUAPLuJTST6J

Each worker thread can process 1 command at a time so there's no need to
allocate a upages array per cmd. This patch moves it to per queue. Even a
small device with 128 cmds and 1 queue this brings mem use for the array
from

2 MB = 8 bytes per page pointer * 2048 pointers * 128 cmds

to

16K = 8 bytes per pointer * 2048 * 1 queue

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 006ffacf1c56..0cfa56d08450 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -83,7 +83,6 @@ struct vhost_scsi_cmd {
 	/* Pointer to the SGL formatted memory from virtio-scsi */
 	struct scatterlist *tvc_sgl;
 	struct scatterlist *tvc_prot_sgl;
-	struct page **tvc_upages;
 	/* Pointer to response header iovec */
 	struct iovec *tvc_resp_iov;
 	/* Pointer to vhost_scsi for our device */
@@ -187,6 +186,7 @@ struct vhost_scsi_virtqueue {
 	struct vhost_scsi_cmd *scsi_cmds;
 	struct sbitmap scsi_tags;
 	int max_cmds;
+	struct page **upages;
 
 	struct vhost_work completion_work;
 	struct llist_head completion_list;
@@ -619,7 +619,6 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	struct vhost_scsi_nexus *tv_nexus;
 	struct scatterlist *sg, *prot_sg;
 	struct iovec *tvc_resp_iov;
-	struct page **pages;
 	int tag;
 
 	tv_nexus = tpg->tpg_nexus;
@@ -637,12 +636,10 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	cmd = &svq->scsi_cmds[tag];
 	sg = cmd->tvc_sgl;
 	prot_sg = cmd->tvc_prot_sgl;
-	pages = cmd->tvc_upages;
 	tvc_resp_iov = cmd->tvc_resp_iov;
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->tvc_sgl = sg;
 	cmd->tvc_prot_sgl = prot_sg;
-	cmd->tvc_upages = pages;
 	cmd->tvc_se_cmd.map_tag = tag;
 	cmd->tvc_tag = scsi_tag;
 	cmd->tvc_lun = lun;
@@ -669,7 +666,9 @@ vhost_scsi_map_to_sgl(struct vhost_scsi_cmd *cmd,
 		      struct scatterlist *sgl,
 		      bool is_prot)
 {
-	struct page **pages = cmd->tvc_upages;
+	struct vhost_scsi_virtqueue *svq = container_of(cmd->tvc_vq,
+					struct vhost_scsi_virtqueue, vq);
+	struct page **pages = svq->upages;
 	struct scatterlist *sg = sgl;
 	ssize_t bytes, mapped_bytes;
 	size_t offset, mapped_offset;
@@ -1595,11 +1594,11 @@ static void vhost_scsi_destroy_vq_cmds(struct vhost_virtqueue *vq)
 
 		kfree(tv_cmd->tvc_sgl);
 		kfree(tv_cmd->tvc_prot_sgl);
-		kfree(tv_cmd->tvc_upages);
 		kfree(tv_cmd->tvc_resp_iov);
 	}
 
 	sbitmap_free(&svq->scsi_tags);
+	kfree(svq->upages);
 	kfree(svq->scsi_cmds);
 	svq->scsi_cmds = NULL;
 }
@@ -1625,6 +1624,11 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 		return -ENOMEM;
 	}
 
+	svq->upages = kcalloc(VHOST_SCSI_PREALLOC_UPAGES, sizeof(struct page *),
+			      GFP_KERNEL);
+	if (!svq->upages)
+		goto out;
+
 	for (i = 0; i < max_cmds; i++) {
 		tv_cmd = &svq->scsi_cmds[i];
 
@@ -1636,14 +1640,6 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 			goto out;
 		}
 
-		tv_cmd->tvc_upages = kcalloc(VHOST_SCSI_PREALLOC_UPAGES,
-					     sizeof(struct page *),
-					     GFP_KERNEL);
-		if (!tv_cmd->tvc_upages) {
-			pr_err("Unable to allocate tv_cmd->tvc_upages\n");
-			goto out;
-		}
-
 		tv_cmd->tvc_resp_iov = kcalloc(UIO_MAXIOV,
 					       sizeof(struct iovec),
 					       GFP_KERNEL);
-- 
2.34.1

