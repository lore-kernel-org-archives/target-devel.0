Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.154
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788325;
	b=aqPuMcPntry3b8cgzgbKfhsw82I9rnqlm519MwE38jBOAMBcQmO99cbeyM7IJZtRTINl
	 38yQ/xoNIiO8rHAFeg/b/D69xCyimCZ8443Cz41+uBgg1b//yiV+tekeLjmcYTcNcV+sN
	 qor5u0dJ6ih7c3izMfRaHZLjafxYP9QeQdD60RlHPdQQzWj8hk2ODLSgeKgQNDM1Ly+Dr
	 z3gYPZrjyXrwOOlAZrThRZe/kdK+dj+px+SZWVhJcIa9fP9AuBhSk1BSDVLMJNsU71qwz
	 cd7DIydCwWx8hatRGZQYPJPnGI+cHuKx86cnvUWvMIOia22aNgjaxzxJP5Pd87WAcZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788325;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=avmRIcRu9EZE8spWIWMDKOK/8vg/KCkRzy/tHk/Ubzk=;
	b=Azlqu9jsU3REVpYBEDMrF+qDAxk5c9uSFi5vIVGSWhV3x0SzHJto463JJOa2EHhaxPFB
	 U8cZSfUeSrl5pWWPu9iAlTbXggWEhqHCcqVO67lqcrCXNmSFtvWLZAmfZCiPxJxGEcBYD
	 CjrUpJXIqGWksqLwrr4QRcOV9kpcdBfeFQMYH/AwrUOILui6roLaQaQuSqOIPFV3Jo2hV
	 9T0q2szExEE5XwtN2Ba2AZIBdgp7bmhaV+XYzWpS8kCPOmDHeF0s+bHciBK16cuwMjp/C
	 /Rdo+BUn3tyoSCOVqwFH4PIbPFwDGtP5CVs2v85VJ7vWEjxSwKH5tIX07gbH4Y3GtKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fv4MMklm;
	arc=none smtp.remote-ip=95.215.58.154
Received: from mta1.migadu.com (out-154.mta1.migadu.com [95.215.58.154])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121ED606A332
	for <target-devel@vger.kernel.org>; Mon, 16 Nov 2026 00:18:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 121ED606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fv4MMklm
X-Envelope-To: target-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=0M2XgL9UYDclhv5Ioofb/hHIFH3uS4AmZa70lUCfTJk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794788323; v=1; x=1795393123;
 b=fv4MMklm2Tlng/FD3N9M2rU5Fmegu2HflgvZoYPN3ld3q0ahWRkif5t958REx6iSD3T5Z9Qr
 w9JFML19iYRDY1+jnEwRJ5DP6OSl9SBA3jv0UV3CQmOA5JpQHoVHcVot06IpCCe2LQzqKgrKkQC
 KmTbce2SR4+BUM8rriGk/M5Q=
X-Envelope-To: target-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 556456cca49a77c6;
	Mon, 16 Nov 2026 00:18:42 +0000
X-Mizu-Trace-ID: 556456cca49a77c6
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Sun, 15 Nov 2026 19:17:57 -0500
Subject: [PATCH RFC 04/18] scsi: target: uring: Map the command descriptors
 into the server
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-feat-target-core-uring-v1-4-28cdc137eac6@linux.dev>
References: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
In-Reply-To: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
To: "Martin K. Petersen" <mkp@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
 io-uring@vger.kernel.org, Mike Christie <michael.christie@oracle.com>, 
 Bodo Stroesser <bostroesser@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 Qiliang Yuan <qiliang.yuan@linux.dev>
X-Mailer: b4 0.13.0

Each queue of a target_core_uring device has an array of command
descriptors that the kernel fills.

The server cannot read the descriptors yet.

Let the server mmap() the descriptors of queue q_id at offset
q_id * TCMUR_DESC_AREA_SIZE of the character device. Refuse writable
mappings, as only the kernel writes descriptors.

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 drivers/target/target_core_uring.c     | 22 +++++++++++++++++++++-
 include/uapi/linux/target_core_uring.h |  6 +++++-
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_uring.c b/drivers/target/target_core_uring.c
index d1ca4f16e7d0b..904ce2a613618 100644
--- a/drivers/target/target_core_uring.c
+++ b/drivers/target/target_core_uring.c
@@ -31,7 +31,7 @@ struct tcmur_dev;
 
 /**
  * struct tcmur_queue - One command queue
- * @descs:	Command descriptors, indexed by tag
+ * @descs:	Command descriptors, indexed by tag and mapped by the server
  * @udev:	Device the queue belongs to
  */
 struct tcmur_queue {
@@ -79,6 +79,25 @@ static size_t tcmur_desc_area_size(struct tcmur_dev *udev)
 	return PAGE_ALIGN(udev->queue_depth * sizeof(struct tcmur_io_desc));
 }
 
+static int tcmur_ch_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct tcmur_dev *udev = filp->private_data;
+	u64 off = (u64)vma->vm_pgoff << PAGE_SHIFT;
+	u32 rem;
+	u64 q_id = div_u64_rem(off, TCMUR_DESC_AREA_SIZE, &rem);
+
+	if (rem || q_id >= udev->nr_queues ||
+	    vma->vm_end - vma->vm_start != tcmur_desc_area_size(udev))
+		return -EINVAL;
+
+	/* Refuse writable mappings, as only the kernel writes descriptors */
+	if (vma->vm_flags & VM_WRITE)
+		return -EPERM;
+	vm_flags_clear(vma, VM_MAYWRITE);
+
+	return remap_vmalloc_range(vma, udev->queues[q_id].descs, 0);
+}
+
 static long tcmur_ch_ioctl(struct file *filp, unsigned int cmd,
 			   unsigned long arg)
 {
@@ -125,6 +144,7 @@ static const struct file_operations tcmur_ch_fops = {
 	.owner		= THIS_MODULE,
 	.open		= tcmur_ch_open,
 	.release	= tcmur_ch_release,
+	.mmap		= tcmur_ch_mmap,
 	.unlocked_ioctl	= tcmur_ch_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
 };
diff --git a/include/uapi/linux/target_core_uring.h b/include/uapi/linux/target_core_uring.h
index c23e01e7638a2..d2b8ffe40bf7a 100644
--- a/include/uapi/linux/target_core_uring.h
+++ b/include/uapi/linux/target_core_uring.h
@@ -54,7 +54,8 @@ enum tcmur_io_op {
  * @data_len:	Bytes of data to transfer
  * @reserved:	Zero
  *
- * The descriptors of a queue form an array indexed by tag.
+ * The descriptors of a queue form an array indexed by tag, which the server
+ * maps read-only at offset q_id * TCMUR_DESC_AREA_SIZE of the file.
  */
 struct tcmur_io_desc {
 	__u32	op;
@@ -65,4 +66,7 @@ struct tcmur_io_desc {
 	__u32	reserved;
 };
 
+#define TCMUR_DESC_AREA_SIZE \
+	(TCMUR_MAX_QUEUE_DEPTH * sizeof(struct tcmur_io_desc))
+
 #endif /* _UAPI_LINUX_TARGET_CORE_URING_H */

-- 
2.43.0

