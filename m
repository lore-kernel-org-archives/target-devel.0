From: ira.weiny@intel.com
Date: Fri, 09 Oct 2020 19:50:27 +0000
Subject: [PATCH RFC PKS/PMEM 52/58] mm: Utilize new kmap_thread()
Message-Id: <20201009195033.3208459-53-ira.weiny@intel.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
In-Reply-To: <20201009195033.3208459-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-aio@kvack.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-mmc@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-kselftest@vger.kernel.org, samba-technical@lists.samba.org, Ira Weiny <ira.weiny@intel.com>, ceph-devel@vger.kernel.org, drbd-dev@lists.linbit.com, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, x86@kernel.org, amd-gfx@lists.freedesktop.org, linux-afs@lists.infradead.org, cluster-devel@redhat.com, linux-cachefs@redhat.com, intel-wired-lan@lists.osuosl.org, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>, linux-um@lists.infradead.org, intel-gfx@lists.freedesktop.org, ecryptfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, reiserfs-devel@vger.kernel.org, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, io-uring@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, netdev@vger.kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-btrfs@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

These kmap() calls are localized to a single thread.  To avoid the over
head of global PKRS updates use the new kmap_thread() call.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 mm/memory.c      | 8 ++++----
 mm/swapfile.c    | 4 ++--
 mm/userfaultfd.c | 4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index fcfc4ca36eba..75a054882d7a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4945,7 +4945,7 @@ int __access_remote_vm(struct task_struct *tsk, struct mm_struct *mm,
 			if (bytes > PAGE_SIZE-offset)
 				bytes = PAGE_SIZE-offset;
 
-			maddr = kmap(page);
+			maddr = kmap_thread(page);
 			if (write) {
 				copy_to_user_page(vma, page, addr,
 						  maddr + offset, buf, bytes);
@@ -4954,7 +4954,7 @@ int __access_remote_vm(struct task_struct *tsk, struct mm_struct *mm,
 				copy_from_user_page(vma, page, addr,
 						    buf, maddr + offset, bytes);
 			}
-			kunmap(page);
+			kunmap_thread(page);
 			put_page(page);
 		}
 		len -= bytes;
@@ -5216,14 +5216,14 @@ long copy_huge_page_from_user(struct page *dst_page,
 
 	for (i = 0; i < pages_per_huge_page; i++) {
 		if (allow_pagefault)
-			page_kaddr = kmap(dst_page + i);
+			page_kaddr = kmap_thread(dst_page + i);
 		else
 			page_kaddr = kmap_atomic(dst_page + i);
 		rc = copy_from_user(page_kaddr,
 				(const void __user *)(src + i * PAGE_SIZE),
 				PAGE_SIZE);
 		if (allow_pagefault)
-			kunmap(dst_page + i);
+			kunmap_thread(dst_page + i);
 		else
 			kunmap_atomic(page_kaddr);
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index debc94155f74..e3296ff95648 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3219,7 +3219,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		error = PTR_ERR(page);
 		goto bad_swap_unlock_inode;
 	}
-	swap_header = kmap(page);
+	swap_header = kmap_thread(page);
 
 	maxpages = read_swap_header(p, swap_header, inode);
 	if (unlikely(!maxpages)) {
@@ -3395,7 +3395,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		filp_close(swap_file, NULL);
 out:
 	if (page && !IS_ERR(page)) {
-		kunmap(page);
+		kunmap_thread(page);
 		put_page(page);
 	}
 	if (name)
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 9a3d451402d7..4d38c881bb2d 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -586,11 +586,11 @@ static __always_inline ssize_t __mcopy_atomic(struct mm_struct *dst_mm,
 			mmap_read_unlock(dst_mm);
 			BUG_ON(!page);
 
-			page_kaddr = kmap(page);
+			page_kaddr = kmap_thread(page);
 			err = copy_from_user(page_kaddr,
 					     (const void __user *) src_addr,
 					     PAGE_SIZE);
-			kunmap(page);
+			kunmap_thread(page);
 			if (unlikely(err)) {
 				err = -EFAULT;
 				goto out;
-- 
2.28.0.rc0.12.gb6a658bd00c9
