Received: from arkamax.eu (128-116-240-228.dyn.eolo.it [128.116.240.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4804419FAE
	for <target-devel@vger.kernel.org>; Mon, 20 Jul 2026 12:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.116.240.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784551677; cv=none; b=kaiHAwD1qFfrwFp6MA0xf9XOWZoJuv3k8o83zTFXUc/fJy3j7hakgh4En60ndMPsLUKXunTYL1uKQXHgdsr509SfjIJ+SnHuxVHqW9abpXcUkCsIt4EIFgBNI8C1cEF9Hr2cv8TJCKeZcXuKsB8xvjO38Zzze9TPpYMCl2OKGWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784551677; c=relaxed/simple;
	bh=4SE9Bmma2zF2rwiEGm15iA6VNAf6r2/EYcNbiPkI8bE=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=N8B+DeTMZbFgrknUe0f5gHXApk/hPJ9Hlqr7vQ/1QBkivjSNIuPXJbLfbwYAZausUJKlIEUf9tMsTMqkc0J0fijtdszGcAVWPs9fBZQ+4imkIQ+I3vtEf/7WjUQKck0vF52jbYoeMSXZWOCeAeUQZvcxp2514NKWp7Mugpr3Kzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arkamax.eu; spf=pass smtp.mailfrom=arkamax.eu; dkim=pass (2048-bit key) header.d=arkamax.eu header.i=@arkamax.eu header.b=cGl+CIv2; arc=none smtp.client-ip=128.116.240.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arkamax.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arkamax.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arkamax.eu header.i=@arkamax.eu header.b="cGl+CIv2"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; s=mail1; bh=4SE9Bmma2zF2rw
	iEGm15iA6VNAf6r2/EYcNbiPkI8bE=; h=in-reply-to:references:to:from:
	subject:cc:date; d=arkamax.eu; b=cGl+CIv2HCLVwezxKKScHkcl07iI/wRKCNj7r
	5kDYiTbK9SfSBL8+/CxMbLCzHEYWTtRBrJmbt7qInK7aU/AGl48VUZIQPX52RChdyNPZYM
	gATsyH12zCntNBc3xoCjiaeptt0fhWD+Y0zJQ4JlllB5LJ9diyC1HS+AzEmpj+tflH7IQ/
	ymfESxpbI3htsWdbtbGYk+zjmDjMX1eMXXkeAx2spZuw/rcY0Q8GOrpNlBPS6DEXGmr7qQ
	tmJ5OaBJXJcTSKv1CbOfhzsOJ6TCFG6SMTMqbvrRrloMp63sPa+Kr2lqgXrNAL1iOdDjI7
	zPp2fam3wk0PudKBi1LIyBfTw==
Received: from localhost (128-116-240-228.dyn.eolo.it [128.116.240.228])
	by arkamax.eu (OpenSMTPD) with ESMTPSA id 74cfdd24 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Mon, 20 Jul 2026 14:41:11 +0200 (CEST)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 20 Jul 2026 14:41:11 +0200
Message-Id: <DK3EMOIBBYKX.2Q4JNOIUC58P@arkamax.eu>
Cc: <mlombard@arkamax.eu>, <michael.christie@oracle.com>,
 <target-devel@vger.kernel.org>, <loberman@redhat.com>
Subject: Re: [PATCH 1/1] target: iscsi: Fix hang for aborted WRITE_PENDING
 commands
From: "Maurizio Lombardi" <mlombard@arkamax.eu>
To: "Bart Van Assche" <bvanassche@acm.org>, "Maurizio Lombardi"
 <mlombard@redhat.com>, <martin.petersen@oracle.com>
X-Mailer: aerc 0.21.0
References: <20260717143828.76291-1-mlombard@redhat.com>
 <20260717143828.76291-2-mlombard@redhat.com>
 <98f75887-2a0d-41aa-9dcc-0b891e84e912@acm.org>
In-Reply-To: <98f75887-2a0d-41aa-9dcc-0b891e84e912@acm.org>

On Fri Jul 17, 2026 at 6:38 PM CEST, Bart Van Assche wrote:
> On 7/17/26 7:38 AM, Maurizio Lombardi wrote:
>> When a LUN_RESET aborts a WRITE command that is in the
>> TRANSPORT_WRITE_PENDING state, the target core sets CMD_T_ABORTED and wa=
its
>> for the frontend to finish processing.
>>=20
>> If the initiator subsequently sends the remaining dataout PDUs,
>> __iscsit_check_dataout_hdr() catches the payload, stops the dataout time=
r
>> if the sequence is final and finally dumps the data.
>> However, the iSCSI target doesn't trigger the completion process for the=
se
>> aborted commands. Because of this, the abort path hangs indefinitely in
>> target_put_cmd_and_wait(), leading to a deadlocked target worker thread.
>>=20
>> Fix this by explicitly calling target_complete_cmd() when the final data=
out
>> PDU is received for an aborted WRITE command. target_complete_cmd() dete=
cts
>> the CMD_T_ABORTED flag and cleanly routes the command into target_abort_=
work,
>> allowing the abort completion to successfully unblock.
>
> Shouldn't a Fixes: tag be added to this patch?

It's a bit difficult to pinpoint an exact commit.

Probably the roots of this bug could be found in aaa00cc93c1d0fd2693a ("scs=
i:
target/core: Fix TAS handling for aborted commands"), you are the author
of that commit btw.

But at the time (we are talking about 4.x kernels) the abort mechanism
was working in a different way, target_abort_work didn't even exists and
target_complete_cmd() was quite different...

Maurizio
