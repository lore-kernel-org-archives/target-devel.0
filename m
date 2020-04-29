From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Wed, 29 Apr 2020 09:44:33 +0000
Subject: [RFC PATCH 00/11] scsi: target/core: Improve ALUA configuration for multi-node TCM
Message-Id: <20200429094443.43937-1-r.bolshakov@yadro.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org, Mike Christie <mchristi@redhat.com>, Bart Van Assche <bvanassche@acm.org>, David Disseldorp <ddiss@suse.de>
Cc: linux-scsi@vger.kernel.org, linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>

Dear SCSI target developers,

The patch series is a backwards-compatible attempt to add flexibility and
consistency in ALUA configuration for multi-node TCM setups with multiple
target ports on each node. The series is based off 5.8/scsi-queue.

Patch 1 adds a way to hide default_tg_pt_gp. It is always returned in REPORT
TARGET PORT GROUP response in the current implementation even if there is no
need to report its presence.

Consider a backstore with non-default node1 that has target port group id 1.
If the group is assigned as a primary target port group to a LUN,
REPORT TARGET PORT GROUPS is going to return two groups:

T # echo node1 > $TARGET/tpgt_1/lun/lun_0/alua_tg_pt_gp
I # sg_rtpg /dev/sda
Report target port groups:
  target port group id : 0x0 , Pref=0, Rtpg_fmt=0
    target port group asymmetric access state : 0x00
    T_SUP : 1, O_SUP : 1, LBD_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 1, AO_SUP : 1
    status code : 0x00
    vendor unique status : 0x00
    target port count : 00
  target port group id : 0x1 , Pref=0, Rtpg_fmt=0
    target port group asymmetric access state : 0x00
    T_SUP : 1, O_SUP : 1, LBD_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 1, AO_SUP : 1
    status code : 0x00
    vendor unique status : 0x00
    target port count : 01
    Relative target port ids:
      0x01

The patch adds a way to show only non-empty target port groups:

T # echo 1 > $BACKSTORE/alua/default_tg_pt_gp/hidden
I # sg_rtpg /dev/sda
Report target port groups:
  target port group id : 0x1 , Pref=0, Rtpg_fmt=0
    target port group asymmetric access state : 0x00
    T_SUP : 1, O_SUP : 1, LBD_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 1, AO_SUP : 1
    status code : 0x00
    vendor unique status : 0x00
    target port count : 01
    Relative target port ids:
      0x01

Patch 2 is a fix that improves SCSI conformance and sets MULTIP bit in the
standard inquiry data if a backstore is exported on multiple ports.

Patches 3 through 6 change RTPI allocation. They're aimed to tackle the
following misbehaviour.

SAM-5 4.6.5.2 (Relative Port Identifier attribute) defines the attribute
as unique across SCSI target ports.

The Relative Port Identifier attribute identifies a SCSI target port or
a SCSI initiator port relative to other SCSI ports in a SCSI target
device and any SCSI initiator devices contained within that SCSI target
device. A SCSI target device may assign relative port identifiers to its
SCSI target ports and any SCSI initiator ports. If relative port
identifiers are assigned, the SCSI target device shall assign each of
its SCSI target ports and any SCSI initiator ports a unique relative
port identifier from 1 to 65 535. SCSI target ports and SCSI initiator
ports share the same number space.

Examples of relative port identifiers usage are described in the
Device Identification VPD page, SCSI Ports VPD page and Reservations.
Relative port identifiers are not required to be contiguous.
Relative port identifier for a SCSI port shall not change once assigned unless
reconfiguration of the SCSI target device occurs.

