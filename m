From: Christoph Hellwig <hch@infradead.org>
Date: Thu, 05 Apr 2018 17:57:14 +0000
Subject: Re: [PATCH] target: change default dbroot to /etc/target
Message-Id: <20180405175714.GA20109@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20180404194703.31888-1-lduncan@suse.com>
In-Reply-To: <20180404194703.31888-1-lduncan@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Thu, Apr 05, 2018 at 10:06:35AM -0700, Lee Duncan wrote:
> Also, I think it's a bit unlikely that anyone will still be using
> /var/target, since targetcli-fb has been setting the target root to
> /etc/target for a while now, and the old targetcli has been deprecated.
> (It's the only app I know that hard-codes the old location.)

That is a a good point.  How about having a search path in the kernel?
Try the configs attribute first if one is set, then /etc/target, then
/var/target?
