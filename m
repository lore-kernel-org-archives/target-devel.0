Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186920;
	b=buNrF5mVhRcu0nIfH+h8XjealVZtMkJqVItGyhyOppTWY2LZ5UuL97gXFJ16sAUsisxu
	 3qE7oh/S9UvrsumI6EAy8iKs96JDXQMmIMGQL833qrG9YhJKW1dOUQBRA7mkJzVOmzxIV
	 Y7B8HoFWA//uQumvq1NgaUCMMLr7RjcelCBJvKtWeo5rlEGJA6He/dYToBHmZoZqb1wGW
	 +MJTrt4w+RMn/C3pyEEXCCwIbB21kEwfst5wEjKKzuafK6duH02I/z/fwZz9afytTtXqK
	 M1bVlYwfnElVaaFCcC9Bt+lc58TID2OTehlufN5QBTaOfn9i6dSLs98CbXowb8GzP9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186920;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=EQquq+i6TPhSReN9IjVRPVIB6xCEadhlzp/OpeuYVq4=;
	b=sxx9uTwOo80uPK7FU2TUVlwiJr15h62ZnF5+ZnmAnCWL7VlJl4uQv1QSHpZPxYZxiYiO
	 AX3CN2PS1UzdgaC0+R/Uq/DXWBNC8Gxd3i+1BfkH9TV4hUWRZ8lMEkmhkscxWrV4LofcS
	 JEukO9C9/bQl98GEuXpdXlExFLbgxSkXlZWOLBBYB7ejM2jI+ARjtB60KGxqgJSKbG8Xs
	 iwrYKIYXwJvv0udQziekeKSAaKGUJhtCyZ6sNLBSdO3HgWogi/IbUjs4fEHUVUMQuYzrt
	 D1Ig2QFD0ccRVMes0Jqh6tZ0AXSyqPV2YTS9bor1wR10U/o9aiRCcSZCBV9xFIGIMog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=V1muv4aO;
	arc=none smtp.remote-ip=209.85.215.172
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C03A606C84A
	for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 15:02:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C03A606C84A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=V1muv4aO
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cc758830601so776809a12.2
        for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 07:02:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186920; x=1795791720; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EQquq+i6TPhSReN9IjVRPVIB6xCEadhlzp/OpeuYVq4=;
        b=V1muv4aOu02L+yE4GAaHN7SP6R+7IjUh8YEh5nx82Yg5Xh8xNHmJDgjDfvfC/ucUjm
         cTr8PmTaextdDJKUU+q20INEYhzxAv8g3wboLhaDeINx8UCor5YAwwfK3r77RL79gQUL
         nvI9YZpWdyh4i1CUrh+3BxYlWTNXbRfdNSO/7PjTlU9qOGYrLTO1FJDWavGJgG5lbgQl
         86hOm/3Bj2KivYZhXFdAWXugZftf1SFw1aWrWS5Ft9/E+N4aUJJyvGimLbMVvTQ83pOD
         yL0DzPzHx9IrRc1eprEVMr9D5trEf9y2Nc0wwM69675ETUuocc7UKxOOAj6El/tge0l3
         aC6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186920; x=1795791720;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EQquq+i6TPhSReN9IjVRPVIB6xCEadhlzp/OpeuYVq4=;
        b=mlFe0pwfM4JrHgC45yV7r0q+o1PrNdKDUfey7WbG8vzHIHv66n6iIvie+S635KfYqT
         x+ajH9Bmv37q7cfIAjU9e48oK8+XnmQKpFk7PL7E5akX5xd2K+OUW/tXPJSH0n2J0Fl5
         uhEH6l31irwGX8xgZaEkoFfFtZM0kcAAsjNwO6giyguIP/5ify1ki7nR2GXvvSdRDJGI
         UoOL2NeXLOE9sYSvGIKg9Afua8rSrJdrfg4+eJdyzeR00+VqWYfX4b4oF4vLWN71DoYm
         chdWP5stZq21ENBsn/+n6RVF/Wm1i1RuGsty8Kuy/p9hXXjQ0TgZOV8UXLi0x7SwND97
         Vpig==
