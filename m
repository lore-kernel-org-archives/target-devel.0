Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795182197;
	b=Alc721zJVXpQGcGoMiH0y9c+Hm3MtpzwNo3xWU5P5K51nzt2TCKjKqO+EhLzuZ3GigHM
	 lcZEW8JCEyht2iIRRxvTs3ppTwdkxCLFEdOXU8i7HEjQt9ehg4gLTT+1JJZiz403DpJVP
	 mAoiAFiMfJBaeQljd8Gpy23VNbKddWAOIY5ZqUeN3eX1Xe2RLyi8PhF40ItnewjByVTD4
	 crPKWd2asHB/UVk718HYgj3p/oNmPMjA3WDUU9rg+60/CLk+d/JAM0n7BkZ+L0UWsvH9Z
	 S8I7zP9UGYcdlZtFMD9dAHuYoWANjUra+TWu6w+P7vF8zu4zQefFAsmnxcoLLsAmU6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795182197;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=B98msGtXqIfU+Q4KW7ICYahd4mKDTByEzIDBkjSlEBA=;
	b=QxYEcjTxoh4gq2B8ewcEGoGBP4wQTj6ZTZzyjkr8pfNqasmCfG4ehmHXci3XXOTrRHaH
	 AqUnGVNU1tSTiTHOfGMwIly+8nVyF4sDEGV2lv2xmNeXlEJIDCKaC2UdmW0n0hSwakeCm
	 xNuzqgGzILLHmHez8rbcsG9tYDIBqbUxdKx075JD0C42MtvXxtQ+FMw56PI38NNIbQrQ/
	 +akD6SHL3cPJNXrDgIe1sNsP0Bh2YMMzsiMKpli8+9Rtn+DP+jKbK6mh/sHMWKbHKzG9+
	 qeIyHhGRUhWJVUzD86MEiHQz6+/H1sqJxuppI3WXM7Fp9U3iqBkE/skNXc76YRsh0Hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YYeUren3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6128060A2606;
	Fri, 20 Nov 2026 13:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YYeUren3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D4A1F0180F;
	Fri, 20 Nov 2026 13:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795182196;
	bh=B98msGtXqIfU+Q4KW7ICYahd4mKDTByEzIDBkjSlEBA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YYeUren3/XuOx7Ihf4FdDY1bq2gRSIwt2b5enGg4fZIvQsHJYJQ+GTu/a1YkNqTeU
	 vSG9nWPSkL+003E7Vd0Ezz4yh7U/j69STz+C83KmGEwhEr76/kJLaE9rjbkboLkcpl
	 /Z0DlxHWuq4uLpfvZ+lh2boZcN81MyTUTr1XtF80=
Date: Fri, 20 Nov 2026 14:43:14 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: nkapron@google.com, linux-usb@vger.kernel.org,
	Thinh.Nguyen@synopsys.com, bigeasy@linutronix.de,
	target-devel@vger.kernel.org, sashiko-reviews@lists.linux.dev,
	linux-kernel@vger.kernel.org, lgs201920130244@gmail.com
Subject: Re: [PATCH] usb: gadget: f_tcm: put the overlapped command's request
 back on ep_cmd
Message-ID: <2026112009-undated-decoy-2ac3@gregkh>
References: <20261119140641.2768465-1-yhlee@isslab.korea.ac.kr>
 <sashiko-outbox-223285@kernel.org>
 <20261120114108.3071955-1-yhlee@isslab.korea.ac.kr>
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
In-Reply-To: <20261120114108.3071955-1-yhlee@isslab.korea.ac.kr>

On Fri, Nov 20, 2026 at 08:41:08PM +0900, Yehyeong Lee wrote:
> Right, this is a real bug, but it needs a non-default setup.  With
> emulate_tas at its default of 1 the core sends TASK ABORTED instead of
> calling .aborted_task(), and a BOT session can't send a TMF itself.  So
> it takes a LUN RESET from a second fabric sharing the backstore, with
> emulate_tas set to 0.  It's an Oops in the target_completion worker, not
> a panic.
> 
> Fixed in a separate patch:
>   https://lore.kernel.org/all/20261120113956.3071640-1-yhlee@isslab.korea.ac.kr/

I see no context.
