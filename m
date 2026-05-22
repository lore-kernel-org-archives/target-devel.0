Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27423CBE78
	for <target-devel@vger.kernel.org>; Fri, 22 May 2026 10:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779446270; cv=none; b=JhDa7jyOLbgMrzp+zkJ4KKtPvzhXnZJ0J6nx3LnGcBH9gyoKFRlouNjdpBNhUstmDZoRhIWNvYW+iJK75ykkcD57xAB7WNOux+k2z/lvwF3XV3KxuAJy9ZiOYFUkOhlh3Wwf5P6WyUBFNVYaVXVQad6g3ctLjq+OrHW1sEMdi1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779446270; c=relaxed/simple;
	bh=Ac4xnvnmTYeA2XO6wouWeRbpqTgtkLKatItCecIHYT4=;
	h=Message-ID:Date:Content-Type:MIME-Version:From:To:Cc:Subject:
	 In-Reply-To:References; b=CltLr4csn+yRCu/Q+9TmLc3n1+jTQJ32oqkXh6AchFRHU1V5hnwq3PGQUT2eJhcVa2gy2uXv9hfDVnI4JobHECpjmCti5HkKLgfWubgUXb8BXfl21dXH4ufPeWvdcYIZQWgi4Vui3J2Kt/FGcjxseXtGBCASqMZsUjkpo0GbGRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WeCtiRxA; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WeCtiRxA"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-67c1e0229acso11863666a12.1
        for <target-devel@vger.kernel.org>; Fri, 22 May 2026 03:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779446263; x=1780051063; darn=vger.kernel.org;
        h=references:in-reply-to:subject:cc:to:from:content-transfer-encoding
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ac4xnvnmTYeA2XO6wouWeRbpqTgtkLKatItCecIHYT4=;
        b=WeCtiRxAUjVZYBIekn+j1tAurP+BrWtiwvGaNBZipS8+QFOssLnwSqA7dp4ORSHLaI
         qp/Itfe2Ykr209UNxoaofgWMsaoQ3ovf6ffaOjf1jcUZKU23jrEcIo9MP/1TBhOmxFSB
         dG15VTtVs9hCTwfouO2YGZEES9Y5x44IyaUXl7ZAIQD4cZi3uYLtrRlCEc/5HIz9tihk
         VqJTq7UW02McmuadUmWBY7l/YUCy0zsj4PP1EQP3Dbfly/p7kqUR2U+LykQfDBR0Eltt
         /iCQsavaBMSTpqPyQe98sRjsoSfAiCaPNmDXPOHpev8lQzDu9vfXRJzEpdVnwJb8bh2h
         PUzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779446263; x=1780051063;
        h=references:in-reply-to:subject:cc:to:from:content-transfer-encoding
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ac4xnvnmTYeA2XO6wouWeRbpqTgtkLKatItCecIHYT4=;
        b=gSBlh/Fqo95A8SYq9O/IDPsKVNUdMWnr9ymgaYjcayGeqkSEgeHpRpOm6+4o+iNFiF
         9IYdABrb51xJrY1sxLEw21KENYFORA/rP6k4DSe2GNNwZZLpGRzqB0Nz1KAaI0i8lCz7
         oqV/PvuMlO7oKrjmSWSwHzm6f0drqS+rjDtRNT1F2gr9nDOAdEVCi06FEK518s7LRSXy
         Qtu5lKRE1COVpYo71+YvN2vZY0jMVU1WnhizcTGclsPAZFidUVEGnpL7BsUubGwWqf6/
         4YoV06ji5rBeURrXaGQy4aw0dFIDPVvF3lo2CCADkDHXm/Y5KaXLqSfZkVF+iogTaA0u
         hcvQ==
X-Forwarded-Encrypted: i=1; AFNElJ9n/bHaU8ECt1Vl3gmbaDNfYHi/ftRt30x7j7pOJGq8HrKIS7hTkpSSnJ9Gz6pEibJDfyjpRjfIvcOaw1c=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywsqm06L88TJBZ7iEZDLgr77LHRHFhCgNznp8vlnAtn8A8gyMI0
	vTInrX0GI7pI741SLXpid78DhjRwph5JSo/tH80M7l2iVNGOGt8OrHc5
