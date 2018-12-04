From: David Disseldorp <ddiss@suse.de>
Date: Tue, 04 Dec 2018 14:31:48 +0000
Subject: Re: [PATCH v5 2/5] target: consistently null-terminate t10_wwn strings
Message-Id: <20181204153148.259a1dba@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181130233423.26556-3-ddiss@suse.de>
In-Reply-To: <20181130233423.26556-3-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Tue, 4 Dec 2018 14:31:57 +0300, Roman Bolshakov wrote:

> On Sat, Dec 01, 2018 at 12:34:20AM +0100, David Disseldorp wrote:
...
> > diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> > index f6b1549f4142..34872f24e8bf 100644
> > --- a/drivers/target/target_core_configfs.c
> > +++ b/drivers/target/target_core_configfs.c
> > @@ -613,12 +613,17 @@ static void dev_set_t10_wwn_model_alias(struct se_device *dev)
> >  	const char *configname;
> >  
> >  	configname = config_item_name(&dev->dev_group.cg_item);
> > -	if (strlen(configname) >= 16) {
> > +	if (strlen(configname) >= INQUIRY_MODEL_LEN) {
> >  		pr_warn("dev[%p]: Backstore name '%s' is too long for "
> >  			"INQUIRY_MODEL, truncating to 16 bytes\n", dev,  
> 
> The warning (which I understand predates your patch) is misleading, it
> should mention truncation to 15 instead of 16 bytes and your comment
> just below explains this.

It's misleading, but could be interpreted as including the
null-terminator. I'll change it to mention 15 chars in the next round.
...
> > +	BUILD_BUG_ON(sizeof(dev->t10_wwn.vendor) != INQUIRY_VENDOR_LEN + 1);
> > +	BUILD_BUG_ON(sizeof(dev->t10_wwn.model) != INQUIRY_MODEL_LEN + 1);
> > +	BUILD_BUG_ON(sizeof(dev->t10_wwn.revision) != INQUIRY_REVISION_LEN + 1);  
> 
> 
> I'm sorry I'm missing something. Why BUILD_BUG_ON is added in many
> places?

These three are mostly left over from the v4 patchset which used
strncpy() + explicit null-term. Given that they don't cost anything,
and IMO improve readability / maintainability in some places I'd like
to keep the others.

> 
> > diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> > index 47d76c862014..1002829f2038 100644
> > --- a/drivers/target/target_core_pscsi.c
> > +++ b/drivers/target/target_core_pscsi.c
> > @@ -190,9 +190,15 @@ pscsi_set_inquiry_info(struct scsi_device *sdev, struct t10_wwn *wwn)
> >  	/*
> >  	 * Use sdev->inquiry from drivers/scsi/scsi_scan.c:scsi_alloc_sdev()
> >  	 */
> > -	memcpy(&wwn->vendor[0], &buf[8], sizeof(wwn->vendor));
> > -	memcpy(&wwn->model[0], &buf[16], sizeof(wwn->model));
> > -	memcpy(&wwn->revision[0], &buf[32], sizeof(wwn->revision));
> > +	BUILD_BUG_ON(sizeof(wwn->vendor) != INQUIRY_VENDOR_LEN + 1);
> > +	snprintf(wwn->vendor, sizeof(wwn->vendor),
> > +		 "%." __stringify(INQUIRY_VENDOR_LEN) "s", &buf[8]);
> > +	BUILD_BUG_ON(sizeof(wwn->model) != INQUIRY_MODEL_LEN + 1);
> > +	snprintf(wwn->model, sizeof(wwn->model),
> > +		 "%." __stringify(INQUIRY_MODEL_LEN) "s", &buf[16]);
> > +	BUILD_BUG_ON(sizeof(wwn->revision) != INQUIRY_REVISION_LEN + 1);
> > +	snprintf(wwn->revision, sizeof(wwn->revision),
> > +		 "%." __stringify(INQUIRY_REVISION_LEN) "s", &buf[32]);
> >  }
> >    
> 
> The parts of the sdev->inquiry have been already right-padded with
> spaces by scsi_sanitize_inquiry_string in scsi_probe_lun. Thus, it's
> enough to replace sizeof with the new length definitions. Also, it's
> possible to use sdev->model,vendor,rev pointers like in
> pscsi_show_configfs_dev_params instead of explicit offsets &buf[8],
> &buf[16], &buf[32].

I'll change this over to use the sdev pointers. I'd prefer to keep the
exiting sizeof() usage.

> >  static int
> > @@ -826,21 +832,21 @@ static ssize_t pscsi_show_configfs_dev_params(struct se_device *dev, char *b)
> >  	if (sd) {
> >  		bl += sprintf(b + bl, "        ");
> >  		bl += sprintf(b + bl, "Vendor: ");
> > -		for (i = 0; i < 8; i++) {
> > +		for (i = 0; i < INQUIRY_VENDOR_LEN; i++) {
> >  			if (ISPRINT(sd->vendor[i]))   /* printable character? */
> >  				bl += sprintf(b + bl, "%c", sd->vendor[i]);
> >  			else
> >  				bl += sprintf(b + bl, " ");
> >  		}
> >  		bl += sprintf(b + bl, " Model: ");
> > -		for (i = 0; i < 16; i++) {
> > +		for (i = 0; i < INQUIRY_MODEL_LEN; i++) {
> >  			if (ISPRINT(sd->model[i]))   /* printable character ? */
> >  				bl += sprintf(b + bl, "%c", sd->model[i]);
> >  			else
> >  				bl += sprintf(b + bl, " ");
> >  		}
> >  		bl += sprintf(b + bl, " Rev: ");
> > -		for (i = 0; i < 4; i++) {
> > +		for (i = 0; i < INQUIRY_REVISION_LEN; i++) {
> >  			if (ISPRINT(sd->rev[i]))   /* printable character ? */
> >  				bl += sprintf(b + bl, "%c", sd->rev[i]);
> >  			else  
> 
> Likewise, the loops are redundant as sd->vendor/model/rev have been
> right padded with spaces by scsi_sanitize_inquiry_string in
> scsi_probe_lun.

Okay, I'll change this over to use sprintf() for the entire string.

Cheers, David
