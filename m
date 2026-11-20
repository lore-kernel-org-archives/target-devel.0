Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186716;
	b=XiJV0YtB7WdHcYrbb7xTfeHyDBw9v1cgbzYP9tWo/Q08gy2WeVvQaT8XQtkw/rk+f65X
	 UGse2SXJmIVo6t0aKc/JGhCfo0TBKtHhC5bPesZjnbVYEjsq+KCAD37HvyrDy0XLDYC9V
	 Hq4Sq3cq3nDE1c2H+UmYA1HVUVLA/l5doY244fQ17CDis/L1zSIWJ1HMY3DwDHlgQQifj
	 ieh2LtpdiiOFJEim3EQ3812B6l9DjNuD8xhdUJxvJf6HRAn9/yuZV/hnrFiqsIUKg/NI4
	 L33AmQJUoZGXekD8gxEKbL07J57i5fDn7GhCDcrt79deBLaeLON2bkbJL01v+DU6xPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186716;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=E6G3BuQHqwFY5tfzNRea1k3DGO2evCkbLdAqXG28pQs=;
	b=z8J/h/J1jM0tOvKXvbsB/7+EITOxudwOcJa/zeKQxZkUv4T9dT5RPBdOnsYnsjRHSaeY
	 30pmyACmirkSxh8ckxUBqOq0pwEAG7mMpCMxLrt9PI3xjG2396f2+DhMu0RLb6XKqg01R
	 EIB7vP2KhhdoNtHkli6v+wLYOLKjKXqXO0tp5HUSpVtvs9Lq0nMzqLtgtdnyMBAKb5yAW
	 aEoPJz7abQrmr2fJPRAFX7JuhM2ajTBA6kFEMcs5X8hya3XFOSQK4UzZu3AFSDcFzf/7V
	 8RnD/nMpiB+u+ypPF0WoFZqfCAuMWbRy2ZkqjzzKHsDorQdmk2MoTxNiqjBBRHZRrEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=d09wDq7X;
	arc=none smtp.remote-ip=209.85.214.169
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FC560A2612
	for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 14:58:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34FC560A2612
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=d09wDq7X
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2f0213202fdso5450785ad.3
        for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 06:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186715; x=1795791515; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=E6G3BuQHqwFY5tfzNRea1k3DGO2evCkbLdAqXG28pQs=;
        b=d09wDq7Xtf/yPNUSUJC1xtX71TCCcLQmg9nOZHtNRXySR/cTI9/Kjr1fu/DTA3OEo8
         7rFZYbsu/Ym/Ilmxw4l/Alq27fsy2InpNapNukXUJnHw0WRneub2rkK/wqWocYt6i2l8
         dFGn05K1Qh6MMOaor543IAdOKMwtiny4PzbkKeF1wRTJ+k5/tVZDrHzHvatlcO6sQswa
         4LaTt1OK8lbY5nofBw2A7hzMG0ubuqKS0rgOOxNa/3P8SoqfvarR18gdmqGp4cJesL/q
         IONyjPStAgcVuCgPfr3djILCQxsKUlr3wcih3buL4AjfDDmkixXm4TTW+mE1nhk9bXq5
         GEUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186715; x=1795791515;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E6G3BuQHqwFY5tfzNRea1k3DGO2evCkbLdAqXG28pQs=;
        b=Mu8beh4QHwWQuBRDsWxr0ljPzeDjY/lzobHKPWxK9YWyuD+HKTiHOdLXxr/enQJUG8
         hQ93bshc42UY3f0HrBxkJhKHAIgKjzIqTrI527Ffa/LNyexrlNNTtHLgMxgD4rduFTrX
         8ykn9LcR6DAg+BWKEFL48Bvs2J9K+ZnoPi98K7wU7cHSVn7T7hozUpS1YBwGVcB54i4z
         LV70QnAV/KvDnm4lJuRZyfgr8sDudMiQLl8oRvkjoxn3MyEW3QSTxNF1UlSRjN9pNLbX
         IHnl4Yfwxn858GLqBWwqHDM4dvLwvBjbKKqx794V1iuNfw4LZnUZ3pGYIRuyqYF6Anp7
         h70Q==
