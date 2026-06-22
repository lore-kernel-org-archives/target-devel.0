Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC26221FB6
	for <target-devel@vger.kernel.org>; Mon, 22 Jun 2026 05:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782107932; cv=pass; b=tEbwVo2RslaAidQVPcNlmkdJJSy2G7vOOvzrMlsysMoAtX+XEMAuFMJFBovAscsRLsaKQUFETMKzgd/vycr+XqTInVLqSPsrpHHgN2zqvgLx5ugWHgbEeoFjjsRMt1af9Qz3gV42VNfBEsVCnm+8HGOfqeevxxZHfJdholZgwAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782107932; c=relaxed/simple;
	bh=Wcxzxhq+BprBQkE0VNNsiEVGATBfaWcxIglQosrHna0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=KwpkzSYGPX2j4G91g9VqsgR1M1CmeWGMtEItksCvKckRMBWJpjFe3yb2CJBGdU+7uI1mESXseZmne6EmMhg1kGQ9lkhPCsb4T1zvPZwu7Y5yLTys5GngQh/TlCNvLHFk5VWtqoK3Ji3Lah1RzlvW1MazK3qgMaOBDiEdF/e1VqI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZeYLWe4z; arc=pass smtp.client-ip=74.125.224.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZeYLWe4z"
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-66043ecf6b3so3514650d50.0
        for <target-devel@vger.kernel.org>; Sun, 21 Jun 2026 22:58:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782107930; cv=none;
        d=google.com; s=arc-20240605;
        b=kk3VORbmPFjDKnsZ8N8d8h7Za7cwQMRhLwXdONpnD4iBmarBdgx3Fbo406yhApFGeP
         WSsP7YNVTwJZAVknG45hQ16W38i8MBsxa6RPmZLZse/TbHAv/ydCWzCLOknvfT62pu2x
         a/aLAnwVRiP1sEM0Pa0wahJyZlJZiEjZh+UIx85Fa+UfTJ22tFYVEt3pWYekHnbJp+As
         425klnOA5i2YisAJll0s65SX/yr/7Bq5gFAydej94GcveCTm7W6c5biPXD5vMPhWXzbW
         RpJ50SKBp85Y9k2vorR3Ull3ULEH7VLdRWUOhmBnk8IO5BHP6dTy0USwcXNLflcIHkRZ
         RUXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=LsBelM7ijqCXXiCQ8rS6cH5Qdku/Q3IO6bOLq6TP7FU=;
        fh=InBi338tRnccEAswk1LVACTNEIvmrs4oKQYyiwL3G5c=;
        b=ZAp6C8X8Y3/wFBF9qehtA7mq11psf9Qq+KCNve2YTtfSRXZazvT96NLaH5ylqbtQwj
         vt6JafAUG/mr9lH32gcYdnEcq66UHOEkW82nyC+FzZtHlffHDkz0elDmci2tb7iDSMqj
         nZ3Y24NvI8D2GdiK8Wbqx21UyCXs5xFdj8oCH4tY0fdLBgC6Ps7QICOl9uvWdCyMNmyW
         Rg++WKgITq5DeQlWWFNRZNFlOmV6eCeztzPOVDocr30IGR/KGwKAjCjiiErGU7xktQsr
         ZMDldp1FJ/bF6E1mF4oT28MIh3Lz48Y40xTSoaDQquJlXu6Cm4Z6nvk9MiFtFmATdYFD
         pMjA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782107930; x=1782712730; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LsBelM7ijqCXXiCQ8rS6cH5Qdku/Q3IO6bOLq6TP7FU=;
        b=ZeYLWe4zf1WELT6GAJoQ2rzcFGF4ahkQOMlVP5XSUaYBGhkHwMpf84BffO+1tK72RP
         OVf3wKbkz5rDjRQsAc5i/R+iX9iKUNKBrjZW6G0EUxJM1CwkRZZEK5m0GXYMVPBcoR57
         rzt7fZsBbz8DXUTTDlM6+BonviebzJIjUJkFULF4aYIiPUcVm/4NrnW3mzeAXuzgMYnW
         ea+SZsmWECBILrPd1Oa7qEFKVNIEGUtA3Wo3pZhQJdtep6CmHEfI/ojJzsHarIX+TELZ
         BMIyJV5E6rdBXtTMJdZfV+i0hlSeymO6WQMHubDuI0BpT8n/TtqZxzh5/e89sN3n8MUO
         mwww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782107930; x=1782712730;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LsBelM7ijqCXXiCQ8rS6cH5Qdku/Q3IO6bOLq6TP7FU=;
        b=XmL9yzjsiaZkid7Zm02m6wUL3Ao1LnbzArO4Mqk87nKl5mlweHDftpHaUxowoR3to7
         EaIXQmjfw7spzfWEaBfaxjf6eAP8a5zaGGDXIWKbyCQ52FJHc5Yy+qqy5tOWnqXeENSY
         p02vfUogLwO8rpJH0uCsPP9oNEiQEeT+fdS2d/SMOqMuocXBskZWm5P5lrc6B0zgvSUH
         v5RE2vb6FnDnjO02Q5EeCJMKdtFA5LAOCUHiZpADWDlFzXL04yhdzZnmG9cvqc47r7I7
         MuMp0sCLh3TZwB7Vembh+LmtVaECMOBQizA25oBSTz8wvKj+NkbgpDsARYtWrBTKMRE9
         1TOA==
