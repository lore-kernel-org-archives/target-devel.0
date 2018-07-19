From: Christoph Hellwig <hch@infradead.org>
Date: Thu, 19 Jul 2018 20:48:57 +0000
Subject: Re: [PATCH 15/15] iscsi target: merge iscsit_start_nopin_timer and __iscsit_start_nopin_timer
Message-Id: <20180719204857.GH14654@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-16-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-16-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sun, Jul 15, 2018 at 06:16:31PM -0500, Mike Christie wrote:
> Just have iscsit_start_nopin_timer grab the lock and
> call __iscsit_start_nopin_timer.

It doesn't really merge them but makes one call the other.  Except for
that this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
