Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD431FC7F0
	for <target-devel@vger.kernel.org>; Tue,  3 Dec 2024 19:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733253440; cv=none; b=Z42uu/xoHZjKp13anxRXC9cQZQ2HHVqUd+eFXXy5Ec3+4lnn00ap4m4+MUV8rrzH0rPYSq6xIRVXiEGCKJZIyTEWpWzEPoD45zUiNKDZtKqJ7wCAY+QLOpAnFzpoMX1P88Gfbk6Ge2dP0NoNYPRmUyQdjuNeVnS0opEchK9tf0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733253440; c=relaxed/simple;
	bh=zpLyMeqw+tfBFC4EwfdSli1uN+ElNLiJtRsWOc27860=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lE+qarVwQEemkRCBULiW/QIWmpwZ6AjoxGmcgOWGwJJWHHFiEu0d+WuWGyogJcOb0zT6s3FbputfPkI8sMrX/+KRjQUFcBlSAzdMULSUrMyiasMjjq9Kmu5KT9sA1Dm+WYZD3OINLT2/SBVtT0Dg+Paa+JlsQbC/SchkRNfkO50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PZFVKCGO; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PZFVKCGO"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B3HtaP6012461;
	Tue, 3 Dec 2024 19:17:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=P2BAh
	ZdACeXaj+1Ef20ces3JOwurWxqNdeMM2D5u+yg=; b=PZFVKCGO5Ey6sMuOPzrlR
	RIW3Gg2BSXY3GaRqAlhvxerVj2pE7LTlpUV4r9Xn37qfdd+gAOGo6KPsacuRQC0b
	pffJXSzUApQhMwac6cqb0hPKILhDlEbMlOQG9UQZ2gfadcUAbdLhgGvx+QVdgZ2Z
	UNYJDYgbNcCR78Y6AQu7APVfL5Bf6bW9W9p7GufXVhGMcCr6MCqKcYCUcw2u5wwr
	gCVy79RZea8k9U+nacOKsgZ4UGfUdBCTd8w9HSs2aQ6cG9SoW4vGhqRTRVw8NkHU
	uJIfJMNsZ+oXQySSEsjweM7enOQVKwoZklAHPrcC6WcjJNoL8ZSVolgIS9Rm4Nms
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437s4c6sxn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Dec 2024 19:17:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B3J65mF001214;
	Tue, 3 Dec 2024 19:17:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 437s58akdh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Dec 2024 19:17:13 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4B3JH9ME021603;
	Tue, 3 Dec 2024 19:17:12 GMT
Received: from mnc-mac.us.oracle.com (dhcp-10-65-163-31.vpn.oracle.com [10.65.163.31])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 437s58ak94-4;
	Tue, 03 Dec 2024 19:17:12 +0000
From: Mike Christie <michael.christie@oracle.com>
To: stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, pbonzini@redhat.com, target-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 3/8] vhost-scsi: Add better resource allocation failure handling
Date: Tue,  3 Dec 2024 13:15:10 -0600
Message-ID: <20241203191705.19431-4-michael.christie@oracle.com>
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
X-Proofpoint-ORIG-GUID: 9fbUM6AojZCIvsmJ0Ou9sFzj1ueXOVj0
X-Proofpoint-GUID: 9fbUM6AojZCIvsmJ0Ou9sFzj1ueXOVj0

If we can't allocate mem to map in data for a request or can't find
a tag for a command, we currently drop the command. This leads to the
error handler running to clean it up. Instead of dropping the command
this has us return an error telling the initiator that it queued more
commands than we can handle. The initiator will then reduce how many
commands it will send us and retry later.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 99e008219e6c..ad7c778632f9 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -629,7 +629,7 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 
 	tag = sbitmap_get(&svq->scsi_tags);
 	if (tag < 0) {
-		pr_err("Unable to obtain tag for vhost_scsi_cmd\n");
+		pr_warn_once("Guest sent too many cmds. Returning TASK_SET_FULL.\n");
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -928,6 +928,24 @@ static void vhost_scsi_target_queue_cmd(struct vhost_scsi_cmd *cmd)
 	target_submit(se_cmd);
 }
 
+static void
+vhost_scsi_send_status(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
+		       int head, unsigned int out, u8 status)
+{
+	struct virtio_scsi_cmd_resp __user *resp;
+	struct virtio_scsi_cmd_resp rsp;
+	int ret;
+
+	memset(&rsp, 0, sizeof(rsp));
+	rsp.status = status;
+	resp = vq->iov[out].iov_base;
+	ret = __copy_to_user(resp, &rsp, sizeof(rsp));
+	if (!ret)
+		vhost_add_used_and_signal(&vs->dev, vq, head, 0);
+	else
+		pr_err("Faulted on virtio_scsi_cmd_resp\n");
+}
+
 static void
 vhost_scsi_send_bad_target(struct vhost_scsi *vs,
 			   struct vhost_virtqueue *vq,
@@ -1215,8 +1233,8 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 					 exp_data_len + prot_bytes,
 					 data_direction);
 		if (IS_ERR(cmd)) {
-			vq_err(vq, "vhost_scsi_get_cmd failed %ld\n",
-			       PTR_ERR(cmd));
+			ret = PTR_ERR(cmd);
+			vq_err(vq, "vhost_scsi_get_tag failed %dd\n", ret);
 			goto err;
 		}
 		cmd->tvc_vhost = vs;
@@ -1253,11 +1271,15 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		 * EINVAL: Invalid response buffer, drop the request
 		 * EIO:    Respond with bad target
 		 * EAGAIN: Pending request
+		 * ENOMEM: Could not allocate resources for request
 		 */
 		if (ret == -ENXIO)
 			break;
 		else if (ret == -EIO)
 			vhost_scsi_send_bad_target(vs, vq, vc.head, vc.out);
+		else if (ret == -ENOMEM)
+			vhost_scsi_send_status(vs, vq, vc.head, vc.out,
+					       SAM_STAT_TASK_SET_FULL);
 	} while (likely(!vhost_exceeds_weight(vq, ++c, 0)));
 out:
 	mutex_unlock(&vq->mutex);
-- 
2.34.1

