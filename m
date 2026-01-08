Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F122D73B6
	for <target-devel@vger.kernel.org>; Thu,  8 Jan 2026 19:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767899736; cv=none; b=L9P0xjOy8cU0b678KRNq3Hefeyhxc9Rd6BCIl59tjqo/ULlUZu/p6Q3Jw0ETigHTVi2fO0zrVZWUBAIl1UCZ3Hfm9WW2L2OUcfh0DTqjeY5ws+32QVTpKJabtQAfJJLtOPTgL4VFb2xLW9yUsFrY0PVV+ktXNP/mMiPS3xEMk4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767899736; c=relaxed/simple;
	bh=DQveYroOYvzQQaZj9xZbwVjXxac8T+c9fvoK8rVsEWc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fLoFpdjstz4vJvTC5k7CWNlPlyImrgx6TOJ4DG1Tv6u772DIPJvMII+cwiBPPYgGqC+ttZhc/EbYAHEYIces+EsmEVLbUqrBfZ4fKCY3OL+13kCyU6kY27hM/0Q05ZxTfjfyxa/LkiJGoROxxpJtcX47GTMQy3+SEEwyT6ZNpQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e25stFvx; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e25stFvx"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7b89c1ce9easo2503332b3a.2
        for <target-devel@vger.kernel.org>; Thu, 08 Jan 2026 11:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767899734; x=1768504534; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rbveBA5EpSAql35W21g5vkaIwp+rRmrP5kRX4QDiu4U=;
        b=e25stFvxPFF4SjgehQEdGtUnVnoemurdrDXXUu9cw4Un56pfeJ/rKdMDA5SN+Bg/LX
         93801B+CpC+D8eehVm+aG/6tzPrpuW/Z74a/lU1rDhRXr/ofMp/dOyAqIBqiP4Ri/aPA
         9DyC3uqVZ22G8pyMh5ya7q5e2GGB3bEzpsBzVkliNFwTJXlirOvGtaNuOqWoSt0hcEJF
         RajnHGW27dumNospZalVJVS9b1b/Zxb8AFUvodtQZSHGfDJ46LBZ1If2BZHwBzmDnIPu
         YewUtxWFvOlvmdgsyUwDuEIiF+cYrxCN9oEshn6qrJg+ZJ73fccw4h0Ac+R1ubJ2wZ38
         jcyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767899734; x=1768504534;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rbveBA5EpSAql35W21g5vkaIwp+rRmrP5kRX4QDiu4U=;
        b=MfJX4LUo0HgeJHfNaNb69qDVKCskF/ffzIFTRsCJtN6GfMelavRMNiGGpWzGPSIkP9
         TXLsZvhImNzdVasXD99WuocBs1CXYQkl+zNV3CqOGgOGYDvkZ0Dcw8G6d5Az3rzy+Hth
         98ZYKkUxjfJKL6lHIgJ3diDuXNK00yLmlyo2DkG2Tb3InR71QCfJaeNMRkhqIXLMTolL
         AGsEaj5YT7+QdvfXhBqOJ7/GwHclWwjFN5L4UVMzGpEQ3L44Qsi4ukf5nWi2yUoE1R1U
         hGBryTRtEGL1Rro55/U4fLKE+ZhJIMmeWSOmzutKiNsfvIMkcKO00OLjSva+2JvJXj8+
         cNaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXmGV085EFgvxmHdMHWeeqFROQCMlYbz4lsYL5d9wrF864ZLUQQOfHHDvOU6E77ASG0YZPVoqM3VtkwVZg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1LOiAEyDMmIjeYLeaylX3mFsmUeJQkA3OxFRBnVlzzqUh0jPt
	r7L6QjKwhiS/1op2gzqq0aknUvVbSQUNqwojzokBv89NI0g5rz7Pe5mioYaULQ==
X-Gm-Gg: AY/fxX68yuCILa6hk9AyZniPfjSPL3T272XA25of5RxnhF7de9C3nDQPQNaQmZ8Jj2g
	gCBbFeFkdgXn+MbudFlPlqE6gdte+U332LZ3IIuujgQAwi+BsfktGy+b9ol4BSYgifQmFCzgrV8
	7TSBV4TDyHPCezXezHoO8N59ZNtcWRTva/rt3m+CuMy16Q+E5KF1dfBXNTsyYoQ6lh0QtNEKGXj
	NciQaV5cwtJLOTVUY/4tU4e7N8ugMPg0j2YM0fPR9J+Gxb0MzCuB3tR2IprucKUJ/y2TYbcuYF0
	naknx8LAvOblAfbJjphWlyJUXg14CXdspgtGr7bPQZUrIs1t+tQh5lqgk5cTiwNw/fOY/pB7lNw
	b3TgtKpqNu6+3D3EhFWoJeV/1kdAqn5gjRThCdC6ssvLxtbTDJ1Jrwg8As+cvRpmL+cWWEKI/WN
	5nAII7KzVrmxmIsH5A9OKrunUyUGQ=
X-Google-Smtp-Source: AGHT+IE7/FzJIxSueg1FJANL4zzf06HltgWTqmNS37F5ymZQV5xCo448U9br6f7GBf0Ggq401yHQeg==
X-Received: by 2002:a05:6a20:12c8:b0:366:5bda:1ebd with SMTP id adf61e73a8af0-3898f8888d4mr6519772637.2.1767899733860;
        Thu, 08 Jan 2026 11:15:33 -0800 (PST)
Received: from localhost.localdomain ([111.125.210.92])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c4cc8d29521sm8616053a12.23.2026.01.08.11.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 11:15:33 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hch@lst.de,
	jlbec@evilplan.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	khalid@kernel.org,
	Prithvi Tambewagh <activprithvi@gmail.com>,
	syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH] scsi: target: Fix recursive locking in __configfs_open_file()
Date: Fri,  9 Jan 2026 00:45:23 +0530
Message-Id: <20260108191523.303114-1-activprithvi@gmail.com>
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

Hence ultimately, __configfs_open_file() was called, indirectly by
target_core_item_dbroot_store(), and it also attempted to acquire
&p->frag_sem, which was already held by the same thread, acquired earlier
in flush_write_buffer. This poses a possibility of recursive locking,
which triggers the lockdep warning.

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

