From: Randy Dunlap <rdunlap@infradead.org>
Date: Sat, 18 Apr 2020 18:49:58 +0000
Subject: Re: [RFC PATCH 1/9] kernel.h: add do_empty() macro
Message-Id: <3990866b-3331-560d-e5e3-6b51ae51c1e2@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200418184111.13401-1-rdunlap@infradead.org>
 <20200418184111.13401-2-rdunlap@infradead.org>
 <6bb8d99e6e56fa1622fc7238c1ae37c3b3510ded.camel@perches.com>
In-Reply-To: <6bb8d99e6e56fa1622fc7238c1ae37c3b3510ded.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Zzy Wysm <zzy@zzywysm.com>, "J. Bruce Fields" <bfields@fieldses.org>, target-devel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, Vishal Verma <vishal.l.verma@intel.com>, linux-input@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, Takashi Iwai <tiwai@suse.com>, Chuck Lever <chuck.lever@oracle.com>, linux-fsdevel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>, Linus Torvalds <torvalds@linux-foundation.org>

On 4/18/20 11:44 AM, Joe Perches wrote:
> On Sat, 2020-04-18 at 11:41 -0700, Randy Dunlap wrote:
>> Add the do_empty() macro to silence gcc warnings about an empty body
>> following an "if" statement when -Wextra is used.
>>
>> However, for debug printk calls that are being disabled, use either
>> no_printk() or pr_debug() [and optionally dynamic printk debugging]
>> instead.
> []
>> +#define do_empty()		do { } while (0)
> 
> If this is really useful
> (I think the warning is somewhat silly)
> 
> bikeshed:
> 
> I think do_nothing() is more descriptive

Yes, I do too, as I more or less mentioned in the cover letter.

-- 
~Randy
