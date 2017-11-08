From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Wed, 08 Nov 2017 09:43:29 +0000
Subject: Re: [PATCH 2/2] tcmu: Add a missing unlock on an error path
Message-Id: <1510134209.29624.73.camel@haakon3.daterainc.com>
List-Id: <target-devel.vger.kernel.org>
References: <20171108084415.dn443crpreqwqoiw@mwanda>
In-Reply-To: <20171108084415.dn443crpreqwqoiw@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mike Christie <mchristi@redhat.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Wed, 2017-11-08 at 11:44 +0300, Dan Carpenter wrote:
> We added a new error path here but we forgot to drop the lock first
> before returning.
> 
> Fixes: 0d44374c1aae ("tcmu: fix double se_cmd completion")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied to target-pending/for-next.

Thanks DanC !

