From: ira.weiny@intel.com
Date: Fri, 09 Oct 2020 19:49:53 +0000
Subject: [PATCH RFC PKS/PMEM 18/58] fs/hfs: Utilize new kmap_thread()
Message-Id: <20201009195033.3208459-19-ira.weiny@intel.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
In-Reply-To: <20201009195033.3208459-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-aio@kvack.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-mmc@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-kselftest@vger.kernel.org, samba-technical@lists.samba.org, Ira Weiny <ira.weiny@intel.com>, ceph-devel@vger.kernel.org, drbd-dev@lists.linbit.com, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, x86@kernel.org, amd-gfx@lists.freedesktop.org, linux-afs@lists.infradead.org, cluster-devel@redhat.com, linux-cachefs@redhat.com, intel-wired-lan@lists.osuosl.org, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>, linux-um@lists.infradead.org, intel-gfx@lists.freedesktop.org, ecryptfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, reiserfs-devel@vger.kernel.org, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, io-uring@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, netdev@vger.kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-btrfs@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

The kmap() calls in this FS are localized to a single thread.  To avoid
the over head of global PKRS updates use the new kmap_thread() call.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 fs/hfs/bnode.c | 14 +++++++-------
 fs/hfs/btree.c | 20 ++++++++++----------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/hfs/bnode.c b/fs/hfs/bnode.c
index b63a4df7327b..8b4d02576405 100644
--- a/fs/hfs/bnode.c
+++ b/fs/hfs/bnode.c
@@ -23,8 +23,8 @@ void hfs_bnode_read(struct hfs_bnode *node, void *buf,
 	off += node->page_offset;
 	page = node->page[0];
 
-	memcpy(buf, kmap(page) + off, len);
-	kunmap(page);
+	memcpy(buf, kmap_thread(page) + off, len);
+	kunmap_thread(page);
 }
 
 u16 hfs_bnode_read_u16(struct hfs_bnode *node, int off)
@@ -108,9 +108,9 @@ void hfs_bnode_copy(struct hfs_bnode *dst_node, int dst,
 	src_page = src_node->page[0];
 	dst_page = dst_node->page[0];
 
-	memcpy(kmap(dst_page) + dst, kmap(src_page) + src, len);
-	kunmap(src_page);
-	kunmap(dst_page);
+	memcpy(kmap_thread(dst_page) + dst, kmap_thread(src_page) + src, len);
+	kunmap_thread(src_page);
+	kunmap_thread(dst_page);
 	set_page_dirty(dst_page);
 }
 
@@ -125,9 +125,9 @@ void hfs_bnode_move(struct hfs_bnode *node, int dst, int src, int len)
 	src += node->page_offset;
 	dst += node->page_offset;
 	page = node->page[0];
-	ptr = kmap(page);
+	ptr = kmap_thread(page);
 	memmove(ptr + dst, ptr + src, len);
-	kunmap(page);
+	kunmap_thread(page);
 	set_page_dirty(page);
 }
 
diff --git a/fs/hfs/btree.c b/fs/hfs/btree.c
index 19017d296173..bd4a6d35e361 100644
--- a/fs/hfs/btree.c
+++ b/fs/hfs/btree.c
@@ -80,7 +80,7 @@ struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id, btree_keycmp ke
 		goto free_inode;
 
 	/* Load the header */
-	head = (struct hfs_btree_header_rec *)(kmap(page) + sizeof(struct hfs_bnode_desc));
+	head = (struct hfs_btree_header_rec *)(kmap_thread(page) + sizeof(struct hfs_bnode_desc));
 	tree->root = be32_to_cpu(head->root);
 	tree->leaf_count = be32_to_cpu(head->leaf_count);
 	tree->leaf_head = be32_to_cpu(head->leaf_head);
@@ -119,7 +119,7 @@ struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id, btree_keycmp ke
 	tree->node_size_shift = ffs(size) - 1;
 	tree->pages_per_bnode = (tree->node_size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
-	kunmap(page);
+	kunmap_thread(page);
 	put_page(page);
 	return tree;
 
@@ -268,7 +268,7 @@ struct hfs_bnode *hfs_bmap_alloc(struct hfs_btree *tree)
 
 	off += node->page_offset;
 	pagep = node->page + (off >> PAGE_SHIFT);
-	data = kmap(*pagep);
+	data = kmap_thread(*pagep);
 	off &= ~PAGE_MASK;
 	idx = 0;
 
@@ -281,7 +281,7 @@ struct hfs_bnode *hfs_bmap_alloc(struct hfs_btree *tree)
 						idx += i;
 						data[off] |= m;
 						set_page_dirty(*pagep);
-						kunmap(*pagep);
+						kunmap_thread(*pagep);
 						tree->free_nodes--;
 						mark_inode_dirty(tree->inode);
 						hfs_bnode_put(node);
@@ -290,14 +290,14 @@ struct hfs_bnode *hfs_bmap_alloc(struct hfs_btree *tree)
 				}
 			}
 			if (++off >= PAGE_SIZE) {
-				kunmap(*pagep);
-				data = kmap(*++pagep);
+				kunmap_thread(*pagep);
+				data = kmap_thread(*++pagep);
 				off = 0;
 			}
 			idx += 8;
 			len--;
 		}
-		kunmap(*pagep);
+		kunmap_thread(*pagep);
 		nidx = node->next;
 		if (!nidx) {
 			printk(KERN_DEBUG "create new bmap node...\n");
@@ -313,7 +313,7 @@ struct hfs_bnode *hfs_bmap_alloc(struct hfs_btree *tree)
 		off = off16;
 		off += node->page_offset;
 		pagep = node->page + (off >> PAGE_SHIFT);
-		data = kmap(*pagep);
+		data = kmap_thread(*pagep);
 		off &= ~PAGE_MASK;
 	}
 }
@@ -360,7 +360,7 @@ void hfs_bmap_free(struct hfs_bnode *node)
 	}
 	off += node->page_offset + nidx / 8;
 	page = node->page[off >> PAGE_SHIFT];
-	data = kmap(page);
+	data = kmap_thread(page);
 	off &= ~PAGE_MASK;
 	m = 1 << (~nidx & 7);
 	byte = data[off];
@@ -373,7 +373,7 @@ void hfs_bmap_free(struct hfs_bnode *node)
 	}
 	data[off] = byte & ~m;
 	set_page_dirty(page);
-	kunmap(page);
+	kunmap_thread(page);
 	hfs_bnode_put(node);
 	tree->free_nodes++;
 	mark_inode_dirty(tree->inode);
-- 
2.28.0.rc0.12.gb6a658bd00c9
