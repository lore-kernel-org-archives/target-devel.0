From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Tue, 31 Oct 2017 18:03:08 +0000
Subject: [PATCH 00/11] SCSI target patches for kernel v4.15
Message-Id: <20171031180319.19258-1-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hello Martin,

This patch series consists of patches I came up with while reviewing and
testing the SCSI target code. Please consider these patches for kernel v4.15.

Thanks,

Bart.

Bart Van Assche (11):
  target: Move a declaration of a global variable into a header file
  target: Suppress gcc 7 fallthrough warnings
  target: Inline transport_put_cmd()
  target: Avoid that EXTENDED COPY commands triggers lock inversion
  target/iscsi: Define OFFLOAD_BUF_SIZE once
  target/iscsi: Use min() in iscsit_dump_data_payload() instead of
    open-coding it
  target/iscsi: Fix endianness in an error message
  target/iscsi: Modify iscsit_do_crypto_hash_buf() prototype
  target/iscsi: Fix a race condition in iscsit_add_reject_from_cmd()
  target/iscsi: Detect conn_cmd_list corruption early
  usb/gadget: Make it again possible to enable the legacy drivers
    without enabling USB_ETH

 drivers/target/iscsi/cxgbit/cxgbit_main.c        |  1 +
 drivers/target/iscsi/iscsi_target.c              | 50 +++++++++++-------------
 drivers/target/iscsi/iscsi_target_erl1.c         |  7 ++--
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c |  2 -
 drivers/target/iscsi/iscsi_target_util.c         |  4 ++
 drivers/target/target_core_configfs.c            | 18 ++++++++-
 drivers/target/target_core_fabric_configfs.c     |  2 -
 drivers/target/target_core_internal.h            |  1 +
 drivers/target/target_core_pr.c                  |  2 +
 drivers/target/target_core_transport.c           | 27 +++----------
 drivers/usb/gadget/Kconfig                       |  4 +-
 drivers/usb/gadget/legacy/Kconfig                | 10 +++++
 include/target/target_core_base.h                |  1 +
 13 files changed, 68 insertions(+), 61 deletions(-)

-- 
2.14.2

