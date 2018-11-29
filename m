From: David Disseldorp <ddiss@suse.de>
Date: Thu, 29 Nov 2018 21:33:19 +0000
Subject: Re: [PATCH v4 5/7] target: add device vendor_id configfs attribute
Message-Id: <20181129223319.139a2693@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181129010157.12687-6-ddiss@suse.de>
In-Reply-To: <20181129010157.12687-6-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Thu, 29 Nov 2018 08:32:47 -0800, Bart Van Assche wrote:

> > +	unsigned char buf[INQUIRY_VENDOR_LEN + 1];
> > +
> > +	if (strlen(page) > INQUIRY_VENDOR_LEN) {
> > +		pr_err("Emulated T10 Vendor Identification exceeds"
> > +			" INQUIRY_VENDOR_LEN: " __stringify(INQUIRY_VENDOR_LEN)
> > +			"\n");
> > +		return -EOVERFLOW;
> > +	}  
> 
> Does this force users to use "echo -n" to configure vendor IDs that are
> INQUIRY_VENDOR_LEN bytes long?

It does. As mentioned in v3, this follows the convention used in
target_wwn_vpd_unit_serial_store(). I don't feel too strongly about it,
but it does make buf allocation a little less error prone IMO.

Cheers, David
