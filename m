From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Fri, 25 Oct 2019 00:22:36 +0000
Subject: Re: [PATCH] target/cxgbit: Fix cxgbit_fw4_ack()
Message-Id: <yq1ftjhd67n.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20191023202150.22173-1-bvanassche@acm.org>
In-Reply-To: <20191023202150.22173-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Wed, 23 Oct 2019 13:21:50 -0700")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Mike Christie <mchristi@redhat.com>, Christoph Hellwig <hch@lst.de>, target-devel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>, Varun Prakash <varun@chelsio.com>, Nicholas Bellinger <nab@linux-iscsi.org>, stable@vger.kernel.org


> Use the pointer 'p' after having tested that pointer instead of before.

Thanks, Bart! Applied to 5.4/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
