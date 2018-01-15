From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 15 Jan 2018 09:36:33 +0000
Subject: [bug report] tcmu: make ring buffer timer configurable
Message-Id: <20180115093633.pazk6vuvj7j6q2gr@mwanda>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hello Mike Christie,

The patch 9103575ae34e: "tcmu: make ring buffer timer configurable"
from Nov 28, 2017, leads to the following static checker warning:

	drivers/target/target_core_user.c:1173 tcmu_check_expired_cmd()
	error: dereferencing freed memory 'cmd'

drivers/target/target_core_user.c
  1162                  scsi_status = SAM_STAT_CHECK_CONDITION;
  1163          } else {
  1164                  list_del_init(&cmd->cmdr_queue_entry);
  1165  
  1166                  idr_remove(&udev->commands, id);
  1167                  tcmu_free_cmd(cmd);
                        ^^^^^^^^^^^^^^^^^^
Freed

  1168                  scsi_status = SAM_STAT_TASK_SET_FULL;
  1169          }
  1170  
  1171          pr_debug("Timing out cmd %u on dev %s that is %s.\n",
  1172                   id, udev->name, is_running ? "inflight" : "queued");
  1173  
  1174          se_cmd = cmd->se_cmd;
                         ^^^^^^^^^^^
Use after free

  1175          cmd->se_cmd = NULL;
                ^^^^^^^^^^^^^^^^^^

  1176          target_complete_cmd(se_cmd, scsi_status);
  1177          return 0;
  1178  }

regards,
dan carpenter
