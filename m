Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB8B364AE
	for <target-devel@vger.kernel.org>; Wed,  9 Oct 2024 01:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728437937; cv=none; b=a7jlW/e+VE4sNySHiU8rQWjuY/nA0JU2JUk5UveG2N5uSdu8x58magJFA3Ldv3wYujyScQZ0qff4dkQwChdEffov/UqHIpxuVzBule6pnkwOWn2oWB/iCHbO2UKHXnI0Iu59BslAmJmX7d1JHZ3F0r+snCMk1oGkKVc/62gOdYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728437937; c=relaxed/simple;
	bh=nOOmzcWzV5Jgotu0qs0L0S00dbc5NvVQjUNgeiPU3MI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nsFLni7gFdcJdZsAuEi/w4cWY1M7sV1p4RHCq5zm4iCS4gYzJq5G6812BXHDrRKwBDJECdj//RUINghzjSQaMZ9LtPsnLFeaw8WPnX64lzBnBjjlm1kaajXlnxC1JIcO+SRvRQTbQ+fWEe0jepSU4iPNMnk73OrVcW0mn6f7YfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=B2uvCrgg; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B2uvCrgg"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 498JtaCR004859;
	Wed, 9 Oct 2024 01:38:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=vCkFZ
	EeDXxgHnFm+nWWr45Y7Z4/V5yEbhek6GlV4ARY=; b=B2uvCrggZIJW1wEz3jBQb
	C9q6nTAX8hXV44xEmwMjc9jaEJdAWAWl1F9q5ifE+vEijgyVrOIEbJAjIpp3McEV
	u5K3ZuhW+n19W5kXt1/tJAydbFLRKOPPdlDxM5+xtD++oo30H5yNAl+UPoA0AhOb
	SRO9Go/LwN8rLc3VBIZS3bep/HZwEFw7Cm/ApAalKlysYN05YNBhWMQ3r6xqzlGP
	dkz3prjEIOtJ22NWrzKBe/eAwCNjJ1bPqJPuMsIGPr6HZRC4bEhNoZWT1TA2wltZ
	lm9j77ToIQ96dLsXO63fAIaWJFhu1f0yUbMZCgbi5FJZgFKVb/lVYaK7Qe8eeuJm
	g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 422yyv75yd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Oct 2024 01:38:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 498NGBA7011084;
	Wed, 9 Oct 2024 01:38:50 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 422uwe89a6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Oct 2024 01:38:50 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4991chjE024787;
	Wed, 9 Oct 2024 01:38:49 GMT
Received: from mnc-mac.us.oracle.com (dhcp-10-65-182-164.vpn.oracle.com [10.65.182.164])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 422uwe897c-5;
	Wed, 09 Oct 2024 01:38:49 +0000
From: Mike Christie <michael.christie@oracle.com>
To: stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, pbonzini@redhat.com, target-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 5/8] vhost-scsi: Dynamically allocate scatterlists
Date: Tue,  8 Oct 2024 20:38:35 -0500
Message-ID: <20241009013839.88593-5-michael.christie@oracle.com>
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
X-Proofpoint-GUID: n2Aq97R496nCw1hD65MuX9ZSkUCM6OXu
X-Proofpoint-ORIG-GUID: n2Aq97R496nCw1hD65MuX9ZSkUCM6OXu

We currently preallocate scatterlists which have 2048 entries for each
command. For a small device with just 1 queue this results in:

8 MB = 32 bytes per sg * 2048 entries * 128 cmd

When mq is turned on and we increase the virtqueue_size so we can handle
commands from multiple queues in parallel, then this can sky rocket.

This patch allows us to dynamically allocate the scatterlist like is done
with drivers like NVMe and SCSI.

For small IO (4-16K) IOPs testing, we didn't see any regressions, but
for throughput testing we sometimes saw a 2-5% regression when the
backend device was very fast (8 NVMe drives in a MD RAID0 config or a
memory backed device). As a result this patch makes the dynamic
allocation feature a modparam so userspace can decide how it wants to
balance mem use and perf.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/Kconfig |   1 +
 drivers/vhost/scsi.c  | 260 ++++++++++++++++++++++++++++--------------
 2 files changed, 173 insertions(+), 88 deletions(-)

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index b455d9ab6f3d..020d4fbb947c 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -47,6 +47,7 @@ config VHOST_SCSI
 	tristate "VHOST_SCSI TCM fabric driver"
 	depends on TARGET_CORE && EVENTFD
 	select VHOST
