Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BF72AEFB
	for <target-devel@vger.kernel.org>; Wed,  9 Oct 2024 01:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728437935; cv=none; b=morMqbDLzVePSfBWtp7P0o51ISnoUctNAQ8eER74lwXd3V3xyR7GTwXY8DOqv8eboUV8K3RN+BxnnJaETHg/GgWx3qszzU/sy41fKQPqNTcJh23nzNSCJMQejDvz8c+0Gv+X90BKsHVB+8BZC7M3q2UmHeSLIWTgmfppMIs1THs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728437935; c=relaxed/simple;
	bh=RBsNWwyxFBmUuCFUXtxIzFGivg0Xs3xGqbcOY98LJfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nt8eSQ1Ci5cUaUFkIb3TO6i8EAyxJmb5jnHtkKkKW60Oq0ivAtSjex0qWFfIKwO2qRredymnK9mw2jCZGJB7JoGCnPfViJT3jnpToVsioCpEeM/IUfNOEnF3vFFE6eX2hagQaNgv14mqbkHJnf5EiXgwrhvkflbjD8S4pyqlgH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EarbOoYv; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EarbOoYv"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 498JtZkL012612;
	Wed, 9 Oct 2024 01:38:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=fibvZ
	/3CnJXnFyjkR5cI8Xjgq9hUnzd4UWZ+8RZ4pgo=; b=EarbOoYvBWZeNDJA04FXY
	UYGZR80+raO92MCwHBjaDB0DLr+G3nGOw5SEnZYJRO3RXNMBQ5I3rL7JDWVJZi6Y
	Q9ihvfnxZsTavPprxMfxqfPtr5/YL/HCu6LRB2hNYcMlMkm6o7gd5CF+egOrxSjK
	zvYeW7sw2L693ZPdycv2hGSfR52QeE/x04yngHNKC+GNuvcQ9XrrHSgAmHWKbnXN
	hflLInZ9hfNvTvJ3OBfcIt2H3Cd/oLdaeS7GsOGptvMZnhz+f/p/o97wu2ncu9OR
	kGzvazXcMIX88i/VyRayj2koMPpKE/oo9RFbHkXreGpPLiCiNf7JMc2PYYACas+2
	Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42300dy70v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Oct 2024 01:38:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 498NHTxB011460;
	Wed, 9 Oct 2024 01:38:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 422uwe899w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Oct 2024 01:38:49 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4991chjC024787;
	Wed, 9 Oct 2024 01:38:48 GMT
Received: from mnc-mac.us.oracle.com (dhcp-10-65-182-164.vpn.oracle.com [10.65.182.164])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 422uwe897c-4;
	Wed, 09 Oct 2024 01:38:48 +0000
From: Mike Christie <michael.christie@oracle.com>
To: stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, pbonzini@redhat.com, target-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 4/8] vhost-scsi: Return queue full for page alloc failures during copy
Date: Tue,  8 Oct 2024 20:38:34 -0500
Message-ID: <20241009013839.88593-4-michael.christie@oracle.com>
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
X-Proofpoint-GUID: L5JhH28T8vSl8czhi0ArkUtPLiA8QVQP
X-Proofpoint-ORIG-GUID: L5JhH28T8vSl8czhi0ArkUtPLiA8QVQP

This has us return queue full if we can't allocate a page during the
copy operation so the initiator can retry.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 415fd3be17b9..095687622497 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -756,7 +756,7 @@ vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
 	size_t len = iov_iter_count(iter);
 	unsigned int nbytes = 0;
 	struct page *page;
-	int i;
+	int i, ret;
 
 	if (cmd->tvc_data_direction == DMA_FROM_DEVICE) {
 		cmd->saved_iter_addr = dup_iter(&cmd->saved_iter, iter,
@@ -769,6 +769,7 @@ vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
 		page = alloc_page(GFP_KERNEL);
 		if (!page) {
 			i--;
+			ret = -ENOMEM;
 			goto err;
 		}
 
@@ -776,8 +777,10 @@ vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
 		sg_set_page(&sg[i], page, nbytes, 0);
 
 		if (cmd->tvc_data_direction == DMA_TO_DEVICE &&
-		    copy_page_from_iter(page, 0, nbytes, iter) != nbytes)
+		    copy_page_from_iter(page, 0, nbytes, iter) != nbytes) {
+			ret = -EFAULT;
 			goto err;
+		}
 
 		len -= nbytes;
 	}
@@ -792,7 +795,7 @@ vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
 	for (; i >= 0; i--)
 		__free_page(sg_page(&sg[i]));
 	kfree(cmd->saved_iter_addr);
-	return -ENOMEM;
+	return ret;
 }
 
 static int
@@ -1246,9 +1249,9 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			 " %d\n", cmd, exp_data_len, prot_bytes, data_direction);
 
 		if (data_direction != DMA_NONE) {
-			if (unlikely(vhost_scsi_mapal(cmd, prot_bytes,
-						      &prot_iter, exp_data_len,
-						      &data_iter))) {
+			ret = vhost_scsi_mapal(cmd, prot_bytes, &prot_iter,
+					       exp_data_len, &data_iter);
+			if (unlikely(ret)) {
 				vq_err(vq, "Failed to map iov to sgl\n");
 				vhost_scsi_release_cmd_res(&cmd->tvc_se_cmd);
 				goto err;
-- 
2.34.1

