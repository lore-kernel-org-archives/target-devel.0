Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.245
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404847;
	b=OyqmqSexOrlQJKLs0WiyrsFSdmC+tLOXs10mjpOWxVdIoKVfrPKdSNmv44tsuCkkJqOW
	 snFulfkRRaTlhAmH5xy9TukxoFSyumGyurJlkaaql/j/p67tKzGrrU8hAuYwUyZCz7msm
	 jn7QYM4eMzX99XWGkRePClmJsCTQqzLMWOvNcqzQtMORZ92fQdnTarOeV53xR8+lbHPm+
	 vN2wZ9eUzTSoVGap27zWtwfZFD7SJEcaukccvGTkXCEWTzJX3jBTtGhMS2QZvH4HPxhLC
	 YxzJIuOv1jwLnneXcKRQXB54AO0K7nQdpiuShV90xM5/eMzVyLy/+a9OIITWq1tvyyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404847;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:X-B4-Tracking:To:Cc:
	 X-Mailer;
	bh=1BizE5bm2337kNlpzWkzdIe8Co2mGkxHMEG1w5RSHWo=;
	b=nuXpmDxQKBA3TKI7niMhrh6AafdS7LylYzERz4/vP2091cTie4DUMMHHwFFI6m6dB+Cn
	 xXUoNS58k0RQZmMCpTdpUpRqlTqigwsmNFdVUaQKbhfCUYDonB5h2mZgByGxwjLpH1hBz
	 09A56onRakRWA03zAxjqBIIXIfrHNCWSxFKclcUGls/WKMpo1Ja+GWVGxISe2/X5Gobia
	 k/44q93Y5FbrcQ/1j6Vj8CTO3Brnyi8UU2CFCz0u+Z90U+vdh2GzfU+X9TLWybdBipoB4
	 6xj1hDZJw9k5h4223E6rN7EiL2U4Tn22DJxemfni7Jae4M962X0NZGxBXIzFTXvnA0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Sq9mFaZd;
	arc=none smtp.remote-ip=91.218.175.245
Received: from mta0.migadu.com (out-245.mta0.migadu.com [91.218.175.245])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35BA606A33A
	for <target-devel@vger.kernel.org>; Wed, 11 Nov 2026 13:47:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A35BA606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Sq9mFaZd
X-Envelope-To: target-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=VdMYcUi7XPWWy7iGCRQJnDkZk3T3knnACfUGqAi7Z1w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794404844; v=1; x=1795009644;
 b=Sq9mFaZd7V6ryc7f0aRbOR9KaP+B+bn+Ot+Vu67lxIiKn+756DO83Zgt1lSyvJhzuTRuup6T
 eMO0Mpbu7d2EL0rr/jQmZYzZNZ13euWK+1QM4QaHZDGgKIGmkDI7nJDHllijpftJESBf5Mfrrgf
 k64WGpIMEYKUzHDlAsMB1pJQ=
X-Envelope-To: target-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1d625bdf92d81dfe;
	Wed, 11 Nov 2026 13:47:24 +0000
X-Mizu-Trace-ID: 1d625bdf92d81dfe
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Wed, 11 Nov 2026 08:47:18 -0500
Subject: [PATCH] scsi: target: alua: Free target port groups with
 kfree_rcu()
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-bug-target-alua-free-gp-v1-1-d1e692ae8694@linux.dev>
X-B4-Tracking: v=1; b=H4sIAOVx9GoC/x3MQQqEMAxA0atI1gZM1YJzlcFF1FgD4khqRRDvP
 sXlW/x/QxRTifApbjA5Nepvy6CygHHhLQjqlA2ucp6IKhxSwIMtyIG8JsbZRDDsSI1v27pj5zu
 GXO8ms17v+ds/zx8vWtVmaQAAAA==
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Mike Christie <michael.christie@oracle.com>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <qiliang.yuan@linux.dev>
X-Mailer: b4 0.13.0

core_alua_free_tg_pt_gp() frees a target port group when its configfs
group goes away, including the default group of every device when its
backstore is deleted. Readers of lun->lun_tg_pt_gp may still hold the
group, so it waits for an RCU grace period before freeing it.

The wait is synchronous, so deleting a backstore spends most of its time
in synchronize_rcu(), which adds up when tearing down many of them.

Free the group with kfree_rcu() instead. Nothing else in the function
needs the grace period to have elapsed, and kmem_cache_destroy() waits
for pending kfree_rcu() calls on module unload.

Deleting 256 rd_mcp backstores through configfs, five rounds
alternating with and without this patch, takes (median, min-max in
parentheses):

  backstores  before (ms)       after (ms)     change
         256  2108 (2105-2127)  692 (675-700)    -67%

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 drivers/target/target_core_alua.c | 3 +--
 include/target/target_core_base.h | 1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 140154d93c430..4ef243ae843bb 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1771,8 +1771,7 @@ void core_alua_free_tg_pt_gp(
 	}
 	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 
-	synchronize_rcu();
-	kmem_cache_free(t10_alua_tg_pt_gp_cache, tg_pt_gp);
+	kfree_rcu(tg_pt_gp, rcu_head);
 }
 
 static struct t10_alua_tg_pt_gp *core_alua_get_tg_pt_gp_by_name(
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 002b0fc575876..cec29cbec1643 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -331,6 +331,7 @@ struct t10_alua_tg_pt_gp {
 	struct list_head tg_pt_gp_lun_list;
 	struct se_lun *tg_pt_gp_alua_lun;
 	struct se_node_acl *tg_pt_gp_alua_nacl;
+	struct rcu_head rcu_head;
 };
 
 struct t10_vpd {

---
base-commit: b3dfbde62cf1981c4638939c159dfd087b7a72e9
change-id: 20261110-bug-target-alua-free-gp-1465539a269a

Best regards,
-- 
Qiliang Yuan <qiliang.yuan@linux.dev>