X-Forwarded-Encrypted: i=1; AL+hErFZlrotF/1RaCi9BPgskdyGrLm/K1rZomxfPpa215yzHte4+nPTO0O9a/pb9mzmKM68rRHSa7pys1Kp3oI=@vger.kernel.org
X-Gm-Message-State: APuU4Z9VHWqGJxHxwyrqUJaL1Iu5LWcrpShAddVuFOSXSj1arC3IavL4
	3BpDSHKtM1zzkiFXm3bZYDwv1jMntz3wqVM5MNC0yxaJA/mtoQENSPcE1Gpqz5kF1tg=
X-Gm-Gg: AYBFou3GW4FhFPCpfjknhtNrMaIsaLpu7ozFemsdqJX0HUNxoqVHQ8JUrNcHwCb3m0s
	lRBob3z5nk7JwIOUqNmRp8r0rEFfS680fwYcIhmVocAbbQgOMFOtcA85+IKTst4Klptx1eVyRt2
	BMEHSvXaDsIF3rw45vTdKUdhDJhlBtYtMvXORy/f1xMECHfarUvCs22SYNZ9MvXzHL8oAFoHha8
	CpfhkxenNdtpTXQ8I9WC3lc8r5r/Zd2WnJoOlcHVmyhXFf2QPLo1CbCEYSmaNdlQ963I7ByBQox
	8alkFGkJF8hBHGknDXlSs+D42w/opuK4poPyLSO3wQ1E0aSn3k9OC3W8Plr0h9qXqx9r99ztab6
	3ZBdsppJezSIwUE8UCUgmEjr7XXgSMmge9u4P7cAkuipSa89/1am3zc7Jgx73n24dHm/WV1+/Ju
	Qkjc0qxfjJWgqpA/GEDK46hCilfDfU0hP6vUU/fncaShX+CecPeQWaZSI3nLfNthzs3yFwSI3Da
	GRRgczFQ1pObMGyqPRbIuWTQ3fRVZvrdnukhJpASKFh24gbI7TqVn4OL2b5n2vvPGWM1Ex8STdO
	f62w2qEkbpUMuc7I7weKPHN5leDkChTAydRl2VbRr8pqP9qUTbUEn5LQq54DnVxMH7mQmxVpkGm
	4cU/z49GlgmIu2TYx2uzTzqrfw3aFG3J3XJXoMg==
X-Received: by 2002:a05:6a20:c887:b0:3ff:f20b:d2ec with SMTP id adf61e73a8af0-4014dd66078mr3640804637.52.1795186919522;
        Fri, 20 Nov 2026 07:01:59 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d06503dsm1398731a12.27.2026.11.20.07.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:01:59 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org,
	nkapron@google.com,
	linux-usb@vger.kernel.org
Cc: Thinh.Nguyen@synopsys.com,
	bigeasy@linutronix.de,
	target-devel@vger.kernel.org,
	sashiko-reviews@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	lgs201920130244@gmail.com
Subject: Re: [PATCH] usb: gadget: f_tcm: put the overlapped command's request back on ep_cmd
Date: Sat, 21 Nov 2026 00:01:53 +0900
Message-ID: <20261120150153.3128458-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-223285@kernel.org>
References: <20261119140641.2768465-1-yhlee@isslab.korea.ac.kr> <sashiko-outbox-223285@kernel.org>
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

On Thu, Nov 19, 2026 at 02:21:37PM +0000, sashiko-bot@kernel.org wrote:
> [Severity: Critical]
> This problem wasn't introduced by this patch, but can usbg_aborted_task()
> dereference a NULL stream->req_out pointer in Bulk-Only Transport (BOT)
> mode [1]?
>
> Aborting a task in BOT mode therefore causes a NULL pointer dereference and
> kernel panic.

Right, this is a real bug, but it needs a non-default setup.  With
emulate_tas at its default of 1 the core sends TASK ABORTED instead of
calling .aborted_task(), and a BOT session can't send a TMF itself.  So
it takes a LUN RESET from a second fabric sharing the backstore, with
emulate_tas set to 0.  It's an Oops in the target_completion worker, not
a panic.

Fixed in a separate patch:
  https://lore.kernel.org/all/20261120113956.3071640-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
