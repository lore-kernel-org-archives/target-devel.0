From: Li Zhong <lizhongfs@gmail.com>
Date: Mon, 05 Aug 2019 00:43:36 +0000
Subject: [RFC PATCH v2] target: tcmu: clean the nl_cmd of the udev when nl send fails
Message-Id: <20190805004336.16181-1-lizhongfs@gmail.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

If the userspace process crashes while we send the nl msg, it is possible
that the cmd in curr_nl_cmd of tcmu_dev never gets reset to 0, and
and returns busy for other commands after the userspace process is
restartd.

More details below:

/backstores/user:file/file> set attribute dev_size 48
Cannot set attribute dev_size: [Errno 3] No such process
/backstores/user:file/file> set attribute dev_size 48
Cannot set attribute dev_size: [Errno 16] Device or resource busy

with following kernel messages:
[173605.747169] Unable to reconfigure device
[173616.686674] tcmu daemon: command reply support 1.
[173623.866978] netlink cmd 3 already executing on file
[173623.866984] Unable to reconfigure device

Also, it is not safe to leave the nl_cmd in the list, and not get
deleted.

This patch removes the nl_cmd from the list, and clear its data if
it is not sent successfully.

Signed-off-by: Li Zhong <lizhongfs@gmail.com>
---
 drivers/target/target_core_user.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 04eda111920e..68045cbca595 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1708,6 +1708,24 @@ static int tcmu_init_genl_cmd_reply(struct tcmu_dev *udev, int cmd)
 	return 0;
 }
 
+static void tcmu_destroy_genl_cmd_reply(struct tcmu_dev *udev)
+{
+	struct tcmu_nl_cmd *nl_cmd = &udev->curr_nl_cmd;
+
+	if (!tcmu_kern_cmd_reply_supported)
+		return;
+
+	if (udev->nl_reply_supported <= 0)
+		return;
+
+	mutex_lock(&tcmu_nl_cmd_mutex);
+
+	list_del(&nl_cmd->nl_list);
+	memset(nl_cmd, 0, sizeof(*nl_cmd));
+
+	mutex_unlock(&tcmu_nl_cmd_mutex);
+}
+
 static int tcmu_wait_genl_cmd_reply(struct tcmu_dev *udev)
 {
 	struct tcmu_nl_cmd *nl_cmd = &udev->curr_nl_cmd;
@@ -1788,6 +1806,8 @@ static int tcmu_netlink_event_send(struct tcmu_dev *udev,
 	if (ret = 0 ||
 	   (ret = -ESRCH && cmd = TCMU_CMD_ADDED_DEVICE))
 		return tcmu_wait_genl_cmd_reply(udev);
+	else
+		tcmu_destroy_genl_cmd_reply(udev);
 
 	return ret;
 }
-- 
2.20.1
