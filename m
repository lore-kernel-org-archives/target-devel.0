Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C003E5595;
	Tue, 13 Oct 2026 01:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791854784; cv=none; b=D44fNTzjKT/Psnde0me5nzT6tLSE2vAYRpX7NFOO4oE96X7+KluSFRndQYwTpqBOTWfSMGGPbe6ycXvUV8O/eZDOe7QVrlizWwnRtjByys1X2m8ZoaVBQgMyYZ/xDFSIxKsx/TEx56Gmr4zYegZ4WYuSgbB4Dv5HMFNWsgTFsTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791854784; c=relaxed/simple;
	bh=msWqNc/xTwn0O99YJ6GkLzhX78KHqpcdk3KQmDThNTE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=n/bEp5grKbs3vroOw1YiVGdC2Tiot0wsZNZHLsz4lxzvUOgneZ83OewqxwhHsOlxNlxnElC7AyIkh98Ro16DP1uoADoEW6574ImCGgtjcsupETBCXAeNBU9FZk55NhY/JatpZGmvC4YOdzZH7BCiotS0g9RPfZBLt103FxO7nmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eNGw7vRI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eNGw7vRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826CA1F0089B;
	Tue, 13 Oct 2026 01:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791854779;
	bh=4cIGQ6xzqbLTuA+AafcWkkBvnKpnpGRewkoKMzEayX0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eNGw7vRIWSEAlG2J2VoLmnFmz7U0oKDRNBoz1dMbxZgidLlcKrNeppNRMqm4QZ2SY
	 5JTtGCE2agabGUGZiQEcm62yLDp/WwrGu6zxkjZb/b5gB3iRH5Tfov7QwHgdOSRvAV
	 MLvKc6dqyCVQI18sUGVcJr4KQCIQ4zgPo4q88JMuRE9lLeialF1b4/uCKthyx0eQYz
	 G72RrG3VFTY87w2dZmOi6K+iLGd8bwz+tN30e0H+qr4zcbwjwd7rgiiaTzd4u/CsOa
	 b4vdD/9V0jkgqS2HD6fa8XEyNADCol0J3lllaicvCyviLNjF74hrJXXYQbp2/CutBu
	 wqHvz2m7BQKmA==
Message-ID: <sashiko-outbox-168835@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] usb: gadget: f_tcm: reject a short write data-out
 transfer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>, linux-usb@vger.kernel.org
Cc: target-devel@vger.kernel.org
In-Reply-To: <20261013005854.2470384-1-yhlee@isslab.korea.ac.kr>
References: <20261013005854.2470384-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 01:26:19 +0000
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] usb: gadget: f_tcm: data_len not cleared on successful OUT transfe=
r wedges pipe on backend failure
--

commit 63110d12dd83cfabcbf4574d13f034b5398b8e04
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

usb: gadget: f_tcm: reject a short write data-out transfer

This patch fails the command when a short write data-out occurs, clearing
cmd->data_len to prevent the BOT status phase from treating it as outstandi=
ng
WRITE data and queuing another OUT request.

> diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/fun=
ction/f_tcm.c
> index 9e6d4f39900a2..cbe64f934724e 100644
> --- a/drivers/usb/gadget/function/f_tcm.c
> +++ b/drivers/usb/gadget/function/f_tcm.c
> @@ -1090,8 +1090,14 @@ static void usbg_data_write_cmpl(struct usb_ep *ep=
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
> +		/* the OUT data phase is over; nothing left for the status phase to dr=
ain */
> +		cmd->data_len =3D 0;
> +		dev_err_ratelimited(&gadget->dev, "%s() state %d transfer failed\n",
> +				    __func__, cmd->state);
>  		goto cleanup;
>  	}

[Severity: High]
Does cmd->data_len also need to be cleared for successful full OUT transfer=
s?

If a full OUT transfer succeeds in usbg_data_write_cmpl() (req->status =3D=
=3D 0
and req->actual =3D=3D req->length), the request is submitted to the target=
 core
backend. If the backend fails during execution (e.g., media error, ENOSPC) =
and
returns a check condition, usbg_send_status_response() routes to
bot_send_status() and subsequently to bot_send_bad_status().

Since cmd->data_len was not cleared, bot_send_bad_status() will attempt to
queue a drain OUT request:

drivers/usb/gadget/function/f_tcm.c:bot_send_bad_status() {
	if (cmd->data_len) {
		...
		if (cmd->data_len > fu->ep_in->maxpacket) {
			...
		} else {
			req->length =3D cmd->data_len;
			cmd->data_len =3D 0;
		}
		...
		usb_ep_queue(ep, req, GFP_KERNEL);
	} else {
		bot_enqueue_sense_code(fu, cmd);
	}
}

However, the host has already finished sending all data during the data pha=
se
and is waiting for the CSW on the IN endpoint. Queuing an OUT request here
will hang indefinitely, wedging the bulk pipe and causing a DoS for the
endpoint.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013005854.2470=
384-1-yhlee@isslab.korea.ac.kr?part=3D1
