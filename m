From: David Disseldorp <ddiss@suse.de>
Date: Wed, 07 Nov 2018 11:11:40 +0000
Subject: Re: [PATCH v4] target: add emulate_pr backstore attr to toggle PR support
Message-Id: <20181107121140.5fa72d1f@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181030142643.17458-1-ddiss@suse.de>
In-Reply-To: <20181030142643.17458-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Tue, 6 Nov 2018 19:54:17 -0600, Mike Christie wrote:

> > -	return snprintf(page, PAGE_SIZE, "%d\n",
> > -			flags & TRANSPORT_FLAG_PASSTHROUGH_PGR ? 0 : 1);
> > +	if (!da->da_dev->dev_attrib.emulate_pr ||
> > +	    (flags & TRANSPORT_FLAG_PASSTHROUGH_PGR))
> > +		pgr_support = 0;
> > +  
> 
> I think we want to keep this separate still. The file tells userspace if
> PRs are supported in the backend module/device or in LIO core.
> 
> With the chunk above, if you had emulate_pr=0 and
> TRANSPORT_FLAG_PASSTHROUGH_PGR is set, userspace cannot detect what the
> backend supports. We would have to temporarily set emaulate_pr sow e can
> read the file then clear it.

Agreed, that'd be awkward and is unnecessary given the presence of both
configfs attributes. I'll send a new version which drops this hunk.

Cheers, David
