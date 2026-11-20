Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795182179;
	b=t60mkSbhguuGpHuZZIFRBU+C8QeH39gGFRZT8rpTDEqmEzXYik56l4zNKPM9rScj1Trt
	 DY16HovQN6JiQ4wRSKFTBF9jGWFLQfVbkzsA7DJTamqe2NVNb45IKbuMqIT7omurmJMo7
	 e3cMZv9ODRnuHG3AeD/NYWXfJjaUF/4hiqhkHeL7iZJPZ+eud7fptBpSEPHxHzcEi02T/
	 K8esRBMGDW+n1fDU7TSbiN8WEoW+hFvgG/4+W8SXqieYytIoio1CNTBMIXfGDIjomnN94
	 ypPgXDsHIrl04Y6szYr5CLGqZZIYhQUsYctm0wg29pI42GdpnyDHE57msMqBy/bRkZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795182179;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=SvA7m/49Gi2iaxV+gXZZS3T1rvAfQr6LUzbleK9RmJI=;
	b=RO+qma/a19X6vHyr39lcGPq+fnnrsOCifgjnRbtxNoU59BpYdPNB2iZv6xKfFxb+Qeax
	 cpXCCTeak87bJ2ck9DnPJ61+hzGkmM32AppLm6+JqhWaCLItaar09QVGpNTru++nbWsdB
	 q11yftSWju9dxCEuT2c+jV6ZhgXzD+tW0hjgVmGVatVm4klT8LARhkdAgIvbkbgTUrsl6
	 KwpPGwwL+70EIP57FsaKRVDyfk7jc2HR7p599S0kLJAt2+0VjgyVYkGyxzZ0sMhRj2N0q
	 h1z1VZxF8veJn6JsV0q3ZzMB95JXJKgAnlJSBJ3EPBN4MInzyAJ5yDVAC9fJaLKkrgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gv+2tT+1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3141360A2601;
	Fri, 20 Nov 2026 13:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gv+2tT+1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2561F0156C;
	Fri, 20 Nov 2026 13:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795182178;
	bh=SvA7m/49Gi2iaxV+gXZZS3T1rvAfQr6LUzbleK9RmJI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Gv+2tT+1IZbGG7xXQKEdMg/FYlWBO7XabOVcDaMmr03D4t6fMlRIDb1kJkaajwQz3
	 ycPKoGHjCcIsTEGOLBgPo6IZKhdPRM83zUVqbUMN0J9QjgeOSmej/Ndlt9SlWw+DW3
	 1JyISUe6zlOqNYmm3c5IKjy1bdBsJqAWbFeBeWj0=
Date: Fri, 20 Nov 2026 14:42:56 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: nkapron@google.com, linux-usb@vger.kernel.org,
	Thinh.Nguyen@synopsys.com, bigeasy@linutronix.de,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	lgs201920130244@gmail.com
Subject: Re: [PATCH] usb: gadget: f_tcm: do not dequeue UAS stream requests
 in BOT mode
Message-ID: <2026112031-sandlot-idealness-df6f@gregkh>
References: <20261120113956.3071640-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120113956.3071640-1-yhlee@isslab.korea.ac.kr>

On Fri, Nov 20, 2026 at 08:39:56PM +0900, Yehyeong Lee wrote:
> usbg_aborted_task() starts by reading stream->req_out->status.  The
> stream requests are allocated by uasp_alloc_stream_res() for the UAS
> alternate setting only, so in BOT mode they are NULL.
> 
> The target core calls .aborted_task() from target_handle_abort() for an
> aborted command whose CMD_T_TAS is clear.  A BOT command gets there when
> a LUN RESET arrives on another fabric that exports the same backstore
> and the backstore has emulate_tas set to 0: core_tmr_drain_state_list()
> aborts every command on the device, no TASK ABORTED status is owed, and
> the core calls .aborted_task(), where the read faults.  With the default
> emulate_tas of 1 the core sends TASK ABORTED status instead.
> 
> Return early unless the function is in UAS mode.  A BOT transfer uses
> fu->bot_req_in and fu->bot_req_out, not the stream requests.
> 
> Reproduced on dummy_hcd in BOT mode with a fileio backstore that is also
> exported through tcm_loop and has emulate_tas set to 0: a WRITE(10) has
> its data stage held while SG_SCSI_RESET_DEVICE on the loopback disk
> issues the LUN RESET.  Without this patch 3 of 3 boots oops as below;
> with it none do, and the write does not reach the backing store.
> 
>   BUG: kernel NULL pointer dereference, address: 000000000000005c
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD 0 P4D 0
>   Oops: Oops: 0000 [#1] SMP NOPTI
>   CPU: 1 UID: 0 PID: 30 Comm: kworker/1:1 Not tainted 7.4.0-rc3-FT9NNM-00395-g8dac6df92a2e #1 PREEMPT(lazy)
>   Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>   Workqueue: target_completion target_abort_work
>   RIP: 0010:usbg_aborted_task+0x2d/0xc0
>   Code: fa 55 53 48 8b 87 e0 01 00 00 48 89 fb 48 8b 50 38 48 8b 52 30 48 8b 2a 8b 57 24 48 8d 14 d2 48 8d 14 d0 48 8b b2 58 03 00 00 <83> 7e 5c 8d 74 2b 48 8b b2 50 03 00 00 83 7e 5c 8d 74 58 48 8b b2
>   RSP: 0018:ffffc90000107e40 EFLAGS: 00010246
>   RAX: ffff88800540d000 RBX: ffff888006c6c870 RCX: 0000000000000001
>   RDX: ffff88800540d6c0 RSI: 0000000000000000 RDI: ffff888006c6c870
>   RBP: ffff8880053febc8 R08: 8080808080808080 R09: ffff88800491c218
>   R10: ffff888005031cc0 R11: fefefefefefefeff R12: ffff88807db295c0
>   R13: ffff888006c6c9a8 R14: ffff888005031805 R15: 0000000000000000
>   FS:  0000000000000000(0000) GS:ffff8880f9e92000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 000000000000005c CR3: 0000000003030002 CR4: 0000000000770ef0
>   PKRU: 55555554
>   Call Trace:
>    <TASK>
>    target_handle_abort+0x6b/0x130
>    process_one_work+0x19e/0x3f0
>    worker_thread+0x180/0x2f0
>    ? __pfx_worker_thread+0x10/0x10
>    kthread+0xee/0x120
>    ? __pfx_kthread+0x10/0x10
>    ret_from_fork+0x186/0x230
>    ? __pfx_kthread+0x10/0x10
>    ret_from_fork_asm+0x1a/0x30
>    </TASK>
>   Modules linked in:
>   CR2: 000000000000005c
>   ---[ end trace 0000000000000000 ]---
>   note: kworker/1:1[30] exited with irqs disabled
> 
> Fixes: 76003eb6d09278 ("usb: gadget: f_tcm: Handle abort command")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
> ---
>  drivers/usb/gadget/function/f_tcm.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
> index 9e6d4f39900a27..57e2ec81f29a8a 100644
> --- a/drivers/usb/gadget/function/f_tcm.c
> +++ b/drivers/usb/gadget/function/f_tcm.c
> @@ -1614,6 +1614,10 @@ static void usbg_aborted_task(struct se_cmd *se_cmd)
>  	struct uas_stream *stream = &fu->stream[se_cmd->map_tag];
>  	int ret = 0;
>  
> +	/* the stream requests exist only in UAS mode */
> +	if (!(fu->flags & USBG_IS_UAS))
> +		return;

What prevents the flags from changing right after you read them?

thanks,

greg k-h
