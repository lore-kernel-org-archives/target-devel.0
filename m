Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85ED2773E5
	for <target-devel@vger.kernel.org>; Fri,  9 Oct 2026 00:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791506145; cv=none; b=ZJXBY/nAGE66cYiA0UgEcKmm2IHtSZH++vsDw7ARvS89ESzJH1qqiYm5BF4wKoKRxqPdDzAuABOXVi1inMkwupu1ndvm67S5BUUvSt/6rC+MouBMy1ZUV8KOGcZ52jDm+Ald1+Ef5B8PBJHpxQ27TAXO+jlLG+laxW1X6IwWx0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791506145; c=relaxed/simple;
	bh=l+t8v9WxXW8yj45kL2UgUyKv0ERAXtt5Qf7uOcu7xTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=COHfHnupdPTQ7YyhIQqp1B9U7chQMjGrSBK8yCQ+SIW5RxEeYmQJTG5AljdSPOob5J8rh8LJNt+Qty+7AkhBA7B28/OVBpvv8KnuyB4eufkx0jWAAUE8ucbOg1IBSlk3iWNqheZwI1B0qMUb+ruwSfMKqKzO2GbtFeGumX6rzzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UBORn/o7; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UBORn/o7"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5c7d1fc8f9dso78370e0c.1
        for <target-devel@vger.kernel.org>; Thu, 08 Oct 2026 17:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791506143; x=1792110943; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WdEsEyWM4pdqoDh+trBH24Lt+yVX+eIUgpA4t+jtMFA=;
        b=UBORn/o7WKX3E4QP9bNP14sMHj9DTfWDzRRL1344vxuMzrTmzQcR7x+CENL6iRddFp
         shDUTHdFyGUi5Z8D0pID3c0ndm4VtF8E78RMXGyu9aZRRYce3iRb/J1AITQgOF2QjQV2
         D4pTt4epZc+TwmDYWhJHwAObUbKAqJ4LRyYh120jTlHwLDh4mYTk/Z2erXIJGSo887yR
         6nt46HiOoQaPfj/Og70gZoKpYTSUrm0LJ6YVAvbP2DcrHg495B54PJHf9UoVwnxS9GI5
         ziZAg+h8TjO3ZiPffpxwenhQjTSLh6VcQC7sfeKvwZsm5ovuVirzG3yAcgYDml3mgIME
         DtaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791506143; x=1792110943;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WdEsEyWM4pdqoDh+trBH24Lt+yVX+eIUgpA4t+jtMFA=;
        b=z+qgjFkCp3eQ4Z3w0GqlPtp9PZ3egcU5NwCxj+du0SIBmuV2P0QVRRPOQVTejYTA/4
         crOUbIcraOWbu/6vpgcxHanrlaIkWGw1aCDr8hnUbyWuINfGnMGgFK5T+j69eqBwjczb
         iiPnJvzbeWLmQj1Fnj7XMFneHOw0b68UNgi0BzbhG4J+e1EPPFriix6L6hA2lH7/q4SN
         NiBqNC2K8CLkO3bLzHqvVfn7zM5/e80OwKetRzL/ofDrrgmAO6w2RIZomQn0QwTlShpK
         11URYjXWZKmnoDKILbGaImL2hqtEzvWxX5wHzkHzlTFzSfBcXldUQIdQQQNkTkaMjRhl
         Ucww==
X-Forwarded-Encrypted: i=1; AKwUvBxb+dvigY5GVaovDR7ZkOh3SrAuxq5lcfvY46hd0ZPY+RaMKjZDiEQDaNYVxlHnkMkUF+Oigvg2moFKzts=@vger.kernel.org
X-Gm-Message-State: AFq9FYJIIYWO3n8G4RdIwJZxlW55hO4DV4mVxcbr/LZlFK/N3DJATrfF
	xrjf18u8sjkyYYwBHI1GujVxq4zoSdJyjjg3UHIHe5wdAAGm/n0mNH4xgzCZ21+CGtg=
X-Gm-Gg: AYBFou3qSTKTgWKPAAUTY3a+DmKIoyQ4YdCNxqo8+8KP5vvnHXpBwnbReMC/lx22+aW
	SRX8cUB0EKi3WZcH+y1mCNb+q7zdDXY4WoU2VwzWz4lWsQZaboxg+XH45GWA0kAgZ4TJk5NTodw
	QKTfiIdTYRGz6whLXeC59ZnPirTpBRcWFLH+h50WwcYuPtuGxjVmT6/oBuRVftPMe7ciFG66gsR
	rTeD+losDRSy3f+wlTIAmbavSskaQgDkgh44Oelsj8mCgTqbtChoXWOIaN/U4wsSSApgrRmqNhA
	O8cLa+vFxlg/fwA/kFxreQEP6GjDFXB3C9Qqh2yz2Yk+UVz+bXhUt2NAzXqFqBWnTEeYw2oU+Xk
	VYEtSNmzuyHzLZL+RAMOOJClWlGQppkv1WYMSBwDxEvg5Lym51yyfQIjaGIv3Mzh57PGmlKxiwz
	5orNrf16qGIlq7fPvAQSfJhqsPsiTVjWH1QM6XNlL2XI37JfITgVBsYGaeCYfp4cdisWyF7BWFe
	c41rmCNGTy9FgUIQODeD6igiy7rfWy3j/XwTOp/oeBgeo1p3zDGOcMhwaKvROzun88MZ/jDvTCV
	DbuAvFUb30rya3bN4hY=
