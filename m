From: Potnuri Bharat Teja <bharat@chelsio.com>
Date: Wed, 26 Feb 2020 15:54:41 +0000
Subject: Connection errors with ISER IO
Message-Id: <20200226155241.GA28594@chelsio.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="dDRMvlgZJXvWKvBx"
List-Id: <target-devel.vger.kernel.org>
To: target-devel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi All,
I observe connection errors almost immediately after I start iozone over iser 
luns. Atached are the connection error and hung task traces on initator and 
target respecively.
Interestingly, I see connection errors only if LUN size is less than 512MB. 
In my case I could consistently reproduce the issue with 511MB LUN and 300MB 
lun size. Connections errors are not seen if I create 512MB or greated LUN.

Further, after the connection errors, I noticed that the poll work queue is 
stuck and never processes drain CQE resulting in hung tasks on the target side.
I tried changing the CQ poll workqueue to be UNBOUND but it did not fix the issue.

Here is what my test does:
Create 8 targets with 511MB lun each, login and format disks to ext3, mount the 
disks and run iozone over them.
#iozone -a -I -+d -g 256m

I am not sure how LUN size could cause the connection errors. I appreciate any 
inputs on this.

Thanks,
Bharat.

--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="connection_errors_on_initiator.txt"

Feb 26 18:49:47 kernel: scsi host6: iSCSI Initiator over iSER
Feb 26 18:49:55 kernel: scsi host6: iSCSI Initiator over iSER
Feb 26 18:49:55 kernel: scsi 6:0:0:0: Direct-Access     LIO-ORG  ram100           4.0  PQ: 0 ANSI: 5
Feb 26 18:49:55 kernel: scsi 6:0:0:0: alua: supports implicit and explicit TPGS
Feb 26 18:49:55 kernel: scsi 6:0:0:0: alua: device naa.600140529eea00202cf486d9aa038838 port group 0 rel port 1
Feb 26 18:49:55 kernel: sd 6:0:0:0: Attached scsi generic sg3 type 0
Feb 26 18:49:55 kernel: sd 6:0:0:0: [sdc] 1046528 512-byte logical blocks: (536 MB/511 MiB)
Feb 26 18:49:55 kernel: sd 6:0:0:0: [sdc] Write Protect is off
Feb 26 18:49:55 kernel: sd 6:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Feb 26 18:49:55 kernel: sd 6:0:0:0: [sdc] Optimal transfer size 4294967288 logical blocks > dev_max (65535 logical blocks)
Feb 26 18:49:55 kernel: sd 6:0:0:0: alua: transition timeout set to 60 seconds
Feb 26 18:49:55 kernel: sd 6:0:0:0: alua: port group 00 state A non-preferred supports TOlUSNA
Feb 26 18:49:55 kernel: sd 6:0:0:0: [sdc] Attached SCSI disk
Feb 26 18:49:55 iscsid: Could not set session20 priority. READ/WRITE throughout and latency could be affected.
Feb 26 18:49:55 iscsid: Connection20:0 to [target: iqn.2016-17.chelsio.org0, portal: 10.0.2.2,3260] through [iface: iser] is operational now
Feb 26 18:49:56 kernel: scsi host7: iSCSI Initiator over iSER
Feb 26 18:49:56 kernel: scsi 7:0:0:0: Direct-Access     LIO-ORG  ram110           4.0  PQ: 0 ANSI: 5
Feb 26 18:49:56 kernel: scsi 7:0:0:0: alua: supports implicit and explicit TPGS
Feb 26 18:49:56 kernel: scsi 7:0:0:0: alua: device naa.60014057d3e8a86a2834f20b61e7081b port group 0 rel port 1
Feb 26 18:49:56 kernel: sd 7:0:0:0: Attached scsi generic sg4 type 0
Feb 26 18:49:56 kernel: sd 7:0:0:0: [sdd] 1046528 512-byte logical blocks: (536 MB/511 MiB)
Feb 26 18:49:56 kernel: sd 7:0:0:0: [sdd] Write Protect is off
Feb 26 18:49:56 kernel: sd 7:0:0:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Feb 26 18:49:56 kernel: sd 7:0:0:0: [sdd] Optimal transfer size 4294967288 logical blocks > dev_max (65535 logical blocks)
Feb 26 18:49:56 kernel: sd 7:0:0:0: alua: transition timeout set to 60 seconds
Feb 26 18:49:56 kernel: sd 7:0:0:0: alua: port group 00 state A non-preferred supports TOlUSNA
Feb 26 18:49:56 kernel: sd 7:0:0:0: [sdd] Attached SCSI disk
Feb 26 18:49:56 iscsid: Could not set session21 priority. READ/WRITE throughout and latency could be affected.
Feb 26 18:49:56 iscsid: Connection21:0 to [target: iqn.2016-17.chelsio.org1, portal: 10.0.2.2,3260] through [iface: iser] is operational now
Feb 26 18:49:57 kernel: scsi host8: iSCSI Initiator over iSER
Feb 26 18:49:57 kernel: scsi 8:0:0:0: Direct-Access     LIO-ORG  ram120           4.0  PQ: 0 ANSI: 5
Feb 26 18:49:57 kernel: scsi 8:0:0:0: alua: supports implicit and explicit TPGS
Feb 26 18:49:57 kernel: scsi 8:0:0:0: alua: device naa.6001405195d118337da4cc5abf4cc083 port group 0 rel port 1
Feb 26 18:49:57 kernel: sd 8:0:0:0: Attached scsi generic sg5 type 0
Feb 26 18:49:57 kernel: sd 8:0:0:0: [sde] 1046528 512-byte logical blocks: (536 MB/511 MiB)
Feb 26 18:49:57 kernel: sd 8:0:0:0: [sde] Write Protect is off
Feb 26 18:49:57 kernel: sd 8:0:0:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Feb 26 18:49:57 kernel: sd 8:0:0:0: [sde] Optimal transfer size 4294967288 logical blocks > dev_max (65535 logical blocks)
Feb 26 18:49:57 kernel: sd 8:0:0:0: alua: transition timeout set to 60 seconds
Feb 26 18:49:57 kernel: sd 8:0:0:0: alua: port group 00 state A non-preferred supports TOlUSNA
Feb 26 18:49:57 kernel: sd 8:0:0:0: [sde] Attached SCSI disk
Feb 26 18:49:57 iscsid: Could not set session22 priority. READ/WRITE throughout and latency could be affected.
Feb 26 18:49:57 iscsid: Connection22:0 to [target: iqn.2016-17.chelsio.org2, portal: 10.0.2.2,3260] through [iface: iser] is operational now
Feb 26 18:49:58 kernel: scsi host9: iSCSI Initiator over iSER
Feb 26 18:49:58 kernel: scsi 9:0:0:0: Direct-Access     LIO-ORG  ram130           4.0  PQ: 0 ANSI: 5
Feb 26 18:49:58 kernel: scsi 9:0:0:0: alua: supports implicit and explicit TPGS
Feb 26 18:49:58 kernel: scsi 9:0:0:0: alua: device naa.6001405f4b5fbdef5e646eb8e5f59fb8 port group 0 rel port 1
Feb 26 18:49:58 kernel: sd 9:0:0:0: Attached scsi generic sg6 type 0
Feb 26 18:49:58 kernel: sd 9:0:0:0: [sdf] 1046528 512-byte logical blocks: (536 MB/511 MiB)
Feb 26 18:49:58 kernel: sd 9:0:0:0: [sdf] Write Protect is off
Feb 26 18:49:58 kernel: sd 9:0:0:0: [sdf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Feb 26 18:49:58 kernel: sd 9:0:0:0: [sdf] Optimal transfer size 4294967288 logical blocks > dev_max (65535 logical blocks)
Feb 26 18:49:58 kernel: sd 9:0:0:0: alua: transition timeout set to 60 seconds
Feb 26 18:49:58 kernel: sd 9:0:0:0: alua: port group 00 state A non-preferred supports TOlUSNA
Feb 26 18:49:58 kernel: sd 9:0:0:0: [sdf] Attached SCSI disk
Feb 26 18:49:58 iscsid: Could not set session23 priority. READ/WRITE throughout and latency could be affected.
Feb 26 18:49:58 iscsid: Connection23:0 to [target: iqn.2016-17.chelsio.org3, portal: 10.0.2.2,3260] through [iface: iser] is operational now
Feb 26 18:49:59 kernel: scsi host10: iSCSI Initiator over iSER
Feb 26 18:49:59 kernel: scsi 10:0:0:0: Direct-Access     LIO-ORG  ram140           4.0  PQ: 0 ANSI: 5
Feb 26 18:49:59 kernel: scsi 10:0:0:0: alua: supports implicit and explicit TPGS
Feb 26 18:49:59 kernel: scsi 10:0:0:0: alua: device naa.600140509956da108304596ba93247de port group 0 rel port 1
Feb 26 18:49:59 kernel: sd 10:0:0:0: Attached scsi generic sg7 type 0
Feb 26 18:49:59 kernel: sd 10:0:0:0: [sdg] 1046528 512-byte logical blocks: (536 MB/511 MiB)
Feb 26 18:49:59 kernel: sd 10:0:0:0: [sdg] Write Protect is off
Feb 26 18:49:59 kernel: sd 10:0:0:0: [sdg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Feb 26 18:49:59 kernel: sd 10:0:0:0: [sdg] Optimal transfer size 4294967288 logical blocks > dev_max (65535 logical blocks)
Feb 26 18:49:59 kernel: sd 10:0:0:0: alua: transition timeout set to 60 seconds
Feb 26 18:49:59 kernel: sd 10:0:0:0: alua: port group 00 state A non-preferred supports TOlUSNA
Feb 26 18:49:59 kernel: sd 10:0:0:0: [sdg] Attached SCSI disk
Feb 26 18:49:59 iscsid: Could not set session24 priority. READ/WRITE throughout and latency could be affected.
Feb 26 18:49:59 iscsid: Connection24:0 to [target: iqn.2016-17.chelsio.org4, portal: 10.0.2.2,3260] through [iface: iser] is operational now
Feb 26 18:50:00 kernel: scsi host11: iSCSI Initiator over iSER
Feb 26 18:50:00 kernel: scsi 11:0:0:0: Direct-Access     LIO-ORG  ram150           4.0  PQ: 0 ANSI: 5
Feb 26 18:50:00 kernel: scsi 11:0:0:0: alua: supports implicit and explicit TPGS
Feb 26 18:50:00 kernel: scsi 11:0:0:0: alua: device naa.6001405463860aec2a842ce8abd15252 port group 0 rel port 1
Feb 26 18:50:00 kernel: sd 11:0:0:0: Attached scsi generic sg8 type 0
Feb 26 18:50:00 kernel: sd 11:0:0:0: [sdh] 1046528 512-byte logical blocks: (536 MB/511 MiB)
Feb 26 18:50:00 kernel: sd 11:0:0:0: [sdh] Write Protect is off
Feb 26 18:50:00 kernel: sd 11:0:0:0: [sdh] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Feb 26 18:50:00 kernel: sd 11:0:0:0: [sdh] Optimal transfer size 4294967288 logical blocks > dev_max (65535 logical blocks)
Feb 26 18:50:00 kernel: sd 11:0:0:0: alua: transition timeout set to 60 seconds
Feb 26 18:50:00 kernel: sd 11:0:0:0: alua: port group 00 state A non-preferred supports TOlUSNA
Feb 26 18:50:00 kernel: sd 11:0:0:0: [sdh] Attached SCSI disk
Feb 26 18:50:00 iscsid: Could not set session25 priority. READ/WRITE throughout and latency could be affected.
Feb 26 18:50:00 iscsid: Connection25:0 to [target: iqn.2016-17.chelsio.org5, portal: 10.0.2.2,3260] through [iface: iser] is operational now
Feb 26 18:50:01 systemd: Started Session 54 of user root.
Feb 26 18:50:01 kernel: scsi host12: iSCSI Initiator over iSER
Feb 26 18:50:01 kernel: scsi 12:0:0:0: Direct-Access     LIO-ORG  ram160           4.0  PQ: 0 ANSI: 5
Feb 26 18:50:01 kernel: scsi 12:0:0:0: alua: supports implicit and explicit TPGS
Feb 26 18:50:01 kernel: scsi 12:0:0:0: alua: device naa.6001405a102ac621d0d4747abadb7b63 port group 0 rel port 1
Feb 26 18:50:01 kernel: sd 12:0:0:0: Attached scsi generic sg9 type 0
Feb 26 18:50:01 kernel: sd 12:0:0:0: [sdi] 1046528 512-byte logical blocks: (536 MB/511 MiB)
Feb 26 18:50:01 kernel: sd 12:0:0:0: [sdi] Write Protect is off
Feb 26 18:50:01 kernel: sd 12:0:0:0: [sdi] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Feb 26 18:50:01 kernel: sd 12:0:0:0: [sdi] Optimal transfer size 4294967288 logical blocks > dev_max (65535 logical blocks)
Feb 26 18:50:01 kernel: sd 12:0:0:0: alua: transition timeout set to 60 seconds
Feb 26 18:50:01 kernel: sd 12:0:0:0: alua: port group 00 state A non-preferred supports TOlUSNA
Feb 26 18:50:01 kernel: sd 12:0:0:0: [sdi] Attached SCSI disk
Feb 26 18:50:02 iscsid: Could not set session26 priority. READ/WRITE throughout and latency could be affected.
Feb 26 18:50:02 iscsid: Connection26:0 to [target: iqn.2016-17.chelsio.org6, portal: 10.0.2.2,3260] through [iface: iser] is operational now
Feb 26 18:50:02 kernel: scsi host13: iSCSI Initiator over iSER
Feb 26 18:50:02 kernel: scsi 13:0:0:0: Direct-Access     LIO-ORG  ram170           4.0  PQ: 0 ANSI: 5
Feb 26 18:50:02 kernel: scsi 13:0:0:0: alua: supports implicit and explicit TPGS
Feb 26 18:50:02 kernel: scsi 13:0:0:0: alua: device naa.600140584652eeb4d46408cbc223d76f port group 0 rel port 1
Feb 26 18:50:02 kernel: sd 13:0:0:0: Attached scsi generic sg10 type 0
Feb 26 18:50:02 kernel: sd 13:0:0:0: [sdj] 1046528 512-byte logical blocks: (536 MB/511 MiB)
Feb 26 18:50:02 kernel: sd 13:0:0:0: [sdj] Write Protect is off
Feb 26 18:50:02 kernel: sd 13:0:0:0: [sdj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Feb 26 18:50:02 kernel: sd 13:0:0:0: [sdj] Optimal transfer size 4294967288 logical blocks > dev_max (65535 logical blocks)
Feb 26 18:50:02 kernel: sd 13:0:0:0: alua: transition timeout set to 60 seconds
Feb 26 18:50:02 kernel: sd 13:0:0:0: alua: port group 00 state A non-preferred supports TOlUSNA
Feb 26 18:50:02 kernel: sd 13:0:0:0: [sdj] Attached SCSI disk
Feb 26 18:50:03 iscsid: Could not set session27 priority. READ/WRITE throughout and latency could be affected.
Feb 26 18:50:03 iscsid: Connection27:0 to [target: iqn.2016-17.chelsio.org7, portal: 10.0.2.2,3260] through [iface: iser] is operational now
Feb 26 18:50:17 kernel: EXT4-fs (sdc): mounting ext3 file system using the ext4 subsystem
Feb 26 18:50:17 kernel: EXT4-fs (sdc): mounted filesystem with ordered data mode. Opts: (null)
Feb 26 18:50:17 kernel: ext3 filesystem being mounted at /mount/iscsi0 supports timestamps until 2038 (0x7fffffff)
Feb 26 18:50:17 kernel: EXT4-fs (sdd): mounting ext3 file system using the ext4 subsystem
Feb 26 18:50:17 kernel: EXT4-fs (sdd): mounted filesystem with ordered data mode. Opts: (null)
Feb 26 18:50:17 kernel: ext3 filesystem being mounted at /mount/iscsi1 supports timestamps until 2038 (0x7fffffff)
Feb 26 18:50:17 kernel: EXT4-fs (sde): mounting ext3 file system using the ext4 subsystem
Feb 26 18:50:17 kernel: EXT4-fs (sde): mounted filesystem with ordered data mode. Opts: (null)
Feb 26 18:50:17 kernel: ext3 filesystem being mounted at /mount/iscsi2 supports timestamps until 2038 (0x7fffffff)
Feb 26 18:50:17 kernel: EXT4-fs (sdf): mounting ext3 file system using the ext4 subsystem
Feb 26 18:50:17 kernel: EXT4-fs (sdf): mounted filesystem with ordered data mode. Opts: (null)
Feb 26 18:50:17 kernel: ext3 filesystem being mounted at /mount/iscsi3 supports timestamps until 2038 (0x7fffffff)
Feb 26 18:50:17 kernel: EXT4-fs (sdg): mounting ext3 file system using the ext4 subsystem
Feb 26 18:50:17 kernel: EXT4-fs (sdg): mounted filesystem with ordered data mode. Opts: (null)
Feb 26 18:50:17 kernel: ext3 filesystem being mounted at /mount/iscsi4 supports timestamps until 2038 (0x7fffffff)
Feb 26 18:50:17 kernel: EXT4-fs (sdh): mounting ext3 file system using the ext4 subsystem
Feb 26 18:50:17 kernel: EXT4-fs (sdh): mounted filesystem with ordered data mode. Opts: (null)
Feb 26 18:50:17 kernel: ext3 filesystem being mounted at /mount/iscsi5 supports timestamps until 2038 (0x7fffffff)
Feb 26 18:50:17 kernel: EXT4-fs (sdi): mounting ext3 file system using the ext4 subsystem
Feb 26 18:50:17 kernel: EXT4-fs (sdi): mounted filesystem with ordered data mode. Opts: (null)
Feb 26 18:50:17 kernel: ext3 filesystem being mounted at /mount/iscsi6 supports timestamps until 2038 (0x7fffffff)
Feb 26 18:50:17 kernel: EXT4-fs (sdj): mounting ext3 file system using the ext4 subsystem
Feb 26 18:50:17 kernel: EXT4-fs (sdj): mounted filesystem with ordered data mode. Opts: (null)
Feb 26 18:50:17 kernel: ext3 filesystem being mounted at /mount/iscsi7 supports timestamps until 2038 (0x7fffffff)
Feb 26 18:58:46 kernel: connection22:0: ping timeout of 5 secs expired, recv timeout 5, last rx 4319116961, last ping 4319121984, now 4319127040
Feb 26 18:58:46 kernel: connection22:0: detected conn error (1022)
Feb 26 18:58:46 iscsid: Kernel reported iSCSI connection 22:0 error (1022 - Invalid or unknown error code) state (3)
Feb 26 19:00:01 systemd: Started Session 55 of user root.
Feb 26 19:00:43 kernel: INFO: task jbd2/sde-8:8819 blocked for more than 122 seconds.
Feb 26 19:00:43 kernel:      Tainted: G          I       5.4.0 #65
Feb 26 19:00:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb 26 19:00:43 kernel: jbd2/sde-8      D    0  8819      2 0x80004080
Feb 26 19:00:43 kernel: Call Trace:
Feb 26 19:00:43 kernel: ? __schedule+0x398/0x970
Feb 26 19:00:43 kernel: ? bit_wait+0x50/0x50
Feb 26 19:00:43 kernel: schedule+0x40/0xc0
Feb 26 19:00:43 kernel: io_schedule+0x12/0x40
Feb 26 19:00:43 kernel: bit_wait_io+0xd/0x50
Feb 26 19:00:43 kernel: __wait_on_bit+0x63/0x90
Feb 26 19:00:43 kernel: out_of_line_wait_on_bit+0x8e/0xb0
Feb 26 19:00:43 kernel: ? init_wait_var_entry+0x40/0x40
Feb 26 19:00:43 kernel: jbd2_journal_commit_transaction+0xeda/0x1f10 [jbd2]
Feb 26 19:00:43 kernel: ? try_to_del_timer_sync+0x4d/0x80
Feb 26 19:00:43 kernel: ? _raw_spin_unlock_irqrestore+0x32/0x57
Feb 26 19:00:43 kernel: kjournald2+0xc9/0x2a0 [jbd2]
Feb 26 19:00:43 kernel: ? remove_wait_queue+0x60/0x60
Feb 26 19:00:43 kernel: kthread+0x103/0x140
Feb 26 19:00:43 kernel: ? commit_timeout+0x10/0x10 [jbd2]
Feb 26 19:00:43 kernel: ? kthread_bind+0x10/0x10
Feb 26 19:00:43 kernel: ret_from_fork+0x3a/0x50
Feb 26 19:00:43 kernel: INFO: task iozone:9238 blocked for more than 122 seconds.
Feb 26 19:00:43 kernel:      Tainted: G          I       5.4.0 #65
Feb 26 19:00:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb 26 19:00:43 kernel: iozone          D    0  9238   8899 0x00004080
Feb 26 19:00:43 kernel: Call Trace:
Feb 26 19:00:43 kernel: ? __schedule+0x398/0x970
Feb 26 19:00:43 kernel: schedule+0x40/0xc0
Feb 26 19:00:43 kernel: jbd2_log_wait_commit+0x10e/0x190 [jbd2]
Feb 26 19:00:43 kernel: ? remove_wait_queue+0x60/0x60
Feb 26 19:00:43 kernel: ext4_sync_fs+0x224/0x260 [ext4]
Feb 26 19:00:43 kernel: ? __ia32_sys_fdatasync+0x20/0x20
Feb 26 19:00:43 kernel: iterate_supers+0xa8/0xf0
Feb 26 19:00:43 kernel: ksys_sync+0x60/0xb0
Feb 26 19:00:43 kernel: __ia32_sys_sync+0xa/0x10
Feb 26 19:00:43 kernel: do_syscall_64+0x60/0x250
Feb 26 19:00:43 kernel: entry_SYSCALL_64_after_hwframe+0x49/0xbe
Feb 26 19:00:43 kernel: RIP: 0033:0x149814f99b37
Feb 26 19:00:43 kernel: Code: Bad RIP value.
Feb 26 19:00:43 kernel: RSP: 002b:00007ffd96521598 EFLAGS: 00000246 ORIG_RAX: 00000000000000a2
Feb 26 19:00:43 kernel: RAX: ffffffffffffffda RBX: 0000000000000009 RCX: 0000149814f99b37
Feb 26 19:00:43 kernel: RDX: 0000000000000000 RSI: 0000000000010000 RDI: 0000000000040000
Feb 26 19:00:43 kernel: RBP: 0000000000010000 R08: 0000000000000016 R09: 000000000000007c
Feb 26 19:00:43 kernel: R10: 0000000000000016 R11: 0000000000000246 R12: 0000000000040000
Feb 26 19:00:43 kernel: R13: 0000000000001000 R14: 0000000000001000 R15: 0000000010000000
Feb 26 19:00:43 kernel: INFO: task iozone:9242 blocked for more than 122 seconds.
Feb 26 19:00:43 kernel:      Tainted: G          I       5.4.0 #65
Feb 26 19:00:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb 26 19:00:43 kernel: iozone          D    0  9242   8921 0x00000080
Feb 26 19:00:43 kernel: Call Trace:
Feb 26 19:00:43 kernel: ? __schedule+0x398/0x970
Feb 26 19:00:43 kernel: schedule+0x40/0xc0
Feb 26 19:00:43 kernel: io_schedule+0x12/0x40
Feb 26 19:00:43 kernel: do_blockdev_direct_IO+0x1cd4/0x2880
Feb 26 19:00:43 kernel: ? ext4_dio_get_block_unwritten_sync+0x60/0x60 [ext4]
Feb 26 19:00:43 kernel: ext4_direct_IO+0x477/0x7a0 [ext4]
Feb 26 19:00:43 kernel: generic_file_direct_write+0xce/0x180
Feb 26 19:00:43 kernel: __generic_file_write_iter+0xb7/0x1c0
Feb 26 19:00:43 kernel: ? generic_write_checks+0x66/0xc0
Feb 26 19:00:43 kernel: ext4_file_write_iter+0x1cb/0x3b0 [ext4]
Feb 26 19:00:43 kernel: ? __lock_acquire+0x44a/0x10c0
Feb 26 19:00:43 kernel: new_sync_write+0x11e/0x1a0
Feb 26 19:00:43 kernel: vfs_write+0xd0/0x1d0
Feb 26 19:00:43 kernel: ? trace_hardirqs_on_thunk+0x1a/0x20
Feb 26 19:00:43 kernel: ksys_write+0x5c/0xd0
Feb 26 19:00:43 kernel: do_syscall_64+0x60/0x250
Feb 26 19:00:43 kernel: entry_SYSCALL_64_after_hwframe+0x49/0xbe
Feb 26 19:00:43 kernel: RIP: 0033:0x1543c482f6a0
Feb 26 19:00:43 kernel: Code: Bad RIP value.
Feb 26 19:00:43 kernel: RSP: 002b:00007ffedd09a758 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
Feb 26 19:00:43 kernel: RAX: ffffffffffffffda RBX: 0000000001000000 RCX: 00001543c482f6a0
Feb 26 19:00:43 kernel: RDX: 0000000001000000 RSI: 00001543c3300000 RDI: 0000000000000004
Feb 26 19:00:43 kernel: RBP: 0000000000000003 R08: ecf8eefaf0fcd2da R09: 0000000000080000
Feb 26 19:00:43 kernel: R10: eaf6ecf8eefad0d8 R11: 0000000000000246 R12: 00001543c3300000
Feb 26 19:00:43 kernel: R13: 0000000000000000 R14: 0000000001000000 R15: 0000000000000000
Feb 26 19:00:43 kernel: INFO: task iozone:9255 blocked for more than 122 seconds.
Feb 26 19:00:43 kernel:      Tainted: G          I       5.4.0 #65
Feb 26 19:00:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb 26 19:00:43 kernel: iozone          D    0  9255   8911 0x00004080
Feb 26 19:00:43 kernel: Call Trace:
Feb 26 19:00:43 kernel: ? __schedule+0x398/0x970
Feb 26 19:00:43 kernel: schedule+0x40/0xc0
Feb 26 19:00:43 kernel: jbd2_log_wait_commit+0x10e/0x190 [jbd2]
Feb 26 19:00:43 kernel: ? remove_wait_queue+0x60/0x60
Feb 26 19:00:43 kernel: ext4_sync_fs+0x224/0x260 [ext4]
Feb 26 19:00:43 kernel: ? __ia32_sys_fdatasync+0x20/0x20
Feb 26 19:00:43 kernel: iterate_supers+0xa8/0xf0
Feb 26 19:00:43 kernel: ksys_sync+0x60/0xb0
Feb 26 19:00:43 kernel: __ia32_sys_sync+0xa/0x10
Feb 26 19:00:43 kernel: do_syscall_64+0x60/0x250
Feb 26 19:00:43 kernel: entry_SYSCALL_64_after_hwframe+0x49/0xbe
Feb 26 19:00:43 kernel: RIP: 0033:0x14ddaca4cb37
Feb 26 19:00:43 kernel: Code: Bad RIP value.
Feb 26 19:00:43 kernel: RSP: 002b:00007fff6a968758 EFLAGS: 00000246 ORIG_RAX: 00000000000000a2
Feb 26 19:00:43 kernel: RAX: ffffffffffffffda RBX: 0000000000000009 RCX: 000014ddaca4cb37
Feb 26 19:00:43 kernel: RDX: 0000000000800000 RSI: 0000000000800000 RDI: 0000000000020000
Feb 26 19:00:43 kernel: RBP: 0000000000800000 R08: 000000000000000a R09: 000014ddad365740
Feb 26 19:00:43 kernel: R10: 0000000000000075 R11: 0000000000000246 R12: 0000000000020000
Feb 26 19:00:43 kernel: R13: 0000000000001000 R14: 0000000000001000 R15: 0000000008000000
Feb 26 19:00:43 kernel: INFO: task iozone:9257 blocked for more than 122 seconds.
Feb 26 19:00:43 kernel:      Tainted: G          I       5.4.0 #65
Feb 26 19:00:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb 26 19:00:43 kernel: iozone          D    0  9257   8952 0x00004080
Feb 26 19:00:43 kernel: Call Trace:
Feb 26 19:00:43 kernel: ? __schedule+0x398/0x970
Feb 26 19:00:43 kernel: schedule+0x40/0xc0
Feb 26 19:00:43 kernel: jbd2_log_wait_commit+0x10e/0x190 [jbd2]
Feb 26 19:00:43 kernel: ? remove_wait_queue+0x60/0x60
Feb 26 19:00:43 kernel: ext4_sync_fs+0x224/0x260 [ext4]
Feb 26 19:00:43 kernel: ? __ia32_sys_fdatasync+0x20/0x20
Feb 26 19:00:43 kernel: iterate_supers+0xa8/0xf0
Feb 26 19:00:43 kernel: ksys_sync+0x60/0xb0
Feb 26 19:00:43 kernel: __ia32_sys_sync+0xa/0x10
Feb 26 19:00:43 kernel: do_syscall_64+0x60/0x250
Feb 26 19:00:43 kernel: entry_SYSCALL_64_after_hwframe+0x49/0xbe
Feb 26 19:00:43 kernel: RIP: 0033:0x149c24a52b37
Feb 26 19:00:43 kernel: Code: Bad RIP value.
Feb 26 19:00:43 kernel: RSP: 002b:00007ffd2255e658 EFLAGS: 00000246 ORIG_RAX: 00000000000000a2
Feb 26 19:00:43 kernel: RAX: ffffffffffffffda RBX: 0000000000000009 RCX: 0000149c24a52b37
Feb 26 19:00:43 kernel: RDX: 0000000000800000 RSI: 0000000000800000 RDI: 0000000000020000
Feb 26 19:00:43 kernel: RBP: 0000000000800000 R08: 000000000000000a R09: 0000149c2536b740
Feb 26 19:00:43 kernel: R10: 0000000000000075 R11: 0000000000000246 R12: 0000000000020000
Feb 26 19:00:43 kernel: R13: 0000000000001000 R14: 0000000000001000 R15: 0000000008000000
Feb 26 19:00:43 kernel: INFO: task iozone:9261 blocked for more than 122 seconds.
Feb 26 19:00:43 kernel:      Tainted: G          I       5.4.0 #65
Feb 26 19:00:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb 26 19:00:43 kernel: iozone          D    0  9261   8931 0x00004080
Feb 26 19:00:43 kernel: Call Trace:
Feb 26 19:00:43 kernel: ? __schedule+0x398/0x970
Feb 26 19:00:43 kernel: schedule+0x40/0xc0
Feb 26 19:00:43 kernel: jbd2_log_wait_commit+0x10e/0x190 [jbd2]
Feb 26 19:00:43 kernel: ? remove_wait_queue+0x60/0x60
Feb 26 19:00:43 kernel: ext4_sync_fs+0x224/0x260 [ext4]
Feb 26 19:00:43 kernel: ? __ia32_sys_fdatasync+0x20/0x20
Feb 26 19:00:43 kernel: iterate_supers+0xa8/0xf0
Feb 26 19:00:43 kernel: ksys_sync+0x60/0xb0
Feb 26 19:00:43 kernel: __ia32_sys_sync+0xa/0x10
Feb 26 19:00:43 kernel: do_syscall_64+0x60/0x250
Feb 26 19:00:43 kernel: entry_SYSCALL_64_after_hwframe+0x49/0xbe
Feb 26 19:00:43 kernel: RIP: 0033:0x150fd3d6eb37
Feb 26 19:00:43 kernel: Code: Bad RIP value.
Feb 26 19:00:43 kernel: RSP: 002b:00007ffdfd057978 EFLAGS: 00000246 ORIG_RAX: 00000000000000a2
Feb 26 19:00:43 kernel: RAX: ffffffffffffffda RBX: 0000000000000009 RCX: 0000150fd3d6eb37
Feb 26 19:00:43 kernel: RDX: 0000000000200000 RSI: 0000000000200000 RDI: 0000000000020000
Feb 26 19:00:43 kernel: RBP: 0000000000200000 R08: 000000000000000a R09: 0000150fd4687740
Feb 26 19:00:43 kernel: R10: 0000000000000073 R11: 0000000000000246 R12: 0000000000020000
Feb 26 19:00:43 kernel: R13: 0000000000001000 R14: 0000000000001000 R15: 0000000008000000
Feb 26 19:00:43 kernel: INFO: task iozone:9266 blocked for more than 122 seconds.
Feb 26 19:00:43 kernel:      Tainted: G          I       5.4.0 #65
Feb 26 19:00:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb 26 19:00:43 kernel: iozone          D    0  9266   8972 0x00004080
Feb 26 19:00:43 kernel: Call Trace:
Feb 26 19:00:43 kernel: ? __schedule+0x398/0x970
Feb 26 19:00:43 kernel: schedule+0x40/0xc0
Feb 26 19:00:43 kernel: jbd2_log_wait_commit+0x10e/0x190 [jbd2]
Feb 26 19:00:43 kernel: ? remove_wait_queue+0x60/0x60
Feb 26 19:00:43 kernel: ext4_sync_fs+0x224/0x260 [ext4]
Feb 26 19:00:43 kernel: ? __ia32_sys_fdatasync+0x20/0x20
Feb 26 19:00:43 kernel: iterate_supers+0xa8/0xf0
Feb 26 19:00:43 kernel: ksys_sync+0x60/0xb0
Feb 26 19:00:43 kernel: __ia32_sys_sync+0xa/0x10
Feb 26 19:00:43 kernel: do_syscall_64+0x60/0x250
Feb 26 19:00:43 kernel: entry_SYSCALL_64_after_hwframe+0x49/0xbe
Feb 26 19:00:43 kernel: RIP: 0033:0x14ffb263fb37
Feb 26 19:00:43 kernel: Code: Bad RIP value.
Feb 26 19:00:43 kernel: RSP: 002b:00007ffee9e97c38 EFLAGS: 00000246 ORIG_RAX: 00000000000000a2
Feb 26 19:00:43 kernel: RAX: ffffffffffffffda RBX: 0000000000000009 RCX: 000014ffb263fb37
Feb 26 19:00:43 kernel: RDX: 0000000000200000 RSI: 0000000000200000 RDI: 0000000000020000
Feb 26 19:00:43 kernel: RBP: 0000000000200000 R08: 000000000000000a R09: 000014ffb2f58740
Feb 26 19:00:43 kernel: R10: 0000000000000073 R11: 0000000000000246 R12: 0000000000020000
Feb 26 19:00:43 kernel: R13: 0000000000001000 R14: 0000000000001000 R15: 0000000008000000
Feb 26 19:00:43 kernel: INFO: task iozone:9268 blocked for more than 122 seconds.
Feb 26 19:00:43 kernel:      Tainted: G          I       5.4.0 #65
Feb 26 19:00:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb 26 19:00:43 kernel: iozone          D    0  9268   8941 0x00004080
Feb 26 19:00:43 kernel: Call Trace:
Feb 26 19:00:43 kernel: ? __schedule+0x398/0x970
Feb 26 19:00:43 kernel: schedule+0x40/0xc0
Feb 26 19:00:43 kernel: jbd2_log_wait_commit+0x10e/0x190 [jbd2]
Feb 26 19:00:43 kernel: ? remove_wait_queue+0x60/0x60
Feb 26 19:00:43 kernel: ext4_sync_fs+0x224/0x260 [ext4]
Feb 26 19:00:43 kernel: ? __ia32_sys_fdatasync+0x20/0x20
Feb 26 19:00:43 kernel: iterate_supers+0xa8/0xf0
Feb 26 19:00:43 kernel: ksys_sync+0x60/0xb0
Feb 26 19:00:43 kernel: __ia32_sys_sync+0xa/0x10
Feb 26 19:00:43 kernel: do_syscall_64+0x60/0x250
Feb 26 19:00:43 kernel: entry_SYSCALL_64_after_hwframe+0x49/0xbe
Feb 26 19:00:43 kernel: RIP: 0033:0x14f5009c1b37
Feb 26 19:00:43 kernel: Code: Bad RIP value.
Feb 26 19:00:43 kernel: RSP: 002b:00007ffe47ef2b48 EFLAGS: 00000246 ORIG_RAX: 00000000000000a2
Feb 26 19:00:43 kernel: RAX: ffffffffffffffda RBX: 0000000000000009 RCX: 000014f5009c1b37
Feb 26 19:00:43 kernel: RDX: 0000000000200000 RSI: 0000000000200000 RDI: 0000000000020000
Feb 26 19:00:43 kernel: RBP: 0000000000200000 R08: 000000000000000a R09: 000014f5012da740
Feb 26 19:00:43 kernel: R10: 0000000000000073 R11: 0000000000000246 R12: 0000000000020000
Feb 26 19:00:43 kernel: R13: 0000000000001000 R14: 0000000000001000 R15: 0000000008000000
Feb 26 19:00:43 kernel: INFO: task iozone:9271 blocked for more than 122 seconds.
Feb 26 19:00:43 kernel:      Tainted: G          I       5.4.0 #65
Feb 26 19:00:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb 26 19:00:43 kernel: iozone          D    0  9271   8962 0x00004080
Feb 26 19:00:43 kernel: Call Trace:
Feb 26 19:00:43 kernel: ? __schedule+0x398/0x970
Feb 26 19:00:43 kernel: schedule+0x40/0xc0
Feb 26 19:00:43 kernel: jbd2_log_wait_commit+0x10e/0x190 [jbd2]
Feb 26 19:00:43 kernel: ? remove_wait_queue+0x60/0x60
Feb 26 19:00:43 kernel: ext4_sync_fs+0x224/0x260 [ext4]
Feb 26 19:00:43 kernel: ? __ia32_sys_fdatasync+0x20/0x20
Feb 26 19:00:43 kernel: iterate_supers+0xa8/0xf0
Feb 26 19:00:43 kernel: ksys_sync+0x60/0xb0
Feb 26 19:00:43 kernel: __ia32_sys_sync+0xa/0x10
Feb 26 19:00:43 kernel: do_syscall_64+0x60/0x250
Feb 26 19:00:43 kernel: entry_SYSCALL_64_after_hwframe+0x49/0xbe
Feb 26 19:00:43 kernel: RIP: 0033:0x14e90041ab37
Feb 26 19:00:43 kernel: Code: Bad RIP value.
Feb 26 19:00:43 kernel: RSP: 002b:00007fff982a5d28 EFLAGS: 00000246 ORIG_RAX: 00000000000000a2
Feb 26 19:00:43 kernel: RAX: ffffffffffffffda RBX: 0000000000000009 RCX: 000014e90041ab37
Feb 26 19:00:43 kernel: RDX: 0000000000200000 RSI: 0000000000200000 RDI: 0000000000020000
Feb 26 19:00:43 kernel: RBP: 0000000000200000 R08: 000000000000000a R09: 000014e900d33740
Feb 26 19:00:43 kernel: R10: 0000000000000073 R11: 0000000000000246 R12: 0000000000020000
Feb 26 19:00:43 kernel: R13: 0000000000001000 R14: 0000000000001000 R15: 0000000008000000
Feb 26 19:00:43 kernel: #012Showing all locks held in the system:
Feb 26 19:00:43 kernel: 1 lock held by khungtaskd/56:
Feb 26 19:00:43 kernel: #0: ffffffffa1a84840 (rcu_read_lock){....}, at: debug_show_all_locks+0xe/0x1a0
Feb 26 19:00:43 kernel: 1 lock held by in:imjournal/1580:
Feb 26 19:00:43 kernel: 3 locks held by rs:main Q:Reg/1584:
Feb 26 19:00:43 kernel: 2 locks held by bash/16572:
Feb 26 19:00:43 kernel: #0: ffff88df685c5890 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x24/0x50
Feb 26 19:00:43 kernel: #1: ffffa9ba000752e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0xd8/0x940
Feb 26 19:00:43 kernel: 1 lock held by iozone/9238:
Feb 26 19:00:43 kernel: #0: ffff88df6db4a0d8 (&type->s_umount_key#46){++++}, at: iterate_supers+0x90/0xf0
Feb 26 19:00:43 kernel: 2 locks held by iozone/9242:
Feb 26 19:00:43 kernel: #0: ffff88df6db4a410 (sb_writers#14){.+.+}, at: vfs_write+0x19f/0x1d0
Feb 26 19:00:43 kernel: #1: ffff88df68f6d168 (&sb->s_type->i_mutex_key#17){++++}, at: ext4_file_write_iter+0x6f/0x3b0 [ext4]
Feb 26 19:00:43 kernel: 1 lock held by iozone/9255:
Feb 26 19:00:43 kernel: #0: ffff88df6db4a0d8 (&type->s_umount_key#46){++++}, at: iterate_supers+0x90/0xf0
Feb 26 19:00:43 kernel: 1 lock held by iozone/9257:
Feb 26 19:00:43 kernel: #0: ffff88df6db4a0d8 (&type->s_umount_key#46){++++}, at: iterate_supers+0x90/0xf0
Feb 26 19:00:43 kernel: 1 lock held by iozone/9261:
Feb 26 19:00:43 kernel: #0: ffff88df6db4a0d8 (&type->s_umount_key#46){++++}, at: iterate_supers+0x90/0xf0
Feb 26 19:00:43 kernel: 1 lock held by iozone/9266:
Feb 26 19:00:43 kernel: #0: ffff88df6db4a0d8 (&type->s_umount_key#46){++++}, at: iterate_supers+0x90/0xf0
Feb 26 19:00:43 kernel: 1 lock held by iozone/9268:
Feb 26 19:00:43 kernel: #0: ffff88df6db4a0d8 (&type->s_umount_key#46){++++}, at: iterate_supers+0x90/0xf0
Feb 26 19:00:43 kernel: 1 lock held by iozone/9271:
Feb 26 19:00:43 kernel: #0: ffff88df6db4a0d8 (&type->s_umount_key#46){++++}, at: iterate_supers+0x90/0xf0
Feb 26 19:00:43 kernel:
Feb 26 19:00:43 kernel: =============================================
Feb 26 19:00:47 kernel: session22: session recovery timed out after 120 secs
Feb 26 19:00:47 kernel: sd 8:0:0:0: rejecting I/O to offline device
Feb 26 19:00:47 kernel: blk_update_request: I/O error, dev sde, sector 503244 op 0x1:(WRITE) flags 0x800 phys_seg 9 prio class 0
Feb 26 19:00:47 kernel: sd 8:0:0:0: rejecting I/O to offline device
Feb 26 19:00:47 kernel: blk_update_request: I/O error, dev sde, sector 503132 op 0x1:(WRITE) flags 0x800 phys_seg 13 prio class 0
Feb 26 19:00:47 kernel: sd 8:0:0:0: rejecting I/O to offline device
Feb 26 19:00:47 kernel: blk_update_request: I/O error, dev sde, sector 503570 op 0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
Feb 26 19:00:47 kernel: sd 8:0:0:0: rejecting I/O to offline device
Feb 26 19:00:47 kernel: blk_update_request: I/O error, dev sde, sector 503220 op 0x1:(WRITE) flags 0x800 phys_seg 9 prio class 0
Feb 26 19:00:47 kernel: sd 8:0:0:0: rejecting I/O to offline device
Feb 26 19:00:47 kernel: blk_update_request: I/O error, dev sde, sector 503576 op 0x1:(WRITE) flags 0x800 phys_seg 13 prio class 0
Feb 26 19:00:47 kernel: sd 8:0:0:0: rejecting I/O to offline device
Feb 26 19:00:47 kernel: blk_update_request: I/O error, dev sde, sector 503424 op 0x1:(WRITE) flags 0x800 phys_seg 21 prio class 0
Feb 26 19:00:47 kernel: sd 8:0:0:0: rejecting I/O to offline device
Feb 26 19:00:47 kernel: blk_update_request: I/O error, dev sde, sector 503168 op 0x1:(WRITE) flags 0x800 phys_seg 13 prio class 0
Feb 26 19:00:47 kernel: sd 8:0:0:0: rejecting I/O to offline device
Feb 26 19:00:47 kernel: blk_update_request: I/O error, dev sde, sector 503572 op 0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
Feb 26 19:00:47 kernel: sd 8:0:0:0: rejecting I/O to offline device
Feb 26 19:00:47 kernel: blk_update_request: I/O error, dev sde, sector 503482 op 0x1:(WRITE) flags 0x800 phys_seg 17 prio class 0
Feb 26 19:00:47 kernel: sd 8:0:0:0: rejecting I/O to offline device
Feb 26 19:00:47 kernel: blk_update_request: I/O error, dev sde, sector 503320 op 0x1:(WRITE) flags 0x800 phys_seg 21 prio class 0
Feb 26 19:00:47 kernel: sd 8:0:0:0: rejecting I/O to offline device
Feb 26 19:00:47 kernel: sd 8:0:0:0: rejecting I/O to offline device
Feb 26 19:00:47 kernel: sd 8:0:0:0: rejecting I/O to offline device
Feb 26 19:00:47 kernel: sd 8:0:0:0: rejecting I/O to offline device
Feb 26 19:00:47 kernel: sd 8:0:0:0: rejecting I/O to offline device
Feb 26 19:00:47 kernel: sd 8:0:0:0: rejecting I/O to offline device
Feb 26 19:00:47 kernel: Aborting journal on device sde-8.
Feb 26 19:00:47 kernel: sd 8:0:0:0: rejecting I/O to offline device
Feb 26 19:00:47 kernel: Buffer I/O error on dev sde, logical block 246019, lost sync page write
Feb 26 19:00:47 kernel: JBD2: Error -5 detected when updating journal superblock for sde-8.
Feb 26 19:00:47 kernel: sd 8:0:0:0: rejecting I/O to offline device
Feb 26 19:00:47 kernel: Buffer I/O error on dev sde, logical block 1, lost sync page write
Feb 26 19:00:47 kernel: EXT4-fs (sde): I/O error while writing superblock
Feb 26 19:00:47 kernel: EXT4-fs error (device sde): ext4_journal_check_start:61: Detected aborted journal
Feb 26 19:00:47 kernel: EXT4-fs (sde): Remounting filesystem read-only
Feb 26 19:00:47 kernel: sd 8:0:0:0: rejecting I/O to offline device
Feb 26 19:00:47 kernel: Buffer I/O error on dev sde, logical block 1, lost sync page write
Feb 26 19:00:47 kernel: EXT4-fs (sde): I/O error while writing superblock
Feb 26 19:01:01 systemd: Started Session 56 of user root.
Feb 26 19:02:41 kernel: connection25:0: ping timeout of 5 secs expired, recv timeout 5, last rx 4319352266, last ping 4319357312, now 4319362560
Feb 26 19:02:41 kernel: connection25:0: detected conn error (1022)
Feb 26 19:02:41 iscsid: Kernel reported iSCSI connection 25:0 error (1022 - Invalid or unknown error code) state (3)
Feb 26 19:04:45 kernel: session25: session recovery timed out after 120 secs
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: print_req_error: 9 callbacks suppressed
Feb 26 19:04:45 kernel: blk_update_request: I/O error, dev sdh, sector 502206 op 0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: blk_update_request: I/O error, dev sdh, sector 501880 op 0x1:(WRITE) flags 0x800 phys_seg 9 prio class 0
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: blk_update_request: I/O error, dev sdh, sector 502266 op 0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: blk_update_request: I/O error, dev sdh, sector 502122 op 0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: blk_update_request: I/O error, dev sdh, sector 502210 op 0x1:(WRITE) flags 0x800 phys_seg 21 prio class 0
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: blk_update_request: I/O error, dev sdh, sector 97306 op 0x1:(WRITE) flags 0x8800 phys_seg 2 prio class 0
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: blk_update_request: I/O error, dev sdh, sector 501660 op 0x1:(WRITE) flags 0x800 phys_seg 13 prio class 0
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: blk_update_request: I/O error, dev sdh, sector 501924 op 0x1:(WRITE) flags 0x800 phys_seg 13 prio class 0
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: blk_update_request: I/O error, dev sdh, sector 502260 op 0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: blk_update_request: I/O error, dev sdh, sector 501958 op 0x1:(WRITE) flags 0x800 phys_seg 13 prio class 0
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: Aborting journal on device sdh-8.
Feb 26 19:04:45 kernel: EXT4-fs error (device sdh) in ext4_free_blocks:4952: Journal has aborted
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: Buffer I/O error on dev sdh, logical block 246019, lost sync page write
Feb 26 19:04:45 kernel: JBD2: Error -5 detected when updating journal superblock for sdh-8.
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: Buffer I/O error on dev sdh, logical block 1, lost sync page write
Feb 26 19:04:45 kernel: EXT4-fs (sdh): I/O error while writing superblock
Feb 26 19:04:45 kernel: EXT4-fs error (device sdh) in ext4_orphan_del:3045: Journal has aborted
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: Buffer I/O error on dev sdh, logical block 1, lost sync page write
Feb 26 19:04:45 kernel: EXT4-fs (sdh): I/O error while writing superblock
Feb 26 19:04:45 kernel: EXT4-fs error (device sdh) in ext4_do_update_inode:5350: Journal has aborted
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: Buffer I/O error on dev sdh, logical block 1, lost sync page write
Feb 26 19:04:45 kernel: EXT4-fs (sdh): I/O error while writing superblock
Feb 26 19:04:45 kernel: EXT4-fs error (device sdh) in ext4_truncate:4535: Journal has aborted
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: Buffer I/O error on dev sdh, logical block 1, lost sync page write
Feb 26 19:04:45 kernel: EXT4-fs (sdh): I/O error while writing superblock
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: Buffer I/O error on dev sdh, logical block 1, lost sync page write
Feb 26 19:04:45 kernel: EXT4-fs (sdh): I/O error while writing superblock
Feb 26 19:04:45 kernel: EXT4-fs error (device sdh): ext4_journal_check_start:61: Detected aborted journal
Feb 26 19:04:45 kernel: EXT4-fs (sdh): Remounting filesystem read-only
Feb 26 19:04:45 kernel: sd 11:0:0:0: rejecting I/O to offline device
Feb 26 19:04:45 kernel: Buffer I/O error on dev sdh, logical block 1, lost sync page write
Feb 26 19:04:45 kernel: EXT4-fs (sdh): I/O error while writing superblock
Feb 26 19:05:15 kernel: connection24:0: ping timeout of 5 secs expired, recv timeout 5, last rx 4319505933, last ping 4319510976, now 4319516161
Feb 26 19:05:15 kernel: connection24:0: detected conn error (1022)
Feb 26 19:05:15 iscsid: Kernel reported iSCSI connection 24:0 error (1022 - Invalid or unknown error code) state (3)
Feb 26 19:07:16 kernel: session24: session recovery timed out after 120 secs
Feb 26 19:07:16 kernel: sd 10:0:0:0: rejecting I/O to offline device
Feb 26 19:07:16 kernel: print_req_error: 30 callbacks suppressed
Feb 26 19:07:16 kernel: blk_update_request: I/O error, dev sdg, sector 503538 op 0x1:(WRITE) flags 0x800 phys_seg 9 prio class 0
Feb 26 19:07:16 kernel: sd 10:0:0:0: rejecting I/O to offline device
Feb 26 19:07:16 kernel: blk_update_request: I/O error, dev sdg, sector 503788 op 0x1:(WRITE) flags 0x800 phys_seg 18 prio class 0
Feb 26 19:07:16 kernel: sd 10:0:0:0: rejecting I/O to offline device
Feb 26 19:07:16 kernel: blk_update_request: I/O error, dev sdg, sector 765978 op 0x1:(WRITE) flags 0xc800 phys_seg 1 prio class 0
Feb 26 19:07:16 kernel: sd 10:0:0:0: rejecting I/O to offline device
Feb 26 19:07:16 kernel: blk_update_request: I/O error, dev sdg, sector 503892 op 0x1:(WRITE) flags 0x800 phys_seg 7 prio class 0
Feb 26 19:07:16 kernel: sd 10:0:0:0: rejecting I/O to offline device
Feb 26 19:07:16 kernel: blk_update_request: I/O error, dev sdg, sector 761882 op 0x1:(WRITE) flags 0xc800 phys_seg 1 prio class 0
Feb 26 19:07:16 kernel: sd 10:0:0:0: rejecting I/O to offline device
Feb 26 19:07:16 kernel: blk_update_request: I/O error, dev sdg, sector 503496 op 0x1:(WRITE) flags 0x800 phys_seg 17 prio class 0
Feb 26 19:07:16 kernel: sd 10:0:0:0: rejecting I/O to offline device
Feb 26 19:07:16 kernel: blk_update_request: I/O error, dev sdg, sector 766490 op 0x1:(WRITE) flags 0xc800 phys_seg 1 prio class 0
Feb 26 19:07:16 kernel: sd 10:0:0:0: rejecting I/O to offline device
Feb 26 19:07:16 kernel: blk_update_request: I/O error, dev sdg, sector 762394 op 0x1:(WRITE) flags 0xc800 phys_seg 1 prio class 0
Feb 26 19:07:16 kernel: sd 10:0:0:0: rejecting I/O to offline device
Feb 26 19:07:16 kernel: blk_update_request: I/O error, dev sdg, sector 767514 op 0x1:(WRITE) flags 0xc800 phys_seg 2 prio class 0
Feb 26 19:07:16 kernel: sd 10:0:0:0: rejecting I/O to offline device
Feb 26 19:07:16 kernel: blk_update_request: I/O error, dev sdg, sector 763930 op 0x1:(WRITE) flags 0xc800 phys_seg 1 prio class 0
Feb 26 19:07:16 kernel: sd 10:0:0:0: rejecting I/O to offline device
Feb 26 19:07:16 kernel: sd 10:0:0:0: rejecting I/O to offline device
Feb 26 19:07:16 kernel: sd 10:0:0:0: rejecting I/O to offline device
Feb 26 19:07:16 kernel: sd 10:0:0:0: rejecting I/O to offline device
Feb 26 19:07:16 kernel: sd 10:0:0:0: rejecting I/O to offline device
Feb 26 19:07:16 kernel: sd 10:0:0:0: rejecting I/O to offline device
Feb 26 19:07:16 kernel: sd 10:0:0:0: rejecting I/O to offline device
Feb 26 19:07:16 kernel: sd 10:0:0:0: rejecting I/O to offline device
Feb 26 19:07:16 kernel: sd 10:0:0:0: rejecting I/O to offline device


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="hung_task_trace_on_target.txt"

[  738.986441] INFO: task iscsi_np:2994 blocked for more than 122 seconds.
[  738.987361]       Not tainted 5.4.0+ #69
[  738.988083] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  738.988812] iscsi_np        D    0  2994      2 0x80004004
[  738.989560] Call Trace:
[  738.990279]  ? __schedule+0x39b/0x970
[  738.990997]  schedule+0x40/0xc0
[  738.991726]  schedule_timeout+0x1e4/0x310
[  738.992471]  ? find_held_lock+0x38/0xa0
[  738.993181]  ? sched_clock+0x5/0x10
[  738.993866]  ? sched_clock_cpu+0xc/0xa0
[  738.994685]  wait_for_completion+0x12e/0x190
[  738.995372]  ? wake_up_q+0x70/0x70
[  738.996064]  iscsi_check_for_session_reinstatement+0x1dd/0x270 [iscsi_target_mod]
[  738.996749]  iscsi_target_do_login+0xe8/0x5d0 [iscsi_target_mod]
[  738.997459]  iscsi_target_start_negotiation+0x51/0xa0 [iscsi_target_mod]
[  738.998147]  iscsi_target_login_thread+0x93d/0x1100 [iscsi_target_mod]
[  738.998824]  kthread+0x106/0x140
[  738.999511]  ? iscsi_target_login_sess_out+0x200/0x200 [iscsi_target_mod]
[  739.000206]  ? kthread_bind+0x10/0x10
[  739.000872]  ret_from_fork+0x3a/0x50
[  739.001561] INFO: task iscsi_ttx:3260 blocked for more than 122 seconds.
[  739.002219]       Not tainted 5.4.0+ #69
[  739.002872] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  739.003579] iscsi_ttx       D    0  3260      2 0x80004004
[  739.004274] Call Trace:
[  739.004941]  ? __schedule+0x39b/0x970
[  739.005634]  schedule+0x40/0xc0
[  739.006282]  schedule_timeout+0x1e4/0x310
[  739.006925]  ? find_held_lock+0x38/0xa0
[  739.007582]  ? sched_clock+0x5/0x10
[  739.008199]  ? sched_clock_cpu+0xc/0xa0
[  739.008788]  wait_for_completion+0x12e/0x190
[  739.009375]  ? wake_up_q+0x70/0x70
[  739.009928]  __ib_drain_sq+0x196/0x1d0 [ib_core]
[  739.010469]  ? ib_sg_to_pages+0x1a0/0x1a0 [ib_core]
[  739.011001]  ? wait_for_completion+0x49/0x190
[  739.011549]  ib_drain_qp+0xe/0x30 [ib_core]
[  739.012083]  isert_wait_conn+0x5e/0x330 [ib_isert]
[  739.012609]  ? __local_bh_enable_ip+0x80/0xf0
[  739.013150]  iscsit_close_connection+0x156/0x8f0 [iscsi_target_mod]
[  739.013680]  ? sched_clock_cpu+0xc/0xa0
[  739.014212]  ? __local_bh_enable_ip+0x80/0xf0
[  739.014755]  iscsit_take_action_for_connection_exit+0x7e/0x100 [iscsi_target_mod]
[  739.015337]  iscsi_target_tx_thread+0x170/0x210 [iscsi_target_mod]
[  739.015903]  ? remove_wait_queue+0x60/0x60
[  739.016449]  kthread+0x106/0x140
[  739.017007]  ? iscsit_thread_get_cpumask+0xa0/0xa0 [iscsi_target_mod]
[  739.017558]  ? kthread_bind+0x10/0x10
[  739.018106]  ret_from_fork+0x3a/0x50
[  739.018649] INFO: task iscsi_ttx:3264 blocked for more than 122 seconds.
[  739.019194]       Not tainted 5.4.0+ #69
[  739.019725] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  739.020324] iscsi_ttx       D    0  3264      2 0x80004004
[  739.020896] Call Trace:
[  739.021450]  ? __schedule+0x39b/0x970
[  739.022014]  schedule+0x40/0xc0
[  739.022571]  schedule_timeout+0x1e4/0x310
[  739.023145]  ? find_held_lock+0x38/0xa0
[  739.023705]  ? sched_clock+0x5/0x10
[  739.024287]  ? sched_clock_cpu+0xc/0xa0
[  739.024836]  wait_for_completion+0x12e/0x190
[  739.025407]  ? wake_up_q+0x70/0x70
[  739.025953]  __ib_drain_sq+0x196/0x1d0 [ib_core]
[  739.026490]  ? __lock_acquire+0x283/0x10f0
[  739.027041]  ? ib_sg_to_pages+0x1a0/0x1a0 [ib_core]
[  739.027574]  ? wait_for_completion+0x49/0x190
[  739.028132]  ib_drain_qp+0xe/0x30 [ib_core]
[  739.028656]  isert_wait_conn+0x5e/0x330 [ib_isert]
[  739.029186]  ? __local_bh_enable_ip+0x80/0xf0
[  739.029703]  iscsit_close_connection+0x156/0x8f0 [iscsi_target_mod]
[  739.030223]  ? sched_clock_cpu+0xc/0xa0
[  739.030727]  ? __local_bh_enable_ip+0x80/0xf0
[  739.031245]  iscsit_take_action_for_connection_exit+0x7e/0x100 [iscsi_target_mod]
[  739.031779]  iscsi_target_tx_thread+0x170/0x210 [iscsi_target_mod]
[  739.032347]  ? remove_wait_queue+0x60/0x60
[  739.032882]  kthread+0x106/0x140
[  739.033405]  ? iscsit_thread_get_cpumask+0xa0/0xa0 [iscsi_target_mod]
[  739.033948]  ? kthread_bind+0x10/0x10
[  739.034485]  ret_from_fork+0x3a/0x50
[  739.035040] INFO: task iscsi_trx:3267 blocked for more than 122 seconds.
[  739.035592]       Not tainted 5.4.0+ #69
[  739.036168] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  739.036735] iscsi_trx       D    0  3267      2 0x80004004
[  739.037333] Call Trace:
[  739.037899]  ? __schedule+0x39b/0x970
[  739.038464]  schedule+0x40/0xc0
[  739.039033]  schedule_timeout+0x1e4/0x310
[  739.039588]  ? find_held_lock+0x38/0xa0
[  739.040158]  ? sched_clock+0x5/0x10
[  739.040711]  ? sched_clock_cpu+0xc/0xa0
[  739.041261]  wait_for_completion+0x12e/0x190
[  739.041799]  ? wake_up_q+0x70/0x70
[  739.042362]  __ib_drain_sq+0x196/0x1d0 [ib_core]
[  739.042882]  ? __lock_acquire+0x283/0x10f0
[  739.043420]  ? ib_sg_to_pages+0x1a0/0x1a0 [ib_core]
[  739.043959]  ? wait_for_completion+0x49/0x190
[  739.044497]  ib_drain_qp+0xe/0x30 [ib_core]
[  739.045015]  isert_wait_conn+0x5e/0x330 [ib_isert]
[  739.045524]  ? __local_bh_enable_ip+0x80/0xf0
[  739.046039]  iscsit_close_connection+0x156/0x8f0 [iscsi_target_mod]
[  739.046545]  ? sched_clock_cpu+0xc/0xa0
[  739.047059]  ? __local_bh_enable_ip+0x80/0xf0
[  739.047576]  iscsit_take_action_for_connection_exit+0x7e/0x100 [iscsi_target_mod]
[  739.048123]  iscsi_target_rx_thread+0xdf/0xf0 [iscsi_target_mod]
[  739.048652]  kthread+0x106/0x140
[  739.049187]  ? iscsi_target_tx_thread+0x210/0x210 [iscsi_target_mod]
[  739.049723]  ? kthread_bind+0x10/0x10
[  739.050265]  ret_from_fork+0x3a/0x50
[  739.050816]
Showing all locks held in the system:
[  739.051890] 1 lock held by khungtaskd/140:
[  739.052471]  #0: ffffffffa848a160 (rcu_read_lock){....}, at: debug_show_all_locks+0xe/0x1a0
[  739.053048] 2 locks held by kworker/20:1H/801:
[  739.053599]  #0: ffff9449d1430348 ((wq_completion)ib-comp-wq){+.+.}, at: process_one_work+0x18c/0x590
[  739.054189]  #1: ffffb8494d187e50 ((work_completion)(&cq->work)){+.+.}, at: process_one_work+0x18c/0x590
[  739.054787] 2 locks held by kworker/21:1H/802:
[  739.055410]  #0: ffff9449d1430348 ((wq_completion)ib-comp-wq){+.+.}, at: process_one_work+0x18c/0x590
[  739.056045]  #1: ffffb8494d18fe50 ((work_completion)(&cq->work)){+.+.}, at: process_one_work+0x18c/0x590
[  739.056667] 2 locks held by kworker/18:1H/804:
[  739.057288]  #0: ffff9449d1430348 ((wq_completion)ib-comp-wq){+.+.}, at: process_one_work+0x18c/0x590
[  739.057943]  #1: ffffb8494d11fe50 ((work_completion)(&cq->work)){+.+.}, at: process_one_work+0x18c/0x590
[  739.058590] 1 lock held by dmesg/3283:
[  739.059225]  #0: ffff9448a8cf80e8 (&user->lock){+.+.}, at: devkmsg_read+0x4a/0x2b0

--dDRMvlgZJXvWKvBx--
