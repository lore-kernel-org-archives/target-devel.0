From: Mike Christie <mchristi@redhat.com>
Date: Wed, 18 Oct 2017 07:13:55 +0000
Subject: [PATCH 00/17] tcmu: ring buffer fixes
Message-Id: <1508310852-15366-1-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Nick, the following patches were made over the tcmu patches
that have been submitted to the list and I have fixed up and/or
reviewed. I have made a branch here:

https://github.com/mikechristie/target-pending/commits/for-nick-next

built over your for-next branch.

The first patch in the set just fixes up the SAM_STAT_TASK_SET_FULL
handling in transport_generic_request_failure so it does not
get changed to a LUN COMM failure. The rest of the patches fix
several bugs in the tcmu ring buffer code include hangs due to
incorrect locking, threading and IO accounting. It also adds
2 features that allow you to configure the ring buffer size
and how long we wait for memory.

