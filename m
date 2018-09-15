From: =?utf-8?B?0JDQu9C10LrRgdC10Lkg0JzQsNC60YHQuNC80L7Qsg==?=  <aleksey.i.maksimov@ya
Date: Sat, 15 Sep 2018 05:51:54 +0000
Subject: Re: LIO FC Target on Debian 9 for Windows Server Failover Cluster
Message-Id: <9017551536990714@iva4-e2956935653d.qloud-c.yandex.net>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

Nobody can help me?

17.02.2018, 20:58, "Максимов Алексей" <aleksey.i.maksimov@yandex.ru>:
> Hello, LIO team,
>
> I am asking for help on setting LIO FC Target on Debian 9.
> I'm trying to use LIO for the first time, so my questions can be
> primitive.
>
> I plan to use LIO Target to create a shared disk that will be used for a
> two-node cluster for Hyper-V (in Windows server 2012 R2).
> For the FC Target, I deployed a separate server where QLogic HBA. Two
> other servers are used as FC Initiator.
>
> ---- LIO FC Target server configuration ----
>
> Hardware:
>
> - HP Proliant DL 380 G5
> - HBA FC 4Gb HP FC1242SR (QLE2462 Dual-Port PCI-Express)
>
> Software:
>
> - Fresh-installed Debian GNU/Linux 9.3 "Stretch" with current kernel
> 4.9.0-5-amd64
> - QLogic firmware installed from public Debian Stretch repo - package
> firmware-qlogic_20161130-3_all.deb
> (https://packages.debian.org/stretch/firmware-qlogic)
> - QLogic driver from module qla2xxx (QLogic Fibre Channel HBA Driver
> version:8.07.00.38-k)
>
> ---- FC Initiators configuration ----
>
> Host1:
>
> - HP Proliant DL 380 G5
> - HBA FC 4Gb PCI-E HP A8003A/FC2242SR Dual-Port (Emulex LightPulse FC HBA
> LPE11002)
> - Windows Server 2012 R2
>
> Host2:
>
> - HP Proliant DL 380 G5
> - HBA FC 4Gb PCI-E HP A8002A/FC2142SR Single-Port (Emulex LightPulse FC
> HBA LPE1150)
> - Windows Server 2012 R2
>
> ---- FC connections ----
>
> Hosts are directly connected to the target server:
>
> - FC Initiator Host1 HBA Port0 -> FC Target Server HBA Port0
> - FC Initiator Host2 HBA Port0 -> FC Target Server HBA Port1
>
> ---- What I did on the target server ----
>
> 1) Switched the QLogic driver to target mode:
>
> # cat /etc/modprobe.d/qla2xxx.conf
> options qla2xxx qlini_mode=disabled
>
> # update-initramfs -u
> update-initramfs: Generating /boot/initrd.img-4.9.0-5-amd64
>
> # reboot
>
> # cat /sys/module/qla2xxx/parameters/qlini_mode
> disabled
>
> 2) Install tools from Debian Stretch repo:
>
> # apt-get install targetcli-fb
>
> # targetcli version
> targetcli version 2.1.fb43
>
> 3) Configure backstores, targets, acls
>
> # targetcli /qla2xxx info
> Fabric module name: qla2xxx
> ConfigFS path: /sys/kernel/config/target/qla2xxx
> Allowed WWN types: naa
> Allowed WWNs list: naa.500143800200c204, naa.500143800200c206
> Fabric module features: acls
> Corresponding kernel module: tcm_qla2xxx
>
> # Create Backstores
> #
> targetcli /backstores/block/ create FS04-vDisk1 /dev/cciss/c0d1
> #
> # Create Targets
> #
> targetcli /qla2xxx create naa.500143800200c204
> targetcli /qla2xxx create naa.500143800200c206
> #
> # Create Backstores mapping to Targets
> #
> targetcli /qla2xxx/naa.500143800200c204/luns create
> /backstores/block/FS04-vDisk1
> targetcli /qla2xxx/naa.500143800200c206/luns create
> /backstores/block/FS04-vDisk1
> #
> # Create ACLs
> #
> targetcli /qla2xxx/naa.500143800200c204/acls create 10000000c9782516
> targetcli /qla2xxx/naa.500143800200c206/acls create 10000000c96f2ce4
> #
> # Save config
> # Configuration saved to /etc/rtslib-fb-target/saveconfig.json
> #
> targetcli saveconfig
> #
>
> The resulting configuration is
>
> # targetcli ls
> o- /
> .........................................................................
> .............................................. [...]
>   o- backstores
> .........................................................................
> ................................... [...]
>   | o- block
> .........................................................................
> ....................... [Storage Objects: 1]
>   | | o- FS04-vDisk1
> ............................................................
> [/dev/cciss/c0d1 (205.0GiB) write-thru activated]
>   | o- fileio
> .........................................................................
> ...................... [Storage Objects: 0]
>   | o- pscsi
> .........................................................................
> ....................... [Storage Objects: 0]
>   | o- ramdisk
> .........................................................................
> ..................... [Storage Objects: 0]
>   o- iscsi
> .........................................................................
> ................................. [Targets: 0]
>   o- loopback
> .........................................................................
> .............................. [Targets: 0]
>   o- qla2xxx
> .........................................................................
> ............................... [Targets: 2]
>   | o- naa.500143800200c204
> .........................................................................
> .................. [gen-acls]
>   | | o- acls
> .........................................................................
> ................................. [ACLs: 1]
>   | | | o- naa.10000000c9782516
> .........................................................................
> ........ [Mapped LUNs: 1]
>   | | | o- mapped_lun0
> .........................................................................
> .. [lun0 block/FS04-vDisk1 (rw)]
>   | | o- luns
> .........................................................................
> ................................. [LUNs: 1]
>   | | o- lun0
> .........................................................................
> ... [block/FS04-vDisk1 (/dev/cciss/c0d1)]
>   | o- naa.500143800200c206
> .........................................................................
> .................. [gen-acls]
>   | o- acls
> .........................................................................
> ................................. [ACLs: 1]
>   | | o- naa.10000000c96f2ce4
> .........................................................................
> ........ [Mapped LUNs: 1]
>   | | o- mapped_lun0
> .........................................................................
> .. [lun0 block/FS04-vDisk1 (rw)]
>   | o- luns
> .........................................................................
> ................................. [LUNs: 1]
>   | o- lun0
> .........................................................................
> ... [block/FS04-vDisk1 (/dev/cciss/c0d1)]
>   o- vhost
> .........................................................................
> ................................. [Targets: 0]
>
> As far as I understand, this configuration should be enough to get some
> result.
>
> But the problem is that I can not obtain normal working of LUNs on any
> host. LUN is available on the first host at first, but not on the second.
> Then LUN is available on the second host, but does not work on the second.
> Then the LUNs are not available at all on the two hosts.
>
> Then I try use Windows Server Failover Cluster Validation Wizard on Host1
> or Host 2 for check Storage, but Failover Cluster Validation Report show
> this error:
>
> => Validate SCSI-3 Persistent Reservation
> Description: Validate that storage supports the SCSI-3 Persistent
> Reservation commands.
> .
> Validating Test Disk 0 for Persistent Reservation support.
> Issuing Persistent Reservation REGISTER AND IGNORE EXISTING for Test Disk
> 0 from node VM09.my.com.
> Failure issuing call to Persistent Reservation REGISTER AND IGNORE
> EXISTING on Test Disk 0 from node VM09.my.com when the disk has no
> existing registration. It is expected to succeed. The device is not ready.
> .
> Test Disk 0 does not provide Persistent Reservations support for the
> mechanisms used by failover clusters. Some storage devices require
> specific firmware versions or settings to function properly with failover
> clusters. Please contact your storage administrator or storage vendor to
> check the configuration of the storage to allow it to function properly
> with failover clusters.
> Failure issuing call to Persistent Reservation REGISTER AND IGNORE
> EXISTING on Test Disk 0 from node VM09.my.com when the disk has no
> existing registration. It is expected to succeed. The device is not ready.
> =>
> At this point on the target server console I see errors (dmesg output in
> attachment):
>
> [ 581.933107]
> filp_open(/var/target/pr/aptpl_678d08c9-05e7-408b-a07b-8b627b82421a) for
> APTPL metadata failed
> [ 582.438777]
> filp_open(/var/target/pr/aptpl_678d08c9-05e7-408b-a07b-8b627b82421a) for
> APTPL metadata failed
> [ 582.939944]
> filp_open(/var/target/pr/aptpl_678d08c9-05e7-408b-a07b-8b627b82421a) for
> APTPL metadata failed
> [ 583.439915]
> filp_open(/var/target/pr/aptpl_678d08c9-05e7-408b-a07b-8b627b82421a) for
> APTPL metadata failed
> [ 583.444460]
> filp_open(/var/target/pr/aptpl_678d08c9-05e7-408b-a07b-8b627b82421a) for
> APTPL metadata failed
>
> However, this directory does not exist on the server
>
> # ls -la /var/target/
> ls: cannot access '/var/target/': No such file or directory
>
> So, I created this directory:
>
> # mkdir -p /var/target/pr
>
> Then I started the Windows server cluster validation wizard again and got
> another problem.
> Validating stick on step "Validate Simultaneous Failover - Taking Test
> Disk 0 offline on node {name of Host}"
>
> At this point on the target server console I see errors (dmesg output in
> attachment):
>
> [ 1496.244209] SPC-3 PR: Attempted RESERVE from [qla2xxx]:
> 10:00:00:00:c9:6f:2c:e4 while reservation already held by [qla2xxx]:
> 10:00:00:00:c9:78:25:16, returning RESERVATION_CONFLICT
> [ 1496.762517] SPC-3 PR: Attempted RESERVE from [qla2xxx]:
> 10:00:00:00:c9:78:25:16 while reservation already held by [qla2xxx]:
> 10:00:00:00:c9:6f:2c:e4, returning RESERVATION_CONFLICT
> [ 1497.280926] SPC-3 PR: Attempted RESERVE from [qla2xxx]:
> 10:00:00:00:c9:78:25:16 while reservation already held by [qla2xxx]:
> 10:00:00:00:c9:6f:2c:e4, returning RESERVATION_CONFLICT
> [ 1497.780617] SPC-3 PR: Attempted RESERVE from [qla2xxx]:
> 10:00:00:00:c9:6f:2c:e4 while reservation already held by [qla2xxx]:
> 10:00:00:00:c9:78:25:16, returning RESERVATION_CONFLICT
> [ 1498.314196] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for
> RELEASE
> [ 1498.807717] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for
> RELEASE
> [ 1499.307711] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for
> RELEASE
> [ 1499.823348] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for
> RELEASE
> [ 1500.323350] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for
> RELEASE
> [ 1500.810226] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for
> RELEASE
> [ 1501.318136] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for
> RELEASE
> [ 1501.820221] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for
> RELEASE
> [ 1502.322301] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for
> RELEASE
> [ 1502.329766] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for
> RELEASE
> [ 1502.822321] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for
> RELEASE
> [ 1503.322340] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for
> RELEASE
> [ 1503.822350] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for
> RELEASE
> [ 1504.322363] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for
> RELEASE
> [ 1504.811912] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for
> RELEASE
> [ 1505.311923] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for
> RELEASE
> [ 1505.827549] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for
> RELEASE
> [ 1506.327558] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for
> RELEASE
> [ 1506.441617] SPC-3 PR REGISTER: Received res_key: 0x000000000000000c
> does not match existing SA REGISTER res_key: 0x000000000000000b
> [ 1506.441925] SPC-3 PR REGISTER: Received res_key: 0x000000000000000d
> does not match existing SA REGISTER res_key: 0x000000000000000b
> [ 1508.010105] SPC-3 PR REGISTER: Received res_key: 0x000000000001000c
> does not match existing SA REGISTER res_key: 0x000000000001000b
> [ 1508.020271] SPC-3 PR REGISTER: Received res_key: 0x000000000001000d
> does not match existing SA REGISTER res_key: 0x000000000001000b
> [ 1509.588980] SPC-3 PR: Attempted RESERVE from [qla2xxx]:
> 10:00:00:00:c9:78:25:16 while reservation already held by [qla2xxx]:
> 10:00:00:00:c9:6f:2c:e4, returning RESERVATION_CONFLICT
> [ 1516.112984] SPC-3 PR: Attempted RESERVE from [qla2xxx]:
> 10:00:00:00:c9:6f:2c:e4 while reservation already held by [qla2xxx]:
> 10:00:00:00:c9:78:25:16, returning RESERVATION_CONFLICT
> [ 1522.658794] SPC-3 PR: Attempted RESERVE from [qla2xxx]:
> 10:00:00:00:c9:78:25:16 while reservation already held by [qla2xxx]:
> 10:00:00:00:c9:6f:2c:e4, returning RESERVATION_CONFLICT
> [ 1595.004398] ABORT_TASK: Found referenced qla2xxx task_tag: 1136484
> [ 1595.004400] ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag:
> 1136484
> [ 1653.005826] ABORT_TASK: Found referenced qla2xxx task_tag: 1138200
> [ 1653.005828] ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag:
> 1138200
> [ 1831.011353] ABORT_TASK: Found referenced qla2xxx task_tag: 1139652
> [ 1831.011354] ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag:
> 1139652
> [ 1889.013392] ABORT_TASK: Found referenced qla2xxx task_tag: 1139740
> [ 1889.013393] ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag:
> 1139740
>
> Please help to resolve this situation.
> Maybe I do something wrong? Maybe I have some incompatible versions of
> programs or drivers?
> dmesg and lspci in attachment.
>
> With best wishes,
> Aleksey I. Maksimov.
