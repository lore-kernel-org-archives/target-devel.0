Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DD72040BD
	for <target-devel@vger.kernel.org>; Tue,  3 Dec 2024 19:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733253444; cv=none; b=IlDscJeagcsV0oNwplw6WKs/dtd2ZLCRTSLHR9qFBU1ou2loqgDyd3B4U+caJuFpQBvfFBxq3kXV0ODkt9BdqP4JgpaJR3AxdZi7eR68pobA1qqNI0r4jkEwL6UxPBcKT1ygWWwG9P/ETLIemg4vNFrT+tWHRkYR4elNcfO/IJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733253444; c=relaxed/simple;
	bh=yYy36V2Jrpf0yuVAWHCYqLEL1Rh2/1EGu+9PihKdVuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CN0Jq3hHoHDgbYIBLIk2SttT03LHjw1KchvIzde0KXBhwdhRVws2L8x/5NHZM2nJrm0r1eTuQnSTXLuALxqG6xi6+x/rtjnPs4Bq0iAsQwfVrJGIKYGP/b/rFXr2NW2pKJXqEW4ylqkZGfWrWr/2++cIUXdu1DDh81leMwHmAkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LBMaWazN; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LBMaWazN"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B3HtYvw030173;
	Tue, 3 Dec 2024 19:17:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=ievkg
	iQ4SKLIGHsZtSVQ374YHSgxmyvMxfrI60k79xk=; b=LBMaWazNsfUyuLH5J3S2v
	cdmTCSeicpaLw5UBs1mqWuUv55aSaKxkmXqjATahRbDyXVX7s38LN52uO+4F55He
	DOAgb0U7w3M2UHAJn9wufYVrzybExDBNL3X0P4SUj9+IUJWtWld7u+K56FiQ3QOz
	6JtRKv4sRSyGK1wm4akBDRrl5n/N8Yx6nx4TSvBOMduyr513FHRCTTx0zeF2C0TI
	63+pt4qu9yLuM3hFgSrLfcV/Ku+3YCPsnFhF35Im1KIdUjvIYlH9XyID4pQHA7Ui
	AbJ6tR5RqTBLI1f9SB6dAXyNltfFXhB0M2SglrBysftGu9hH8TH0H2kLeHelNU1N
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437tas6sbq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Dec 2024 19:17:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B3Hp0QS001813;
	Tue, 3 Dec 2024 19:17:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 437s58akge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Dec 2024 19:17:18 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4B3JH9MM021603;
	Tue, 3 Dec 2024 19:17:18 GMT
Received: from mnc-mac.us.oracle.com (dhcp-10-65-163-31.vpn.oracle.com [10.65.163.31])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 437s58ak94-8;
	Tue, 03 Dec 2024 19:17:18 +0000
From: Mike Christie <michael.christie@oracle.com>
To: stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, pbonzini@redhat.com, target-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 7/8] vhost-scsi: Allocate iov_iter used for unaligned copies when needed
Date: Tue,  3 Dec 2024 13:15:14 -0600
Message-ID: <20241203191705.19431-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20241203191705.19431-1-michael.christie@oracle.com>
References: <20241203191705.19431-1-michael.christie@oracle.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-03_08,2024-12-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412030159
X-Proofpoint-GUID: -Cv4rMDr94G-2HdOZriF0o5riMWHNSUX
X-Proofpoint-ORIG-GUID: -Cv4rMDr94G-2HdOZriF0o5riMWHNSUX

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
index 97b0c3fc1fb2..ca93089c9f8e 100644
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

