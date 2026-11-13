Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.225.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794573426;
	b=xuxPgV1Vn9SaTLODjxWqg94DsaKne2gMmd+R6SB+45jNX1Q6IrYlMWyTHLGYGvCx+K9X
	 5T54GCXj6GItT8jrFLQ/aaXYHKNi9Tfu5/Q1VBXsCZZ0hjO3L/kK8TMdo/n5GS+c2aM6z
	 e2X5WQKD2bE3szVDshBk8MfA5A6chfeSoqMwSkliVNSf3atEKT1BXI5SZ774aoO0tUTEq
	 88zY2O5BL22rsw1sj9ENoIM86I8JdTyPrb8I7fNQbaeCDvcWHUYnZ57KAUoR0RBo/ucQ7
	 BT3+j+VIG1UPFt1IMLT8uAV/pCuhcJrlWwvawddQHO6oJq+XCePR2fH2gEDzq1cZr0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794573426;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=87/Ge5NhXdmtGpcXCLUvnqWpWEAxiW5M6eWOW+m4zUs=;
	b=2UvixUtkR7Q+UcpuHl/+wKA2B5msfOi01IOPLNXwFkNEve/SzA0ewYgOf5pe+Q3J7HSS
	 JH5xVTDsOI+1jWPJxtFljs0yntAFpkbQ3gsFBtRe2x9rF9R6/NESgY9Yygk/J9/D3oTY4
	 Dznramkhkt0xkghvbYzMwvkUynVnoMgfmsyq+EKCpuYz2GRUvPtk/wToKwxhXgeupBVdb
	 8MHvvarHnNPcfG6c5WYUyXdC7AQ8dRekTyF09tZIVBOfb3ewcTmk9ipJwvHJQ1hvQTFbB
	 aNrXyN1Km59GsJ8G/jHKmhyYFFBMPaYThEXWRJRqHDFxmzdphdme8Z9FEgKBwXdAPYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=n2XPHptJ;
	arc=none smtp.remote-ip=74.125.225.138
Received: from mail-wm2-f10.google.com (mail-wm2-f10.google.com [74.125.225.138])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E02606A33E
	for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 12:37:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2E02606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=n2XPHptJ
Received: by mail-wm2-f10.google.com with SMTP id 5b1f17b1804b1-4b886ebe069so3303825e9.1
        for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 04:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794573423; x=1795178223; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=87/Ge5NhXdmtGpcXCLUvnqWpWEAxiW5M6eWOW+m4zUs=;
        b=n2XPHptJWAiGnWBjuWK6g5NkFljgiKFcabC8Vn0J/U7Rs5oCxIs8ae//bm8icbKFtW
         GhaGag1Xoi7ZyXwdHESo4gzqQGVIFHJ4SWyDVffZrMrzihrR6J8Y41NroO1pUm4S3UEM
         GevRMV87lpSFNCzDE68IInZGbL5X+gYDk7IApotAPKeUo9xOfBbHGBSC5mcggp0KJBcK
         Nc+e1mR1SmgmgC0Frha4Bk72pKDTzd14yUseYASwtvG8qZfbG+gNn4GmoQhA8ODET64L
         X6SskqZIriPJvj35d5mhI8G8hobVKdLKjnxeG6bMHAYcCPTjUD9dRkaaJK3nWVTXV/IA
         bDIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794573423; x=1795178223;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=87/Ge5NhXdmtGpcXCLUvnqWpWEAxiW5M6eWOW+m4zUs=;
        b=Ur1DWAxhX5xFyAK2AKUjGK5sNFcX0uAq56bHZuTfHpDEmodxn+mZA+8xVu8GXLDoQs
         3o9oIX/1GJH+YSBx0NYv0L4OQ6Pb1II+Q8YM8Uc3qE5+kTfCjrbpKsf0BO5YkLTM+kPq
         VewDXEU+1AYwikq+o0CclEMLoVAUOCAeZf9TRgGbYSuNGmVs5HksJkvI5neb88EzTfX0
         sNe4ET6kLQ0CUGJxIee0nyWgsIcadcZ1AR8/qrBQxMJdiNKZaaHnFg/03hod8EkSdB6A
         bz0jVxqT0uEUA0bklRNDnpYPQHdvJBh4zvl7oNn1zwKtDIwC1zM3RDhXSY/UZ33juGPO
         c+1w==
