From: Christoph Hellwig <hch@infradead.org>
Date: Thu, 19 Jul 2018 20:41:39 +0000
Subject: Re: [PATCH 06/15] target: make transport_init_session_tags static
Message-Id: <20180719204139.GC14654@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-7-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-7-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sun, Jul 15, 2018 at 06:16:22PM -0500, Mike Christie wrote:
> transport_init_session_tags is only called from target_core_transport.c
> so make it static.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>

Looks fine by itself:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Although folding it into the only caller would be even better.
