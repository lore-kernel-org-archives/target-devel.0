From: Mike Christie <mchristi@redhat.com>
Date: Sun, 29 Oct 2017 16:41:39 +0000
Subject: Re: [PATCH 00/20] tcmu update
Message-Id: <59F604C3.9050907@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1508950050-10120-1-git-send-email-mchristi@redhat.com>
In-Reply-To: <1508950050-10120-1-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="viscii"
Content-Transfer-Encoding: quoted-printable
To: target-devel@vger.kernel.org

On 10/25/2017 11:47 AM, Mike Christie wrote:
> - Patch 5 - 18 fix bugs in tcmu's ring buffer code.
> - Patch 18 - 20 allow you to configure the size of the ring buffer

Hey Nick,

If you are out there, do not merge patches 5 - 20. I have a patchset
that will simplify things.

You should also drop

commit b8501553476c2eabbd15da79e152a84a9a67dc5a
Author: Xiubo Li <lixiubo@cmss.chinamobile.com>
Date:   Wed Jul 12 15:16:07 2017 +0800

    tcmu: Add fifo type waiter list support to avoid starvation

https://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git/comm=
it/?h=3Dfor-next&id=B8501553476c2eabbd15da79e152a84a9a67dc5a

and

commit 04229774f69250e0f7e63b4d1b50ba8371c9d165
Author: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Tue Aug 1 23:09:17 2017 +0300

    tcmu: Oops in unmap_thread_fn()

    Calling list_del() on the iterator pointer in list_for_each_entry() will
    cause an oops.  We need to user the _safe() version for that.

https://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git/comm=
it/?h=3Dfor-next&id=04229774f69250e0f7e63b4d1b50ba8371c9d165

from your for-next branch. That first patch added several regressions
and the second patch is then not needed. My new patchset will fix the
starvation issue.
