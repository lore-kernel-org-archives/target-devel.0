From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Wed, 08 Nov 2017 09:43:05 +0000
Subject: Re: [PATCH 1/2] tcmu: Fix some memory corruption
Message-Id: <1510134185.29624.72.camel@haakon3.daterainc.com>
List-Id: <target-devel.vger.kernel.org>
References: <20171108084344.hmqtb5k2puzh3sc6@mwanda>
In-Reply-To: <20171108084344.hmqtb5k2puzh3sc6@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Kenjiro Nakayama <nakayamakenjiro@gmail.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Wed, 2017-11-08 at 11:43 +0300, Dan Carpenter wrote:
> "udev->nl_reply_supported" is an int but on 64 bit arches we are writing
> 8 bytes of data to it so it corrupts four bytes beyond the end of the
> struct.
> 
> Fixes: b849b4567549 ("target: Add netlink command reply supported option for each device")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 

Applied to target-pending/for-next.

