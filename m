Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795195728;
	b=OCGRYXnqzcs+AWlFBd6Fh/kw/mjmGX2hmHkiz/WTc93kbfPQSwbVh9v61vAtSy8RnLqA
	 Gh8RWClw9U70hFZpO3JmrjvEKBXnO2cWT9YrbQmbtQmJjxIX2+k4jgu1nbt8DU4GKAC7c
	 PFA0vYEEQXcookMkIoYzvd01+DwcH5zdW/Gfd5sD3GXiO4SxLaY3QDbAu6Tjbt+rKrr8t
	 iWbajg8TpE8b3h1UQPc4MoJGKYF6lcnQ9bo1oRh1stx7m7I5a1IwxtExEG/Q0eo+VjIJg
	 rDNr4I3/DFj9LFtF1cgN0wsPNZ7kkhpR8Me3oj14A1H6htE2NWRWqmSRvkt5eWdA6QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795195728;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xxYJksBoX0oLarGiBWELphq92MylUpFS9PsbMM1zZeE=;
	b=3XmGsg+8DscsbakXD1+6paL4G4KOtidw3/xltxC71XbaW/yRvO1vZh5Tlzm/cybtF/CE
	 TvHM+4EdIrm0uo8dknGLp2cNNu9z5jdxDtK8v+hqrQ4qEIFKNdm55cFfuICJb/zLmNMeW
	 zZlkQ6CLRYuptg1UVtKWn6pX6N3W717pEcG5RHXEngaiaG3ud6RBbwbuICUSVBDQ9NkJQ
	 0ZKedm1N4nJ5bgX62bIPYGq6y36IoH6oIEkJatpout9fh2PXYZoiLOnkf15TtKa9M02wo
	 qBGLjqdRTSnIGvllYuWJthKZg6MhUxF5VoGdMlBpsi+T8lFyGlsHIw6eIcgUCYAmpbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Z5jqe+ct;
	arc=none smtp.remote-ip=209.85.210.171
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C021606A334
	for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 17:28:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C021606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Z5jqe+ct
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8b5a6f2f27fso581022b3a.3
        for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 09:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795195727; x=1795800527; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xxYJksBoX0oLarGiBWELphq92MylUpFS9PsbMM1zZeE=;
        b=Z5jqe+ct7rqVEZunLyzcRBFtUcB1PaPmFayXQj80bxlnQ7nuLHz1OnJcJ9g/Aure4R
         FaAwLsrx8PBE2Jxv/2G945qIWvKjujkadkVip6lw+QDi59Tv8zklpOtm88hYJewmggn4
         glxT42F3oomoyu4zhx9fkoHRhUPmEBYE/szYJYz6ByUHqvjn0PlRLKy3GespQy1Nbubd
         3+Bgq3kKEMg+2r+KY//L27oak23aliNCMY80QJs4T4YvGguFKweFrQzs4/iMdvCxvhjJ
         RG8VZqk7+IIFZUQMsw9uCaDhmB+Z1F1NeYsgHfy9erJMOPOlgALht/KD9sluBxjeFXE8
         iLtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795195727; x=1795800527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xxYJksBoX0oLarGiBWELphq92MylUpFS9PsbMM1zZeE=;
        b=bnzUXJHrKWH3JR/XHqzkz7NhvJAYHEHHWRkV42YGO6QD0W+ZtfDzS15bNxq3nye8hv
         b5JNw/wHfyJebZdipRIW/IeaoTSFJj0UfQ1+Ly1dfqdbScK5Jls3Vs+fjOoC/k8ateWn
         JBL7zwX98vjbMVfwz8UzwG2h03upTInp+q8h9WeniWv0VQJq+rV6i6MRqIXz51pVSysg
         FiVPS+dL3UQyPTfi8LlCVp6Wk+ZHg10z9tonk9zTXqTo96y7JwdKRRgoA1JApeh5qbJ3
         14CqRLGKn1mXNRhV5IeYuH8XKsQGESCsfQBlaxszVEWq4iGpAymHWtlLhBSQB0kYnnPI
         586A==
X-Forwarded-Encrypted: i=1; AL+hErGOcVHOb35mCMfhkz4rs6CUHxK9GM1WhPJYCmlGE6yoqXLWcNnmB32LIoRfPT7++82nW37ADM/skj0L+NM=@vger.kernel.org
X-Gm-Message-State: APuU4Z999G8nzBUyazyMLdlz0ZFPF0iKsfdR6SUNOOcswQU7/Wppr5JM
	4BaPV7bSReJedsF3QLxyeFxPkIRPYpkm2whNecYjv+RXMNleuYdr3UV+oEVADVaqKYD3BiJDXbR
	Wuy4fIHw=
