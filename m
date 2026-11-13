Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.225.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794565562;
	b=Ceu60RMYfllnwQFQqHuOAh0TvRC2Hexd8u6o27poewRnECnk9ZPqU1ubdCIghiDlmRnP
	 L8upyvULmSEbCrmYoHpaKsatSjBBNo8RIvoQdCl52C0UXySEHQjp7vbtONSebuxCdYn+v
	 yyT727m3fVpp4Mh+QimRIsUBXgNPRbg5v4aY7CnusmT7LGJKZkMlEdthsOBOoT5D8383f
	 yfjgsMaMrXJImV2pC5PQER7sGiURNvxvkuXyKrECNsamM5iXWr4Gdgg7RsC0Jhl//vCSa
	 czuEtNLB+QvskW0kEX07UhMuOKEt2B8iAm6FvOjSGuTP0PKnQ7OD3AIDbmTJx62DdNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794565562;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=5OyDtStyAeBedN7jaZpmypaL0n4+GQJgji3UYOQMX7Y=;
	b=sbP7rDMe98JD53vpP4Vs9lnY67bBKuK8opuS4gXnZa7v4py09cuzEagy9K4A6cXILp+6
	 gvZ7T4ChdQWEXmiDQ77zY0WxlOf5b/dA/V94g7ADjEROCyybbU0JLHfK4cbHmoXbnHvq/
	 /GquNwevQQMGa4o77RvSc8QFVaIX28VUnrh9o+PEHfNodpkXpV2o+Xs1sYrg3FnJagrVQ
	 pTGSbSJn9Pgv1fJU1kb49cSoIlqnMYJDCuxXhGFq/uSI8f55Zf+gcb/JCpwsJHWukgTv2
	 ngS1+AsXOatBgyXKkPyf+8+bkwQSdSBNNcY9L8n4vXutszbyYnolkAt6vnKgBaG9+yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=EhCy1rjV;
	arc=none smtp.remote-ip=74.125.225.138
Received: from mail-wm2-f10.google.com (mail-wm2-f10.google.com [74.125.225.138])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF58F606A891
	for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 10:26:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF58F606A891
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=EhCy1rjV
Received: by mail-wm2-f10.google.com with SMTP id 5b1f17b1804b1-49ff9833fedso1224165e9.0
        for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 02:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794565560; x=1795170360; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=5OyDtStyAeBedN7jaZpmypaL0n4+GQJgji3UYOQMX7Y=;
        b=EhCy1rjVxVdFrlqlBXdnWdhZOgju6UqPO7MHP0T5eDQlLH3bu4fGnJjBmSeu+X4e2W
         fqknndYp9WUsPcSw+hMOJQKeOCVQ26f4CApHOuaHiz0ZnrEcpw06GAGjRX2e/v0KskXR
         kPbczhlJA2JL/E3RYwJYZ55bjMsTqV1bcwrFG/iNBMGzSlTlhWz25UxyOw6nI4axYZSB
         u0krz81cE8qJBpZN+Gj0XIkGJFuZa0vCttP7+3dXPKfvLd7fzcQdMwTNK/JaleYs6P1m
         dJAReh6EvrYwFB4nFlJdvgjX0mrHV5c8k7KozarvFnbaOIXtcKdLHY5nOcL1YTJjLQtf
         x2BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794565560; x=1795170360;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5OyDtStyAeBedN7jaZpmypaL0n4+GQJgji3UYOQMX7Y=;
        b=1VuHv75+Jan1YIxd1R4Gh6kgZvMLx7t8DzKcMrdqfEn777zMxR3TECRm2zjqMJBlTl
         PWDJ18G0hDXkLgwgLHHCJWB9qTsUrlyrG/Kc3hVO59jpmwD60858NY2hvepCpA8c3dVj
         OK44eT1KtU9eN5pQRAUvSmswMVNlYdHA5OebgLRS3fSvqxKvDsRM72iv6u2N9pg80guY
         EI3+yLsb/6av70SJ1elVMJrMSBvCcBT7xNayMhB5nKMBkupBiuGDBH8PEXsCEC30t8sB
         xoBn8sYwh9lsDxd/L71SYBCPjzfv3edIdZJ3J7r661ATFym/2oWCowmOMjB7h3wHQSnk
         bC3A==
