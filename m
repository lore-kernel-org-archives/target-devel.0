From: ira.weiny@intel.com
Date: Fri, 09 Oct 2020 19:50:01 +0000
Subject: [PATCH RFC PKS/PMEM 26/58] fs/zonefs: Utilize new kmap_thread()
Message-Id: <20201009195033.3208459-27-ira.weiny@intel.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
In-Reply-To: <20201009195033.3208459-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-aio@kvack.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-mmc@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-kselftest@vger.kernel.org, samba-technical@lists.samba.org, Ira Weiny <ira.weiny@intel.com>, ceph-devel@vger.kernel.org, drbd-dev@lists.linbit.com, Naohiro Aota <naohiro.aota@wdc.com>, linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, x86@kernel.org, amd-gfx@lists.freedesktop.org, linux-afs@lists.infradead.org, cluster-devel@redhat.com, linux-cachefs@redhat.com, intel-wired-lan@lists.osuosl.org, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>, devel@driverdev.osuosl.org, linux-um@lists.infradead.org, intel-gfx@lists.freedesktop.org, ecryptfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-nfs@vger.kernel.org, reiserfs-devel@vger.kernel.org, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, io-uring@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, linux-ntfs-dev@lists.sourceforge.net, netdev@vger.kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-btrfs@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

The kmap() calls in this FS are localized to a single thread.  To avoid
the over head of global PKRS updates use the new kmap_thread() call.

Cc: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 fs/zonefs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 8ec7c8f109d7..2fd6c86beee1 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -1297,7 +1297,7 @@ static int zonefs_read_super(struct super_block *sb)
 	if (ret)
 		goto free_page;
 
-	super = kmap(page);
+	super = kmap_thread(page);
 
 	ret = -EINVAL;
 	if (le32_to_cpu(super->s_magic) != ZONEFS_MAGIC)
@@ -1349,7 +1349,7 @@ static int zonefs_read_super(struct super_block *sb)
 	ret = 0;
 
 unmap:
-	kunmap(page);
+	kunmap_thread(page);
 free_page:
 	__free_page(page);
 
-- 
2.28.0.rc0.12.gb6a658bd00c9
