From: David Disseldorp <ddiss@suse.de>
Date: Tue, 20 Nov 2018 18:00:57 +0000
Subject: Re: [PATCH v3 3/4] target: add device vendor_id configfs attribute
Message-Id: <20181120190057.31d3f620@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181119210636.22979-4-ddiss@suse.de>
In-Reply-To: <20181119210636.22979-4-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Tue, 20 Nov 2018 09:24:39 -0800, Bart Van Assche wrote:

> On Mon, 2018-11-19 at 22:06 +0100, David Disseldorp wrote:
> >  /*
> > + * STANDARD and VPD page 0x80 T10 Vendor Identification
> > + */
> > +static ssize_t target_wwn_vendor_id_show(struct config_item *item,
> > +		char *page)
> > +{
> > +	return sprintf(page, "T10 Vendor Identification: %."
> > +		       __stringify(INQUIRY_VENDOR_IDENTIFIER_LEN) "s\n",
> > +		       &to_t10_wwn(item)->vendor[0]);
> > +}  
> 
> This doesn't follow the convention used by other configfs attributes,
> namely that only the value should be reported and no prefix. Please leave
> out the "T10 Vendor Identification: " prefix.

I based this on the convention used with
target_wwn_vpd_unit_serial_show(). I'm happy to drop the prefix if you
prefer.

> > +static ssize_t target_wwn_vendor_id_store(struct config_item *item,
> > +		const char *page, size_t count)
> > +{
> > +	struct t10_wwn *t10_wwn = to_t10_wwn(item);
> > +	struct se_device *dev = t10_wwn->t10_dev;
> > +	/* +1 to ensure buf is zero terminated for stripping */
> > +	unsigned char buf[INQUIRY_VENDOR_IDENTIFIER_LEN + 1];
> > +
> > +	if (strlen(page) > INQUIRY_VENDOR_IDENTIFIER_LEN) {
> > +		pr_err("Emulated T10 Vendor Identification exceeds"
> > +			" INQUIRY_VENDOR_IDENTIFIER_LEN: %d\n",
> > +			INQUIRY_VENDOR_IDENTIFIER_LEN);
> > +		return -EOVERFLOW;
> > +	}  
> 
> Trailing newline(s) should be stripped before the length check is performed. I
> don't think that you want to force users to use "echo -n" instead of "echo" when
> setting this attribute.

This is also a target_wwn_vpd_unit_serial_store() carryover, which
checks the length prior to the strip. Doing so makes buffer length
a little easier to determine.

> > +	strncpy(buf, page, sizeof(buf));  
> 
> Isn't strncpy() deprecated? How about using strlcpy() instead?

Will change to use strlcpy in the next round.

> > +	/*
> > +	 * Check to see if any active $FABRIC_MOD exports exist.  If they
> > +	 * do exist, fail here as changing this information on the fly
> > +	 * (underneath the initiator side OS dependent multipath code)
> > +	 * could cause negative effects.
> > +	 */
> > +	if (dev->export_count) {
> > +		pr_err("Unable to set T10 Vendor Identification while"
> > +			" active %d $FABRIC_MOD exports exist\n",
> > +			dev->export_count);
> > +		return -EINVAL;
> > +	}  
> 
> Are there any users who understand what "$FABRIC_MOD" means? Please leave out that
> string or change it into the name of the fabric driver followed by the name of the
> target port associated with 'item'.

Another target_wwn_vpd_unit_serial_store() carryover. Will drop the
string from the next round.

> > +
> > +	/*
> > +	 * Assume ASCII encoding. Strip any newline added from userspace.
> > +	 * The result may *not* be null terminated.
> > +	 */
> > +	strncpy(dev->t10_wwn.vendor, strstrip(buf),
> > +		INQUIRY_VENDOR_IDENTIFIER_LEN);  
> 
> Keeping strings around that are not '\0'-terminated is a booby trap. It is very
> easy for anyone who modifies or reviews code that uses such strings to overlook
> that the string is not '\0'-terminated. Please increase the size of the vendor[]
> array by one and make sure that that string is '\0'-terminated.

I tend to agree that it's dangerous, but chose to stay somewhat
consistent with the other t10_wwn strings that are treated as though
they may not be NULL terminated.

If you're in favour adding an extra terminator byte here, then I think
it'd make sense to do the same for model[], revision[] and unit_serial[]
too. Are you okay with that approach?

Cheers, David
