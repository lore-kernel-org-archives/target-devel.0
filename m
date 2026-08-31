Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8893E1231
	for <target-devel@vger.kernel.org>; Mon, 31 Aug 2026 09:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788168397; cv=pass; b=qBqDS4CvWEwpBwa3hH3FznrV+Ra2dDbCjU0UCZVOiZJzGymcFcfAMz30JEQeQDGj5iZvki00xpDK1B3VFqrYIEVqsVgEqbHqTNkTbEa654vGWhQ2nnnZj6q1OhLz9PNpcI4uu6KXAuTkQZTrlDmHApdMFYxK2mxYLxf0q4bZETc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788168397; c=relaxed/simple;
	bh=GBTgWejtGdJAKdiFr7UJ4AwaGexhIKwa4b9R0XxIbeg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=eeQF0UY2jnOGe+v5s3du5oij3uFzY/WXzMsSNlezc/gLFNtYQHqgPW0US7D6ZDQVUEO4TVu/lvQV0zNYbzwK9YiXMqH1/TES3JwD7vWznU6z10X7xBZMPHXtJh6N7AAw+w27B1M+99APZOQT2vo/qH88zuHUzKn5i+zHJu+Izrs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PeHql9S5; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PeHql9S5"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-52e2d1bdbc0so22168431cf.0
        for <target-devel@vger.kernel.org>; Mon, 31 Aug 2026 02:26:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788168395; cv=none;
        d=google.com; s=arc-20260327;
        b=OvgzENnip9LX1IwyMZgew561c9/I7xH6NWOP8Fy6oqHcaD5+lxV8N+lt5/5MgsmC+U
         520p0dvM51N51BYBaH0SA1g91fsP2L7GEcjOU9PEvy0glgjlOhQYIPa1RmHevgeshpc+
         fECRH9NPa5ieW1G0GHrXVcWxOJ8m9fXL47gPPHQ28ggvl8jJFQMBNPPjRSGeaFZ4F4XC
         qQYZSiwQIlCJR14qh5Zi7n51DQEsCCYam/lbiOIXqQj3mZQgrPyzIdbN+vVPInwNf/6h
         rc/eny/aZmnLKXq7T/gZD/vQyOKg8FlTA5Z9yqrZN4RzdavLUM/+oZCsdc6ekzV63ejF
         F0yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Oc557eT+uz9yntWQBXBtcxG6zb+6RfKcRPnFhGyakfY=;
        fh=3i9Mt5aGI12d4+r23vnPE/ppw7xVw3CnpKbscC7nu3E=;
        b=m8vTzwYfnokaiIQoC2yzIX2PpZJqLBwS7fx6gJLektBPfGCBrJAAig8UuLEg+0R2Sc
         JqP/wAok4IrSc4i0/ti/wzkr6UGbO0uqPeoLSxRjFnxKA7u1Ipb6mnOFg32MtOz6oJLt
         63rOsQslF3QCkxL1jiGDKCZWV/kZhvlhuXLRk68Wm79V1I2XnmvSTLUN2iUDQIrvW9F9
         c93yJA2ZctpOW85YeM+9h79v6/0ilmEU1VXEmUmCN3BChB+ng+lFfIu6742iGFEcHVPr
         W3tNhLWOZcaS9x1wFLIE4g+XxbfA1Et91qVE+mKis6zCj33L1Rgo8JxVCydcldC+WEFB
         4N2w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788168395; x=1788773195; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Oc557eT+uz9yntWQBXBtcxG6zb+6RfKcRPnFhGyakfY=;
        b=PeHql9S5/0kZwqz0rUaDXl00/w+wPsflJNITbSpescVsDLVU+tCfW+BVz+BCfOM/9T
         K9ZnzCgRwecSwHxcq+bXdaSFzBDTJ3RVMOtDopQXg+QVhqCNIaX/S4Nok+sOjDczPT/9
         mlOei57B5PeK4kNCgw28NXK57/B8zgDc8C4G7R40GABAXnYC3u66tEeuFgHYVfheyqKg
         lvLDoYISZSMAlwWXYD9Dt98ncKoyHqJa7l8167tV7/c0GvNe3B51IohkMirkd3wItdn5
         MJ1l5JfJ83jU3rZ1Ru4NyKUs9fkls1xHFvJXVih06+owmYis+zJw60ryisUkcwWIRAmC
         yLWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788168395; x=1788773195;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Oc557eT+uz9yntWQBXBtcxG6zb+6RfKcRPnFhGyakfY=;
        b=Gm6tgmRB1O4yzJGSNVF15b3+b3ht09UhgsxYzs3IUsiHIyqZ+QF8guEtb5HnRbSSPg
         FbY2n/kEEFubIyJs9FxZz/iREvBHbknfwpF/EHeIttSQ8Wia25RbOWzk8zC5VD9QgK/o
         fH8ylqZqqSNwbRhHR5BOFQWQDt5BkfyVqwUy7FhFcMaLo0Qp+704C105mBiaxf2e7uQX
         B6vYZb4S/MJh6v1wnn9Y4Ul/u7LBoCDb1ZN0djHlUf+htwJbn1Y9Sqef0nSPYzw5moTz
         kd1I7OGhIakKnR1ZmsXwQOMFHfzzVn/ZTmPsSYrInkAn7cxAi0vT8AZpgXBBPotI+99E
         Rpmw==
