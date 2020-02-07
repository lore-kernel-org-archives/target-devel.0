From: Pavel Zakharov <pavel.zakharov@delphix.com>
Date: Fri, 07 Feb 2020 18:48:51 +0000
Subject: [LIO-target] BUG: Deleting a LUN hangs in transport_clear_lun_ref
Message-Id: <9A92D656-A796-4858-85CD-3750BDACFA28@delphix.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: martin.petersen@oracle.com, bvanassche@acm.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

The issue is that deleting a LUN on the target will hang until IO is attempted to this LUN from the initiator.

I suspect the following patch introduced a regression:

commit 83f85b8ec305be9d65284de2921d8eeb6c7fcf12
Author: Bart Van Assche <bvanassche@acm.org>
Date:   Fri Jan 25 10:34:46 2019 -0800

    scsi: target/core: Inline transport_lun_remove_cmd()

REPRODUCER:

Target: Ubuntu 18.04.4 LTS running 5.3.0-28-generic
Initiator: Windows Server 2012 Build 9600
Both Running as VMs on ESX

1. Ubuntu: Upgrade & Install packages
$ sudo apt dist-upgrade && sudo apt install linux-image-generic-hwe-18.04 targetcli-fb && sudo reboot

2. Ubuntu: Setup iSCSI Target
$ sudo targetcli /iscsi create
Created target iqn.2003-01.org.linux-iscsi.ubuntu18.x8664:sn.6efb4b5956b3.
Created TPG 1.
Global pref auto_add_default_portal=true
Created default portal listening on all IPs (0.0.0.0), port 3260.
$ sudo targetcli /iscsi/iqn.2003-01.org.linux-iscsi.ubuntu18.x8664:sn.6efb4b5956b3/tpg1/acls create wwn=iqn.1991-05.com.microsoft:10-44-13-164.ad.delphix.com
Created Node ACL for iqn.1991-05.com.microsoft:10-44-13-164.ad.delphix.com
$ sudo targetcli /backstores/fileio create filedisk1 /filedisk1 1G
Created fileio filedisk1 with size 1073741824
$ sudo targetcli /iscsi/iqn.2003-01.org.linux-iscsi.ubuntu18.x8664:sn.6efb4b5956b3/tpg1/luns create lun=0 storage_object=/backstores/fileio/filedisk1
Created LUN 0.
Created LUN 0->0 mapping in node ACL iqn.1991-05.com.microsoft:10-44-13-164.ad.delphix.com

3. Windows: Connect to iSCSI target, then go to Disk Management: Rescan Disks, Online Disk, Initialize Disk, Create Volume

4. Ubuntu: Delete LUN
$ sudo targetcli /iscsi/iqn.2003-01.org.linux-iscsi.ubuntu18.x8664:sn.6efb4b5956b3/tpg1/luns delete 0
<Command hangs here>
In another window:
$ sudo cat /proc/$(pgrep targetcli)/stack
[<0>] core_tpg_remove_lun+0x35/0x100 [target_core_mod]
[<0>] core_dev_del_lun+0x26/0x70 [target_core_mod]
[<0>] target_fabric_port_unlink+0x4a/0x50 [target_core_mod]
[<0>] configfs_unlink+0xea/0x1b0
[<0>] vfs_unlink+0x111/0x200
[<0>] do_unlinkat+0x2ad/0x320
[<0>] __x64_sys_unlink+0x23/0x30
[<0>] do_syscall_64+0x5a/0x130
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Left for some time, you can see this in dmesg:
[ 1330.438613] INFO: task iscsicmd:24572 blocked for more than 120 seconds.
[ 1330.439554]       Tainted: P           OE     5.3.0-26-generic #28~18.04.1-Ubuntu
[ 1330.440594] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1330.441666] iscsicmd        D    0 24572   8910 0x00000080
[ 1330.441668] Call Trace:
[ 1330.441674]  __schedule+0x2a8/0x670
[ 1330.441676]  schedule+0x33/0xa0
[ 1330.441678]  schedule_timeout+0x1d3/0x2f0
[ 1330.441682]  ? __kfifo_to_user_r+0xb0/0xb0
[ 1330.441684]  wait_for_completion+0xba/0x140
[ 1330.441688]  ? wake_up_q+0x80/0x80
[ 1330.441704]  transport_clear_lun_ref+0x27/0x30 [target_core_mod]
[ 1330.441711]  core_tpg_remove_lun+0x35/0x100 [target_core_mod]
[ 1330.441716]  core_dev_del_lun+0x26/0x70 [target_core_mod]
[ 1330.441721]  target_fabric_port_unlink+0x4a/0x50 [target_core_mod]
[ 1330.441724]  configfs_unlink+0xea/0x1b0
[ 1330.441727]  vfs_unlink+0x111/0x200
[ 1330.441729]  do_unlinkat+0x2ad/0x320
[ 1330.441731]  __x64_sys_unlink+0x23/0x30
[ 1330.441734]  do_syscall_64+0x5a/0x130
[ 1330.441736]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

5. Workaround: Windows: Rescan Disks. This will send some IO to the LUN and let the task resume

ANALYSIS

From my debugging, the issue is that a lun_ref is being held at all times by an iscsi_cmd that is in iscsi_conn.conn_cmd_list.
Normally iscsit_ack_from_expstatsn() is supposed to take care of cleaning up iscsi_conn.conn_cmd_list, however due to the "iscsi_sna_lt(cmd->stat_sn, exp_statsn)” check, the latest command is always left on that list.
Prior to the patch that removed the explicit call of transport_lun_remove_cmd(), the lun_ref would be cleaned up whenever the command would be completed. So even if the command was still in iscsi_conn.conn_cmd_list it would not hold a lun_ref.

I’ve done some live tracing and compared the 5.0 kernel (which doesn’t have the issue and the patch) with the 5.3 kernel, and as soon as some IO as performed on the LUN on the 5.3 kernel there is always this outstanding lun_ref.
I didn't dig as to why sending IO to a LUN that is being deleted unblocks the deletion, but my guess is that new lun_refs are not created because percpu_ref_tryget_live() fails, however iscsit_ack_from_expstatsn() is then run with a higher exp_statsn, so it frees up the iscsi_cmd that was holding the previous ref.

Using bpftrace while the deletion was hanging and running Rescan Disks on the initiator did somewhat confirm that:
$ sudo bpftrace -e 'k:core_tpg_lun_ref_release{printf("%s",kstack())}’
...
        core_tpg_lun_ref_release+1
        transport_generic_free_cmd+117
        iscsit_free_cmd+89
        iscsit_ack_from_expstatsn+393
        iscsit_process_scsi_cmd+62
        iscsit_get_rx_pdu+1635
        iscsi_target_rx_thread+187
        kthread+289
        ret_from_fork+31

I haven’t yet tried rebuilding the kernel with the patch reverted, but that is the next step I’m planning to try once I figure out how to do it.
