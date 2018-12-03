From: David Disseldorp <ddiss@suse.de>
Date: Mon, 03 Dec 2018 11:52:19 +0000
Subject: Re: [PATCH v5 5/5] target: perform t10_wwn ID initialisation in target_alloc_device()
Message-Id: <20181203125219.6843014e@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181130233423.26556-6-ddiss@suse.de>
In-Reply-To: <20181130233423.26556-6-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sun, 2 Dec 2018 23:22:23 +0100, David Disseldorp wrote:

> > > +	if (!(dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)) {
> > > +		strlcpy(dev->t10_wwn.vendor, "LIO-ORG",
> > > +			sizeof(dev->t10_wwn.vendor));
> > > +		strlcpy(dev->t10_wwn.model, dev->transport->inquiry_prod,
> > > +			sizeof(dev->t10_wwn.model));
> > > +		strlcpy(dev->t10_wwn.revision, dev->transport->inquiry_rev,
> > > +			sizeof(dev->t10_wwn.revision));
> > > +	}
> > > +
> > >   	return dev;
> > >   }
> > >       
> > This is odd. I'd rather have it consistent across backends, ie either 
> > move the initialisation into the backends, or provide a means to check 
> > if the inquiry data has already been pre-filled.
> > But this check really is awkward.  
> 
> Not quite sure I follow here. I could the default setting to the
> target_backend_ops.alloc_device() code paths, but I don't think the
> duplication would make this much cleaner, if at all.
> I can look into this further if you like (target_backend_ops.inquiry_rev
> could be dropped that way),

Looking a little closer, I think we can drop the conditional completely
and set the vendor/model/rev defaults for all cases here:
- target_core_pscsi overwrites the defaults in the
  pscsi_configure_device() callback.
  + the contents is then only used for configfs via
    $pscsi_dev/info, $pscsi_dev/statistics/scsi_lu/vend, etc.
- target_core_user doesn't touch the defaults, nor are they used for
  anything outside of configfs.

> but my preference would be to do so as a
> follow-up patch-set.

This is still my preference.

Cheers, David
