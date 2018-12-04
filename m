From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Tue, 04 Dec 2018 13:26:59 +0000
Subject: Re: [PATCH v6 3/5] target: add device vendor_id configfs attribute
Message-Id: <20181204132659.luuhcmux6zwbjzck@SPB-NB-133.local>
List-Id: <target-devel.vger.kernel.org>
References: <20181204101238.20587-4-ddiss@suse.de>
In-Reply-To: <20181204101238.20587-4-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Tue, Dec 04, 2018 at 03:13:51PM +0300, Roman Bolshakov wrote:
> On Tue, Dec 04, 2018 at 11:12:36AM +0100, David Disseldorp wrote:
> > The vendor_id attribute will allow for the modification of the T10
> > Vendor Identification string returned in inquiry responses. Its value
> > can be viewed and modified via the ConfigFS path at:
> > target/core/$backstore/$name/wwn/vendor_id
> > 
> > "LIO-ORG" remains the default value, which is set when the backstore
> > device is enabled.
> > 
> > Signed-off-by: David Disseldorp <ddiss@suse.de>
> > Reviewed-by: Bryant G. Ly <bly@catalogicsoftware.com>
> > Reviewed-by: Lee Duncan <lduncan@suse.com>
> > Reviewed-by: Hannes Reinecke <hare@suse.com>
> > ---
> >  drivers/target/target_core_configfs.c | 48 +++++++++++++++++++++++++++++++++++
> >  1 file changed, 48 insertions(+)
> > 
> > diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> > index 34872f24e8bf..67303c3f9cb4 100644
> > --- a/drivers/target/target_core_configfs.c
> > +++ b/drivers/target/target_core_configfs.c
> > +
> > +	/* Assume ASCII encoding. Strip any newline added from userspace. */
> > +	BUILD_BUG_ON(sizeof(dev->t10_wwn.vendor) != INQUIRY_VENDOR_LEN + 1);
> > +	strlcpy(dev->t10_wwn.vendor, strstrip(buf),
> > +		sizeof(dev->t10_wwn.vendor));
> > +
> 
> Should we allow non-ASCII characters? It's okay to strip final newline
> for convenience. A simple loop would ensure the rest is conformant to
> SPC. EINVAL can be returned otherwise.
> 
> And for fuzzy purposes there could be a special backstore that does all
> sorts of nasty things.
> 
> According to SPC 4.3.1:
> ASCII data fields shall contain only ASCII printable characters (i.e.,
> code values 20h to 7Eh) and may be terminated with one or more ASCII
> null (00h) characters.
> 
> 3.3.10 shall
> keyword indicating a mandatory requirement
> Note 1 to entry: Designers are required to implement all such
> interoperability with other products that conform to this standard.
> 
> Thank you,
> Roman

wrt PATCH 5 in the series. Should we allow to set vendor_id for for
pscsi? target_transport_configure sets t10_wwn fields for pscsi, but but
an attempt to set vendor_id will overwrite the value recieved from
scsi_device.

And (please correct me if I'm wrong) it's not used anywhere except
statistics config_group. That means in the actual INQUIRY commands it
will still return vendor_id of the underlying storage. If that's that's
true, this means an attempt to set vendor_id will be succesful but it
won't do what's intended for.

Perhaps -ENOSYS or an error code of your preference could be returned if
device has TRANSPORT_FLAG_PASSTHROUGH.

Roman
