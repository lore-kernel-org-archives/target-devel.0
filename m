Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A24A944;
	Thu, 10 Jul 2025 02:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752113775; cv=none; b=e/VIH/Iwt54kwKYRYWieqQClQxWhoejJUQx4V5SISVAUWQu1XrZac0zd1kSDhATDp9y5FVzND1eiq0RHH/GHsgVtAnXVs2cwRtnh3fFwzdGDzD4L8RMa+bilEhhX/64bApJpanvkQDHhxEm9mYlRv8p7CvLHC9Usf2xJeHdQgXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752113775; c=relaxed/simple;
	bh=X4L1nD935TtqtjLGzfH+gCd2GumkvcMnXiT7Ep4Y1tY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=ZGsJrd58BJ197Ui0AJefEuChB7ty+g9U1kzbaw1HJF824oU4Ul81AfcdOgPaX2nCpE8tmBeUYTNCmme4yQB9CylYtzpuMtlSKvYZZyU+pVPH/vB5QufNL2p0+P8kEYGNaSy/UG0hAeGPY4l7jzmexZSw5Xp7EU1q63Ixvv5Fcg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=atKnPYqi; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="atKnPYqi"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6ecf99dd567so7946906d6.0;
        Wed, 09 Jul 2025 19:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752113773; x=1752718573; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ERuvWwAALNRbWeIGzNOKgbzogbmWSGtRZ1bueyDFv/Y=;
        b=atKnPYqikeszvitJYqWJMCJZZn1to/bDD0g+DNMwaV4dPdiUfPvxMKujTStGFIxVal
         zb7ksLpBZ9uvXo873KXZkwj+ghSO+NhdqFTa1pmW52c/mewI+wJlFSLc16hPdJemshgy
         c7zIImMRrW/gapiHiIYZ29BnKMnROWJMTPAht6S+CJytXgdBB68GHmdpGxbvJ7HgPj4p
         /qFyd3Qh1oZTXZUoU8KXHQyr9Yc2Is7iXfD8tO/9Dwz7y/jZbcf2D0/QYqqq9qrpef3T
         Je2ml5YdfW2hbBzpyCrwvCzs/auks9Uz4PIAJrGAKuG1v2Y/cSo7FwQS/ifFO5RUE9u4
         +p6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752113773; x=1752718573;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ERuvWwAALNRbWeIGzNOKgbzogbmWSGtRZ1bueyDFv/Y=;
        b=t/TPc0R40nAewHZYcisIS4pO8eCgft7U2BZteG/i04ngCRknOJCJsSpDj+R0i36q8t
         rm/Lw1gTkwKlIcFzgazT0QeYOiC8uYA7RIkMl9+QfOvKV8fWSQoAHaGBU9B0zxNZ8fG1
         JqLzgGgSuxmcgC3Ew7sSfwNkVIcCOzzlbwU9EDhEWtMaLdjEEj5zO8NhnjqoQjRo9+a+
         atSUgzSQY6O1L9vOKWoeBsHm6RWTNePSzsICwvhxTeeyYfzZVZv5ZEGpRaFbCUHiQVtw
         nH0RlYcotOdb3TXf9Ryg+vA/JDWf7AcdN8HYOg9HekVU3t0T7ivfANvxF4gB9zZraHBl
         U/cQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXmU6qzuwb4U7HGniWSl0S+r7zbHioPJrIKUlU236aKtVaIrAbUb3Xd/L4vYfcBMqwPOw1HrpqO285LTc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGxbwYBXZHVd1yC4BshtTnQjkJUtdSyp4MVAsxPS7hXHyYp32Y
	pr35hVxHuxszhzqprFUtRfwIziA8O89BfjDXQyvIo4IWKuuLze29mKckwuNjigloB9PZQHYXPC7
	3/5KmKtr0QLPpaX04QKFnY867rpzOZRjlZGdtFH8dhg==
X-Gm-Gg: ASbGncv9ebkIRXxAU4RgadsnWseuWTJ8cjajip/sNK0pA7K+9qAH53j/REqx+q7//Ew
	gLR02pUPn3XZhyWO1XbKOj0emz4RbrGsw98AzHdxh/gfDsBUYbYCesqAbO2nttsaW4l0uDIIdyF
	ExB2gcsbc3wCY0XIg9febZvNsWFriDCcMSAAjSwHb/YArLBpyf4aHNZEJk7r6wMq+QJdaT4yV6Z
	GeTgkxVVcy+JZkF
X-Google-Smtp-Source: AGHT+IFShdSq7Eo8+srNx4XT1FX5k6J8whHP5ca/B4ciURotS/ruYAhZrYUFzNd8FXmzgFwSoT+4lK9RmFXfBIBNJYM=
X-Received: by 2002:a05:6214:5991:b0:704:7b9a:8515 with SMTP id
 6a1803df08f44-7049831d59dmr13160486d6.38.1752113772973; Wed, 09 Jul 2025
 19:16:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Wang Haoran <haoranwangsec@gmail.com>
Date: Thu, 10 Jul 2025 10:16:00 +0800
X-Gm-Features: Ac12FXw9CaBpu43ZVWqY-zMTHeUosS8BzIEyjcIUCAbwm39wBr-IN4NwIWUlVeY
Message-ID: <CANZ3JQT825NXA16wequ3YPP-StVGVVQQm0DgHuCk_ZY=aG20kQ@mail.gmail.com>
Subject: We found a bug in target_core_configfs.c for the latest linux
To: martin.petersen@oracle.com
Cc: target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi, my name is Wang Haoran. We found a bug in the
target_lu_gp_members_show function located in
drivers/target/target_core_configfs.c in the latest Linux kernel
(version 6.15.5).
The function uses snprintf to format a device path string into a
fixed-size buffer buf, which has size LU_GROUP_NAME_BUF (defined as
256). However, the device name of
config_item_name(&dev->dev_group.cg_item) can be up to 255 characters.
When combined with config_item_name(&hba->hba_group.cg_item), '/',
newline, and null terminator, "%s/%s\n" may exceed 256 bytes.
Since "snprintf" returns the total number of bytes that would have
been written, the return value cur_len may exceed length of buf, and a
buffer overflow would occur when executing memcpy(page+len, buf,
cur_len);
Replacing snprintf with scnprintf ensures the return value never
exceeds the specified buffer size, preventing such issues.

--- target_core_configfs.c 2025-07-06 17:04:26.000000000 +0800
+++ target_core_configfs.c 2025-07-09 18:43:05.926386901 +0800
@@ -2771,7 +2771,7 @@
  dev = lu_gp_mem->lu_gp_mem_dev;
  hba = dev->se_hba;

- cur_len = snprintf(buf, LU_GROUP_NAME_BUF, "%s/%s\n",
+ cur_len = scnprintf(buf, LU_GROUP_NAME_BUF, "%s/%s\n",
  config_item_name(&hba->hba_group.cg_item),
  config_item_name(&dev->dev_group.cg_item));
  cur_len++; /* Extra byte for NULL terminator */

Best regards,
Wang Haoran
