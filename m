Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186874;
	b=DxcJRkHxR/VXdraCnMBw6oM9TJmMjzVaI6TgEt8Wvb07LL+9yj05FQEvFs8WamOTrF7T
	 Wn9UmCZbpF6K4Df6M4Q2fQZ5HdHpF79WECpCy1Tmd0sYA6vySi6P6LTQVWVnSW8FMglOU
	 ZLKxI4Xnconl6pj8tP4KF4fSmTEMCLjz37xjC4NYdfbZ0bDPM9WVGNsl3lej43MMc8cKh
	 i2an7KY+OKZAr+A0msU0s3HaIi/je/DBxp9jHXyvWeFF3jaeGptU/7ULtYuGZ5QMHRwza
	 rjLBpPf8KAMR3YzhNdlop3sHdnemasuBDHTnKM+38tmFw4t4NaQN8Qf/AfSJrcRe0Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186874;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=bUXTcWB2gCAchh7a7jLoo9myOcXMnzJqVzVHJAOHy7Y=;
	b=Nr1GPnkCRubydsd0m63RI5jQnG/xe93GxjWDAgjzF6SI6yzs6AFSFMzd1+da7voRj9Xx
	 /Lvn8BJxdeKdFyAjkIHR2IWote1iPXf2AQN0/3GpzSy80Vtu6CKGY0a2jhjqSZzLPJGWH
	 IAuTZ+29J/sFZp2mR2AZkpb1j2X46VMFCf2v1krYHRTzRuYvbbn+RRhsPzENYmrgD19Qs
	 cXCAez6+t6kqxcmdN95QUDNQAe/+Mt/C7is2crUVTQCx9ZX4yDLwFyJNdLRZ1ldy9iy8X
	 /qsB2JvCPBO0lgKmVqpfmzmqgMuKLKNWZUMbwC27Oxx0CPZFrDWqj90a01cCXZ/sryw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="q/876PqC";
	arc=none smtp.remote-ip=209.85.216.51
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7BE60A2613
	for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 15:01:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D7BE60A2613
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=q/876PqC
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3b3a914e4c8so604400a91.0
        for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 07:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186874; x=1795791674; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bUXTcWB2gCAchh7a7jLoo9myOcXMnzJqVzVHJAOHy7Y=;
        b=q/876PqCgLYg6tbOv1L4VfzQwB4XKk6YHc8mfdeFLsL9+h3VRZOktn7UEeU3ZaREoh
         Hb3uJN1RoTBHw/D97uK55OMHsY/wL4bSOIqZ6aELTKUAyQ7oXjzgMDILpd64vNt6iAfF
         CJNy6rNyIq1/00W1ExqDuhMNb9G0VYhEpT8S25B01H+c6csmZc5/Vt3Y+JgFGl6mP2Cu
         JE9Fw6tqlyzuNcg7MnrqfSP3vAlE2NjuANuSVpg/cMYetY5RlHzhuZhg70Rygt8FXL7I
         Hns05w27Jj8nTy7+6t2IBjjDTtmlIyixFwdjeswnu/0R5ccN5//dYv0qd9Occ673oOjZ
         KiwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186874; x=1795791674;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bUXTcWB2gCAchh7a7jLoo9myOcXMnzJqVzVHJAOHy7Y=;
        b=wvOzmp+KDgHRNaHFpFCP6yeKr8MZpvc88jdo79Uyy7vaagHkcuq+WgZjO7L02uALKM
         rJP4MQMRz+kVGakfi+BbhxzOpLXzUn7gpQ+6rvaVhzgQGKRDUTzNmjqToN4a8ha8ns4N
         ik7N8U/3cxByYswjbV/WNnM1caa6/Zm6vCReYVJF4RZ8HyACKS64bLX00bcmYykAH1ao
         r22DTMsVICfr5PlgeYt5XTTNRWBIcKCrKxrMU9n5cvE+byVHyfOOKnq3yOaBDg5jEAJi
         +FHgc01nCraRzpA9pAB++G8yCJdhvXKb0Gqn1LnNyCgD1QFCG0i+oboKVcaEwO4Q2tdG
         SLkw==
