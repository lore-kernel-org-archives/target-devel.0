Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555CA37418C
	for <target-devel@vger.kernel.org>; Fri, 17 Jul 2026 16:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784306298; cv=none; b=kYdKLlRrCHT1WAhCUMQBmGK13cynpPlO1RrwupT3l9RQbyjjbd1Z/yIHsytq8VP53mmMe8733fc5f25BC17gtLSbyZBIBkWGUKEUhnqzq+iUnfz7fgzHLQYxvRgeHwasmITYjFtTkaXdA3PMYc8BNxHxipqzT5/5w2YbgQZWSVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784306298; c=relaxed/simple;
	bh=eEtSsHHkVS6EEgLnyWOrs6P9pU8mRTI7vhR4tH1XMRo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=igOSYER77wS9rMNTJmHoh02Ylhq+SgdeoN65QFSN/4FnBTAXlYTlkdrtZQD0yj/R90JLwIRqy10ESDXSJtD2uqsgoZX0vXiO6f8ZPFzQgIJ9BVH0GiBewG+1W7XjPgsi5vdIglsviu5rdBfJZ86gZSxbt1n2xlZBQc443bSy70w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hNVpVeL/; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hNVpVeL/"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4h1wZc5fsVz1XMmDQ;
	Fri, 17 Jul 2026 16:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784306293; x=1786898294; bh=undtjE1TEqLAg8m1bXRqNVty
	vuGabFNwsuhCZioLsaA=; b=hNVpVeL/Epxv+hADlFticQgOMuuV1MHOUYCHd6TU
	QdFN22sJcyrrZMCgBdC7NB20z9y6ul4kYYWh3yAHv0i5K+VFLTG9tSVyqhH6tuon
	LL1Vh+FAlxMivBfV2dANKZsdqb8nyGyvKAnBz6bxSzu6T+Xh8MEL0dBVp7OMC0oQ
	9r80/7mBMkKzUBSO8oQE2PHly4sRsB5rTScWmAT7On+N4yCs1USgK9JUWeEUhRQc
	Ua0Ac07u5ujpvxuaaJlVt1B4ox87JBRhmQV1oJ30YC+zmf3BubufzLpouIIM/zK7
	2otAP8NaPoY/TIUZHVHyA95aWaY9MkPiI8cOZvba8gtz2g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wQGsWVcS1TNi; Fri, 17 Jul 2026 16:38:13 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4h1wZW3lhVz1XMKfh;
	Fri, 17 Jul 2026 16:38:11 +0000 (UTC)
Message-ID: <98f75887-2a0d-41aa-9dcc-0b891e84e912@acm.org>
Date: Fri, 17 Jul 2026 09:38:10 -0700
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] target: iscsi: Fix hang for aborted WRITE_PENDING
 commands
To: Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc: mlombard@arkamax.eu, michael.christie@oracle.com,
 target-devel@vger.kernel.org, loberman@redhat.com
References: <20260717143828.76291-1-mlombard@redhat.com>
 <20260717143828.76291-2-mlombard@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260717143828.76291-2-mlombard@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/17/26 7:38 AM, Maurizio Lombardi wrote:
> When a LUN_RESET aborts a WRITE command that is in the
> TRANSPORT_WRITE_PENDING state, the target core sets CMD_T_ABORTED and waits
> for the frontend to finish processing.
> 
> If the initiator subsequently sends the remaining dataout PDUs,
> __iscsit_check_dataout_hdr() catches the payload, stops the dataout timer
> if the sequence is final and finally dumps the data.
> However, the iSCSI target doesn't trigger the completion process for these
> aborted commands. Because of this, the abort path hangs indefinitely in
> target_put_cmd_and_wait(), leading to a deadlocked target worker thread.
> 
> Fix this by explicitly calling target_complete_cmd() when the final dataout
> PDU is received for an aborted WRITE command. target_complete_cmd() detects
> the CMD_T_ABORTED flag and cleanly routes the command into target_abort_work,
> allowing the abort completion to successfully unblock.

Shouldn't a Fixes: tag be added to this patch?

Thanks,

Bart.
