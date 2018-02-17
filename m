From: =?koi8-r?B?7cHL08nNz9cg4czFy9PFyg==?=  <aleksey.i.maksimov@yandex.ru>
Date: Sat, 17 Feb 2018 17:58:41 +0000
Subject: LIO FC Target on Debian 9 for Windows Server Failover Cluster
Message-Id: <000201d3a818$f29181a0$d7b484e0$@yandex.ru>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="----=_NextPart_000_0003_01D3A832.17DEB9A0"
List-Id: <target-devel.vger.kernel.org>
To: target-devel@vger.kernel.org

This is a multipart message in MIME format.

------=_NextPart_000_0003_01D3A832.17DEB9A0
Content-Type: text/plain;
	charset="koi8-r"
Content-Transfer-Encoding: 7bit

Hello, LIO team,


I am asking for help on setting LIO FC Target on Debian 9.
I'm trying to use LIO for the first time, so my questions can be primitive.

I plan to use LIO Target to create a shared disk that will be used for a
two-node cluster for Hyper-V (in Windows server 2012 R2).
For the FC Target, I deployed a separate server where QLogic HBA. Two other
servers are used as FC Initiator.


---- LIO FC Target server configuration ----

Hardware:

- HP Proliant DL 380 G5
- HBA FC 4Gb HP FC1242SR (QLE2462 Dual-Port PCI-Express)

Software:
 
- Fresh-installed Debian GNU/Linux 9.3 "Stretch" with current kernel
4.9.0-5-amd64
- QLogic firmware installed from public Debian Stretch repo - package
firmware-qlogic_20161130-3_all.deb
(https://packages.debian.org/stretch/firmware-qlogic)
- QLogic driver from module qla2xxx (QLogic Fibre Channel HBA Driver
version:8.07.00.38-k)


---- FC Initiators configuration ----

Host1: 

- HP Proliant DL 380 G5
- HBA FC 4Gb PCI-E HP A8003A/FC2242SR Dual-Port (Emulex LightPulse FC HBA
LPE11002) 
- Windows Server 2012 R2

Host2:

- HP Proliant DL 380 G5
- HBA FC 4Gb PCI-E HP A8002A/FC2142SR Single-Port (Emulex LightPulse FC HBA
LPE1150)
- Windows Server 2012 R2


---- FC connections ----

Hosts are directly connected to the target server:

- FC Initiator Host1 HBA Port0 -> FC Target Server HBA Port0
- FC Initiator Host2 HBA Port0 -> FC Target Server HBA Port1


---- What I did on the target server ----

1) Switched the QLogic driver to target mode:

# cat /etc/modprobe.d/qla2xxx.conf
options qla2xxx qlini_mode=disabled

# update-initramfs -u
update-initramfs: Generating /boot/initrd.img-4.9.0-5-amd64

# reboot

# cat /sys/module/qla2xxx/parameters/qlini_mode
disabled

2) Install tools from Debian Stretch repo:

# apt-get install targetcli-fb 

# targetcli version
targetcli version 2.1.fb43

3) Configure backstores, targets, acls


# targetcli /qla2xxx info
Fabric module name: qla2xxx
ConfigFS path: /sys/kernel/config/target/qla2xxx
Allowed WWN types: naa
Allowed WWNs list: naa.500143800200c204, naa.500143800200c206
Fabric module features: acls
Corresponding kernel module: tcm_qla2xxx

# Create Backstores
#
targetcli /backstores/block/ create FS04-vDisk1 /dev/cciss/c0d1
#
# Create Targets
#
targetcli /qla2xxx create naa.500143800200c204
targetcli /qla2xxx create naa.500143800200c206
#
# Create Backstores mapping to Targets
#
targetcli /qla2xxx/naa.500143800200c204/luns create
/backstores/block/FS04-vDisk1
targetcli /qla2xxx/naa.500143800200c206/luns create
/backstores/block/FS04-vDisk1
#
# Create ACLs
#
targetcli /qla2xxx/naa.500143800200c204/acls create 10000000c9782516
targetcli /qla2xxx/naa.500143800200c206/acls create 10000000c96f2ce4
#
# Save config
# Configuration saved to /etc/rtslib-fb-target/saveconfig.json
#
targetcli saveconfig
#


The resulting configuration is

# targetcli ls
o- /
............................................................................
............................................. [...]
  o- backstores
............................................................................
.................................. [...]
  | o- block
............................................................................
...................... [Storage Objects: 1]
  | | o- FS04-vDisk1
.............................................................
[/dev/cciss/c0d1 (205.0GiB) write-thru activated]
  | o- fileio
............................................................................
..................... [Storage Objects: 0]
  | o- pscsi
............................................................................
...................... [Storage Objects: 0]
  | o- ramdisk
............................................................................
.................... [Storage Objects: 0]
  o- iscsi
............................................................................
................................ [Targets: 0]
  o- loopback
............................................................................
............................. [Targets: 0]
  o- qla2xxx
............................................................................
.............................. [Targets: 2]
  | o- naa.500143800200c204
............................................................................
................. [gen-acls]
  | | o- acls
............................................................................
................................ [ACLs: 1]
  | | | o- naa.10000000c9782516
............................................................................
....... [Mapped LUNs: 1]
  | | |   o- mapped_lun0
............................................................................
. [lun0 block/FS04-vDisk1 (rw)]
  | | o- luns
............................................................................
................................ [LUNs: 1]
  | |   o- lun0
............................................................................
.. [block/FS04-vDisk1 (/dev/cciss/c0d1)]
  | o- naa.500143800200c206
............................................................................
................. [gen-acls]
  |   o- acls
............................................................................
................................ [ACLs: 1]
  |   | o- naa.10000000c96f2ce4
............................................................................
....... [Mapped LUNs: 1]
  |   |   o- mapped_lun0
............................................................................
. [lun0 block/FS04-vDisk1 (rw)]
  |   o- luns
............................................................................
................................ [LUNs: 1]
  |     o- lun0
............................................................................
.. [block/FS04-vDisk1 (/dev/cciss/c0d1)]
  o- vhost
............................................................................
................................ [Targets: 0]


As far as I understand, this configuration should be enough to get some
result.

But the problem is that I can not obtain normal working of LUNs on any host.
LUN is available on the first host at first, but not on the second. 
Then LUN is available on the second host, but does not work on the second.
Then the LUNs are not available at all on the two hosts.

Then I try use Windows Server Failover Cluster Validation Wizard on Host1 or
Host 2 for check Storage, but Failover Cluster Validation Report show this
error:

===
Validate SCSI-3 Persistent Reservation
Description: Validate that storage supports the SCSI-3 Persistent
Reservation commands.
.
Validating Test Disk 0 for Persistent Reservation support.
Issuing Persistent Reservation REGISTER AND IGNORE EXISTING for Test Disk 0
from node VM09.my.com.
Failure issuing call to Persistent Reservation REGISTER AND IGNORE EXISTING
on Test Disk 0 from node VM09.my.com when the disk has no existing
registration. It is expected to succeed. The device is not ready.
.
Test Disk 0 does not provide Persistent Reservations support for the
mechanisms used by failover clusters. Some storage devices require specific
firmware versions or settings to function properly with failover clusters.
Please contact your storage administrator or storage vendor to check the
configuration of the storage to allow it to function properly with failover
clusters.
Failure issuing call to Persistent Reservation REGISTER AND IGNORE EXISTING
on Test Disk 0 from node VM09.my.com when the disk has no existing
registration. It is expected to succeed. The device is not ready.
===


At this point on the target server console I see errors (dmesg output in
attachment):


[  581.933107]
filp_open(/var/target/pr/aptpl_678d08c9-05e7-408b-a07b-8b627b82421a) for
APTPL metadata failed
[  582.438777]
filp_open(/var/target/pr/aptpl_678d08c9-05e7-408b-a07b-8b627b82421a) for
APTPL metadata failed
[  582.939944]
filp_open(/var/target/pr/aptpl_678d08c9-05e7-408b-a07b-8b627b82421a) for
APTPL metadata failed
[  583.439915]
filp_open(/var/target/pr/aptpl_678d08c9-05e7-408b-a07b-8b627b82421a) for
APTPL metadata failed
[  583.444460]
filp_open(/var/target/pr/aptpl_678d08c9-05e7-408b-a07b-8b627b82421a) for
APTPL metadata failed

However, this directory does not exist on the server

# ls -la /var/target/
ls: cannot access '/var/target/': No such file or directory

So, I created this directory: 

# mkdir -p /var/target/pr

Then I started the Windows server cluster validation wizard again and got
another problem.
Validating stick on step "Validate Simultaneous Failover - Taking Test Disk
0 offline on node {name of Host}"


At this point on the target server console I see errors (dmesg output in
attachment):

[ 1496.244209] SPC-3 PR: Attempted RESERVE from [qla2xxx]:
10:00:00:00:c9:6f:2c:e4 while reservation already held by [qla2xxx]:
10:00:00:00:c9:78:25:16, returning RESERVATION_CONFLICT
[ 1496.762517] SPC-3 PR: Attempted RESERVE from [qla2xxx]:
10:00:00:00:c9:78:25:16 while reservation already held by [qla2xxx]:
10:00:00:00:c9:6f:2c:e4, returning RESERVATION_CONFLICT
[ 1497.280926] SPC-3 PR: Attempted RESERVE from [qla2xxx]:
10:00:00:00:c9:78:25:16 while reservation already held by [qla2xxx]:
10:00:00:00:c9:6f:2c:e4, returning RESERVATION_CONFLICT
[ 1497.780617] SPC-3 PR: Attempted RESERVE from [qla2xxx]:
10:00:00:00:c9:6f:2c:e4 while reservation already held by [qla2xxx]:
10:00:00:00:c9:78:25:16, returning RESERVATION_CONFLICT
[ 1498.314196] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for RELEASE
[ 1498.807717] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for RELEASE
[ 1499.307711] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for RELEASE
[ 1499.823348] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for RELEASE
[ 1500.323350] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for RELEASE
[ 1500.810226] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for RELEASE
[ 1501.318136] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for RELEASE
[ 1501.820221] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for RELEASE
[ 1502.322301] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for RELEASE
[ 1502.329766] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for RELEASE
[ 1502.822321] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for RELEASE
[ 1503.322340] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for RELEASE
[ 1503.822350] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for RELEASE
[ 1504.322363] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for RELEASE
[ 1504.811912] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for RELEASE
[ 1505.311923] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for RELEASE
[ 1505.827549] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for RELEASE
[ 1506.327558] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for RELEASE
[ 1506.441617] SPC-3 PR REGISTER: Received res_key: 0x000000000000000c does
not match existing SA REGISTER res_key: 0x000000000000000b
[ 1506.441925] SPC-3 PR REGISTER: Received res_key: 0x000000000000000d does
not match existing SA REGISTER res_key: 0x000000000000000b
[ 1508.010105] SPC-3 PR REGISTER: Received res_key: 0x000000000001000c does
not match existing SA REGISTER res_key: 0x000000000001000b
[ 1508.020271] SPC-3 PR REGISTER: Received res_key: 0x000000000001000d does
not match existing SA REGISTER res_key: 0x000000000001000b
[ 1509.588980] SPC-3 PR: Attempted RESERVE from [qla2xxx]:
10:00:00:00:c9:78:25:16 while reservation already held by [qla2xxx]:
10:00:00:00:c9:6f:2c:e4, returning RESERVATION_CONFLICT
[ 1516.112984] SPC-3 PR: Attempted RESERVE from [qla2xxx]:
10:00:00:00:c9:6f:2c:e4 while reservation already held by [qla2xxx]:
10:00:00:00:c9:78:25:16, returning RESERVATION_CONFLICT
[ 1522.658794] SPC-3 PR: Attempted RESERVE from [qla2xxx]:
10:00:00:00:c9:78:25:16 while reservation already held by [qla2xxx]:
10:00:00:00:c9:6f:2c:e4, returning RESERVATION_CONFLICT
[ 1595.004398] ABORT_TASK: Found referenced qla2xxx task_tag: 1136484
[ 1595.004400] ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag:
1136484
[ 1653.005826] ABORT_TASK: Found referenced qla2xxx task_tag: 1138200
[ 1653.005828] ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag:
1138200
[ 1831.011353] ABORT_TASK: Found referenced qla2xxx task_tag: 1139652
[ 1831.011354] ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag:
1139652
[ 1889.013392] ABORT_TASK: Found referenced qla2xxx task_tag: 1139740
[ 1889.013393] ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag:
1139740

Please help to resolve this situation. 
Maybe I do something wrong? Maybe I have some incompatible versions of
programs or drivers?
dmesg and lspci in attachment.

With best wishes, 
Aleksey I. Maksimov.


------=_NextPart_000_0003_01D3A832.17DEB9A0
Content-Type: text/plain;
	name="lspci.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="lspci.txt"

# lspci -vvv
00:00.0 Host bridge: Intel Corporation 5000P Chipset Memory Controller =
Hub (rev b1)
        Subsystem: Hewlett-Packard Company 5000P Chipset Memory =
Controller Hub
        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 =
PME-
        Capabilities: [58] MSI: Enable- Count=3D1/2 Maskable- 64bit-
                Address: fee00000  Data: 0000
        Capabilities: [6c] Express (v1) Root Port (Slot-), MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0
                        ExtTag- RBE-
                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ =
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- =
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s, Exit =
Latency L0s unlimited, L1 unlimited
                        ClockPM- Surprise+ LLActRep+ BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ =
DLActive+ BWMgmt- ABWMgmt-
                RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ =
PMEIntEna+ CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES+ TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UESvrt: DLP+ SDES- TLP+ FCP+ CmpltTO+ CmpltAbrt+ =
UnxCmplt+ RxOF+ MalfTLP+ ECRC- UnsupReq+ ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- =
NonFatalErr-
                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ =
NonFatalErr-
                AERCap: First Error Pointer: 15, GenCap- CGenEn- ChkCap- =
ChkEn-

00:02.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 =
Port 2 (rev b1) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D09, subordinate=3D12, =
sec-latency=3D0
        I/O behind bridge: 00005000-00005fff
        Memory behind bridge: f3e00000-f7ffffff
        Prefetchable memory behind bridge: =
00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 =
PME-
        Capabilities: [58] MSI: Enable- Count=3D1/2 Maskable- 64bit-
                Address: fee00000  Data: 0000
        Capabilities: [6c] Express (v1) Root Port (Slot-), MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0
                        ExtTag- RBE-
                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ =
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- =
TransPend-
                LnkCap: Port #2, Speed 2.5GT/s, Width x4, ASPM L0s, Exit =
Latency L0s unlimited, L1 unlimited
                        ClockPM- Surprise+ LLActRep+ BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ =
DLActive+ BWMgmt- ABWMgmt-
                RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ =
PMEIntEna+ CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES+ TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UESvrt: DLP+ SDES- TLP+ FCP+ CmpltTO+ CmpltAbrt+ =
UnxCmplt+ RxOF+ MalfTLP+ ECRC- UnsupReq+ ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- =
NonFatalErr-
                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ =
NonFatalErr-
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- =
ChkEn-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:03.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 =
Port 3 (rev b1) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D06, subordinate=3D08, =
sec-latency=3D0
        I/O behind bridge: 00004000-00004fff
        Memory behind bridge: f3c00000-f3dfffff
        Prefetchable memory behind bridge: =
00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 =
PME-
        Capabilities: [58] MSI: Enable- Count=3D1/2 Maskable- 64bit-
                Address: fee00000  Data: 0000
        Capabilities: [6c] Express (v1) Root Port (Slot-), MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0
                        ExtTag- RBE-
                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ =
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- =
TransPend-
                LnkCap: Port #3, Speed 2.5GT/s, Width x4, ASPM L0s, Exit =
Latency L0s unlimited, L1 unlimited
                        ClockPM- Surprise+ LLActRep+ BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ =
DLActive+ BWMgmt- ABWMgmt-
                RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ =
PMEIntEna+ CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES+ TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UESvrt: DLP+ SDES- TLP+ FCP+ CmpltTO+ CmpltAbrt+ =
UnxCmplt+ RxOF+ MalfTLP+ ECRC- UnsupReq+ ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- =
NonFatalErr-
                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ =
NonFatalErr-
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- =
ChkEn-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:04.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 =
Port 4-5 (rev b1) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D13, subordinate=3D15, =
sec-latency=3D0
        I/O behind bridge: 00006000-00006fff
        Memory behind bridge: f9d00000-f9ffffff
        Prefetchable memory behind bridge: =
00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 =
PME-
        Capabilities: [58] MSI: Enable- Count=3D1/2 Maskable- 64bit-
                Address: fee00000  Data: 0000
        Capabilities: [6c] Express (v1) Root Port (Slot-), MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0
                        ExtTag- RBE-
                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ =
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- =
TransPend-
                LnkCap: Port #4, Speed 2.5GT/s, Width x8, ASPM L0s, Exit =
Latency L0s unlimited, L1 unlimited
                        ClockPM- Surprise+ LLActRep+ BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ =
DLActive+ BWMgmt- ABWMgmt-
                RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ =
PMEIntEna+ CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES+ TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UESvrt: DLP+ SDES- TLP+ FCP+ CmpltTO+ CmpltAbrt+ =
UnxCmplt+ RxOF+ MalfTLP+ ECRC- UnsupReq+ ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- =
NonFatalErr-
                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ =
NonFatalErr-
                AERCap: First Error Pointer: 05, GenCap- CGenEn- ChkCap- =
ChkEn-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:05.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 =
Port 5 (rev b1) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D16, subordinate=3D16, =
sec-latency=3D0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: =
00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D3 NoSoftRst- PME-Enable+ DSel=3D0 DScale=3D0 =
PME-
        Capabilities: [58] MSI: Enable- Count=3D1/2 Maskable- 64bit-
                Address: fee00000  Data: 0000
        Capabilities: [6c] Express (v1) Root Port (Slot-), MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0
                        ExtTag- RBE-
                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ =
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- =
TransPend-
                LnkCap: Port #5, Speed 2.5GT/s, Width x4, ASPM L0s, Exit =
