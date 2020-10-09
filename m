From: ira.weiny@intel.com
Date: Fri, 09 Oct 2020 19:50:28 +0000
Subject: [PATCH RFC PKS/PMEM 53/58] lib: Utilize new kmap_thread()
Message-Id: <20201009195033.3208459-54-ira.weiny@intel.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
In-Reply-To: <20201009195033.3208459-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-aio@kvack.org, Song Liu <songliubraving@fb.com>, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-mmc@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-kselftest@vger.kernel.org, samba-technical@lists.samba.org, Ira Weiny <ira.weiny@intel.com>, ceph-devel@vger.kernel.org, drbd-dev@lists.linbit.com, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, x86@kernel.org, John Fastabend <john.fastabend@gmail.com>, amd-gfx@lists.freedesktop.org, linux-afs@lists.infradead.org, cluster-devel@redhat.com, linux-cachefs@redhat.com, intel-wired-lan@lists.osuosl.org, Yonghong Song <yhs@fb.com>, linux-ext4@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>, Fenghua Yu <fenghua.yu@intel.com>, linux-um@lists.infradead.org, intel-gfx@lists.freedesktop.org, ecryptfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, reiserfs-devel@vger.kernel.org, linux-block@vger.kernel.org, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, xen-devel@lists.xenproject.org, KP Singh <kpsingh@chromium.org>, Dan Williams <dan.j.williams@intel.com>, io-uring@vger.kernel.org, linux-bcache@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, netdev@vger.kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, Martin KaFai Lau <kafai@fb.com>, linux-btrfs@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

These kmap() calls are localized to a single thread.  To avoid the over
head of global PKRS updates use the new kmap_thread() call.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Jérôme Glisse" <jglisse@redhat.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: Andrii Nakryiko <andriin@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@chromium.org>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 lib/iov_iter.c | 12 ++++++------
 lib/test_bpf.c |  4 ++--
 lib/test_hmm.c |  8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 5e40786c8f12..1d47f957cf95 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -208,7 +208,7 @@ static size_t copy_page_to_iter_iovec(struct page *page, size_t offset, size_t b
 	}
 	/* Too bad - revert to non-atomic kmap */
 
-	kaddr = kmap(page);
+	kaddr = kmap_thread(page);
 	from = kaddr + offset;
 	left = copyout(buf, from, copy);
 	copy -= left;
@@ -225,7 +225,7 @@ static size_t copy_page_to_iter_iovec(struct page *page, size_t offset, size_t b
 		from += copy;
 		bytes -= copy;
 	}
-	kunmap(page);
+	kunmap_thread(page);
 
 done:
 	if (skip = iov->iov_len) {
@@ -292,7 +292,7 @@ static size_t copy_page_from_iter_iovec(struct page *page, size_t offset, size_t
 	}
 	/* Too bad - revert to non-atomic kmap */
 
-	kaddr = kmap(page);
+	kaddr = kmap_thread(page);
 	to = kaddr + offset;
 	left = copyin(to, buf, copy);
 	copy -= left;
@@ -309,7 +309,7 @@ static size_t copy_page_from_iter_iovec(struct page *page, size_t offset, size_t
 		to += copy;
 		bytes -= copy;
 	}
-	kunmap(page);
+	kunmap_thread(page);
 
 done:
 	if (skip = iov->iov_len) {
@@ -1742,10 +1742,10 @@ int iov_iter_for_each_range(struct iov_iter *i, size_t bytes,
 		return 0;
 
 	iterate_all_kinds(i, bytes, v, -EINVAL, ({
-		w.iov_base = kmap(v.bv_page) + v.bv_offset;
+		w.iov_base = kmap_thread(v.bv_page) + v.bv_offset;
 		w.iov_len = v.bv_len;
 		err = f(&w, context);
-		kunmap(v.bv_page);
+		kunmap_thread(v.bv_page);
 		err;}), ({
 		w = v;
 		err = f(&w, context);})
diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index ca7d635bccd9..441f822f56ba 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -6506,11 +6506,11 @@ static void *generate_test_data(struct bpf_test *test, int sub)
 		if (!page)
 			goto err_kfree_skb;
 
-		ptr = kmap(page);
+		ptr = kmap_thread(page);
 		if (!ptr)
 			goto err_free_page;
 		memcpy(ptr, test->frag_data, MAX_DATA);
-		kunmap(page);
+		kunmap_thread(page);
 		skb_add_rx_frag(skb, 0, page, 0, MAX_DATA, MAX_DATA);
 	}
 
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index e7dc3de355b7..e40d26f97f45 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -329,9 +329,9 @@ static int dmirror_do_read(struct dmirror *dmirror, unsigned long start,
 		if (!page)
 			return -ENOENT;
 
-		tmp = kmap(page);
+		tmp = kmap_thread(page);
 		memcpy(ptr, tmp, PAGE_SIZE);
-		kunmap(page);
+		kunmap_thread(page);
 
 		ptr += PAGE_SIZE;
 		bounce->cpages++;
@@ -398,9 +398,9 @@ static int dmirror_do_write(struct dmirror *dmirror, unsigned long start,
 		if (!page || xa_pointer_tag(entry) != DPT_XA_TAG_WRITE)
 			return -ENOENT;
 
-		tmp = kmap(page);
+		tmp = kmap_thread(page);
 		memcpy(tmp, ptr, PAGE_SIZE);
-		kunmap(page);
+		kunmap_thread(page);
 
 		ptr += PAGE_SIZE;
 		bounce->cpages++;
-- 
2.28.0.rc0.12.gb6a658bd00c9
