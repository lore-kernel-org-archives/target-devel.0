From: David Disseldorp <ddiss@suse.de>
Date: Sat, 23 May 2020 13:03:03 +0000
Subject: Re: [PATCH] scsi: target: tcmu: Fix a use after free in tcmu_check_expired_queue_cmd()
Message-Id: <20200523150303.5bd1d24a@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20200523101129.GB98132@mwanda>
In-Reply-To: <20200523101129.GB98132@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Bodo Stroesser <bstroesser@ts.fujitsu.com>, Mike Christie <mchristi@redhat.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Sat, 23 May 2020 13:11:29 +0300, Dan Carpenter wrote:

> The pr_debug() dereferences "cmd" after we already freed it by calling
> tcmu_free_cmd(cmd).  The debug printk needs to be done earlier.
> 
> Fixes: 61fb24822166 ("scsi: target: tcmu: Userspace must not complete queued commands")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: David Disseldorp <ddiss@suse.de>

Looks like this could be squashed in with the change that it fixes,
given that 5.8/scsi-queue hasn't gone out yet.

Cheers, David
