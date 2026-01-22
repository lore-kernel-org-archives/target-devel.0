Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C18441054
	for <target-devel@vger.kernel.org>; Thu, 22 Jan 2026 15:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769096467; cv=none; b=kDiIexWdc9YS3e81xh5lCnFfduw417UP8+YstK835TZSfSgurY684DzMsq8zYhECvDymjP79B68Cy4nbasEiPgkQWBL9RPBNp91oudOBC5fjP7GPeM8LSsOqwRkOU9lUfEDAN9YV4rMyspHDCl0iW+1GGXBG1na3U3iojvZyZf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769096467; c=relaxed/simple;
	bh=uONlpUsG6B+1SJNCDttGGY2DFAbNfSVv6+TjnGPV9Ro=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KUi/P5Hvhk09ybmq/i9/PWrX0WuVcffcetj9CO2PfsdOPU7UkgHyGVutkbv8mcAYPEriv/M/MoL+os3E1UPzIj+jA4N7NM+JHyRfjG4FAvT2M1v7Cfazv3Jdz8qK+h0GFKyQOxhi2vjGW8ei6jSkMbNOCxT0dRrqggluLZgIm2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UInVgzqJ; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UInVgzqJ"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-81f4ba336b4so1115180b3a.1
        for <target-devel@vger.kernel.org>; Thu, 22 Jan 2026 07:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769096462; x=1769701262; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iC3BQrsx4m1KIySd6SGYfoOdN/kOmKuZK6JhgQwLLwU=;
        b=UInVgzqJdiwkrpta0q1byxIFltiwJbGYlfvUihTy1JF0VxZ1EhsDOfpEfaK1nd3awD
         aoGR4DIcNaGc5hur+fI4/Dfy4NUzWJ6T7sxdXa/K2CDXIngiw9lZZU+NwnyZUVetns9I
         5bEOzxsZp/MF6zlIFd3hw+f403B5rP6M2o2KK6F506alIzWt23EZ7AP2yabYG7Zw2Z0W
         kXLMV3IbFrh3fa66hRBG1Xu3xXjcorVd6T0uIX3QuIkOmWqn0x+GjjRt1BCPHy+A45kt
         RbC39LlbzbC1Dun65yFK840m4+2/1XTmQPWHXzMuJxU6XNhm2b0OZ2wNuV2n+cTT7K4x
         RG7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769096462; x=1769701262;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iC3BQrsx4m1KIySd6SGYfoOdN/kOmKuZK6JhgQwLLwU=;
        b=jV04ZNnzM4F5xUBWygBATsytSux7crPFf/GNR145sLbkG1JhuCxhy/FlU8MH6DQQBJ
         ZkC/XOyuyzLOKDMGDzxy9I8V4Bg5higGhOF9TYCLaLMh33ksCGD4Nzr6iXic+1oAWEzX
         3NX/Xuyi3+GkvRLbf0AmdBTmnTwx5s3HRwVqwNquJ1YGqlX1PcJKEilgWzqgrA40AaWp
         KTQUOIsE3gyB7soopluhy9A+i/SFdpyHumUgtIP1t+fatMipNRYd53zIYE70jzB6zGp8
         94PZ6xTrRKne7ocDZxE99o6FViJwIJ6k0WrF/RNhAKrpcJYjvoetFyOy/7wVVytcVlZV
         E4sQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSYVXxBdNpQOlbk8wo48pqtMAYlGtCAR09c7AThPegunLo6XP4hDPyAfT6GAbBLbaVaetRBgv+4zAe0Ek=@vger.kernel.org
X-Gm-Message-State: AOJu0YylBPLjb+H9B2MXLnGXbp6HFs7W4JRuHEBDiPYmo6PbzptRKNtP
	zYl6m+12A4C1lL5Z4bFqdSq9fQshE0/nE4bQpyVA2Z06LDNa7slNHIql
