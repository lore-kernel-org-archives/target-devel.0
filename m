From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Date: Fri, 17 Jan 2020 16:42:29 +0000
Subject: RE: [PATCH] RDMA/isert: Fix a recently introduced regression related to logout
Message-Id: <MWHPR1101MB22715AD3606D8C7DCB6C740F86310@MWHPR1101MB2271.namprd11.prod.outlook.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200116044737.19507-1-bvanassche@acm.org>
In-Reply-To: <20200116044737.19507-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Rahul Kundu <rahul.kundu@chelsio.com>

> Subject: [PATCH] RDMA/isert: Fix a recently introduced regression related to
> logout
> 
> iscsit_close_connection() calls isert_wait_conn(). Due to commit
> e9d3009cb936 both functions call target_wait_for_sess_cmds() although
> that last function should be called only once. Fix this by removing
> the target_wait_for_sess_cmds() call from isert_wait_conn() and by
> only calling isert_wait_conn() after target_wait_for_sess_cmds().
> 
> Reported-by: Rahul Kundu <rahul.kundu@chelsio.com>
> Fixes: e9d3009cb936 ("scsi: target: iscsi: Wait for all commands to finish
> before freeing a session").
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Tested-by: Mike Marciniszyn <mike.marciniszyn@intel.com>

Mike
