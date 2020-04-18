From: Randy Dunlap <rdunlap@infradead.org>
Date: Sat, 18 Apr 2020 18:55:38 +0000
Subject: Re: [PATCH 2/9] fs: fix empty-body warning in posix_acl.c
Message-Id: <722a746a-1438-60e3-04b2-c13eda2ad168@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200418184111.13401-1-rdunlap@infradead.org>
 <20200418184111.13401-3-rdunlap@infradead.org>
 <CAHk-=wjSzuTyyBkmMDG4fx_sXzLJsh+9Xk-ubgbpJzJq_kzPsA@mail.gmail.com>
In-Reply-To: <CAHk-=wjSzuTyyBkmMDG4fx_sXzLJsh+9Xk-ubgbpJzJq_kzPsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: alsa-devel@alsa-project.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Zzy Wysm <zzy@zzywysm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, target-devel <target-devel@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Vishal Verma <vishal.l.verma@intel.com>, linux-input@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, "open list:NFS, SUNRPC,
 AND..." <linux-nfs@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, Takashi Iwai <tiwai@suse.com>, Chuck Lever <chuck.lever@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Johannes Berg <johannes@sipsolutions.net>

On 4/18/20 11:53 AM, Linus Torvalds wrote:
> On Sat, Apr 18, 2020 at 11:41 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>>
>> Fix gcc empty-body warning when -Wextra is used:
> 
> Please don't do this.
> 
> First off, "do_empty()" adds nothing but confusion. Now it
> syntactically looks like it does something, and it's a new pattern to
> everybody. I've never seen it before.
> 
> Secondly, even if we were to do this, then the patch would be wrong:
> 
>>         if (cmpxchg(p, ACL_NOT_CACHED, sentinel) != ACL_NOT_CACHED)
>> -               /* fall through */ ;
>> +               do_empty(); /* fall through */
> 
> That comment made little sense before, but it makes _no_ sense now.
> 
> What fall-through? I'm guessing it meant to say "nothing", and
> somebody was confused. With "do_empty()", it's even more confusing.
> 
> Thirdly, there's a *reason* why "-Wextra" isn't used.
> 
> The warnings enabled by -Wextra are usually complete garbage, and
> trying to fix them often makes the code worse. Exactly like here.

OK, no problem.  That's why PATCH 0/9 says RFC.

Oops. Crap. It was *supposed* to say RFC. :(

-- 
~Randy
