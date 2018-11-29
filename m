From: David Disseldorp <ddiss@suse.de>
Date: Thu, 29 Nov 2018 20:31:19 +0000
Subject: Re: [PATCH v4 3/7] target: consistently null-terminate t10_wwn.model
Message-Id: <20181129213119.05fb07fd@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181129010157.12687-4-ddiss@suse.de>
In-Reply-To: <20181129010157.12687-4-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Thu, 29 Nov 2018 08:24:38 -0800, Bart Van Assche wrote:

> On Thu, 2018-11-29 at 02:01 +0100, David Disseldorp wrote:
> > diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> > index f6b1549f4142..9f49b1afd685 100644
> > --- a/drivers/target/target_core_configfs.c
> > +++ b/drivers/target/target_core_configfs.c
> > @@ -613,12 +613,12 @@ static void dev_set_t10_wwn_model_alias(struct se_device *dev)
> >  	const char *configname;
> >  
> >  	configname = config_item_name(&dev->dev_group.cg_item);
> > -	if (strlen(configname) >= 16) {
> > +	if (strlen(configname) >= INQUIRY_MODEL_LEN) {
> >  		pr_warn("dev[%p]: Backstore name '%s' is too long for "
> >  			"INQUIRY_MODEL, truncating to 16 bytes\n", dev,
> >  			configname);
> >  	}
> > -	snprintf(&dev->t10_wwn.model[0], 16, "%s", configname);
> > +	snprintf(&dev->t10_wwn.model[0], INQUIRY_MODEL_LEN, "%s", configname);  
> 
> Both the old and the new statement truncate inquiry strings that are 16 bytes
> long, which is a bug.

As mentioned in the changelog, I don't think we can fix this without
potentially breaking existing deployments - e.g. a "fourfourfourfour"
backstore name with emulate_model_alias=1 would change inquiry product
ID from "fourfourfourfou" to "fourfourfourfour" following kernel
upgrade.

> Additionally, have you considered to use strlcpy()
> instead of snprintf()?

Happy to change the logic below over if you find it easier to follow.

Cheers, David
