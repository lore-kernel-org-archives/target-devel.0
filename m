From: Randy Dunlap <rdunlap@infradead.org>
Date: Sat, 18 Apr 2020 22:32:05 +0000
Subject: Re: [PATCH 6/9] nfsd: fix empty-body warning in nfs4state.c
Message-Id: <c838fc1d-3973-9cd8-ecc6-8739af514dd0@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200418184111.13401-1-rdunlap@infradead.org>
 <20200418184111.13401-7-rdunlap@infradead.org>
 <CDCF7717-7CBC-47CA-9E83-3A18ECB3AB89@oracle.com>
 <d2e2f7967804446a825ec0ff61095e6640b5a968.camel@hammerspace.com>
In-Reply-To: <d2e2f7967804446a825ec0ff61095e6640b5a968.camel@hammerspace.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Trond Myklebust <trondmy@hammerspace.com>, "chuck.lever@oracle.com" <chuck.lever@oracle.com>
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "zzy@zzywysm.com" <zzy@zzywysm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bfields@fieldses.org" <bfields@fieldses.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "dave.jiang@intel.com" <dave.jiang@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>, "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "johannes@sipsolutions.net" <johannes@sipsolutions.net>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>, "tiwai@suse.com" <tiwai@suse.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>

On 4/18/20 3:28 PM, Trond Myklebust wrote:
> On Sat, 2020-04-18 at 14:45 -0400, Chuck Lever wrote:
>>> On Apr 18, 2020, at 2:41 PM, Randy Dunlap <rdunlap@infradead.org>
>>> wrote:
>>>
>>> Fix gcc empty-body warning when -Wextra is used:
>>>
>>> ../fs/nfsd/nfs4state.c:3898:3: warning: suggest braces around empty
>>> body in an ‘else’ statement [-Wempty-body]
>>>
>>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>>> Cc: Linus Torvalds <torvalds@linux-foundation.org>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: "J. Bruce Fields" <bfields@fieldses.org>
>>> Cc: Chuck Lever <chuck.lever@oracle.com>
>>> Cc: linux-nfs@vger.kernel.org
>>
>> I have a patch in my queue that addresses this particular warning,
>> but your change works for me too.
>>
>> Acked-by: Chuck Lever <chuck.lever@oracle.com>
>>
>> Unless Bruce objects.
>>
>>
>>> ---
>>> fs/nfsd/nfs4state.c |    3 ++-
>>> 1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> --- linux-next-20200417.orig/fs/nfsd/nfs4state.c
>>> +++ linux-next-20200417/fs/nfsd/nfs4state.c
>>> @@ -34,6 +34,7 @@
>>>
>>> #include <linux/file.h>
>>> #include <linux/fs.h>
>>> +#include <linux/kernel.h>
>>> #include <linux/slab.h>
>>> #include <linux/namei.h>
>>> #include <linux/swap.h>
>>> @@ -3895,7 +3896,7 @@ nfsd4_setclientid(struct svc_rqst *rqstp
>>> 		copy_clid(new, conf);
>>> 		gen_confirm(new, nn);
>>> 	} else /* case 4 (new client) or cases 2, 3 (client reboot): */
>>> -		;
>>> +		do_empty();
> 
> Urgh... This is just for documentation purposes anyway, so why not just
> turn it all into a comment by moving the 'else' into the comment field?
> 
> i.e.
> 	} /* else case 4 (.... */
> 
> 	new->cl_minorversion = 0;
>>> 	gen_callback(new, setclid, rqstp);
>>> 	add_to_unconfirmed(new);

Like I said earlier, since Chuck has a patch that addresses this,
let's just go with that.

thanks.
-- 
~Randy
