From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Wed, 13 Dec 2017 23:50:18 +0000
Subject: [PATCH 00/11] SCSI target patches for kernel v4.16
Message-Id: <20171213235029.581-1-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
References: <20171031180319.19258-1-bart.vanassche@wdc.com>
In-Reply-To: <20171031180319.19258-1-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hello Martin,

As you maybe know some time ago I started working on simplifying task
management function handling in the SCSI target core (see e.g. "[PATCH 00/34]
SCSI target patches for kernel v4.11"; January 2017;
https://www.spinics.net/lists/target-devel/msg14054.html). There were some
patches in that series that rightfully raised Nic's eyebrows. Reviewing these
patches myself made me realize that before TMF handling can be made
synchronous that some unusual constructs in the SCSI target core have to be
reworked first. Hence this patch series. The following tests have been run
against this patch series for both the iSCSI and SRPT target drivers:
- Run the libiscsi conformance tests.
- Run fio ${dev} in one shell and while sg_reset -d ${dev}; do :; done from
  another shell. This is a good way to stress test TMF handling.
- For the SRP target driver: run the srp-test software.

Please consider this patch series for kernel v4.16.

Thanks,

Bart.

Bart Van Assche (11):
  target: Fix an argument name in a function documentation header
  target: Use config_item_name() instead of open-coding it
  target: Avoid that EXTENDED COPY commands trigger lock inversion
  target: Make the session shutdown code also wait for commands that are
    being aborted
  target: Add more documentation
  target: Simplify core_tmr_handle_tas_abort()
  target: Fold core_tmr_handle_tas_abort() into
    transport_cmd_finish_abort()
  target: Simplify transport_generic_free_cmd() (1/2)
  target: Simplify transport_generic_free_cmd() (2/2)
  target: Simplify the code for waiting for command completion
  target/iscsi: Reduce number of __iscsit_free_cmd() callers

 drivers/target/iscsi/iscsi_target.c          |   2 -
 drivers/target/iscsi/iscsi_target_configfs.c |   1 +
 drivers/target/iscsi/iscsi_target_util.c     |   4 +-
 drivers/target/target_core_configfs.c        |   4 +-
 drivers/target/target_core_device.c          |  31 +++--
 drivers/target/target_core_internal.h        |   2 +-
 drivers/target/target_core_sbc.c             |   7 +-
 drivers/target/target_core_tmr.c             |  30 +----
 drivers/target/target_core_transport.c       | 166 ++++++++++++---------------
 include/target/target_core_base.h            |   5 +-
 10 files changed, 113 insertions(+), 139 deletions(-)

-- 
2.15.1

