From: ira.weiny@intel.com
Date: Fri, 09 Oct 2020 19:50:06 +0000
Subject: [PATCH RFC PKS/PMEM 31/58] fs/vboxsf: Utilize new kmap_thread()
Message-Id: <20201009195033.3208459-32-ira.weiny@intel.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
In-Reply-To: <20201009195033.3208459-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-aio@kvack.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-mmc@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-kselftest@vger.kernel.org, samba-technical@lists.samba.org, Ira Weiny <ira.weiny@intel.com>, ceph-devel@vger.kernel.org, drbd-dev@lists.linbit.com, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, x86@kernel.org, amd-gfx@lists.freedesktop.org, linux-afs@lists.infradead.org, cluster-devel@redhat.com, linux-cachefs@redhat.com, intel-wired-lan@lists.osuosl.org, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>, linux-um@lists.infradead.org, intel-gfx@lists.freedesktop.org, ecryptfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, reiserfs-devel@vger.kernel.org, linux-block@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, linux-bcache@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, io-uring@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, netdev@vger.kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-btrfs@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

The kmap() calls in this FS are localized to a single thread.  To avoid
the over head of global PKRS updates use the new kmap_thread() call.

Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 fs/vboxsf/file.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/vboxsf/file.c b/fs/vboxsf/file.c
index c4ab5996d97a..d9c7e6b7b4cc 100644
--- a/fs/vboxsf/file.c
+++ b/fs/vboxsf/file.c
@@ -216,7 +216,7 @@ static int vboxsf_readpage(struct file *file, struct page *page)
 	u8 *buf;
 	int err;
 
-	buf = kmap(page);
+	buf = kmap_thread(page);
 
 	err = vboxsf_read(sf_handle->root, sf_handle->handle, off, &nread, buf);
 	if (err = 0) {
@@ -227,7 +227,7 @@ static int vboxsf_readpage(struct file *file, struct page *page)
 		SetPageError(page);
 	}
 
-	kunmap(page);
+	kunmap_thread(page);
 	unlock_page(page);
 	return err;
 }
@@ -268,10 +268,10 @@ static int vboxsf_writepage(struct page *page, struct writeback_control *wbc)
 	if (!sf_handle)
 		return -EBADF;
 
-	buf = kmap(page);
+	buf = kmap_thread(page);
 	err = vboxsf_write(sf_handle->root, sf_handle->handle,
 			   off, &nwrite, buf);
-	kunmap(page);
+	kunmap_thread(page);
 
 	kref_put(&sf_handle->refcount, vboxsf_handle_release);
 
@@ -302,10 +302,10 @@ static int vboxsf_write_end(struct file *file, struct address_space *mapping,
 	if (!PageUptodate(page) && copied < len)
 		zero_user(page, from + copied, len - copied);
 
-	buf = kmap(page);
+	buf = kmap_thread(page);
 	err = vboxsf_write(sf_handle->root, sf_handle->handle,
 			   pos, &nwritten, buf + from);
-	kunmap(page);
+	kunmap_thread(page);
 
 	if (err) {
 		nwritten = 0;
-- 
2.28.0.rc0.12.gb6a658bd00c9
