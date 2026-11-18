Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794975249;
	b=J4I6diveDpuvBRtX2+WmblruAY9m4ERnMstMSDDI0gSduizNZTf3CCDkV2/pvfIDJNbN
	 J2g27m0TcBKffzPBdxqTjoyXm/FlFj5rZ10QG80/dzGBA9zJIjiZegRqyvx2geANTzJyF
	 Wpz3In1NQmaScZtE0Pn3r/uBN8ZlNFg3TCYd/HdYc5QIXUoSJ6A0UOuKE5h4uKyNpX2T5
	 V+VcTwTmbSxOS0G2Wmc7lYPBeorbN1CMkL6J4atIKLzO0OWNnPMwVaKUK0KYkQOerGdfG
	 tNBl0SRpNvl0jzrtphQ4p1YRpm7VTvuEhvQiPkfBL6krXXbTCc1hVb+88tqljKGSFpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794975249;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QqYVAbH+O5Ra0wuswn0xYA0NuJYo04JzgdWyvccojr8=;
	b=MAHxwHc3mrjrJ2s2FgKB0x47/omKa4kHUmz8oItfexIgeaYaoXSHoKtxujEKSClYSsiw
	 Mn7h2EzjP+6JdgCtWxvFi14eMD3H5IER47idE9V9pA6ggmgGCiBJOGnJ1TZINdpFewpjb
	 82DAIxu4Hmzu9EWrrvV6ExsyWnk5NBeHIMTzD4xJoHOnukF2F8rpLoQ63aXgCZDL1+Iwe
	 seDfDSiuGGZE9eD6rlZRw+fF+7SJp9Dw1mNUjhYvUB8MQO88F/3GAvj9ScUV0X7YnIAV4
	 zICjr4S8Pg1hljg5guZcmaRDLHXktsj/9DXK0OddLtT9eJ8M8psRWZUcjnsJ4SSRu5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bvwgy8lj;
	arc=none smtp.remote-ip=209.85.214.172
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9090F606A32C
	for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 04:14:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9090F606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bvwgy8lj
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2e9d7791b00so5102745ad.0
        for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 20:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794975249; x=1795580049; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QqYVAbH+O5Ra0wuswn0xYA0NuJYo04JzgdWyvccojr8=;
        b=bvwgy8ljGMYFBI4Ygw0rFbgR0HHy3hEqTsLS9jrO4+33PKYhqXqnBsa55LGMTHZ5LN
         XJc/PVWeRn/u8qd0UHWg6NbTPsht7ffVqPBIK1JouIG0OdAj6zv5CfjvvwL9/tojCDl2
         wvHW54vXtCYf+c41J4YMeUKZCCC067IInN/vZ7L3gE65g2KXidx71QDuxZleeFjKcO+W
         pVu96oFSG1H04tTmve+dSWYLPw5CsTYNShc7BadfAfVkZ+3HbuDf+2JaJsMDup6VBKSf
         /mFSL3oXD/xvkyRvKHcJoFctXpXqyHlAz8DylwM0GIOHEjadcV4wplzCs6KJ1xn1zENy
         ZqNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794975249; x=1795580049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QqYVAbH+O5Ra0wuswn0xYA0NuJYo04JzgdWyvccojr8=;
        b=FCYG3Fhmq8LBVVzUljQdRKwSXrfUlxX5/p9kENEmehJvHRg4DvQXiKdLd2fXl9uu59
         eDXaeMOso864SJ4zu3zPJ5Ov7IoqIzQS0b9hdFQN8wWkMO7eZp08RgfLukxLqwq+gOAt
         tvlubQKhZNHcaiWLq2+0CMak56T76fdxU2tPzrWhwDTLB02HsVZqUwCD5S0TAcjfHAH+
         lGjmoqDhjxfswkQAVGJ6s2ac95Vb+syMUrho71i9iulIRUc6d6/7x2V+NfFkbvhdnCTo
         L8BJtYNS8WM2iVpWycUoNk0V/OFc76w5OW8Xjwwi1Z7NL9nPbyTbnwMmosCx3rUDyZPj
         ftjA==
