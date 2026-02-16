Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC2D19E97B
	for <target-devel@vger.kernel.org>; Mon, 16 Feb 2026 06:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771222828; cv=none; b=ddwcpA8wS/BZx2AbgGJF/EtpkaMk07zwIX1+ovpNg2xpxJ2PFKfiS7IzZvDUG56Wde7EDW6eLtFitNC0BoDW/biRQGHWswOJeRup5Vedxl5su7NDe9uuCz2PVt+V/dwiMJ12AfmWVN9Mt3+ZUyBbYc9t0dnn4zSbgMgvHYVU36c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771222828; c=relaxed/simple;
	bh=lweh5wTqdn5NyXCEB1iITaZxpjD9zsXuEt4pDx+EBK4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BOY1VJlQqFW2cGbLWKQ1K22LYoV3cKJYcPc19lTQC1N23l7plD2XCVs/8MUU8MeJCWWMI8d6vIvAdyOJr0WuQY3xNFCDrE8YkVsjlMp7+bo9XERrLx323uDdo/66TCKTDfQQWm3plKJayJAcpHZ7jcI7q2mjZBYkOX80ekxtMdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ALAEpDBW; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ALAEpDBW"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8217f2ad01eso2314650b3a.2
        for <target-devel@vger.kernel.org>; Sun, 15 Feb 2026 22:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771222826; x=1771827626; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gq3u6/pH6XaIhkLYyxC209miQpGjF2eS8OFp0J3cin8=;
        b=ALAEpDBWJxUjzuwSWKAnp/tMqGNmMxFuwNAjeuQXGFVfxHaXlhJ+ZT8cxJX/qPwao/
         hYz0pxajX5pN/xjXORvEfNN8AMMFd1LiRivuBTmv693BuH7gqJwWHgcVVtwgqwvgxQn0
         x2h9k0gSCiHgWYDMOXBhrU9pbVgRj8k42Z3X325TwHdOLJQg+/9BMlq0X69+nC8M/NNb
         gy63Ha8sdQnw+PL5ePrmGT6RaMGKuQbCtxmQxVgy6y0HaHfmJ2rOagsVynAN6t27zh7F
         TMXqpTMeTHwOqXee/2AhBRUwg9lVJEzsXhkWbY3XvE2l2OLfNOxJW9IRe5Phn+xYd33u
         MwzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771222826; x=1771827626;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gq3u6/pH6XaIhkLYyxC209miQpGjF2eS8OFp0J3cin8=;
        b=NJBz1u55kHBoEcHv53ph51Obx61MMiHouevQJIILTth2dLSVVgr0RiTZKhfGHTd0bv
         E3kzaA6NctWREnl/SIoagWwXr2zFBrYLibSrF1cs5ndzyr3G6odabyBbNlE3dVGm2FQz
         TrkGv6WU53tEcvbPW1LMJQ1FvHS2TjY3Upp9N7OkOy+2X1oZ0s62hO0nzIENF1XgLTps
         z9BspQBMOrsAIZNcEmiSrL1nfPaUeRE4V76Vu6v+rqoIGeF8k2Wisy/mabPQfhTDwFgm
         cjibijXk0fg76j2fb72qknvEWX2yBI1X4vBSUDiqv3G+uhhYZpJSQSITfC0FzT4w5v+v
         gMeg==
X-Forwarded-Encrypted: i=1; AJvYcCUJlHvBP9THZm3Bg4mGpVDmYw/NGLQJEgW9TNFSoqOvGJ6iox56C7YwXELezopPLbSXOyQmvbV5oFot6+I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiEPonYcHiO7Gb5AOlZ0DvlD3Hz52LTIKXxiXoGGuZECGlV3+a
	zUdoXsXz8jalrLCx6ictwSfoq3vOXKIgpjColxmFh+Y9zWvHWLl50F8q
X-Gm-Gg: AZuq6aKvOSvu9fLSNAOn1RKLQirpdiNEsu6k8+meGw4mwe5pGJej92TfZ40xPZwGEtl
	eIPaHJzV4VQk9swi+E41bb3WZ3MZ2iwvL01lbKJwr2502BoGAiZTDkURYcTeurzZieDkLwfgOzn
	v4tLtt+VC9pyP7HeoMSJCz0oRCU/mEJgNYSZAouKpLU5PMbI0ZLgaa0JYJP2nE7pFNXGL3vNtdY
	xQ8bLAAAJhqqNj0LGhfDRNT+4/muG/gs4hYOpUiwgYPBl6qVHrNth0UL7qJWdL5zBrj9alB3mHR
	520K0dJBLehs857CQp/zb/qy51DUShYjyVaKWhXLlAX1Sl85oK5Ys2zfOQ4cot3+HjkBozGg5gp
	Xl7lLRRsClktMCW2O6GnURbffqMX6+Rw7pglujYdrxycaphCfwvwU3fckca8zh9AZl+Of26bS1Y
	YtAQiyJjFepKR33iszElBhHRzODd7aL0XPUKknOA==
