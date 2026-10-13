Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45891397338;
	Tue, 13 Oct 2026 07:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791877620; cv=none; b=c+5377HyByjnf6yJn1UCcFULWwb8OxTdNpGovu2JXWe5CITlpzxP5/AFOIBppiwQpnFgaGkmoGyEYUX2VQAhvhhyjdMGrRRK2c3tqCCXo7LDW8mRtSUSQAP38kv0hYKB/RIdklI3seHs0lTQ2uX9yk7wFQOv3A6LfmS6TaDhOng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791877620; c=relaxed/simple;
	bh=e5veVajL/nY5oYAK/bV9FvUF9rn0cqowC0u/oo2D31U=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=QsKJeUmCvd4Pxxo21wFL3SOn1FE13ht1x8OFgALkIZTdcqczqHULNjuterw1kC2go4bpldWXshzvT5lin5GaJtJ+w9xR4FhdSBAKdldeG4dShHp4ppV3FBqieEP9EZH8T+os9XvdwwxrHZLvCTs3bo115zaGWaUl98g+4gKP304=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZY2uty0s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZY2uty0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB441F000FF;
	Tue, 13 Oct 2026 07:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791877618;
	bh=RDN/5pUUIoTyltvO5ppIBqMLax6S88Enq7jx0j//shQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZY2uty0sYc0ca59ZHhQ3XMyl1EUoRkWlRIScI+pEs2VJWigEcfpV3COk4qO5yoetM
	 Bc0LZi4vaYQtGhsI2g1YM1oxN3aWi/dbAWJDrb3rgh6m23wXxjx+av38+yA1/jZVIy
	 KRLaZ3kLhTk+z2UPYDDN43FYnLUVq8jXuXnvK1ZuxJr9eup/E06Ob30+qhyKf8aUw/
	 AQWpFmvCn0/1sKCHJxQmriVYEUYteFpAAzsrkGQu50AxWMebZPXh/bOCqSxOdICThR
	 NfbAbIKeZ3I2eodyItmFSduoJgbkSPSfruNT1QWs+k4x9SZN9QbK4nFHRWiHBl+Xro
	 6TTYCgf3b8IGA==
Message-ID: <sashiko-outbox-169209@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 1/3] usb: gadget: f_tcm: queue the BOT status
 requests with GFP_ATOMIC
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>, linux-usb@vger.kernel.org
Cc: target-devel@vger.kernel.org
In-Reply-To: <20261013073328.2936318-2-yhlee@isslab.korea.ac.kr>
References: <20261013073328.2936318-1-yhlee@isslab.korea.ac.kr>
 <20261013073328.2936318-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 07:46:58 +0000
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] usb: unhandled usb_ep_queue() failure leaks TCM command
--

commit 16a4c4e4e7a428273bc0342e9886b47a85b4aef2
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

usb: gadget: f_tcm: queue the BOT status requests with GFP_ATOMIC

This commit fixes sleeping in atomic context by changing the queue flags
in bot_send_bad_status() and bot_send_status() from GFP_KERNEL to
GFP_ATOMIC.

> diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/fun=
ction/f_tcm.c
> index 9e6d4f39900a2..12e2b20e33b92 100644
> --- a/drivers/usb/gadget/function/f_tcm.c
> +++ b/drivers/usb/gadget/function/f_tcm.c
> @@ -139,7 +139,7 @@ static void bot_send_bad_status(struct usbg_cmd *cmd)
>  		req->complete =3D bot_err_compl;
>  		req->context =3D cmd;
>  		req->buf =3D fu->cmd[0].buf;
> -		usb_ep_queue(ep, req, GFP_KERNEL);
> +		usb_ep_queue(ep, req, GFP_ATOMIC);

[Severity: High]
Does this code leak the TCM command and hang the USB BOT session if
usb_ep_queue() fails?

By changing the allocation flag to GFP_ATOMIC, usb_ep_queue() is more
likely to fail under memory pressure.

Because the return value isn't checked here, if it fails, the endpoint
completion callback (bot_err_compl) will never execute. The callback is
responsible for queuing the next CBW (Command Block Wrapper) to receive
subsequent commands, so the BOT instance will stall.

The command is also not freed by transport_generic_free_cmd(), leading
to eventual session tag exhaustion. A host-initiated USB Bulk Reset
(US_BULK_RESET_REQUEST) resumes listening for new CBWs but does not
explicitly abort the leaked TCM command.

>  	} else {
>  		bot_enqueue_sense_code(fu, cmd);
>  	}
[ ... ]
> @@ -167,7 +167,7 @@ static int bot_send_status(struct usbg_cmd *cmd, bool=
 moved_data)
>  		csw->Status =3D US_BULK_STAT_OK;
>  		fu->bot_status.req->context =3D cmd;
> =20
> -		ret =3D usb_ep_queue(fu->ep_in, fu->bot_status.req, GFP_KERNEL);
> +		ret =3D usb_ep_queue(fu->ep_in, fu->bot_status.req, GFP_ATOMIC);
>  		if (ret)
>  			pr_err("%s(%d) ERR: %d\n", __func__, __LINE__, ret);

[Severity: High]
Does this code leak the TCM command and hang the USB BOT session if
usb_ep_queue() fails?

Similarly, if the GFP_ATOMIC allocation fails under memory pressure, the
error is only logged and we unconditionally return 0.

The endpoint completion callback will never execute, which stalls the
BOT session because the next CBW won't be queued. The command is
permanently leaked.

>  	} else {
>  		cmd->csw_code =3D US_BULK_STAT_FAIL;
>  		bot_send_bad_status(cmd);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013073328.2936=
318-1-yhlee@isslab.korea.ac.kr?part=3D1
