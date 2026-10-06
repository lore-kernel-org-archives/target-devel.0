Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419D93D9DCE
	for <target-devel@vger.kernel.org>; Tue,  6 Oct 2026 09:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791279278; cv=none; b=gcmGOp39F3B1HilNjaJqyrooqNlTiEn+DBLwHlC/yRA91fB8PDLr503Y2AUVO6n7Zd/2y9iDeFFfi0tqBDTWoRrYD9FgDoO/Rp5/dT/hg3iBUqG5CPqXKoxwDKuEzpaUVdNkzhyC96McnDGmEpOwPYpkFzKWAldbDQWlW1efAEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791279278; c=relaxed/simple;
	bh=okY7cIImX8qIYsFc9Y9Q3Pwsl1ijY3N0uQi/iyGQ8K4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hwjiiBta1BpiFUYbgOy1LoxU8r6snW77/ED9hmKiD7DJz8Zwu/JWEhJI4Wi7QoyE51+ir4vWshaV7rTq7S3trNB8xRGOm/cQaxcFGP/dfSVOnAXXj78g7p+fPoxMWEcrtH+huEYr6w7DNCyES9EOOPfJDHqHEnnYV3p6iS89ijY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cMY9vATI; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cMY9vATI"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3a4b9732d5aso679537a91.3
        for <target-devel@vger.kernel.org>; Tue, 06 Oct 2026 02:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791279268; x=1791884068; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y4occJ8bcfYl1ztAcem1o8SmF8sKoGNbjtjkE+6WTes=;
        b=cMY9vATIbKCsCvSpcEGZFdVW+CtDVE8Qqij3hcHiT2iY+FxItunXPr9yKFPGMI7yGG
         8jMbtlfoFk1nVdnZ7NLzwdotw8cFG7IdCPrQcNSvHJpDU4zWCklhw6oGvzwr9OOBD2QL
         O0RH/89LXxiV3ZNXXSpQGIR6gToihQbyi1JRxHOOPlOUXylG/gBJjtG99jbIbGIYUliz
         hJdWU6LxsQObQ7FQvbSK9nZyPlacXn6NPNxMG+wbVgL8sTt1mhQsa2USFMRSPHFP9tk/
         gelTAwI06Sr7jNYWKZn1kpaR97P7YoGa4/lW3se+bNOs7YcRNH5aAaK04wIaPKl2S1d2
         BTQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791279268; x=1791884068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y4occJ8bcfYl1ztAcem1o8SmF8sKoGNbjtjkE+6WTes=;
        b=r9s7M4bDAj7G8XSQS8SnjilRjnmMF5TIUOQZIHiWvWgS+I43CTWeXbU23+CiZD8fOI
         zB8hHP31uJU2b9fSUM64XqBkMi0m/uH7usbblPf/TtrjTRKv78aupgHdz2ZQf+YxMvuG
         +z2F572aW/b/TVMkzAsVh5nXY8NBq0MURRi5T4LQn8HjEql2V6tv6Z/jmfjAP4DqGEPE
         uxBiSnfus8qkQND2yRaEX34sGmbuw/uz+7+NC9j8hd/gN+g0EFzfZfz4diw4BFFiSVFl
         aBN1iFhjZtvtASKM54vzn7Lram4jUoGKNzuyDjhBx5SMvB8ZgYPSs3McFwBCJsJBPNrz
         KChQ==
X-Forwarded-Encrypted: i=1; AKwUvByU7fSXDG+1qhTQ4iePr8khs6Fcp07DP59LqkhKV/BTzCsUfGj1/c0oR5wSJ0uTEjLg1Flj9BTs7yKaNNw=@vger.kernel.org
X-Gm-Message-State: AFq9FYLSYwSRSSGWSaJYR0mSguvBGwunHjw3oAgBEmBhpVIzn5BYql8D
	WiR2i/uEQ7RsdtFyENzuLm2C+ckygNMF12Ct2Km1CoyDf4kfeLob4f3w
X-Gm-Gg: AYBFou0fXUBgfwmclf/0ip/7/bOyjoCRQKuvlmeJdkMEiH5/hxtVokRT5Ywbu9XrpIb
	PWsU64hE9+OTf6N3FfZKdYyjiGP1HIs90qhGMLu3NNFjw0RavkaQvlUKpbxvuCh28h8tgHs+TQj
	0bGQXrseb66oAKWegCVLDnrYyqlYObJXG6cFll4zbqcEQWyT347cLAuxCL4cNAEWCZP4CFg9LS/
	NOmO7TDZP0kjGf3Giwr0F/JLBLwzDTHPC+lYBgRqJqVEUzhLcbFK1Qwwal1inOIFIde7a+dT4RT
	dgPUBl/U3q9Suw64xKgSYLlBLlVShM5B9R8bqGsmoFL7MlB3OAcrkRdTVhB/OAuIbD7d7oJJhDy
	xNdSBLWfADmHBA/T8RIXjdRPzFQKVfVq3BqJW75OIsHyafZfdsky2gEcAkRkOiDrI5iFoyBcWFV
	J8t4LcK5JBmqoY9wgeZ9RgZTzp8UBqGXS1bbSZiRTUm++eAXC7C8yesGcP1YHO3lyYf4WoHA==