X-Forwarded-Encrypted: i=1; AL+hErF/v5gn3Lh6RB2xo2TkfD1jfGSODC7/gEka+1iLHlg77OmxGvhjujz7e8Hos8y/NTulKWxY9M7Pk+QY+Lo=@vger.kernel.org
X-Gm-Message-State: APuU4Z8CAnIL5E5iuGlOQd44NaJVaiZCyYjPyHi+5SrWju+iBZ2DXWgn
	pNbhALeXpwokAbQGzCLCLHtannYsD9/ZyDoha/u9xWtB+qeopkCXg8LPW8ly0d/xGss=
X-Gm-Gg: AZFdTZdbwVG+sM2HuoGysyt8c4doB5ARXgqPy+UgbYBmnVoK33ayGb4u8QZyI9PTO+4
	V/IZ5/F+o6895eQzyygujIqTPCsZ1iJkd3BG/hCNil0aMPePfGxmtM3MjLcW8KBExSaJQHKF5sH
	kLMSTD+4EfduxkfCNkKDtXlxO3YEzSIHdfImbZpOQZWX8XHBSpUzZ1iA5p96vsyAGVEIp7qcRKW
	VFWn/U7xajyGS87XZg4NE/4tCqervM2V3uoGM7WKELa4ly0GAzMltvAakOcO1S4Mp9GMiMDSMjY
	CNzTd4kJ6iYG5fd8SfzwbnbarPmLm/AibRttrnuadHHqMXr0IApVaOoYB5fCyqJXddpCMykNqMG
	sySQAuJGwFSub+FX/z1s54nkXCT9oSfOTbdbg4I0oceCxVkh4uzUdw6JCVXyeZ6yxDU3ssZMh1h
	z1m6MFvw5z7ewu7usZbkRRhBoT3zkgFLR40HPlNQVkH1qktDPtHqBw9Z0GPmsEuKWAIqp2XkeCk
	L6CMbcADhkQBt/L+mkP57Rb34zMO2/9PZUbuqrHM7qfzEPDoTO5dv/0UJMwRbRdRbUCOL8Gk+dg
	th0r5WywORJzaccTCj0MEkdh25e35bCkHFa5NZaWKsdpGEwKhZ2Sghbuzu8LrtXBuzHjXZcx7Wk
	/ZwNuq7ahx5OFGsBVmQOzhdjnL8XvLG6zhw5uQRgD5C0hbUx5USlLBVyjmw==
X-Received: by 2002:a17:90b:1801:b0:3b3:ffa8:6bc5 with SMTP id 98e67ed59e1d1-3b41c9823cemr3026706a91.60.1795186873588;
        Fri, 20 Nov 2026 07:01:13 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b40578d771sm7768016a91.1.2026.11.20.07.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:01:13 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: ram.vegesna@broadcom.com
Cc: dwagner@suse.de,
	mkp@kernel.org,
	jsmart2021@gmail.com,
	hare@suse.de,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: efct: hold a node reference across asynchronous session setup
Date: Sat, 21 Nov 2026 00:01:08 +0900
Message-ID: <20261120150108.3128312-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261021022209.2580332-1-yhlee@isslab.korea.ac.kr>
References: <20261021022209.2580332-1-yhlee@isslab.korea.ac.kr>
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

On Wed, Oct 21, 2026 at 11:22:09AM +0900, Yehyeong Lee wrote:
> efct_scsi_new_initiator() hands a bare struct efc_node pointer to lio_wq
> and returns EFC_SCSI_CALL_ASYNC, so the node state machine keeps running
> while efct_lio_setup_session() is still queued. The work item then
> dereferences that pointer on both sides of a sleeping call.
> efct_get_vport_tpg() reads node->nport before target_setup_session(),
> efct_session_cb() reads it from inside that call, and node->tgt_node is

This is superseded by v3:
  https://lore.kernel.org/all/20261021142818.2782104-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
