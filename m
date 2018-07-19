From: Christoph Hellwig <hch@infradead.org>
Date: Thu, 19 Jul 2018 20:47:28 +0000
Subject: Re: [PATCH 11/15] target: export initiator port values for all sessions
Message-Id: <20180719204728.GF14654@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-12-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-12-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Thu, Jul 19, 2018 at 05:07:59PM +0000, Bart Van Assche wrote:
> Initially configfs did not support creation of a directory from the kernel
> side. Last time I brought this up with Christoph he replied that this
> functionality has been added to configfs (if I understood Christoph
> correctly).

I don't think the functionality was ever missing, but I might be
mistaken.  You can always call config_group_init_type_name() +
configfs_add_default_group to add a directory.  nvmet makes heavy
use of that.