X-Received: by 2002:a17:90b:380d:b0:39d:84af:a0b3 with SMTP id 98e67ed59e1d1-3a87353c171mr667697a91.18.1791279267975;
        Tue, 06 Oct 2026 02:34:27 -0700 (PDT)
Received: from gmail.com ([188.253.12.30])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8543ab76bsm3905277a91.13.2026.10.06.02.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 02:34:27 -0700 (PDT)
From: Jia Jia <physicalmtea@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>
Cc: Jan Engelhardt <jengelh@inai.de>,
	Hannes Reinecke <hare@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	James Bottomley <James.Bottomley@suse.de>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jia Jia <physicalmtea@gmail.com>
Subject: [PATCH 2/8] scsi: target: keep REPORT REFERRALS stores inside the buffer
Date: Tue,  6 Oct 2026 17:33:32 +0800
Message-Id: <20261006093338.27342-3-physicalmtea@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261006093338.27342-1-physicalmtea@gmail.com>
References: <20261006093338.27342-1-physicalmtea@gmail.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

target_emulate_report_referrals() stores an 8-byte LBA when
data_length > off. That test only shows that one byte is left. An
allocation length of 9 therefore writes buf[8] through buf[15].

vhost-scsi keeps one sg inside a page. Nine bytes placed at page
offset 4087 end on the page boundary, so the extra seven bytes are the
next physical page. That page is not part of the data-in sgl.

The check from commit 38edd7245771 ("target_core_alua: check for buffer
overflow") still walks every map entry, so the returned data length stays
the full descriptor size. Keep the walk.
Encode each LBA locally, then copy only the bytes that fit in the
remaining allocation. This also preserves the valid prefix when the
allocation ends in the middle of an LBA field.

The one-byte descriptor fields already test data_length > off.

KASAN reports:

  BUG: KASAN: use-after-free in target_emulate_report_referrals+0x100/0x380 [target_core_mod]
  Write of size 8

  target_emulate_report_referrals
  __target_execute_cmd
  target_execute_cmd
  transport_generic_new_cmd
  __target_submit
  target_queued_submit_work
  process_one_work
  worker_thread
  kthread
  ret_from_fork

Fixes: 38edd7245771 ("target_core_alua: check for buffer overflow")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
---
 drivers/target/target_core_alua.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -44,9 +44,22 @@ static u32 alua_lu_gps_count;
 static u16 alua_lu_gps_counter;
 static u32 alua_lu_gps_count;
 
 static DEFINE_SPINLOCK(lu_gps_lock);
 static LIST_HEAD(lu_gps_list);
 
 struct t10_alua_lu_gp *default_lu_gp;
 
+static void
+target_emulate_report_referrals_copy_lba(unsigned char *buf, u32 off,
+					 u32 data_length, u64 lba)
+{
+	unsigned char lba_buf[sizeof(lba)];
+
+	if (off >= data_length)
+		return;
+	put_unaligned_be64(lba, lba_buf);
+	memcpy(&buf[off], lba_buf,
+	       min_t(u32, sizeof(lba_buf), data_length - off));
+}
+
 /*
@@ -85,13 +98,15 @@ target_emulate_report_referrals(struct se_cmd *cmd)
 	list_for_each_entry(map, &dev->t10_alua.lba_map_list,
 			    lba_map_list) {
 		int desc_num = off + 3;
 		int pg_num;
 
 		off += 4;
-		if (cmd->data_length > off)
-			put_unaligned_be64(map->lba_map_first_lba, &buf[off]);
+		target_emulate_report_referrals_copy_lba(buf, off,
+							 cmd->data_length,
+							 map->lba_map_first_lba);
 		off += 8;
-		if (cmd->data_length > off)
-			put_unaligned_be64(map->lba_map_last_lba, &buf[off]);
+		target_emulate_report_referrals_copy_lba(buf, off,
+							 cmd->data_length,
+							 map->lba_map_last_lba);
 		off += 8;
 		rd_len += 20;
