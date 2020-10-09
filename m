From: ira.weiny@intel.com
Date: Fri, 09 Oct 2020 19:49:56 +0000
Subject: [PATCH RFC PKS/PMEM 21/58] fs/nfs: Utilize new kmap_thread()
Message-Id: <20201009195033.3208459-22-ira.weiny@intel.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
In-Reply-To: <20201009195033.3208459-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-aio@kvack.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-mmc@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-kselftest@vger.kernel.org, samba-technical@lists.samba.org, Ira Weiny <ira.weiny@intel.com>, ceph-devel@vger.kernel.org, drbd-dev@lists.linbit.com, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, x86@kernel.org, amd-gfx@lists.freedesktop.org, io-uring@vger.kernel.org, cluster-devel@redhat.com, linux-cachefs@redhat.com, intel-wired-lan@lists.osuosl.org, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>, linux-afs@lists.infradead.org, linux-um@lists.infradead.org, intel-gfx@lists.freedesktop.org, ecryptfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, reiserfs-devel@vger.kernel.org, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Trond Myklebust <trond.myklebust@hammerspace.com>, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, netdev@vger.kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, Anna Schumaker <anna.schumaker@netapp.com>, linux-btrfs@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

The kmap() calls in this FS are localized to a single thread.  To avoid
the over head of global PKRS updates use the new kmap_thread() call.

Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Anna Schumaker <anna.schumaker@netapp.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 fs/nfs/dir.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index cb52db9a0cfb..fee321acccb4 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -213,7 +213,7 @@ int nfs_readdir_make_qstr(struct qstr *string, const char *name, unsigned int le
 static
 int nfs_readdir_add_to_array(struct nfs_entry *entry, struct page *page)
 {
-	struct nfs_cache_array *array = kmap(page);
+	struct nfs_cache_array *array = kmap_thread(page);
 	struct nfs_cache_array_entry *cache_entry;
 	int ret;
 
@@ -235,7 +235,7 @@ int nfs_readdir_add_to_array(struct nfs_entry *entry, struct page *page)
 	if (entry->eof != 0)
 		array->eof_index = array->size;
 out:
-	kunmap(page);
+	kunmap_thread(page);
 	return ret;
 }
 
@@ -347,7 +347,7 @@ int nfs_readdir_search_array(nfs_readdir_descriptor_t *desc)
 	struct nfs_cache_array *array;
 	int status;
 
-	array = kmap(desc->page);
+	array = kmap_thread(desc->page);
 
 	if (*desc->dir_cookie = 0)
 		status = nfs_readdir_search_for_pos(array, desc);
@@ -359,7 +359,7 @@ int nfs_readdir_search_array(nfs_readdir_descriptor_t *desc)
 		desc->current_index += array->size;
 		desc->page_index++;
 	}
-	kunmap(desc->page);
+	kunmap_thread(desc->page);
 	return status;
 }
 
@@ -602,10 +602,10 @@ int nfs_readdir_page_filler(nfs_readdir_descriptor_t *desc, struct nfs_entry *en
 
 out_nopages:
 	if (count = 0 || (status = -EBADCOOKIE && entry->eof != 0)) {
-		array = kmap(page);
+		array = kmap_thread(page);
 		array->eof_index = array->size;
 		status = 0;
-		kunmap(page);
+		kunmap_thread(page);
 	}
 
 	put_page(scratch);
@@ -669,7 +669,7 @@ int nfs_readdir_xdr_to_array(nfs_readdir_descriptor_t *desc, struct page *page,
 		goto out;
 	}
 
-	array = kmap(page);
+	array = kmap_thread(page);
 
 	status = nfs_readdir_alloc_pages(pages, array_size);
 	if (status < 0)
@@ -691,7 +691,7 @@ int nfs_readdir_xdr_to_array(nfs_readdir_descriptor_t *desc, struct page *page,
 
 	nfs_readdir_free_pages(pages, array_size);
 out_release_array:
-	kunmap(page);
+	kunmap_thread(page);
 	nfs4_label_free(entry.label);
 out:
 	nfs_free_fattr(entry.fattr);
@@ -803,7 +803,7 @@ int nfs_do_filldir(nfs_readdir_descriptor_t *desc)
 	struct nfs_cache_array *array = NULL;
 	struct nfs_open_dir_context *ctx = file->private_data;
 
-	array = kmap(desc->page);
+	array = kmap_thread(desc->page);
 	for (i = desc->cache_entry_index; i < array->size; i++) {
 		struct nfs_cache_array_entry *ent;
 
@@ -827,7 +827,7 @@ int nfs_do_filldir(nfs_readdir_descriptor_t *desc)
 	if (array->eof_index >= 0)
 		desc->eof = true;
 
-	kunmap(desc->page);
+	kunmap_thread(desc->page);
 	dfprintk(DIRCACHE, "NFS: nfs_do_filldir() filling ended @ cookie %Lu; returning = %d\n",
 			(unsigned long long)*desc->dir_cookie, res);
 	return res;
-- 
2.28.0.rc0.12.gb6a658bd00c9
