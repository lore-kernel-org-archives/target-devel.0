From: Yizhuo Zhai <yzhai003@ucr.edu>
Date: Mon, 07 Oct 2019 19:03:50 +0000
Subject: Potential NULL pointer deference in cxgbit
Message-Id: <CABvMjLQxcV5UE3_j84SV3u2LxJKVoQ2G+5CZCuKtAd6A_6FDNw@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, Kate Stewart <kstewart@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Allison Randal <allison@lohutok.net>, varun@chelsio.com, Enrico Weigelt <info@metux.net>, bvanassche@acm.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Zhiyun Qian <zhiyunq@cs.ucr.edu>, Chengyu Song <csong@cs.ucr.edu>

Hi All:

drivers/target/iscsi/cxgbit/cxgbit_ddp.c:

Inside function cxgbit_ddp_sgl_check(), sg_next() could return NULL,
however, the return value of sg_next() is not checked and get
dereferenced. This could potentially be unsafe.

-- 
Kind Regards,

Yizhuo Zhai

Computer Science, Graduate Student
University of California, Riverside
