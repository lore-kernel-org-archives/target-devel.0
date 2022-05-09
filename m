Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D18E0C433FE
	for <target-devel@archiver.kernel.org>; Mon,  9 May 2022 18:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240034AbiEISQc (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 9 May 2022 14:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240080AbiEISQJ (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 9 May 2022 14:16:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E0649CBD
        for <target-devel@vger.kernel.org>; Mon,  9 May 2022 11:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jBAxB3AIHOJ8SifWVHc/VdXX/9KeXtix2H9wycYLQxY=; b=D/B1nEvPlalLOxwzzlrUIPP5od
        IEpwoKd6QkN0CjwghytaGEsoCsFvZsGCxeVrKU7w2fKlD4Gfoc86RX8JHAFqCYduqSw83dbA+GbR1
        C5WoupGZ5DAoL9h3tjircg2usBqCqXHeet022oCKASX5mxFuJK6AeMR4RcBtZ24tfqKGYHlWhgSpQ
        AicD2HSUCE0Vj37jBVZqRX4h+2D4ygCTY4UdFRULFd8OeuNmRNmG0tWoZ23PhxTJFnInmsPyIeSKU
        wMn2A0q3VWtTLy+ys+nWoylipcz33RXkFAgVkTyU/iKgNChTbeTnmxBGQfSRWNaorohjDmVSbTrsL
        CSW2ks3A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1no7rV-003gVP-RF; Mon, 09 May 2022 18:12:01 +0000
Date:   Mon, 9 May 2022 19:12:01 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Bodo Stroesser <bostroesser@gmail.com>,
        xiaoguang.wang@linux.alibaba.com, target-devel@vger.kernel.org
Subject: Re: [bug report] scsi: target: tcmu: Fix possible data corruption
Message-ID: <YnlZcUTU2SzYi5/N@casper.infradead.org>
References: <YnKX+i4XeOJV1njK@kili>
 <748a23d4-6036-c62d-8e1f-4856d6c75439@gmail.com>
 <20220509060545.GI4031@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509060545.GI4031@kadam>
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Mon, May 09, 2022 at 09:05:45AM +0300, Dan Carpenter wrote:
> > If there is no other way to avoid the Smatch warning,
> 
> The Smatch warning is not the issue.  If we're holding a spinlock and
> we call might_sleep() then that generates a stack trace at runtime if
> you have CONFIG_DEBUG_ATOMIC_SLEEP enabled.  Probably enabling
> CONFIG_DEBUG_ATOMIC_SLEEP should just be a standard part of the QC
> process.
> 
> Anyway, it sounds you're just doing the locking to silence a warning in
> xarray.  Let's ask Matthew if he has a hint.

I suspect that the tcmu code is doing something horrible & wrong again.
It keeps poking at VM internals without understanding of what's going
on or why.  Anyway ...

> On Sun, May 08, 2022 at 08:03:14PM +0200, Bodo Stroesser wrote:
> > I'm quite sure that our code does not cause any problems, because
> > in tcmu we explicitly or implicitly take the xarray's lock only while
> > holding the so called cmdr_lock mutex. Also, we take the lock without
> > disabling irq or bh. So I think there is no problem if lock_page sleeps
> > while we hold the xarray's lock.
> > 
> > Of course, we wouldn't need the xarray lock at all, but xarray code
> > forces us to take it to avoid warnings.

You mean "The XArray warns us when we break its locking rules".

> > In tcmu_blocks_release we use the advanced xarray API to keep the
> > overhead small. It allows us to lock/unlock before and after the loop
> > only. If there is no other way to avoid the Smatch warning, we could
> > easily put additional xas_unlock() and xas_lock() around the
> > lock_page/unlock_page block.

... then you'd have to call xas_reset(), and you might as well use
xa_for_each().

> > >      1661 static u32 tcmu_blocks_release(struct tcmu_dev *udev, unsigned long first,
> > >      1662                                 unsigned long last)
> > >      1663 {
> > >      1664         XA_STATE(xas, &udev->data_pages, first * udev->data_pages_per_blk);
> > >      1665         struct page *page;
> > >      1666         u32 pages_freed = 0;
> > >      1667
> > >      1668         xas_lock(&xas);
> > >                   ^^^^^^^^^^^^^^
> > > We take a spinlock here.
> > > 
> > > 
> > >      1669         xas_for_each(&xas, page, (last + 1) * udev->data_pages_per_blk - 1) {
> > >      1670                 xas_store(&xas, NULL);
> > >      1671                 /*
> > >      1672                  * While reaching here there may be page faults occurring on
> > >      1673                  * the to-be-released pages. A race condition may occur if
> > >      1674                  * unmap_mapping_range() is called before page faults on these
> > >      1675                  * pages have completed; a valid but stale map is created.
> > >      1676                  *
> > >      1677                  * If another command subsequently runs and needs to extend
> > >      1678                  * dbi_thresh, it may reuse the slot corresponding to the
> > >      1679                  * previous page in data_bitmap. Though we will allocate a new
> > >      1680                  * page for the slot in data_area, no page fault will happen
> > >      1681                  * because we have a valid map. Therefore the command's data
> > >      1682                  * will be lost.
> > >      1683                  *
> > >      1684                  * We lock and unlock pages that are to be released to ensure
> > >      1685                  * all page faults have completed. This way
> > >      1686                  * unmap_mapping_range() can ensure stale maps are cleanly
> > >      1687                  * removed.
> > >      1688                  */
> > > --> 1689                 lock_page(page);
> > >                           ^^^^^^^^^^^^^^^
> > > The lock_page() function calls might_sleep() (inside the declaration
> > > block).
> > > 
> > >      1690                 unlock_page(page);
> > >      1691                 __free_page(page);
> > >      1692                 pages_freed++;
> > >      1693         }
> > >      1694         xas_unlock(&xas);

There are a number of things you can do.  One is to remove pages into
a pagevec until it is full, then xas_unlock(); xas_reset(); lock and
unlock each page and pass the pagevec to __pagevec_release().  Then
xas_lock() and continue the loop.

Another possibility is to trylock each page; if it fails, put it into
the pagevec (and do the above dance if the pagevec is now full), but
if it succeeds, you can now unlock it and __free_page().

The key to going fast is batching.  And that goes for __free_page()
vs __pagevec_release() as much as for walking the XArray.
