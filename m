From: Martin Svec <martin.svec@zoner.cz>
Date: Tue, 13 Nov 2018 15:17:36 +0000
Subject: SPC-3 persistent reservations race condition
Message-Id: <3ee76029-a49c-e5ce-39c8-62af5f4ce711@zoner.cz>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hello,

during Hyper-V Cluster Validation tests, we hit a bug in SPC-3 persistent reservations
implementation where LIO iSCSI target started to loop indefinitely while freeing
a PR registration.

According to our investigation, there's the following race between pr_reg->pr_res_holders
reference counter and dev->dev_reservation_lock:

(1) Thread A enters core_scsi3_pro_preempt() and locks dev->dev_reservation_lock.

(2) Thread B enters core_scsi3_pro_preempt() and increments pr_reg->pr_res_holders
    by core_scsi3_locate_pr_reg().

(3) Thread B waits for dev->dev_reservation_lock which is held by thread A.

(4) Thread A goes through the registration list and calls __core_scsi3_free_registration()
    to remove all registrations.

(5) When __core_scsi3_free_registration() is called for pr_reg referenced by thread B
    in step 2, it ends up waiting for pr_reg->pr_res_holders = 0 indefinitely.

That is, thread A waits for thread B to decrease pr_res_holders and thread B waits
for thread A to release dev->dev_reservation_lock. 

We're able to reproduce this deadlock in LTS kernels 4.14.78 and 4.9.x but the bug
seems to be there from the beginning. I also guess that the same deadlock can occur in
core_scsi3_emulate_pro_clear() too.

Any ideas how to fix the locking?

Martin
