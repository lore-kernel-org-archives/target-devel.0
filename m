From: Christoph Hellwig <hch@infradead.org>
Date: Thu, 19 Jul 2018 20:39:54 +0000
Subject: Re: [PATCH 05/15] target: remove sess_get_index
Message-Id: <20180719203954.GB14654@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-6-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-6-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sun, Jul 15, 2018 at 06:16:21PM -0500, Mike Christie wrote:
> sess_get_index is meaninless for most drivers. For iscsi, it
> is the same as the se_session->sid now and for fcoe it was just
> the port id which would not work if multiple initiators
> connected to the same target port. So just use the se_session sid
> for all drivers and remove sess_get_index callout.

Use up all your space again (not going to complain for any further
patches).

Modulo that and the type that Bart found:

Reviewed-by: Christoph Hellwig <hch@lst.de>