Latency L0s unlimited, L1 unlimited
                        ClockPM- Surprise+ LLActRep+ BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ =
DLActive- BWMgmt- ABWMgmt-
                RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ =
PMEIntEna+ CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES+ TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UESvrt: DLP+ SDES- TLP+ FCP+ CmpltTO+ CmpltAbrt+ =
UnxCmplt+ RxOF+ MalfTLP+ ECRC- UnsupReq+ ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- =
NonFatalErr-
                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ =
NonFatalErr-
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- =
ChkEn-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:06.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 =
Port 6-7 (rev b1) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D17, subordinate=3D19, =
sec-latency=3D0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fa000000-fdffffff
        Prefetchable memory behind bridge: =
00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 =
PME-
        Capabilities: [58] MSI: Enable- Count=3D1/2 Maskable- 64bit-
                Address: fee00000  Data: 0000
        Capabilities: [6c] Express (v1) Root Port (Slot-), MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0
                        ExtTag- RBE-
                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ =
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- =
TransPend-
                LnkCap: Port #6, Speed 2.5GT/s, Width x8, ASPM L0s, Exit =
Latency L0s unlimited, L1 unlimited
                        ClockPM- Surprise+ LLActRep+ BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ =
DLActive+ BWMgmt- ABWMgmt-
                RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ =
PMEIntEna+ CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES+ TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UESvrt: DLP+ SDES- TLP+ FCP+ CmpltTO+ CmpltAbrt+ =
UnxCmplt+ RxOF+ MalfTLP+ ECRC- UnsupReq+ ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- =
NonFatalErr-
                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ =
NonFatalErr-
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- =
ChkEn-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:07.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 =
Port 7 (rev b1) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D1a, subordinate=3D1a, =
sec-latency=3D0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: =
00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D3 NoSoftRst- PME-Enable+ DSel=3D0 DScale=3D0 =
PME-
        Capabilities: [58] MSI: Enable- Count=3D1/2 Maskable- 64bit-
                Address: fee00000  Data: 0000
        Capabilities: [6c] Express (v1) Root Port (Slot-), MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0
                        ExtTag- RBE-
                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ =
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- =
TransPend-
                LnkCap: Port #7, Speed 2.5GT/s, Width x4, ASPM L0s, Exit =
Latency L0s unlimited, L1 unlimited
                        ClockPM- Surprise+ LLActRep+ BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ =
DLActive- BWMgmt- ABWMgmt-
                RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ =
PMEIntEna+ CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES+ TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UESvrt: DLP+ SDES- TLP+ FCP+ CmpltTO+ CmpltAbrt+ =
UnxCmplt+ RxOF+ MalfTLP+ ECRC- UnsupReq+ ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- =
NonFatalErr-
                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ =
NonFatalErr-
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- =
ChkEn-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:10.0 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers =
(rev b1)
        Subsystem: Hewlett-Packard Company ProLiant DL140 G3
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- =
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Kernel driver in use: i5000_edac
        Kernel modules: i7300_idle, i5k_amb, i5000_edac

00:10.1 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers =
(rev b1)
        Subsystem: Hewlett-Packard Company ProLiant DL140 G3
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- =
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Kernel modules: i7300_idle, i5k_amb, i5000_edac

00:10.2 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers =
(rev b1)
        Subsystem: Hewlett-Packard Company ProLiant DL140 G3
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- =
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Kernel modules: i7300_idle, i5k_amb, i5000_edac

00:11.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved =
Registers (rev b1)
        Subsystem: Hewlett-Packard Company ProLiant DL140 G3
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- =
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:13.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved =
Registers (rev b1)
        Subsystem: Hewlett-Packard Company ProLiant DL140 G3
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- =
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:15.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers =
(rev b1)
        Subsystem: Hewlett-Packard Company ProLiant DL140 G3
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- =
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:16.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers =
(rev b1)
        Subsystem: Hewlett-Packard Company ProLiant DL140 G3
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- =
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:1c.0 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI =
Express Root Port 1 (rev 09) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 24
        Bus: primary=3D00, secondary=3D02, subordinate=3D03, =
sec-latency=3D0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: de000000-dfffffff
        Prefetchable memory behind bridge: =
00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Root Port (Slot-), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag+ RBE-
                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ =
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ =
TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, =
Exit Latency L0s <256ns, L1 <4us
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ =
DLActive- BWMgmt- ABWMgmt-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- =
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [80] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
                Address: feeff00c  Data: 41b1
        Capabilities: [90] Subsystem: Device 0000:0000
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 =
PME-
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
                Arb:    Fixed+ WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=3DFixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=3D00 MaxTimeSlots=3D1 =
RejSnoopTrans-
                        Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- =
WRR256-
                        Ctrl:   Enable+ ID=3D0 ArbSelect=3DFixed =
TC/VC=3Dff
                        Status: NegoPending- InProgress-
                VC1:    Caps:   PATOffset=3D00 MaxTimeSlots=3D1 =
RejSnoopTrans-
                        Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- =
WRR256-
                        Ctrl:   Enable- ID=3D0 ArbSelect=3DFixed =
TC/VC=3D00
                        Status: NegoPending- InProgress-
        Capabilities: [180 v1] Root Complex Link
                Desc:   PortNumber=3D01 ComponentID=3D02 =
EltType=3DConfig
                Link0:  Desc:   TargetPort=3D00 TargetComponent=3D02 =
AssocRCRB- LinkType=3DMemMapped LinkValid+
                        Addr:   00000000fed1c001
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:1c.1 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI =
Express Root Port 2 (rev 09) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 25
        Bus: primary=3D00, secondary=3D04, subordinate=3D05, =
sec-latency=3D0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: f0000000-f1ffffff
        Prefetchable memory behind bridge: =
00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Root Port (Slot-), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag+ RBE-
                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ =
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ =
TransPend-
                LnkCap: Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, =
Exit Latency L0s <256ns, L1 <4us
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ =
DLActive- BWMgmt- ABWMgmt-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- =
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [80] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
                Address: feeff00c  Data: 41d1
        Capabilities: [90] Subsystem: Device 0000:0000
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 =
PME-
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
                Arb:    Fixed+ WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=3DFixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=3D00 MaxTimeSlots=3D1 =
RejSnoopTrans-
                        Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- =
WRR256-
                        Ctrl:   Enable+ ID=3D0 ArbSelect=3DFixed =
TC/VC=3Dff
                        Status: NegoPending- InProgress-
                VC1:    Caps:   PATOffset=3D00 MaxTimeSlots=3D1 =
RejSnoopTrans-
                        Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- =
WRR256-
                        Ctrl:   Enable- ID=3D0 ArbSelect=3DFixed =
TC/VC=3D00
                        Status: NegoPending- InProgress-
        Capabilities: [180 v1] Root Complex Link
                Desc:   PortNumber=3D02 ComponentID=3D02 =
EltType=3DConfig
                Link0:  Desc:   TargetPort=3D00 TargetComponent=3D02 =
AssocRCRB- LinkType=3DMemMapped LinkValid+
                        Addr:   00000000fed1c001
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:1d.0 USB controller: Intel Corporation 631xESB/632xESB/3100 Chipset =
UHCI USB Controller #1 (rev 09) (prog-if 00 [UHCI])
        Subsystem: Hewlett-Packard Company ProLiant DL140 G3
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 4: I/O ports at 1000 [size=3D32]
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci_hcd

00:1d.1 USB controller: Intel Corporation 631xESB/632xESB/3100 Chipset =
UHCI USB Controller #2 (rev 09) (prog-if 00 [UHCI])
        Subsystem: Hewlett-Packard Company ProLiant DL140 G3
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 17
        Region 4: I/O ports at 1020 [size=3D32]
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci_hcd

00:1d.2 USB controller: Intel Corporation 631xESB/632xESB/3100 Chipset =
UHCI USB Controller #3 (rev 09) (prog-if 00 [UHCI])
        Subsystem: Hewlett-Packard Company ProLiant DL140 G3
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        Region 4: I/O ports at 1040 [size=3D32]
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci_hcd

00:1d.3 USB controller: Intel Corporation 631xESB/632xESB/3100 Chipset =
UHCI USB Controller #4 (rev 09) (prog-if 00 [UHCI])
        Subsystem: Hewlett-Packard Company 631xESB/632xESB/3100 Chipset =
UHCI USB Controller
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin D routed to IRQ 19
        Region 4: I/O ports at 1060 [size=3D32]
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci_hcd

