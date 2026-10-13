Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66C64B0CA8;
	Tue, 13 Oct 2026 06:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791873416; cv=none; b=oi/iWEqb48Ke0aUztHmD+UqsY5pA8BYjfMkwdUBPOr/lP5jk2y68scpGwbyljeM28x3EpI8VwhCD2Ynr6QVOuB54mAldOSrJIX9psghSo4f876Xx3giW+7MfS6Em8QmGYGwSZpMLeLMSnPcoa1nf2xn3OlDUYpY6vL0MdeEGa4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791873416; c=relaxed/simple;
	bh=Ly9EdeXXamLh3MkicmeXlKp/vmlrtDdAup32UCF9W1M=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=k9LTWydOS6LENmJEAHk+eEG/bV+kAbGCQttSPNh9YlryLDGkKSFbLqFDSmgl68oOzaSyXgLa0HjreisK5uHribuP33tox1AFrcGUGegWHts/khTLc5GWGF/ZjsWEXqKehVWI816yapidYOjK5SsNi3t/xLIGj8mbw5picEHgPIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RYD7GdRj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RYD7GdRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB171F000FF;
	Tue, 13 Oct 2026 06:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791873414;
	bh=fgOBiUXLecxWWJLIYUvuCgItMZPC9eaaEzSaUhhR1TE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RYD7GdRjFbMam04KFFeDAOoOZGSfD3Bf3O9COnZvtjB6vMICP4vWSy2L0ieW6YFeW
	 hztLHuEUOxq1veJOuBYlYWelqboLz23pX7OzlIlQy621HWoYziGRvs+Nu+9jO8RZCK
	 qaSMfIeSnUvOvrTJQ8n+t7Iixru4f8PpYydrBTiBZjNCutbgq8MLRxgGGaVV0Dn8hu
	 aV1MDQlAh0vtPiImARsREPz0reYMUHq+yaYdhQwLRHkmqedSYsI0VfkH2zUmxdyIIj
	 AW7dlXVVGkoHSSuJFkHgawdQa4LcD3HWcrmOQSEINpERatFD/wdH7YQTirgkdTHDuV
	 WipX43WDUPb5A==
Message-ID: <sashiko-outbox-169111@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 1/2] usb: gadget: f_tcm: queue the BOT status
 requests with GFP_ATOMIC
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>, linux-usb@vger.kernel.org
Cc: target-devel@vger.kernel.org
In-Reply-To: <20261013062129.2568405-2-yhlee@isslab.korea.ac.kr>
References: <20261013062129.2568405-1-yhlee@isslab.korea.ac.kr>
 <20261013062129.2568405-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 06:36:53 +0000
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] usb: f_tcm: command leak and session hang on usb_ep_queue failure
--

commit 02e0e86fc156823b4bb7eaf20b01ef508e2fded8
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

usb: gadget: f_tcm: queue the BOT status requests with GFP_ATOMIC

This commit changes the allocation flags used when queuing BOT status reque=
sts
in the f_tcm USB gadget function. Since the completion callbacks are execut=
ed
with interrupts disabled, GFP_KERNEL is replaced with GFP_ATOMIC to prevent
sleeping in an atomic context.

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
In bot_send_bad_status(), if usb_ep_queue() fails, do the target core comma=
nd
(usbg_cmd) and dynamically allocated buffers (such as cmd->data_buf) leak h=
ere?
The return value is completely ignored, which means the completion callback
is never invoked to free them.

Since the target core expects all commands to complete before session teard=
own,
could this cause target_wait_for_sess_cmds() to loop forever waiting for
completion, resulting in a permanent kernel hang? A faulty or untrusted USB=
 host
can trigger this by resetting the bus or disconnecting at the exact moment
usb_ep_queue() attempts to queue the status request.

>  	} else {
>  		bot_enqueue_sense_code(fu, cmd);
>  	}
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
Similarly in bot_send_status(), the return value of usb_ep_queue() is check=
ed
but only logged. If the queue fails, does this lead to the same command leak
and session hang because the status completion handler is never called to f=
ree
the command?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013062129.2568=
405-1-yhlee@isslab.korea.ac.kr?part=3D1