X-Received: by 2002:a05:6a00:7543:b0:81e:12f1:d83 with SMTP id d2e1a72fcca58-824c6102ba1mr7161063b3a.42.1771222826432;
        Sun, 15 Feb 2026 22:20:26 -0800 (PST)
Received: from localhost.localdomain ([114.79.136.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824c6a626bfsm8992768b3a.28.2026.02.15.22.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Feb 2026 22:20:26 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: martin.petersen@oracle.com,
	d.bogdanov@yadro.com,
	bvanassche@acm.org,
	viro@zeniv.linux.org.uk
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
Subject: [PATCH v4] scsi: target: fix recursive locking in __configfs_open_file()
Date: Mon, 16 Feb 2026 11:50:02 +0530
Message-Id: <20260216062002.61937-1-activprithvi@gmail.com>
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
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
Changes since v3:
 - Add LOOKUP_DIRECTORY flag in call to kern_path() so as to check presence 
   of directory checks more efficiently

v3 link: https://lore.kernel.org/all/20260205162624.117957-1-activprithvi@gmail.com/T/#m175d152067817dd6e9dc1821b6fbf626e47a4007


Note:
I checked out and found that when I try to test on commit 3a8660878839faadb4f1a6dd72c3179c1df56787
(latest commit on which bug dashboard reports the bug on, in upstream repository) 
syzbot uses, in its kernel config:

CONFIG_CC_VERSION_TEXT="gcc (Debian 12.2.0-14+deb12u1) 12.2.0"

Ref: https://syzkaller.appspot.com/x/.config?x=e854293d7f44b5a5
Syzbot Reply: https://lore.kernel.org/all/6767d8ea.050a0220.226966.0021.GAE@google.com/T/#m62bc76de5549460ae98e843bb120712548489794

While when #syz test (i.e. on HEAD commit of upstream) is used, it uses, in
its kernel config:

CONFIG_CC_VERSION_TEXT="gcc (Debian 14.2.0-19) 14.2.0"

Ref: https://syzkaller.appspot.com/x/.config?x=99ac58566e9eb044
Syzbot reply: https://lore.kernel.org/all/6767d8ea.050a0220.226966.0021.GAE@google.com/T/#me8b79610e4c18a8d8a7d8d6bc249d1c7cf2f8819

However in both cases it uses:

gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Probably due to mismatch in compiler version which syzbot actually uses and 
whats present in kernel config, the build fails for the first case. However, 
the patch succeeds in fixing the bug in second case.

Earlier for v1 patch (sine v2 patch involved minor change to commit message 
and v3 involved adding a missed out Reviewed-by tag) patch the kernel builds 
as well as testing succeeded since syzbot used this in its kernel config:

CONFIG_CC_VERSION_TEXT="gcc (Debian 12.2.0-14+deb12u1) 12.2.0"

as well as used the compiler:

gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40 

Changes since v2:
 - Add Reviewed-by tag received from Dmitry Bogdanov, which was accidentally
   left to be added in v2 patch.

v2 link: https://lore.kernel.org/linux-scsi/20260122154051.64132-1-activprithvi@gmail.com/T/#u
Reference for Reviewed-by Tag: https://lore.kernel.org/all/20260108191523.303114-1-activprithvi@gmail.com/T/#mb22d0fc06e747e2b2df8320a15afd2a0670fd0e7


Changes since v1:
 - Update commit message to reflect the fact that same file, which code was 
   currently operating on, was tried to be opened again, leading to 
   acquiring the same semaphore in nested manner & possibility of recursive
   locking.

v1 link: https://lore.kernel.org/all/20260108191523.303114-1-activprithvi@gmail.com/T/

 drivers/target/target_core_configfs.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index b19acd662726..f94c242eff97 100644
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
@@ -131,17 +131,14 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
 		db_root_stage[read_bytes - 1] = '\0';
 
 	/* validate new db root before accepting it */
-	fp = filp_open(db_root_stage, O_RDONLY, 0);
-	if (IS_ERR(fp)) {
+	r = kern_path(db_root_stage, LOOKUP_FOLLOW | LOOKUP_DIRECTORY, &path);
+	if (r) {
 		pr_err("db_root: cannot open: %s\n", db_root_stage);
+		if (r == -ENOTDIR)
+			pr_err("db_root: not a directory: %s\n", db_root_stage);
 		goto unlock;
 	}
-	if (!S_ISDIR(file_inode(fp)->i_mode)) {
-		filp_close(fp, NULL);
-		pr_err("db_root: not a directory: %s\n", db_root_stage);
-		goto unlock;
-	}
-	filp_close(fp, NULL);
+	path_put(&path);
 
 	strscpy(db_root, db_root_stage);
 	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);

base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
-- 
2.34.1

