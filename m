From: David Disseldorp <ddiss@suse.de>
Date: Wed, 06 Dec 2017 12:29:21 +0000
Subject: Re: [RFC PATCH] target: detect read-only from underlying iblock device
Message-Id: <20171206132921.69f38c90@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20171205205442.25414-1-ddiss@suse.de>
In-Reply-To: <20171205205442.25414-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, 6 Dec 2017 04:33:16 +0000, Bart Van Assche wrote:

> Although the patch itself looks fine to me: do we really need this kind of
> functionality in the kernel? Is it possible to implement the same functionality
> in user space?

Thanks for the feedback, Bart and Johannes. This functionality could
be handled in user-space, but having the error reported when the
backstore is enabled, rather than when the backstore->control node is
setup makes it less than intuitive for targetcli, etc.
Having targetcli call ioctl(BLKROGET) prior to issuing the
backstore->control I/O would probably be a cleaner user-space option.

Cheers, David
