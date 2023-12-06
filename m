Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cloud.com header.i=@cloud.com header.b="GHUvrzxG"
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB355199A
	for <target-devel@vger.kernel.org>; Wed,  6 Dec 2023 08:01:13 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-40b2ad4953cso6126895e9.0
        for <target-devel@vger.kernel.org>; Wed, 06 Dec 2023 08:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.com; s=cloud; t=1701878472; x=1702483272; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sEe2BGdVEyn8WqIfOdf4ZPwNt5gvQYVB5GInA5lvLMM=;
        b=GHUvrzxGXKl3OqjNfZUHZGzaAGoBa66YYZrIoy5YQNHk0Wsu/HwMPP52T9VXaZfSoG
         xoh/TEy/0dNicsJKoHAJKcGtM6Azl/uYXSMFAl29/fXZ/2hfRHjiDCzFdNJ8TA+JZPfk
         YHsqXMGbVi8H6GJCvHFoy84sLYlp8Ub4hy8Tg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701878472; x=1702483272;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sEe2BGdVEyn8WqIfOdf4ZPwNt5gvQYVB5GInA5lvLMM=;
        b=whxoL5d6adGXyXQgG2xekojGk9rCZFFoxPfgJWg79C/KQAlkBQhGu3aWlph/vegj8x
         Mxo5zJRAeNdG3QKZZLezEfqdXtSatCmHr/UJESfvtiTCRfEkhOC7wVYOavqXnIg+y0at
         zTys6wLTDna0eEuy2m5XONj+JxZnc9fIdugpVjWIeDKWJ9jGpsonFhoKDYQEqP5du5ZM
         mRoKiIW4ORAEMDRD9Zk5g5ZRCVb/fiJSF2lpkD8iNCsYwRJf06SXj5Bg/zWzrD2lJz/o
         37jpzG3UtcNdAppX/ZFNCs9ZbtEEHRZvtLyL/yba7MNZx5m8iOEDPpr9ukvu0wT1BeHO
         83uw==
X-Gm-Message-State: AOJu0YwK9D3CERVmk2FP7diJwXR3RMzlMsyYBDnRwJ75cLyzwifWywQ7
	ZXVtmX8dpy4pCDMJMBW3yU6MBgMVlRDvHN8/abYQBxbeMN8Tb/NIPAQ=
X-Google-Smtp-Source: AGHT+IF/LygHb2kPc/lhKZ9nGuacXMIUIieyW/RW8x2UXTMhDVjcg/o3SIXym5k24M0s7bp1jurTfIFxF5QQQwyoTrI=
X-Received: by 2002:a05:600c:4a83:b0:40b:5e56:7b70 with SMTP id
 b3-20020a05600c4a8300b0040b5e567b70mr1890444wmp.185.1701878471881; Wed, 06
 Dec 2023 08:01:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Mark Syms <mark.syms@cloud.com>
Date: Wed, 6 Dec 2023 16:01:01 +0000
Message-ID: <CAPYKksXn79p9mYyn0-qYYnmwaRZ0UdTa+VfaizmK+=1XA+gYog@mail.gmail.com>
Subject: Question about tpg isolation
To: target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

Got a possibly odd question. I'm pretty sure the iSCSI target doesn't
support this but wondered if it was something that could be considered
for future.

We've been trying to use the target to emulate a customer environment
that we do not have direct access to. They have a SAN which has a
fairly complex configuration. There are two array controllers, each
with its own IQN, each controller then has two TPGs each of which has
three portal addresses. So far this is all OK and we can emulate that
with a software target. Where it becomes difficult is when we look at
the responses from discovery. Each group of three portal addresses
will only return itself and the other two siblings, it will not return
the details of the portals on the other tpg or those for the other
array controller.

Our control plane software should work in this scenario but our
customer found a bug meaning it did not in all circumstances function
correctly. As part of producing a fix it would be preferable if we
could also create a regression test for this scenario to ensure that
after it is fixed it doesn't get broken again and without requiring
capital expense to purchase a representative SAN. Whilst the software
target can be configured with multiple IQNs and multiple tpgs and with
multiple portals for each tpg when performing discovery to any one of
those portals will respond with the details of all of the other
portals and thus will not trigger the bug that we have seen.

This is a little bit similar to
https://target-devel.vger.kernel.narkive.com/SyrmxKHS/lio-per-initiator-target-discovery-question,
but in our case we would be satisfying the ACL when contacting each of
the portal addresses so it's only the cross tpg discovery exposure
that we would want to disable.

Is this something that would be considered or is it just too specific
to a small use case?

Thanks,

Mark.