X-Forwarded-Encrypted: i=1; AHgh+RqIDjgV+5t2ASMgTcaCXIVxSqKAW+eUD6Lqy3bZxyfhFksICTWjT2Mkn46lyMn7CEnQ8/QiPCrHg6JaxEk=@vger.kernel.org
X-Gm-Message-State: AFuF++m+Xb0h2RUjO31eiG2dGAyQzzolRyccXwfc/rLMzCqC42/GC4qT
	twmnCKmpi+USlAf34UHQXFDN4UnwA6McABQwham5/CxMATWZAIY2s3sU4+5eaQR3RTBmblnMVS3
	gjV+l8Qfg+Rf1SXXW3zExruGua1e5SYk=
X-Gm-Gg: AR+sD12CX9/sd42mq8Gv0biUxHlMl6FErKxg6T3T8z33r8HaWkb6zWbpTnUsdP8eHbk
	+Ee/O9OU4Mbc9Cxruah6uzBCiqgKxRAktLck3HM4QaZ0K+c6owNehDuj+f23BPnzQ0C8vGOptc5
	C/6g5Ib4by9vcx5XEsyc8xQvXr2aGmUcbd7sHd5j0ImLXLHEdbIEhLCr5mwAtHZBgnX/HvZ6TN5
	fKPFZXAnFpbkYT+H1ixsryEOP3fqt6k7vNakAHjSsviUk4f8wDd9L+SOJHYMcmPy1FiCg+ecHdh
	7za0ViMgSJeKi5MBCrhbvTlFnyVhLo+hVvqIXnJAfsISdpATDXKrFOeCYjZMSue7lzOtg781WkS
	W+Z9XVEtzM3sMWFfyqlcv0pe1f8EUR+a3+Qh5mtw=
X-Received: by 2002:ac8:5751:0:b0:528:583:a6ca with SMTP id
 d75a77b69052e-52fb947ce64mr298965361cf.14.1788168390317; Mon, 31 Aug 2026
 02:26:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: ZW Tang <tangzw515@gmail.com>
Date: Mon, 31 Aug 2026 17:26:19 +0800
X-Gm-Features: AcwNN1VmE5hg-mg3rivFLUTIR9ieFN67679RSw-ZKkt1qwYIsnJOkNZQM4cS9tE
Message-ID: <CAA2SOT4Hok5xOtbviX4HkeqVK_u79NZjw3+0WKZMmUQb35jORw@mail.gmail.com>
Subject: [BUG] usb: gadget: f_tcm: possible circular locking dependency in usbg_make_tpg
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I am reporting a possible circular locking dependency triggered by a
syzkaller reproducer on Linux 7.2.0-rc3. Similar issues appear to have
been reported upstream before, but I can still reproduce this warning on
Linux 7.2.0-rc3 with HEAD commit
1137d8b5df06137fb49513cc923b3b24d94cb809.

