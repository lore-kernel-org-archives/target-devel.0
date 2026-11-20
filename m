Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795191508;
	b=5EsKXHlw6bLlM1l+J6JLDTpMObtTWPgzmal2Lqz3lzbrDHhlVrOTAt++3HycjrdspMeJ
	 fYguQyxCfdf1mIvBEAdE5oJZv2C1bniUF4Gr7U4MRqVsJ/qmQ5On8i4L+rhjehlsHTMaG
	 iaMPVeR+d8LZ4vXeDeci39FOxaAHfefxj4593vhXvRHRmR/oimgJkfj7BAaQsVWy99nau
	 VXuDdxi5+3jO1ixHZSY4Bl/kbYo1SeO2w7qduleAOILTxH+9mAOjpHUdcNlEzQzJQhxPn
	 tbUWNYkDWOZTRyFR/UTUYpvzOS30oRelSIIzRM7swzKRUEgH5zrol62S/L1B/nrGdCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795191508;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Yuo0+Pw8Cic/oPO/CJ6MTAhVLVtBofsbkkLBYKbgeu8=;
	b=lQbPZ+5T5/YawkwBYPg4LI/r+vZ3+1IhmMfuqXslRALbqvxCN8k9XDD4QacCuew1v2zx
	 j8TodhKGsqbtHocY8kU5hoJzDep1rTYU6EL+OmZtdA95atFl72RW2eEzpJOBDl4eTGA0v
	 pMbyliKkXGllK+oOXXYdY3eWrakH7xdVJ1CYa0iAsJrJHqvpWaWRHtX4XRPmOWE/qxPh5
	 uUDxevw+GaDA8UBLt9PHStc3Hz0cw5iHjiVJ32lvdyAXEP6bXcQCvt5vWDjYtJTJ8x/3H
	 +mO4irrN6YUm3z9a8X5LrSmk1Adb8Af3cRwZd9OKaLtP+29kAnv2C53oQXbj+kss9Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aysi+C8i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F4C606A325;
	Fri, 20 Nov 2026 16:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aysi+C8i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874E91F000C6;
	Fri, 20 Nov 2026 16:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795191507;
	bh=Yuo0+Pw8Cic/oPO/CJ6MTAhVLVtBofsbkkLBYKbgeu8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aysi+C8iuycwU52jP+cRNCO4lNKJ2M9m5KVkkhJpb0T81e0Eqjw0rw2uOYLtSVWJB
	 oW2Vx7AtY9JyF6hqsQsfB24PJWIQZ+Tos7vNTZdD2TTWFNPU5DyAS1qcBRAo1/LO6b
	 9MSJbYy4yMx+4R/dmT960dPVl1Ob9do7CdYu2mWYF/W7d4UNeax+WQ8UM/mkZwOR7v
	 ExVGx2QTYKoAU2rG6MOnp9Xf6cbM5O/X4jTroZ5OlLWqM3cJcU4pdkppbCl7kaPV97
	 4gbeu5F22QNPOsvHeFYH+LI7L2bAZ3zDth8BVIiIgpoy9t0Ro4eyP9a1aKtRip+w/Z
	 r5aAiawLNuTmw==
Message-ID: <sashiko-outbox-225553@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] usb: gadget: f_tcm: lock the UAS stream requests in
 .aborted_task()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>, linux-usb@vger.kernel.org
Cc: target-devel@vger.kernel.org
In-Reply-To: <20261120160616.3219043-1-yhlee@isslab.korea.ac.kr>
References: <20261120160616.3219043-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 16:18:27 +0000
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Critical] usb: gadget: f_tcm: use-after-free due to stale tpg pointer
  in tcm_alloc() [1]
--

commit 6cf4e81d4473dd79e435edcd1431deef1606dc92
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

usb: gadget: f_tcm: lock the UAS stream requests in .aborted_task()

This commit adds fu->stream_lock to synchronize allocation, teardown, and
dequeueing of the UAS stream requests across uasp_alloc_stream_res(),
uasp_cleanup_one_stream(), and usbg_aborted_task().

> diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/fun=
ction/f_tcm.c
> index 9e6d4f39900a2..21e5ef629319a 100644
> --- a/drivers/usb/gadget/function/f_tcm.c
> +++ b/drivers/usb/gadget/function/f_tcm.c

[ ... ]

> @@ -2757,6 +2777,7 @@ static struct usb_function *tcm_alloc(struct usb_fu=
nction_instance *fi)
>  	fu->tpg =3D tpg_instances[i].tpg;
>  	INIT_WORK(&fu->delayed_set_alt, tcm_delayed_set_alt);
>  	spin_lock_init(&fu->delayed_set_alt_lock);
> +	spin_lock_init(&fu->stream_lock);

[Severity: Critical]
This problem wasn't introduced by this patch, but caching fu->tpg in
tcm_alloc() [1] can leave a dangling pointer if the TPG is dropped and
recreated before the gadget binds.  When userspace removes the TPG,
usbg_drop_tpg() frees it, and creating a new TPG re-enables opts->can_attach
without updating fu->tpg in the already-allocated function.  Can tcm_bind()
refresh fu->tpg instead of relying on the pointer cached at allocation time?

[1] https://sashiko.dev/#/bug/linux-abce2989-69f9-4b30-b16f-d2b7ee05baa9

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120160616.3219=
043-1-yhlee@isslab.korea.ac.kr?part=3D1
