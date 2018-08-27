From: Matthew Wilcox <willy@infradead.org>
Date: Mon, 27 Aug 2018 20:02:51 +0000
Subject: Re: [PATCH 1/2] iscsi target: Set conn->sess to NULL when iscsi_login_set_conn_values fails
Message-Id: <20180827200251.GD24544@bombadil.infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <1535399116-15138-2-git-send-email-mchristi@redhat.com>
In-Reply-To: <1535399116-15138-2-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, Aug 27, 2018 at 02:45:15PM -0500, Mike Christie wrote:
> Signed-off-by: Vincent Pelletier <plr.vincent@gmail.com>
> [rebased against idr/ida changes and to handle ret review comments from Matthew]
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> Cc: Matthew Wilcox <willy@infradead.org>

Reviewed-by: Matthew Wilcox <willy@infradead.org>
