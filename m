Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795172125;
	b=SmYeTeRdTjUqD2YIo6iN8ULco6wc4d9YxcueqMM0l0oKEbRgMSMU75C3myMwdjdOSK0N
	 KTtP/nFG05KLsY5oufwG3MWfVGGd5xHO3MzrStpBxday1zzq+o14vBK1xho7UWEpaqRvo
	 mxOORKI0wTS8ZG+MqxWJW/vDOyJcvgov1yJO8avp3QaIAyoRtLZFvk0Z/MNQVABJ9V/7C
	 B5J6pn+K3A2BEsjYdD71wLFeT332ruVz8Y0YMCJw+cRFKM+Q7Cijeok/va8b0hUIBXWiL
	 Sdfz10xI2sa5cdYfTpjQmizH+iH87wC1S/IIrWZKnne5ZJ/kVb8VaYP77PVcAQbyH8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795172125;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=bLcMDaVf3ij0ZSaF2zMGac0vrTlfz0+kPwjMSXMIj5U=;
	b=2LjgPf6KKfd954VpdbdKc4lwbGrwY9H1Yj6ZmwBGnfXQP/X1Jb+Fq5J+7Gyak9ssCzzl
	 C2uBQRxx8ROTnvstqDFqw96tkhLKZcMLydleouWr7aaNbBUqlwsJrJBOgYxb6YGLIhKE5
	 a/cZAposzXr5KbzJQ8hUQui0BjeyGnSarTru8voYYwuQFbFsGRLqotRGtiMAFRm0/b5Ob
	 iA9rNwUkUPAYQuG5CMVnTrYoe1ofKhgbj2D2UXJcsaT/Mjcl+E1lzLn2fpqjSkuvBXg6A
	 ZB2gooaJAoeWPbNQiKMhdpwOupUDup74akRg68TPQvgLD6ou3kI+9BuX5y7WULIvluw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ye2Uw0Ba;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6261606A320;
	Fri, 20 Nov 2026 10:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ye2Uw0Ba
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224B91F000C4;
	Fri, 20 Nov 2026 10:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795172124;
	bh=bLcMDaVf3ij0ZSaF2zMGac0vrTlfz0+kPwjMSXMIj5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ye2Uw0BaRJIp043gaYaatqhZcquHMIrhJuynKF97QNz+Ch42NO2pqrLTPNjg3fDfm
	 MZQ7CncA6i3012fas8Nf+LNGld+EmAhejvbXF7JJCFFKPnkniqj+9orq1lmb7WOMd6
	 y9nELxsav1QFC9sDf/zomNaXkKhcUQmt+LB5HJzs=
Date: Fri, 20 Nov 2026 11:55:22 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: nkapron@google.com, linux-usb@vger.kernel.org,
	Thinh.Nguyen@synopsys.com, bigeasy@linutronix.de,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	benquike@gmail.com
Subject: Re: [PATCH v8 2/4] usb: gadget: f_tcm: zero the CBW buffer the
 status path sends
Message-ID: <2026112008-parakeet-unblessed-17ed@gregkh>
References: <20261118124005.2428068-1-yhlee@isslab.korea.ac.kr>
 <20261118124005.2428068-3-yhlee@isslab.korea.ac.kr>
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118124005.2428068-3-yhlee@isslab.korea.ac.kr>

On Wed, Nov 18, 2026 at 09:40:03PM +0900, Yehyeong Lee wrote:
> bot_prepare_reqs() allocates fu->cmd[0].buf with kmalloc(), one endpoint
> maxpacket in size, and the only thing ever written into it is the 31-byte
> CBW the host sends.  The rest is never initialised.
> 
> When a command is rejected before its data stage, bot_send_bad_status()
> points the status request at that same buffer and queues it to the IN
> endpoint for a read, and bot_err_compl() re-queues it until the length the
> host declared in the CBW is satisfied.  So the host gets the buffer's
> contents back, a maxpacket at a time, for as long a transfer as it asked
> for, and whatever lies past the CBW it never wrote.
> 
> Allocate it with kzalloc().
> 
> On a dummy_hcd gadget with a 512-byte bulk maxpacket, a rejected IN
> command declaring 4096 bytes returns 4096 bytes to the host, of which 72
> are non-zero and begin with the previous CBW's "USBC" signature.  The
> part no CBW ever writes read back as zero there, both before and after
> this patch, so what that buffer held beforehand was not observed; what
> the test does show is that the host is handed a buffer it only ever
> wrote 31 bytes of.
> 
> Hui Peng's multi-driver fix of 2026-09-19 zeroed this buffer too; the
> reviewer asked for it to be split per driver and it was not applied.

Why is this line in the changelog?  It shouldn't be.