X-Gm-Gg: AZuq6aIVfySjRlkRPDAUv/bcsxZV+o+TAf30j2KzMpPQPsYz/L81M8Q6U2H5KAwqm7a
	mTHGEOVg2wo39K28/SmIN84FKkK0q0CrgJ7WuT8vcn0NqFLcVtOQ8TPZulpqi7wza/6wk8XTgSk
	kt2/2bj0QfB4+lKv+I8wvNPZs/8LtVrgEHqpajFJY9reDNbddkiXxGOutWd9MH9KIT38rFiDfuL
	MbI3zS0pgHyr2JijCgyK8+mQz+QZKoO7w0UcFhLcT4Rb0Av/l7x3vvr+jYnnQVBWNmZnch0PcHR
	pO6tZkC/LyrBPf0/YHkA23ZJIDDa41XjdJ3NBUVi87K/TrMLsnghIatgRhF6Q1WV8TQRh82RjJz
	w6EYAvy6dhQiEhu0LZyP8fi4gCuNR1SsrzUSmK9CKhF3yiVsz5qKO0CqL6sIYeJ9dj33ONE1qcx
	3jXMHJxGiNJC2eWbmVjzkXdJI+nOQ1
X-Received: by 2002:a05:6a00:1302:b0:823:1117:39e6 with SMTP id d2e1a72fcca58-82311173ef0mr798121b3a.33.1769096462238;
        Thu, 22 Jan 2026 07:41:02 -0800 (PST)
Received: from localhost.localdomain ([111.125.231.221])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82181d6f7f7sm3474462b3a.50.2026.01.22.07.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 07:41:01 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: martin.petersen@oracle.com,
	d.bogdanov@yadro.com,
	bvanassche@acm.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	khalid@kernel.org,
	Prithvi Tambewagh <activprithvi@gmail.com>,
	syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH v2] scsi: target: fix recursive locking in __configfs_open_file()
Date: Thu, 22 Jan 2026 21:10:51 +0530
Message-Id: <20260122154051.64132-1-activprithvi@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In flush_write_buffer, &p->frag_sem is acquired and then the loaded store
function is called, which, here, is target_core_item_dbroot_store().
This function called filp_open(), following which these functions were
called (in reverse order), according to the call trace:

down_read
__configfs_open_file
do_dentry_open
vfs_open
do_open
path_openat
do_filp_open
file_open_name
filp_open
target_core_item_dbroot_store
flush_write_buffer
configfs_write_iter

target_core_item_dbroot_store() tries to validate the new file path by
trying to open the file path provided to it; however, in this case,
the bug report shows:

db_root: not a directory: /sys/kernel/config/target/dbroot

indicating that the same configfs file was tried to be opened, on which
it is currently working on. Thus, it is trying to acquire frag_sem
semaphore of the same file of which it already holds the semaphore obtained
in flush_write_buffer(), leading to acquiring the semaphore in a nested
manner and a possibility of recursive locking.

Fix this by modifying target_core_item_dbroot_store() to use kern_path()
instead of filp_open() to avoid opening the file using filesystem-specific
function __configfs_open_file(), and further modifying it to make this
fix compatible.

Reported-by: syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f6e8174215573a84b797
Tested-by: syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
---
Changes since v1:
 - Update commit message to reflect the fact that same file, which code was 
   currently operating on, was tried to be opened again, leading to 
   acquiring the same semaphore in nested manner & possibility of recursive
   locking.

v1 link: https://lore.kernel.org/all/20260108191523.303114-1-activprithvi@gmail.com/T/ 

 drivers/target/target_core_configfs.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index b19acd662726..f29052e6a87d 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -108,8 +108,8 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
 					const char *page, size_t count)
 {
 	ssize_t read_bytes;
-	struct file *fp;
 	ssize_t r = -EINVAL;
+	struct path path = {};
 
 	mutex_lock(&target_devices_lock);
 	if (target_devices) {
@@ -131,17 +131,18 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
 		db_root_stage[read_bytes - 1] = '\0';
 
 	/* validate new db root before accepting it */
-	fp = filp_open(db_root_stage, O_RDONLY, 0);
-	if (IS_ERR(fp)) {
+	r = kern_path(db_root_stage, LOOKUP_FOLLOW, &path);
+	if (r) {
 		pr_err("db_root: cannot open: %s\n", db_root_stage);
 		goto unlock;
 	}
-	if (!S_ISDIR(file_inode(fp)->i_mode)) {
-		filp_close(fp, NULL);
+	if (!d_is_dir(path.dentry)) {
+		path_put(&path);
 		pr_err("db_root: not a directory: %s\n", db_root_stage);
+		r = -ENOTDIR;
 		goto unlock;
 	}
-	filp_close(fp, NULL);
+	path_put(&path);
 
 	strscpy(db_root, db_root_stage);
 	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);

base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
-- 
2.34.1

