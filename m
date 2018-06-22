From: Mike Christie <mchristi@redhat.com>
Date: Fri, 22 Jun 2018 21:40:21 +0000
Subject: [PATCH 4/6] tcmu: misc nl code cleanup
Message-Id: <1529703623-9606-5-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Some misc cleanup of the nl rework patches.

1. Fix space instead of tabs use and extra newline.
2. Drop initializing variables to 0 when not needed
3. Just pass the skb_buff and msg_header pointers to
tcmu_netlink_event_send.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 9835ea3..2a2e9e4e 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1628,11 +1628,9 @@ static int tcmu_netlink_event_init(struct tcmu_dev *udev,
 
 static int tcmu_netlink_event_send(struct tcmu_dev *udev,
 				   enum tcmu_genl_cmd cmd,
-				   struct sk_buff **buf, void **hdr)
+				   struct sk_buff *skb, void *msg_header)
 {
-	int ret = 0;
-	struct sk_buff *skb = *buf;
-	void *msg_header = *hdr;
+	int ret;
 
 	genlmsg_end(skb, msg_header);
 
@@ -1644,7 +1642,7 @@ static int tcmu_netlink_event_send(struct tcmu_dev *udev,
 
 	ret = genlmsg_multicast_allns(&tcmu_genl_family, skb, 0,
 				      TCMU_MCGRP_CONFIG, GFP_KERNEL);
-       /* We don't care if no one is listening */
+	/* We don't care if no one is listening */
 	if (ret = -ESRCH)
 		ret = 0;
 	if (!ret)
@@ -1662,9 +1660,8 @@ static int tcmu_send_dev_add_event(struct tcmu_dev *udev)
 				      &msg_header);
 	if (ret < 0)
 		return ret;
-	return tcmu_netlink_event_send(udev, TCMU_CMD_ADDED_DEVICE, &skb,
-				       &msg_header);
-
+	return tcmu_netlink_event_send(udev, TCMU_CMD_ADDED_DEVICE, skb,
+				       msg_header);
 }
 
 static int tcmu_send_dev_remove_event(struct tcmu_dev *udev)
@@ -1678,7 +1675,7 @@ static int tcmu_send_dev_remove_event(struct tcmu_dev *udev)
 	if (ret < 0)
 		return ret;
 	return tcmu_netlink_event_send(udev, TCMU_CMD_REMOVED_DEVICE,
-				       &skb, &msg_header);
+				       skb, msg_header);
 }
 
 static int tcmu_update_uio_info(struct tcmu_dev *udev)
@@ -2197,7 +2194,7 @@ static int tcmu_send_dev_config_event(struct tcmu_dev *udev,
 		return ret;
 	}
 	return tcmu_netlink_event_send(udev, TCMU_CMD_RECONFIG_DEVICE,
-				       &skb, &msg_header);
+				       skb, msg_header);
 }
 
 
@@ -2259,7 +2256,7 @@ static int tcmu_send_dev_size_event(struct tcmu_dev *udev, u64 size)
 		return ret;
 	}
 	return tcmu_netlink_event_send(udev, TCMU_CMD_RECONFIG_DEVICE,
-				       &skb, &msg_header);
+				       skb, msg_header);
 }
 
 static ssize_t tcmu_dev_size_store(struct config_item *item, const char *page,
@@ -2341,7 +2338,7 @@ static int tcmu_send_emulate_write_cache(struct tcmu_dev *udev, u8 val)
 		return ret;
 	}
 	return tcmu_netlink_event_send(udev, TCMU_CMD_RECONFIG_DEVICE,
-				       &skb, &msg_header);
+				       skb, msg_header);
 }
 
 static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
-- 
2.7.2