X-Forwarded-Encrypted: i=1; AL+hErFSjbkeIzycqAEu4/CIcUmG9OldTV7M7z5ufIglhsUag1RXKGYd/qB3uv23LxfEiHPd3WL3F4NazSUcN9A=@vger.kernel.org
X-Gm-Message-State: APuU4Z/O301GNA19WHl6EWyQ2v9+lLKvsybj29fM6Ku6ZHcnADcL6R7V
	9IzAC00vKCNvLN6dmXiNVKVK7qdr4YJd1YuL+5DTFUGhHAT2skhvrV4o
X-Gm-Gg: AZFdTZdYH6kQg0eottHryUVbUVySpBF8a8H7H4RIwuwpOqm6G4icvB5H0pzDrpBuyhv
	x2Qfbj7rP4sva+VZXROzQC9R03obYg2emtVzlTfce2OQpWpEtnL79d1gYTnVr+EFTl9RR6hCXM1
	lpXAPt+WrhtFxqcTdwzZpf2aDXFHjL3ZvkXkAtNxaWYTey9xkNnGxoVt+fGWI1nNE5cNQrexWC7
	iwdYQPq6CcbXsMa7qkuEpY7iL61SWwVHYIFQmLYJHszIKZuW25Z/+GWG4EwGZNfH6TedJSgII7j
	naFm+0nKPiCdveMuD8U/sz2zMB6chkTfPMOjlSUeA7f9vuPn3nYbW/gIX/SohiUKInLkPV4gs+r
	Y8Mbd22TYwnB6l/EIWt0qz94SmPsA5IKAKkPWVxRoWlYoqlKMR6UKdwmiT8a33FP+qrR9VNPg8B
	V/2QQohKZuQnke/0KJtZlYUQu0oHVz24xAIem3SdxVRcyzj+hCNXUHqj6Ck5IXjDNMyjlpGejbA
	7TnYgyr0OFuDq5SQrLt0nDQwoS9r7S/oqGtqKtXsZAoI/wlCxWe8E2+0/BBbyI1deNL7C75xCOd
	Q68S9daq/7vH7hCuCdI5xw==
X-Received: by 2002:a17:902:c945:b0:2ed:56ee:af84 with SMTP id d9443c01a7336-2eff75693c0mr13558185ad.62.1794975248848;
        Tue, 17 Nov 2026 20:14:08 -0800 (PST)
Received: from gmail.com ([2407:cdc0:d002:0:188:253:12:32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff6214f4dsm5728685ad.43.2026.11.17.20.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 20:14:08 -0800 (PST)
From: Jia Jia <physicalmtea@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>,
	Jan Engelhardt <jengelh@inai.de>,
	Hannes Reinecke <hare@suse.de>,
	James Bottomley <James.Bottomley@suse.de>,
	Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jia Jia <physicalmtea@gmail.com>
Subject: [PATCH v2 3/8] scsi: target: reject a short SET TARGET PORT GROUPS list
Date: Wed, 18 Nov 2026 12:13:06 +0800
Message-Id: <20261118041311.19011-4-physicalmtea@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261118041311.19011-1-physicalmtea@gmail.com>
References: <20261118041311.19011-1-physicalmtea@gmail.com>
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SET TARGET PORT GROUPS has a four-byte header followed by four-byte
descriptors. target_emulate_set_target_port_groups() accepts any list
at least four bytes long, then walks a descriptor whenever bytes remain.
A five-byte list can therefore make get_unaligned_be16() read past the
parameter data.

Reject lists whose lengths are not multiples of four before walking
them or changing port group state.

KASAN reports:

  BUG: KASAN: use-after-free in target_emulate_set_target_port_groups+0x1dc/0x540 [target_core_mod]
  Read of size 2

  target_emulate_set_target_port_groups
  __target_execute_cmd
  target_execute_cmd
  vhost_scsi_write_pending
  transport_generic_new_cmd

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
---
 drivers/target/target_core_alua.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index c110914b7b78b..22b4c39748704 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -298,9 +298,9 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 	int alua_access_state, primary = 0, valid_states;
 	u16 tg_pt_id, rtpi;
 
-	if (cmd->data_length < 4) {
-		pr_warn("SET TARGET PORT GROUPS parameter list length %u too"
-			" small\n", cmd->data_length);
+	if (cmd->data_length < 4 || (cmd->data_length & 3)) {
+		pr_warn("SET TARGET PORT GROUPS invalid list length %u\n",
+			cmd->data_length);
 		return TCM_INVALID_PARAMETER_LIST;
 	}
 