X-Received: by 2002:a05:6102:1624:b0:7c3:5d0:3028 with SMTP id ada2fe7eead31-7cb372122a9mr115807137.2.1791506142814;
        Thu, 08 Oct 2026 17:35:42 -0700 (PDT)
Received: from localhost.localdomain ([132.170.205.109])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7cb3539092esm488922137.3.2026.10.08.17.35.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Oct 2026 17:35:41 -0700 (PDT)
From: Sanan Hasanov <sanan.hasanou@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Sanan Hasanov <sanan.hasanov@ucf.edu>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+fa495e1497c48a6ed885@syzkaller.appspotmail.com
Subject: [PATCH v4 1/4] scsi: target: rd: Fix oversized sg table array allocation
Date: Thu,  8 Oct 2026 20:35:31 -0400
Message-ID: <20261009003537.62265-2-sanan.hasanou@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20261009003537.62265-1-sanan.hasanou@gmail.com>
References: <20261009003537.62265-1-sanan.hasanou@gmail.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sanan Hasanov <sanan.hasanov@ucf.edu>

The rd_pages= device parameter is taken from configfs without an upper
bound. rd_build_device_space() uses it to size the sg table array, so a
large value such as INT_MAX makes it attempt a kzalloc() of roughly
64 MiB, which is above the page allocator's maximum order and triggers:

  WARNING: mm/page_alloc.c:5340 at __alloc_frozen_pages_noprof+0x294/0x874
  Call trace:
   __alloc_frozen_pages_noprof+0x294/0x874 (P)
   ___kmalloc_large_node+0x64/0xd0
   __kmalloc_noprof+0x24/0x54
   rd_configure_device+0x74/0xdc
   target_configure_device+0xa0/0x1c4
   target_dev_enable_store+0x4c/0x5c
   configfs_write_iter+0xec/0x124

A ramdisk is backed page-by-page by system memory, so a page count
larger than totalram_pages() can never be satisfied. Reject it with
-EINVAL before allocating anything. NULLIO devices allocate no backing
pages and are not affected.

The array needs 64 bytes per 2048 pages, so even a valid page count
exceeds the 4 MiB maximum order once the ramdisk is larger than 512 GiB.
Allocate the sg table arrays with kvzalloc_objs() so that large arrays
fall back to vmalloc.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Reported-by: syzbot+fa495e1497c48a6ed885@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fa495e1497c48a6ed885
Signed-off-by: Sanan Hasanov <sanan.hasanov@ucf.edu>
---
 drivers/target/target_core_rd.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 092d9fe0d..97c63b122 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -14,6 +14,7 @@
 #include <linux/string.h>
 #include <linux/parser.h>
 #include <linux/highmem.h>
+#include <linux/mm.h>
 #include <linux/timer.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
@@ -81,7 +82,7 @@ static u32 rd_release_sgl_table(struct rd_dev *rd_dev, struct rd_dev_sg_table *s
 		kfree(sg);
 	}
 
-	kfree(sg_table);
+	kvfree(sg_table);
 	return page_count;
 }
 
@@ -188,10 +189,16 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 	if (rd_dev->rd_flags & RDF_NULLIO)
 		return 0;
 
+	if (rd_dev->rd_page_count > totalram_pages()) {
+		pr_err("Page count: %u exceeds total RAM pages: %lu for Ramdisk device\n",
+		       rd_dev->rd_page_count, totalram_pages());
+		return -EINVAL;
+	}
+
 	total_sg_needed = rd_dev->rd_page_count;
 
 	sg_tables = (total_sg_needed / max_sg_per_table) + 1;
-	sg_table = kzalloc_objs(*sg_table, sg_tables);
+	sg_table = kvzalloc_objs(*sg_table, sg_tables);
 	if (!sg_table)
 		return -ENOMEM;
 
@@ -248,7 +255,7 @@ static int rd_build_prot_space(struct rd_dev *rd_dev, int prot_length, int block
 	total_sg_needed = (rd_dev->rd_page_count * prot_length / block_size) + 1;
 
 	sg_tables = (total_sg_needed / max_sg_per_table) + 1;
-	sg_table = kzalloc_objs(*sg_table, sg_tables);
+	sg_table = kvzalloc_objs(*sg_table, sg_tables);
 	if (!sg_table)
 		return -ENOMEM;
 
-- 
2.48.1

