From: Randy Dunlap <rdunlap@infradead.org>
Date: Fri, 23 Feb 2018 00:38:37 +0000
Subject: target documentation patches?
Message-Id: <e2bc69ce-2270-7996-ca50-928fa3c71ffa@infradead.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi Nicholas,

I posted several patches for target documentation cleanups and adding
a chapter to the driver-api chapter back in December.

Do I need to repost those?  Do you want someone else to merge them, even
though several of them are in drivers/target/ ?


[PATCH] target: fix kernel-doc warnings in drivers/target/target_core_transport.c
https://www.spinics.net/lists/target-devel/msg16378.html

[PATCH] target: cleanup target_core_transport.c for kernel-doc
https://www.spinics.net/lists/target-devel/msg16381.html

[PATCH] target: add kernel-doc overview in target_core_user.[hc]
https://www.spinics.net/lists/target-devel/msg16380.html

[PATCH v2] target: add a target/iscsi driver-api Documentation chapter
https://www.spinics.net/lists/target-devel/msg16383.html

This patch has already been merged:
[PATCH] scsi: fix iscsi-related kernel-doc warnings
  https://marc.info/?l=linux-scsi&m1398051426923&w=2


thanks,
-- 
~Randy
