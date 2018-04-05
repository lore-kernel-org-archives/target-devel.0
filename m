From: Christoph Hellwig <hch@infradead.org>
Date: Thu, 05 Apr 2018 07:17:49 +0000
Subject: Re: [PATCH] target: change default dbroot to /etc/target
Message-Id: <20180405071749.GA2086@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20180404194703.31888-1-lduncan@suse.com>
In-Reply-To: <20180404194703.31888-1-lduncan@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, Apr 04, 2018 at 12:47:03PM -0700, Lee Duncan wrote:
> The dbroot (target PR database root directory) is
> configurable but default to /var/target, a historic
> value. But the reason for adding configurability
> was to move the target directory out of /var. This
> is because the File Hierarchy Standard v3.0 mandates
> that this "target" directory not be in /var. See
> https://refspecs.linuxfoundation.org/FHS_3.0/fhs-3.0.pdf
> 
> This change moves the default from /var/target to
> /etc/target, but this value is still configurable,
> so those wishing to continue to use /var/target
> can still do so.

This will break upgrades of all existing setups, so NAK.
