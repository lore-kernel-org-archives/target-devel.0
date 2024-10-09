Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536312BD1D
	for <target-devel@vger.kernel.org>; Wed,  9 Oct 2024 01:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728437939; cv=none; b=TXo6z4p+G3g3unSGK/5V3JNlVshDo8D5oTZkHB1Bji2CgiwaR2fiLjymKq65wjfvLr8Bg979c9n/j92E4ezgQUQVxKoxw85eR9ItglABBqCmfHn2/pDuFR1/JZd0sfG2DNgKZTQieUNERYs7haj3DDKs/i+RqBwUvZplOuCXWZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728437939; c=relaxed/simple;
	bh=tTklKKBh/ofWjnyLLuU9VHRql7Xi3mSH1Du1pVxFXX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fpS7+N6nILersR/r+mJB1nFGjFyvhPODYQ12Yrnp8NiLCOn6rOl/dNUcLiOBOF0tg+WrVfFNwYBwcWZXc7tRQiXlt9Wzqn1NV9LGB3Dy7VNYtgl6Ctl/CWKOwt9HRheSQcgkG2szUgqRKuaBKqKQLovq3A+B0/PNJJmy3ZgPnjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=n7wG8pe4; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n7wG8pe4"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 498JtbsK026074;
	Wed, 9 Oct 2024 01:38:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=tFzDx
	HtjosrnsFwyQJkvvlTdUikiNAjZpGNzlL4Kngo=; b=n7wG8pe49rLGtmTN4xojC
	dG8aEdqzJUfYFqvL87AhcG5IHQ8WgKqXUeEGC0IQQ1JtBbRuA9KczXvMb5uIArF/
	mjcW0xeeVZCNIB8vF3aE+2u9sqgVbCrMBobF13pdYxNj97oXiL9sygiOlbGb8b26
	SPHBK2j4vQMYiBjUEHGVDvYYhym0CzKsPP2YnQl3XwMzTf8IThQRuyeFMQ1YpXeR
	89Lzop4eBHP9UsjCu0qUIhMXv2qGsm1CY+izoxlY1kuQPyBpPs91J3UfK4+E0K4H
	R42PQpeqYSGz5eIaiktZEkOqQPh2hj6Ubj8/exx1QILRSlV+gIRheHCSeEsA8WTb
	Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42302pf183-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Oct 2024 01:38:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 498MrIJV011868;
	Wed, 9 Oct 2024 01:38:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 422uwe89as-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Oct 2024 01:38:51 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4991chjI024787;
	Wed, 9 Oct 2024 01:38:51 GMT
Received: from mnc-mac.us.oracle.com (dhcp-10-65-182-164.vpn.oracle.com [10.65.182.164])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 422uwe897c-7;
	Wed, 09 Oct 2024 01:38:51 +0000
From: Mike Christie <michael.christie@oracle.com>
To: stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, pbonzini@redhat.com, target-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 7/8] vhost-scsi: Allocate iov_iter used for unaligned copies when needed
Date: Tue,  8 Oct 2024 20:38:37 -0500
Message-ID: <20241009013839.88593-7-michael.christie@oracle.com>
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
X-Proofpoint-ORIG-GUID: 1MfCj2kJH6HjQlasyxCwDbGjdu4qDlEv
X-Proofpoint-GUID: 1MfCj2kJH6HjQlasyxCwDbGjdu4qDlEv

It's extremely rare that we get unaligned requests that need to drop
down to the data copy code path. However, the iov_iter is almost 5% of
the mem used for the vhost_scsi_cmd. This patch has us allocate the
iov_iter only when needed since it's not a perf path that uses the
struct. This along with the patches that removed the duplicated fields on
the vhost_scsd_cmd allow us to reduce mem use by 1 MB in mid size setups
where we have 16 virtqueues and are doing 1024 cmds per queue.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index cb317bfada20..25d59d4ee149 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -112,8 +112,8 @@ struct vhost_scsi_cmd {
 	u32 tvc_sgl_count;
 	u32 tvc_prot_sgl_count;
 	u32 copied_iov:1;
-	const void *saved_iter_addr;
-	struct iov_iter saved_iter;
+	const void *read_iov;
+	struct iov_iter *read_iter;
 	struct scatterlist *sgl;
 	struct sg_table table;
 	struct scatterlist *prot_sgl;
@@ -378,7 +378,8 @@ static void vhost_scsi_release_cmd_res(struct se_cmd *se_cmd)
 			else
 				put_page(page);
 		}
-		kfree(tv_cmd->saved_iter_addr);
+		kfree(tv_cmd->read_iter);
+		kfree(tv_cmd->read_iov);
 		sg_free_table_chained(&tv_cmd->table, vs->inline_sg_cnt);
 	}
 	if (tv_cmd->tvc_prot_sgl_count) {
@@ -576,7 +577,7 @@ static void vhost_scsi_evt_work(struct vhost_work *work)
 
 static int vhost_scsi_copy_sgl_to_iov(struct vhost_scsi_cmd *cmd)
 {
-	struct iov_iter *iter = &cmd->saved_iter;
+	struct iov_iter *iter = cmd->read_iter;
 	struct scatterlist *sg;
 	struct page *page;
 	size_t len;
@@ -624,7 +625,7 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 			cmd, se_cmd->residual_count, se_cmd->scsi_status);
 		memset(&v_rsp, 0, sizeof(v_rsp));
 
-		if (cmd->saved_iter_addr && vhost_scsi_copy_sgl_to_iov(cmd)) {
+		if (cmd->read_iter && vhost_scsi_copy_sgl_to_iov(cmd)) {
 			v_rsp.response = VIRTIO_SCSI_S_BAD_TARGET;
 		} else {
 			v_rsp.resid = cpu_to_vhost32(cmd->tvc_vq,
@@ -808,10 +809,15 @@ vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
 	int i, ret;
 
 	if (data_dir == DMA_FROM_DEVICE) {
-		cmd->saved_iter_addr = dup_iter(&cmd->saved_iter, iter,
-						GFP_KERNEL);
-		if (!cmd->saved_iter_addr)
+		cmd->read_iter = kzalloc(sizeof(*cmd->read_iter), GFP_KERNEL);
+		if (!cmd->read_iter)
 			return -ENOMEM;
+
+		cmd->read_iov = dup_iter(cmd->read_iter, iter, GFP_KERNEL);
+		if (!cmd->read_iov) {
+			ret = -ENOMEM;
+			goto free_iter;
+		}
 	}
 
 	for_each_sgtable_sg(sg_table, sg, i) {
@@ -845,7 +851,9 @@ vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
 		if (page)
 			__free_page(page);
 	}
-	kfree(cmd->saved_iter_addr);
+	kfree(cmd->read_iov);
+free_iter:
+	kfree(cmd->read_iter);
 	return ret;
 }
 
-- 
2.34.1

