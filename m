Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B7537DAD7
	for <target-devel@vger.kernel.org>; Sun, 26 Jul 2026 14:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785077989; cv=none; b=AlgjsImogHhdAI93dxblGbN+Pi4z0/3VXa4X/o35kLUGQkuxIVBSSGDHGuaK/suaQH+vEJxzxb3h1BEVbO3wnAVFfW/jLSg1T5MsbkEFm3cPTMb6qdhJS2sXe5ZVnFOxkA8JlDg4oV7TP9q/p8BnyA0nrhTdIGDSFjewx6m7WbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785077989; c=relaxed/simple;
	bh=Z81Et9KQCb4svrySw3fAoBZgNyI7CjfEO+k/cqzuXbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgoroQuYAEQZWNVGiOI0KAw24yaLc/U1sPVC2ISLllOBL28MljqQ4Qx2Wi48IxgSiMMkfl06Eb85aJAQjcauPVivihQ6vsSOEZX/Pwe2uVEQpTq2c8yrg1rf1gOuL3LvvskMOD4EPHPi/8ikuPlQhAu93KMtBPtCSlm5nIYkoEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=qWkDcwVY; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="qWkDcwVY"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-84a2dcede83so2522646b3a.3
        for <target-devel@vger.kernel.org>; Sun, 26 Jul 2026 07:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785077988; x=1785682788; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FGDMCesZy1ft/61eesd79fseURXoeAeKC+nY8ZObiXg=;
        b=qWkDcwVYxTebIGWv7nPVUF4tEebuW+FWpoS46jnG+vEkA+r8UaSUjEXf+OKVaumf8U
         Up4L7YaeaCUXmHsUVIMlznxxykDArAUPbzdmcacr7fgOO5cLrEicjol1aZNKOyxz8J2W
         Fpm9+1zx1KN//2aTt+5clTBjwmkidGrnX92xei5jOhZ3K98y+DCmMr3+dzj98/lXHyaP
         k9XWT66Y3S//4LdUKiUEh/Js/rcs5hbO7nqzHbgmt6RNjKQ/YLpUhE8wd7/HCR1vogBW
         eLLaeh4UhDiKK9dy5dED7IqTgeuvqQeab2m3aqkkuyzVnxHR2bu4JR2gjwidteR70M8B
         b5aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785077988; x=1785682788;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FGDMCesZy1ft/61eesd79fseURXoeAeKC+nY8ZObiXg=;
        b=DGpFUlIbSKwexfvXpC95v1PzlhVu5lvIaT9uDwL+J5a46/rWiLd5fLy0u6ZuZ8xPTm
         WOTjRrdfahd8KfOuO5DztSQGxHWVhpt8UGGwusOItDFd+WiEex65tZfJLbKTitkXERB+
         TYtPTcZgt7NBTnmR9emGu5Hfmrm+JMxa3W22JqayC04dQKbaBB2mz1Ej0sb4HJRAQLbx
         FHyVjS6D/7rPpSpG1RBZEpDq6vYeQrBZQ2JP0xY4lR2c68YHnPeaWJDPgMxu3LzTjQlX
         KAFM77uV1B685CeH3rmSqIuUXq/hC/rG7ip78WqjN41ZRlE0hmf8U9THWSnSOqCx9CyD
         mALg==
X-Forwarded-Encrypted: i=1; AHgh+RogqPMKwLWHhO8Wri1oE5+3bdhc/kVXiAr41mGTaEaI2qvlX38q9mt1+VseXZQv2DY98uSBWx7WLWYowmE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVlTWIoPSV+2+WtfXHrKyV4pYViPnIaLTnLpXEVMJJAZMchzwB
	EpkK4YXwTzvHLyM3GiZz8weLlHH9Orw3lsJd9Rcu0SqL2CuGkk4VQNoRiZBlmRSlBa0=
