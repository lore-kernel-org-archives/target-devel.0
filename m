Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657339;
	b=yRrX+zMu+hzlvrxzMzvSg6s/g4YMHt5WNEhf/OD+kkWyE6q9PaSLabJe9lSpQ1iS+CeQ
	 8AW7iKepROAXx2mNyRQKf5wOGQ564iKMFeJUSJAYrmUQLGJ0ysKEcf2jNGKXrtKrgrvJf
	 KgFt9Raho2XhXa6cp40hK8uglUBCh7OwOpPioFoq3fBYypYVneoXWd1CPso8r7b4CEMnm
	 5NsjkoLMdXtbRrgkcWJFHB29l2rXfTqni76zx01q0JtoTnLdtmzrcpWIX5KVKmEKevZMu
	 BVEY2Wg+mm9QoeE60FEy1Mlbr2hMrvei8oboXpUTK1UTQ6c2T9dRj0g4PEIx9HJSS1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657339;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=nJvs09p7QWIuuw8YOzj5TR133+2IJ5+yRajckn/hsO0=;
	b=W64yzgFGMxpkjoMih2pSH0JelDLYrqEwFSjYEvYP9We0vQwCbupnTlYohG8tUt45wRVU
	 EXcx80F7sOQtdA4KmTiH+HMeewR0ITsVXwIHcUT8EIrH/YrvOXn7jXhEam/c7Qpho+kZR
	 LfudileOyeQ9UxgxaNEAl5vlLVTDPNNdIO0wt7K06+/Id+4wcr9C94dfcLvwNe7zM4S7U
	 SmT6RJE8UTp1i6Y9b2GyNrPN1BRwat51lWTzhOHJm0V/6ReZbSNlW3rVtoFmddp8m5Lh9
	 oA0ZClaI6fnsFvU+g+bx5mNvUx21U3SulOr06a0VbLbDJwA8Q1uqb17D373UJhzNj/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MrTBjpIE;
	arc=none smtp.remote-ip=209.85.208.45
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710EF606A338
	for <target-devel@vger.kernel.org>; Sat, 14 Nov 2026 11:55:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 710EF606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MrTBjpIE
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b577addee9so3416712a12.1
        for <target-devel@vger.kernel.org>; Sat, 14 Nov 2026 03:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794657337; x=1795262137; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nJvs09p7QWIuuw8YOzj5TR133+2IJ5+yRajckn/hsO0=;
        b=MrTBjpIEXzsSZaANjc7oExJhwGnF+j3pBQoJGLV3AozjECewWnT/dOn8PoCfUIeYGI
         mRgldWBhVoyoY4kjpOu/TkcCPMpetn8bMN74Irqnk0JnK5MAQS777TE3iVfENO0qNvUE
         8qb82pxhdLikkA/6tATGUpByZMee1vHTbdl6A6vtosorr3+hE9wD/mpuH76lS1WAZqyn
         nUdTyabyG8UAyWqGnpYJGfY62DgpvBldD5kNADP5MARyaYxmHHJYDsQkr6qVKrnaldzF
         KHIyaxdpU8Pcl80WjVwUUXXw+yU81KD0D8RdN7wE6Dhf//BzElFXAKq/AgQBu3vGzFII
         7JmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794657337; x=1795262137;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=nJvs09p7QWIuuw8YOzj5TR133+2IJ5+yRajckn/hsO0=;
        b=l+AKIiGOUegMxAwlKU3dBjZM6In18e5bBsdHr62lWUUo26y4GMYYgOj2BuIJMzXvfa
         D/qYHYcKzhwlHR7z5E6UQWKXXTkodYW1JYCaW8hf/vOGP8pC+dCpwP1yC7W8c60uQPf1
         QVyix02JnDA3uhCRaiuIGifYnk2rrR3JueMTQglihE5rFaTu2ds548MyhXC/p0IR7uGP
         eGHKV5c5TDPy69/P+LfZdmwljZKiYpGutadmQ/EO9RxL6u7GG00hz68MWaam1NAugGcn
         ZNkBQjsJXo9C1L1Qxqn1PWBRw6V2BhGxPd1RDk6FN6w8irSWOgu9USdS9yLtVIcBX3My
         GDDw==