+	select SG_POOL
 	default n
 	help
 	Say M here to enable the vhost_scsi TCM fabric module
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 095687622497..635ca372f874 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -46,6 +46,50 @@
 #define VHOST_SCSI_PREALLOC_UPAGES 2048
 #define VHOST_SCSI_PREALLOC_PROT_SGLS 2048
 
+static unsigned int vhost_scsi_inline_sg_cnt = VHOST_SCSI_PREALLOC_SGLS;
+
+#ifdef CONFIG_ARCH_NO_SG_CHAIN
+static int vhost_scsi_set_inline_sg_cnt(const char *buf,
+					const struct kernel_param *kp)
+{
+	pr_err("Setting inline_sg_cnt is not supported.\n");
+	return -EOPNOTSUPP;
+}
+#else
+static int vhost_scsi_set_inline_sg_cnt(const char *buf,
+					const struct kernel_param *kp)
+{
+	unsigned int cnt;
+	int ret;
+
+	ret = kstrtouint(buf, 10, &cnt);
+	if (ret)
+		return ret;
+
+	if (ret > VHOST_SCSI_PREALLOC_SGLS) {
+		pr_err("Max inline_sg_cnt is %u\n", VHOST_SCSI_PREALLOC_SGLS);
+		return -EINVAL;
+	}
+
+	vhost_scsi_inline_sg_cnt = cnt;
+	return 0;
+}
+#endif
+
+static int vhost_scsi_get_inline_sg_cnt(char *buf,
+					const struct kernel_param *kp)
+{
+	return sprintf(buf, "%u\n", vhost_scsi_inline_sg_cnt);
+}
+
+static const struct kernel_param_ops vhost_scsi_inline_sg_cnt_op = {
+	.get = vhost_scsi_get_inline_sg_cnt,
+	.set = vhost_scsi_set_inline_sg_cnt,
+};
+
+module_param_cb(inline_sg_cnt, &vhost_scsi_inline_sg_cnt_op, NULL, 0644);
+MODULE_PARM_DESC(inline_sg_cnt, "Set the number of scatterlist entries to pre-allocate. The default is 2048.");
+
 /* Max number of requests before requeueing the job.
  * Using this limit prevents one virtqueue from starving others with
  * request.
@@ -80,9 +124,10 @@ struct vhost_scsi_cmd {
 	u32 copied_iov:1;
 	const void *saved_iter_addr;
 	struct iov_iter saved_iter;
-	/* Pointer to the SGL formatted memory from virtio-scsi */
-	struct scatterlist *tvc_sgl;
-	struct scatterlist *tvc_prot_sgl;
+	struct scatterlist *sgl;
+	struct sg_table table;
+	struct scatterlist *prot_sgl;
+	struct sg_table prot_table;
 	/* Pointer to response header iovec */
 	struct iovec *tvc_resp_iov;
 	/* Pointer to vhost_scsi for our device */
