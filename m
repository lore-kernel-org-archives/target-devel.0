From: ira.weiny@intel.com
Date: Fri, 09 Oct 2020 19:50:17 +0000
Subject: [PATCH RFC PKS/PMEM 42/58] drivers/scsi: Utilize new kmap_thread()
Message-Id: <20201009195033.3208459-43-ira.weiny@intel.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
In-Reply-To: <20201009195033.3208459-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-aio@kvack.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-mmc@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-kselftest@vger.kernel.org, samba-technical@lists.samba.org, Ira Weiny <ira.weiny@intel.com>, ceph-devel@vger.kernel.org, drbd-dev@lists.linbit.com, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, x86@kernel.org, amd-gfx@lists.freedesktop.org, linux-afs@lists.infradead.org, cluster-devel@redhat.com, linux-cachefs@redhat.com, intel-wired-lan@lists.osuosl.org, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, intel-gfx@lists.freedesktop.org, Fenghua Yu <fenghua.yu@intel.com>, linux-um@lists.infradead.org, "James E.J. Bottomley" <jejb@linux.ibm.com>, ecryptfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, reiserfs-devel@vger.kernel.org, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, io-uring@vger.kernel.org, linux-nfs@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-ntfs-dev@lists.sourceforge.net, netdev@vger.kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-btrfs@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

These kmap() calls are localized to a single thread.  To avoid the over
head of global PKRS updates use the new kmap_thread() call.

Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/scsi/ipr.c     | 8 ++++----
 drivers/scsi/pmcraid.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index b0aa58d117cc..a5a0b8feb661 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -3923,9 +3923,9 @@ static int ipr_copy_ucode_buffer(struct ipr_sglist *sglist,
 			buffer += bsize_elem) {
 		struct page *page = sg_page(sg);
 
-		kaddr = kmap(page);
+		kaddr = kmap_thread(page);
 		memcpy(kaddr, buffer, bsize_elem);
-		kunmap(page);
+		kunmap_thread(page);
 
 		sg->length = bsize_elem;
 
@@ -3938,9 +3938,9 @@ static int ipr_copy_ucode_buffer(struct ipr_sglist *sglist,
 	if (len % bsize_elem) {
 		struct page *page = sg_page(sg);
 
-		kaddr = kmap(page);
+		kaddr = kmap_thread(page);
 		memcpy(kaddr, buffer, len % bsize_elem);
-		kunmap(page);
+		kunmap_thread(page);
 
 		sg->length = len % bsize_elem;
 	}
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index aa9ae2ae8579..4b05ba4b8a11 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3269,13 +3269,13 @@ static int pmcraid_copy_sglist(
 	for (i = 0; i < (len / bsize_elem); i++, sg = sg_next(sg), buffer += bsize_elem) {
 		struct page *page = sg_page(sg);
 
-		kaddr = kmap(page);
+		kaddr = kmap_thread(page);
 		if (direction = DMA_TO_DEVICE)
 			rc = copy_from_user(kaddr, buffer, bsize_elem);
 		else
 			rc = copy_to_user(buffer, kaddr, bsize_elem);
 
-		kunmap(page);
+		kunmap_thread(page);
 
 		if (rc) {
 			pmcraid_err("failed to copy user data into sg list\n");
@@ -3288,14 +3288,14 @@ static int pmcraid_copy_sglist(
 	if (len % bsize_elem) {
 		struct page *page = sg_page(sg);
 
-		kaddr = kmap(page);
+		kaddr = kmap_thread(page);
 
 		if (direction = DMA_TO_DEVICE)
 			rc = copy_from_user(kaddr, buffer, len % bsize_elem);
 		else
 			rc = copy_to_user(buffer, kaddr, len % bsize_elem);
 
-		kunmap(page);
+		kunmap_thread(page);
 
 		sg->length = len % bsize_elem;
 	}
-- 
2.28.0.rc0.12.gb6a658bd00c9
