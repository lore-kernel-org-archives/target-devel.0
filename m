From: David Disseldorp <ddiss@suse.de>
Date: Fri, 23 Oct 2020 20:57:19 +0000
Subject: [PATCH 1/5] lib/scatterlist: use consistent sg_copy_buffer() return type
Message-Id: <20201023205723.17880-2-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20201023205723.17880-1-ddiss@suse.de>
In-Reply-To: <20201023205723.17880-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, David Disseldorp <ddiss@suse.de>

sg_copy_buffer() returns a size_t with the number of bytes copied.
Return 0 instead of false if the copy is skipped.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 lib/scatterlist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 9a4992dc8e8c..be8d6f4c1c05 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -933,7 +933,7 @@ size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents, void *buf,
 	sg_miter_start(&miter, sgl, nents, sg_flags);
 
 	if (!sg_miter_skip(&miter, skip))
-		return false;
+		return 0;
 
 	while ((offset < buflen) && sg_miter_next(&miter)) {
 		unsigned int len;
-- 
2.26.2
