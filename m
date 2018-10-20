From: Roland Dreier <roland@kernel.org>
Date: Sat, 20 Oct 2018 16:45:16 +0000
Subject: [PATCH 2/2] target: Don't request modules that aren't even built
Message-Id: <20181020164516.8719-1-roland@kernel.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

If, for example, I don't enable CONFIG_TCM_PSCSI, then every time I load
the target subsystem, I get an annoying

    Unable to load target_core_pscsi

kernel log message.  Instead let's only request_module() on things if that
code is enabled.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/target/target_core_transport.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 86c0156e6c88..eee222db0a14 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -205,19 +205,19 @@ void transport_subsystem_check_init(void)
 	if (sub_api_initialized)
 		return;
 
-	ret = request_module("target_core_iblock");
+	ret = IS_ENABLED(CONFIG_TCM_IBLOCK) && request_module("target_core_iblock");
 	if (ret != 0)
 		pr_err("Unable to load target_core_iblock\n");
 
-	ret = request_module("target_core_file");
+	ret = IS_ENABLED(CONFIG_TCM_FILEIO) && request_module("target_core_file");
 	if (ret != 0)
 		pr_err("Unable to load target_core_file\n");
 
-	ret = request_module("target_core_pscsi");
+	ret = IS_ENABLED(CONFIG_TCM_PSCSI) && request_module("target_core_pscsi");
 	if (ret != 0)
 		pr_err("Unable to load target_core_pscsi\n");
 
-	ret = request_module("target_core_user");
+	ret = IS_ENABLED(CONFIG_TCM_USER2) && request_module("target_core_user");
 	if (ret != 0)
 		pr_err("Unable to load target_core_user\n");
 
-- 
2.19.1
