Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8473B52E1
	for <target-devel@vger.kernel.org>; Fri, 22 May 2026 09:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779443801; cv=none; b=BVneDRjNdOGFy6aVZ1wsfAHaZSY4FjYF4iF+8/K/0xrjbsgguCb6OMlGqbu6w392YuzsRjCfitNaAu6Fl3eUxd6ExHUqqr8JSB44aSAboknjebYT8B/wNFsg1hqV5IFvdPo3l3ySFeStrnIDXTF6nupcrwF+DFaSDe+yj4f/aPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779443801; c=relaxed/simple;
	bh=+9CkvQvwITcHVUaiqsGONkFkiD8T7xTmKd6scWLoWao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gslVn9dI9UX0JwFYBomqdxhKwOWP/vN5TOQePc5eN+qFzcRLXqk40lYg2NMtQhbAqWjA3e2OyW9fLFAAp+fILoObMMnacAGuC4DHSZqPnSq8IAiTLabXBTcTZOkG5sqZ5FjlTlBlkJQiheQG1wu07S8V8KFBbYp1HtlxNZsPpW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BW84dCJB; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BW84dCJB"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5a85b30dd54so7683733e87.2
        for <target-devel@vger.kernel.org>; Fri, 22 May 2026 02:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779443798; x=1780048598; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u8y63JRIZrYdcs199ekWdJMzEhRGTikpYaZ3eKttq4U=;
        b=BW84dCJBX1gMHJS+u1ZDWod+KbJ0Eo5R5ziRIeKClZ4tRGBdQP1zH4vgPhkx/hIEBn
         hsbaexZCSuURDhXycLRNRDJcm8PmDve3M+Oq+VNaOX8yElHr6agHKiDTCyQeubO3yURM
         QiTJ5vdwFhR5cebj6MpJIMd/cz367C9teECI0TbeipFadJw5xkB4NxOyD98KJ50KJWSU
         tPXRkWeAGw1p6YYnulCAuMqe3xfX8HgmGYpvV23m8ZZr9lZrejl65LERVZAlD6TlrW5Y
         4YsdzKVouHrMl+X17ukvywJG2haLCZOE/hlZNdze5AAQEbHz69OXfGhZsR8nTDk5yw/8
         3v1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779443798; x=1780048598;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u8y63JRIZrYdcs199ekWdJMzEhRGTikpYaZ3eKttq4U=;
        b=KfP6BRyLTvMPQkpFpPpdRlyvBcKKsEhg4/9n6dyigBUWQ8x8sEdAAKpRw3XDszGt1U
         dfxv3IkhrCeOIB98EeYwD7twVC9lSL92ZXaTOY4fnQnAaBSSzytFPsrL2TccZRfrEF46
         gvViGbs5N8YEQdTiRYJgiwN7NZVAMZUCRM3OpfIQHmlEy8tO+pVM7saH+Bukikh5OMH0
         MV1ILrNBBd03TsulyLMXQNfLfz2MKiDqqVGfL0ygdsIHaZM0NuKy59Fw2TpX83Q6+3Kh
         K3U2Qbng8lu2x2oSF9j72vQbEODt13u8wix4gTJNGvrj3jA3C2tpZscV9uZqYyR4SNa9
         CcHA==
X-Forwarded-Encrypted: i=1; AFNElJ84PMoNTlP9Fy+tNsqgyNIucMnCxjlrFgbx4MANab96WoUXIWX7bkAMDl0QUICaU1hZf/yKYEMG8bCmhGc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8mfPCrL/LmMk1v1K959l/uJkdXY+Yik0GlTqTjudmfBGKPbGp
	d0TN0EXseNMUjvuxmrqeJOCglviTpnPYVkXAl/7zDGpX/2k6E4kaGMrigd+UvQ3gAfVAyMufYsR
	WoDIuJB0=
X-Gm-Gg: Acq92OFt7mGmiEshOEmu05TZPZupMx8N68k/3JutG7dOb3zei0aMLOAv7UmESheGvrs
	LIg9p4QUgijKyslIIduQHn9OesxLC0z7JBmZQjF3y+aKIasPZIbb3n/vQKSyARGauFamw0uGzA5
	UyhZlLFWKwRBJu9Bw5lwq0vfbkfYTIR6PitY4+HdxolTwPYajHMlw9i1MtRcbf+c/Nsrg1H33Xz
	o+eTtxoBmAVTuuaG6qMCnxOndcBYOSNN0wCN+WWQg0XdDEPEAfMRwbcHyVKXM4e5bwVlndir0dI
	hMf8SX3baMyzAta34Sb22Wph2fvwMsbb/vLY2N/7m9KKdYez/jNwP3vsu3j9eF18JmODbEtPlmQ
	DBfu0SbkIazbIYtMK6AD8FOHme4I6JuzQapGz8u8cY5VxOLobvdIjgAaHKSAFkgukz3GI527+7g
	TWTOcLX079aQ7pC6OqYybYxDIbZSM4v7a8MhNfUEMFXGSDc0Sr/BI4zFkcUb5fJxQyJUdjUX/8t
	/T97PcU9BcPnY8i
