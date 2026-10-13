Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51ACD3EB105;
	Tue, 13 Oct 2026 06:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791874123; cv=none; b=ZszHze3/F+mDn1+vMbvH1PwKIaQ6CQhprD4C0kTXZPPOgkxTxIwcAIw+Fq6aSEXrF5grp1xCiQD9jC1JVpLASbTM433QXu7Z50OJ2ODi0R6YiwBq50JJQ9i7Q/EIG7JRILbmsIaLD+IRY0pyuLQPxBN4lajLSbHEllLAKHCAAzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791874123; c=relaxed/simple;
	bh=xWfbayAEwMfa8Dnxl5Ql8I3qEdkobRYLjAZb8LxQ2jE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=HqLHRJzq1/wD/cFx7qMFdAV7uZV9aOLtGTVXldnOUDDP+TTJEODl89FyJtm40t3+p0AlQ0lDFwpv/y9y0hcz+9fKby3Rj1dmFnl0u+oTezFFrtYOYlex4bWUBsP/Fj2KLW2u9gDHlcjGU/qCgM0MTNRENiqMmRwVeN9+mTRiu5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P7Nz6wkW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P7Nz6wkW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79F21F000FF;
	Tue, 13 Oct 2026 06:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791874121;
	bh=iveYHy/PosXY/ULvzzCvTTiNNvARbGrlyk8M8t9CvEk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P7Nz6wkWAVWqf5FMi7sPDWAPn4hzT5mKht06CfiVVmgfjRFkWRoo7bN2XyOV8Camt
	 6ftR2P2cB4eusaBMaxQhMFTvPBHPy3lXUKvfBdYCZemuBYNsmEVUvTEz2omzfGPfsD
	 iCkzSqa7u3GX2IrpO4gg74ncer+naKy47Br5XgMV48BUsqsM+s3vEt+wsUMEagupLs
	 lTxZJ71yVxYiSepr9aiXDDuEhtLnxncpLcGvHFxnPgIDzP1B4lST7nJEwyymf8KBeH
	 JkoJzdLZPGFnNksSqGOMPcy+D1aqgl6hblGBrBUhZ8kMiPOe+/p6kKq8ttv8y6G8YA
	 iKyp5gpbJGA7A==
Message-ID: <sashiko-outbox-169135@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 2/2] usb: gadget: f_tcm: reject a short write
 data-out transfer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>, linux-usb@vger.kernel.org
Cc: target-devel@vger.kernel.org
In-Reply-To: <20261013062129.2568405-3-yhlee@isslab.korea.ac.kr>
References: <20261013062129.2568405-1-yhlee@isslab.korea.ac.kr>
 <20261013062129.2568405-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 06:48:41 +0000
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] usb: gadget: f_tcm: info leak of uninit heap via dummy IN data
--

commit b6ddf000f25244005d71ddb597b63ddd0507d15b
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

usb: gadget: f_tcm: reject a short write data-out transfer

usbg_data_write_cmpl() copies se_cmd->data_length bytes out of the bounce
buffer into the command's scatter-gather list without checking how much the
host actually sent. A bot host can declare a larger out transfer than it
delivers and end the data stage with a short packet.

Fail the command when req->actual does not match req->length instead of
committing the stale tail.

> diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/fun=
ction/f_tcm.c
> index 12e2b20e33b92..a37a3ec8e7a4d 100644
> --- a/drivers/usb/gadget/function/f_tcm.c
> +++ b/drivers/usb/gadget/function/f_tcm.c
> @@ -120,7 +120,8 @@ static void bot_send_bad_status(struct usbg_cmd *cmd)
> =20
>  	csw->Residue =3D cpu_to_le32(cmd->data_len);
> =20
> -	if (cmd->data_len) {
> +	/* nothing to drain once the OUT data phase has completed */
> +	if (cmd->data_len && !(cmd->flags & USBG_CMD_OUT_DATA_DONE)) {
>  		if (cmd->is_read) {
>  			ep =3D fu->ep_in;
>  			req =3D fu->bot_req_in;

[Severity: High]
Does this code transmit uninitialized kernel heap memory to an untrusted
usb host?

Looking at bot_prepare_reqs(), fu->cmd[0].buf is allocated with kmalloc()
without being zeroed:

drivers/usb/gadget/function/f_tcm.c:bot_prepare_reqs() {
    ...
	fu->cmd[0].buf =3D kmalloc(fu->ep_out->maxpacket, GFP_KERNEL);
	if (!fu->cmd[0].buf)
		goto err_buf;
    ...
}

The usb host writes a 31-byte bot cbw into it, leaving the remaining space
(up to 993 bytes for superspeed endpoints) uninitialized.

When a data-in command (host read) is rejected prior to its data phase,
this uninitialized fu->cmd[0].buf is explicitly queued further down inside
this same bot_send_bad_status() block to satisfy the host's requested lengt=
h:

		req->buf =3D fu->cmd[0].buf;
		usb_ep_queue(ep, req, GFP_ATOMIC);

The completion handler then continuously re-queues this same buffer until
the host's requested data length (which can be up to 4GB) is fully satisfie=
d:

drivers/usb/gadget/function/f_tcm.c:bot_err_compl() {
    ...
	if (cmd->data_len) {
        ...
		usb_ep_queue(ep, req, GFP_ATOMIC);
		return;
	}
    ...
}

Can an attached usb host trigger this by sending an invalid data-in command,
creating a large information leak?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013062129.2568=
405-1-yhlee@isslab.korea.ac.kr?part=3D2