00:1d.7 USB controller: Intel Corporation 631xESB/632xESB/3100 Chipset =
EHCI USB2 Controller (rev 09) (prog-if 20 [EHCI])
        Subsystem: Hewlett-Packard Company ProLiant DL140 G3
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at dddf0000 (32-bit, non-prefetchable) =
[size=3D1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 =
PME-
        Capabilities: [58] Debug port: BAR=3D1 offset=3D00a0
        Kernel driver in use: ehci-pci
        Kernel modules: ehci_pci

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9) (prog-if =
01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Bus: primary=3D00, secondary=3D01, subordinate=3D01, =
sec-latency=3D32
        I/O behind bridge: 00002000-00003fff
        Memory behind bridge: dde00000-ddffffff
        Prefetchable memory behind bridge: =
00000000d0000000-00000000d7ffffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Subsystem: Hewlett-Packard Company ProLiant =
DL140 G3

00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC =
Interface Controller (rev 09)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Kernel driver in use: lpc_ich
        Kernel modules: intel_rng, lpc_ich

00:1f.1 IDE interface: Intel Corporation 631xESB/632xESB IDE Controller =
(rev 09) (prog-if 8a [Master SecP PriP])
        Subsystem: Hewlett-Packard Company ProLiant DL140 G3
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 17
        Region 0: I/O ports at 01f0 [size=3D8]
        Region 1: I/O ports at 03f4
        Region 2: I/O ports at 0170 [size=3D8]
        Region 3: I/O ports at 0374
        Region 4: I/O ports at 0500 [size=3D16]
        Kernel driver in use: ata_piix
        Kernel modules: ata_piix, ata_generic

01:03.0 VGA compatible controller: Advanced Micro Devices, Inc. =
[AMD/ATI] ES1000 (rev 02) (prog-if 00 [VGA controller])
        Subsystem: Hewlett-Packard Company ES1000
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr- Stepping+ SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (2000ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at d0000000 (32-bit, prefetchable) =
[size=3D128M]
        Region 1: I/O ports at 3000 [size=3D256]
        Region 2: Memory at ddff0000 (32-bit, non-prefetchable) =
[size=3D64K]
        [virtual] Expansion ROM at 000c0000 [disabled] [size=3D128K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 =
PME-
        Kernel driver in use: radeon
        Kernel modules: radeonfb, radeon

01:04.0 System peripheral: Compaq Computer Corporation Integrated Lights =
Out Controller (rev 03)
        Subsystem: Hewlett-Packard Company Integrated Lights Out =
Controller
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- =
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin A routed to IRQ 21
        Region 0: I/O ports at 2800 [size=3D256]
        Region 1: Memory at ddfe0000 (32-bit, non-prefetchable) =
[size=3D512]
        Capabilities: [f0] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 =
PME-
        Kernel driver in use: hpwdt
        Kernel modules: hpwdt

01:04.2 System peripheral: Compaq Computer Corporation Integrated Lights =
Out  Processor (rev 03)
        Subsystem: Hewlett-Packard Company Integrated Lights Out  =
Processor
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- =
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 22
        BIST result: 00
        Region 0: I/O ports at 3400 [size=3D256]
        Region 1: Memory at ddfd0000 (32-bit, non-prefetchable) =
[size=3D2K]
        Region 2: Memory at ddfc0000 (32-bit, non-prefetchable) =
[size=3D16K]
        Region 3: Memory at ddf00000 (32-bit, non-prefetchable) =
[size=3D512K]
        [virtual] Expansion ROM at dde20000 [disabled] [size=3D64K]
        Capabilities: [f0] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 =
PME-
        Kernel driver in use: hpilo
        Kernel modules: hpilo

01:04.4 USB controller: Hewlett-Packard Company Integrated Lights-Out =
Standard Virtual USB Controller (prog-if 00 [UHCI])
        Subsystem: Hewlett-Packard Company iLO2
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64
        Interrupt: pin B routed to IRQ 22
        Region 4: I/O ports at 3800 [size=3D32]
        Capabilities: [f0] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 =
PME-
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci_hcd

01:04.6 IPMI SMIC interface: Hewlett-Packard Company Integrated =
Lights-Out Standard KCS Interface (prog-if 01)
        Subsystem: Hewlett-Packard Company iLO2
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- =
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at ddef0000 (32-bit, non-prefetchable) =
[size=3D256]
        Capabilities: [f0] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 =
PME-
        Kernel driver in use: ipmi_si
        Kernel modules: ipmi_si

02:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c3) =
(prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D02, secondary=3D03, subordinate=3D03, =
sec-latency=3D64
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: de000000-dfffffff
        Prefetchable memory behind bridge: =
00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [60] Express (v1) PCI-Express to PCI/PCI-X Bridge, =
MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- =
SlotPowerLimit 0.000W
                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ =
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- =
BrConfRtry-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ =
TransPend+
                LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, =
Exit Latency L0s <4us, L1 <4us
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ =
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [90] PCI-X bridge device
                Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- =
Freq=3D133MHz
                Status: Dev=3D02:00.0 64bit- 133MHz- SCD- USC- SCO- SRD-
                Upstream: Capacity=3D0 CommitmentLimit=3D0
                Downstream: Capacity=3D0 CommitmentLimit=3D0
        Capabilities: [b0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D1 =
PME-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UESvrt: DLP+ SDES- TLP+ FCP+ CmpltTO+ CmpltAbrt+ =
UnxCmplt+ RxOF+ MalfTLP+ ECRC- UnsupReq+ ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- =
NonFatalErr-
                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ =
NonFatalErr-
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- =
ChkEn-
        Capabilities: [14c v1] Power Budgeting <?>
        Capabilities: [160 v1] Device Serial Number =
00-1a-4b-ff-fe-b2-66-e8
        Kernel modules: shpchp

03:00.0 Ethernet controller: Broadcom Limited NetXtreme II BCM5708 =
Gigabit Ethernet (rev 12)
        Subsystem: Hewlett-Packard Company NC373i Integrated =
Multifunction Gigabit Server Adapter
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (16000ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 38
        Region 0: Memory at de000000 (64-bit, non-prefetchable) =
[size=3D32M]
        Capabilities: [40] PCI-X non-bridge device
                Command: DPERE- ERO- RBC=3D512 OST=3D8
                Status: Dev=3D03:00.0 64bit+ 133MHz+ SCD- USC- =
DC=3Dsimple DMMRBC=3D512 DMOST=3D8 DMCRS=3D32 RSCEM- 266MHz- 533MHz-
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D1 =
PME-
        Capabilities: [50] Vital Product Data
                Product Name: HP NC373i Multifunction Gigabit Server =
Adapter
                Read-only fields:
                        [PN] Part number: N/A
                        [EC] Engineering changes: N/A
                        [SN] Serial number: 0123456789
                        [MN] Manufacture ID: 31 30 33 43
                        [RV] Reserved: checksum good, 37 byte(s) =
reserved
                End
        Capabilities: [58] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee0800c  Data: 4173
        Kernel driver in use: bnx2
        Kernel modules: bnx2

04:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c3) =
(prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D04, secondary=3D05, subordinate=3D05, =
sec-latency=3D64
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: f0000000-f1ffffff
        Prefetchable memory behind bridge: =
00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [60] Express (v1) PCI-Express to PCI/PCI-X Bridge, =
MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- =
SlotPowerLimit 0.000W
                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ =
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- =
BrConfRtry-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ =
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, =
Exit Latency L0s <4us, L1 <4us
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ =
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [90] PCI-X bridge device
                Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- =
Freq=3D133MHz
                Status: Dev=3D04:00.0 64bit- 133MHz- SCD- USC- SCO- SRD-
                Upstream: Capacity=3D0 CommitmentLimit=3D0
                Downstream: Capacity=3D0 CommitmentLimit=3D0
        Capabilities: [b0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D1 =
PME-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UESvrt: DLP+ SDES- TLP+ FCP+ CmpltTO+ CmpltAbrt+ =
UnxCmplt+ RxOF+ MalfTLP+ ECRC- UnsupReq+ ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- =
NonFatalErr-
                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ =
NonFatalErr-
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- =
ChkEn-
        Capabilities: [14c v1] Power Budgeting <?>
        Capabilities: [160 v1] Device Serial Number =
00-1a-4b-ff-fe-b2-66-e6
        Kernel modules: shpchp

05:00.0 Ethernet controller: Broadcom Limited NetXtreme II BCM5708 =
Gigabit Ethernet (rev 12)
        Subsystem: Hewlett-Packard Company NC373i Integrated =
Multifunction Gigabit Server Adapter
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (16000ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at f0000000 (64-bit, non-prefetchable) =
[size=3D32M]
        Capabilities: [40] PCI-X non-bridge device
                Command: DPERE- ERO- RBC=3D512 OST=3D8
                Status: Dev=3D05:00.0 64bit+ 133MHz+ SCD- USC- =
DC=3Dsimple DMMRBC=3D512 DMOST=3D8 DMCRS=3D32 RSCEM- 266MHz- 533MHz-
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D1 =
PME-
        Capabilities: [50] Vital Product Data
                Product Name: HP NC373i Multifunction Gigabit Server =
Adapter
                Read-only fields:
                        [PN] Part number: N/A
                        [EC] Engineering changes: N/A
                        [SN] Serial number: 0123456789
                        [MN] Manufacture ID: 31 30 33 43
                        [RV] Reserved: checksum good, 37 byte(s) =
reserved
                End
        Capabilities: [58] MSI: Enable- Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee2000c  Data: 4183
        Kernel driver in use: bnx2
        Kernel modules: bnx2

06:00.0 RAID bus controller: Hewlett-Packard Company Smart Array =
Controller (rev 03)
        Subsystem: Hewlett-Packard Company P400 SAS Controller
        Physical Slot: 1
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at f3d00000 (64-bit, non-prefetchable) =
[size=3D1M]
        Region 2: I/O ports at 4000 [size=3D256]
        Region 3: Memory at f3cf0000 (64-bit, non-prefetchable) =
[size=3D4K]
        [virtual] Expansion ROM at f3c00000 [disabled] [size=3D256K]
        Capabilities: [b0] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s =
unlimited, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset- =
SlotPowerLimit 0.000W
                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ =
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq+ AuxPwr- =
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x8, ASPM L0s, Exit =
Latency L0s <2us, L1 unlimited
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk- =
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [d4] MSI-X: Enable+ Count=3D4 Masked-
                Vector table: BAR=3D0 offset=3D000fe000
                PBA: BAR=3D0 offset=3D000ff000
        Capabilities: [e0] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 =
PME-
        Capabilities: [ec] Vital Product Data
pcilib: sysfs_read_vpd: read failed: Input/output error
                Not readable
        Capabilities: [100 v1] Power Budgeting <?>
        Kernel driver in use: cciss
        Kernel modules: cciss, hpsa

09:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express =
Upstream Port (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D09, secondary=3D0a, subordinate=3D11, =
sec-latency=3D0
        I/O behind bridge: 00005000-00005fff
        Memory behind bridge: f3f00000-f7ffffff
        Prefetchable memory behind bridge: =
00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [44] Express (v1) Upstream Port, MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- =
SlotPowerLimit 0.000W
                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ =
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr+ UnsuppReq+ AuxPwr- =
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x8, ASPM L0s, Exit =
Latency L0s unlimited, L1 unlimited
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ =
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 =
PME-
        Capabilities: [80] Subsystem: Device 0000:0000
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UESvrt: DLP+ SDES- TLP+ FCP+ CmpltTO+ CmpltAbrt+ =
UnxCmplt+ RxOF+ MalfTLP+ ECRC- UnsupReq+ ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- =
NonFatalErr-
                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ =
NonFatalErr-
                AERCap: First Error Pointer: 14, GenCap- CGenEn- ChkCap- =
ChkEn-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

09:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to =
PCI-X Bridge (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D09, secondary=3D12, subordinate=3D12, =
sec-latency=3D64
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: =
00000000fff00000-00000000000fffff
        Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [44] Express (v1) PCI-Express to PCI/PCI-X Bridge, =
MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- =
SlotPowerLimit 0.000W
                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ =
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- =
BrConfRtry-
                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr+ UnsuppReq+ AuxPwr- =
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x8, ASPM L0s, Exit =
Latency L0s unlimited, L1 unlimited
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk- =
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [6c] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 =
PME-
        Capabilities: [80] Subsystem: Device 0000:0000
        Capabilities: [d8] PCI-X bridge device
                Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- =
Freq=3D133MHz
                Status: Dev=3D00:00.3 64bit- 133MHz- SCD- USC- SCO- SRD-
                Upstream: Capacity=3D65535 CommitmentLimit=3D65535
                Downstream: Capacity=3D65535 CommitmentLimit=3D65535
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UESvrt: DLP+ SDES- TLP+ FCP+ CmpltTO+ CmpltAbrt+ =
UnxCmplt+ RxOF+ MalfTLP+ ECRC- UnsupReq+ ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- =
NonFatalErr-
                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ =
NonFatalErr-
                AERCap: First Error Pointer: 14, GenCap- CGenEn- ChkCap- =
ChkEn-
        Kernel modules: shpchp

0a:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express =
Downstream Port E1 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Bus: primary=3D0a, secondary=3D0b, subordinate=3D0d, =
sec-latency=3D0
        I/O behind bridge: 00005000-00005fff
        Memory behind bridge: f3f00000-f3ffffff
        Prefetchable memory behind bridge: =
00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [44] Express (v1) Downstream Port (Slot-), MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0
                        ExtTag- RBE-
                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ =
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- =
TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x4, ASPM L0s, Exit =
Latency L0s unlimited, L1 unlimited
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ =
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [60] MSI: Enable- Count=3D1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 =
PME-
        Capabilities: [80] Subsystem: Device 0000:0000
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UESvrt: DLP+ SDES- TLP+ FCP+ CmpltTO+ CmpltAbrt+ =
UnxCmplt+ RxOF+ MalfTLP+ ECRC- UnsupReq+ ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- =
NonFatalErr-
                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ =
NonFatalErr-
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- =
ChkEn-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

0a:01.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express =
Downstream Port E2 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 17
        Bus: primary=3D0a, secondary=3D0e, subordinate=3D10, =
sec-latency=3D0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: f4000000-f7ffffff
        Prefetchable memory behind bridge: =
00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [44] Express (v1) Downstream Port (Slot-), MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0
                        ExtTag- RBE-
                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ =
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- =
TransPend-
                LnkCap: Port #2, Speed 2.5GT/s, Width x4, ASPM L0s, Exit =
Latency L0s unlimited, L1 unlimited
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ =
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [60] MSI: Enable- Count=3D1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 =
PME-
        Capabilities: [80] Subsystem: Device 0000:0000
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UESvrt: DLP+ SDES- TLP+ FCP+ CmpltTO+ CmpltAbrt+ =
UnxCmplt+ RxOF+ MalfTLP+ ECRC- UnsupReq+ ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- =
NonFatalErr-
                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ =
NonFatalErr-
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- =
ChkEn-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

0a:02.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express =
Downstream Port E3 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Bus: primary=3D0a, secondary=3D11, subordinate=3D11, =
sec-latency=3D0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: =
00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [44] Express (v1) Downstream Port (Slot-), MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0
                        ExtTag- RBE-
                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ =
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- =
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s, Exit =
Latency L0s unlimited, L1 unlimited
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk- =
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [60] MSI: Enable- Count=3D1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D3 NoSoftRst- PME-Enable+ DSel=3D0 DScale=3D0 =
PME-
        Capabilities: [80] Subsystem: Device 0000:0000
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UESvrt: DLP+ SDES- TLP+ FCP+ CmpltTO+ CmpltAbrt+ =
UnxCmplt+ RxOF+ MalfTLP+ ECRC- UnsupReq+ ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- =
NonFatalErr-
                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ =
NonFatalErr-
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- =
ChkEn-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

0b:00.0 Fibre Channel: QLogic Corp. ISP2432-based 4Gb Fibre Channel to =
PCI Express HBA (rev 03)
        Subsystem: Hewlett-Packard Company ISP2432-based 4Gb Fibre =
Channel to PCI Express HBA
        Physical Slot: 2
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: I/O ports at 5000 [size=3D256]
        Region 1: Memory at f3ff0000 (64-bit, non-prefetchable) =
[size=3D16K]
        [virtual] Expansion ROM at f3f00000 [disabled] [size=3D256K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 =
PME-
        Capabilities: [4c] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 1024 bytes, PhantFunc 0, Latency L0s =
<4us, L1 <1us
                        ExtTag- AttnBtn+ AttnInd+ PwrInd+ RBE- FLReset- =
SlotPowerLimit 0.000W
                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ =
Unsupported+
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr+ UnsuppReq+ AuxPwr- =
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s, Exit =
Latency L0s <4us, L1 unlimited
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ =
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [64] MSI: Enable- Count=3D1/16 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [74] Vital Product Data
                Product Name: PCI-Express Dual Port 4Gb Fibre Channel =
HBA
                Read-only fields:
                        [PN] Part number: AE312-60001
                        [EC] Engineering changes: C-4830
                        [SN] Serial number: MXK084077W
                        [V0] Vendor specific: PW=3D15W
                        [V2] Vendor specific: 4840
                        [MN] Manufacture ID: 50 58 32 35 31 30 34 30 31 =
2d 36 39 20 20 42
                        [V1] Vendor specific: 02.22
                        [V3] Vendor specific: 05.03.15
                        [V4] Vendor specific: 03.13
                        [V5] Vendor specific: 02.03
                        [YA] Asset tag: NA
                        [RV] Reserved: checksum good, 0 byte(s) reserved
                End
        Capabilities: [7c] MSI-X: Enable- Count=3D16 Masked-
                Vector table: BAR=3D1 offset=3D00002000
                PBA: BAR=3D1 offset=3D00003000
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt+ RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UESvrt: DLP+ SDES- TLP+ FCP+ CmpltTO+ CmpltAbrt+ =
UnxCmplt+ RxOF+ MalfTLP+ ECRC- UnsupReq+ ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- =
NonFatalErr-
                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ =
NonFatalErr-
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ =
ChkEn-
        Capabilities: [138 v1] Power Budgeting <?>
        Kernel driver in use: qla2xxx
        Kernel modules: qla2xxx

0b:00.1 Fibre Channel: QLogic Corp. ISP2432-based 4Gb Fibre Channel to =
PCI Express HBA (rev 03)
        Subsystem: Hewlett-Packard Company ISP2432-based 4Gb Fibre =
Channel to PCI Express HBA
        Physical Slot: 2
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 17
        Region 0: I/O ports at 5400 [size=3D256]
        Region 1: Memory at f3fe0000 (64-bit, non-prefetchable) =
[size=3D16K]
        [virtual] Expansion ROM at f3f40000 [disabled] [size=3D256K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 =
PME-
        Capabilities: [4c] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 1024 bytes, PhantFunc 0, Latency L0s =
<4us, L1 <1us
                        ExtTag- AttnBtn+ AttnInd+ PwrInd+ RBE- FLReset- =
SlotPowerLimit 0.000W
                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ =
Unsupported+
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr+ UnsuppReq+ AuxPwr- =
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s, Exit =
Latency L0s <4us, L1 unlimited
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ =
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [64] MSI: Enable- Count=3D1/16 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [74] Vital Product Data
                Product Name: PCI-Express Dual Port 4Gb Fibre Channel =
HBA
                Read-only fields:
                        [PN] Part number: AE312-60001
                        [EC] Engineering changes: C-4830
                        [SN] Serial number: MXK084077W
                        [V0] Vendor specific: PW=3D15W
                        [V2] Vendor specific: 4840
                        [MN] Manufacture ID: 50 58 32 35 31 30 34 30 31 =
2d 36 39 20 20 42
                        [V1] Vendor specific: 02.22
                        [V3] Vendor specific: 05.03.15
                        [V4] Vendor specific: 03.13
                        [V5] Vendor specific: 02.03
                        [YA] Asset tag: NA
                        [RV] Reserved: checksum good, 0 byte(s) reserved
                End
        Capabilities: [7c] MSI-X: Enable- Count=3D16 Masked-
                Vector table: BAR=3D1 offset=3D00002000
                PBA: BAR=3D1 offset=3D00003000
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt+ RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UESvrt: DLP+ SDES- TLP+ FCP+ CmpltTO+ CmpltAbrt+ =
UnxCmplt+ RxOF+ MalfTLP+ ECRC- UnsupReq+ ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- =
NonFatalErr-
                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ =
NonFatalErr-
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ =
ChkEn-
        Capabilities: [138 v1] Power Budgeting <?>
        Kernel driver in use: qla2xxx
        Kernel modules: qla2xxx

0e:00.0 PCI bridge: Intel Corporation 41210 [Lanai] Serial to Parallel =
PCI Bridge (A-Segment Bridge) (rev 09) (prog-if 00 [Normal decode])
        Physical Slot: 3
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D0e, secondary=3D0f, subordinate=3D0f, =
sec-latency=3D64
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: f4000000-f5ffffff
        Prefetchable memory behind bridge: =
00000000fff00000-00000000000fffff
        Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [44] Express (v1) PCI-Express to PCI/PCI-X Bridge, =
MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- =
SlotPowerLimit 0.000W
                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ =
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- =
BrConfRtry-
                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr+ UnsuppReq+ AuxPwr- =
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x8, ASPM L0s, Exit =
Latency L0s unlimited, L1 unlimited
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk- =
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [5c] MSI: Enable- Count=3D1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [6c] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 =
PME-
        Capabilities: [d8] PCI-X bridge device
                Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- =
Freq=3D100MHz
                Status: Dev=3D0e:00.0 64bit- 133MHz- SCD- USC- SCO- SRD-
                Upstream: Capacity=3D65535 CommitmentLimit=3D65535
                Downstream: Capacity=3D65535 CommitmentLimit=3D65535
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UESvrt: DLP+ SDES- TLP+ FCP+ CmpltTO+ CmpltAbrt+ =
UnxCmplt+ RxOF+ MalfTLP+ ECRC- UnsupReq+ ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- =
NonFatalErr-
                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ =
NonFatalErr-
                AERCap: First Error Pointer: 14, GenCap- CGenEn- ChkCap- =
ChkEn-
        Capabilities: [300 v1] Power Budgeting <?>
        Kernel modules: shpchp

0e:00.2 PCI bridge: Intel Corporation 41210 [Lanai] Serial to Parallel =
PCI Bridge (B-Segment Bridge) (rev 09) (prog-if 00 [Normal decode])
        Physical Slot: 3
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D0e, secondary=3D10, subordinate=3D10, =
sec-latency=3D64
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: f6000000-f7ffffff
        Prefetchable memory behind bridge: =
00000000fff00000-00000000000fffff
        Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [44] Express (v1) PCI-Express to PCI/PCI-X Bridge, =
MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- =
SlotPowerLimit 0.000W
                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ =
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- =
BrConfRtry-
                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr+ UnsuppReq+ AuxPwr- =
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x8, ASPM L0s, Exit =
Latency L0s unlimited, L1 unlimited
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk- =
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [5c] MSI: Enable- Count=3D1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [6c] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 =
PME-
        Capabilities: [d8] PCI-X bridge device
                Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- =
Freq=3D100MHz
                Status: Dev=3D0e:00.2 64bit- 133MHz- SCD- USC- SCO- SRD-
                Upstream: Capacity=3D65535 CommitmentLimit=3D65535
                Downstream: Capacity=3D65535 CommitmentLimit=3D65535
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UESvrt: DLP+ SDES- TLP+ FCP+ CmpltTO+ CmpltAbrt+ =
UnxCmplt+ RxOF+ MalfTLP+ ECRC- UnsupReq+ ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- =
NonFatalErr-
                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ =
NonFatalErr-
                AERCap: First Error Pointer: 14, GenCap- CGenEn- ChkCap- =
ChkEn-
        Capabilities: [300 v1] Power Budgeting <?>
        Kernel modules: shpchp

0f:04.0 Ethernet controller: Broadcom Limited NetXtreme II BCM5706 =
Gigabit Ethernet (rev 02)
        Subsystem: Hewlett-Packard Company NC380T PCI Express Dual Port =
Multifunction Gigabit Server Adapter
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (16000ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at f4000000 (64-bit, non-prefetchable) =
[size=3D32M]
        Capabilities: [40] PCI-X non-bridge device
                Command: DPERE- ERO- RBC=3D512 OST=3D8
                Status: Dev=3D0f:04.0 64bit+ 133MHz+ SCD- USC- =
DC=3Dsimple DMMRBC=3D512 DMOST=3D8 DMCRS=3D32 RSCEM- 266MHz- 533MHz-
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D1 =
PME-
        Capabilities: [50] Vital Product Data
                Product Name: HP NC380T Dual Multifunction Gig Server =
Adapter
                Read-only fields:
                        [PN] Part number: 012392-002
                        [EC] Engineering changes: 0A
                        [SN] Serial number: 0123456789
                        [MN] Manufacture ID: 31 30 33 43
                        [RV] Reserved: checksum good, 30 byte(s) =
reserved
                End
        Capabilities: [58] MSI: Enable- Count=3D1/1 Maskable- 64bit+
                Address: f7e7fb9ef1bf8dd8  Data: fff3
        Kernel driver in use: bnx2
        Kernel modules: bnx2

10:05.0 Ethernet controller: Broadcom Limited NetXtreme II BCM5706 =
Gigabit Ethernet (rev 02)
        Subsystem: Hewlett-Packard Company NC380T PCI Express Dual Port =
Multifunction Gigabit Server Adapter
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (16000ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at f6000000 (64-bit, non-prefetchable) =
[size=3D32M]
        Capabilities: [40] PCI-X non-bridge device
                Command: DPERE- ERO- RBC=3D512 OST=3D8
                Status: Dev=3D10:05.0 64bit+ 133MHz+ SCD- USC- =
DC=3Dsimple DMMRBC=3D512 DMOST=3D8 DMCRS=3D32 RSCEM- 266MHz- 533MHz-
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D1 =
PME-
        Capabilities: [50] Vital Product Data
                Product Name: HP NC380T Dual Multifunction Gig Server =
Adapter
                Read-only fields:
                        [PN] Part number: 012392-002
                        [EC] Engineering changes: 0A
                        [SN] Serial number: 0123456789
                        [MN] Manufacture ID: 31 30 33 43
                        [RV] Reserved: checksum good, 30 byte(s) =
reserved
                End
        Capabilities: [58] MSI: Enable- Count=3D1/1 Maskable- 64bit+
                Address: 8c00cb2143d40018  Data: 1020
        Kernel driver in use: bnx2
        Kernel modules: bnx2

13:00.0 RAID bus controller: Hewlett-Packard Company Smart Array G6 =
controllers (rev 01)
        Subsystem: Hewlett-Packard Company Smart Array P411
        Physical Slot: 5
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at f9e00000 (64-bit, non-prefetchable) =
[size=3D2M]
        Region 2: Memory at f9df0000 (64-bit, non-prefetchable) =
[size=3D4K]
        Region 4: I/O ports at 6000 [size=3D256]
        [virtual] Expansion ROM at f9d00000 [disabled] [size=3D512K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA =
PME(D0+,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 =
PME-
        Capabilities: [50] MSI: Enable- Count=3D1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s =
<1us, L1 <8us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- =
SlotPowerLimit 116.000W
                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ =
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr+ UnsuppReq+ AuxPwr- =
TransPend-
                LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM not =
supported, Exit Latency L0s <512ns, L1 <64us
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ =
DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis+, =
LTR-, OBFF Not Supported
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, =
LTR-, OBFF Disabled
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- =
SpeedDis-
                         Transmit Margin: Normal Operating Range, =
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB, =
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-, =
LinkEqualizationRequest-
        Capabilities: [ac] MSI-X: Enable+ Count=3D16 Masked-
                Vector table: BAR=3D0 offset=3D001c2000
                PBA: BAR=3D0 offset=3D001c4000
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UESvrt: DLP+ SDES+ TLP+ FCP+ CmpltTO+ CmpltAbrt+ =
UnxCmplt+ RxOF+ MalfTLP+ ECRC- UnsupReq+ ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- =
NonFatalErr-
                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ =
NonFatalErr+
                AERCap: First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ =
ChkEn-
        Kernel driver in use: hpsa
        Kernel modules: hpsa

17:00.0 PCI bridge: Intel Corporation 41210 [Lanai] Serial to Parallel =
PCI Bridge (A-Segment Bridge) (rev 09) (prog-if 00 [Normal decode])
        Physical Slot: 4
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D17, secondary=3D18, subordinate=3D18, =
sec-latency=3D64
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fa000000-fbffffff
        Prefetchable memory behind bridge: =
00000000fff00000-00000000000fffff
        Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [44] Express (v1) PCI-Express to PCI/PCI-X Bridge, =
MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- =
SlotPowerLimit 0.000W
                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ =
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- =
BrConfRtry-
                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr+ UnsuppReq+ AuxPwr- =
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x8, ASPM L0s, Exit =
Latency L0s unlimited, L1 unlimited
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk- =
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [5c] MSI: Enable- Count=3D1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [6c] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 =
PME-
        Capabilities: [d8] PCI-X bridge device
                Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- =
Freq=3D100MHz
                Status: Dev=3D17:00.0 64bit- 133MHz- SCD- USC- SCO- SRD-
                Upstream: Capacity=3D65535 CommitmentLimit=3D65535
                Downstream: Capacity=3D65535 CommitmentLimit=3D65535
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UESvrt: DLP+ SDES- TLP+ FCP+ CmpltTO+ CmpltAbrt+ =
UnxCmplt+ RxOF+ MalfTLP+ ECRC- UnsupReq+ ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- =
NonFatalErr-
                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ =
NonFatalErr-
                AERCap: First Error Pointer: 14, GenCap- CGenEn- ChkCap- =
ChkEn-
        Capabilities: [300 v1] Power Budgeting <?>
        Kernel modules: shpchp

17:00.2 PCI bridge: Intel Corporation 41210 [Lanai] Serial to Parallel =
PCI Bridge (B-Segment Bridge) (rev 09) (prog-if 00 [Normal decode])
        Physical Slot: 4
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D17, secondary=3D19, subordinate=3D19, =
sec-latency=3D64
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fc000000-fdffffff
        Prefetchable memory behind bridge: =
00000000fff00000-00000000000fffff
        Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [44] Express (v1) PCI-Express to PCI/PCI-X Bridge, =
MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- =
SlotPowerLimit 0.000W
                DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ =
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- =
BrConfRtry-
                        MaxPayload 256 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr+ UnsuppReq+ AuxPwr- =
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x8, ASPM L0s, Exit =
Latency L0s unlimited, L1 unlimited
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk- =
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [5c] MSI: Enable- Count=3D1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [6c] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 =
PME-
        Capabilities: [d8] PCI-X bridge device
                Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- =
Freq=3D100MHz
                Status: Dev=3D17:00.2 64bit- 133MHz- SCD- USC- SCO- SRD-
                Upstream: Capacity=3D65535 CommitmentLimit=3D65535
                Downstream: Capacity=3D65535 CommitmentLimit=3D65535
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- =
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UESvrt: DLP+ SDES- TLP+ FCP+ CmpltTO+ CmpltAbrt+ =
UnxCmplt+ RxOF+ MalfTLP+ ECRC- UnsupReq+ ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- =
NonFatalErr-
                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ =
NonFatalErr-
                AERCap: First Error Pointer: 14, GenCap- CGenEn- ChkCap- =
ChkEn-
        Capabilities: [300 v1] Power Budgeting <?>
        Kernel modules: shpchp

18:04.0 Ethernet controller: Broadcom Limited NetXtreme II BCM5706 =
Gigabit Ethernet (rev 02)
        Subsystem: Hewlett-Packard Company NC380T PCI Express Dual Port =
Multifunction Gigabit Server Adapter
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (16000ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at fa000000 (64-bit, non-prefetchable) =
[size=3D32M]
        Capabilities: [40] PCI-X non-bridge device
                Command: DPERE- ERO- RBC=3D512 OST=3D8
                Status: Dev=3D18:04.0 64bit+ 133MHz+ SCD- USC- =
DC=3Dsimple DMMRBC=3D512 DMOST=3D8 DMCRS=3D32 RSCEM- 266MHz- 533MHz-
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D1 =
PME-
        Capabilities: [50] Vital Product Data
                Product Name: HP NC380T Dual Multifunction Gig Server =
Adapter
                Read-only fields:
                        [PN] Part number: 012392-002
                        [EC] Engineering changes: 0A
                        [SN] Serial number: 0123456789
                        [MN] Manufacture ID: 31 30 33 43
                        [RV] Reserved: checksum good, 30 byte(s) =
reserved
                End
        Capabilities: [58] MSI: Enable- Count=3D1/1 Maskable- 64bit+
                Address: fffbffff7f7f7fbc  Data: fdff
        Kernel driver in use: bnx2
        Kernel modules: bnx2

19:05.0 Ethernet controller: Broadcom Limited NetXtreme II BCM5706 =
Gigabit Ethernet (rev 02)
        Subsystem: Hewlett-Packard Company NC380T PCI Express Dual Port =
Multifunction Gigabit Server Adapter
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- =
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (16000ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fc000000 (64-bit, non-prefetchable) =
[size=3D32M]
        Capabilities: [40] PCI-X non-bridge device
                Command: DPERE- ERO- RBC=3D512 OST=3D8
                Status: Dev=3D19:05.0 64bit+ 133MHz+ SCD- USC- =
DC=3Dsimple DMMRBC=3D512 DMOST=3D8 DMCRS=3D32 RSCEM- 266MHz- 533MHz-
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D1 =
PME-
        Capabilities: [50] Vital Product Data
                Product Name: HP NC380T Dual Multifunction Gig Server =
Adapter
                Read-only fields:
                        [PN] Part number: 012392-002
                        [EC] Engineering changes: 0A
                        [SN] Serial number: 0123456789
                        [MN] Manufacture ID: 31 30 33 43
                        [RV] Reserved: checksum good, 30 byte(s) =
reserved
                End
        Capabilities: [58] MSI: Enable- Count=3D1/1 Maskable- 64bit+
                Address: 2defef09679cafdc  Data: fbb8
        Kernel driver in use: bnx2
        Kernel modules: bnx2

------=_NextPart_000_0003_01D3A832.17DEB9A0
Content-Type: text/plain;
	name="dmesg.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg.txt"

# dmesg
[    0.000000] Linux version 4.9.0-5-amd64 =
(debian-kernel@lists.debian.org) (gcc version 6.3.0 20170516 (Debian =
6.3.0-18) ) #1 SMP Debian 4.9.65-3+deb9u2 (2018-01-04)
[    0.000000] Command line: BOOT_IMAGE=3D/vmlinuz-4.9.0-5-amd64 =
root=3DUUID=3Dd135d38d-aa53-4c9d-a56b-f57ee591da0c ro quiet
[    0.000000] x86/fpu: Legacy x87 FPU detected.
[    0.000000] x86/fpu: Using 'eager' FPU context switches.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ebff] =
usable
[    0.000000] BIOS-e820: [mem 0x000000000009ec00-0x000000000009ffff] =
reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] =
reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cfe43fff] =
usable
[    0.000000] BIOS-e820: [mem 0x00000000cfe44000-0x00000000cfe4bfff] =
ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000cfe4c000-0x00000000cfe4cfff] =
usable
[    0.000000] BIOS-e820: [mem 0x00000000cfe4d000-0x00000000cfffffff] =
reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] =
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fecfffff] =
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee0ffff] =
reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffffffff] =
reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000000fefffefff] =
usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: HP ProLiant DL380 G5, BIOS P56 08/16/2015
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> =
reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfeffff max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00D0000000 mask 3FF0000000 uncachable
[    0.000000]   1 base 00E0000000 mask 3FE0000000 uncachable
[    0.000000]   2 base 1000000000 mask 3000000000 uncachable
[    0.000000]   3 base 2000000000 mask 2000000000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- =
WT
[    0.000000] e820: last_pfn =3D 0xcfe4d max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f4f80-0x000f4f8f] mapped =
at [ffff8a29400f4f80]
[    0.000000] Base memory trampoline at [ffff8a2940098000] 98000 size =
24576
[    0.000000] BRK [0xd27d37000, 0xd27d37fff] PGTABLE
[    0.000000] BRK [0xd27d38000, 0xd27d38fff] PGTABLE
[    0.000000] BRK [0xd27d39000, 0xd27d39fff] PGTABLE
[    0.000000] BRK [0xd27d3a000, 0xd27d3afff] PGTABLE
[    0.000000] BRK [0xd27d3b000, 0xd27d3bfff] PGTABLE
[    0.000000] BRK [0xd27d3c000, 0xd27d3cfff] PGTABLE
[    0.000000] BRK [0xd27d3d000, 0xd27d3dfff] PGTABLE
[    0.000000] BRK [0xd27d3e000, 0xd27d3efff] PGTABLE
[    0.000000] BRK [0xd27d3f000, 0xd27d3ffff] PGTABLE
[    0.000000] BRK [0xd27d40000, 0xd27d40fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x35985000-0x36cb9fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F4F00 000024 (v02 HP    )
[    0.000000] ACPI: XSDT 0x00000000CFE447C0 00007C (v01 HP     ProLiant =
00000002 \xffffffd2?   0000162E)
[    0.000000] ACPI: FACP 0x00000000CFE44840 0000F4 (v03 HP     ProLiant =
00000002 \xffffffd2?   0000162E)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for =
FADT/Pm1aControlBlock: 32, using default 16 (20160831/tbfadt-708)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for =
FADT/Pm2ControlBlock: 32, using default 8 (20160831/tbfadt-708)
[    0.000000] ACPI: DSDT 0x00000000CFE44940 0023E8 (v01 HP     DSDT     =
00000001 INTL 20030228)
[    0.000000] ACPI: FACS 0x00000000CFE44100 000040
[    0.000000] ACPI: FACS 0x00000000CFE44100 000040
[    0.000000] ACPI: SPCR 0x00000000CFE44140 000050 (v01 HP     SPCRRBSU =
00000001 \xffffffd2?   0000162E)
[    0.000000] ACPI: MCFG 0x00000000CFE441C0 00003C (v01 HP     ProLiant =
00000001      00000000)
[    0.000000] ACPI: HPET 0x00000000CFE44200 000038 (v01 HP     ProLiant =
00000002 \xffffffd2?   0000162E)
[    0.000000] ACPI: SPMI 0x00000000CFE44240 000040 (v05 HP     ProLiant =
00000001 \xffffffd2?   0000162E)
[    0.000000] ACPI: ERST 0x00000000CFE44280 0001D0 (v01 HP     ProLiant =
00000001 \xffffffd2?   0000162E)
[    0.000000] ACPI: APIC 0x00000000CFE44480 00009E (v01 HP     ProLiant =
00000002      00000000)
[    0.000000] ACPI: FFFF 0x00000000CFE44540 000176 (v01 HP     ProLiant =
00000001 \xffffffd2?   0000162E)
[    0.000000] ACPI: BERT 0x00000000CFE446C0 000030 (v01 HP     ProLiant =
00000001 \xffffffd2?   0000162E)
[    0.000000] ACPI: HEST 0x00000000CFE44700 0000BC (v01 HP     ProLiant =
00000001 \xffffffd2?   0000162E)
[    0.000000] ACPI: SSDT 0x00000000CFE49000 000C85 (v01 HP     SSDTP    =
00000001 INTL 20061109)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem =
0x0000000000000000-0x0000000fefffefff]
[    0.000000] NODE_DATA(0) allocated [mem 0xfefffa000-0xfefffefff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x0000000fefffefff]
[    0.000000]   Device   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009dfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000cfe43fff]
[    0.000000]   node   0: [mem 0x00000000cfe4c000-0x00000000cfe4cfff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x0000000fefffefff]
[    0.000000] Initmem setup node 0 [mem =
0x0000000000001000-0x0000000fefffefff]
[    0.000000] On node 0 totalpages: 16514529
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13242 pages used for memmap
[    0.000000]   DMA32 zone: 847429 pages, LIFO batch:31
[    0.000000]   Normal zone: 244736 pages used for memmap
[    0.000000]   Normal zone: 15663103 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x908
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high =
edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high =
level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcfe44000-0xcfe4bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xcfe4d000-0xcfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee10000-0xffbfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffc00000-0xffffffff]
[    0.000000] e820: [mem 0xd0000000-0xdfffffff] available for PCI =
devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff =
max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 =
nr_cpu_ids:8 nr_node_ids:1
[    0.000000] percpu: Embedded 35 pages/cpu @ffff8a392fa00000 s105304 =
r8192 d29864 u262144
[    0.000000] pcpu-alloc: s105304 r8192 d29864 u262144 =
alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  =
Total pages: 16256466
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=3D/vmlinuz-4.9.0-5-amd64 =
root=3DUUID=3Dd135d38d-aa53-4c9d-a56b-f57ee591da0c ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - =
bailing!
[    0.000000] Memory: 64923132K/66058116K available (6196K kernel code, =
1159K rwdata, 2848K rodata, 1408K init, 688K bss, 1134984K reserved, 0K =
cma-reserved)
[    0.000000] Kernel/User page tables isolation: enabled
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  Build-time adjustment of leaf fanout to 64.
[    0.000000]  RCU restricting CPUs from NR_CPUS=3D512 to =
nr_cpu_ids=3D8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D64, =
nr_cpu_ids=3D8
[    0.000000] NR_IRQS:33024 nr_irqs:488 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: =
0xffffffff, max_idle_ns: 133484882848 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3166.798 MHz processor
[    0.008018] Calibrating delay loop (skipped), value calculated using =
timer frequency.. 6333.59 BogoMIPS (lpj=3D12667192)
[    0.008021] pid_max: default: 32768 minimum: 301
[    0.008045] ACPI: Core revision 20160831
[    0.009882] ACPI: 2 ACPI AML tables successfully acquired and loaded
[    0.009949] Security Framework initialized
[    0.009951] Yama: disabled by default; enable with sysctl =
kernel.yama.*
[    0.009959] AppArmor: AppArmor disabled by boot time parameter
[    0.013501] Dentry cache hash table entries: 8388608 (order: 14, =
67108864 bytes)
[    0.041456] Inode-cache hash table entries: 4194304 (order: 13, =
33554432 bytes)
[    0.054952] Mount-cache hash table entries: 131072 (order: 8, 1048576 =
bytes)
[    0.055018] Mountpoint-cache hash table entries: 131072 (order: 8, =
1048576 bytes)
[    0.056170] CPU: Physical Processor ID: 0
[    0.056171] CPU: Processor Core ID: 0
[    0.056172] mce: CPU supports 6 MCE banks
[    0.056179] CPU0: Thermal monitoring enabled (TM2)
[    0.056184] process: using mwait in idle threads
[    0.056188] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
[    0.056189] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32, 1GB 0
[    0.056504] Freeing SMP alternatives memory: 24K
[    0.058693] ftrace: allocating 25212 entries in 99 pages
[    0.064094] smpboot: Max logical packages: 2
[    0.064466] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 =
pin2=3D-1
[    0.108000] smpboot: CPU0: Intel(R) Xeon(R) CPU           X5460  @ =
3.16GHz (family: 0x6, model: 0x17, stepping: 0x6)
[    0.108000] Performance Events: PEBS fmt0+, Core2 events, Broken BIOS =
detected, complain to your hardware vendor.
[    0.108000] [Firmware Bug]: the BIOS has corrupted hw-PMU resources =
(MSR 186 is 43003c)
[    0.108000] Intel PMU driver.
[    0.108000] ... version:                2
[    0.108000] ... bit width:              40
[    0.108000] ... generic registers:      2
[    0.108000] ... value mask:             000000ffffffffff
[    0.108000] ... max period:             000000007fffffff
[    0.108000] ... fixed-purpose events:   3
[    0.108000] ... event mask:             0000000700000003
[    0.108000] NMI watchdog: enabled on all CPUs, permanently consumes =
one hw-PMU counter.
[    0.108000] x86: Booting SMP configuration:
[    0.108000] .... node  #0, CPUs:      #1 #2 #3 #4 #5 #6 #7
[    0.204112] x86: Booted up 1 node, 8 CPUs
[    0.204112] smpboot: Total of 8 processors activated (50667.93 =
BogoMIPS)
[    0.213929] devtmpfs: initialized
[    0.213929] x86/mm: Memory block size: 128MB
[    0.224223] clocksource: jiffies: mask: 0xffffffff max_cycles: =
0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.224223] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.224227] pinctrl core: initialized pinctrl subsystem
[    0.224381] NET: Registered protocol family 16
[    0.240004] cpuidle: using governor ladder
[    0.256002] cpuidle: using governor menu
[    0.256026] ACPI: bus type PCI registered
[    0.256028] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.256098] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem =
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.256100] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in =
E820
[    0.256115] PCI: Using configuration type 1 for base access
[    0.256119] PCI: HP ProLiant DL380 detected, enabling pci=3Dbfsort.
[    0.272039] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.272092] ACPI: Added _OSI(Module Device)
[    0.272093] ACPI: Added _OSI(Processor Device)
[    0.272093] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.272094] ACPI: Added _OSI(Processor Aggregator Device)
[    0.272517] ACPI Error: Field [CDW3] at 96 exceeds Buffer [NULL] size =
64 (bits) (20160831/dsopcode-236)
[    0.272650] ACPI Error: Method parse/execution failed [\_SB._OSC] =
(Node ffff8a392f5b0758), AE_AML_BUFFER_LIMIT (20160831/psparse-543)
[    0.273028] ACPI: Dynamic OEM Table Load:
[    0.273034] ACPI: SSDT 0xFFFF8A38E9B20780 0000AD (v01 HP     CPU0CST  =
00000001 INTL 20061109)
[    0.273092] ACPI: Dynamic OEM Table Load:
[    0.273092] ACPI: SSDT 0xFFFF8A38E9AFDB40 0000AD (v01 HP     CPU1CST  =
00000001 INTL 20061109)
[    0.273092] ACPI: Dynamic OEM Table Load:
[    0.273092] ACPI: SSDT 0xFFFF8A38E9B20480 0000AD (v01 HP     CPU2CST  =
00000001 INTL 20061109)
[    0.273092] ACPI: Dynamic OEM Table Load:
[    0.273092] ACPI: SSDT 0xFFFF8A38E9AFDCC0 0000AD (v01 HP     CPU3CST  =
00000001 INTL 20061109)
[    0.273092] ACPI: Dynamic OEM Table Load:
[    0.273092] ACPI: SSDT 0xFFFF8A38E9B20180 0000AD (v01 HP     CPU4CST  =
00000001 INTL 20061109)
[    0.273092] ACPI: Dynamic OEM Table Load:
[    0.273092] ACPI: SSDT 0xFFFF8A38E9AFDF00 0000AD (v01 HP     CPU5CST  =
00000001 INTL 20061109)
[    0.273092] ACPI: Dynamic OEM Table Load:
[    0.273092] ACPI: SSDT 0xFFFF8A38E9B209C0 0000AD (v01 HP     CPU6CST  =
00000001 INTL 20061109)
[    0.273092] ACPI: Dynamic OEM Table Load:
[    0.273092] ACPI: SSDT 0xFFFF8A38E9AFDC00 0000AD (v01 HP     CPU7CST  =
00000001 INTL 20061109)
[    0.273092] ACPI: Interpreter enabled
[    0.273092] ACPI: (supports S0 S4 S5)
[    0.273092] ACPI: Using IOAPIC for interrupt routing
[    0.273092] HEST: Table parsing has been initialized.
[    0.273092] PCI: Using host bridge windows from ACPI; if necessary, =
use "pci=3Dnocrs" and report a bug
[    0.278099] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7f])
[    0.278104] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM =
ClockPM Segments MSI]
[    0.278108] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling =
ASPM
[    0.278247] PCI host bridge to bus 0000:00
[    0.278249] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 =
window]
[    0.278250] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff =
window]
[    0.278251] pci_bus 0000:00: root bus resource [mem =
0x000a0000-0x000bffff window]
[    0.278252] pci_bus 0000:00: root bus resource [mem =
0xd0000000-0xdfffffff window]
[    0.278254] pci_bus 0000:00: root bus resource [mem =
0xf0000000-0xfebfffff window]
[    0.278255] pci_bus 0000:00: root bus resource [bus 00-7f]
[    0.278265] pci 0000:00:00.0: [8086:25d8] type 00 class 0x060000
[    0.278307] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.278372] pci 0000:00:02.0: [8086:25e2] type 01 class 0x060400
[    0.278405] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.278468] pci 0000:00:03.0: [8086:25e3] type 01 class 0x060400
[    0.278500] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.278563] pci 0000:00:04.0: [8086:25f8] type 01 class 0x060400
[    0.278595] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.278659] pci 0000:00:05.0: [8086:25e5] type 01 class 0x060400
[    0.278691] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.278749] pci 0000:00:06.0: [8086:25f9] type 01 class 0x060400
[    0.278781] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.278843] pci 0000:00:07.0: [8086:25e7] type 01 class 0x060400
[    0.278876] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.278938] pci 0000:00:10.0: [8086:25f0] type 00 class 0x060000
[    0.279000] pci 0000:00:10.1: [8086:25f0] type 00 class 0x060000
[    0.279446] pci 0000:00:10.2: [8086:25f0] type 00 class 0x060000
[    0.279512] pci 0000:00:11.0: [8086:25f1] type 00 class 0x060000
[    0.279582] pci 0000:00:13.0: [8086:25f3] type 00 class 0x060000
[    0.279645] pci 0000:00:15.0: [8086:25f5] type 00 class 0x060000
[    0.279708] pci 0000:00:16.0: [8086:25f6] type 00 class 0x060000
[    0.279779] pci 0000:00:1c.0: [8086:2690] type 01 class 0x060400
[    0.279840] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.279908] pci 0000:00:1c.1: [8086:2692] type 01 class 0x060400
[    0.279967] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.280041] pci 0000:00:1d.0: [8086:2688] type 00 class 0x0c0300
[    0.280092] pci 0000:00:1d.0: reg 0x20: [io  0x1000-0x101f]
[    0.280171] pci 0000:00:1d.1: [8086:2689] type 00 class 0x0c0300
[    0.280221] pci 0000:00:1d.1: reg 0x20: [io  0x1020-0x103f]
[    0.280301] pci 0000:00:1d.2: [8086:268a] type 00 class 0x0c0300
[    0.280352] pci 0000:00:1d.2: reg 0x20: [io  0x1040-0x105f]
[    0.280430] pci 0000:00:1d.3: [8086:268b] type 00 class 0x0c0300
[    0.280482] pci 0000:00:1d.3: reg 0x20: [io  0x1060-0x107f]
[    0.280566] pci 0000:00:1d.7: [8086:268c] type 00 class 0x0c0320
[    0.280580] pci 0000:00:1d.7: reg 0x10: [mem 0xdddf0000-0xdddf03ff]
[    0.280649] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.280709] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.280801] pci 0000:00:1f.0: [8086:2670] type 00 class 0x060100
[    0.280921] pci 0000:00:1f.1: [8086:269e] type 00 class 0x01018a
[    0.280932] pci 0000:00:1f.1: reg 0x10: [io  0x01f0-0x01f7]
[    0.280939] pci 0000:00:1f.1: reg 0x14: [io  0x03f4-0x03f7]
[    0.280946] pci 0000:00:1f.1: reg 0x18: [io  0x0170-0x0177]
[    0.280953] pci 0000:00:1f.1: reg 0x1c: [io  0x0374-0x0377]
[    0.280961] pci 0000:00:1f.1: reg 0x20: [io  0x0500-0x050f]
[    0.280977] pci 0000:00:1f.1: legacy IDE quirk: reg 0x10: [io  =
0x01f0-0x01f7]
[    0.280978] pci 0000:00:1f.1: legacy IDE quirk: reg 0x14: [io  =
0x03f6]
[    0.280979] pci 0000:00:1f.1: legacy IDE quirk: reg 0x18: [io  =
0x0170-0x0177]
[    0.280980] pci 0000:00:1f.1: legacy IDE quirk: reg 0x1c: [io  =
0x0376]
[    0.281299] pci 0000:09:00.0: [8086:3500] type 01 class 0x060400
[    0.282856] pci 0000:09:00.0: PME# supported from D0 D3hot D3cold
[    0.283497] pci 0000:09:00.3: [8086:350c] type 01 class 0x060400
[    0.285145] pci 0000:09:00.3: PME# supported from D0 D3hot D3cold
[    0.285649] pci 0000:09:00.0: disabling ASPM on pre-1.1 PCIe device.  =
You can enable it with 'pcie_aspm=3Dforce'
[    0.285833] pci 0000:00:02.0: PCI bridge to [bus 09-12]
[    0.285835] pci 0000:00:02.0:   bridge window [io  0x5000-0x5fff]
[    0.285837] pci 0000:00:02.0:   bridge window [mem =
0xf3e00000-0xf7ffffff]
[    0.286702] pci 0000:0a:00.0: [8086:3510] type 01 class 0x060400
[    0.288413] pci 0000:0a:00.0: PME# supported from D0 D3hot D3cold
[    0.288824] pci 0000:0a:00.0: disabling ASPM on pre-1.1 PCIe device.  =
You can enable it with 'pcie_aspm=3Dforce'
[    0.289053] pci 0000:0a:01.0: [8086:3514] type 01 class 0x060400
[    0.290794] pci 0000:0a:01.0: PME# supported from D0 D3hot D3cold
[    0.291205] pci 0000:0a:00.0: disabling ASPM on pre-1.1 PCIe device.  =
You can enable it with 'pcie_aspm=3Dforce'
[    0.291435] pci 0000:0a:02.0: [8086:3518] type 01 class 0x060400
[    0.293192] pci 0000:0a:02.0: PME# supported from D0 D3hot D3cold
[    0.293603] pci 0000:0a:00.0: disabling ASPM on pre-1.1 PCIe device.  =
You can enable it with 'pcie_aspm=3Dforce'
[    0.294290] pci 0000:09:00.0: PCI bridge to [bus 0a-11]
[    0.294336] pci 0000:09:00.0:   bridge window [io  0x5000-0x5fff]
[    0.294382] pci 0000:09:00.0:   bridge window [mem =
0xf3f00000-0xf7ffffff]
[    0.295848] pci 0000:0b:00.0: [1077:2432] type 00 class 0x0c0400
[    0.296412] pci 0000:0b:00.0: reg 0x10: [io  0x5000-0x50ff]
[    0.296916] pci 0000:0b:00.0: reg 0x14: [mem 0xf3ff0000-0xf3ff3fff =
64bit]
[    0.298198] pci 0000:0b:00.0: reg 0x30: [mem 0x00000000-0x0003ffff =
pref]
[    0.301557] pci 0000:0b:00.1: [1077:2432] type 00 class 0x0c0400
[    0.302107] pci 0000:0b:00.1: reg 0x10: [io  0x5400-0x54ff]
[    0.302610] pci 0000:0b:00.1: reg 0x14: [mem 0xf3fe0000-0xf3fe3fff =
64bit]
[    0.303893] pci 0000:0b:00.1: reg 0x30: [mem 0x00000000-0x0003ffff =
pref]
[    0.307205] pci 0000:0b:00.0: disabling ASPM on pre-1.1 PCIe device.  =
You can enable it with 'pcie_aspm=3Dforce'
[    0.307481] pci 0000:0a:00.0: PCI bridge to [bus 0b-0d]
[    0.307526] pci 0000:0a:00.0:   bridge window [io  0x5000-0x5fff]
[    0.307572] pci 0000:0a:00.0:   bridge window [mem =
0xf3f00000-0xf3ffffff]
[    0.309099] pci 0000:0e:00.0: [8086:0340] type 01 class 0x060400
[    0.312183] pci 0000:0e:00.0: PME# supported from D0 D3hot D3cold
[    0.313282] pci 0000:0e:00.2: [8086:0341] type 01 class 0x060400
[    0.316412] pci 0000:0e:00.2: PME# supported from D0 D3hot D3cold
[    0.317328] pci 0000:0e:00.0: disabling ASPM on pre-1.1 PCIe device.  =
You can enable it with 'pcie_aspm=3Dforce'
[    0.317603] pci 0000:0a:01.0: PCI bridge to [bus 0e-10]
[    0.317695] pci 0000:0a:01.0:   bridge window [mem =
0xf4000000-0xf7ffffff]
[    0.319389] pci 0000:0f:04.0: [14e4:164a] type 00 class 0x020000
[    0.320183] pci 0000:0f:04.0: reg 0x10: [mem 0xf4000000-0xf5ffffff =
64bit]
[    0.321786] pci 0000:0f:04.0: reg 0x30: [mem 0x00000000-0x0000ffff =
pref]
[    0.323434] pci 0000:0f:04.0: PME# supported from D3hot
[    0.325328] pci 0000:0e:00.0: PCI bridge to [bus 0f]
[    0.325511] pci 0000:0e:00.0:   bridge window [mem =
0xf4000000-0xf5ffffff]
[    0.327389] pci 0000:10:05.0: [14e4:164a] type 00 class 0x020000
[    0.328183] pci 0000:10:05.0: reg 0x10: [mem 0xf6000000-0xf7ffffff =
64bit]
[    0.329786] pci 0000:10:05.0: reg 0x30: [mem 0x00000000-0x0000ffff =
pref]
[    0.331434] pci 0000:10:05.0: PME# supported from D3hot
[    0.332961] pci 0000:0e:00.2: PCI bridge to [bus 10]
[    0.333144] pci 0000:0e:00.2:   bridge window [mem =
0xf6000000-0xf7ffffff]
[    0.334385] pci 0000:0a:02.0: PCI bridge to [bus 11]
[    0.336916] pci 0000:09:00.3: PCI bridge to [bus 12]
[    0.337426] pci 0000:06:00.0: [103c:3230] type 00 class 0x010400
[    0.337441] pci 0000:06:00.0: reg 0x10: [mem 0xf3d00000-0xf3dfffff =
64bit]
[    0.337448] pci 0000:06:00.0: reg 0x18: [io  0x4000-0x40ff]
[    0.337460] pci 0000:06:00.0: reg 0x1c: [mem 0xf3cf0000-0xf3cf0fff =
64bit]
[    0.337473] pci 0000:06:00.0: reg 0x30: [mem 0x00000000-0x0003ffff =
pref]
[    0.337512] pci 0000:06:00.0: supports D1
[    0.337565] pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  =
You can enable it with 'pcie_aspm=3Dforce'
[    0.337571] pci 0000:00:03.0: PCI bridge to [bus 06-08]
[    0.337573] pci 0000:00:03.0:   bridge window [io  0x4000-0x4fff]
[    0.337575] pci 0000:00:03.0:   bridge window [mem =
0xf3c00000-0xf3dfffff]
[    0.337678] pci 0000:13:00.0: [103c:323a] type 00 class 0x010400
[    0.337694] pci 0000:13:00.0: reg 0x10: [mem 0xf9e00000-0xf9ffffff =
64bit]
[    0.337706] pci 0000:13:00.0: reg 0x18: [mem 0xf9df0000-0xf9df0fff =
64bit]
[    0.337714] pci 0000:13:00.0: reg 0x20: [io  0x6000-0x60ff]
[    0.337728] pci 0000:13:00.0: reg 0x30: [mem 0x00000000-0x0007ffff =
pref]
[    0.337772] pci 0000:13:00.0: PME# supported from D0
[    0.348010] pci 0000:00:04.0: PCI bridge to [bus 13-15]
[    0.348012] pci 0000:00:04.0:   bridge window [io  0x6000-0x6fff]
[    0.348014] pci 0000:00:04.0:   bridge window [mem =
0xf9d00000-0xf9ffffff]
[    0.348047] pci 0000:00:05.0: PCI bridge to [bus 16]
[    0.348145] pci 0000:17:00.0: [8086:0340] type 01 class 0x060400
[    0.348198] pci 0000:17:00.0: PME# supported from D0 D3hot D3cold
[    0.348268] pci 0000:17:00.2: [8086:0341] type 01 class 0x060400
[    0.348321] pci 0000:17:00.2: PME# supported from D0 D3hot D3cold
[    0.348385] pci 0000:17:00.0: disabling ASPM on pre-1.1 PCIe device.  =
You can enable it with 'pcie_aspm=3Dforce'
[    0.348391] pci 0000:00:06.0: PCI bridge to [bus 17-19]
[    0.348394] pci 0000:00:06.0:   bridge window [mem =
0xfa000000-0xfdffffff]
[    0.348444] pci 0000:18:04.0: [14e4:164a] type 00 class 0x020000
[    0.348462] pci 0000:18:04.0: reg 0x10: [mem 0xfa000000-0xfbffffff =
64bit]
[    0.348495] pci 0000:18:04.0: reg 0x30: [mem 0x00000000-0x0000ffff =
pref]
[    0.348533] pci 0000:18:04.0: PME# supported from D3hot
[    0.348600] pci 0000:17:00.0: PCI bridge to [bus 18]
[    0.348604] pci 0000:17:00.0:   bridge window [mem =
0xfa000000-0xfbffffff]
[    0.348656] pci 0000:19:05.0: [14e4:164a] type 00 class 0x020000
[    0.348673] pci 0000:19:05.0: reg 0x10: [mem 0xfc000000-0xfdffffff =
64bit]
[    0.348706] pci 0000:19:05.0: reg 0x30: [mem 0x00000000-0x0000ffff =
pref]
[    0.348744] pci 0000:19:05.0: PME# supported from D3hot
[    0.348811] pci 0000:17:00.2: PCI bridge to [bus 19]
[    0.348815] pci 0000:17:00.2:   bridge window [mem =
0xfc000000-0xfdffffff]
[    0.348853] pci 0000:00:07.0: PCI bridge to [bus 1a]
[    0.348907] pci 0000:02:00.0: [1166:0103] type 01 class 0x060400
[    0.348997] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.349057] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  =
You can enable it with 'pcie_aspm=3Dforce'
[    0.349064] pci 0000:00:1c.0: PCI bridge to [bus 02-03]
[    0.349068] pci 0000:00:1c.0:   bridge window [mem =
0xde000000-0xdfffffff]
[    0.349126] pci 0000:03:00.0: [14e4:164c] type 00 class 0x020000
[    0.349151] pci 0000:03:00.0: reg 0x10: [mem 0xde000000-0xdfffffff =
64bit]
[    0.349200] pci 0000:03:00.0: reg 0x30: [mem 0x00000000-0x0001ffff =
pref]
[    0.349253] pci 0000:03:00.0: PME# supported from D3hot D3cold
[    0.349344] pci 0000:02:00.0: PCI bridge to [bus 03]
[    0.349353] pci 0000:02:00.0:   bridge window [mem =
0xde000000-0xdfffffff]
[    0.349413] pci 0000:04:00.0: [1166:0103] type 01 class 0x060400
[    0.349503] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    0.349564] pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  =
You can enable it with 'pcie_aspm=3Dforce'
[    0.349571] pci 0000:00:1c.1: PCI bridge to [bus 04-05]
[    0.349576] pci 0000:00:1c.1:   bridge window [mem =
0xf0000000-0xf1ffffff]
[    0.349633] pci 0000:05:00.0: [14e4:164c] type 00 class 0x020000
[    0.349658] pci 0000:05:00.0: reg 0x10: [mem 0xf0000000-0xf1ffffff =
64bit]
[    0.349706] pci 0000:05:00.0: reg 0x30: [mem 0x00000000-0x0001ffff =
pref]
[    0.349760] pci 0000:05:00.0: PME# supported from D3hot D3cold
[    0.349849] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.349857] pci 0000:04:00.0:   bridge window [mem =
0xf0000000-0xf1ffffff]
[    0.349919] pci 0000:01:03.0: [1002:515e] type 00 class 0x030000
[    0.349935] pci 0000:01:03.0: reg 0x10: [mem 0xd0000000-0xd7ffffff =
pref]
[    0.349944] pci 0000:01:03.0: reg 0x14: [io  0x3000-0x30ff]
[    0.349954] pci 0000:01:03.0: reg 0x18: [mem 0xddff0000-0xddffffff]
[    0.349988] pci 0000:01:03.0: reg 0x30: [mem 0x00000000-0x0001ffff =
pref]
[    0.350017] pci 0000:01:03.0: supports D1 D2
[    0.350062] pci 0000:01:04.0: [0e11:b203] type 00 class 0x088000
[    0.350077] pci 0000:01:04.0: reg 0x10: [io  0x2800-0x28ff]
[    0.350086] pci 0000:01:04.0: reg 0x14: [mem 0xddfe0000-0xddfe01ff]
[    0.350156] pci 0000:01:04.0: PME# supported from D0 D3hot D3cold
[    0.350214] pci 0000:01:04.2: [0e11:b204] type 00 class 0x088000
[    0.350231] pci 0000:01:04.2: reg 0x10: [io  0x3400-0x34ff]
[    0.350242] pci 0000:01:04.2: reg 0x14: [mem 0xddfd0000-0xddfd07ff]
[    0.350252] pci 0000:01:04.2: reg 0x18: [mem 0xddfc0000-0xddfc3fff]
[    0.350262] pci 0000:01:04.2: reg 0x1c: [mem 0xddf00000-0xddf7ffff]
[    0.350292] pci 0000:01:04.2: reg 0x30: [mem 0x00000000-0x0000ffff =
pref]
[    0.350323] pci 0000:01:04.2: PME# supported from D0 D3hot D3cold
[    0.350378] pci 0000:01:04.4: [103c:3300] type 00 class 0x0c0300
[    0.350432] pci 0000:01:04.4: reg 0x20: [io  0x3800-0x381f]
[    0.350483] pci 0000:01:04.4: PME# supported from D0 D3hot D3cold
[    0.350535] pci 0000:01:04.6: [103c:3302] type 00 class 0x0c0701
[    0.350551] pci 0000:01:04.6: reg 0x10: [mem 0xddef0000-0xddef00ff]
[    0.350629] pci 0000:01:04.6: PME# supported from D0 D3hot D3cold
[    0.350707] pci 0000:00:1e.0: PCI bridge to [bus 01] (subtractive =
decode)
[    0.350709] pci 0000:00:1e.0:   bridge window [io  0x2000-0x3fff]
[    0.350712] pci 0000:00:1e.0:   bridge window [mem =
0xdde00000-0xddffffff]
[    0.350716] pci 0000:00:1e.0:   bridge window [mem =
0xd0000000-0xd7ffffff 64bit pref]
[    0.350718] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7 =
window] (subtractive decode)
[    0.350719] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff =
window] (subtractive decode)
[    0.350720] pci 0000:00:1e.0:   bridge window [mem =
0x000a0000-0x000bffff window] (subtractive decode)
[    0.350721] pci 0000:00:1e.0:   bridge window [mem =
0xd0000000-0xdfffffff window] (subtractive decode)
[    0.350723] pci 0000:00:1e.0:   bridge window [mem =
0xf0000000-0xfebfffff window] (subtractive decode)
[    0.351043] ACPI: PCI Interrupt Link [LNKA] (IRQs *5 7 10 11)
[    0.351084] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *7 10 11)
[    0.351124] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 7 *10 11)
[    0.351164] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 *10 11)
[    0.351204] ACPI: PCI Interrupt Link [LNKE] (IRQs 5 7 10 11) *0, =
disabled.
[    0.351244] ACPI: PCI Interrupt Link [LNKF] (IRQs *5 7 10 11)
[    0.351284] ACPI: PCI Interrupt Link [LNKG] (IRQs 5 7 *10 11)
[    0.351323] ACPI: PCI Interrupt Link [LNKH] (IRQs 5 *7 10 11)
[    0.352018] vgaarb: setting as boot device: PCI:0000:01:03.0
[    0.352018] vgaarb: device added: =
PCI:0000:01:03.0,decodes=3Dio+mem,owns=3Dio+mem,locks=3Dnone
[    0.352018] vgaarb: loaded
[    0.352018] vgaarb: bridge control possible 0000:01:03.0
[    0.352072] PCI: Using ACPI for IRQ routing
[    0.359424] PCI: pci_cache_line_size set to 64 bytes
[    0.360309] e820: reserve RAM buffer [mem 0x0009ec00-0x0009ffff]
[    0.360310] e820: reserve RAM buffer [mem 0xcfe44000-0xcfffffff]
[    0.360311] e820: reserve RAM buffer [mem 0xcfe4d000-0xcfffffff]
[    0.360311] e820: reserve RAM buffer [mem 0xfeffff000-0xfefffffff]
[    0.360451] HPET: 3 timers in total, 0 timers will be used for =
per-cpu timer
[    0.360451] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.360451] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.364018] clocksource: Switched to clocksource hpet
[    0.373098] VFS: Disk quotas dquot_6.6.0
[    0.373142] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 =
bytes)
[    0.373261] pnp: PnP ACPI init
[    0.373562] system 00:00: [io  0x0408-0x040f] has been reserved
[    0.373564] system 00:00: [io  0x04d0-0x04d1] has been reserved
[    0.373566] system 00:00: [io  0x0700-0x071f] has been reserved
[    0.373567] system 00:00: [io  0x0800-0x083f] has been reserved
[    0.373569] system 00:00: [io  0x0900-0x097f] has been reserved
[    0.373572] system 00:00: [io  0x0c80-0x0c83] has been reserved
[    0.373573] system 00:00: [io  0x0cd4-0x0cd7] has been reserved
[    0.373575] system 00:00: [io  0x0f50-0x0f58] has been reserved
[    0.373576] system 00:00: [io  0x0ca0-0x0ca1] has been reserved
[    0.373578] system 00:00: [io  0x0ca4-0x0ca5] has been reserved
[    0.373579] system 00:00: [io  0x02f8-0x02ff] has been reserved
[    0.373581] system 00:00: [mem 0xe0000000-0xefffffff] has been =
reserved
[    0.373583] system 00:00: [mem 0xfe000000-0xfebfffff] has been =
reserved
[    0.373587] system 00:00: Plug and Play ACPI device, IDs PNP0c02 =
(active)
[    0.373633] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 =
(active)
[    0.373660] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 PNP0f0e =
(active)
[    0.373838] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 PNP0500 =
(active)
[    0.373973] pnp: PnP ACPI: found 4 devices
[    0.380566] clocksource: acpi_pm: mask: 0xffffff max_cycles: =
0xffffff, max_idle_ns: 2085701024 ns
[    0.382067] pci 0000:0b:00.0: BAR 6: assigned [mem =
0xf3f00000-0xf3f3ffff pref]
[    0.382069] pci 0000:0b:00.1: BAR 6: assigned [mem =
0xf3f40000-0xf3f7ffff pref]
[    0.382071] pci 0000:0a:00.0: PCI bridge to [bus 0b-0d]
[    0.382089] pci 0000:0a:00.0:   bridge window [io  0x5000-0x5fff]
[    0.382181] pci 0000:0a:00.0:   bridge window [mem =
0xf3f00000-0xf3ffffff]
[    0.382320] pci 0000:0f:04.0: BAR 6: no space for [mem size =
0x00010000 pref]
[    0.382321] pci 0000:0f:04.0: BAR 6: failed to assign [mem size =
0x00010000 pref]
[    0.382322] pci 0000:0e:00.0: PCI bridge to [bus 0f]
[    0.382455] pci 0000:0e:00.0:   bridge window [mem =
0xf4000000-0xf5ffffff]
[    0.382731] pci 0000:10:05.0: BAR 6: no space for [mem size =
0x00010000 pref]
[    0.382732] pci 0000:10:05.0: BAR 6: failed to assign [mem size =
0x00010000 pref]
[    0.382733] pci 0000:0e:00.2: PCI bridge to [bus 10]
[    0.382867] pci 0000:0e:00.2:   bridge window [mem =
0xf6000000-0xf7ffffff]
[    0.383142] pci 0000:0a:01.0: PCI bridge to [bus 0e-10]
[    0.383234] pci 0000:0a:01.0:   bridge window [mem =
0xf4000000-0xf7ffffff]
[    0.383372] pci 0000:0a:02.0: PCI bridge to [bus 11]
[    0.383600] pci 0000:09:00.0: PCI bridge to [bus 0a-11]
[    0.383646] pci 0000:09:00.0:   bridge window [io  0x5000-0x5fff]
[    0.383737] pci 0000:09:00.0:   bridge window [mem =
0xf3f00000-0xf7ffffff]
[    0.383876] pci 0000:09:00.3: PCI bridge to [bus 12]
[    0.384105] pci 0000:00:02.0: PCI bridge to [bus 09-12]
[    0.384106] pci 0000:00:02.0:   bridge window [io  0x5000-0x5fff]
[    0.384109] pci 0000:00:02.0:   bridge window [mem =
0xf3e00000-0xf7ffffff]
[    0.384114] pci 0000:06:00.0: BAR 6: assigned [mem =
0xf3c00000-0xf3c3ffff pref]
[    0.384116] pci 0000:00:03.0: PCI bridge to [bus 06-08]
[    0.384117] pci 0000:00:03.0:   bridge window [io  0x4000-0x4fff]
[    0.384120] pci 0000:00:03.0:   bridge window [mem =
0xf3c00000-0xf3dfffff]
[    0.384124] pci 0000:13:00.0: BAR 6: assigned [mem =
0xf9d00000-0xf9d7ffff pref]
[    0.384125] pci 0000:00:04.0: PCI bridge to [bus 13-15]
[    0.384127] pci 0000:00:04.0:   bridge window [io  0x6000-0x6fff]
[    0.384129] pci 0000:00:04.0:   bridge window [mem =
0xf9d00000-0xf9ffffff]
[    0.384133] pci 0000:00:05.0: PCI bridge to [bus 16]
[    0.384140] pci 0000:18:04.0: BAR 6: no space for [mem size =
0x00010000 pref]
[    0.384141] pci 0000:18:04.0: BAR 6: failed to assign [mem size =
0x00010000 pref]
[    0.384142] pci 0000:17:00.0: PCI bridge to [bus 18]
[    0.384145] pci 0000:17:00.0:   bridge window [mem =
0xfa000000-0xfbffffff]
[    0.384151] pci 0000:19:05.0: BAR 6: no space for [mem size =
0x00010000 pref]
[    0.384152] pci 0000:19:05.0: BAR 6: failed to assign [mem size =
0x00010000 pref]
[    0.384154] pci 0000:17:00.2: PCI bridge to [bus 19]
[    0.384157] pci 0000:17:00.2:   bridge window [mem =
0xfc000000-0xfdffffff]
[    0.384162] pci 0000:00:06.0: PCI bridge to [bus 17-19]
[    0.384165] pci 0000:00:06.0:   bridge window [mem =
0xfa000000-0xfdffffff]
[    0.384169] pci 0000:00:07.0: PCI bridge to [bus 1a]
[    0.384175] pci 0000:03:00.0: BAR 6: no space for [mem size =
0x00020000 pref]
[    0.384176] pci 0000:03:00.0: BAR 6: failed to assign [mem size =
0x00020000 pref]
[    0.384178] pci 0000:02:00.0: PCI bridge to [bus 03]
[    0.384183] pci 0000:02:00.0:   bridge window [mem =
0xde000000-0xdfffffff]
[    0.384191] pci 0000:00:1c.0: PCI bridge to [bus 02-03]
[    0.384195] pci 0000:00:1c.0:   bridge window [mem =
0xde000000-0xdfffffff]
[    0.384201] pci 0000:05:00.0: BAR 6: no space for [mem size =
0x00020000 pref]
[    0.384202] pci 0000:05:00.0: BAR 6: failed to assign [mem size =
0x00020000 pref]
[    0.384204] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.384208] pci 0000:04:00.0:   bridge window [mem =
0xf0000000-0xf1ffffff]
[    0.384217] pci 0000:00:1c.1: PCI bridge to [bus 04-05]
[    0.384221] pci 0000:00:1c.1:   bridge window [mem =
0xf0000000-0xf1ffffff]
[    0.384228] pci 0000:01:03.0: BAR 6: assigned [mem =
0xdde00000-0xdde1ffff pref]
[    0.384230] pci 0000:01:04.2: BAR 6: assigned [mem =
0xdde20000-0xdde2ffff pref]
[    0.384231] pci 0000:00:1e.0: PCI bridge to [bus 01]
[    0.384233] pci 0000:00:1e.0:   bridge window [io  0x2000-0x3fff]
[    0.384236] pci 0000:00:1e.0:   bridge window [mem =
0xdde00000-0xddffffff]
[    0.384239] pci 0000:00:1e.0:   bridge window [mem =
0xd0000000-0xd7ffffff 64bit pref]
[    0.384244] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.384245] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.384247] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff =
window]
[    0.384248] pci_bus 0000:00: resource 7 [mem 0xd0000000-0xdfffffff =
window]
[    0.384249] pci_bus 0000:00: resource 8 [mem 0xf0000000-0xfebfffff =
window]
[    0.384250] pci_bus 0000:09: resource 0 [io  0x5000-0x5fff]
[    0.384252] pci_bus 0000:09: resource 1 [mem 0xf3e00000-0xf7ffffff]
[    0.384253] pci_bus 0000:0a: resource 0 [io  0x5000-0x5fff]
[    0.384254] pci_bus 0000:0a: resource 1 [mem 0xf3f00000-0xf7ffffff]
[    0.384255] pci_bus 0000:0b: resource 0 [io  0x5000-0x5fff]
[    0.384256] pci_bus 0000:0b: resource 1 [mem 0xf3f00000-0xf3ffffff]
[    0.384257] pci_bus 0000:0e: resource 1 [mem 0xf4000000-0xf7ffffff]
[    0.384259] pci_bus 0000:0f: resource 1 [mem 0xf4000000-0xf5ffffff]
[    0.384260] pci_bus 0000:10: resource 1 [mem 0xf6000000-0xf7ffffff]
[    0.384262] pci_bus 0000:06: resource 0 [io  0x4000-0x4fff]
[    0.384263] pci_bus 0000:06: resource 1 [mem 0xf3c00000-0xf3dfffff]
[    0.384264] pci_bus 0000:13: resource 0 [io  0x6000-0x6fff]
[    0.384265] pci_bus 0000:13: resource 1 [mem 0xf9d00000-0xf9ffffff]
[    0.384266] pci_bus 0000:17: resource 1 [mem 0xfa000000-0xfdffffff]
[    0.384268] pci_bus 0000:18: resource 1 [mem 0xfa000000-0xfbffffff]
[    0.384269] pci_bus 0000:19: resource 1 [mem 0xfc000000-0xfdffffff]
[    0.384270] pci_bus 0000:02: resource 1 [mem 0xde000000-0xdfffffff]
[    0.384272] pci_bus 0000:03: resource 1 [mem 0xde000000-0xdfffffff]
[    0.384273] pci_bus 0000:04: resource 1 [mem 0xf0000000-0xf1ffffff]
[    0.384274] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
[    0.384276] pci_bus 0000:01: resource 0 [io  0x2000-0x3fff]
[    0.384277] pci_bus 0000:01: resource 1 [mem 0xdde00000-0xddffffff]
[    0.384278] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xd7ffffff =
64bit pref]
[    0.384279] pci_bus 0000:01: resource 4 [io  0x0000-0x0cf7 window]
[    0.384280] pci_bus 0000:01: resource 5 [io  0x0d00-0xffff window]
[    0.384281] pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff =
window]
[    0.384282] pci_bus 0000:01: resource 7 [mem 0xd0000000-0xdfffffff =
window]
[    0.384283] pci_bus 0000:01: resource 8 [mem 0xf0000000-0xfebfffff =
window]
[    0.384381] NET: Registered protocol family 2
[    0.384788] TCP established hash table entries: 524288 (order: 10, =
4194304 bytes)
[    0.386374] TCP bind hash table entries: 65536 (order: 8, 1048576 =
bytes)
[    0.386764] TCP: Hash tables configured (established 524288 bind =
65536)
[    0.386869] UDP hash table entries: 32768 (order: 8, 1048576 bytes)
[    0.387301] UDP-Lite hash table entries: 32768 (order: 8, 1048576 =
bytes)
[    0.387809] NET: Registered protocol family 1
[    0.408085] pci 0000:00:1f.0: rerouting interrupts for [8086:2670]
[    0.408097] pci 0000:01:03.0: Video device with shadowed ROM at [mem =
0x000c0000-0x000dffff]
[    0.409817] PCI: CLS 64 bytes, default 64
[    0.409887] Unpacking initramfs...
[    0.705572] Freeing initrd memory: 19668K
[    0.705697] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.705701] software IO TLB [mem 0xcbe44000-0xcfe44000] (64MB) mapped =
at [ffff8a2a0be44000-ffff8a2a0fe43fff]
[    0.705809] platform rtc_cmos: registered platform RTC device (no PNP =
device found)
[    0.706289] audit: initializing netlink subsys (disabled)
[    0.706321] audit: type=3D2000 audit(1518887201.704:1): initialized
[    0.706739] workingset: timestamp_bits=3D40 max_order=3D24 =
bucket_order=3D0
[    0.706863] zbud: loaded
[    0.707836] Block layer SCSI generic (bsg) driver version 0.4 loaded =
(major 250)
[    0.707894] io scheduler noop registered
[    0.707895] io scheduler deadline registered
[    0.707912] io scheduler cfq registered (default)
[    0.711848] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.711853] pciehp: PCI Express Hot Plug Controller Driver version: =
0.4
[    0.711872] intel_idle: does not run on family 6 model 23
[    0.712339] ERST: Failed to get Error Log Address Range.
[    0.712447] GHES: APEI firmware first mode is enabled by WHEA _OSC.
[    0.712516] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.733329] 00:03: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D =
115200) is a 16550A
[    0.753573] serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3, base_baud =3D =
115200) is a 16550A
[    0.753927] Linux agpgart interface v0.103
[    0.754023] AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>
[    0.754023] AMD IOMMUv2 functionality not available on this system
[    0.754605] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at =
0x60,0x64 irq 1,12
[    0.756406] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.756410] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.756544] mousedev: PS/2 mouse device common for all mice
[    0.756594] rtc_cmos rtc_cmos: RTC can wake from S4
[    0.756718] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    0.756739] rtc_cmos rtc_cmos: alarms up to one year, y3k, 114 bytes =
nvram, hpet irqs
[    0.756855] ledtrig-cpu: registered to indicate activity on CPUs
[    0.757358] NET: Registered protocol family 10
[    0.757597] mip6: Mobile IPv6
[    0.757599] NET: Registered protocol family 17
[    0.757601] mpls_gso: MPLS GSO support
[    0.757889] microcode: sig=3D0x10676, pf=3D0x40, revision=3D0x612
[    0.757966] microcode: Microcode Update Driver: v2.01 =
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.758115] registered taskstats version 1
[    0.758136] zswap: loaded using pool lzo/zbud
[    0.758265] ima: No TPM chip found, activating TPM-bypass!
[    0.761767] rtc_cmos rtc_cmos: setting system clock to 2018-02-17 =
17:06:42 UTC (1518887202)
[    0.761807] PM: Hibernation image not present or could not be loaded.
[    0.763199] Freeing unused kernel memory: 1408K
[    0.763200] Write protecting the kernel read-only data: 12288k
[    0.764086] Freeing unused kernel memory: 1980K
[    0.767158] Freeing unused kernel memory: 1248K
[    0.772037] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    0.788753] random: systemd-udevd: uninitialized urandom read (16 =
bytes read)
[    0.788861] random: systemd-udevd: uninitialized urandom read (16 =
bytes read)
[    0.788874] random: systemd-udevd: uninitialized urandom read (16 =
bytes read)
[    0.789909] random: udevadm: uninitialized urandom read (16 bytes =
read)
[    0.789952] random: udevadm: uninitialized urandom read (16 bytes =
read)
[    0.791138] random: udevadm: uninitialized urandom read (16 bytes =
read)
[    0.791154] random: udevadm: uninitialized urandom read (16 bytes =
read)
[    0.791218] random: udevadm: uninitialized urandom read (16 bytes =
read)
[    0.791621] random: udevadm: uninitialized urandom read (16 bytes =
read)
[    0.791696] random: udevadm: uninitialized urandom read (16 bytes =
read)
[    0.852732] Floppy drive(s): fd0 is 1.44M
[    0.852968] thermal LNXTHERM:00: registered as thermal_zone0
[    0.852970] ACPI: Thermal Zone [THM0] (8 C)
[    0.854543] bnx2: QLogic bnx2 Gigabit Ethernet Driver v2.2.6 (January =
29, 2014)
[    0.855323] SCSI subsystem initialized
[    0.856031] HP CISS Driver (v 3.6.26)
[    0.856159] cciss 0000:06:00.0: can't disable ASPM; OS doesn't have =
ASPM control
[    0.858460] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA =
Driver: 8.07.00.38-k.
[    0.858953] qla2xxx [0000:0b:00.0]-001d: : Found an ISP2432 irq 16 =
iobase 0xffffb64a86265000.
[    0.859212] qla2xxx [0000:0b:00.0]-0034:0: MSI-X: Unsupported ISP =
2432 SSVID/SSDID (0x103C,0x7041).
[    0.862581] ACPI: bus type USB registered
[    0.862607] usbcore: registered new interface driver usbfs
[    0.862621] usbcore: registered new interface driver hub
[    0.862664] usbcore: registered new device driver usb
[    0.863311] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) =
Driver
[    0.863556] ehci-pci: EHCI PCI platform driver
[    0.863740] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    0.863741] uhci_hcd: USB Universal Host Controller Interface driver
[    0.863749] ehci-pci 0000:00:1d.7: new USB bus registered, assigned =
bus number 1
[    0.863763] ehci-pci 0000:00:1d.7: debug port 1
[    0.867684] ehci-pci 0000:00:1d.7: cache line size of 64 is not =
supported
[    0.867700] ehci-pci 0000:00:1d.7: irq 16, io mem 0xdddf0000
[    0.868412] libata version 3.00 loaded.
[    0.884029] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.884109] usb usb1: New USB device found, idVendor=3D1d6b, =
idProduct=3D0002
[    0.884111] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, =
SerialNumber=3D1
[    0.884112] usb usb1: Product: EHCI Host Controller
[    0.884113] usb usb1: Manufacturer: Linux 4.9.0-5-amd64 ehci_hcd
[    0.884114] usb usb1: SerialNumber: 0000:00:1d.7
[    0.884269] hub 1-0:1.0: USB hub found
[    0.884282] hub 1-0:1.0: 8 ports detected
[    0.884576] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.884581] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned =
bus number 2
[    0.884586] uhci_hcd 0000:00:1d.0: detected 2 ports
[    0.884602] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001000
[    0.884646] usb usb2: New USB device found, idVendor=3D1d6b, =
idProduct=3D0001
[    0.884648] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, =
SerialNumber=3D1
[    0.884649] usb usb2: Product: UHCI Host Controller
[    0.884650] usb usb2: Manufacturer: Linux 4.9.0-5-amd64 uhci_hcd
[    0.884651] usb usb2: SerialNumber: 0000:00:1d.0
[    0.884760] hub 2-0:1.0: USB hub found
[    0.884765] hub 2-0:1.0: 2 ports detected
[    0.884906] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.884910] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned =
bus number 3
[    0.884915] uhci_hcd 0000:00:1d.1: detected 2 ports
[    0.884939] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001020
[    0.884984] usb usb3: New USB device found, idVendor=3D1d6b, =
idProduct=3D0001
[    0.884985] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, =
SerialNumber=3D1
[    0.884986] usb usb3: Product: UHCI Host Controller
[    0.884987] usb usb3: Manufacturer: Linux 4.9.0-5-amd64 uhci_hcd
[    0.884988] usb usb3: SerialNumber: 0000:00:1d.1
[    0.885088] hub 3-0:1.0: USB hub found
[    0.885093] hub 3-0:1.0: 2 ports detected
[    0.885230] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.885235] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned =
bus number 4
[    0.885239] uhci_hcd 0000:00:1d.2: detected 2 ports
[    0.885260] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001040
[    0.885299] usb usb4: New USB device found, idVendor=3D1d6b, =
idProduct=3D0001
[    0.885300] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, =
SerialNumber=3D1
[    0.885301] usb usb4: Product: UHCI Host Controller
[    0.885302] usb usb4: Manufacturer: Linux 4.9.0-5-amd64 uhci_hcd
[    0.885303] usb usb4: SerialNumber: 0000:00:1d.2
[    0.885404] hub 4-0:1.0: USB hub found
[    0.885409] hub 4-0:1.0: 2 ports detected
[    0.885566] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    0.885570] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned =
bus number 5
[    0.885575] uhci_hcd 0000:00:1d.3: detected 2 ports
[    0.885595] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001060
[    0.885631] usb usb5: New USB device found, idVendor=3D1d6b, =
idProduct=3D0001
[    0.885633] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, =
SerialNumber=3D1
[    0.885634] usb usb5: Product: UHCI Host Controller
[    0.885635] usb usb5: Manufacturer: Linux 4.9.0-5-amd64 uhci_hcd
[    0.885636] usb usb5: SerialNumber: 0000:00:1d.3
[    0.885734] hub 5-0:1.0: USB hub found
[    0.885740] hub 5-0:1.0: 2 ports detected
[    0.885843] ata_piix 0000:00:1f.1: version 2.13
[    0.886050] uhci_hcd 0000:01:04.4: UHCI Host Controller
[    0.886054] uhci_hcd 0000:01:04.4: new USB bus registered, assigned =
bus number 6
[    0.886064] uhci_hcd 0000:01:04.4: detected 8 ports
[    0.886065] uhci_hcd 0000:01:04.4: port count misdetected? forcing to =
2 ports
[    0.887205] uhci_hcd 0000:01:04.4: irq 22, io base 0x00003800
[    0.887644] usb usb6: New USB device found, idVendor=3D1d6b, =
idProduct=3D0001
[    0.887646] usb usb6: New USB device strings: Mfr=3D3, Product=3D2, =
SerialNumber=3D1
[    0.887647] usb usb6: Product: UHCI Host Controller
[    0.887648] usb usb6: Manufacturer: Linux 4.9.0-5-amd64 uhci_hcd
[    0.887649] usb usb6: SerialNumber: 0000:01:04.4
[    0.887832] hub 6-0:1.0: USB hub found
[    0.887837] hub 6-0:1.0: 2 ports detected
[    0.888344] scsi host1: ata_piix
[    0.888472] scsi host2: ata_piix
[    0.888521] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x500 =
irq 14
[    0.888522] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x508 =
irq 15
[    0.952225] qla2xxx 0000:0b:00.0: firmware: direct-loading firmware =
ql2400_fw.bin
[    0.956052] cciss 0000:06:00.0: cciss0: <0x3230> at PCI 0000:06:00.0 =
IRQ 26 using DAC
[    0.959954]  cciss/c0d0: p1 p2 < p5 p6 >
[    0.992818]  cciss/c0d1: p1 p2 p3
[    0.993247] scsi host3: cciss
[    0.993324] HP HPSA Driver (v 3.4.16-0)
[    0.993342] hpsa 0000:13:00.0: can't disable ASPM; OS doesn't have =
ASPM control
[    0.993392] hpsa 0000:13:00.0: MSI-X capable controller
[    0.993522] hpsa 0000:13:00.0: Logical aborts not supported
[    0.993524] hpsa 0000:13:00.0: HP SSD Smart Path aborts not supported
[    1.036191] scsi host4: hpsa
[    1.041715] hpsa 0000:13:00.0: scsi 4:0:0:0: added RAID              =
HP       P411             controller SSDSmartPathCap- En- Exp=3D1
[    1.041718] hpsa 0000:13:00.0: scsi 4:0:1:0: masked Enclosure         =
PMCSIERA  SRC 8x6G        enclosure SSDSmartPathCap- En- Exp=3D0
[    1.042271] scsi 4:0:0:0: RAID              HP       P411             =
6.00 PQ: 0 ANSI: 5
[    1.080297] ata1.00: ATAPI: HL-DT-ST DVDRAM GSA-4084N, KS02, max =
UDMA/33
[    1.104178] ata1.00: configured for UDMA/33
[    1.110153] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4084N =
KS02 PQ: 0 ANSI: 5
[    1.139969] sr 1:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer dvd-ram =
cd/rw xa/form2 cdda tray
[    1.139971] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.140123] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.220012] usb 6-1: new full-speed USB device number 2 using =
uhci_hcd
[    1.248222] scsi host0: qla2xxx
[    1.248637] qla2xxx [0000:0b:00.0]-00fb:0: QLogic HPAE312A - =
PCI-Express Dual Port 4Gb Fibre Channel HBA.
[    1.248644] qla2xxx [0000:0b:00.0]-00fc:0: ISP2432: PCIe (2.5GT/s x4) =
@ 0000:0b:00.0 hdma+ host#=3D0 fw=3D8.03.00 (9496).
[    1.249025] qla2xxx [0000:0b:00.1]-001d: : Found an ISP2432 irq 17 =
iobase 0xffffb64a86275000.
[    1.249256] qla2xxx [0000:0b:00.1]-0034:5: MSI-X: Unsupported ISP =
2432 SSVID/SSDID (0x103C,0x7041).
[    1.379001] usb 6-1: New USB device found, idVendor=3D03f0, =
idProduct=3D1027
[    1.379003] usb 6-1: New USB device strings: Mfr=3D1, Product=3D2, =
SerialNumber=3D0
[    1.379004] usb 6-1: Product: Virtual Keyboard
[    1.379005] usb 6-1: Manufacturer: HP
[    1.388837] hidraw: raw HID events driver (C) Jiri Kosina
[    1.397704] usbcore: registered new interface driver usbhid
[    1.397705] usbhid: USB HID core driver
[    1.398451] input: HP Virtual Keyboard as =
/devices/pci0000:00/0000:00:1e.0/0000:01:04.4/usb6/6-1/6-1:1.0/0003:03F0:=
1027.0001/input/input3
[    1.456172] hid-generic 0003:03F0:1027.0001: input,hidraw0: USB HID =
v1.01 Keyboard [HP Virtual Keyboard] on usb-0000:01:04.4-1/input0
[    1.456333] input: HP Virtual Keyboard as =
/devices/pci0000:00/0000:00:1e.0/0000:01:04.4/usb6/6-1/6-1:1.1/0003:03F0:=
1027.0002/input/input4
[    1.456412] hid-generic 0003:03F0:1027.0002: input,hidraw1: USB HID =
v1.01 Mouse [HP Virtual Keyboard] on usb-0000:01:04.4-1/input1
[    1.468325] bnx2 0000:03:00.0 eth0: Broadcom NetXtreme II BCM5708 =
1000Base-T (B2) PCI-X 64-bit 133MHz found at mem de000000, IRQ 16, node =
addr 00:1a:4b:b2:66:e8
[    1.640225] scsi host5: qla2xxx
[    1.640592] qla2xxx [0000:0b:00.1]-00fb:5: QLogic HPAE312A - =
PCI-Express Dual Port 4Gb Fibre Channel HBA.
[    1.640596] qla2xxx [0000:0b:00.1]-00fc:5: ISP2432: PCIe (2.5GT/s x4) =
@ 0000:0b:00.1 hdma+ host#=3D5 fw=3D8.03.00 (9496).
[    1.724014] tsc: Refined TSC clocksource calibration: 3166.666 MHz
[    1.724020] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: =
0x2da548e32c1, max_idle_ns: 440795301503 ns
[    2.068262] bnx2 0000:05:00.0 eth1: Broadcom NetXtreme II BCM5708 =
1000Base-T (B2) PCI-X 64-bit 133MHz found at mem f0000000, IRQ 17, node =
addr 00:1a:4b:b2:66:e6
[    2.070777] bnx2 0000:0f:04.0 eth2: Broadcom NetXtreme II BCM5706 =
1000Base-T (A2) PCI-X 64-bit 100MHz found at mem f4000000, IRQ 17, node =
addr 00:1b:78:9a:8a:0c
[    2.073256] bnx2 0000:10:05.0 eth3: Broadcom NetXtreme II BCM5706 =
1000Base-T (A2) PCI-X 64-bit 100MHz found at mem f6000000, IRQ 18, node =
addr 00:1b:78:9a:8a:0e
[    2.073817] bnx2 0000:18:04.0 eth4: Broadcom NetXtreme II BCM5706 =
1000Base-T (A2) PCI-X 64-bit 100MHz found at mem fa000000, IRQ 19, node =
addr 00:1a:4b:ae:33:7c
[    2.074377] bnx2 0000:19:05.0 eth5: Broadcom NetXtreme II BCM5706 =
1000Base-T (A2) PCI-X 64-bit 100MHz found at mem fc000000, IRQ 16, node =
addr 00:1a:4b:ae:33:7e
[    2.076736] bnx2 0000:03:00.0 enp3s0: renamed from eth0
[    2.124236] bnx2 0000:05:00.0 enp5s0: renamed from eth1
[    2.192196] bnx2 0000:19:05.0 enp25s5: renamed from eth5
[    2.212218] bnx2 0000:0f:04.0 enp15s4: renamed from eth2
[    2.248095] bnx2 0000:18:04.0 enp24s4: renamed from eth4
[    2.280115] bnx2 0000:10:05.0 enp16s5: renamed from eth3
[    2.748112] clocksource: Switched to clocksource tsc
[    4.060026] floppy0: no floppy controllers found
[    4.103811] PM: Starting manual resume from disk
[    4.103815] PM: Hibernation image partition 104:6 present
[    4.103815] PM: Looking for hibernation image.
[    4.103864] PM: Image not found (code -22)
[    4.103865] PM: Hibernation image not present or could not be loaded.
[    4.318058] EXT4-fs (cciss!c0d0p5): mounted filesystem with ordered =
data mode. Opts: (null)
[    4.432080] random: fast init done
[    4.944340] ip_tables: (C) 2000-2006 Netfilter Core Team
[    4.967948] systemd[1]: systemd 232 running in system mode. (+PAM =
+AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP =
+GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
[    4.968132] systemd[1]: Detected architecture x86-64.
[    4.972228] systemd[1]: Set hostname to <KOM-AD01-FS03>.
[    5.409670] systemd[1]: Listening on udev Control Socket.
[    5.409895] systemd[1]: Created slice User and Session Slice.
[    5.409948] systemd[1]: Started Forward Password Requests to Wall =
Directory Watch.
[    5.409986] systemd[1]: Listening on Syslog Socket.
[    5.410028] systemd[1]: Listening on /dev/initctl Compatibility Named =
Pipe.
[    5.410075] systemd[1]: Started Dispatch Password Requests to Console =
Directory Watch.
[    5.410090] systemd[1]: Reached target Paths.
[    5.660038] EXT4-fs (cciss!c0d0p5): re-mounted. Opts: =
errors=3Dremount-ro
[    5.719349] systemd-journald[275]: Received request to flush runtime =
journal from PID 1
[    6.099974] input: Power Button as =
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
[    6.099980] ACPI: Power Button [PWRF]
[    6.108624] intel_rng: FWH not detected
[    6.232936] ipmi message handler version 39.2
[    6.233404] shpchp: Standard Hot Plug PCI Controller Driver version: =
0.4
[    6.234011] scsi 4:0:0:0: Attached scsi generic sg0 type 12
[    6.234043] hpwdt 0000:01:04.0: HPE Watchdog Timer Driver: NMI =
decoding initialized, allow kernel dump: ON (default =3D 1/ON)
[    6.234072] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    6.234101] hpwdt 0000:01:04.0: HPE Watchdog Timer Driver: 1.4.0, =
timer margin: 30 seconds (nowayout=3D0).
[    6.234638] Floppy drive(s): fd0 is 1.44M
[    6.242379] input: PC Speaker as =
/devices/platform/pcspkr/input/input6
[    6.256174] ipmi_si IPI0001:00: ipmi_si: probing via ACPI
[    6.256190] ipmi_si IPI0001:00: [io  0x0ca2-0x0ca3] regsize 1 spacing =
1 irq 0
[    6.256191] ipmi_si: Adding ACPI-specified kcs state machine
[    6.256210] IPMI System Interface driver.
[    6.256225] ipmi_si 0000:01:04.6: probing via PCI
[    6.256267] ipmi_si 0000:01:04.6: [mem 0xddef0000-0xddef00ff] regsize =
1 spacing 1 irq 21
[    6.256268] ipmi_si: Adding PCI-specified kcs state machine
[    6.256283] ipmi_si: probing via SMBIOS
[    6.256284] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
[    6.256285] ipmi_si: Adding SMBIOS-specified kcs state machine =
duplicate interface
[    6.256287] ipmi_si: probing via SPMI
[    6.256288] ipmi_si: SPMI: io 0xca2 regsize 2 spacing 2 irq 0
[    6.256288] ipmi_si: Adding SPMI-specified kcs state machine =
duplicate interface
[    6.256290] ipmi_si: Trying PCI-specified kcs state machine at mem =
address 0xddef0000, slave address 0x0, irq 21
[    6.274682] ACPI Warning: SystemIO range =
0x0000000000000928-0x000000000000092F conflicts with OpRegion =
0x0000000000000928-0x000000000000092F (\SGPE) (20160831/utaddress-247)
[    6.274687] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver
[    6.274713] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    6.307773] EDAC MC: Ver: 3.0.0
[    6.366151] EDAC MC0: Giving out device to module i5000_edac.c =
controller I5000: DEV 0000:00:10.0 (POLLED)
[    6.366166] EDAC PCI0: Giving out device to module i5000_edac =
controller EDAC PCI controller: DEV 0000:00:10.0 (POLLED)
[    6.377658] [drm] Initialized
[    6.419629] [drm] radeon kernel modesetting enabled.
[    6.524245] random: crng init done
[    6.577082] CRAT table not found
[    6.577085] Finished initializing topology ret=3D0
[    6.577108] kfd kfd: Initialized module
[    6.577613] [drm] initializing kernel modesetting (RV100 =
0x1002:0x515E 0x103C:0x31FB 0x02).
[    6.577640] [drm] register mmio base: 0xDDFF0000
[    6.577640] [drm] register mmio size: 65536
[    6.577751] radeon 0000:01:03.0: VRAM: 128M 0x00000000D0000000 - =
0x00000000D7FFFFFF (32M used)
[    6.577753] radeon 0000:01:03.0: GTT: 512M 0x00000000B0000000 - =
0x00000000CFFFFFFF
[    6.577761] [drm] Detected VRAM RAM=3D128M, BAR=3D128M
[    6.577761] [drm] RAM width 16bits DDR
[    6.577828] [TTM] Zone  kernel: Available graphics memory: 32473730 =
kiB
[    6.577829] [TTM] Zone   dma32: Available graphics memory: 2097152 =
kiB
[    6.577830] [TTM] Initializing pool allocator
[    6.577835] [TTM] Initializing DMA pool allocator
[    6.577863] [drm] radeon: 32M of VRAM memory ready
[    6.577864] [drm] radeon: 512M of GTT memory ready.
[    6.577881] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    6.598692] [drm] PCI GART of 512M enabled (table at =
0x0000000036B00000).
[    6.598731] radeon 0000:01:03.0: WB disabled
[    6.598734] radeon 0000:01:03.0: fence driver on ring 0 use gpu addr =
0x00000000b0000000 and cpu addr 0xffff8a29768a1000
[    6.598736] [drm] Supports vblank timestamp caching Rev 2 =
(21.10.2013).
[    6.598736] [drm] Driver supports precise vblank timestamp query.
[    6.598756] [drm] radeon: irq initialized.
[    6.598765] [drm] Loading R100 Microcode
[    6.601531] radeon 0000:01:03.0: firmware: failed to load =
radeon/R100_cp.bin (-2)
[    6.601580] radeon 0000:01:03.0: Direct firmware load for =
radeon/R100_cp.bin failed with error -2
[    6.601645] [drm:r100_cp_init [radeon]] *ERROR* Failed to load =
firmware!
[    6.601687] radeon 0000:01:03.0: failed initializing CP (-2).
[    6.601728] radeon 0000:01:03.0: Disabling GPU acceleration
[    6.601771] [drm] radeon: cp finalized
[    6.602264] [drm] No TV DAC info found in BIOS
[    6.602296] [drm] Radeon Display Connectors
[    6.602297] [drm] Connector 0:
[    6.602297] [drm]   VGA-1
[    6.602298] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[    6.602299] [drm]   Encoders:
[    6.602299] [drm]     CRT1: INTERNAL_DAC1
[    6.602300] [drm] Connector 1:
[    6.602300] [drm]   VGA-2
[    6.602301] [drm]   DDC: 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c
[    6.602302] [drm]   Encoders:
[    6.602302] [drm]     CRT2: INTERNAL_DAC2
[    6.638043] [drm] fb mappable at 0xD0040000
[    6.638044] [drm] vram apper at 0xD0000000
[    6.638045] [drm] size 786432
[    6.638046] [drm] fb depth is 8
[    6.638046] [drm]    pitch is 1024
[    6.638109] fbcon: radeondrmfb (fb0) is primary device
[    6.699812] Adding 7783420k swap on /dev/cciss/c0d0p6.  Priority:-1 =
extents:1 across:7783420k FS
[    6.797972] Console: switching to colour frame buffer device 128x48
[    6.805518] radeon 0000:01:03.0: fb0: radeondrmfb frame buffer device
[    6.833601] iTCO_vendor_support: vendor-support=3D0
[    6.840090] [drm] Initialized radeon 2.49.0 20080528 for 0000:01:03.0 =
on minor 0
[    6.860900] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    6.860960] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled =
by hardware/BIOS
[    6.883900] intel_powerclamp: No package C-state available
[    6.920490] intel_powerclamp: No package C-state available
[    6.988035] ipmi_si 0000:01:04.6: Using irq 21
[    6.997891] EXT4-fs (cciss!c0d0p1): mounted filesystem with ordered =
data mode. Opts: (null)
[    7.015478] ipmi_si 0000:01:04.6: Found new BMC (man_id: 0x00000b, =
prod_id: 0x2000, dev_id: 0x11)
[    7.015490] ipmi_si 0000:01:04.6: IPMI kcs interface initialized
[    7.016339] intel_powerclamp: No package C-state available
[    7.563052] nf_conntrack version 0.5.0 (65536 buckets, 262144 max)
[    8.095590] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    8.164415] bnx2 0000:03:00.0: firmware: direct-loading firmware =
bnx2/bnx2-mips-06-6.2.3.fw
[    8.169172] bnx2 0000:03:00.0: firmware: direct-loading firmware =
bnx2/bnx2-rv2p-06-6.0.15.fw
[    8.320013] bnx2 0000:03:00.0 enp3s0: using MSI
[    8.329290] ipmi device interface
[    9.436217] floppy0: no floppy controllers found
[   10.267537] Fusion MPT base driver 3.04.20
[   10.267539] Copyright (c) 1999-2008 LSI Corporation
[   10.271596] Fusion MPT misc device (ioctl) driver 3.04.20
[   10.271645] mptctl: Registered with Fusion MPT base driver
[   10.271646] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[   11.596620] bnx2 0000:03:00.0 enp3s0: NIC Copper Link is Up, 1000 =
Mbps full duplex
[   19.022138] Rounding down aligned max_sectors from 4294967295 to =
4294967288
[   19.072688] ignoring deprecated emulate_dpo attribute
[   19.072780] ignoring deprecated emulate_fua_read attribute
[   19.082406] qla2xxx [0000:0b:00.1]-00af:5: Performing ISP error =
recovery - ha=3Dffff8a38e01e0000.
[   20.056011] qla2xxx [0000:0b:00.1]-500a:5: LOOP UP detected (4 Gbps).
[   20.141014] qla2xxx [0000:0b:00.1]-0121:5: Failed to enable receiving =
of RSCN requests: 0x2.
[   21.117580] qla2xxx [0000:0b:00.0]-00af:0: Performing ISP error =
recovery - ha=3Dffff8a38e4360000.
[   22.032018] qla2xxx [0000:0b:00.0]-500a:0: LOOP UP detected (4 Gbps).
[   22.093000] qla2xxx [0000:0b:00.0]-0121:0: Failed to enable receiving =
of RSCN requests: 0x2.
[  399.251738] TARGET_CORE[qla2xxx]: Expected Transfer Length: 16621 =
does not match SCSI CDB Length: 16384 for SAM Opcode: 0xa0
[  399.257683] TARGET_CORE[qla2xxx]: Expected Transfer Length: 489 does =
not match SCSI CDB Length: 252 for SAM Opcode: 0x12
[  406.028771] TARGET_CORE[qla2xxx]: Expected Transfer Length: 16621 =
does not match SCSI CDB Length: 16384 for SAM Opcode: 0xa0
[  406.034955] TARGET_CORE[qla2xxx]: Expected Transfer Length: 489 does =
not match SCSI CDB Length: 252 for SAM Opcode: 0x12
[  407.890229] TARGET_CORE[qla2xxx]: Expected Transfer Length: 489 does =
not match SCSI CDB Length: 252 for SAM Opcode: 0x12
[  407.890788] TARGET_CORE[qla2xxx]: Expected Transfer Length: 2294 does =
not match SCSI CDB Length: 2056 for SAM Opcode: 0xa0
[  407.890972] TARGET_CORE[qla2xxx]: Expected Transfer Length: 493 does =
not match SCSI CDB Length: 255 for SAM Opcode: 0x12
[  407.893283] TARGET_CORE[qla2xxx]: Expected Transfer Length: 269 does =
not match SCSI CDB Length: 8 for SAM Opcode: 0x25
[  578.916445] =
filp_open(/var/target/pr/aptpl_678d08c9-05e7-408b-a07b-8b627b82421a) for =
APTPL metadata failed
[  579.426377] =
filp_open(/var/target/pr/aptpl_678d08c9-05e7-408b-a07b-8b627b82421a) for =
APTPL metadata failed
[  579.926333] =
filp_open(/var/target/pr/aptpl_678d08c9-05e7-408b-a07b-8b627b82421a) for =
APTPL metadata failed
[  580.426335] =
filp_open(/var/target/pr/aptpl_678d08c9-05e7-408b-a07b-8b627b82421a) for =
APTPL metadata failed
[  580.930007] =
filp_open(/var/target/pr/aptpl_678d08c9-05e7-408b-a07b-8b627b82421a) for =
APTPL metadata failed
[  580.937897] =
filp_open(/var/target/pr/aptpl_678d08c9-05e7-408b-a07b-8b627b82421a) for =
APTPL metadata failed
[  581.434556] =
filp_open(/var/target/pr/aptpl_678d08c9-05e7-408b-a07b-8b627b82421a) for =
APTPL metadata failed
[  581.933107] =
filp_open(/var/target/pr/aptpl_678d08c9-05e7-408b-a07b-8b627b82421a) for =
APTPL metadata failed
[  582.438777] =
filp_open(/var/target/pr/aptpl_678d08c9-05e7-408b-a07b-8b627b82421a) for =
APTPL metadata failed
[  582.939944] =
filp_open(/var/target/pr/aptpl_678d08c9-05e7-408b-a07b-8b627b82421a) for =
APTPL metadata failed
[  583.439915] =
filp_open(/var/target/pr/aptpl_678d08c9-05e7-408b-a07b-8b627b82421a) for =
APTPL metadata failed
[  583.444460] =
filp_open(/var/target/pr/aptpl_678d08c9-05e7-408b-a07b-8b627b82421a) for =
APTPL metadata failed
[ 1496.244209] SPC-3 PR: Attempted RESERVE from [qla2xxx]: =
10:00:00:00:c9:6f:2c:e4 while reservation already held by [qla2xxx]: =
10:00:00:00:c9:78:25:16, returning RESERVATION_CONFLICT
[ 1496.762517] SPC-3 PR: Attempted RESERVE from [qla2xxx]: =
10:00:00:00:c9:78:25:16 while reservation already held by [qla2xxx]: =
10:00:00:00:c9:6f:2c:e4, returning RESERVATION_CONFLICT
[ 1497.280926] SPC-3 PR: Attempted RESERVE from [qla2xxx]: =
10:00:00:00:c9:78:25:16 while reservation already held by [qla2xxx]: =
10:00:00:00:c9:6f:2c:e4, returning RESERVATION_CONFLICT
[ 1497.780617] SPC-3 PR: Attempted RESERVE from [qla2xxx]: =
10:00:00:00:c9:6f:2c:e4 while reservation already held by [qla2xxx]: =
10:00:00:00:c9:78:25:16, returning RESERVATION_CONFLICT
[ 1498.314196] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for =
RELEASE
[ 1498.807717] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for =
RELEASE
[ 1499.307711] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for =
RELEASE
[ 1499.823348] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for =
RELEASE
[ 1500.323350] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for =
RELEASE
[ 1500.810226] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for =
RELEASE
[ 1501.318136] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for =
RELEASE
[ 1501.820221] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for =
RELEASE
[ 1502.322301] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for =
RELEASE
[ 1502.329766] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for =
RELEASE
[ 1502.822321] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for =
RELEASE
[ 1503.322340] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for =
RELEASE
[ 1503.822350] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for =
RELEASE
[ 1504.322363] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for =
RELEASE
[ 1504.811912] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for =
RELEASE
[ 1505.311923] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for =
RELEASE
[ 1505.827549] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for =
RELEASE
[ 1506.327558] SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for =
RELEASE
[ 1506.441617] SPC-3 PR REGISTER: Received res_key: 0x000000000000000c =
does not match existing SA REGISTER res_key: 0x000000000000000b
[ 1506.441925] SPC-3 PR REGISTER: Received res_key: 0x000000000000000d =
does not match existing SA REGISTER res_key: 0x000000000000000b
[ 1508.010105] SPC-3 PR REGISTER: Received res_key: 0x000000000001000c =
does not match existing SA REGISTER res_key: 0x000000000001000b
[ 1508.020271] SPC-3 PR REGISTER: Received res_key: 0x000000000001000d =
does not match existing SA REGISTER res_key: 0x000000000001000b
[ 1509.588980] SPC-3 PR: Attempted RESERVE from [qla2xxx]: =
10:00:00:00:c9:78:25:16 while reservation already held by [qla2xxx]: =
10:00:00:00:c9:6f:2c:e4, returning RESERVATION_CONFLICT
[ 1516.112984] SPC-3 PR: Attempted RESERVE from [qla2xxx]: =
10:00:00:00:c9:6f:2c:e4 while reservation already held by [qla2xxx]: =
10:00:00:00:c9:78:25:16, returning RESERVATION_CONFLICT
[ 1522.658794] SPC-3 PR: Attempted RESERVE from [qla2xxx]: =
10:00:00:00:c9:78:25:16 while reservation already held by [qla2xxx]: =
10:00:00:00:c9:6f:2c:e4, returning RESERVATION_CONFLICT
[ 1595.004398] ABORT_TASK: Found referenced qla2xxx task_tag: 1136484
[ 1595.004400] ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: =
1136484
[ 1653.005826] ABORT_TASK: Found referenced qla2xxx task_tag: 1138200
[ 1653.005828] ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: =
1138200
[ 1831.011353] ABORT_TASK: Found referenced qla2xxx task_tag: 1139652
[ 1831.011354] ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: =
1139652
[ 1889.013392] ABORT_TASK: Found referenced qla2xxx task_tag: 1139740
[ 1889.013393] ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: =
1139740


------=_NextPart_000_0003_01D3A832.17DEB9A0--

