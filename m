Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC6EEC433F5
	for <target-devel@archiver.kernel.org>; Fri, 15 Apr 2022 05:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348040AbiDOFNL (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Fri, 15 Apr 2022 01:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349940AbiDOFMv (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 15 Apr 2022 01:12:51 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE9682D20
        for <target-devel@vger.kernel.org>; Thu, 14 Apr 2022 22:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649999311; x=1681535311;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Fza98p6Hk/Oo3R5YjAQC2Nws92s1JhenlM6js5zQuBI=;
  b=eH7fhRQ5Emf7mnVoxYT0vT1ynrsoefol7CjLKx/XFK1lQ81oC9FnkImk
   0NvSAhootdN/mtykKo57EDtbn7QC7BqNjq7L/dHxLEFE6ljGWqWQIm0i3
   BW5OG8PE8TF6wOemfDnO5HzDUZnLBPyHAYk2akTrdI//A9C6bbVD9C8CG
   6QbLAAhWuHhV9fk4K+f8Pjrbv15O0S56sdANUVtss7i9WT7pH9QsV4tH5
   kCwbUNkuqTLEkoJQ/bUoE233322a65AFm2rEvTmKcnFsaa+C4zrvzX79x
   SMjZjjguqq845PbqpRFsFxIU8MBB741m0wBEDKq9MFre5pFWtmZ0idIkm
   g==;
X-IronPort-AV: E=Sophos;i="5.90,261,1643644800"; 
   d="scan'208";a="309936208"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 15 Apr 2022 13:08:29 +0800
IronPort-SDR: ziOni+fp0eEVXq5iOjC3xOyJ/5t73LqlcGWIPM2gI+b+vda0UV1lZwmFb0UMxmK/6sST9DNN9W
 Upe453ovh91LPXfH+HRMMQF5jpt8olU/WhpN8ZkwYaZ3Lt5kRHk5NZxRHLAeODYZOhLmR/mR/5
 5qfjwSwK8c0ESSor2YMTKXjDRqYEp3PiSAYFxmIOoh0zu1H4aCTgjRK+3lSeSPp0jd2zxt2ZQF
 g79kIgvlZbWyrP1C7uzqfPIIzrUCTQbTsp431nxnGaT1rJ4C4nrSUpjziIyNpiUt981aLNFsKu
 G1p7zXk7TJt+HqeUrACQF7Te
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Apr 2022 21:38:53 -0700
IronPort-SDR: IDrd2PI2EhORfcrWYnjuMlNmdqP6l4enrlKLcMWacNShjDl+liuPbbB7euWlel8VABaCI/EqOE
 aXUzWWHJBS+BnBf/JqW4x7OUckS9G1tQ9HnXuutK+MtSxCD0RSAstrIQgWxsFcn+mCmWwpVYvf
 rS3MDIFoQtjHtB525mV1TYITD2VY1mbwXLSuBqYnCclRhsw55lcl0tK82Rp2CJ3q+CF923zbfX
 9ygejAXXzxMB8MFHjU4oM+31okMthoiSixJWZ+kGe29V6BJ3zUUIQszVISefNgqId78JU0UGgn
 /GQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Apr 2022 22:08:29 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Kfkqw1B2bz1SVp0
        for <target-devel@vger.kernel.org>; Thu, 14 Apr 2022 22:08:28 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1649999307; x=1652591308; bh=Fza98p6Hk/Oo3R5YjAQC2Nws92s1JhenlM6
        js5zQuBI=; b=PnLGxxEK3pLyssa8yxGNdC4XjW2wbor1ccVbtGFYLuF6J3cLtHd
        AbpMYH7aDhgG/pTbCzP2Jz5UXeITA2uAAyiR/Fy6attbFAobIm77MiZ1d9JwxmK8
        shfFnnjg3a2RytIj37jVhbyrF9O4v+hLyhCzQz2dnHJygtOnBuY0SiH0emrVEC5V
        37Q51RwNl9CEkvSI7J63mNoy2HlvXkxHid/Xl33/pVaD25Hfmrh/cyibuFKv7AtS
        /tmUO1ElBPCNJo60JkfPy33eMUDO0eae+UlOxVUV5CwFdxfl0b0VIs1osnbs2TmY
        qPuOzeMMi/kXJvdALFOBXWDwdlihcT0EYFQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ovc4hQrhiiQr for <target-devel@vger.kernel.org>;
        Thu, 14 Apr 2022 22:08:27 -0700 (PDT)
Received: from [10.225.163.9] (unknown [10.225.163.9])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Kfkqn6sCZz1Rvlx;
        Thu, 14 Apr 2022 22:08:21 -0700 (PDT)
Message-ID: <d7a39cfc-9b28-f0d6-bf62-4351c55daec2@opensource.wdc.com>
Date:   Fri, 15 Apr 2022 14:08:20 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 27/27] direct-io: remove random prefetches
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-um@lists.infradead.org,
        linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
        nbd@other.debian.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev,
        ocfs2-devel@oss.oracle.com, linux-mm@kvack.org
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-28-hch@lst.de>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220415045258.199825-28-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 4/15/22 13:52, Christoph Hellwig wrote:
> Randomly poking into block device internals for manual prefetches isn't
> exactly a very maintainable thing to do.  And none of the performance
> criticil direct I/O implementations still use this library function

s/criticil/critical

> anyway, so just drop it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>


-- 
Damien Le Moal
Western Digital Research
