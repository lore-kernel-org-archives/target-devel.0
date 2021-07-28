Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E39C4338F
	for <target-devel@archiver.kernel.org>; Wed, 28 Jul 2021 11:54:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ECE060EB2
	for <target-devel@archiver.kernel.org>; Wed, 28 Jul 2021 11:54:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbhG1Lyd (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 07:54:33 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:43226 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236180AbhG1Lya (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 07:54:30 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 4955522303;
        Wed, 28 Jul 2021 11:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1627473265; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wP0kGLM35GFqHOl87a7ZDS0M7gPM3pxvHhCTsV1M+UQ=;
        b=UVFu85q1ULjGxTGz0y3CY0pZwTmYgrqvNp50FFEgX2UdO4/9d7WvoruD0s6wVU4Aq7sQZ/
        wFLFMbncOCtXa+x0waBXVCurReHssbMCjXaf1sABaPflwP913uRP8qwqB6RMxk5srqxgeh
        wkdwMMqHz3HhUjACAIaPIpegKr7IvzU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1627473265;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wP0kGLM35GFqHOl87a7ZDS0M7gPM3pxvHhCTsV1M+UQ=;
        b=29xIm3B41w8k9lj3AY91RZ3hCJt4EXYvEiGy+LtdSRKjC5Jysjn6vIOh+fDQspXD3MSP4U
        Ur9DesUj5AhRaYAg==
Received: from echidna.suse.de (unknown [10.163.26.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 1FF29A3B87;
        Wed, 28 Jul 2021 11:54:25 +0000 (UTC)
From:   David Disseldorp <ddiss@suse.de>
To:     target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, michael.christie@oracle.com,
        David Disseldorp <ddiss@suse.de>
Subject: [PATCH 3/3] scsi: target: drop unnecessary se_cmd asc/ascq members
Date:   Wed, 28 Jul 2021 13:53:54 +0200
Message-Id: <20210728115353.2396-4-ddiss@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210728115353.2396-1-ddiss@suse.de>
References: <20210728115353.2396-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

These members are only used for ALUA sense detail propagation, which
can just as easily be done via sense_reason_t.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/target_core_alua.c      | 86 +++++++++-----------------
 drivers/target/target_core_transport.c | 33 +++++++---
 include/target/target_core_base.h      |  8 ++-
 3 files changed, 60 insertions(+), 67 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index e0036e72b351..cb1de1ecaaa6 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -428,22 +428,6 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 	return rc;
 }
 
-static inline void set_ascq(struct se_cmd *cmd, u8 alua_ascq)
-{
-	/*
-	 * Set SCSI additional sense code (ASC) to 'LUN Not Accessible';
-	 * The ALUA additional sense code qualifier (ASCQ) is determined
-	 * by the ALUA primary or secondary access state..
-	 */
-	pr_debug("[%s]: ALUA TG Port not available, "
-		"SenseKey: NOT_READY, ASC/ASCQ: "
-		"0x04/0x%02x\n",
-		cmd->se_tfo->fabric_name, alua_ascq);
-
-	cmd->scsi_asc = 0x04;
-	cmd->scsi_ascq = alua_ascq;
-}
-
 static inline void core_alua_state_nonoptimized(
 	struct se_cmd *cmd,
 	unsigned char *cdb,
@@ -458,7 +442,7 @@ static inline void core_alua_state_nonoptimized(
 	cmd->alua_nonop_delay = nonop_delay_msecs;
 }
 
-static inline int core_alua_state_lba_dependent(
+static inline sense_reason_t core_alua_state_lba_dependent(
 	struct se_cmd *cmd,
 	u16 tg_pt_gp_id)
 {
@@ -506,8 +490,7 @@ static inline int core_alua_state_lba_dependent(
 		}
 		if (!cur_map) {
 			spin_unlock(&dev->t10_alua.lba_map_lock);
-			set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_UNAVAILABLE);
-			return 1;
+			return TCM_ALUA_TG_PT_UNAVAILABLE;
 		}
 		list_for_each_entry(map_mem, &cur_map->lba_map_mem_list,
 				    lba_map_mem_list) {
@@ -516,12 +499,10 @@ static inline int core_alua_state_lba_dependent(
 			switch(map_mem->lba_map_mem_alua_state) {
 			case ALUA_ACCESS_STATE_STANDBY:
 				spin_unlock(&dev->t10_alua.lba_map_lock);
-				set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_STANDBY);
-				return 1;
+				return TCM_ALUA_TG_PT_STANDBY;
 			case ALUA_ACCESS_STATE_UNAVAILABLE:
 				spin_unlock(&dev->t10_alua.lba_map_lock);
-				set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_UNAVAILABLE);
-				return 1;
+				return TCM_ALUA_TG_PT_UNAVAILABLE;
 			default:
 				break;
 			}
@@ -531,7 +512,7 @@ static inline int core_alua_state_lba_dependent(
 	return 0;
 }
 
-static inline int core_alua_state_standby(
+static inline sense_reason_t core_alua_state_standby(
 	struct se_cmd *cmd,
 	unsigned char *cdb)
 {
@@ -555,24 +536,21 @@ static inline int core_alua_state_standby(
 		case SAI_READ_CAPACITY_16:
 			return 0;
 		default:
-			set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_STANDBY);
-			return 1;
+			return TCM_ALUA_TG_PT_STANDBY;
 		}
 	case MAINTENANCE_IN:
 		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:
 			return 0;
 		default:
-			set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_STANDBY);
-			return 1;
+			return TCM_ALUA_TG_PT_STANDBY;
 		}
 	case MAINTENANCE_OUT:
 		switch (cdb[1]) {
 		case MO_SET_TARGET_PGS:
 			return 0;
 		default:
-			set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_STANDBY);
-			return 1;
+			return TCM_ALUA_TG_PT_STANDBY;
 		}
 	case REQUEST_SENSE:
 	case PERSISTENT_RESERVE_IN:
@@ -581,14 +559,13 @@ static inline int core_alua_state_standby(
 	case WRITE_BUFFER:
 		return 0;
 	default:
-		set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_STANDBY);
-		return 1;
+		return TCM_ALUA_TG_PT_STANDBY;
 	}
 
 	return 0;
 }
 
-static inline int core_alua_state_unavailable(
+static inline sense_reason_t core_alua_state_unavailable(
 	struct se_cmd *cmd,
 	unsigned char *cdb)
 {
@@ -605,30 +582,27 @@ static inline int core_alua_state_unavailable(
 		case MI_REPORT_TARGET_PGS:
 			return 0;
 		default:
-			set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_UNAVAILABLE);
-			return 1;
+			return TCM_ALUA_TG_PT_UNAVAILABLE;
 		}
 	case MAINTENANCE_OUT:
 		switch (cdb[1]) {
 		case MO_SET_TARGET_PGS:
 			return 0;
 		default:
-			set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_UNAVAILABLE);
-			return 1;
+			return TCM_ALUA_TG_PT_UNAVAILABLE;
 		}
 	case REQUEST_SENSE:
 	case READ_BUFFER:
 	case WRITE_BUFFER:
 		return 0;
 	default:
-		set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_UNAVAILABLE);
-		return 1;
+		return TCM_ALUA_TG_PT_UNAVAILABLE;
 	}
 
 	return 0;
 }
 
