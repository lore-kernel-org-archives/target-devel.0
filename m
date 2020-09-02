From: David Disseldorp <ddiss@suse.de>
Date: Wed, 02 Sep 2020 22:23:36 +0000
Subject: Re: [RFC PATCH] scsi: target: detect XCOPY NAA descriptor conflicts
Message-Id: <20200903002336.083e88a4@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20200813002142.13820-1-ddiss@suse.de>
        <2155E745-0E65-441B-93AF-7B4C0A53F5F4@oracle.com>
In-Reply-To: <2155E745-0E65-441B-93AF-7B4C0A53F5F4@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michael Christie <michael.christie@oracle.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi Mike,

On Tue, 1 Sep 2020 22:17:51 -0500, Michael Christie wrote:

> > --- a/drivers/target/target_core_xcopy.c
> > +++ b/drivers/target/target_core_xcopy.c
> > @@ -68,8 +68,14 @@ static int target_xcopy_locate_se_dev_e4_iter(struct se_device *se_dev,
> > 	if (rc != 0)
> > 		return 0;
> > 
> > -	info->found_dev = se_dev;
> > 	pr_debug("XCOPY 0xe4: located se_dev: %p\n", se_dev);
> > +	if (info->found_dev) {
> > +		pr_warn("XCOPY 0xe4 descriptor conflict for se_dev %p and %p\n",
> > +			info->found_dev, se_dev);
> > +		target_undepend_item(&info->found_dev->dev_group.cg_item);
> > +		return -ENOTUNIQ;
> > +	}
> > +	info->found_dev = se_dev;  
> 
> Was it valid to copy to/from the same LUN? You would copy from/to different src/destinations on that LUN. Would your patch break that?

XCOPY allows for copies to occur on the same LUN or between separate
src/destinations. The intention of this patch is that regardless of the
source or destination, if the NAA WWN could refer to multiple LUNs on
the same target (via target_for_each_device()) then the XCOPY should
fail and force the initiator to fallback to initiator driver copy.

Cheers, David
