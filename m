From: David Disseldorp <ddiss@suse.de>
Date: Thu, 28 Jun 2018 14:48:08 +0000
Subject: Re: [PATCH v3] target: add emulate_pr backstore attr to toggle PR support
Message-Id: <20180628164808.34a2e4d6@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20180625185658.31141-1-ddiss@suse.de>
In-Reply-To: <20180625185658.31141-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, 27 Jun 2018 13:22:27 -0500, Mike Christie wrote:

> > So I'd like to propose the following:
> > 1) Have an attribute to switch between normal mode (pr_support active)
> >    and new mode (pr_support inactive).
> > Whether this is done via the existing pr_support attribute or via
> >    a new attribute is a question of flavor.
> > 2) If pr_support is inactive, spc_parse_cdb() would reject PR CDBs
> >    while passthrough_parse_cdb() would pass through those CDBs to
> >    userspace.
> > 3) In the "pr_support inactive" mode for devices using
> > passthrough_parse_cdb() the transport_flag
> > TRANSPORT_FLAG_PASSTHROUGH_PGR would be set. For devices using
> >    spc_parse_cdb() a new flag like TRANSPORT_FLAG_REJECT_PGR should be
> >    used. (See details below regarding dev specific transport_flags.)  
> 
> I am not sure I got this. How do apps like targetcli that manage tcmu
> with rtslib tell the tcmu userspace daemon if it should reject PGRs? I
> think you need 2 device attributes or 1 with a 3rd state:
> 
> 1. emulate_pr - Controls whether PGRs are executed or failed. Does not
> matter if in kernel or userspace.
> 2. pgr_support - Controls if PGRs are executed in the LIO PGR layer in
> kernel or passed to the backend driver (up to userspace for tcmu or to
> the physical device for pscsi).
> 
> So with tcmu and {emulate_pr=0 pgr_support=0} would be pass to userspace
> and fail PGRs.

So how should we proceed here? Separate emulate_pr and pgr_support
interfaces would imply that this change could go in as-is, while a
multi-state interface would probably require more thought.

Cheers, David