X-Gm-Gg: AR+sD13yN1TkEPQ+TK1y9YsZEPProgVXQYoAjVNioNqSlfSYQGbw/pRruGxeVfgghSU
	2asllv0ssbmZZMVcKpPId6WaSTdh3bUYvvMzCB+/WbokKeJ5m/QLS9Kmw4C80bd5KjPTMjKaeK9
	Sr05k6OpGkhiQJ3sHKkup/S00dXQEkGcMIyawct50FLrHDkvqrmkp8Brq7IMq21Z7qwAI+KJTmO
	8GMS3k1hyVBR9tVrKfpXRQf1kIrxqm/O0GLR3b08Qf5r4Ay5jwnGneETXo5LPwqplW/d2ToZHm5
	A9xGE7wVZ7BJuuDF5Y9I7R3Jg6bLjyNMtBTRCRh5XD3mTUqibs/5elqXlRvvJuTKDgRjdVwzz2o
	lAsBwXH1TPF6BNwHoyMUNxFNVnGgXVZ/DRaElVPjkaAb3HtRpwh6KHY5AG8UvB2Yui1so7p1uI4
	FDthC15EqNH33uw6vhX7Un3+So
X-Received: by 2002:a05:6a00:6c95:b0:84a:2ec8:fac1 with SMTP id d2e1a72fcca58-84e595d8845mr4345226b3a.72.1785077987788;
        Sun, 26 Jul 2026 07:59:47 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:be9c:ea6b:29a7:6c78])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e5341d68asm1894803b3a.46.2026.07.26.07.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 07:59:46 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: michael.christie@oracle.com
Cc: martin.petersen@oracle.com,
	ddiss@suse.de,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v2] scsi: target: Fix NULL se_tpg dereference in target_complete()
Date: Sun, 26 Jul 2026 23:59:34 +0900
Message-ID: <20260726145934.933618-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <79ceea04-7fe3-48b2-91bc-48b208f10229@oracle.com>
References: <79ceea04-7fe3-48b2-91bc-48b208f10229@oracle.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 7/26/26 5:44 AM, Mike Christie wrote:
> I think we need to figure out how we got into this situation because we
> can't free the session while it's still in use.

You were right to ask.  The session is not being freed - it has not
finished being set up, and this patch is aimed at the wrong place.  I am
withdrawing it.

I instrumented transport_deregister_session() and
__transport_register_session() with a silent ring keyed on the
se_session pointer, and printed only from the cold NULL branch.  In a
login-churn workload that build recorded nine hits, and every one says
the same thing: the se_session had never passed
transport_deregister_session(); it had a matching
__transport_register_session() record; ktime_get_ns() taken at the read,
before any printk, is earlier than the timestamp taken at the top of
__transport_register_session() in every case; and conn->conn_state was
TARG_CONN_STATE_LOGGED_IN every time.

The window is in login, not teardown.  isert_put_login_tx() posts the
full-feature receive buffers and then sends the final Login Response;
iscsi_post_login_handler(), which calls __transport_register_session(),
only runs after that.  An initiator that sends a command as soon as it
sees the Login Response gets it received and completed against a session
whose se_tpg is still NULL.  The command reaches the backend because
transport_lookup_cmd_lun() does not need se_tpg on the mapped-LUN path -
it uses se_sess->se_node_acl, which iscsit sets much earlier in
iscsi_target_locate_portal().

iscsit's own RX thread is not exposed to this: it waits on
conn->rx_login_comp, which is completed at the end of
iscsi_post_login_handler(), after registration.  isert takes its PDUs
from the completion queue instead, and isert_recv_done() has no
connection-state check.

So the commit message on this patch is wrong.  It describes a
deregistration window that none of the nine observations involved.  I
described a mechanism I had not measured, and I will not do that again.

Guarding target_complete() is also the wrong shape.  In the same window
transport_lookup_cmd_lun() dereferences se_sess->se_tpg on the
virtual-LUN-0 fallback, so a command arriving before registration for an
unmapped LUN would fault there instead.

I have posted the isert fix to linux-rdma:

  Message-ID: <20260726144213.933544-1-yhlee@isslab.korea.ac.kr>
  https://lore.kernel.org/linux-rdma/20260726144213.933544-1-yhlee@isslab.korea.ac.kr/

It moves the isert_post_recvm() call into isert_get_rx_pdu(), which
iscsi_target_rx_thread() invokes after the same rx_login_comp wait, so
the buffers only become available once the session is registered.
Unpatched 9 of 10 runs oops, patched 0 of 10, run alternately in a
single session under KASAN with soft-RoCE.

Please drop this patch.

Best regards,