X-Forwarded-Encrypted: i=1; AL+hErEP77hvbbkctYUVoNFzX7yvWvljNHUfmuuh0eZsOSY1vWGCPYaOBohsQCA3KZOT0j0mHwUwC2R2YD6n6RM=@vger.kernel.org
X-Gm-Message-State: APuU4Z9w2w8hC7CRrNCkZ+5RHMz89ELHjF2KrFRGrSCOZHRStvJHKSWT
	jjyjimcDARwXDYCpmzfq+s0hHK9Dkbx3PCynAhJneR6SIOpnLzmGpNfK2Aijasn4dKE=
X-Gm-Gg: AZFdTZdw8Q+mq6J38kgFrkS86JyWkdeAxLWphZIutTI5puQZcTLuL03DYoBHovdVKoz
	Lrfs8sryGDRxJ0RMedwDl2cXQcWlBd+TO0YNxHCqIQUAIW7Wu5RoC6UEtWJGUvSSuTL2R107kzj
	WyoHubYBmEVPrEeM4fJy3pZJBEH3sizOEFuT6V/AZyRdxKJVUeyG7160dqOXnTeNWEND+qnjGDg
	sDP2jSJzd3XWrudnb2KC+2AFoQi66XWZoKb+51OlF6lLBNOOiU59ZeYjbtJx1xBHuSjGrAs6NxO
	GQ1k6wNk+yy7mzSzAWj87caBsmTb0iJLyQTT7EWVoeo3LQ1Fc3FykngtH4yl/hnH3b2R2NfGEEq
	17VaOW6Bp1b2fgPlB8tLeTqvoFDDjCWb+pj/wm/pF27whmMiyLaqCy04NLA8IAeQ6rO41Zj7u6s
	lxRH1pbZQL8TgBLBPe7Cl9fB1hSJlBE0ss6GazQMx8itG0p/tYjv1o7LO3EACsOi09YUkT6VUWz
	2nPXCXhz4xp/noDbhx6E3i/6+gx5sMfb7M7Sp17pkbD/VRtLpdqVIUlcSklgHJZVDTpecfi0rLL
	SUpcA/6wACHErjU+U3F5GaB0Y8DmUc+sgxR0qoiE15zHiYXCPWB5Gt6PA/k2e3xM2f/lg9txerk
	b87RS+NQ+eQmVpBAAuo55HHXCjDUPAd/zDdQ9Xk+UG6xTRUmQ4meydxhZCg==
X-Received: by 2002:a17:902:f551:b0:2f0:2ba0:3b9a with SMTP id d9443c01a7336-2f03f1bfc54mr34636435ad.38.1795186715512;
        Fri, 20 Nov 2026 06:58:35 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f10c9casm15616035ad.52.2026.11.20.06.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 06:58:35 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: martin.petersen@oracle.com
Cc: michael.christie@oracle.com,
	himanshu.madhani@oracle.com,
	ddiss@suse.de,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: Fix NULL se_tpg dereference in target_complete()
Date: Fri, 20 Nov 2026 23:58:29 +0900
Message-ID: <20261120145829.3127721-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260725084939.694403-1-yhlee@isslab.korea.ac.kr>
References: <20260725084939.694403-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Sat, Jul 25, 2026 at 05:49:39PM +0900, Yehyeong Lee wrote:
> Commit a47fa41381a0 ("scsi: target: Fix NULL dereference on XCOPY
> completion") guarded target_complete() against a NULL se_tpg_wwn, which the
> EXTENDED COPY worker hits because its global xcopy_pt_tpg carries no
> se_tpg_wwn.  target_complete() dereferences
> cmd->se_sess->se_tpg->se_tpg_wwn; that fix handled the innermost pointer.

This is superseded by v2:
  https://lore.kernel.org/all/20260725165818.769963-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
