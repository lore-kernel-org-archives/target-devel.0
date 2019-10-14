From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 14 Oct 2019 11:50:25 +0000
Subject: [bug report] target/cxgbit: Fix endianness annotations
Message-Id: <20191014115025.GA9350@mwanda>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hello Bart Van Assche,

This is a semi-automatic email about new static checker warnings.

The patch 5cadafb236df: "target/cxgbit: Fix endianness annotations"
from Jan 13, 2017, leads to the following Smatch complaint:

    drivers/target/iscsi/cxgbit/cxgbit_cm.c:1836 cxgbit_fw4_ack()
    warn: variable dereferenced before check 'p' (see line 1834)

drivers/target/iscsi/cxgbit/cxgbit_cm.c
  1833			struct sk_buff *p = cxgbit_sock_peek_wr(csk);
  1834			const u32 csum = (__force u32)p->csum;
                                                      ^^^^^^^
We moved this dereference earlier

  1835	
  1836			if (unlikely(!p)) {
                                      ^
so now it's before the NULL check

  1837				pr_err("csk 0x%p,%u, cr %u,%u+%u, empty.\n",
  1838				       csk, csk->tid, credits,

regards,
dan carpenter