X-Gm-Gg: Acq92OHY2WSHta1OzYpni+r4pgd6/fHkrsELFux3YeK++FkFF8t8dqAnARbfueuqhdt
	D2aOH2aGawz3UdOKo4S5ViGYbpvSVZIxKHqmrPiJs1IGGGk4axdn6HRJogwghz8xnc2/d/EHoM/
	VNECmkZpaY8EZUe+9D7AnE2OCxzCLHjvB4k1zbstwf8WIhC46TJqvNDK5gBiqp/iL1hzJPEKB8d
	F+q6C56HSkg7qLDrGZsT9M0UVNiIV/qM99xAKSuE8mi48bnH09oMvdG5O+NU6cjZjDkHtfTWZCu
	VQdeB7gJ3wGh0dlAl2osd/mfSr7Q7CwL3CXV9e3AQdmhsa9hlMtqpH59Iwf6JdjvMDvW5ff42Fd
	+DVya3RBshhNxUd+cG474K6CKZ4ywktvRGXHbP4fl1XZD+2GFOOejhT89gw2yaTNEAvVUx3GCdN
	dGEhIBHOlJ3p/4Ls7zVvaYO4QcXVzctaYaZpOoiZTAgoPWPpIlxeSPP4FQwDmh+hX2WAxbxwCQH
	lbk4QL1GFCsDzOL82lrbfTTVD305nWeuK/SRrkIsPdLuFqBm4dc/Inf/bEAqHRimtBrODDK1pjQ
	pP2xM/LFtmnKgJ6N0+gHcbRw/SWg
X-Received: by 2002:a05:6402:1cc9:b0:676:d8df:f8c1 with SMTP id 4fb4d7f45d1cf-6889cc544b4mr1427718a12.22.1779446262781;
        Fri, 22 May 2026 03:37:42 -0700 (PDT)
Received: from ahossu.localdomain (ip-217-105-56-94.ip.prioritytelecom.net. [217.105.56.94])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-688bb62b6dfsm513385a12.30.2026.05.22.03.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 03:37:41 -0700 (PDT)
Message-ID: <6a1031f5.e5f1cd4d.398bf4.edc9@mx.google.com>
Date: Fri, 22 May 2026 03:37:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
From: Alexandru Hossu <hossu.alexandru@gmail.com>
To: Hannes Reinecke <hare@suse.com>
Cc: David Disseldorp <ddiss@suse.de>, martin.petersen@oracle.com,
 bvanassche@acm.org, mlombard@arkamax.eu, target-devel@vger.kernel.org,
 linux-scsi@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] scsi: target: iscsi: validate CHAP_R length before
 base64 decode
In-Reply-To: <430612f0-53f6-49bc-acd5-e69df3b330da@suse.com>
References: <20260518121811.385350-1-hossu.alexandru@gmail.com>
 <20260520165259.272808-1-hossu.alexandru@gmail.com>
 <20260522003800.2323e11a.ddiss@suse.de>
 <430612f0-53f6-49bc-acd5-e69df3b330da@suse.com>

T24gRnJpLCBNYXkgMjIsIDIwMjYsIEhhbm5lcyBSZWluZWNrZSB3cm90ZToKPiBUaGUgbGVuZ3Ro
IGNoZWNrIHNob3VsZCBiZSBwYXJ0IG9mIHRoZSBjaGFwX2Jhc2U2NF9kZWNvZGUoKSBmdW5jdGlv
biwKPiB3aGljaCBzaG91bGQgcmVqZWN0IGlucHV0cyB3aXRoIHRoZSB3cm9uZyBsZW5ndGguIF9B
bmRfIHlvdSBuZWVkCj4gdG8gYWRkIGEgJ2xlbmd0aCcgYXJndW1lbnQgZm9yICdjbGllbnRfZGln
ZXN0JyBzdWNoIHRoYXQgdGhlIGZ1bmN0aW9uCj4ga25vd3MgdGhlIHNpemUgb2YgdGhlIG91dHB1
dCBidWZmZXIgYW5kIGNhbiBhdm9pZCBwcmVjaXNlbHkgdGhlc2UKPiBpc3N1ZXMuCgpUaGFuayB5
b3UgZm9yIHRoZSBmZWVkYmFjay4gQWRkaW5nIGEgZHN0X2xlbiBwYXJhbWV0ZXIgdG8KY2hhcF9i
YXNlNjRfZGVjb2RlKCkgYW5kIG1vdmluZyB0aGUgb3ZlcmZsb3cgY2hlY2sgaW5zaWRlIHRoZSBk
ZWNvZGVyCmlzIGEgY2xlYW5lciBhcHByb2FjaCBhbmQgSSBhZ3JlZSBpdCBpcyB0aGUgcmlnaHQg
ZGlyZWN0aW9uLgoKdjQgY2FycmllcyBEYXZpZCdzIFJldmlld2VkLWJ5IGFuZCBmaXhlcyB0aGUg
aW1tZWRpYXRlIG92ZXJmbG93IHdpdGggYQptaW5pbWFsIGRpZmYuIFdvdWxkIGl0IGJlIGFjY2Vw
dGFibGUgdG8gbWVyZ2UgdjQgYXMgYSBxdWljayBmaXggZm9yIHRoZQpvdmVyZmxvdywgd2l0aCBh
IGZvbGxvdy11cCBwYXRjaCB0aGF0IGFkZHMgdGhlIGRzdF9sZW4gcGFyYW1ldGVyIHRvCmNoYXBf
YmFzZTY0X2RlY29kZSgpIGFuZCByZW1vdmVzIHRoZSBwcmUtY2hlY2s/CgpBbGV4YW5kcnU=

