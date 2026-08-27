Received: from arkamax.eu (128-116-240-228.dyn.eolo.it [128.116.240.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2904156DA
	for <target-devel@vger.kernel.org>; Thu, 27 Aug 2026 10:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.116.240.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787827085; cv=none; b=e3U3THosdLz2B8XiCvYuUKgXTuhibXWDCOETgqlsaiHwtpsY7PVhkZsXqWXJGJVv8l0cmCqCXsjYavKragNWNVUMxUgVw5hOuBBNMrogmZ2NbkTS3KeQCYUQTLcquxS8/wNMcIdx7MKJDaaYpaP2vmu6+d+oFzUFhipyUYv4vD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787827085; c=relaxed/simple;
	bh=IdCiDqZkTR2cDd1ON7dY9SYuEzk6Fp9TqPYUst3vaqI=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=kvs4jtLCcTpp5EcoUEk41HpEBidpo2vWz0BiWSUjds1BaEGJmvfW8MsD02oqkzRsHN4ujJ21ofh9inKdzRK7/aLo6cYV7VtKgGtrlqCWvtfvUNeuWRWfJTPKLS5kyBp85tmzDufttWELm4MrO4w7UHLk57yjgv8sCMSKkFN/d+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arkamax.eu; spf=pass smtp.mailfrom=arkamax.eu; dkim=pass (2048-bit key) header.d=arkamax.eu header.i=@arkamax.eu header.b=PrwcWsku; arc=none smtp.client-ip=128.116.240.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arkamax.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arkamax.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arkamax.eu header.i=@arkamax.eu header.b="PrwcWsku"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; s=mail1; bh=IdCiDqZkTR2cDd
	1ON7dY9SYuEzk6Fp9TqPYUst3vaqI=; h=in-reply-to:references:from:subject:
	cc:to:date; d=arkamax.eu; b=PrwcWskuRDuReUcTilSmp5oV4Iu+SdhWaU20nCsXI3
	BQAHz2Uq6KzwG7HpTdIv//iOIPRS425cEcSnuQas/Oceq2+14/l3g+o2pMhrhtmCCJnMy3
	e49quro7kv4p3/gt+eUBJOWjS8ABNl1TsNFA5O0NrnJjHYOI2h8+WyKoUgOk+YSHHw76qv
	tByxt7PqUVeYVUJfZY3nauc7yKDlOrzEb1UmlufVJ4BrSYCD/hCWRdoPKV6NZCbTX7dcsD
	A9f03zLKgUz2aGFONt7jK0JZ7GJwCbnMaEyJbgb9Svm4bCO1zaD7ieB7DAo8mh42rXwe1c
	/FPjnv8YCrX0OjGrqzpg==
Received: from localhost (<unknown> [193.207.148.212])
	by arkamax.eu (OpenSMTPD) with ESMTPSA id 5384c7ec (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 27 Aug 2026 12:38:00 +0200 (CEST)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 27 Aug 2026 12:37:58 +0200
Message-Id: <DKZNT1I9M241.G6SBI1ZO6UJK@arkamax.eu>
To: "Dmitry Bogdanov" <d.bogdanov@yadro.com>, "Maurizio Lombardi"
 <mlombard@redhat.com>
Cc: <martin.petersen@oracle.com>, <mlombard@arkamax.eu>,
 <michael.christie@oracle.com>, <target-devel@vger.kernel.org>,
 <loberman@redhat.com>
Subject: Re: [PATCH 1/1] target: iscsi: Fix hang for aborted WRITE_PENDING
 commands
From: "Maurizio Lombardi" <mlombard@arkamax.eu>
X-Mailer: aerc 0.22.0
References: <20260717143828.76291-1-mlombard@redhat.com>
 <20260717143828.76291-2-mlombard@redhat.com>
 <20260827093301.GA2638@yadro.com>
In-Reply-To: <20260827093301.GA2638@yadro.com>

On Thu Aug 27, 2026 at 11:33 AM CEST, Dmitry Bogdanov wrote:
>
> On Fri, Jul 17, 2026 at 04:38:28PM +0200, Maurizio Lombardi wrote:
>>=20
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
>>=20
>> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
>> ---
>>  drivers/target/iscsi/iscsi_target.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/=
iscsi_target.c
>> index 62ada3a52210..124ff269b8e7 100644
>> --- a/drivers/target/iscsi/iscsi_target.c
>> +++ b/drivers/target/iscsi/iscsi_target.c
>> @@ -1533,8 +1533,10 @@ __iscsit_check_dataout_hdr(struct iscsit_conn *co=
nn, void *buf,
>>                  */
>>                 if (se_cmd->transport_state & CMD_T_ABORTED) {
>>                         if (hdr->flags & ISCSI_FLAG_CMD_FINAL &&
>> -                           --cmd->outstanding_r2ts < 1)
>> +                           --cmd->outstanding_r2ts < 1) {
>>                                 iscsit_stop_dataout_timer(cmd);
>> +                               target_complete_cmd(se_cmd, SAM_STAT_TAS=
K_ABORTED);
>> +                       }
>>=20
>>                         return iscsit_dump_data_payload(conn, payload_le=
ngth, 1);
>>                 }
>> --
>> 2.55.0
>>=20
>
> Hi Maurizio,
>
> We also faced that bug several years ago. We solved it by removing all
> leftovers of hanling of aborted commands in iscsi, because the handling
> of aborted commands moved to target core an age ago. iSCSI will collect
> data as usual and pass the command to target core, it in its turns will
> abort the command.

Hi Dmitry,

isn't Yadro considering upstreaming those changes?

Maurizio