X-Gm-Gg: AYBFou3/6ra+WbrELs8OMeOqnmCEj6/S/4DnjdfxQgNaqSahot5tkuLfsQkVZUoTxOj
	/G0QI+Fs4FtVkCFdNkbj6jBIjp+dZxmrvcK+EBF27oONFbTyfP3ZiltsNjXK+sqBnQ1HRpezVb3
	Mjyt7ySrEJJ/qsN1wlmQ3fknRfha4RiHWkQWGNp4ye9OZuXNSDy9WP7BzSOMR5yFRe9X6Ag6Yr/
	KY+0CzqqmHCiHREFv/0Tov+9gUNb9cAWoBNPa4MYPUPLHsYAtnNVwvFESuzKMwq+MID0Mr8HWmP
	IG6VDcaM9ty3qUE2C4aBml7aat7n+12HI8p7gDuRo3FeI7i2LC93pa6aU+dYyOBk9xWxx42fHJG
	ULRHrHp/DrfSpyojIP9s+w60Rr/bsW0nez9TO7Z08+WNUGmJHgxl2lex0iU17KumC/YxFyADdUT
	bGzeOsLtk6yS2B0R91MUWOpKMg+VCGtkwowl0vDdq3peA1RVqUAzGBVzVt9ROYOjzNw6jFHC3DL
	n83PQZrvNRYpYK06O7BFaqxy47cJXB2IZQqKE4o7owu/+ycTpTI4WpY/bayqf+r2H4xv5kxuPjq
	kjfhGWkQilGoacdUmLp13dPkrhapaumcrphectQDv5hImaxFLwOQ1af9DSc/kq7Qf5gdbuc7Gu3
	LuiBDzm49OJKjyvvn/sS9C1QyDHI7J7f+WPyu+A==
X-Received: by 2002:a05:6a00:1989:b0:8b5:a9e0:3050 with SMTP id d2e1a72fcca58-8c8792c35e6mr4133537b3a.2.1795195726843;
        Fri, 20 Nov 2026 09:28:46 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87334890csm1867911b3a.33.2026.11.20.09.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 09:28:46 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org,
	nkapron@google.com,
	linux-usb@vger.kernel.org
Cc: Thinh.Nguyen@synopsys.com,
	bigeasy@linutronix.de,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	benquike@gmail.com
Subject: [PATCH v9 1/3] usb: gadget: f_tcm: zero the CBW buffer the status path sends
Date: Sat, 21 Nov 2026 02:28:27 +0900
Message-ID: <20261120172829.3286180-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261120172829.3286180-1-yhlee@isslab.korea.ac.kr>
References: <20261120172829.3286180-1-yhlee@isslab.korea.ac.kr>
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

bot_prepare_reqs() allocates fu->cmd[0].buf with kmalloc(), one endpoint
maxpacket in size, and the only thing ever written into it is the 31-byte
CBW the host sends.  The rest is never initialised.

When a command is rejected before its data stage, bot_send_bad_status()
points the status request at that same buffer and queues it to the IN
endpoint for a read, and bot_err_compl() re-queues it until the length the
host declared in the CBW is satisfied.  So the host gets the buffer's
contents back, a maxpacket at a time, for as long a transfer as it asked
for, and whatever lies past the CBW it never wrote.

Allocate it with kzalloc().

Fixes: c52661d60f63 ("usb-gadget: Initial merge of target module for UASP + BOT")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
v9: move the credit line and the Link out of the changelog (Greg).

The same change was part of Hui Peng's multi-driver patch of 2026-09-19,
which was asked to be split per driver and was not applied:

  https://lore.kernel.org/all/20260919223521.3890508-1-benquike@gmail.com/

On a dummy_hcd gadget with a 512-byte bulk maxpacket, a rejected IN
command declaring 4096 bytes returns 4096 bytes to the host, of which 72
are non-zero and begin with the previous CBW's "USBC" signature.  The part
no CBW ever writes read back as zero there, both before and after this
patch, so what that buffer held beforehand was not observed; what the test
does show is that the host is handed a buffer it only ever wrote 31 bytes
of.

 drivers/usb/gadget/function/f_tcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 3af28419a8bca9..22e57f14e938e7 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -330,7 +330,7 @@ static int bot_prepare_reqs(struct f_uas *fu)
 	fu->bot_status.req->complete = bot_status_complete;
 	fu->bot_status.csw.Signature = cpu_to_le32(US_BULK_CS_SIGN);
 
-	fu->cmd[0].buf = kmalloc(fu->ep_out->maxpacket, GFP_KERNEL);
+	fu->cmd[0].buf = kzalloc(fu->ep_out->maxpacket, GFP_KERNEL);
 	if (!fu->cmd[0].buf)
 		goto err_buf;
 
-- 
2.43.0

