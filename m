Received: from mail-dy2-f41.google.com (mail-dy2-f41.google.com [74.125.229.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8DA5C613
	for <target-devel@vger.kernel.org>; Sun, 27 Sep 2026 05:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790486246; cv=none; b=YCSF7IwpZ+WMBFRHaj8clyGFNlvW2Lx/6TuMO2UgfifuFcQbkZ+tHOUcbdEz1wJgp6/7nXYlITB3pTmJ4co1T8XGQgSMQsYI5jdCYHbfPxOQgUNiu1JJ2Kk2phplK+3UYsQbNB0/fMTkQi1CsSY9N/qtDOKG90HRiBTR7mcvHgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790486246; c=relaxed/simple;
	bh=nWYyEn3FlxnbDE5hfPTdOkEDIO47hQrt3IWc+5iB0G0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AAjjmnVC8rLL1JexCPmkxo6fsAq+aN8lan+1fL1b1bNYE4CAhUu6upXU7E6GHj4zHwqvq5Vs/vIGX1j1nQDz4cFHc51UrlvqzwJRJNrHsHjsQxK/wpmPYqvDGwLHyK6eKks8iiUHwemkp79JGQ/rotZShcO5NgnZziuzvv445jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pc15xYtH; arc=none smtp.client-ip=74.125.229.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pc15xYtH"
Received: by mail-dy2-f41.google.com with SMTP id 5a478bee46e88-343f0ddf131so142780eec.3
        for <target-devel@vger.kernel.org>; Sat, 26 Sep 2026 22:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790486244; x=1791091044; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fYllJEMjqSI9dmThGcCAG+WXxe2fhi4B+5VSXcbhrlk=;
        b=pc15xYtHMkXyln8PLqM50TBJpeK8NQI1vbmHUZ9vKdY6G7P3LJhAUzrEh6D+kSplJR
         NQMgfhFab+awep1voN/hVZ4/Q84K6oj9yAi8neT/i4kLyZ0lKeU16uInYmxRC35duhgL
         ULAW5+Jro6HaqHslL5V/sUPyPQ4kuOPL6gfrurocq7LhFul6eaYf5g3fKavmp7SsHjco
         +XGQ4me41b1WTZIgKyqG3+r37W+AeVspTyv62+t9XHFVudBZL58kE4KwzJwGo9a0k1kn
         VXaB+01nzQXdATLH2OJ61uZSyH+RsBuKacuUpqkKMQAvcp39CDEpquRv/6zuw2ctiZRn
         RIlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790486244; x=1791091044;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fYllJEMjqSI9dmThGcCAG+WXxe2fhi4B+5VSXcbhrlk=;
        b=uuxU6IdBWytbZ9VRjSELA1zpClmhKYrsOIpK4t2RUC5VSqXxmYk/ctTfrP/PwsD7w2
         +PngwIQ+rDNjX8b8DweQoO+gyWnRdC5CQ/IGpx2CRGMeSZQJoVcNmyYZkVEOKnnUfqpK
         mAOPbXuigRCY4fKLvRoeyPRawSoTQLgqKcYZqvbPEUV2pgeT/atPjge4OrGcE5W/j2Km
         Bh22dGU/lvLJu+c34NNCrqrmXx26HZHrHW8PHcMdze52cNTn9TXDvmprkLyXZ2PB0qfa
         5OwMgWVR20chIqU0yfkHoFmNsYG966VD1ypxPEVHNe1ipTBM+lnqcT1FasuoFtUmHpM+
         r49g==
X-Forwarded-Encrypted: i=1; AKwUvByz953l6IlYE+cFBwdZTSZOBxa2W8BLKGicuCGF5WhvjsAU7rO1PRahc8m8ovBAUrAeZEnej2HE3V+dJTM=@vger.kernel.org
X-Gm-Message-State: AFq9FYKUXhn+0Rm1zo2+uAGRFX4QT1fTwNWk4Uv42b/QUEvl396d9nzE
	bi5qtdAlFE7zWU+WD3ufrzPnhL3kZEgT7d4G/JQlWZKMO5gY07r3FfrV
X-Gm-Gg: AYBFou1JgKSmY4hntujLR9w4Fo+HLVw5CtYG9ENvMu47KQntvDWC54wO0lxYOzlCoLs
	c6vItJo3X4j7UCI977jB+z+e69tIV5wB1J5OKWQrRVrL84iLfBj6QGkcRW+rp3jvbZhOLFE2gX2
	5WPfGI63vKtBSual/oCjb8AoOkQQUZL1vzZh2bP/ICP2n1Sc8vWr/pvbHslEz2AZdRSp6OFZluH
	vkbudnqaXQvohsl1IvBzCwXUvCxW/rg5Hi+T1K/epBGXvIbBPeqNNrztuWpC6UXpUdvPf4TV1SB
	DQQU2dQo4mPBqv5BSb9Z15maL5VAsrQK/9wH5WH2KbwBKZy1zGr2O2oTA778uMmqTDBzNZzBcfj
	rn6S+aLpIgfss2cPLuXUUu2sC4m0z3zbksrvayv/qegWKtUUAy/AlloMtyQK3R7ihX4R4+0Cbvw
	LBij4YzDLZWw4zrFL3ADKGat/GHhYR92E50rWetTqYF/0AvseZOJW4EMSvpb7YYFwJkJ908ypff
	n27/7GlQ6Y83RI/edPzQQf83z7/tZHu6tsHW6luS0BzNYXWkYKc6qTmwA9cLW6Jn3PSSdhHWoE9
	aPeUCaZs0lkIOLjMYgXasCu3ByRLolpq2fOlQEuZOjY7L1MFH+F9vIXGzRUDPmJhjuu08OsVgA=
	=
X-Received: by 2002:a05:693c:824c:b0:346:7c2c:1d0c with SMTP id 5a478bee46e88-3467c2c2549mr424577eec.17.1790486243877;
        Sat, 26 Sep 2026 22:17:23 -0700 (PDT)
Received: from FT6N242TWK ([223.181.116.210])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-341459234a1sm18410338eec.24.2026.09.26.22.17.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 26 Sep 2026 22:17:23 -0700 (PDT)
From: Shashank Mohan Jain <jain.sm@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>
Cc: Mike Christie <michael.christie@oracle.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: target: rd: Check the return value of match_int()
Date: Sun, 27 Sep 2026 10:47:17 +0530
Message-ID: <20260927051717.71269-1-jain.sm@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rd_set_configfs_dev_params() ignores the return value of match_int()
for the rd_pages=, rd_nullio= and rd_dummy= options and then uses 'arg'
anyway.

match_token() only matches these options if the value is a number with
nothing after it, but match_int() can still fail with -ERANGE: when the
value is 24 characters or longer, on any architecture, and on 64-bit for
most values outside the range of an int.  'arg' is then not written.  It
still holds the value parsed for an earlier option in the same write, or
is uninitialized if no number was parsed yet.  The write succeeds, and
for rd_pages= that value becomes the page count and RDF_HAS_PAGE_COUNT
is set.  On 64-bit, for example, "rd_nullio=1,rd_pages=4294967296"
configures a one page device, and "rd_pages=4294967296" alone uses an
uninitialized page count (0 with CONFIG_INIT_STACK_ALL_ZERO, which is
only rejected when the device is enabled).  A stale 1 also turns on
RDF_NULLIO or RDF_DUMMY for an invalid rd_nullio= or rd_dummy= value.

Return the error from match_int(), as the fileio and pscsi backends do
for their match_int() options.  As there, options that come before the
invalid one in the same write have already been applied.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Assisted-by: LLM
Signed-off-by: Shashank Mohan Jain <jain.sm@gmail.com>
---
This patch was prepared with Claude Code (Anthropic), model Claude Opus 5.5
(claude-opus-5-5): the analysis, the fix, the changelog and the throwaway
test described below. The trailer only says "Assisted-by: LLM", as
Documentation/process/coding-assistants.rst describes.

Earlier attempts at this fix were not merged:
https://lore.kernel.org/r/1528779148-42485-1-git-send-email-jiazhouyang09@gmail.com
https://lore.kernel.org/r/20190112053159.99406-1-kjlu@umn.edu
This version follows the review comments there: it returns the error
from match_int() instead of -EINVAL, does not leak 'orig', covers
rd_nullio= (and rd_dummy=, added later), and goes through a single exit
path as the fileio backend does.  James Bottomley suggested
ignoring an invalid option instead of failing the write; I went with
returning the error so that a mistyped size is not silently replaced by
a stale or uninitialized one, but ignoring it (a 'break' instead of
'goto out') would also fix the bug.

Dependencies: none. The patch is correct on its own on current mainline.
It is related to "lib: parser: reject out-of-range values in
match_number()", sent to Andrew Morton:
https://lore.kernel.org/r/20260926012718.15675-1-jain.sm@gmail.com
With that patch, out-of-range values also fail on 32-bit (today they
wrap there, for example rd_pages=4294967296 gives 0 pages), and this
patch then turns that failure into an error instead of a stale value.

Testing done:
- W=1 build of drivers/target/target_core_rd.o with allmodconfig for
  x86_64 and i386: no warnings.
- A throwaway KUnit test (not part of this patch) called
  rd_set_configfs_dev_params() under UML (x86_64 and i386 subarch).
  Without the patch, on x86_64:
  "rd_nullio=1,rd_pages=4294967296" returns success with 1 page and
  RDF_HAS_PAGE_COUNT set; "rd_pages=4294967296" gives 0 pages with
  CONFIG_INIT_STACK_ALL_ZERO and 0xfefefefe pages with
  CONFIG_INIT_STACK_ALL_PATTERN; a 24-character rd_nullio= or rd_dummy=
  value of 0 after "rd_pages=1" sets RDF_NULLIO or RDF_DUMMY (also on
  i386).  With the patch all of these writes fail with -ERANGE, and valid
  values (rd_pages=8, rd_pages=0x10, "rd_pages=8,rd_nullio=1,rd_dummy=1",
  rd_pages=2147483647) are unchanged, on x86_64 and i386.

Not tested: writing to the configfs control file of a real rd_mcp device
with targetcli, and enabling such a device.

Not changed: a negative rd_pages= value still parses and becomes a huge
u32 page count, as before.

 drivers/target/target_core_rd.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 092d9fe0d4e3..32762199e742 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -545,7 +545,7 @@ static ssize_t rd_set_configfs_dev_params(struct se_device *dev,
 	struct rd_dev *rd_dev = RD_DEV(dev);
 	char *orig, *ptr, *opts;
 	substring_t args[MAX_OPT_ARGS];
-	int arg, token;
+	int ret = 0, arg, token;
 
 	opts = kstrdup(page, GFP_KERNEL);
 	if (!opts)
@@ -560,14 +560,18 @@ static ssize_t rd_set_configfs_dev_params(struct se_device *dev,
 		token = match_token(ptr, tokens, args);
 		switch (token) {
 		case Opt_rd_pages:
-			match_int(args, &arg);
+			ret = match_int(args, &arg);
+			if (ret)
+				goto out;
 			rd_dev->rd_page_count = arg;
 			pr_debug("RAMDISK: Referencing Page"
 				" Count: %u\n", rd_dev->rd_page_count);
 			rd_dev->rd_flags |= RDF_HAS_PAGE_COUNT;
 			break;
 		case Opt_rd_nullio:
-			match_int(args, &arg);
+			ret = match_int(args, &arg);
+			if (ret)
+				goto out;
 			if (arg != 1)
 				break;
 
@@ -575,7 +579,9 @@ static ssize_t rd_set_configfs_dev_params(struct se_device *dev,
 			rd_dev->rd_flags |= RDF_NULLIO;
 			break;
 		case Opt_rd_dummy:
-			match_int(args, &arg);
+			ret = match_int(args, &arg);
+			if (ret)
+				goto out;
 			if (arg != 1)
 				break;
 
@@ -587,8 +593,9 @@ static ssize_t rd_set_configfs_dev_params(struct se_device *dev,
 		}
 	}
 
+out:
 	kfree(orig);
-	return count;
+	return (!ret) ? count : ret;
 }
 
 static ssize_t rd_show_configfs_dev_params(struct se_device *dev, char *b)
-- 
2.43.0

