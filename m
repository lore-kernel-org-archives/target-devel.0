Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C33367F5D
	for <target-devel@vger.kernel.org>; Thu,  9 Apr 2026 02:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775701433; cv=none; b=sZ8Ayjmtc+EU8ZNtrywyIR0TEBnH/o46BAzaBTL2Bh7kXZ210+0Mc9DwwSlFCZXsKlCE651yS6ZMZ0qRAaEx1u8S+KpZ9Y5V5c9aWF5PV84T4krH8s/QhwrJHPot3WU6qvG7nQfWjgWEECAjsT+9CLZs0OZSU7yvNk7DfyZG4NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775701433; c=relaxed/simple;
	bh=nw4pVaEcfm/QcpCg7nPjcfcAKQBAqQ4BkxPpfDJokm0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hjv5lBQ8phYIFPY84VqFD2qC1RpAZjFNmdsEy4YDvtV3LAuzhyhbzkQOsatOZJDAtffAzzTiJo/pS9RaP3pw6MSUs6oz2uPMC4lVYLHRvwoDntouwmRis/fcdxbjGMQTQcPj+NAG3BOjvUsEkX7i+8SmzdABKzdkSv3gMDKVpSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UDNXnHOv; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UDNXnHOv"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2d18dfa2713so185049eec.0
        for <target-devel@vger.kernel.org>; Wed, 08 Apr 2026 19:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775701429; x=1776306229; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2NjOcxpQYu8C0IWIdL6Safc6hHjGZNla//RS6XeIqKQ=;
        b=UDNXnHOvvynagP5E+ZiA+5Yhfw1tXvwhLgsnPv7fKIjuAww1DVVbXqeRhVh2r9urTZ
         R2XPGTlolJFs9TNAon+/vHkUYqcwTSM/GVhBHvw4Gci6nr9WDf2g0AUm44MHNSEV68Sw
         uss6o3aMFG2psihQ8p3lAsrGma9kB0TP9NZsnU7T+Y1FccLtk2O0EBDxBvevVNtlUSCF
         q3zgqPjjIuxsFHbSNNwPLysMzKZF4Iyi7G4QvYMHz9z1pd35tLh2mPOLuY8ZIsQPHCF3
         m10kVyAKAyydaKEC+Na92rBEnGP5tuYm5owqARrVKm0f2k/TzM6ufV1ap9/GO1qFxr59
         N+Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775701429; x=1776306229;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2NjOcxpQYu8C0IWIdL6Safc6hHjGZNla//RS6XeIqKQ=;
        b=DuASmbTMGWTvSWhxpAmCeiVbCDHYZe7ztlpCcXHoooSga3/0dIGEYeF+dfLaTXW3KG
         84aw50bB+m/6pV0m9invQKKm6kFUQEl49FlglP2nEu20OiAv9ZmDfgJTsly3w+73kI8O
         FUKtGfj6dkL+eGeA9ugiMax0Jul8L1S+2/Vx5SIVhQryIn25TRUk9HrJTp5YCZaxnhxy
         /AMrWQYIcSGrIiXtZLvAWW2OjTQuwmtKSe3qhauMWjd37bWonPQQpsUofFT2CrixfZ8G
         7b9g02k+YfBzjFs8RFmtwG30qv5HBjhK1hPoaR+iqjjzMTNqLTLZAcPKijMd2wuCBBa/
         wG3w==
X-Forwarded-Encrypted: i=1; AJvYcCXAWPoakOZzLdS7dI3rUcR6oU3ECT0N7TLy0H9et1NlpJYlpGIRR2P4GMUVtFo35QGO+WcdNaz2UIkZHlc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUbPLl72j2UGA1Jgu9rBZ+eXYhST/WsrZQJ5d1ekbc+YHd7K8x
	GY5ySTxoctO//vcV+CRSAU9pPl3IVuJOZS0zETGe6N6i15ND1qm0hNJu
X-Gm-Gg: AeBDievVA7zC27myw7Ksv44m1VKXFJ2hTkjZbqxx+2s+sJzypA8VknJppbIKU81tNOw
	8XwqynJ/D1otubOGYcQIaE+eP5pJBpN+XJp211fZQpgGcOrsePK0VtVSEz713ZRSbzQunNS2ut8
	hCWcnb1WeXSGgErwU7yPVIlQAfpm8NyMLPyCdWurlfItGOkRfIAICjSBRSUrZnKaXE+wPTwD0GH
	geHAcH4No8/Auzu/1gDteqhOQ3hTgUHdQPciQ72HhkBu0+x+cXXWL9VhmlY46B7/GkNeUNAMnaz
	NzJnAw6iaw9+Ff5IwmQtDIphpEP6ch+hxQTb4tDKVdb8RZctNkUtEgJdBd0Fxd7zfs9Z+ElLsI2
	WPF5I3LJMgQ+cWkmDPLoisjCxxsrq80zyqSuKva5kxpJP2muhSQTw4eZoCGPx/ezbkXeXFV8rKa
	eEDJU7SQ0jlELm2sKmTJJQCsq3We/B/WjvVFKmoeUU
X-Received: by 2002:a05:7300:371f:b0:2c1:6cfd:73ee with SMTP id 5a478bee46e88-2cbfc4623e3mr12849990eec.24.1775701429277;
        Wed, 08 Apr 2026 19:23:49 -0700 (PDT)
