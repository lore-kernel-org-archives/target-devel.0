Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795172159;
	b=HbR6k59tyioN4p9fGYE1RvZ4GkPeLNZCqfUWYlMhnCRpEpdKzof/2c/RUTkO/ScO4o75
	 Or94tSS6pzquiF5SpPkqVUlbRvQAy015Mp054B3n/ODhnGqleKQw6UUzJERn8IpC7meoL
	 GdcQRy3RHZhkFfdi2RqdYswUPeSWrRO2TCEOX+rd5dthfkItwcJACf2GjbjVNIAwdPcl1
	 lgUb1xbouFDqKhaUbbs3Xb2Yv3zS9dIXwW+TfisihzRzwa3Fla8V7Fb95Dxug2wkMJya0
	 Uh79ssFA2E9c7CNDtTkKU+wjTeQ92kjxItTT2tACm2WbS6dnKcXYhUm1QsNKqHddygg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795172159;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=2ScDhhlhFxgtL/0M/4qB5NHle6XaWcn7NPdtwh1ni+I=;
	b=HhXMVsC4d6GD2IYOMs883Y4yiwj9fE4YallZ+85O76uZCV6l0yhY4yVYlkDXWnj+Urzm
	 I9W/s5X3FHehhzG89VEi/4tv80KmjTYMzNPpEpr/Z7OA1/j8ip1EGVhSWd75nNYRN7vhP
	 X0AvyS8G+8Az0vvfw9JDS4UVrbBfDsVDjpQwL7/2GwVfM0h3MFO8K9qpHoFHA+dLDiqgS
	 SRruZOAJVz7p6PZO0puLkU8eoO2xhJjQ69NFLEsRnf1dCxi5a3g3YTAMEalWPIv7yhlWA
	 mPrkBubPOWS3Su7Y7yNs6D8Bni+7NDasrk9INlx9mE6R7JRVw0f9uKySmyku8G89Dzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DJiIKxki;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E01D606A320;
	Fri, 20 Nov 2026 10:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DJiIKxki
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6471F000C4;
	Fri, 20 Nov 2026 10:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795172159;
	bh=2ScDhhlhFxgtL/0M/4qB5NHle6XaWcn7NPdtwh1ni+I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DJiIKxki/8jpTxa2IkvVVJyOt/mbTcX7uIEHXwjecSRkbmf+OdEU1hx/yl8980Mv2
	 tBBvBfIPq5lY+XQHkRryUmnlVZdt1pjN7gfJVMvAI1ylx29aglE8EMc1qXyfTm0/dR
	 uvMZQNjx3k++3RQqF4VKn5hWxiq2J6lIqMeibsnA=
Date: Fri, 20 Nov 2026 11:55:56 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: nkapron@google.com, linux-usb@vger.kernel.org,
	Thinh.Nguyen@synopsys.com, bigeasy@linutronix.de,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	benquike@gmail.com
Subject: Re: [PATCH v8 4/4] usb: gadget: f_tcm: clear the scatter list when
 reusing the BOT status request
Message-ID: <2026112046-thirstily-cosmetics-1aca@gregkh>
References: <20261118124005.2428068-1-yhlee@isslab.korea.ac.kr>
 <20261118124005.2428068-5-yhlee@isslab.korea.ac.kr>
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
In-Reply-To: <20261118124005.2428068-5-yhlee@isslab.korea.ac.kr>

On Wed, Nov 18, 2026 at 09:40:05PM +0900, Yehyeong Lee wrote:
> bot_send_bad_status() reuses fu->bot_req_in/bot_req_out to send the CSW or
> drain the data phase, but a preceding sg command left req->sg and
> req->num_sgs pointing at that command's t_data_sg - set in
> bot_send_read_response() for a read, or usbg_prepare_w_request() for a
> write.  That command is freed before the status request runs, so on an
> sg-capable UDC the status request is handed to the controller with a freed
> scatter list: the controller reads freed memory out to the host on an IN
> endpoint, or writes host data into it on an OUT endpoint.
> 
> Clear req->num_sgs and req->sg so the UDC uses the linear req->buf instead.
> 
> A test module that stands in for the controller's queue path, so that it
> dereferences req->sg the way an sg-capable UDC would, reports a KASAN
> slab-use-after-free on the freed entry for a read command followed by a
> rejected command that reuses bot_req_in: 20 runs out of 20 without this
> patch and 0 out of 20 with it.  A normal sg read still queues its own
> scatter list.

Why is this paragraph here?  What does it mean?