-static inline int core_alua_state_transition(
+static inline sense_reason_t core_alua_state_transition(
 	struct se_cmd *cmd,
 	unsigned char *cdb)
 {
@@ -645,16 +619,14 @@ static inline int core_alua_state_transition(
 		case MI_REPORT_TARGET_PGS:
 			return 0;
 		default:
-			set_ascq(cmd, ASCQ_04H_ALUA_STATE_TRANSITION);
-			return 1;
+			return TCM_ALUA_STATE_TRANSITION;
 		}
 	case REQUEST_SENSE:
 	case READ_BUFFER:
 	case WRITE_BUFFER:
 		return 0;
 	default:
-		set_ascq(cmd, ASCQ_04H_ALUA_STATE_TRANSITION);
-		return 1;
+		return TCM_ALUA_STATE_TRANSITION;
 	}
 
 	return 0;
@@ -674,6 +646,7 @@ target_alua_state_check(struct se_cmd *cmd)
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	int out_alua_state, nonop_delay_msecs;
 	u16 tg_pt_gp_id;
+	sense_reason_t rc = TCM_NO_SENSE;
 
 	if (dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE)
 		return 0;
@@ -687,8 +660,7 @@ target_alua_state_check(struct se_cmd *cmd)
 	if (atomic_read(&lun->lun_tg_pt_secondary_offline)) {
 		pr_debug("ALUA: Got secondary offline status for local"
 				" target port\n");
-		set_ascq(cmd, ASCQ_04H_ALUA_OFFLINE);
-		return TCM_CHECK_CONDITION_NOT_READY;
+		return TCM_ALUA_OFFLINE;
 	}
 
 	if (!lun->lun_tg_pt_gp)
@@ -715,20 +687,16 @@ target_alua_state_check(struct se_cmd *cmd)
 		core_alua_state_nonoptimized(cmd, cdb, nonop_delay_msecs);
 		break;
 	case ALUA_ACCESS_STATE_STANDBY:
-		if (core_alua_state_standby(cmd, cdb))
-			return TCM_CHECK_CONDITION_NOT_READY;
+		rc = core_alua_state_standby(cmd, cdb);
 		break;
 	case ALUA_ACCESS_STATE_UNAVAILABLE:
-		if (core_alua_state_unavailable(cmd, cdb))
-			return TCM_CHECK_CONDITION_NOT_READY;
+		rc = core_alua_state_unavailable(cmd, cdb);
 		break;
 	case ALUA_ACCESS_STATE_TRANSITION:
-		if (core_alua_state_transition(cmd, cdb))
-			return TCM_CHECK_CONDITION_NOT_READY;
+		rc = core_alua_state_transition(cmd, cdb);
 		break;
 	case ALUA_ACCESS_STATE_LBA_DEPENDENT:
-		if (core_alua_state_lba_dependent(cmd, tg_pt_gp_id))
-			return TCM_CHECK_CONDITION_NOT_READY;
+		rc = core_alua_state_lba_dependent(cmd, tg_pt_gp_id);
 		break;
 	/*
 	 * OFFLINE is a secondary ALUA target port group access state, that is
@@ -738,10 +706,16 @@ target_alua_state_check(struct se_cmd *cmd)
 	default:
 		pr_err("Unknown ALUA access state: 0x%02x\n",
 				out_alua_state);
-		return TCM_INVALID_CDB_FIELD;
+		rc = TCM_INVALID_CDB_FIELD;
 	}
 
-	return 0;
+	if (rc && rc != TCM_INVALID_CDB_FIELD) {
+		pr_debug("[%s]: ALUA TG Port not available, "
+			"SenseKey: NOT_READY, ASC/rc: 0x04/%d\n",
+			cmd->se_tfo->fabric_name, rc);
+	}
+
+	return rc;
 }
 
 /*
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 26ceabe34de5..c26b3afc4575 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2003,7 +2003,6 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 	case TCM_ADDRESS_OUT_OF_RANGE:
 	case TCM_CHECK_CONDITION_ABORT_CMD:
 	case TCM_CHECK_CONDITION_UNIT_ATTENTION:
-	case TCM_CHECK_CONDITION_NOT_READY:
 	case TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED:
 	case TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED:
 	case TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED:
@@ -2013,6 +2012,10 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 	case TCM_TOO_MANY_SEGMENT_DESCS:
 	case TCM_UNSUPPORTED_SEGMENT_DESC_TYPE_CODE:
 	case TCM_INVALID_FIELD_IN_COMMAND_IU:
+	case TCM_ALUA_TG_PT_STANDBY:
+	case TCM_ALUA_TG_PT_UNAVAILABLE:
+	case TCM_ALUA_STATE_TRANSITION:
+	case TCM_ALUA_OFFLINE:
 		break;
 	case TCM_OUT_OF_RESOURCES:
 		cmd->scsi_status = SAM_STAT_TASK_SET_FULL;
@@ -3277,9 +3280,6 @@ static const struct sense_detail sense_detail_table[] = {
 	[TCM_CHECK_CONDITION_UNIT_ATTENTION] = {
 		.key = UNIT_ATTENTION,
 	},
-	[TCM_CHECK_CONDITION_NOT_READY] = {
-		.key = NOT_READY,
-	},
 	[TCM_MISCOMPARE_VERIFY] = {
 		.key = MISCOMPARE,
 		.asc = 0x1d, /* MISCOMPARE DURING VERIFY OPERATION */
@@ -3340,6 +3340,26 @@ static const struct sense_detail sense_detail_table[] = {
 		.asc = 0x0e,
 		.ascq = 0x03, /* INVALID FIELD IN COMMAND INFORMATION UNIT */
 	},
+	[TCM_ALUA_TG_PT_STANDBY] = {
+		.key = NOT_READY,
+		.asc = 0x04,
+		.ascq = ASCQ_04H_ALUA_TG_PT_STANDBY,
+	},
+	[TCM_ALUA_TG_PT_UNAVAILABLE] = {
+		.key = NOT_READY,
+		.asc = 0x04,
+		.ascq = ASCQ_04H_ALUA_TG_PT_UNAVAILABLE,
+	},
+	[TCM_ALUA_STATE_TRANSITION] = {
+		.key = NOT_READY,
+		.asc = 0x04,
+		.ascq = ASCQ_04H_ALUA_STATE_TRANSITION,
+	},
+	[TCM_ALUA_OFFLINE] = {
+		.key = NOT_READY,
+		.asc = 0x04,
+		.ascq = ASCQ_04H_ALUA_OFFLINE,
+	},
 };
 
 /**
@@ -3374,11 +3394,8 @@ static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 			cmd->scsi_status = SAM_STAT_BUSY;
 			return;
 		}
-	} else if (sd->asc == 0) {
-		WARN_ON_ONCE(cmd->scsi_asc == 0);
-		asc = cmd->scsi_asc;
-		ascq = cmd->scsi_ascq;
 	} else {
+		WARN_ON_ONCE(sd->asc == 0);
 		asc = sd->asc;
 		ascq = sd->ascq;
 	}
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 85c16c266eac..f53e0f160695 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -171,7 +171,7 @@ enum tcm_sense_reason_table {
 	TCM_WRITE_PROTECTED			= R(0x0c),
 	TCM_CHECK_CONDITION_ABORT_CMD		= R(0x0d),
 	TCM_CHECK_CONDITION_UNIT_ATTENTION	= R(0x0e),
-	TCM_CHECK_CONDITION_NOT_READY		= R(0x0f),
+
 	TCM_RESERVATION_CONFLICT		= R(0x10),
 	TCM_ADDRESS_OUT_OF_RANGE		= R(0x11),
 	TCM_OUT_OF_RESOURCES			= R(0x12),
@@ -188,6 +188,10 @@ enum tcm_sense_reason_table {
 	TCM_INSUFFICIENT_REGISTRATION_RESOURCES	= R(0x1d),
 	TCM_LUN_BUSY				= R(0x1e),
 	TCM_INVALID_FIELD_IN_COMMAND_IU         = R(0x1f),
+	TCM_ALUA_TG_PT_STANDBY			= R(0x20),
+	TCM_ALUA_TG_PT_UNAVAILABLE		= R(0x21),
+	TCM_ALUA_STATE_TRANSITION		= R(0x22),
+	TCM_ALUA_OFFLINE			= R(0x23),
 #undef R
 };
 
@@ -455,8 +459,6 @@ enum target_core_dif_check {
 struct se_cmd {
 	/* SAM response code being sent to initiator */
 	u8			scsi_status;
-	u8			scsi_asc;
-	u8			scsi_ascq;
 	u16			scsi_sense_length;
 	unsigned		unknown_data_length:1;
 	bool			state_active:1;
-- 
2.26.2

