Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IqpZ0VR4"
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8914D46
	for <target-devel@vger.kernel.org>; Thu, 23 Nov 2023 12:04:04 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-6cb90b33c1dso292720b3a.0
        for <target-devel@vger.kernel.org>; Thu, 23 Nov 2023 12:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1700769844; x=1701374644; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u/WfHWKDW3LuB/2tH5rrGpk3IkHtZyi5i7bzkP0nzIk=;
        b=IqpZ0VR4wjLxxY8xCWNegkoZpS10S+2UhaT/eAPWNkxofnOgmqjOE2K8Cz9GlmtR8Q
         tbxnjGEVO3Lb75AroPUo8c2tVOJX7HtA2UzGJnxLfkzi6XmW9AdNoDflyYw+mtNbDz/5
         WkgNkueKL8PzY4ZZi8CtcSLq9e2CBWQPdk9a4Mlo2spImKFmoARY2u1xqL8hRIXTOjNE
         7DV9GmIto+zxp/sl6gzxOy9OpipKDUkZExwKYdOg7foQSIXvy4bqEKjFJtG2LVhQFcfz
         AQesjHRB3nv44oVksZ4y+apNUp/PKBhrrJ3YYwFj3LcKKPX5Tdd+YFjKI2M/jUIFePqv
         HJwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700769844; x=1701374644;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u/WfHWKDW3LuB/2tH5rrGpk3IkHtZyi5i7bzkP0nzIk=;
        b=NSK7LTDs46hyhehLqiNyZOLCrfGTN8X0nt8IuxPbvcJSOnNGsmNdeVxA9S/BAKYW4E
         aeqFcjwEWqYwaJbiCgKcopv7OgcxffV1n3lW2wstcIKrJNKRezpE0iCd9lQ3nzSEXSvP
         xqbxs/qGv6kVtvU2a5GyVuSThJu1QdZytAkPgJGiLFNDi4SYRRqoCxvn3vQUYalsTSgi
         Zwr475THsF70lARfKGlSazNquT+EcmfsN8MEJlJhisuAXsU3lQTz7Kwc8GQoye+ihkc4
         RzULDZHLRI/P7j06uswa7k8IMPsLVDgMrTupiDKDUuWaaegCgKp1qo9Jj3DmCbsqsVEZ
         jnBA==
X-Gm-Message-State: AOJu0Yw2pUAsxq0UDHtpB5ZgbYnKjDS04GBX8pK3uY5WBz2/m1ZJeB4z
	wvKpzzDIihWjNpqVJyirqLQxsYEgL2uXjayzCgJ3iQ==
X-Google-Smtp-Source: AGHT+IHOsETM6ubQBxOsCUwHnVNtbPNzAzdYNcu/mic2bqqRB0wc1z/0IBofXl3irDzN5mAxRUc6DQ==
X-Received: by 2002:a05:6a20:8f18:b0:186:10ae:152a with SMTP id b24-20020a056a208f1800b0018610ae152amr792987pzk.4.1700769844215;
        Thu, 23 Nov 2023 12:04:04 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id z12-20020aa791cc000000b006c0316485f9sm1604516pfa.64.2023.11.23.12.04.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Nov 2023 12:04:03 -0800 (PST)
Message-ID: <2f3bf38b-a803-43e5-a9b9-54a88f837125@kernel.dk>
Date: Thu, 23 Nov 2023 13:04:02 -0700
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: target: core: add missing file_{start,end}_write()
Content-Language: en-US
To: Amir Goldstein <amir73il@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Jan Kara <jack@suse.cz>, Josef Bacik <josef@toxicpanda.com>,
 David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
 Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
 stable@vger.kernel.org
References: <20231123092000.2665902-1-amir73il@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231123092000.2665902-1-amir73il@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/23/23 2:20 AM, Amir Goldstein wrote:
> The callers of vfs_iter_write() are required to hold file_start_write().
> file_start_write() is a no-op for the S_ISBLK() case, but it is really
> needed when the backing file is a regular file.
> 
> We are going to move file_{start,end}_write() into vfs_iter_write(), but
> we need to fix this first, so that the fix could be backported to stable
> kernels.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe


