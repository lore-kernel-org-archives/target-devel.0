From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Tue, 21 Jan 2020 05:30:53 +0000
Subject: Re: [PATCH] RDMA/isert: Fix a recently introduced regression related to logout
Message-Id: <yq1d0bdidf6.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200116044737.19507-1-bvanassche@acm.org>
In-Reply-To: <20200116044737.19507-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Wed, 15 Jan 2020 20:47:37 -0800")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Rahul Kundu <rahul.kundu@chelsio.com>


Bart,

> iscsit_close_connection() calls isert_wait_conn(). Due to commit
> e9d3009cb936 both functions call target_wait_for_sess_cmds() although
> that last function should be called only once. Fix this by removing
> the target_wait_for_sess_cmds() call from isert_wait_conn() and by
> only calling isert_wait_conn() after target_wait_for_sess_cmds().

Applied to 5.5/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