X-Forwarded-Encrypted: i=1; AL+hErGb4Q6m0qQMZjJZ8dIQ3VAlPf/RIDViJN2hqTnNtz3kmq0NQJzi4obwtLSfrnz3UO092EjKY1blIfz80SA=@vger.kernel.org
X-Gm-Message-State: APuU4Z/3hVzWukHVTJdli4osTbKYIFophP1e1HLsqkVLurCetZs/wEEG
	KVRZOWG3J2LH/3WhYXcMXLgzmruMr6wNKUveom1uVtWCXJzuyb6oHieub/VuAOUixBS8
X-Gm-Gg: AYBFou1K6fzTSdCpR2IPi4DT3JhbdkNwC+nxKxhG/I046drrLObHYjadsKOC/u4vwjK
	v2Nlx3+WwlNcYnX0tv4Mlen+CngNXW9lSx4bwfkaD8sMLEPtbG43L6I0k33db6wlZCsDqwwAfOY
	ONvKa9EHAnJEvMpxxp/8y5MSoIaoOq9Wc8rHZuZY2RNyAwloah8upRCC4SoasJ7dEKa+Oi6GKBL
	Wbp748WpnQLLAYhpHtb1jJR5dvqYmxpzflaMdtvf8mfiqOYtFbduKeA7vyvpEtd5y4tlPySYLiI
	LgFciVuNKFfJuL/yHyydJ7PMuCPaKmbl2p6PKeAk2HD05aeD1nrur3T2/HgjfY5a0C0NbzsbtEj
	HoNDtXJSPNOt5haIPe6iwluz7Luqt1BXxVD+ZZPLMG3e31GytMXzKQ2SOrrNS4twHM6XW0Vcup9
	BOxhu/R0lIVuByH3J9Xzaz/gUnOzmua0VgBJ4baVDka5J3Ge8PfxuOU6K3uarJ1CjY4ZaJR4ndC
	FO1Lv/n3tRwDMyQeU7tI03K6/0QZZ/8prnpIhvcNmRuo7KaemU41FANyNvOpPC8smMD+EJBUQET
	JD3TDXZSeGHx4NO+fW4hgOz8PJUrbIBikJtCfDrRyhc1yL5+7pYZ+vWLtdM8Gqk=
X-Received: by 2002:a05:600c:4e49:b0:4a1:78c5:79f5 with SMTP id 5b1f17b1804b1-4bb55aa999dmr38995625e9.33.1794565560090;
        Fri, 13 Nov 2026 02:26:00 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e2538b9sm244439965e9.1.2026.11.13.02.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:25:59 -0800 (PST)
Message-ID: <fb1d72cf25d10a960da627f6d93a3e041820ed3a.camel@amutable.com>
Subject: Re: [PATCH RFC 38/41] fuse: refuse files on pseudo filesystems as
 passthrough backing files
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, Chris Mason
	 <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
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
Date: Fri, 13 Nov 2026 11:25:57 +0100
In-Reply-To: <20261111151202.GA11391@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>
	 <20261111151202.GA11391@lst.de>
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

Hi Christoph,

On Wed, 2026-11-11 at 16:12 +0100, Christoph Hellwig wrote:
> I've seen setups where people use fuse to mediate access to sysfs
> sysfs in odd ways.=C2=A0 No idea if that's still around, but if so, this
> patch will break it.


Oh, that's painful. Do they use backing files for that?
It's a relatively new feature in FUSE...

Kind regards,
Alex
