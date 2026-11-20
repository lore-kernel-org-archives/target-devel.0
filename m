Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190912;
	b=DyGnLXARZIfj12wcXNkfyxYaHfR2PAKgs5TcJjRtcsbmkEuBFUDmTYX+GCeKfO0N8IYw
	 70VLzBXm7mu4EbGm0xt51tnQJhHnj7euLmWvAbZi/1prLQS1LLEzDyQq3Rbz3a8CAMw2w
	 IgwXzMm/083eN7eoIlxP76AffkTdIie5bYZiOEAIh340NVMa+puNpbHy1FeO9attSvXaR
	 i757FgKoaGTKo5D3Q6FoVe2aUMcI1kUawtKfzkWJgfdW9M5dBXu6pJw/Kevc1CD+0N1Rd
	 9Cus8dlhk0B3mzGhoIQx9rip+1a8lzBjtdobidBPNvvFd4oGJszxeiP33UF4KqOMFOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190912;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=KJHdeXgb+8oRA+Qq0eNkR56itfHtyKGNVrXS9DvLfB0=;
	b=jiAYEOpgGd0RksqXWAeTKsFv0w1RdI8/grOb2UPlXPYBDwRNLNDyy5i89mgidysRCnWt
	 yeGEF7ZQ5nHmWyWi75QEzEuzuIaEKFy38Na2vRi6l2YbGmLkzwIPsXsJJydp6Z2PqXH0Q
	 cBiedMN/JJcTLItO/Svfeb+ZOdD5u+ZJX51J7AKA8OnnvVfg+Tu2VWt7Ion+pbRZrBsXh
	 J1aM5ygbo4yLPdmr1Bglk72quk46nhtGF+qIIR3JzpKk/5Tf3V/0weuik0DbxGTqw9nQ2
	 b5QEUZsIoNZzfr7SAVwj+NZwGvdPuN57f77cOxPhD9nXIwf+8iugWDDfk8y0a3xbhbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=cuUyZqwV;
	arc=none smtp.remote-ip=209.85.210.176
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF39606A320
	for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 16:08:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1BF39606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=cuUyZqwV
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8a06cc097c7so840266b3a.0
        for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 08:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795190911; x=1795795711; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KJHdeXgb+8oRA+Qq0eNkR56itfHtyKGNVrXS9DvLfB0=;
        b=cuUyZqwVRtfVW7vE8lx1+x9WioLQ1b28O+I6Z/BeSWzgR8e8P2++UfLkZbbFEXxhE5
         S9NgC3FWjt+S16UPYcpgqt9a2wsg1sIrPXExX7Pgc9SEXoJgqFgn9stwySib04t8Em2D
         PmIWviqwi4pjOiQY/nhhtlChPjSgnLjE3w3f/ev2qG/mCHI8XUo6A3qxHXtDnq8Q1K32
         JI5LtL342JitpqNhVxqSGyLQ77EOPORqHW0U/sMIYhic1haSzHG3OQq9qnFcTtQOwSWr
         dX0D2j8+Etjgkvj8ZnQHsSBzOZxQRA/1TFYpZ2vPe73DuQo3KcSzvtXXC5iqTpyIQ64o
         X2jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795190911; x=1795795711;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KJHdeXgb+8oRA+Qq0eNkR56itfHtyKGNVrXS9DvLfB0=;
        b=1+1/pwhLYsRrFYdT4bEqRjS5nrfW3FVETQ9a4jeCzjW2s3AHL+YmNoQD5zTzVg4JCr
         HWHLnMEEBkr/Y5F/xADvMB2p/UBDRaQugV+xOpY9Lv3oGbnKCMF2DTTqQd/SuNYtSjyI
         +tuedshaYDjRzyL3BCzsVIm0GTatzNOFJBsbjfrZIxj7mmecLWjzsVuN8tQq4fKeCgEi
         3ZetvLpEUq6QbzNSo7Y7uBbKd9JfDskV4XD6D114SYZqsROCKrcdaNP0vJhHicv8XetY
         d75adhHA9J6CgjW9reZzTxuopG9RiK++uKj6JFxzU7N2W4EQ1XBm+UHWZPrg4NZozpBK
         1uPA==
