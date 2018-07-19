From: Christoph Hellwig <hch@infradead.org>
Date: Thu, 19 Jul 2018 20:42:16 +0000
Subject: Re: [PATCH 07/15] target: rename target_alloc_session
Message-Id: <20180719204216.GD14654@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-8-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-8-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sun, Jul 15, 2018 at 06:16:23PM -0500, Mike Christie wrote:
> Rename target_alloc_session to target_setup_session to avoid
> confusion with the other transport session allocation
> function that only allocates the session and because
> the target_alloc_session does so more. It allocates the
> session, sets up the nacl and egisters the session.
> 
> The next patch will then add a remove function to match the
> setup in this one, so it should make sense for all drivers,
> except iscsi, to just call those 2 functions to setup and remove
> a session.

Ok.

> iscsi will continue to be the odd driver.

Wish we could sort that out eventually..

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
