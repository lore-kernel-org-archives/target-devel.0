Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795872587;
	b=pXTjJabmiQumDJgKb+hIO4hc/URU+afh3JqjB1pElPbznmVMlz0TFbqkHhhC2ZMEaBlz
	 hlwnEKr4BwqN8s9upalvH56jRguP+D4dGqTQSyHNs3auVuRKZfgrjjO6Q7hbXh7Akm9Ov
	 99XaJtYj85xYqTwZcnLHMecCn1d5+P5j9Tlc0T7fn5He+AZZzrRLuqYkb++Q3pE5LSiqP
	 6uta6ebCwYU37b/SibhnF6ZnV/G5lYP5P/Olwpnk0PfXAoXzyrMxzq0QSmZLSUIgzLRl4
	 8haVlNlvM6jquBYcz4ZL9WaSyzpVMdWyGUhEUs8D7pyFsKzZtENf79BeC0qo5oM+3ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795872587;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=JpG4BmIeBWZQ5XHLHes+EMm77sbfxTu2hLavRKMyG5M=;
	b=fnSSN4DZ1byEPyTXIBxbAWNY8Pe/JGDfcVi2wQT99bhoSC4pjJlkpyQaKiMqerlFhHes
	 JCb9oHQZFJhqRJBuIT/rPxK78DSHu36lboGWc7dHmYYp5k81MYNy5s//niBZtPuFROPhM
	 EW2KjDJ8c0XH8ZRu2sdGXix4nTymnq3W1w/cA9hRI0wG8Z4GHAx8kzTV9jONv2kODzHhK
	 0AQZay5l2+I8YpFkCOqLo5/r4/v9Q5XIup99egl3oFpbTSdSd8V2eujYHoL3ivIxkc5Z/
	 DvEkIbgALVzVZCg2du2LKpHOujmgNfRKqjlDjXv1Xr7fT5srxPETc8Ryd2KS4uUKEDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=FP28DAvH;
	arc=none smtp.remote-ip=115.124.30.133
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F6E606A31F;
	Sat, 28 Nov 2026 13:29:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3F6E606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=FP28DAvH
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795872577; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=JpG4BmIeBWZQ5XHLHes+EMm77sbfxTu2hLavRKMyG5M=;
	b=FP28DAvHVdCGTC5C8AXxm5/jZCBEBnGn0xjKvWOULrEvbzMuZMVcFVVt88LbaSriBr/mVuo7BtjjIQpV7dlUuLCquaaOT5P9F8lIXdqaslO8ut3rAR3IcdropAIc/InNsObExIxeBk2MsE8YZIyNsR8BVsMytSMOpkLSmEKxSqk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=zoutao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0XFaYYMD_1795872576;
Received: from localhost(mailfrom:zoutao@linux.alibaba.com fp:SMTPD_---0XFaYYMD_1795872576 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 28 Nov 2026 21:29:37 +0800
From: Tao Zou <zoutao@linux.alibaba.com>
To: Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	Tao Zou <zoutao@linux.alibaba.com>
Subject: [PATCH v2 1/1] tcmu: Fix inode use-after-free in global data block pool
Date: Sat, 28 Nov 2026 21:29:34 +0800
Message-Id: <20261128132934.11219-2-zoutao@linux.alibaba.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20261128132934.11219-1-zoutao@linux.alibaba.com>
References: <20261127023346.37933-1-zoutao@linux.alibaba.com>
 <20261128132934.11219-1-zoutao@linux.alibaba.com>
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

tcmu_open() stores the character device inode in udev->inode, but
tcmu_release() does not clear it.  If tcmu-runner exits while the LIO
configuration remains, delayed global data-block reclaim can later
dereference the stale inode in unmap_mapping_range() after the VFS has
freed it.

The open file and its VMAs already keep the inode alive while mappings
exist, so no additional inode reference is needed.  Protect the pointer
with cmdr_lock, clear it in tcmu_release(), and skip only the mapping
invalidation after the final close.  Block reclamation still runs.

Fixes: b6df4b79a551 ("tcmu: Add global data block pool support")
Signed-off-by: Tao Zou <zoutao@linux.alibaba.com>
---
 drivers/target/target_core_user.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Changes in v2:
- Drop the extra inode reference, which did not pin the mount or
  sb->s_active and could leave a busy inode during filesystem unmount.
- Clear udev->inode in tcmu_release() and skip only mapping invalidation
  after the final close; block reclamation still runs.
- Test the original reproducer and a separate tmpfs unmount, reopen,
  delayed reclaim and device destruction scenario.

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 80da90a..481b16f 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1959,7 +1959,9 @@ static int tcmu_open(struct uio_info *info, struct inode *inode)
 	if (test_and_set_bit(TCMU_DEV_BIT_OPEN, &udev->flags))
 		return -EBUSY;
 
+	mutex_lock(&udev->cmdr_lock);
 	udev->inode = inode;
+	mutex_unlock(&udev->cmdr_lock);
 
 	pr_debug("open\n");
 
@@ -2000,6 +2002,7 @@ static int tcmu_release(struct uio_info *info, struct inode *inode)
 	if (freed && list_empty(&udev->tmr_queue))
 		run_qfull_queue(udev, false);
 
+	udev->inode = NULL;
 	mutex_unlock(&udev->cmdr_lock);
 
 	clear_bit(TCMU_DEV_BIT_OPEN, &udev->flags);
@@ -3255,7 +3258,9 @@ static void find_free_blocks(void)
 
 		/* Here will truncate the data area from off */
 		off = udev->data_off + (loff_t)start * udev->data_blk_size;
-		unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
+		/* All VMAs are closed before the last fput calls tcmu_release(). */
+		if (udev->inode)
+			unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
 
 		mutex_unlock(&udev->cmdr_lock);
 
-- 
2.39.5 (Apple Git-154)

