From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date: Wed, 21 Oct 2020 12:17:21 +0000
Subject: [PATCH v3 0/6] Documentation build fixes against upstream
Message-Id: <cover.1603282193.git.mchehab+huawei@kernel.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Luben Tuikov <luben.tuikov@amd.com>, kunit-dev@googlegroups.com, David Airlie <airlied@linux.ie>, Brendan Higgins <brendanhiggins@google.com>, dri-devel@lists.freedesktop.org, target-devel@vger.kernel.org, linux-kselftest@vger.kernel.org, Max Gurtovoy <maxg@mellanox.com>, Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Bart Van Assche <bvanassche@acm.org>, Jonathan Corbet <corbet@lwn.net>, Mauro Carvalho Chehab <mchehab+huawei@kernel.org>, Bernard Zhao <bernard@vivo.com>, amd-gfx@lists.freedesktop.org, Ingo Molnar <mingo@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, Colton Lewis <colton.w.lewis@protonmail.com>, Ben Skeggs <bskeggs@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, Dave Airlie <airlied@redhat.com>, Iurii Zaikin <yzaikin@google.com>, Dennis Li <Dennis.Li@amd.com>, linux-rdma@vger.kernel.org, Yamin Friedman <yaminf@mellanox.com>, Andrey Grodzovsky <andrey.grodzovsky@amd.com>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Boqun Feng <boqun.feng@gmail.com>, Josef Bacik <josef@toxicpanda.com>, Christophe JAILLET <christophe.jaillet@wanadoo.fr>, Shuah Khan <skhan@linuxfoundation.org>, David Sterba <dsterba@suse.com>, Evan Quan <evan.quan@amd.com>, Ingo Molnar <mingo@redhat.com>, Sagi Grimberg <sagi@grimberg.me>, Stephen Boyd <sboyd@kernel.org>, linux-kernel@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>, Peter Zijlstra <peterz@infradead.org>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Daniel Vetter <daniel@ffwll.ch>, Alex Deucher <alexander.deucher@amd.com>, Alan Maguire <alan.maguire@oracle.com>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Hawking Zhang <Hawking.Zhang@amd.com>

As we're close to the end of the merge window for Kernel 5.10,
this series contain the patches from the past two documentation
fix series I sent during the merge window and that required more
work.

It is based on the top of upstream. The full series with the patches
that either didn't generate any reply or have been acked is on
this branch:

	https://git.linuxtv.org/mchehab/experimental.git/log/?h=docs_for_v5.10

There are a couple of warnings that aren't addressed here, because
they don't show at linux-next. I'm keeping a second patch series 
against next-20201021 fixing additional warnings caused by patches
pending merges.

I'll be posting those in separate.

Regards,
Mauro

Mauro Carvalho Chehab (6):
  drm: amdgpu: kernel-doc: update some adev parameters
  docs: lockdep-design: fix some warning issues
  locking/refcount: move kernel-doc markups to the proper place
  IB/srpt: docs: add a description for cq_size  member
  kunit: test: fix remaining kernel-doc warnings
  docs: fs: api-summary.rst: get rid of kernel-doc include

 Documentation/filesystems/api-summary.rst    |   3 -
 Documentation/locking/lockdep-design.rst     |  51 +++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c   |  28 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_gtt_mgr.c  |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c |   7 +-
 drivers/infiniband/ulp/srpt/ib_srpt.h        |   1 +
 include/kunit/test.h                         |  16 +-
 include/linux/refcount.h                     | 158 +++++++++----------
 8 files changed, 139 insertions(+), 131 deletions(-)

-- 
2.26.2
