From: Matthew Wilcox <willy@infradead.org>
Date: Fri, 24 Aug 2018 19:13:42 +0000
Subject: Re: [PATCH 2/3] iscsi target: Set conn->sess to NULL when iscsi_login_set_conn_values fails
Message-Id: <20180824191342.GB1604@bombadil.infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <1535135833-7454-3-git-send-email-mchristi@redhat.com>
In-Reply-To: <1535135833-7454-3-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Fri, Aug 24, 2018 at 01:37:12PM -0500, Mike Christie wrote:
> Also, let idr_alloc return value through instead of replacing it with -ENOMEM,
> as it is already a negative value and caller checks sign, not exact value.

I bet it's less code to just return -ENOMEM in all situations instead of
making the compiler remember the return value from idr_alloc().  The
patch becomes smaller, at least ;-)
