From: "bodo.stroesser@ts.fujitsu.com" <bodo.stroesser@ts.fujitsu.com>
Date: Tue, 08 Oct 2019 20:20:12 +0000
Subject: Wrong resetting of Logical Unit Number field in CDB
Message-Id: <ac680e032540400a8cd7b1bf03361df3@R01UKEXCASM125.r01.fujitsu.local>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi,

We use TCMUser to run userspace tape and changer emulations.

Current tests with a new version of backup SW failed, due to that application
using SECURITY PROTOCOL IN / OUT  SCSI commands.
The CDBs of these commands in byte 1 contain relevant information that
is overwritten in passthrough_parse_cdb() / target_core_device.c

This is the related part of the code:

        /*
         * Clear a lun set in the cdb if the initiator talking to use spoke
         * and old standards version, as we can't assume the underlying device
         * won't choke up on it.
         */
        switch (cdb[0]) {
        case READ_10: /* SBC - RDProtect */
        case READ_12: /* SBC - RDProtect */
        case READ_16: /* SBC - RDProtect */
        case SEND_DIAGNOSTIC: /* SPC - SELF-TEST Code */
        case VERIFY: /* SBC - VRProtect */
        case VERIFY_16: /* SBC - VRProtect */
        case WRITE_VERIFY: /* SBC - VRProtect */
        case WRITE_VERIFY_12: /* SBC - VRProtect */
        case MAINTENANCE_IN: /* SPC - Parameter Data Format for SA RTPG */
                break;
        default:
                cdb[1] &= 0x1f; /* clear logical unit number */
                break;
        }

Obviously the list of command codes for which bits 5,6,7 of byte 1 are _not_ reset
is not complete. Now I'm wondering what would be the right fix:

1) Scan the SCSI specs and add all other missing command codes to the list of
   Codes to skip

2) Create a list of commands that definitely have the LUN field in byte 1 and
   reset the bits only in those. (Might be better than 1), because I expect new
   commands to not have the LUN field.)

3) Remove the code entirely, because it is no longer needed / useful (?)

For 1) and 2) an additionally question is, based on what SCSI version the lists would
have to be created?

Based on your help and hints I'd like to create a patch.

Thank you,
Bodo