X-Gm-Message-State: AOJu0YwV236qZpL0Yggdv+2T7fQzF9RNogQjSKisBnaebHn/l8NuTacJ
	DXfGHCiQB3kN+tpo1nmV8fyZV+yQBMJ0mU9vAbCVVk1hSsGVVLD1aKBvK8uBNaUNiH7PVugReya
	/k7ZP70QO2lsyjrmX/Y4MCo6JCr77UgGtiyr8
X-Gm-Gg: AfdE7clReDTceBIBmgOeENLwQo1/4w4r4HIX9O0VChgCnl/691JgoXDEhpQ3dZvovB0
	XxP3XM/3HZw0tm2ZVZ7N/O1e9jpeyahfUf9o2expsnI9wij9lmep8HDpSUJ/FhF1FyBHiUm4qJA
	3FyWkRYW9ZBr9TDLaSywu/D1Fiy9aP819LOjIYP8QVnmXgVlfcgeW669dR4X/JX76LuB56X/ji9
	dzKSw2Aqxh+ebOs0308PChAepDE8QMpXxKvRpzbLV4pQgV2rGPowAojMRNGCsUBxXbIdD1d6vsk
	MluOMivd7Q==
X-Received: by 2002:a05:690e:4091:b0:662:c730:e22f with SMTP id
 956f58d0204a3-663030c0f99mr10116813d50.26.1782107930641; Sun, 21 Jun 2026
 22:58:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Ginger <ginger.jzllee@gmail.com>
Date: Mon, 22 Jun 2026 13:58:39 +0800
X-Gm-Features: AVVi8CdV9sfPgNE-Q53GSN0TUJFDN_PySXblxgqY2m3iXlG-1fLYc5NcZ8JR8CQ
Message-ID: <CAGp+u1ZRiTdz0khkrm2ExJP=WpB3gSuNhF7WZ4mEkO151k29Tw@mail.gmail.com>
Subject: [bug report] Potential atomicity bug in drivers/target/sbp/sbp_target.c,
 between sbp_management_request_reconnect() and session_reconnect_expired()
To: bootc@bootc.net
Cc: target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Dear Linux kernel maintainers,

My research-based static analyzer found a potential atomicity bug
within the 'drivers/target/sbp' subsystem, more specifically, in
'drivers/target/sbp/sbp_target.c', where sbp_management_request_reconnect()
reads login->sess fields with the risk of null pointer dereference.

This potential issue is present as of git commit
eb3f4b7426cfd2b79d65b7d37155480b32259a11 of the mainline kernel.

The potential race is described below:

T0:
sbp_management_request_reconnect
  --> login = sbp_login_find_by_id(tpg, ...); [t0]
  --> if (login->sess->guid != guid) [t2]
        ....
  --> spin_lock_bh(&login->sess->lock)
  ...

T1:
session_reconnect_expired
   --> spin_lock_bh(&sess->lock);
   --> login->sess = NULL; [t1]
   --> list_move_tail(&login->link, &login_list); [t3]
   --> spin_unlock_bh(&sess->lock);

It is possible for t1 to occur before t2, i.e., the nullification of login->sess
happens before the usage in t2, causing null pointer dereference.

Regarding the potential concurrency of sbp_management_request_reconnect()
and session_reconnect_expired(), it is possible for 'sbp_mgt_agent_process()'
to be invoked with two requests leading to 'MANAGEMENT_ORB_FUNCTION_LOGIN'
and 'MANAGEMENT_ORB_FUNCTION_RECONNECT', chronologically.

Then, the maintenance work launched by 'sbp_management_request_login'
may still be
working and calling 'session_reconnect_expired()', while the second
request of reconnection
reaches the agent work.

Best regards,
Ginger
