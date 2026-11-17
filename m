Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794903941;
	b=a63RTpG+6j5rff12KI9Vn6A51VGrTfbzBA4MSwjVF46X1H6oH8Fo8Kaqyw1ahMoeLYKN
	 noxSjcKOGaAFR6K29xxomt1OHlKzeuf+buLlZfUpJ+kLmOe0xsSU6gtSSj1X7iYh9viwm
	 Sz39MF7Kbz1BU3O1/kKF5IoQ1v3DXa+ZvsGml2mkT0+woYTPnzsWRvIBn9N3Jh1Fwv8wF
	 w6KxYG3WOLRLbW2FldY1TXbzYbdhVsV17TdZhfbbumynRFBnh2AFwC7HTklXTJfXol/z0
	 1jyaN5TNobJ0a5Teze6Lm6RKwukqpnMsv1TvIxPGlJ6dntp8dSLEVn0BrljkgmekADQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794903941;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=UGlayfD5Z/El6cdpm6ie0HDMH84kD107OWGXScU9uXE=;
	b=20DXq3fv/P8gPdyqUXYkcEpXYJFvWd1lntepu0hzdBqAejfy71KWtIhoBzrrZqwx25bJ
	 Rgdkw9U8fihqa+1B3cPQTil5ebJAhLbJ9VT/XubZ8Dwwm8JPa0sU1SeUSvqZRd/bASKmK
	 bLQqLJh6dzss6Gu6pSVYcWGBnMg4HkdFJQ8M58rWK5OmNIM5E5K++Vc5fKzInl5LOCHeF
	 NLRxcb8ayAc7p/0T3toC/3Dmxc6/eRZPcuqfA7w4SYhWWrKULCvqETOA/rpOfziM3EAVk
	 6ak08dwXninlTmNhGkhZ+8OJI00YpH4ST19cCWxDjbxbLFBRqZjhPfZ50UeLssa1gjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="QoCmkI1/";
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2E8606A339
	for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 08:25:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D2E8606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=QoCmkI1/
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48dee593f18so4521694f8f.3
        for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 00:25:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794903939; x=1795508739; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=UGlayfD5Z/El6cdpm6ie0HDMH84kD107OWGXScU9uXE=;
        b=QoCmkI1/XbLLMuB5pWQjj6w7lhYbbqiM96jQW+pj9RZ000aRRl9S7H2qSmbtORMNOo
         ePt1TXAWzVIR/TrMeI58Zu3n81XgIdPHavzyhyljr/3uEJYZwsW6Sg14gd450d308jE0
         RrvE2vSlthe4MhW9V05IsJzW8g0CM3u+nfQ1hkfntpYQW6a4z4zmXmxD0w/TiuzDbd7U
         U8xZ2FexNWbZhSQ3d3pA0tlH/f0MOfn4O69UeuIyRM8vQ/YXTKpGPDyGoQczoxEfoynP
         BDcwZppUf46pJGXZ+RH52kug0iZSl25eld2NGIqCa+XVs4XFwFr0CZI1pzljVyhbNHw0
         NmQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794903939; x=1795508739;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UGlayfD5Z/El6cdpm6ie0HDMH84kD107OWGXScU9uXE=;
        b=2baT6w8OKFiIptYTdLzjX5b/WpupitaV+ZA4wdNVh2FJpnRbmjVJ4LV4Pno6MSjse4
         Tf9y4icVao6nFzRtqIVgd0oV5PcVrOJYWyWN9CtO5CcXM3z13bHN1cPkMoP/5Lxziikh
         2b2mM5Uk4QvdmoiygBvaxdsVpm682ItwhGmbM96nx2UIuX9vSEFPPtMSq/gzL3U/KOcg
         /jTcyH49DyqA4+T98yM/ziOIfpKiIEEqfaOkjoA9j3bd1hwhZdzmr2nGyiL+QK24Nt0k
         bo7uEdC1lWZ4s35ISY+uxVRYOPVSm5BOadSFS2x+QYmtZ9qrlnuvGHdMtQ63ICI2NmP7
         Sgsg==
X-Forwarded-Encrypted: i=1; AL+hErH3yTcXywT4LBJ/o/pDnpM/haPJyO6ZUI9/t78IaoJnFj1r51g3TPJsfRRBBQhC/IZEwiZZZf3D1B/RO0w=@vger.kernel.org
X-Gm-Message-State: APuU4Z9z9Jd6mUmFR8CTjlJolAZc0SF61CCyxzzrN3XIZWYtwGV9cxim
	3VOu71/LVZFVRushK9BtsMc5AHk0mlwI1fMDXWjBeq+mUL4EgTSWNdFyY4Uo8uw1iw4t
