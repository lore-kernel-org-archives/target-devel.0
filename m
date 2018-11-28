From: David Disseldorp <ddiss@suse.de>
Date: Wed, 28 Nov 2018 16:28:55 +0000
Subject: Re: [PATCH v3 3/4] target: add device vendor_id configfs attribute
Message-Id: <20181128172855.2dfdd7d1@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181119210636.22979-4-ddiss@suse.de>
In-Reply-To: <20181119210636.22979-4-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, 28 Nov 2018 08:08:30 -0800, Bart Van Assche wrote:

> > Just a follow up here. I think it's safer to retain strncpy() in this
> > function for the purpose of zero filling. scsi_dump_inquiry() and
> > target_stat_lu_vend_show() walk the entire length of the t10_wwn.vendor
> > buffer.  
> 
> How about adding a comment about above struct t10_wwn that vendor[], model[]
> and revision[] in that structure may but do not have to be terminated with a
> trailing '\0' and also that unit_serial[] is '\0'-terminated?
> 
> It would make me happy if the size of the character arrays in that structure
> would be increased by one and if the target code would be modified such that
> these strings are always '\0'-terminated.

I'm working on the +1 length increase for those t10_wwn members ATM, but
just thought I'd mention that the zeroing of unused bytes is still
required due to the scsi_dump_inquiry() + target_stat_lu_vend_show()
behaviour.

Cheers, David
