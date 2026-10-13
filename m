Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E9927FB1C;
	Tue, 13 Oct 2026 04:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791867391; cv=none; b=BnqB65PdYXemi0yoncDBjLA+yXtF1EFisPEDPiCHA/9qJshbbbh5f87FUBmFR2F6rCWiIesOwMAW8HiyzP7lg88dm6rUfBkIKt7kQDhZEs9OYZbXCVsy4aReqxoZhdw21/fmseJjfw5a5d8/LzhvZAywvI/ImBqrAVFUEthgjWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791867391; c=relaxed/simple;
	bh=5UMfXIoPRKdBc+1s94LwVsSix9oIkGnoy9sRwah1ecs=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=I8z+KawHGZwYng1Is4gOxEosUwjsj9KNGnzRdvV4guINjwyBkp/74fUhRbzmXA566aI6Ds0sv3SWOuQApUDKB5ou4LGRGnz4+Yr4jpoBMH3EfenROI4IVqETFJuA3WJLhbuXcJcdpJT/fxi7fydsX4VdV+rXXmCYrR890AFd82c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YV640lWs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YV640lWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51DF01F000FF;
	Tue, 13 Oct 2026 04:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791867390;
	bh=CEzTgOnMoVFi0KomUaGHHgRJsSfTwwZLvX8bE8sKeCs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YV640lWsAHQnFrbfAixUUdvz0mQatde0k4kK5Iv1kMH6SdkML9tqbRgLx1qJjvpRB
	 ORxAY6NmZnLdjOQMEUXvJn6nPvdFjX/A3w21DATRCXLDXeZmAog0pKm1+E8Dpg0IA8
	 qIe2Gwc58pxz7TcIrBED1Dh1unYxArOvxCbYnv7bgiBxjkA9A8NQETKr13PHliEEJq
	 9O1OvRkLOrZEqSurt0ChZmdoPNoz87l4GLhUex4f6xpP7PEpQAglFZAGWyAie/xWgK
	 8AIJ9lSuyUQCcRAcl0ifNyoBKn+4JK6raQ14Vif12Xk5/ivnbtV5LExuYLLzIepItT
	 wnXeCj8zostuw==
Message-ID: <sashiko-outbox-168987@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4] usb: gadget: f_tcm: reject a short write data-out
 transfer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>, linux-usb@vger.kernel.org
Cc: target-devel@vger.kernel.org
In-Reply-To: <20261013043951.2534225-1-yhlee@isslab.korea.ac.kr>
References: <20261013043951.2534225-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 04:56:29 +0000
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] usb: gadget: f_tcm: sleep in atomic context via GFP_KERNEL
--

commit 566301a7621de86baa390c10673ab9e19515b2d9
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

usb: gadget: f_tcm: reject a short write data-out transfer

usbg_data_write_cmpl() copies se_cmd->data_length bytes out of the bounce
buffer into the command's scatter-gather list without checking how much the
host actually sent. This patch fails the command when req->actual does not
match req->length instead of committing the stale tail.

> diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/fun=
ction/f_tcm.c
> index 9e6d4f39900a2..d686fbcf36f72 100644
> --- a/drivers/usb/gadget/function/f_tcm.c
> +++ b/drivers/usb/gadget/function/f_tcm.c
> @@ -120,7 +120,8 @@ static void bot_send_bad_status(struct usbg_cmd *cmd)
> =20
>  	csw->Residue =3D cpu_to_le32(cmd->data_len);
> =20
> -	if (cmd->data_len) {
> +	/* a short data-out already ended the phase; draining it would hang */
> +	if (cmd->data_len && !(cmd->flags & USBG_CMD_OUT_SHORT)) {
>  		if (cmd->is_read) {
>  			ep =3D fu->ep_in;
>  			req =3D fu->bot_req_in;
[ ... ]
> @@ -1090,8 +1091,15 @@ static void usbg_data_write_cmpl(struct usb_ep *ep=
, struct usb_request *req)
>  		return;
>  	}
> =20
> -	if (req->status) {
> -		pr_err("%s() state %d transfer failed\n", __func__, cmd->state);
> +	/* a short data-out left the buffer unwritten; don't commit stale data =
*/
> +	if (req->status || req->actual !=3D req->length) {
> +		struct usb_gadget *gadget =3D fuas_to_gadget(cmd->fu);
> +
> +		if (!req->status)
> +			cmd->flags |=3D USBG_CMD_OUT_SHORT;
> +
> +		dev_err_ratelimited(&gadget->dev, "%s() state %d transfer failed\n",
> +				    __func__, cmd->state);
>  		goto cleanup;

[Severity: High]
Does this code sleep in atomic context?

usbg_data_write_cmpl() is a USB endpoint completion callback running in ato=
mic
context.

When the transfer fails, or a short packet occurs, this path jumps to the
cleanup label, which synchronously calls:

    transport_send_check_condition_and_sense(se_cmd,
                                             TCM_CHECK_CONDITION_ABORT_CMD,=
 0);

This invokes the queue_status callback which eventually calls
bot_send_bad_status(). As seen earlier in the file, bot_send_bad_status()
can submit the request with GFP_KERNEL:

drivers/usb/gadget/function/f_tcm.c:bot_send_bad_status() {
    ...
    if (cmd->data_len && !(cmd->flags & USBG_CMD_OUT_SHORT)) {
        ...
        usb_ep_queue(ep, req, GFP_KERNEL);
    ...
}

If req->status is non-zero, USBG_CMD_OUT_SHORT is not set, so the above path
is taken. Will passing GFP_KERNEL to usb_ep_queue() in this atomic completi=
on
path cause a sleep in atomic context?

>  	}
> =20
>  	if (req->num_sgs =3D=3D 0) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013043951.2534=
225-1-yhlee@isslab.korea.ac.kr?part=3D1
