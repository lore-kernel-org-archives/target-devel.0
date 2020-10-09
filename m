From: ira.weiny@intel.com
Date: Fri, 09 Oct 2020 19:50:13 +0000
Subject: [PATCH RFC PKS/PMEM 38/58] fs/isofs: Utilize new kmap_thread()
Message-Id: <20201009195033.3208459-39-ira.weiny@intel.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
In-Reply-To: <20201009195033.3208459-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-aio@kvack.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-mmc@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-kselftest@vger.kernel.org, samba-technical@lists.samba.org, Ira Weiny <ira.weiny@intel.com>, ceph-devel@vger.kernel.org, drbd-dev@lists.linbit.com, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, x86@kernel.org, amd-gfx@lists.freedesktop.org, linux-afs@lists.infradead.org, cluster-devel@redhat.com, linux-cachefs@redhat.com, intel-wired-lan@lists.osuosl.org, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>, linux-um@lists.infradead.org, intel-gfx@lists.freedesktop.org, ecryptfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, reiserfs-devel@vger.kernel.org, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, io-uring@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, netdev@vger.kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-btrfs@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

These kmap() calls are localized to a single thread.  To avoid the over head of
global PKRS updates use the new kmap_thread() call.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 fs/isofs/compress.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/isofs/compress.c b/fs/isofs/compress.c
index bc12ac7e2312..ddd3fd99d2e1 100644
--- a/fs/isofs/compress.c
+++ b/fs/isofs/compress.c
@@ -344,7 +344,7 @@ static int zisofs_readpage(struct file *file, struct page *page)
 			pages[i] = grab_cache_page_nowait(mapping, index);
 		if (pages[i]) {
 			ClearPageError(pages[i]);
-			kmap(pages[i]);
+			kmap_thread(pages[i]);
 		}
 	}
 
@@ -356,7 +356,7 @@ static int zisofs_readpage(struct file *file, struct page *page)
 			flush_dcache_page(pages[i]);
 			if (i = full_page && err)
 				SetPageError(pages[i]);
-			kunmap(pages[i]);
+			kunmap_thread(pages[i]);
 			unlock_page(pages[i]);
 			if (i != full_page)
 				put_page(pages[i]);
-- 
2.28.0.rc0.12.gb6a658bd00c9