X-Gm-Gg: AZFdTZf452fcnBvI0JBw8T1dcj9Wayesn9i8V7BVYHLsJ5/ScSMySb83+h0YimOUI6O
	Rv/MEqAj5fdKhBgZ2WD5/xXPNunl+iFZ+n1FM03KayCBSHyk9H40wpUxLAjH6biLzm5nxAcGXUN
	cly1FS6IR+JO284HIUQyjf973uPB0FPYPslqxhkX6BxHPolZpT25ZdqbWWj30Z3MVqootTf7Jc4
	OJ5kdPY3PsJcJ+OxWd+2QtEw6f6H8mUxf9V59tHIRCG4cu/mBVSmoCfbesAfZl0IpRDT6r8pxkI
	87qKwRX7onkKu+rwy7MOwFqLDauchttaZX5eDWb+gKrrwbhhPeAO0or5MzUW5LQ9QjJ90Vv16Yl
	9RROC3lFBkgt8JmQfRDVD8b5aNGHbcICLvroJo0JDxkQkUrVri0zQ+sXir6xJs+vmCzPcAzelNM
	F6h1dlp30JPJD28gIDqTz37jtincpKtCkDJnTSQhG7ILKOjwHGnPKnqKmBEJJmemqV4vWIhX6w3
	GT+ZMlZ7KHKowD5987gclJaKzTkfETb15KQO2yGufE3RHqjnRkNkZXcQKb54NYcxJexNMWHhDO5
	to3FreuJZltm4pvKZVhK4+/WJsql5SIgd0/VxCHpvJUZcpP2UD3fNya4ZlNXpFdPRNIOsxJ0dJK
	a8nmNLtcejq+DlEHX9iVPgQgT6uFRg1KlEWGBGvjcJzrbQnm+Qr3fjIEad9voYKNbpk6Df9fwjk
	ZpLw==
X-Received: by 2002:a05:6000:2084:b0:492:46e:d4ce with SMTP id ffacd0b85a97d-49c6fd932c8mr25238543f8f.13.1794903938925;
        Tue, 17 Nov 2026 00:25:38 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5ff2be55sm26907832f8f.28.2026.11.17.00.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:25:38 -0800 (PST)
Message-ID: <a9124bf1c858cef3e8ac06b1b2396dcb0e19e2a5.camel@amutable.com>
Subject: Re: [PATCH RFC v3 02/44] nvmet: check that the file backend
 supports ->{read,write}_iter
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
 linux-kselftest@vger.kernel.org, Chris Down	 <chris@chrisdown.name>
Date: Tue, 17 Nov 2026 09:25:36 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-2-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-2-8cbbea1cf34f@kernel.org>
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

On Mon, 2026-11-16 at 12:04 +0100, Christian Brauner wrote:
> The file backend calls ->read_iter() and ->write_iter() of the
> backing
> file directly but never checks that they exist. Everything that isn't
> a
> block device ends up in the file backend. So a namespace pointing to
> a
> file without them calls a NULL pointer on its first I/O. Only
> buffered_io=3D1 gets that far as the O_DIRECT open fails for such
> files.
>=20
> Refuse them when the namespace is enabled the same way zloop does
> since
> commit 0c10f8a1a7ae ("zloop: check that the zone backing file support
> ->{read,write}_iter").
>=20
> Fixes: d5eff33ee6f8 ("nvmet: add simple file backed ns support")
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0drivers/nvme/target/io-cmd-file.c | 5 +++++
> =C2=A01 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/nvme/target/io-cmd-file.c
> b/drivers/nvme/target/io-cmd-file.c
> index 695963dd932ee..dfa8aa46188c8 100644
> --- a/drivers/nvme/target/io-cmd-file.c
> +++ b/drivers/nvme/target/io-cmd-file.c
> @@ -47,6 +47,11 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
> =C2=A0		return ret;
> =C2=A0	}
> =C2=A0
> +	if (!ns->file->f_op->read_iter || !ns->file->f_op-
> >write_iter) {
> +		ret =3D -EINVAL;
> +		goto err;
> +	}
> +
> =C2=A0	nvmet_file_ns_revalidate(ns);
> =C2=A0
> =C2=A0	/*