X-Forwarded-Encrypted: i=1; AL+hErHeuOCn7CM1OBd9PWC+/BW6GA6JOy4XfRNa+Xa5fBqVCuAjhvYkVnj/JzOipFqvYzif7ldOt1Y3CDMxLrw=@vger.kernel.org
X-Gm-Message-State: APuU4Z/ghC8b7Ql4nbmPt3k3Pa9D3bNH7YbhCvo8ibYHVPhg47SGb9In
	bxKBnUmhVvXLR2EjhRc9Q2H45tyJGQi3bBvO3vLqn/soTq8wHZSmOcxsed1C1/eiIEa1
X-Gm-Gg: AYBFou3vnLjOwIMTVQnP24Vnf7gqTbvzfu6ncVYwFZQa1qWg7IQhB6xD0xBE3pMmCNk
	tfeNtr+SAZyE7v4LxjC8VNxrmK1mSMEDPjupikvH1ihPZAbGob01u8EeyJ8Gmb8NUSaPuG+fqNK
	YIhQSVUglP3wcg6k2AAPALTs7Oohkie3+4WRkiM15TCA8nxgNI/C/zqrbygdDWev2w4wxI/g8c4
	4ds7AkDi7+jjHfEUY3VX0vyY0ahdkXuh311miHaB9T6xbKzXQ+g9zN6dCAOgOt+bPgEj0w+nAnk
	01VduqA2FDFa5qh3TEcWqdmxc9dKKWzclU4QZhrJlWerx8s6pehHqAnxXgUBlVNqhyqZVecxS5O
	TcS7zs4mCfQPzwGbIt9veewtSc9hY/GmLq4g7WtrRHi4Ul91PIpiY0t15NNbbXy2SpVk0aZ7KaH
	X4NEz/p2tpeN0T3L0B1zrRCrgEvSGIXzVbfK8JJv6hPkfPRDKyrqJEi+CT93vSL+Xd8ruaE2jTl
	L5r4haypUxsnevvkmqHhnr772ufvypSaGK/6QKmL+ev5VNXcMPg5zORBoWAmmrjzhF/NAKdmcvh
	lPvzik7WyceLguJdSLx19sQV2/BGNMWeycFrP85UqwNo2Z2aXRVGTwr6LVgjCyxNEYG6WDhQGbO
	Fd8vv5yIa
X-Received: by 2002:a05:600c:b86:b0:4b5:d95c:2378 with SMTP id 5b1f17b1804b1-4bb55ac4030mr49782945e9.34.1794573423157;
        Fri, 13 Nov 2026 04:37:03 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb55af2901sm57437255e9.13.2026.11.13.04.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:37:02 -0800 (PST)
Message-ID: <f12140be54ffc4d1e8e4026f80c41c75cf5727e0.camel@amutable.com>
Subject: Re: [PATCH RFC 39/41] usb: gadget: f_mass_storage: refuse files on
 pseudo filesystems
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef
 Bacik	 <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, 	driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org,
 netdev@vger.kernel.org, 	fuse-devel@lists.linux.dev,
 linux-efi@vger.kernel.org, 	xen-devel@lists.xenproject.org,
 ocfs2-devel@lists.linux.dev, 	linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, 	linux-usb@vger.kernel.org, Amir Goldstein
 <amir73il@gmail.com>, 	linux-erofs@lists.ozlabs.org,
 linux-kselftest@vger.kernel.org
Date: Fri, 13 Nov 2026 13:36:59 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-39-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-39-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> fsg_lun_open() takes any regular file as the backing file of a LUN.
> The
> file-storage kthread then reads and writes it with kernel_read() and
> kernel_write() on behalf of the USB host. With a procfs or sysfs file
> behind a LUN the host gets to read and write kernel interfaces with
> kernel credentials. Refuse files on pseudo filesystems just like loop
> does.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0drivers/usb/gadget/function/storage_common.c | 5 +++++
> =C2=A01 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/usb/gadget/function/storage_common.c
> b/drivers/usb/gadget/function/storage_common.c
> index 75831f2c7abe..83683ade20c2 100644
> --- a/drivers/usb/gadget/function/storage_common.c
> +++ b/drivers/usb/gadget/function/storage_common.c
> @@ -211,6 +211,11 @@ int fsg_lun_open(struct fsg_lun *curlun, const
> char *filename)
> =C2=A0		goto out;
> =C2=A0	}
> =C2=A0
> +	if (file_is_pseudo(filp)) {
> +		LINFO(curlun, "file on a pseudo filesystem: %s\n",
> filename);
> +		goto out;
> +	}
> +
> =C2=A0	/*
> =C2=A0	 * If we can't read the file, it's no good.
> =C2=A0	 * If we can't write the file, use it read-only.