X-Forwarded-Encrypted: i=1; AL+hErHf2FOW87f0+mV7CwiuoJAzSWBX78pH/qTapQrXzVe5igDo3zf5HocevLvXZimSCLsbts1YE4MLytmDzz0=@vger.kernel.org
X-Gm-Message-State: APuU4Z81C09FkF4WFQjasxXI3dyOjgRHelNiwBHr8Dcfb5uX83LVk9Th
	ppSvemoxaw+PLgzRyqriswuGZCO/Gk/OqIYGZRhSyHSkc37tosLj/s9i
X-Gm-Gg: AYBFou0qaLbG+s4GlHb4+Y+WXh3grGRDfggQqj9mTfKzuknVI0HfbfjXkjrF2Y54xk0
	PEOaHmEQUwI4pvOd2kED+jZNtCngmPGcjpZYHZJVKkitJeB7xRbRxk8/CCcLewnTLOjMSwt2KUS
	93wUa114wZHPx6kY9cuifoo9ghPITfVg3nfSAEW/HIm13VuGvalmI2Z5eHO44NtTYoaYSndbdVS
	98Ooao3T5XK7+U8RL0L5+HsTWrJfwUjv1ttQCzHYp22nUhYTlQNSFOVYCQCITpUKktv7iZqzrCZ
	MkJcVJsqvviuoDbdfKV4Uif5m4vormsha6LeDk92bCfoPyghRq0vks9qOZkKZZ3PEQXuSNNR3wd
	qMuBexwJw3uqrJWj77WUPBnq3vQXLXQKxRKhtxsAzN54HYnp7+tX9gSpemMc4NaSRVxUsU4sSey
	dBo6pUmlgyKZPcld5hEjkuyl/Ls3tdgY6NUpOPBxe1Ce57OcfneXlM2OfWOxoMasfzIRNQMFmIN
	/kSTx4PwhEb8StpfuWryPXdi07wRg6JVRtp4cbtm1x0JQ8wt1q/tfPIOUBRLuLEujUKXS9oGG0g
	fZGkJfucSgB3sT4Imru+yOSSc6jZ0YJwtMrV09QFlCAdSju23LPAM33ovzzOgc0A0zk200diErL
	l+hSID4bvlj4=
X-Received: by 2002:a17:907:3e10:b0:c40:231:6eab with SMTP id a640c23a62f3a-c5096370c31mr441592966b.16.1794657336589;
        Sat, 14 Nov 2026 03:55:36 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b41f44sm206223866b.31.2026.11.14.03.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 03:55:36 -0800 (PST)
Date: Sat, 14 Nov 2026 12:55:35 +0100
From: Amir Goldstein <amir73il@gmail.com>
To: Alexander Mikhalitsyn <alex@amutable.com>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org,
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 38/41] fuse: refuse files on pseudo filesystems as
 passthrough backing files
Message-ID: <avhMN39TECaur0sS@amir-ThinkPad-T480>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>
 <20261111151202.GA11391@lst.de>
 <fb1d72cf25d10a960da627f6d93a3e041820ed3a.camel@amutable.com>
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fb1d72cf25d10a960da627f6d93a3e041820ed3a.camel@amutable.com>

On Fri, Nov 13, 2026 at 11:25:57AM +0100, Alexander Mikhalitsyn wrote:
> Hi Christoph,
> 
> On Wed, 2026-11-11 at 16:12 +0100, Christoph Hellwig wrote:
> > I've seen setups where people use fuse to mediate access to sysfs
> > sysfs in odd ways.  No idea if that's still around, but if so, this
> > patch will break it.
> 
> 
> Oh, that's painful. Do they use backing files for that?
> It's a relatively new feature in FUSE...
> 

Very unlikely that they use FUSE passthrough and if they did
very unlikely that it would break their filesystem.

The API for fuse passthrough is that the server requests to setup a
backing file before open via ioctl and if ioctl fails (as this patch
does) then server falls back to non-passthrough open.

The ioctl can already fail for many reasons such as MAX_STACK_DEPTH on
procfs as the commit message says, so server needs to cope with the
fall back.

Thanks,
Amir.
