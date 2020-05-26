From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 26 May 2020 12:26:45 +0000
Subject: Re: [PATCH] scsi: target: tcmu: Fix a use after free in tcmu_check_expired_queue_cmd()
Message-Id: <20200526122645.GG22511@kadam>
List-Id: <target-devel.vger.kernel.org>
References: <20200523101129.GB98132@mwanda>
 <68d6b1e9-65fa-e91c-e55e-f520839b5efe@ts.fujitsu.com>
In-Reply-To: <68d6b1e9-65fa-e91c-e55e-f520839b5efe@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <mchristi@redhat.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Mon, May 25, 2020 at 11:11:38AM +0200, Bodo Stroesser wrote:
> On 05/23/20 12:11, Dan Carpenter wrote:
> > The pr_debug() dereferences "cmd" after we already freed it by calling
> > tcmu_free_cmd(cmd).  The debug printk needs to be done earlier.
> > 
> > Fixes: 61fb24822166 ("scsi: target: tcmu: Userspace must not complete queued commands")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> >   drivers/target/target_core_user.c | 6 +++---
> >   1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> 
> Thank you.
> 
> I'm very sorry for this stupid bug.

Bugs like this are super common.  Part of being human.  It would have
been hard to discover via testing because you have disable memory
poisoning on free and debugging at the same time.

regards,
dan carpenter
