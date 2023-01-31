Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCFDBC61DA4
	for <target-devel@archiver.kernel.org>; Tue, 31 Jan 2023 01:52:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbjAaBwU (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 30 Jan 2023 20:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjAaBwO (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 30 Jan 2023 20:52:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41ED29175
        for <target-devel@vger.kernel.org>; Mon, 30 Jan 2023 17:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675129877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mBv8DJNmeWTzhqoixUePfk7DvfX/r91Bih49ZwlSTgg=;
        b=DC/74vslTzwnAVEO02wzUzKZO9FsmJQQvVyLu1aOUQQoIFRxiJB2pM3C6SSQ8ZwwTMh653
        0dTn7zVksefp4LEZoq7HcTjcJ7Sgzcq3kwcZ1KyfZXMAdhSzPv2ZX+XPOqVvutfVgE/Fwd
        C6ReLcsooHyYBc0JuMNS1RmenAaSZwE=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-522-aLfVjjlwNbenUsljCsAF6Q-1; Mon, 30 Jan 2023 20:51:16 -0500
X-MC-Unique: aLfVjjlwNbenUsljCsAF6Q-1
Received: by mail-pf1-f198.google.com with SMTP id f15-20020a62380f000000b0058db55a8d7aso6421127pfa.21
        for <target-devel@vger.kernel.org>; Mon, 30 Jan 2023 17:51:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mBv8DJNmeWTzhqoixUePfk7DvfX/r91Bih49ZwlSTgg=;
        b=Mv+3e/dZRTF+CRY3S5JAC+0eErIQfTpugxO2ZbWx50RLqNbo512AKOiPqF/F3QyZje
         nWICNEYCUsDUqrbwX5xxsbJpeLq2hxiyiqzjgx5xfZpF2dIbDjTgG+DjeIh0l8HUg8yA
         z1M6+t9vRHbZyYGZTEoMPQ2fLBr2K+0jnEbyD/cgV9pmrjM2oTeqX0gkaK+Hsfgf8HJZ
         EcBQWoccGqalYjlgaUqMqxsmrQzfrD3XAhOGL+JL8aPWRpqIcC6yujfbXQkEahQ3vb8Q
         +ToKRGc27+d9lUkjhyXUWJU6b++2R5Y1UqWMdEouT8XFQ9OCduWhRN/FHgBDYAtHUCqE
         1Y5g==
X-Gm-Message-State: AO0yUKW0rd0NF+kATdP53sGztDtiyx8RQnKeUFEo59/IL3LCAsr10GPi
        2K7Aqt90s9LoTe5Uf4Rvy0sFezCg2MtWc65voIK2ighLcblkcsYjcl49oVv7q9FYBc50YWXp+hV
        CtLRCTc2HdOGWalDLU/ECm5+i
X-Received: by 2002:a17:902:d487:b0:196:15af:e6de with SMTP id c7-20020a170902d48700b0019615afe6demr29574984plg.68.1675129875394;
        Mon, 30 Jan 2023 17:51:15 -0800 (PST)
X-Google-Smtp-Source: AK7set8JSjJ+sRvtPcXP6fVdufCYZ8fk74MG4aecVDj2Iej+5W2CdxzxrzRUj04G/QWJkYRImmyA4Q==
X-Received: by 2002:a17:902:d487:b0:196:15af:e6de with SMTP id c7-20020a170902d48700b0019615afe6demr29574939plg.68.1675129875072;
        Mon, 30 Jan 2023 17:51:15 -0800 (PST)
Received: from [10.72.13.217] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id o17-20020a170902d4d100b00196077ba463sm8430985plg.123.2023.01.30.17.51.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 17:51:14 -0800 (PST)
Message-ID: <ba3adefd-f2d8-d074-4dfc-5677c3cd71a3@redhat.com>
Date:   Tue, 31 Jan 2023 09:51:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 12/23] ceph: use bvec_set_page to initialize a bvec
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>, Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Mike Marshall <hubcap@omnibond.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        devel@lists.orangefs.org, io-uring@vger.kernel.org,
        linux-mm@kvack.org
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-13-hch@lst.de>
 <CAOi1vP_b77Pq=hYmFMi1zGGRMee2uNjbAbHz_gCCoByOdbRqLw@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP_b77Pq=hYmFMi1zGGRMee2uNjbAbHz_gCCoByOdbRqLw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org


On 31/01/2023 02:02, Ilya Dryomov wrote:
> On Mon, Jan 30, 2023 at 10:22 AM Christoph Hellwig <hch@lst.de> wrote:
>> Use the bvec_set_page helper to initialize a bvec.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> ---
>>   fs/ceph/file.c | 10 +++++-----
>>   1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 764598e1efd91f..6419dce7c57987 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -103,11 +103,11 @@ static ssize_t __iter_get_bvecs(struct iov_iter *iter, size_t maxsize,
>>                  size += bytes;
>>
>>                  for ( ; bytes; idx++, bvec_idx++) {
>> -                       struct bio_vec bv = {
>> -                               .bv_page = pages[idx],
>> -                               .bv_len = min_t(int, bytes, PAGE_SIZE - start),
>> -                               .bv_offset = start,
>> -                       };
>> +                       struct bio_vec bv;
>> +
>> +                       bvec_set_page(&bv, pages[idx],
> Hi Christoph,
>
> There is trailing whitespace on this line which git complains about
> and it made me take a second look.  I think bvec_set_page() allows to
> make this more compact:
>
>          for ( ; bytes; idx++, bvec_idx++) {
>                  int len = min_t(int, bytes, PAGE_SIZE - start);
>
>                  bvec_set_page(&bvecs[bvec_idx], pages[idx], len, start);
>                  bytes -= len;
>                  start = 0;
>          }
>
This looks better.

Thanks