X-Received: by 2002:a05:6512:694:b0:5aa:30d8:3281 with SMTP id 2adb3069b0e04-5aa3237d71amr867452e87.32.1779443798393;
        Fri, 22 May 2026 02:56:38 -0700 (PDT)
Received: from [100.64.15.206] (h-158-174-93-34.NA.cust.bahnhof.se. [158.174.93.34])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa32cf95c9sm298531e87.78.2026.05.22.02.56.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 02:56:38 -0700 (PDT)
Message-ID: <430612f0-53f6-49bc-acd5-e69df3b330da@suse.com>
Date: Fri, 22 May 2026 11:56:37 +0200
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: target: iscsi: validate CHAP_R length before
 base64 decode
To: David Disseldorp <ddiss@suse.de>,
 Alexandru Hossu <hossu.alexandru@gmail.com>
Cc: martin.petersen@oracle.com, bvanassche@acm.org, mlombard@arkamax.eu,
 target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
 stable@vger.kernel.org
References: <20260518121811.385350-1-hossu.alexandru@gmail.com>
 <20260520165259.272808-1-hossu.alexandru@gmail.com>
 <20260522003800.2323e11a.ddiss@suse.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260522003800.2323e11a.ddiss@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/21/26 16:38, David Disseldorp wrote:
> On Wed, 20 May 2026 18:52:59 +0200, Alexandru Hossu wrote:
> 
>> chap_server_compute_hash() allocates client_digest as
>> kzalloc(chap->digest_size) and then, for BASE64-encoded responses,
>> passes chap_r directly to chap_base64_decode() without checking whether
>> the input length could produce more than digest_size bytes of output.
>>
>> chap_base64_decode() writes to the destination unconditionally as long
>> as there is input to consume. With MAX_RESPONSE_LENGTH set to 128 and
>> the "0b" prefix stripped by extract_param(), up to 127 base64 characters
>> can reach the decoder. 127 characters decode to 95 bytes. For SHA-256
>> (digest_size=32) this overflows client_digest by 63 bytes; for MD5
>> (digest_size=16) the overflow is 79 bytes.
>>
>> The length check at line 344 fires after the write has already happened.
>>
>> The HEX branch in the same switch statement already validates the length
>> up front. Apply the same approach to the BASE64 branch: strip trailing
>> base64 padding characters, then reject any input whose data length
>> exceeds DIV_ROUND_UP(digest_size * 4, 3) before calling the decoder.
>>
>> Stripping trailing '=' before the comparison handles both padded and
>> unpadded encodings. chap_base64_decode() already returns early on '=',
>> so the full original string is still passed to the decoder unchanged.
>>
>> Fixes: 1e5733883421 ("scsi: target: iscsi: Support base64 in CHAP")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
>> ---
>> v3: strip trailing '=' before length check to handle padded encodings
>>      (reported by Maurizio Lombardi)
>> v2: use DIV_ROUND_UP(digest_size * 4, 3) as suggested by David Disseldorp
>>
>>   drivers/target/iscsi/iscsi_target_auth.c | 11 ++++++++++-
>>   1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
>> index c46c69a..00487d0 100644
>> --- a/drivers/target/iscsi/iscsi_target_auth.c
>> +++ b/drivers/target/iscsi/iscsi_target_auth.c
>> @@ -340,13 +340,22 @@ static int chap_server_compute_hash(
>>   			goto out;
>>   		}
>>   		break;
>> -	case BASE64:
>> +	case BASE64: {
>> +		size_t r_len = strlen(chap_r);
>> +
>> +		while (r_len > 0 && chap_r[r_len - 1] == '=')
>> +			r_len--;
>> +		if (r_len > DIV_ROUND_UP(chap->digest_size * 4, 3)) {
>> +			pr_err("Malformed CHAP_R: base64 payload too long\n");
>> +			goto out;
>> +		}
>>   		if (chap_base64_decode(client_digest, chap_r, strlen(chap_r)) !=
>>   		    chap->digest_size) {
>>   			pr_err("Malformed CHAP_R: invalid BASE64\n");
>>   			goto out;
>>   		}
>>   		break;
>> +	}
>>   	default:
>>   		pr_err("Could not find CHAP_R\n");
>>   		goto out;
> 
> 
> This looks a bit fragile, but moving the overflow check into
> chap_base64_decode() probably won't make it any cleaner. I'd like to see
> a comment or build-time assert in the mutual CHAP path as to why the
> length check can be skipped there. Aside from that I think it makes
> sense to merge this.
> 
Please, no.
The length check should be part of the chap_base64_decode() function,
which should reject inputs with the wrong length. _And_ you need
to add a 'length' argument for 'client_digest' such that the function
nows the size of the output buffer and can avoid precisely these
issues.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
