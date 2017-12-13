From: David Disseldorp <ddiss@suse.de>
Date: Wed, 13 Dec 2017 17:22:30 +0000
Subject: [PATCH] target: avoid NULL dereference in CHAP auth error path
Message-Id: <20171213172230.12767-1-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

If chap_server_compute_md5() fails early, e.g. via CHAP_N mismatch, then
crypto_free_shash() is called with a NULL pointer which gets
dereferenced in crypto_shash_tfm().

Fixes: 69110e3cedbb ("iscsi-target: Use shash and ahash")
Suggested-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: David Disseldorp <ddiss@suse.de>
---
This is a minimal fix, similar to Markus's
"target/iscsi: Less function calls in chap_server_compute_md5() after error detection"
patch, but without all of the coding-style changes mixed in.

 drivers/target/iscsi/iscsi_target_auth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index f9bc8ec6fb6b..9518ffd8b8ba 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -421,7 +421,8 @@ static int chap_server_compute_md5(
 	auth_ret = 0;
 out:
 	kzfree(desc);
-	crypto_free_shash(tfm);
+	if (tfm)
+		crypto_free_shash(tfm);
 	kfree(challenge);
 	kfree(challenge_binhex);
 	return auth_ret;
-- 
2.13.6

