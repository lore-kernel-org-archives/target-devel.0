Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7728265CA6
	for <target-devel@vger.kernel.org>; Tue,  9 Sep 2025 22:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757455781; cv=none; b=I7gegTfgJTcZ/iB6NncjcV4LdgHPvvsyvuLenDYu3ThrDUB417d9fDcyOlJzGPbq999/26Y6O9+zGnM8nCRKPBWdR8t3CJ69mAX4wIgwg6XtYrh5d3EjDGj1UhVDbcl/DOUmcILWnIT3FPlyBJALHITDQWxgoWdXeyFuyAIhV9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757455781; c=relaxed/simple;
	bh=Rl85ifHTqqcOljpR5uWWgDGTzWdXobghNEGRkdP76KY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=j3t/GnfLAn5HfybFldVc4CtsS9NjLpQokJrHDu14vUbLCI4sS4q8lkTSQfaQ13X0S3oD3TIoD9a8e/6cUGxQJyxgTMxjBJ9hwIxOQ1Zx8fl1W6MKRpPh3YqQXDhDQpTbNGbSuBCYcpyZGpq10uBu7MueYJ/iiQwfgEnJxTTWb5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TzMswMtw; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TzMswMtw"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e9d6cb1df67so4555056276.1
        for <target-devel@vger.kernel.org>; Tue, 09 Sep 2025 15:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757455779; x=1758060579; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XmJ5o+jPnqmlOrUzy3HJkAfKFx97iJc4+bwh0bc73yY=;
        b=TzMswMtwKFYpxuG7MGPp5IWu3C/gPtGaHvjCi3bmfyi1/WoJl5ceBqIAqcoJEpK6q6
         /R3o+hXqQMYOWSjjsr3oH22HUv5VWIZdMzUFw5Wzu6/jCIM1CRCAd17zYvTqJSXg/Cf6
         7ZJ7HN5yAoVTi7jU3bC4t3UBEtcEIm5Ve4aYjVHNf+vyJDrGBexhI+H5RhcYxYns/B5W
         qYv2jYeXRdOZHwU9lYhryqcwVifw5ON6BbduzOH5EkzNqSVYZrErKUSozy69cX1mWlec
         gfgkRyQBMwEJ5nniYHk5Vlbk+AVZCJTZhdAacMJ140rcDrEaONVHAN1jvLE67Ynzt2ha
         bEjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757455779; x=1758060579;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XmJ5o+jPnqmlOrUzy3HJkAfKFx97iJc4+bwh0bc73yY=;
        b=maGPgS42FT4Hp86yPGwvIB+AC9GGOR8sfOHszkcR/P/POo3Kg8Gi5cCWpqaxV/p7h9
         NmONpeMbcXbX1pgC1C58ajVqGn40IeMhZQHaKeP3DToqwAATIy76hJ0a4pVqBGfcnQ/g
         2sypcLC6gwCUKQYT3v+6kyQAjD5+FGCJ6pa4ElzP1cMYm9r2ka5UG9gegviUR7ytNjwS
         y7s77TocltZ6synDm6s952r+rzFB5lEluVNj8jX6l0vouG1f+DTCpt1kHVVjVnyD6ciJ
         jcXzUk9VIVYsB5EmL5cKImp2JECLt1NsayuQzab9qEdqaCsdUV1HHzqlvpMbW2D02FRZ
         +6/g==
X-Gm-Message-State: AOJu0YzkQbjmHYWhfX4IL4GtBfn2kNTZFhlkWCFclWGmKcQHFlnh7nF9
	m8A7Rkr78KwyYmXhQhynQyGyjINhqQ6A3r+42uNE2xzuXO03yY7WOEXQogQr1PSuvQVMvE8hVdO
	wsQLPtVcwcCKDsVrSn5qtsQUkQ4REMFQ=
