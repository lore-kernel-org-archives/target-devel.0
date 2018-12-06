From: David Disseldorp <ddiss@suse.de>
Date: Thu, 06 Dec 2018 13:01:44 +0000
Subject: Re: [PATCH v7 3/5] target: add device vendor_id configfs attribute
Message-Id: <20181206140144.0afe056a@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181205121838.23982-4-ddiss@suse.de>
In-Reply-To: <20181205121838.23982-4-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Thu, 6 Dec 2018 15:25:42 +0300, Roman Bolshakov wrote:

> >  /*
> > + * STANDARD and VPD page 0x80 T10 Vendor Identification  
> 
> Perhaps you meant 0x83 (Device Identification VPD page, T10 vendor ID
> based designator). INQUIRY page 0x80 is Unit Serial Number.

Indeed, the comment should refer to page 0x83.
@Martin: all patches in this series have now been reviewed+acked. Can
         you fix the above comment (s/0x80/0x83) if/when you merge, or
	 should I resend the series with this fixed?

Cheers, David
