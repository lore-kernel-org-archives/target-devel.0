From: Christoph Hellwig <hch@infradead.org>
Date: Fri, 06 Apr 2018 07:06:14 +0000
Subject: Re: [PATCH] target: change default dbroot to /etc/target
Message-Id: <20180406070614.GA25053@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20180404194703.31888-1-lduncan@suse.com>
In-Reply-To: <20180404194703.31888-1-lduncan@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Thu, Apr 05, 2018 at 01:54:25PM -0700, Lee Duncan wrote:
> How about if the code looks for /etc/target, then uses /var/target if
> /etc/target is not present? Then users can use the current sysfs logic
> to set the path to any other directory, if neither of these paths are to
> their liking?
> 
> And users can always find out the current dbroot with the sysfs attribute.

Sounds fine to me.