In the current TCM implementation, auto-incremented lun_rtpi doesn't
follow the model outlined by SAM-5 and SPC-4. In case of multiple SCSI
target ports (se_portal_group's), which is common to scenario with
multiple HBAs or multiple iSCSI/FC targets, it's possible to have two
backstores (se_device's) with different values of lun_rtpi on the same
SCSI target port.

Consider we have backstores foo and bar and target ports A and B.
If foo is exported first on A and then on B but bar is exported on B and
then on A, we get the following:
  RTPI of foo on A is going to be 1, RTPI of bar on A is going to be 2
  RTPI of foo on B is going to be 2, RTPI of bar on B is going to be 1

Similar issue happens during re-export. If a LUN of a backstore is
removed from a target port and added again to the same target port, RTPI
is incremented again and will be different from the first time.

The two issues happen because each se_device increments RTPI for its own
LUNs independently.

The behaviour means that a SCSI application client can't reliably make any
sense of RTPI values reported by a LUN as it's not really related to SCSI
target ports. A conforming target implementation must ensure that RTPI field is
unique per port. The three patches resolve the issue.

Patches 7 and 8 add ability to set and read RTPI value for a target port after
initial configuration using configfs:

I # sg_rtpg /dev/sda
Report target port groups:
  target port group id : 0x1 , Pref=0, Rtpg_fmt=0
    target port group asymmetric access state : 0x00
    T_SUP : 1, O_SUP : 1, LBD_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 1, AO_SUP : 1
    status code : 0x00
    vendor unique status : 0x00
    target port count : 01
    Relative target port ids:
      0x01

T # echo 2 > $TARGET/tpgt_1/attrib/rtpi
I # sg_rtpg /dev/sda
Report target port groups:
  target port group id : 0x0 , Pref=0, Rtpg_fmt=0
    target port group asymmetric access state : 0x00
    T_SUP : 1, O_SUP : 1, LBD_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 1, AO_SUP : 1
    status code : 0x00
    vendor unique status : 0x00
    target port count : 01
    Relative target port ids:
      0x02

INQUIRY DATA HAS CHANGED unit attention is sent after RTPI change on all I_T
nexuses related to the port.

Patches 9 through 11 is a new feature that helps to return RTPI consistently on
all ports in a cluster running TCM. Together with previous RTPI changes, it
allows to assign RTPI values to a target port group that resides on the other
node and report it. Consider that node1 two primary target port groups, node1
and node2, with target port group id 1 and 2, respectively. node1 has real port
attached to it. node2 is a target portal group to represent state of the ports
on node2. Then it can be filled with fake peer ports using configfs:

T # mkdir $BACKSTORE/alua/node2/peers/2
I # sg_rtpg /dev/sda
Report target port groups:
  target port group id : 0x1 , Pref=0, Rtpg_fmt=0
    target port group asymmetric access state : 0x00
    T_SUP : 1, O_SUP : 1, LBD_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 1, AO_SUP : 1
    status code : 0x00
    vendor unique status : 0x00
    target port count : 01
    Relative target port ids:
      0x01
  target port group id : 0x2 , Pref=0, Rtpg_fmt=0
    target port group asymmetric access state : 0x00
    T_SUP : 1, O_SUP : 1, LBD_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 1, AO_SUP : 1
    status code : 0x00
    vendor unique status : 0x00
    target port count : 01
    Relative target port ids:
      0x02

And it's possible to have a similar config on node2 to report port groups
consistently regardless of where the command was received.

The patches also ensure that no LUN has duplicated RTPI values between SCSI
target ports and peer ports. Unfortunately, a global RTPI mutex had to be
introduced for that.

There are a few checkpatch.pl checks/warnings I had to keep to avoid breaking
80 char limit:
CHECK: Lines should not end with a '('
WARNING: quoted string split across lines

Thanks,
Roman

Roman Bolshakov (11):
  scsi: target/core: Add a way to hide a port group
  scsi: target/core: Set MULTIP bit for se_device with multiple ports
  scsi: target/core: Add cleanup sequence in core_tpg_register()
  scsi: target/core: Add RTPI field to target port
  scsi: target/core: Use RTPI from target port
  scsi: target/core: Drop device-based RTPI
  scsi: target/core: Add common port attributes
  scsi: target/core: Add RTPI attribute for target port
  scsi: target/core: Populate configfs for peer ports
  scsi: target/core: Prevent RTPI conflicts
  scsi: target/core: Show peer ports in RTPG response

 drivers/target/target_core_alua.c            |  44 +++-
 drivers/target/target_core_alua.h            |   1 +
 drivers/target/target_core_configfs.c        | 164 ++++++++++++-
 drivers/target/target_core_device.c          |  62 ++---
 drivers/target/target_core_fabric_configfs.c |  41 +++-
 drivers/target/target_core_internal.h        |   4 +-
 drivers/target/target_core_pr.c              |   8 +-
 drivers/target/target_core_spc.c             |  19 +-
 drivers/target/target_core_stat.c            |   6 +-
 drivers/target/target_core_tpg.c             | 246 +++++++++++++++++--
 drivers/target/target_core_transport.c       |  15 +-
 include/target/target_core_base.h            |  17 +-
 12 files changed, 549 insertions(+), 78 deletions(-)

-- 
2.26.1
