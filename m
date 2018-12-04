From: David Disseldorp <ddiss@suse.de>
Date: Tue, 04 Dec 2018 14:58:45 +0000
Subject: Re: [PATCH v6 3/5] target: add device vendor_id configfs attribute
Message-Id: <20181204155845.042c19f1@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181204101238.20587-4-ddiss@suse.de>
In-Reply-To: <20181204101238.20587-4-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Tue, 4 Dec 2018 15:13:51 +0300, Roman Bolshakov wrote:

> > +	/* Assume ASCII encoding. Strip any newline added from userspace. */
> > +	BUILD_BUG_ON(sizeof(dev->t10_wwn.vendor) != INQUIRY_VENDOR_LEN + 1);
> > +	strlcpy(dev->t10_wwn.vendor, strstrip(buf),
> > +		sizeof(dev->t10_wwn.vendor));
> > +  
> 
> Should we allow non-ASCII characters?

No :)

> It's okay to strip final newline
> for convenience. A simple loop would ensure the rest is conformant to
> SPC. EINVAL can be returned otherwise.

I'll add an isascii() loop in the next round.

Cheers, David
