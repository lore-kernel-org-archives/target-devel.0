From: ira.weiny@intel.com
Date: Fri, 09 Oct 2020 19:50:02 +0000
Subject: [PATCH RFC PKS/PMEM 27/58] fs/ubifs: Utilize new kmap_thread()
Message-Id: <20201009195033.3208459-28-ira.weiny@intel.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
In-Reply-To: <20201009195033.3208459-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-aio@kvack.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-mmc@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-kselftest@vger.kernel.org, samba-technical@lists.samba.org, Ira Weiny <ira.weiny@intel.com>, ceph-devel@vger.kernel.org, drbd-dev@lists.linbit.com, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, Richard Weinberger <richard@nod.at>, x86@kernel.org, amd-gfx@lists.freedesktop.org, linux-afs@lists.infradead.org, cluster-devel@redhat.com, linux-cachefs@redhat.com, intel-wired-lan@lists.osuosl.org, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>, linux-um@lists.infradead.org, intel-gfx@lists.freedesktop.org, ecryptfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, reiserfs-devel@vger.kernel.org, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, io-uring@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, netdev@vger.kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-btrfs@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

The kmap() calls in this FS are localized to a single thread.  To avoid
the over head of global PKRS updates use the new kmap_thread() call.

Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 fs/ubifs/file.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index b77d1637bbbc..a3537447a885 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -111,7 +111,7 @@ static int do_readpage(struct page *page)
 	ubifs_assert(c, !PageChecked(page));
 	ubifs_assert(c, !PagePrivate(page));
 
-	addr = kmap(page);
+	addr = kmap_thread(page);
 
 	block = page->index << UBIFS_BLOCKS_PER_PAGE_SHIFT;
 	beyond = (i_size + UBIFS_BLOCK_SIZE - 1) >> UBIFS_BLOCK_SHIFT;
@@ -174,7 +174,7 @@ static int do_readpage(struct page *page)
 	SetPageUptodate(page);
 	ClearPageError(page);
 	flush_dcache_page(page);
-	kunmap(page);
+	kunmap_thread(page);
 	return 0;
 
 error:
@@ -182,7 +182,7 @@ static int do_readpage(struct page *page)
 	ClearPageUptodate(page);
 	SetPageError(page);
 	flush_dcache_page(page);
-	kunmap(page);
+	kunmap_thread(page);
 	return err;
 }
 
@@ -616,7 +616,7 @@ static int populate_page(struct ubifs_info *c, struct page *page,
 	dbg_gen("ino %lu, pg %lu, i_size %lld, flags %#lx",
 		inode->i_ino, page->index, i_size, page->flags);
 
-	addr = zaddr = kmap(page);
+	addr = zaddr = kmap_thread(page);
 
 	end_index = (i_size - 1) >> PAGE_SHIFT;
 	if (!i_size || page->index > end_index) {
@@ -692,7 +692,7 @@ static int populate_page(struct ubifs_info *c, struct page *page,
 	SetPageUptodate(page);
 	ClearPageError(page);
 	flush_dcache_page(page);
-	kunmap(page);
+	kunmap_thread(page);
 	*n = nn;
 	return 0;
 
@@ -700,7 +700,7 @@ static int populate_page(struct ubifs_info *c, struct page *page,
 	ClearPageUptodate(page);
 	SetPageError(page);
 	flush_dcache_page(page);
-	kunmap(page);
+	kunmap_thread(page);
 	ubifs_err(c, "bad data node (block %u, inode %lu)",
 		  page_block, inode->i_ino);
 	return -EINVAL;
@@ -918,7 +918,7 @@ static int do_writepage(struct page *page, int len)
 	/* Update radix tree tags */
 	set_page_writeback(page);
 
-	addr = kmap(page);
+	addr = kmap_thread(page);
 	block = page->index << UBIFS_BLOCKS_PER_PAGE_SHIFT;
 	i = 0;
 	while (len) {
@@ -950,7 +950,7 @@ static int do_writepage(struct page *page, int len)
 	ClearPagePrivate(page);
 	ClearPageChecked(page);
 
-	kunmap(page);
+	kunmap_thread(page);
 	unlock_page(page);
 	end_page_writeback(page);
 	return err;
-- 
2.28.0.rc0.12.gb6a658bd00c9