X-Forwarded-Encrypted: i=1; AL+hErFUupbPmcGeSz//aiuuZspOH9ORUK4wjef1mvRONLlGdzr+fZ/puq8v7D5vOktfX1uFLjpp2h4Caa8rgZY=@vger.kernel.org
X-Gm-Message-State: APuU4Z9f++qvGyHBxao1bukKqcvJS+Z1snEI3jPTGSDk7u8BsmZHZ/33
	3W7itVQexmYKkFaFWCj7nwRJemtVS94oas/73KXEaWP3KdgwEuM5nvCDwmSm40QgrwA=
X-Gm-Gg: AYBFou0KyyZJghE6TMZUC0PH5s0dOF+RpS3SCtk/hMHLx8Nq2pTcEkoQNpQ4chNuTN4
	UmwE9SpIe77aosew/hrG6Vr9PojEe26PYLJ5bt19Gm8V/CGu5Ki7wizkfDndH0Nj/jyIVv5XH2D
	muBewF5V25Pt4Ak47Ew11qkfSD8P1dkXvyeulwZ9bmDpTpdGxX3NkPnr0UC6Yne1frfiBLXW/+h
	Fnqicrr/rnHOeYpVdQ7iIYg2ORG6NNnXla1u1O39NCyxdxXBxhPqtoumF5dQj1D0/tizHk0LLBD
	RzUsM0xQuGHNa9w9PyjelroUA9fu7PD/0NPoHzDImnxtqHXNUAjxxayDh6VRmhkT4vnq+08GibJ
	fxWKtNi9WTqEiweoisopS+fNp8WTbzNh1xBZ33y9UV6933LI7Vqe7AuXb9kfz1HhP379QQOCycA
	hcrChfIuJn/gxe+gva9BQHmaQnTpe8KXIcKOSF/YuXpmS2JzWOBHyrxZRaa24LjbCQdfePZ8CP3
	3Ula22AS75iz7g9AMOegpNjkUX0tHM3SU/d342ol2x2ScaWSG5fUl1U+YWCMe+5aVh/D5H38Cwf
	ZYmqp6DKOZUFPMuNkSqrQK2hyfWalXy2aY4IxDuUdcnunEC/C2xLX5nhgMWBkU5X7/dh6D7ynsP
	N7/Yr8LsS9+0K+76Waj21db5Hf6KFvn+p+AT6
X-Received: by 2002:a05:6a20:7a9a:b0:3fa:5900:6e44 with SMTP id adf61e73a8af0-40205f1edc5mr1443887637.52.1795190911331;
        Fri, 20 Nov 2026 08:08:31 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6cea770asm1552917a12.3.2026.11.20.08.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 08:08:31 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org,
	nkapron@google.com,
	linux-usb@vger.kernel.org
Cc: Thinh.Nguyen@synopsys.com,
	bigeasy@linutronix.de,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lgs201920130244@gmail.com
Subject: Re: [PATCH] usb: gadget: f_tcm: do not dequeue UAS stream requests in BOT mode
Date: Sat, 21 Nov 2026 01:08:25 +0900
Message-ID: <20261120160825.3219262-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <2026112031-sandlot-idealness-df6f@gregkh>
References: <20261120113956.3071640-1-yhlee@isslab.korea.ac.kr> <2026112031-sandlot-idealness-df6f@gregkh>
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

On Fri, Nov 20, 2026 at 02:42:56PM +0100, Greg KH wrote:
> On Fri, Nov 20, 2026 at 08:39:56PM +0900, Yehyeong Lee wrote:
> > @@ -1614,6 +1614,10 @@ static void usbg_aborted_task(struct se_cmd *se_cmd)
> >  	struct uas_stream *stream = &fu->stream[se_cmd->map_tag];
> >  	int ret = 0;
> >
> > +	/* the stream requests exist only in UAS mode */
> > +	if (!(fu->flags & USBG_IS_UAS))
> > +		return;
> > +
> >  	if (stream->req_out->status == -EINPROGRESS)
> >  		ret = usb_ep_dequeue(fu->ep_out, stream->req_out);
>
> What prevents the flags from changing right after you read them?

Nothing does.  The same teardown that clears fu->flags also frees the
stream requests, from the set_alt work or from .disable(), without
waiting for the commands the target core still holds.  So the test is
wrong, not just racy: the host can take the UAS alternate setting away
between the test and the dequeue.

v2 drops the test and puts the requests under a lock, so .aborted_task()
either dequeues a live request or finds none:
  https://lore.kernel.org/all/20261120160616.3219043-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