The reproducer mounts configfs, creates a USB gadget TCM function, creates
a target usb_gadget fabric TPG, and then links the TCM function into a USB
gadget configuration.

Lockdep reports a cycle involving the configfs inode mutex,
tpg_instances_lock, and the f_tcm opts->dep_lock. The current path is
creating a TPG through configfs_mkdir(). It reaches usbg_make_tpg(), holds
tpg_instances_lock and opts->dep_lock, and then calls
configfs_depend_item_unlocked(), which tries to acquire a configfs inode
mutex.

The existing reverse dependency is created by the USB gadget symlink path:
configfs_symlink() calls config_usb_cfg_link(), which calls
usb_get_function() and then tcm_alloc(), where tpg_instances_lock is
acquired.

This creates the following lock order cycle:

configfs inode mutex -> tpg_instances_lock -> opts->dep_lock
opts->dep_lock -> configfs inode mutex

This looks like a lock-ordering issue in the USB gadget TCM function /
target configfs integration. The kernel should avoid taking these locks in
opposite orders, because this can lead to an actual deadlock.

Reproducer:

syz reproducer: https://pastebin.com/raw/xHmrR2GY
console output: https://pastebin.com/raw/G4WtE3Xs
kernel config: https://pastebin.com/raw/GhP15ssA

Kernel:

HEAD commit: 1137d8b5df06137fb49513cc923b3b24d94cb809
git tree: torvalds/linux
kernel version: 7.2.0-rc3 #1 PREEMPT(full) (QEMU Ubuntu 24.10)

Relevant log:

syz.0.17/12335 is trying to acquire lock:
ffff88801e4a6280 (&sb->s_type->i_mutex_key#26){+.+.}-{4:4},
at: configfs_depend_item_unlocked+0xe8/0x460

but task is already holding lock:
ffff888058c6c918 (&opts->dep_lock){+.+.}-{4:4},
at: usbg_make_tpg+0x153/0x5e0

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #3 (&opts->dep_lock){+.+.}-{4:4}:
__mutex_lock+0x16e/0x2760
usbg_make_tpg+0x153/0x5e0
target_fabric_make_tpg+0xab/0xad0
configfs_mkdir+0x5ae/0xc50
vfs_mkdir+0x35f/0x7b0
filename_mkdirat+0x407/0x580
__x64_sys_mkdirat+0x8a/0xc0

-> #2 (tpg_instances_lock){+.+.}-{4:4}:
__mutex_lock+0x16e/0x2760
tcm_alloc+0x20/0x310
usb_get_function+0x61/0xd0
config_usb_cfg_link+0x1f6/0x3f0
configfs_symlink+0x53c/0x1180
vfs_symlink+0x180/0x4e0
filename_symlinkat+0x324/0x430
__x64_sys_symlinkat+0x9c/0xe0

-> #1 (&gi->lock){+.+.}-{4:4}:
__mutex_lock+0x16e/0x2760
config_usb_cfg_link+0x57/0x3f0
configfs_symlink+0x53c/0x1180
vfs_symlink+0x180/0x4e0
filename_symlinkat+0x324/0x430
__x64_sys_symlinkat+0x9c/0xe0

-> #0 (&sb->s_type->i_mutex_key#26){+.+.}-{4:4}:
down_write+0x91/0x200
configfs_depend_item_unlocked+0xe8/0x460
usbg_make_tpg+0x214/0x5e0
target_fabric_make_tpg+0xab/0xad0
configfs_mkdir+0x5ae/0xc50
vfs_mkdir+0x35f/0x7b0
filename_mkdirat+0x407/0x580
__x64_sys_mkdirat+0x8a/0xc0

Chain exists of:
&sb->s_type->i_mutex_key#26 --> tpg_instances_lock --> &opts->dep_lock

Possible unsafe locking scenario:

  CPU0                    CPU1
  ----                    ----

lock(&opts->dep_lock);
lock(tpg_instances_lock);
lock(&opts->dep_lock);
lock(&sb->s_type->i_mutex_key#26);

*** DEADLOCK ***
