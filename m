From: Mikulas Patocka <mpatocka@redhat.com>
Date: Sat, 08 Aug 2020 11:31:39 +0000
Subject: target core warning
Message-Id: <alpine.LRH.2.02.2008080725350.10490@file01.intranet.prod.int.rdu2.redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Joel Becker <jlbec@evilplan.org>, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

Hi

I report that I get this warning on shutdown with the kernel 5.8. The 
warning is 100% reproducible.

Is it a known problem? Should I bisect it?

Mikulas

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 0 PID: 2777 at lib/refcount.c:28 refcount_warn_saturate+0xe1/0x100
Modules linked in: sha256_generic libsha256 blowfish_generic blowfish_common cbc essiv authenc dm_crypt dm_loop dm_mod dax msr iscsi_target_mod target_core_pscsi target_core_file target_core_mod configfs cpufreq_userspace cpufreq_powersave cpufreq_ondemand cpufreq_conservative autofs4 ipv6 ext4 crc32c_generic crc16 mbcache jbd2 hpfs nls_cp852 msdos fat snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore matroxfb_base matroxfb_g450 matroxfb_accel cfbfillrect cfbimgblt cfbcopyarea matroxfb_DAC1064 g450_pll matroxfb_misc floppy fuse powernow_k6 pcspkr evdev via_agp agpgart pata_it821x hid_generic usbhid hid sg e1000 ehci_pci pata_via uhci_hcd ehci_hcd libata usbcore usb_common unix
CPU: 0 PID: 2777 Comm: rmdir Not tainted 5.8.0 #1
Hardware name: System Manufacturer Product Name/VA-503, BIOS 4.51 PG 01/11/01
EIP: refcount_warn_saturate+0xe1/0x100
Code: 56 40 c1 c6 05 42 5f 47 c1 01 e8 fa 2d e4 ff 0f 0b 58 c3 8d b6 00 00 00 00 68 98 56 40 c1 c6 05 44 5f 47 c1 01 e8 df 2d e4 ff <0f> 0b 59 c3 eb 19 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
EAX: 00000026 EBX: deb83238 ECX: c145f08c EDX: c145f088
ESI: deb83098 EDI: e0a6d950 EBP: 00000000 ESP: de371ed0
DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068 EFLAGS: 00010286
CR0: 80050033 CR2: 082d6dfc CR3: 1e901000 CR4: 00000090
Call Trace:
 ? configfs_remove_default_groups+0x33/0x60 [configfs]
 ? target_fabric_drop_tpg+0xa/0x20 [target_core_mod]
 ? configfs_rmdir+0x193/0x2e0 [configfs]
 ? vfs_rmdir+0x53/0x160
 ? do_rmdir+0x144/0x180
 ? do_syscall_32_irqs_on+0x34/0x1a0
 ? exc_page_fault+0x183/0x3e0
 ? do_int80_syscall_32+0x6/0x20
 ? entry_INT80_32+0xf1/0xf1
---[ end trace 59dc38640589748b ]---
