From: David Disseldorp <ddiss@suse.de>
Date: Mon, 04 Jun 2018 20:20:30 +0000
Subject: Re: [PATCH] target: fix truncated PR-in ReadKeys response
Message-Id: <20180604222030.6d01543d@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20180531222054.32655-1-ddiss@suse.de>
In-Reply-To: <20180531222054.32655-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, 04 Jun 2018 21:42:36 +0200, Maged Mokhtar wrote:

> Yes it fixes the "Storage Spaces Persistent Reservation" test in the 
> Windows 2016 Server Failover Cluster validation suites when having many 
> connections that result in more than 8 registrations. I tested your 
> patch on 4.17 with iblock.

Thanks a lot for confirming this, Maged. Patch with new commit message
to follow...

Cheers, David