@@ -206,6 +251,8 @@ struct vhost_scsi {
 
 	bool vs_events_missed; /* any missed events, protected by vq->mutex */
 	int vs_events_nr; /* num of pending events, protected by vq->mutex */
+
+	unsigned int inline_sg_cnt;
 };
 
 struct vhost_scsi_tmf {
@@ -328,23 +375,35 @@ static void vhost_scsi_release_cmd_res(struct se_cmd *se_cmd)
 {
 	struct vhost_scsi_cmd *tv_cmd = container_of(se_cmd,
 				struct vhost_scsi_cmd, tvc_se_cmd);
+	struct vhost_scsi *vs = tv_cmd->tvc_vhost;
 	struct vhost_scsi_virtqueue *svq = container_of(tv_cmd->tvc_vq,
 				struct vhost_scsi_virtqueue, vq);
 	struct vhost_scsi_inflight *inflight = tv_cmd->inflight;
+	struct scatterlist *sg;
+	struct page *page;
 	int i;
 
 	if (tv_cmd->tvc_sgl_count) {
-		for (i = 0; i < tv_cmd->tvc_sgl_count; i++) {
+		for_each_sgtable_sg(&tv_cmd->table, sg, i) {
+			page = sg_page(sg);
+			if (!page)
+				continue;
+
 			if (tv_cmd->copied_iov)
-				__free_page(sg_page(&tv_cmd->tvc_sgl[i]));
+				__free_page(page);
 			else
-				put_page(sg_page(&tv_cmd->tvc_sgl[i]));
+				put_page(page);
 		}
 		kfree(tv_cmd->saved_iter_addr);
+		sg_free_table_chained(&tv_cmd->table, vs->inline_sg_cnt);
 	}
 	if (tv_cmd->tvc_prot_sgl_count) {
-		for (i = 0; i < tv_cmd->tvc_prot_sgl_count; i++)
-			put_page(sg_page(&tv_cmd->tvc_prot_sgl[i]));
+		for_each_sgtable_sg(&tv_cmd->prot_table, sg, i) {
+			page = sg_page(sg);
+			if (page)
+				put_page(page);
+		}
+		sg_free_table_chained(&tv_cmd->prot_table, vs->inline_sg_cnt);
 	}
 
 	sbitmap_clear_bit(&svq->scsi_tags, se_cmd->map_tag);
@@ -534,14 +593,17 @@ static void vhost_scsi_evt_work(struct vhost_work *work)
 static int vhost_scsi_copy_sgl_to_iov(struct vhost_scsi_cmd *cmd)
 {
 	struct iov_iter *iter = &cmd->saved_iter;
-	struct scatterlist *sg = cmd->tvc_sgl;
+	struct scatterlist *sg;
 	struct page *page;
 	size_t len;
 	int i;
 
-	for (i = 0; i < cmd->tvc_sgl_count; i++) {
-		page = sg_page(&sg[i]);
-		len = sg[i].length;
+	for_each_sgtable_sg(&cmd->table, sg, i) {
+		page = sg_page(sg);
+		if (!page)
+			continue;
+
+		len = sg->length;
 
 		if (copy_page_to_iter(page, 0, len, iter) != len) {
 			pr_err("Could not copy data while handling misaligned cmd. Error %zu\n",
@@ -617,7 +679,7 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 					struct vhost_scsi_virtqueue, vq);
 	struct vhost_scsi_cmd *cmd;
 	struct vhost_scsi_nexus *tv_nexus;
-	struct scatterlist *sg, *prot_sg;
+	struct scatterlist *sgl, *prot_sgl;
 	struct iovec *tvc_resp_iov;
 	int tag;
 
@@ -634,12 +696,12 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	}
 
 	cmd = &svq->scsi_cmds[tag];
-	sg = cmd->tvc_sgl;
-	prot_sg = cmd->tvc_prot_sgl;
+	sgl = cmd->sgl;
+	prot_sgl = cmd->prot_sgl;
 	tvc_resp_iov = cmd->tvc_resp_iov;
 	memset(cmd, 0, sizeof(*cmd));
-	cmd->tvc_sgl = sg;
-	cmd->tvc_prot_sgl = prot_sg;
+	cmd->sgl = sgl;
+	cmd->prot_sgl = prot_sgl;
 	cmd->tvc_se_cmd.map_tag = tag;
 	cmd->tvc_tag = scsi_tag;
 	cmd->tvc_lun = lun;
@@ -655,6 +717,27 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	return cmd;
 }
 
+static void vhost_scsi_revert_map_iov_to_sgl(struct iov_iter *iter,
+					     struct scatterlist *curr,
+					     struct scatterlist *end)
+{
+	size_t revert_bytes = 0;
+	struct page *page;
+
+	while (curr != end) {
+		page = sg_page(curr);
+
+		if (page) {
+			put_page(page);
+			revert_bytes += curr->length;
+		}
+		/* Clear so we can re-use it for the copy path */
+		sg_set_page(curr, NULL, 0, 0);
+		curr = sg_next(curr);
+	}
+	iov_iter_revert(iter, revert_bytes);
+}
+
 /*
  * Map a user memory range into a scatterlist
  *
@@ -663,16 +746,17 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 static int
 vhost_scsi_map_to_sgl(struct vhost_scsi_cmd *cmd,
 		      struct iov_iter *iter,
-		      struct scatterlist *sgl,
+		      struct sg_table *sg_table,
+		      struct scatterlist **sgl,
 		      bool is_prot)
 {
 	struct vhost_scsi_virtqueue *svq = container_of(cmd->tvc_vq,
 					struct vhost_scsi_virtqueue, vq);
 	struct page **pages = svq->upages;
-	struct scatterlist *sg = sgl;
-	ssize_t bytes, mapped_bytes;
-	size_t offset, mapped_offset;
-	unsigned int npages = 0;
+	struct scatterlist *sg = *sgl;
+	ssize_t bytes;
+	size_t offset;
+	unsigned int n, npages = 0;
 
 	bytes = iov_iter_get_pages2(iter, pages, LONG_MAX,
 				VHOST_SCSI_PREALLOC_UPAGES, &offset);
@@ -680,11 +764,8 @@ vhost_scsi_map_to_sgl(struct vhost_scsi_cmd *cmd,
 	if (bytes <= 0)
 		return bytes < 0 ? bytes : -EFAULT;
 
-	mapped_bytes = bytes;
-	mapped_offset = offset;
-
 	while (bytes) {
-		unsigned n = min_t(unsigned, PAGE_SIZE - offset, bytes);
+		n = min_t(unsigned int, PAGE_SIZE - offset, bytes);
 		/*
 		 * The block layer requires bios/requests to be a multiple of
 		 * 512 bytes, but Windows can send us vecs that are misaligned.
@@ -705,25 +786,24 @@ vhost_scsi_map_to_sgl(struct vhost_scsi_cmd *cmd,
 			goto revert_iter_get_pages;
 		}
 
-		sg_set_page(sg++, pages[npages++], n, offset);
+		sg_set_page(sg, pages[npages++], n, offset);
+		sg = sg_next(sg);
 		bytes -= n;
 		offset = 0;
 	}
 
+	*sgl = sg;
 	return npages;
 
 revert_iter_get_pages:
-	iov_iter_revert(iter, mapped_bytes);
+	vhost_scsi_revert_map_iov_to_sgl(iter, *sgl, sg);
 
-	npages = 0;
-	while (mapped_bytes) {
-		unsigned int n = min_t(unsigned int, PAGE_SIZE - mapped_offset,
-				       mapped_bytes);
+	iov_iter_revert(iter, bytes);
+	while (bytes) {
+		n = min_t(unsigned int, PAGE_SIZE, bytes);
 
 		put_page(pages[npages++]);
-
-		mapped_bytes -= n;
-		mapped_offset = 0;
+		bytes -= n;
 	}
 
 	return -EINVAL;
@@ -751,10 +831,11 @@ vhost_scsi_calc_sgls(struct iov_iter *iter, size_t bytes, int max_sgls)
 
 static int
 vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
-			   struct scatterlist *sg, int sg_count)
+			   struct sg_table *sg_table, int sg_count)
 {
 	size_t len = iov_iter_count(iter);
 	unsigned int nbytes = 0;
+	struct scatterlist *sg;
 	struct page *page;
 	int i, ret;
 
@@ -765,16 +846,15 @@ vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
 			return -ENOMEM;
 	}
 
-	for (i = 0; i < sg_count; i++) {
+	for_each_sgtable_sg(sg_table, sg, i) {
 		page = alloc_page(GFP_KERNEL);
 		if (!page) {
-			i--;
 			ret = -ENOMEM;
 			goto err;
 		}
 
 		nbytes = min_t(unsigned int, PAGE_SIZE, len);
-		sg_set_page(&sg[i], page, nbytes, 0);
+		sg_set_page(sg, page, nbytes, 0);
 
 		if (cmd->tvc_data_direction == DMA_TO_DEVICE &&
 		    copy_page_from_iter(page, 0, nbytes, iter) != nbytes) {
@@ -792,39 +872,29 @@ vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
 	pr_err("Could not read %u bytes while handling misaligned cmd\n",
 	       nbytes);
 
-	for (; i >= 0; i--)
-		__free_page(sg_page(&sg[i]));
+	for_each_sgtable_sg(sg_table, sg, i) {
+		page = sg_page(sg);
+		if (page)
+			__free_page(page);
+	}
 	kfree(cmd->saved_iter_addr);
 	return ret;
 }
 
 static int
 vhost_scsi_map_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
-			  struct scatterlist *sg, int sg_count, bool is_prot)
+			  struct sg_table *sg_table, int sg_count, bool is_prot)
 {
-	struct scatterlist *p = sg;
-	size_t revert_bytes;
+	struct scatterlist *sg = sg_table->sgl;
 	int ret;
 
 	while (iov_iter_count(iter)) {
-		ret = vhost_scsi_map_to_sgl(cmd, iter, sg, is_prot);
+		ret = vhost_scsi_map_to_sgl(cmd, iter, sg_table, &sg, is_prot);
 		if (ret < 0) {
-			revert_bytes = 0;
-
-			while (p < sg) {
-				struct page *page = sg_page(p);
-
-				if (page) {
-					put_page(page);
-					revert_bytes += p->length;
-				}
-				p++;
-			}
-
-			iov_iter_revert(iter, revert_bytes);
+			vhost_scsi_revert_map_iov_to_sgl(iter, sg_table->sgl,
+							 sg);
 			return ret;
 		}
-		sg += ret;
 	}
 
 	return 0;
@@ -835,23 +905,29 @@ vhost_scsi_mapal(struct vhost_scsi_cmd *cmd,
 		 size_t prot_bytes, struct iov_iter *prot_iter,
 		 size_t data_bytes, struct iov_iter *data_iter)
 {
+	struct vhost_scsi *vs = cmd->tvc_vhost;
 	int sgl_count, ret;
 
 	if (prot_bytes) {
 		sgl_count = vhost_scsi_calc_sgls(prot_iter, prot_bytes,
 						 VHOST_SCSI_PREALLOC_PROT_SGLS);
-		if (sgl_count < 0)
-			return sgl_count;
+		cmd->prot_table.sgl = cmd->prot_sgl;
+		ret = sg_alloc_table_chained(&cmd->prot_table, sgl_count,
+					     cmd->prot_table.sgl,
+					     vs->inline_sg_cnt);
+		if (ret)
+			return ret;
 
-		sg_init_table(cmd->tvc_prot_sgl, sgl_count);
 		cmd->tvc_prot_sgl_count = sgl_count;
 		pr_debug("%s prot_sg %p prot_sgl_count %u\n", __func__,
-			 cmd->tvc_prot_sgl, cmd->tvc_prot_sgl_count);
+			 cmd->prot_table.sgl, cmd->tvc_prot_sgl_count);
 
 		ret = vhost_scsi_map_iov_to_sgl(cmd, prot_iter,
-						cmd->tvc_prot_sgl,
+						&cmd->prot_table,
 						cmd->tvc_prot_sgl_count, true);
 		if (ret < 0) {
+			sg_free_table_chained(&cmd->prot_table,
+					      vs->inline_sg_cnt);
 			cmd->tvc_prot_sgl_count = 0;
 			return ret;
 		}
@@ -861,20 +937,23 @@ vhost_scsi_mapal(struct vhost_scsi_cmd *cmd,
 	if (sgl_count < 0)
 		return sgl_count;
 
-	sg_init_table(cmd->tvc_sgl, sgl_count);
+	cmd->table.sgl = cmd->sgl;
+	ret = sg_alloc_table_chained(&cmd->table, sgl_count, cmd->table.sgl,
+				     vs->inline_sg_cnt);
+	if (ret)
+		return ret;
+
 	cmd->tvc_sgl_count = sgl_count;
 	pr_debug("%s data_sg %p data_sgl_count %u\n", __func__,
-		  cmd->tvc_sgl, cmd->tvc_sgl_count);
+		  cmd->table.sgl, cmd->tvc_sgl_count);
 
-	ret = vhost_scsi_map_iov_to_sgl(cmd, data_iter, cmd->tvc_sgl,
+	ret = vhost_scsi_map_iov_to_sgl(cmd, data_iter, &cmd->table,
 					cmd->tvc_sgl_count, false);
-	if (ret == -EINVAL) {
-		sg_init_table(cmd->tvc_sgl, cmd->tvc_sgl_count);
-		ret = vhost_scsi_copy_iov_to_sgl(cmd, data_iter, cmd->tvc_sgl,
+	if (ret == -EINVAL)
+		ret = vhost_scsi_copy_iov_to_sgl(cmd, data_iter, &cmd->table,
 						 cmd->tvc_sgl_count);
-	}
-
 	if (ret < 0) {
+		sg_free_table_chained(&cmd->table, vs->inline_sg_cnt);
 		cmd->tvc_sgl_count = 0;
 		return ret;
 	}
@@ -906,10 +985,10 @@ static void vhost_scsi_target_queue_cmd(struct vhost_scsi_cmd *cmd)
 
 	/* FIXME: BIDI operation */
 	if (cmd->tvc_sgl_count) {
-		sg_ptr = cmd->tvc_sgl;
+		sg_ptr = cmd->table.sgl;
 
 		if (cmd->tvc_prot_sgl_count)
-			sg_prot_ptr = cmd->tvc_prot_sgl;
+			sg_prot_ptr = cmd->prot_table.sgl;
 		else
 			se_cmd->prot_pto = true;
 	} else {
@@ -1617,8 +1696,8 @@ static void vhost_scsi_destroy_vq_cmds(struct vhost_virtqueue *vq)
 	for (i = 0; i < svq->max_cmds; i++) {
 		tv_cmd = &svq->scsi_cmds[i];
 
-		kfree(tv_cmd->tvc_sgl);
-		kfree(tv_cmd->tvc_prot_sgl);
+		kfree(tv_cmd->sgl);
+		kfree(tv_cmd->prot_sgl);
 		kfree(tv_cmd->tvc_resp_iov);
 	}
 
@@ -1632,6 +1711,7 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 {
 	struct vhost_scsi_virtqueue *svq = container_of(vq,
 					struct vhost_scsi_virtqueue, vq);
+	struct vhost_scsi *vs = svq->vs;
 	struct vhost_scsi_cmd *tv_cmd;
 	unsigned int i;
 
@@ -1657,12 +1737,14 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 	for (i = 0; i < max_cmds; i++) {
 		tv_cmd = &svq->scsi_cmds[i];
 
-		tv_cmd->tvc_sgl = kcalloc(VHOST_SCSI_PREALLOC_SGLS,
-					  sizeof(struct scatterlist),
-					  GFP_KERNEL);
-		if (!tv_cmd->tvc_sgl) {
-			pr_err("Unable to allocate tv_cmd->tvc_sgl\n");
-			goto out;
+		if (vs->inline_sg_cnt) {
+			tv_cmd->sgl = kcalloc(vs->inline_sg_cnt,
+					      sizeof(struct scatterlist),
+					      GFP_KERNEL);
+			if (!tv_cmd->sgl) {
+				pr_err("Unable to allocate tv_cmd->sgl\n");
+				goto out;
+			}
 		}
 
 		tv_cmd->tvc_resp_iov = kcalloc(UIO_MAXIOV,
@@ -1673,12 +1755,13 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 			goto out;
 		}
 
-		if (vhost_has_feature(vq, VIRTIO_SCSI_F_T10_PI)) {
-			tv_cmd->tvc_prot_sgl = kcalloc(VHOST_SCSI_PREALLOC_PROT_SGLS,
-						sizeof(struct scatterlist),
-						GFP_KERNEL);
-			if (!tv_cmd->tvc_prot_sgl) {
-				pr_err("Unable to allocate tv_cmd->tvc_prot_sgl\n");
+		if (vhost_has_feature(vq, VIRTIO_SCSI_F_T10_PI) &&
+		    vs->inline_sg_cnt) {
+			tv_cmd->prot_sgl = kcalloc(vs->inline_sg_cnt,
+						   sizeof(struct scatterlist),
+						   GFP_KERNEL);
+			if (!tv_cmd->prot_sgl) {
+				pr_err("Unable to allocate tv_cmd->prot_sgl\n");
 				goto out;
 			}
 		}
@@ -1968,6 +2051,7 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 	vs = kvzalloc(sizeof(*vs), GFP_KERNEL);
 	if (!vs)
 		goto err_vs;
+	vs->inline_sg_cnt = vhost_scsi_inline_sg_cnt;
 
 	if (nvqs > VHOST_SCSI_MAX_IO_VQ) {
 		pr_err("Invalid max_io_vqs of %d. Using %d.\n", nvqs,
-- 
2.34.1

