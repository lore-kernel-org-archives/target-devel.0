From: David Disseldorp <ddiss@suse.de>
Date: Sun, 02 Dec 2018 22:22:23 +0000
Subject: Re: [PATCH v5 5/5] target: perform t10_wwn ID initialisation in target_alloc_device()
Message-Id: <20181202232223.7db5f24e@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181130233423.26556-6-ddiss@suse.de>
In-Reply-To: <20181130233423.26556-6-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi Hannes,

Thanks for the feedback...

On Sat, 1 Dec 2018 15:59:25 +0100, Hannes Reinecke wrote:

> On 12/1/18 12:34 AM, David Disseldorp wrote:
...
> > @@ -810,6 +810,23 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
> >   	mutex_init(&xcopy_lun->lun_tg_pt_md_mutex);
> >   	xcopy_lun->lun_tpg = &xcopy_pt_tpg;
> >   
> > +	/*
> > +	 * Preload the initial INQUIRY const values if we are doing
> > +	 * anything virtual (IBLOCK, FILEIO, RAMDISK), but not for TCM/pSCSI
> > +	 * passthrough because this is being provided by the backend LLD.
> > +	 */
> > +	BUILD_BUG_ON(sizeof(dev->t10_wwn.vendor) != INQUIRY_VENDOR_LEN + 1);
> > +	BUILD_BUG_ON(sizeof(dev->t10_wwn.model) != INQUIRY_MODEL_LEN + 1);
> > +	BUILD_BUG_ON(sizeof(dev->t10_wwn.revision) != INQUIRY_REVISION_LEN + 1);
> > +	if (!(dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)) {
> > +		strlcpy(dev->t10_wwn.vendor, "LIO-ORG",
> > +			sizeof(dev->t10_wwn.vendor));
> > +		strlcpy(dev->t10_wwn.model, dev->transport->inquiry_prod,
> > +			sizeof(dev->t10_wwn.model));
> > +		strlcpy(dev->t10_wwn.revision, dev->transport->inquiry_rev,
> > +			sizeof(dev->t10_wwn.revision));
> > +	}
> > +
> >   	return dev;
> >   }
> >     
> This is odd. I'd rather have it consistent across backends, ie either 
> move the initialisation into the backends, or provide a means to check 
> if the inquiry data has already been pre-filled.
> But this check really is awkward.

Not quite sure I follow here. I could the default setting to the
target_backend_ops.alloc_device() code paths, but I don't think the
duplication would make this much cleaner, if at all.
I can look into this further if you like (target_backend_ops.inquiry_rev
could be dropped that way), but my preference would be to do so as a
follow-up patch-set.

Cheers, David
