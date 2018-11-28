From: David Disseldorp <ddiss@suse.de>
Date: Wed, 28 Nov 2018 15:37:16 +0000
Subject: Re: [PATCH v3 3/4] target: add device vendor_id configfs attribute
Message-Id: <20181128163716.129a2320@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181119210636.22979-4-ddiss@suse.de>
In-Reply-To: <20181119210636.22979-4-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Tue, 20 Nov 2018 19:00:57 +0100, David Disseldorp wrote:

> > > +	strncpy(buf, page, sizeof(buf));    
> > 
> > Isn't strncpy() deprecated? How about using strlcpy() instead?  
> 
> Will change to use strlcpy in the next round.

Just a follow up here. I think it's safer to retain strncpy() in this
function for the purpose of zero filling. scsi_dump_inquiry() and
target_stat_lu_vend_show() walk the entire length of the t10_wwn.vendor
buffer.

Cheers, David
