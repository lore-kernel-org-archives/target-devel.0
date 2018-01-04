From: Randy Dunlap <rdunlap@infradead.org>
Date: Thu, 04 Jan 2018 05:58:58 +0000
Subject: Re: [PATCH] scsi: fix iscsi-related kernel-doc warnings
Message-Id: <617cf496-3fe0-6834-1a6c-57d5adc2f027@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <44a0f532-b1e9-e0cf-4a61-d592a4306f61@infradead.org>
 <yq1373mxny3.fsf@oracle.com>
In-Reply-To: <yq1373mxny3.fsf-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>

On 01/03/2018 08:11 PM, Martin K. Petersen wrote:
> 
> Randy,
> 
>> Fix kernel-doc warnings in drivers/scsi/ that are related to iscsi
>> support interfaces.
>>
>> Fixes these kernel-doc warnings: (tested by adding these files to a new
>> target.rst documentation file: WIP)
> 
> Applied to 4.16/scsi-queue, thanks!
> 
>> Cc:	"Nicholas A. Bellinger" <nab@linux-iscsi.org>
>> Cc:	linux-scsi@vger.kernel.org
>> Cc:	target-devel@vger.kernel.org
>> Cc:	Sagi Grimberg <sagi@grimberg.me>
>> Cc:	linux-rdma@vger.kernel.org
>> Cc:	"James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
>> Cc:	"Martin K. Petersen" <martin.petersen@oracle.com>
> 
>      ^^^ checkpatch complains about these spaces.

Hah, those are tabs, not spaces.

scripts/checkpatch.pl (comment) says something about this being a style thing:
# Check signature styles

WARNING: Use a single space after Cc:
#29: 
Cc:	"Martin K. Petersen" <martin.petersen@oracle.com>



Email standards (RFCs) sure don't require a single space.

and I would like to be able to copy N lines from MAINTAINERS file and then
replace either the M: and/or L: (actually just the 'M' or 'L') with
"To" or "Cc" and be done with it, instead of having to replace TAB on each
line with a space also.

Does anyone know where this "signature style" check came from?
I don't see it in any style guide.

thanks,
-- 
~Randy