X-Gm-Gg: ASbGncuO3Z2xjNPquN8jEULdifS/tPj5YIbGCb9xxVXZGeLSu4Q59K0wM7bQcjRpuae
	vaNRC8es8Ip4GbSNnzsdpQfkRBAS1QmDac/Dbv76XKjRwyv6xY3ztdBysbH2n1Y68DWmKKj9Zsn
	AM2OOQTjVq3dkfjxnLib72rydIB1xjypWIRYepVN9Z5a22WtAQ8pb4jsNAq+ljhbg5XKWaTKbHh
	7fWcuHaRyWQPT6n9VQArbnCOQzI3x50xu2Q5jljfG4tb6+kCla9dBn7QMetzg==
X-Google-Smtp-Source: AGHT+IFqNLkC+jmXhcN3ReNLmiASziY8GQzbu1BJxMjJ7N26Xo+bVXvGXy5YOxms8UmrenvJkTKUPDHd82QRK/PTE8U=
X-Received: by 2002:a05:690c:fca:b0:72c:2eaf:1cc0 with SMTP id
 00721157ae682-72c2eaf361amr50796687b3.23.1757455778642; Tue, 09 Sep 2025
 15:09:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Davy Davidse <davydavidse@gmail.com>
Date: Wed, 10 Sep 2025 00:09:26 +0200
X-Gm-Features: Ac12FXxpG4DYXH2BN4T5ajRp3bT0waYrA9jzpYOUgyBROKwgeF818Nlj_rCkAcs
Message-ID: <CADzRqdBCLjA=6nLxUivDm=hA5vkfkMiE+BmC_zKtA2DCUxu2Dg@mail.gmail.com>
Subject: [RFC] target: Support for CD/DVD device emulation in fileio backstore
To: martin.petersen@oracle.com
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Dear Linux SCSI Target maintainers,

I'm writing to discuss a limitation in the Linux Target subsystem regarding
CD/DVD device emulation and to gauge interest in addressing this gap.

# Current Situation

When serving ISO files via iSCSI targets, there's a significant behavioral
difference between TGT (user-space) and Linux Target (kernel-space):

TGT behavior:
- Supports explicit device type configuration for ISO files
- Presents ISO as TYPE_ROM (0x05) SCSI device when configured for optical media
- Windows recognizes the ISO as an optical drive
- ISO appears in File Explorer as a mounted volume
- Can be browsed like a regular DVD/CD

Linux Target behavior:
- No device type configuration available for ISO files
- Always presents ISO as TYPE_DISK (0x00) SCSI device
- Windows sees the ISO as a regular disk in "diskpart list disk" but
not as a volume with the type DVD-ROM
- The disk cannot be read by Windows

# Technical Root Cause

The issue stems from the hardcoded device type in
drivers/target/target_core_sbc.c:

```
u32 sbc_get_device_type(struct se_device *dev)
{
    return TYPE_DISK;  /* Always TYPE_DISK (0x00) */
}
```

Both fileio and iblock backstores use this function, preventing any form
of optical media emulation.

# Comparison with Existing Solutions

User-space alternatives like TGT provide this functionality:
- Explicit device type selection via command-line parameters
- Full MMC (MultiMedia Commands) implementation
- Proper SCSI device type presentation

Kernel infrastructure already supports multiple device types:
- pscsi backend: Returns actual device type from underlying hardware
- Core SPC module: Contains TYPE_ROM handling code
- SCSI subsystem: Full support for all standard device types

# Request for Comments

Would the maintainers be interested in accepting a patch to add configurable
device type support to the fileio backstore? This would:

- Maintain full backward compatibility (default to TYPE_DISK)
- Enable proper CD/DVD/ROM device emulation
- Bring kernel-space target capabilities in line with user-space solutions
- Address real deployment scenarios currently requiring TGT

As someone primarily focused on high level coding languages, rather than kernel
development, I'm hoping this RFC might inspire a kernel developer who sees
value in this functionality to take on the implementation.

Thank you for your time and consideration.

Best regards,
Davy
