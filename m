From: David Disseldorp <ddiss@suse.de>
Date: Fri, 30 Nov 2018 12:44:51 +0000
Subject: Re: [PATCH v4 1/7] target: use consistent left-aligned ASCII INQUIRY data
Message-Id: <20181130134451.237737d6@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181129010157.12687-2-ddiss@suse.de>
In-Reply-To: <20181129010157.12687-2-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, 28 Nov 2018 17:23:07 -0800, Lee Duncan wrote:

> > +	 * unused bytes at the end of the field (i.e., highest offset) and the
> > +	 * unused bytes shall be filled with ASCII space characters (20h).
> > +	 */
> > +	memset(&buf[8], 0x20, 8 + 16 + 4);  
> 
> I dislike that you are using 0x20 here (and below) instead of ' '.

Given that this patch already has a couple of reviewed-bys, I'd prefer
to avoid respinning it for this. Besides, I think the comment above
makes it pretty clear.

Thanks for your feedback.

Cheers, David
