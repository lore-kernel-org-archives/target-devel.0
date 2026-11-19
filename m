Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795098098;
	b=JSQTa5U08oTr9JfFI6LfaxVfkPc9IOOoUw96IGEVempSIhe4k9wqXedihNV5ik+5peTy
	 1l2Kh1vDpTuU9SpNMXOsaKBmM89R6A+QhivA6C70febCrlQz9d/0O/B0KqZrWEgWGC0gG
	 hXZkXdt+OnaaxtMV73KZDyiOp5S92ym7lJrwHJDgkn0/LeSBrzBe+hd/Pp0oMHTjd4YZs
	 ZmQpXyIYb4PzC1JxpHXiY+D4xv7wBNoe255wbedVj5i8IefzFWjK1+IYIN0wOk9hgbOed
	 ef8h/2NNdtZEW86OuOCClZzArxie9APImIKxHm0vjBkM2CnqehmkS+XP+XgsnOJVXaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795098098;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wkSqqGgCFN84aZAl8/Lb7dsxadkH7LkBRIP76S7TKwI=;
	b=E2Q9aEkUlYQKY5PUB1cnd2SG2vu2PBbO7y4hAfhqVjKi4QozeH40nMC5SnsGvoJUn85B
	 /y2liiWwWrMh9ZYNS2cOkK96b6ZbUqdgzTXVMqCMRs2iKK3Nahouoj9JKPQ1OKPt0+oB2
	 Fj53m7JNJGpAOFbWCyOQj6UVDWCGaZb1kC3UL15hYgdVVbAq5wOuMZsBkUuGEJqI1Il8s
	 +hqf3L6Ey2NkFIDoLdWtjGiTJye/zFMdMZEY+XWnx9lUKtl1kqG2ioSHwxeAweV1BSRYi
	 osOA020z1YENYbLCdPxxlu2TJLIoctRUrHCOrU72S5LsRbuut2ussiw3Rf4R1lEKN2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OHfWT6x5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32921606A33C;
	Thu, 19 Nov 2026 14:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OHfWT6x5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F5A1F000D2;
	Thu, 19 Nov 2026 14:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795098097;
	bh=wkSqqGgCFN84aZAl8/Lb7dsxadkH7LkBRIP76S7TKwI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OHfWT6x5htd9s5bvTlH7vH8oE6msc/QgzStnNMLzEbo3lTETIJhqOHwPK3Z+SpUUJ
	 i5IoDzMmA2OkjRm5Wx6gB2gRvWa6/+XShlwjo2Q6uP4FXgM56O6JdqJJMn7swJr6p+
	 ppwTQVx6EpJ1Iovb6C5o8I4fEF9pW8DrhLVQH+6vAshNBo8rb1jkT/asCHqsSgeh8/
	 Yrr0mtWs3htRNFvqmkbyacDwVzZSmQZAf9ZWOdmckARRxNsFO+VSAYfOLkA4oWK1xr
	 1YD1jyfJcQDQ2CDVEhsQenc6OuO4qiZUpwaH/OnNogovEbl9VF7Kgr1HVJim3nuhMe
	 qFqM8A29Ghi0w==
Message-ID: <sashiko-outbox-223285@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] usb: gadget: f_tcm: put the overlapped command's
 request back on ep_cmd
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>, linux-usb@vger.kernel.org
Cc: target-devel@vger.kernel.org
In-Reply-To: <20261119140641.2768465-1-yhlee@isslab.korea.ac.kr>
References: <20261119140641.2768465-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 14:21:37 +0000
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
- [Critical] usb: gadget: f_tcm: NULL pointer dereference in
  usbg_aborted_task() [1]
--

commit 8fc2b5f7f30651e73e59207af565a062eb0d398b
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

usb: gadget: f_tcm: put the overlapped command's request back on ep_cmd

This commit requeues the USB request of a duplicate overlapped command on
ep_cmd before returning its tag slot to the session tag pool in
usbg_cmd_work().

> diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/fun=
ction/f_tcm.c
> index 9e6d4f39900a2..4dcf2ba008384 100644
> --- a/drivers/usb/gadget/function/f_tcm.c
> +++ b/drivers/usb/gadget/function/f_tcm.c
[ ... ]
> @@ -1333,6 +1340,8 @@ static void usbg_cmd_work(struct work_struct *work)
>  		active_cmd->tmr_rsp =3D RC_OVERLAPPED_TAG;
>  		usbg_aborted_task(&active_cmd->se_cmd);
> =20
> +		usb_ep_queue(fu->ep_cmd, req, GFP_ATOMIC);

[Severity: Critical]
This problem wasn't introduced by this patch, but can usbg_aborted_task()
dereference a NULL stream->req_out pointer in Bulk-Only Transport (BOT)
mode [1]?

The target core also registers usbg_aborted_task() as the .aborted_task
callback and invokes it on task abort sequences such as a LUN reset.
Because stream requests are only allocated for UAS mode, stream->req_out
remains NULL in BOT mode:

drivers/usb/gadget/function/f_tcm.c:usbg_aborted_task() {
	...
	struct uas_stream *stream =3D &fu->stream[se_cmd->map_tag];
	int ret =3D 0;

	if (stream->req_out->status =3D=3D -EINPROGRESS)
		ret =3D usb_ep_dequeue(fu->ep_out, stream->req_out);
	...
}

Aborting a task in BOT mode therefore causes a NULL pointer dereference and
kernel panic.

[1] https://sashiko.dev/#/bug/linux-02bb90fe-74db-45ad-a2cf-107fe1a41bc4

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119140641.2768=
465-1-yhlee@isslab.korea.ac.kr?part=3D1