Received: from [192.168.86.23] ([136.25.189.61])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d2bc2c40b1sm6286634eec.3.2026.04.08.19.23.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 19:23:48 -0700 (PDT)
Message-ID: <2e0b621e-9d12-46e9-9595-7fb7e2885f88@gmail.com>
Date: Wed, 8 Apr 2026 19:23:46 -0700
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: target: iscsi: reject zero-length Extended CDB AHS
To: Dmitry Bogdanov <d.bogdanov@yadro.com>, carlos.bilbao@kernel.org
Cc: martin.petersen@oracle.com, kees@kernel.org, pabeni@redhat.com,
 mlombard@redhat.com, kuniyu@google.com, michael.christie@oracle.com,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org, bilbao@vt.edu
References: <20260404014429.115807-1-carlos.bilbao@kernel.org>
 <20260407092357.GA974@yadro.com>
Content-Language: en-US
From: Carlos Bilbao <carlos.bilbao.osdev@gmail.com>
In-Reply-To: <20260407092357.GA974@yadro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

On 4/7/26 02:23, Dmitry Bogdanov wrote:
> On Fri, Apr 03, 2026 at 06:44:29PM -0700, carlos.bilbao@kernel.org wrote:
>> From: Carlos Bilbao <carlos.bilbao@kernel.org>
>>
>> If ecdb_ahdr->ahslength is zero, two bugs follow:
>>
>>    kmalloc(be16_to_cpu(ecdb_ahdr->ahslength) + 15, ...)
>>
>> allocates 15 bytes, but the immediately following memcpy writes
>> ISCSI_CDB_SIZE (16) bytes into it, a one-byte heap overflow. Also:
>>
>>    memcpy(cdb + ISCSI_CDB_SIZE, ecdb_ahdr->ecdb,
>>             be16_to_cpu(ecdb_ahdr->ahslength) - 1);
>>
>> (u16)0 - 1 promotes to (int)-1 which converts to SIZE_MAX as size_t,
>> causing a massive out-of-bounds write.
>>
>> Reject ahslength == 0 with ISCSI_REASON_PROTOCOL_ERROR before the kmalloc.
>>
>> Fixes: 8f1f7d297bce ("scsi: target: iscsi: Add support for extended CDB AHS")
>> Signed-off-by: Carlos Bilbao (Lambda) <carlos.bilbao@kernel.org>
>> ---
>>   drivers/target/iscsi/iscsi_target.c | 15 +++++++++++----
>>   1 file changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
>> index e80449f6ce15..8db24d35c762 100644
>> --- a/drivers/target/iscsi/iscsi_target.c
>> +++ b/drivers/target/iscsi/iscsi_target.c
>> @@ -1100,6 +1100,8 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
>>          cdb = hdr->cdb;
>>
>>          if (hdr->hlength) {
>> +               u16 ahslength;
>> +
>>                  ecdb_ahdr = (struct iscsi_ecdb_ahdr *) (hdr + 1);
>>                  if (ecdb_ahdr->ahstype != ISCSI_AHSTYPE_CDB) {
>>                          pr_err("Additional Header Segment type %d not supported!\n",
>> @@ -1108,14 +1110,19 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
>>                                  ISCSI_REASON_CMD_NOT_SUPPORTED, buf);
>>                  }
>>
>> -               cdb = kmalloc(be16_to_cpu(ecdb_ahdr->ahslength) + 15,
>> -                             GFP_KERNEL);
>> +               ahslength = be16_to_cpu(ecdb_ahdr->ahslength);
>> +               if (!ahslength) {
>> +                       pr_err("Extended CDB AHS with zero length, protocol error.\n");
>> +                       return iscsit_add_reject_cmd(cmd,
>> +                               ISCSI_REASON_PROTOCOL_ERROR, buf);
>> +               }
>> +
> For a complete solution please add a check that AHS fits in the buffer.
> ahslength must be less or equal than ((hdr->hlength * 4) - 3).


For sure, I'll send a v2 including that.


>
>> +               cdb = kmalloc(ahslength + 15, GFP_KERNEL);
> It took some time to recall what did 15 mean. May be make it clear for
> everyone too?
>
> u16 cdb_length = ahslength - 1 + ISCSI_CDB_SIZE;
> cdb = kmalloc(cdb_length, GFP_KERNEL);
> memcpy(cdb, hdr->cdb, ISCSI_CDB_SIZE);
> memcpy(cdb + ISCSI_CDB_SIZE, ecdb_ahdr->ecdb, cdb_length - ISCSI_CDB_SIZE);
>

Agreed!


>>                  if (cdb == NULL)
>>                          return iscsit_add_reject_cmd(cmd,
>>                                  ISCSI_REASON_BOOKMARK_NO_RESOURCES, buf);
>>                  memcpy(cdb, hdr->cdb, ISCSI_CDB_SIZE);
>> -               memcpy(cdb + ISCSI_CDB_SIZE, ecdb_ahdr->ecdb,
>> -                      be16_to_cpu(ecdb_ahdr->ahslength) - 1);
>> +               memcpy(cdb + ISCSI_CDB_SIZE, ecdb_ahdr->ecdb, ahslength - 1);
>>          }
>>
>>          data_direction = (hdr->flags & ISCSI_FLAG_CMD_WRITE) ? DMA_TO_DEVICE :
>> --
>> 2.43.0
>>

Thanks,

Carlos

