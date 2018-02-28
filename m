From: Andrei Vagin <avagin@gmail.com>
Date: Wed, 28 Feb 2018 03:06:50 +0000
Subject: target can submit bio-s with lengths unaligned on sector size
Message-Id: <20180228030649.GA3893@gmail.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hello,

I found that iscsi target with a block device as backing store can
submit bio with a length which isn't aligned on the sector size (512)
(steps to reproduce bellow). The behavior of the kernel isn't defined in
this case. If we read the code, we can find that such requests
probably will be handled incorrectly. Here are a few example which shows
that a generic code isn't ready to handle such bio-s:

include/linux/bio.h:
...
#define bio_sectors(bio)        ((bio)->bi_iter.bi_size >> 9)
#define bio_end_sector(bio)     ((bio)->bi_iter.bi_sector +
bio_sectors((bio)))

block/blk-merge.c:
...
                sectors += bv.bv_len >> 9; 


drivers/md/dm-thin.c:
...
        sector_t e = b + (bio->bi_iter.bi_size >> SECTOR_SHIFT);


drivers/md/dm.c
...
        unsigned bi_size = bio->bi_iter.bi_size >> SECTOR_SHIFT;

fs/buffer.c:
...
        if (likely((bio->bi_iter.bi_size >> 9) <= maxsector))


Last time this behaviour was change in this commit:
commit 4c054ba63ad47ef244cfcfa1cea38134620a5bae
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Thu Aug 16 15:33:10 2012 -0700

    target: Fix ->data_length re-assignment bug with SCSI overflow

Now I try to figure out how to fix this properly. If you have any ideas
or advices, you are welcome.

Steps to reproduce:

[root@fc24 ~]# losetup -f ~/image

[root@fc24 ~]# targetcli
targetcli shell version 2.1.fb46
Copyright 2011-2013 by Datera, Inc and others.
/> cd backstores/block
/backstores/block> create  loop0 /dev/loop0
Created block storage object loop0 using /dev/loop0.
/backstores/block> cd /iscsi
/iscsi>
/iscsi> create
Created target iqn.2003-01.org.linux-iscsi.fc24.x8664:sn.5e89a50a68f0.
Created TPG 1.
Global pref auto_add_default_portal=true
Created default portal listening on all IPs (0.0.0.0), port 3260.
/iscsi> cd iqn.2003-01.org.linux-iscsi.fc24.x8664:sn.5e89a50a68f0/tpg1/
/iscsi/iqn.20...a50a68f0/tpg1> set attribute authentication=0
Parameter authentication is now '0'.
/iscsi/iqn.20...a50a68f0/tpg1> set attribute generate_node_acls=1
Parameter generate_node_acls is now '1'.
/iscsi/iqn.20...a50a68f0/tpg1> cd luns
/iscsi/iqn.20...8f0/tpg1/luns> create  /backstores/block/loop0
Created LUN 0.
/iscsi/iqn.20...8f0/tpg1/luns> exit
Global pref auto_save_on_exit=true
Last 10 configs saved in /etc/target/backup.
Configuration saved to /etc/target/saveconfig.json

[root@fc24 ~]# IQN=iqn.2003-01.org.linux-iscsi.fc24.x8664:sn.5e89a50a68f0
[root@fc24 ~]# iscsiadm -m discovery -t st -p 127.0.0.1
127.0.0.1:3260,1 iqn.2003-01.org.linux-iscsi.fc24.x8664:sn.5e89a50a68f0

[root@fc24 ~]# iscsiadm -m node -T $IQN -l --portal 127.0.0.1
Logging in to [iface: default, target:
iqn.2003-01.org.linux-iscsi.fc24.x8664:sn.5e89a50a68f0, portal:
127.0.0.1,3260] (multiple)
Login to [iface: default, target:
iqn.2003-01.org.linux-iscsi.fc24.x8664:sn.5e89a50a68f0, portal:
127.0.0.1,3260] successful.

[root@fc24 ~]# sg_raw -r511 /dev/sda 28 0 0 0 0 0 0 0 9 0 -R
SCSI Status: Good

Received -3586 bytes of data:

[root@fc24 ~]# dmesg -c
[  142.815103] TARGET_CORE[iSCSI]: Expected Transfer Length: 511 does
not match SCSI CDB Length: 4608 for SAM Opcode: 0x28

And I see that a bio with bv_offset=0 and bv_lenQ1 was submitted to
the loop device in this case.

Thanks,
Andrei
