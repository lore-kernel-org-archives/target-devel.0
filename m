From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 22 Jan 2019 09:27:02 +0000
Subject: [bug report] scsi: tcmu: avoid cmd/qfull timers updated whenever a new cmd comes
Message-Id: <20190122092702.GA7268@kadam>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hello Xiubo Li,

The patch a94a2572b977: "scsi: tcmu: avoid cmd/qfull timers updated
whenever a new cmd comes" from Nov 23, 2018, leads to the following
static checker warning:

	drivers/target/target_core_user.c:1325 tcmu_check_expired_cmd()
	warn: 'cmd' was already freed.

drivers/target/target_core_user.c
    1290 static int tcmu_check_expired_cmd(int id, void *p, void *data)
    1291 {
    1292 	struct tcmu_cmd *cmd = p;
    1293 	struct tcmu_dev *udev = cmd->tcmu_dev;
    1294 	u8 scsi_status;
    1295 	struct se_cmd *se_cmd;
    1296 	bool is_running;
    1297 
    1298 	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags))
    1299 		return 0;
    1300 
    1301 	if (!time_after(jiffies, cmd->deadline))
    1302 		return 0;
    1303 
    1304 	is_running = test_bit(TCMU_CMD_BIT_INFLIGHT, &cmd->flags);
    1305 	se_cmd = cmd->se_cmd;
    1306 
    1307 	if (is_running) {
    1308 		/*
    1309 		 * If cmd_time_out is disabled but qfull is set deadline
    1310 		 * will only reflect the qfull timeout. Ignore it.
    1311 		 */
    1312 		if (!udev->cmd_time_out)
    1313 			return 0;
    1314 
    1315 		set_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags);
    1316 		/*
    1317 		 * target_complete_cmd will translate this to LUN COMM FAILURE
    1318 		 */
    1319 		scsi_status = SAM_STAT_CHECK_CONDITION;
    1320 	} else {
    1321 		idr_remove(&udev->commands, id);
    1322 		tcmu_free_cmd(cmd);
                        ^^^^^^^^^^^^^^^^^^
    1323 		scsi_status = SAM_STAT_TASK_SET_FULL;
    1324 	}
--> 1325 	list_del_init(&cmd->queue_entry);
                              ^^^^^^^^^^^^^^^^^
    1326 
    1327 	pr_debug("Timing out cmd %u on dev %s that is %s.\n",
    1328 		 id, udev->name, is_running ? "inflight" : "queued");
    1329 
    1330 	target_complete_cmd(se_cmd, scsi_status);
    1331 	return 0;
    1332 }

regards,
dan carpenter
