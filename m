Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795182255;
	b=5OiFGwQN7j1sSTKIdz72BJyXuG+TOUiLOlGzsr5gk80dSUNn4DCUWyQvzoldBS6K5dTe
	 Ou64xazG/Vu471gcqS3HtcMrQHi029Kq+ptp7i5v7m723jCb0v82o0N5i5jBJqpZBWKoH
	 dUae3j/d48dUQmvEMelOBYbdF1RSAbV2nE3p7vW55Yz3T/JUmR1x6MvQAsIrd45j4SLa1
	 rE+oPXOppoes2kjrIRH+hYUyjM0+9pAQsnMAyq1gcUwaEdkQu4DPcOxzceZwF0GTE+BlI
	 bwQvm9HuEz+qsaj+QOBL0dz1QkavlxBjwND/TCzKRna1Uoh9WzfPuSZg8Vt+OAoAqTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795182255;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=vkyc/Z6a3G6ykwaX38bwBluxWjpdopYbdPN9Re75IuI=;
	b=UuzzjWTTT+/XmLIdGuxV5dXS1ApAesgHZwhZduZkksN5eS+3Kq+TE8qO9p+NRZOu062t
	 wwPyxFywfUGEHVtHL2n3QQEI8M5V3AFCmAyGRrMFKfAOorcYMXOLFvveSjxFTv7ww+PnA
	 O1xy2ixswVAZpvXnAUxSBC3oi1HxOhhmZS/P8dWODIDq9478JB0qHDZTcp+RuUV4QInj0
	 BQXNGsjNrAV/bDRf7s0dFa//f3bxnh3h26Ez+DNRdHH5wauNamSwBQmotZG/LfkgT7l+d
	 Gs4LnIygujuIh9w8BCqSWt7N6oEwx1bmvyQbM8Yi3nfQVkPQ+4ekl1olwKnzGAlPXNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lPXsR74P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A6660A381C;
	Fri, 20 Nov 2026 13:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lPXsR74P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99DE1F0156F;
	Fri, 20 Nov 2026 13:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795182254;
	bh=vkyc/Z6a3G6ykwaX38bwBluxWjpdopYbdPN9Re75IuI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lPXsR74PS5CfGCG5aDIRSTpqTsCYrHfDaDp5buGfEDYsRvB/cL07ojkIhmTcLNgxp
	 9iP64Nf9yX6EFcsR7HTBVZcbk2Z1lnG6cekloTpD9YsbUC/GZCWNIlJCUpeMsRpJmJ
	 Ac+A3JfIKngc4vvcSz00uc+TPtAUR4Uo92dKFPus=
Date: Fri, 20 Nov 2026 14:44:11 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: linux-usb@vger.kernel.org, Thinh.Nguyen@synopsys.com,
	bigeasy@linutronix.de, target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] usb: gadget: f_tcm: reject a short write data-out
 transfer
Message-ID: <2026112033-devious-chowtime-d73f@gregkh>
References: <20261013015416.2503787-1-yhlee@isslab.korea.ac.kr>
 <20261120113411.3069169-1-yhlee@isslab.korea.ac.kr>
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
In-Reply-To: <20261120113411.3069169-1-yhlee@isslab.korea.ac.kr>

On Fri, Nov 20, 2026 at 08:34:11PM +0900, Yehyeong Lee wrote:
> This is superseded by v8:
>   https://lore.kernel.org/all/20261118124005.2428068-1-yhlee@isslab.korea.ac.kr/

Please fix your email quoting.  This does not mean anything to me.

Remember, some of us get 1000+ emails a day, there's a reason your email
client wants to properly quote context.

greg k-h
