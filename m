Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1BD46EC7C;
	Tue, 13 Oct 2026 02:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791857658; cv=none; b=QlWjd/Ge7E5BcM8cvJFiXeHi7hf3716OYSXEcOKpaLM0BjiLU65/hIKlO1PYWNCO3Eo4kerNPJGvPtaiUIN7xdCCVVhor/KO705EVEJifEWafbsZ31dKy731T+7LxxoBsP1LIFYbtG+zFbTqE8VmSqrZoxKMyVLNpt3E4ep1AmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791857658; c=relaxed/simple;
	bh=dHOopfR12PALJSYZGECRqDg12/KSjc6+ruHCgUt0OfI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ld3OVGycpcSIYQ6peZCXFSvQbWy848olV8iWRO+8AKTT3VOlhxKxmPPlBo8pSGH96v6kwvJPU8/ffcsRn28WY1YH1E6Q/FjFgVn/dTygVvG9l4SJrhGCmIAUGDiQ6Hce0I6dFj5vOFACWzFZpUY5H9UHPU4SOi/3W5Vk0HBhqms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SfBLdmq4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SfBLdmq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8843F1F00893;
	Tue, 13 Oct 2026 02:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791857656;
	bh=qvLf9e3JixLDEVVAIWNucUQP+rrmPMqzoO4de35dQFI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SfBLdmq4OzPdMYfPudVp2SUYALLI7Eqmz7hzEM7Q7kEchvcQsscP5uKRI19HrJMN7
	 Q+f50EdkXQLTXsLKei8dQsqr83jj6kdat2hzijrEFZE0Cpy1HFWkYM1cw+36Bm2ASa
	 KQq0n7pf6wk6be4z0qGGEoxr5zpywukFXh8ja5IOWg1WW9oJPWUvag7hd1j2oi+MUs
	 Fjsu9vlSXLPPzkcMQPU0YLB2nbP92jV60A+qOFDHTQcx7r1a3HfPIOKji6JpNzrvYT
	 qd6ukCN03ObYVasJ+p40AMcxgA88I33x/Bdme/nhCU95hYtNjBgad7GZNFIqcuOltw
	 08q/V8Ne4sURw==
Message-ID: <sashiko-outbox-168852@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] usb: gadget: f_tcm: reject a short write data-out
 transfer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>, linux-usb@vger.kernel.org
Cc: target-devel@vger.kernel.org
In-Reply-To: <20261013015416.2503787-1-yhlee@isslab.korea.ac.kr>
References: <20261013015416.2503787-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 02:14:16 +0000
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] usb: gadget: f_tcm: UAF in usbg_data_write_cmpl due to early kref =
put
- [Medium] usb: gadget: f_tcm: incorrect CSW residue on short OUT transfers
--

commit f48535188baaf66bf383bdd7132a79b493a45251
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

usb: gadget: f_tcm: reject a short write data-out transfer

This commit updates usbg_data_write_cmpl() to reject short data-out
transfers by verifying that req->actual matches req->length. It also
unconditionally clears cmd->data_len to prevent trailing OUT requests
from wedging the bulk pipe.

Fixes: c52661d60f63 ("usb-gadget: Initial merge of target module for UASP +=
 BOT")
Cc: stable@vger.kernel.org

> diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/fun=
ction/f_tcm.c
> index 9e6d4f39900a2..cf6a394c4196b 100644
> --- a/drivers/usb/gadget/function/f_tcm.c
> +++ b/drivers/usb/gadget/function/f_tcm.c
> @@ -1090,8 +1090,15 @@ static void usbg_data_write_cmpl(struct usb_ep *ep=
, struct usb_request *req)
>  		return;
>  	}
> =20
> -	if (req->status) {
> -		pr_err("%s() state %d transfer failed\n", __func__, cmd->state);
> +	/* the OUT data phase is over; nothing left for the status phase to dra=
in */
> +	cmd->data_len =3D 0;

[Severity: Medium]
Will clearing cmd->data_len here cause an incorrect BOT CSW residue to be
reported on short OUT transfers?

Looking at bot_send_bad_status(), it uses cmd->data_len to populate the CSW
residue field:

csw->Residue =3D cpu_to_le32(cmd->data_len);

If a short transfer occurs and usbg_data_write_cmpl() sets cmd->data_len to=
 0,
the device might incorrectly report a CSW residue of 0, hiding the fact that
data was dropped.

This appears to violate the USB Mass Storage BOT specification, which requi=
res
reporting the exact difference between expected and actual data length for =
short
transfers.

> +
> +	/* a short data-out left the buffer unwritten; don't commit stale data =
*/
> +	if (req->status || req->actual !=3D req->length) {
> +		struct usb_gadget *gadget =3D fuas_to_gadget(cmd->fu);
> +
> +		dev_err_ratelimited(&gadget->dev, "%s() state %d transfer failed\n",
> +				    __func__, cmd->state);
>  		goto cleanup;

[Severity: High]
Can jumping to the cleanup block lead to a use-after-free or a double-put of
the se_cmd?

The cleanup block unconditionally drops the fabric reference and then
immediately accesses se_cmd:

cleanup:
	target_put_sess_cmd(se_cmd);
	...
	transport_send_check_condition_and_sense(se_cmd,
			TCM_CHECK_CONDITION_ABORT_CMD, 0);

Calling transport_send_check_condition_and_sense() after dropping the refer=
ence
via target_put_sess_cmd() appears to be a use-after-free.

Furthermore, if this error path is reached because the target core aborted =
the
command (which completes the USB request with an error like -ECONNRESET), t=
he
target core will have already forcefully dropped both the ACK reference and=
 the
execution reference via target_handle_abort().

When the dequeued request enters usbg_data_write_cmpl(), calling
target_put_sess_cmd() again could cause a double-put underflow and
dereference the freed se_cmd.

>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013015416.2503=
787-1-yhlee@isslab.korea.ac.kr?part=3D1
