Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF26282F16
	for <target-devel@vger.kernel.org>; Fri,  9 Oct 2026 00:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791506146; cv=none; b=u7ugoeRFTLuoYKPQwjmW4Atu3DvjIs+ww/bJoqGtkKEriTtRDBKXv2Eb7IxnluCTyZzELBZRlnxFwc1RUPkXHo9S8lXZ3akh8Ulbnjr6efaGq2NYU4X68Dv0RdrDcFzEH/zFSNHyI/lFLOrw5BVae9TLFyRqEDCkmErnviRkNuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791506146; c=relaxed/simple;
	bh=yka6JI/V/V6RpE2ODPGrIdu0dRDsQCDABjiTa+/MLIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NyBasiwv0Rq+QU+/JIQSkbE+vx9RxFzWBIwtDN9xPtF2tRAxAtYHwAv4Mq2GE8CCioBdXb+eRT9QM2qo2jXwkoANiitXPU5JGHGveSnMOOZyeK/aHPUPe/AqQkjg0R9DggqCmX3JQH9oQkRsf4piMPBKLWHSPfUHr4zvGo7m3Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Iylsnmkf; arc=none smtp.client-ip=209.85.217.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iylsnmkf"
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-7c0466d653fso87609137.3
        for <target-devel@vger.kernel.org>; Thu, 08 Oct 2026 17:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791506144; x=1792110944; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gtpd/G2gn58KFoYIjlWFKfZTxGRss08rArh+p0s4NsY=;
        b=IylsnmkfxhZqTkHyee/TApqPd9+QaU6TSf5MA4RiIs9Ll7ZHbJuzcPTAtYsGHXwxeg
         +lUc/N8UKgFBMb2M0k+0CDcXQ6i/bWnX/AaiCZyLA4Vbol34UzAfVwQwSyUwfSu36FVd
         VG3MRM1lVBJEdg42JmkFnZqV7jvq1+I5MCiCg7I087sWyuIm8znLPMrBCAtY+MqeZmah
         pWNycjEXVxQWkrikpp9GGE87k/RBw7Wxg7E8z+VJnjq9yWjIJZmC77rvQBDDrL/JIMFr
         Sz3ky+lamnRykUCDUDu6OafNLHXBe78a3rx4WrxmMSWfhEILzZd02ZLXKUsBpo9gFwgd
         qJuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791506144; x=1792110944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gtpd/G2gn58KFoYIjlWFKfZTxGRss08rArh+p0s4NsY=;
        b=Ps5dhm9tPy8X/+mYVTqDqIyVHzb2HsneYdIiMtmofVd5ZiCgWRJ21oS9Hs50RKBBU+
         R37eDXByI87SDipPan/VguOsNbP7TnJ0fgq6gnlshaXHu4qumXL+OHoVom2ZKuk8SBLS
         8qQAfE5IpDKLuKNDc1xN0BStogF/eDXjI7rBhXnfsmf0mZ57TG4T0CXrWwRnO4oAmfnA
         nP9pzSRFpvRSY4Md9vuyoun1DKFwDdoBQPhJHwpvWBwnpzo8hl0rnFOyNGX4PMzPUeqQ
         gZX1jvmfbj+3dWQMf9bJwd/9X7D6liHKqefk2mmttdsfYvKswx/6og+fpsZe2jol93Jm
         ONHQ==
X-Forwarded-Encrypted: i=1; AKwUvByWjvX4NRu873PkOpb4BAtd65Vuh/BF9TUbxyyNZLG3eD0TakUIK6cQwYmMh3/IeHRGZFUHhMzqBsQiplI=@vger.kernel.org
X-Gm-Message-State: AFq9FYLnyGK4uLUM7dOQ4CuumGxBKuX0R+hv5helPYxXk3mQ4ZqcMFhm
	d0X+v6YdNxhe5uUGWiUoUQ/AiiihSv/Zbd/Qxo3bA7JV0IE04tFejsww
X-Gm-Gg: AYBFou3JmuH5Tyz0S0owVj7LCFH10qcksrE/flbIl9P892DMaW1RUmkqTf/I0whZOOe
	eXoWPIdGNRZwYgeJuDk1PKIv9z6RfneREFso04Fr0+ZiQCz1+Uh4y4fLnls5T4OXEuqDjuoDqU1
	RdFdDiNNeKDo1v4D0OP86NT5HzNOBziBECWwvdza6M2HjInk/5IYP58edP2TsNPck8h7PEU0oxe
	iHvOXjLFDXB+ToVKWta1hyMJVBqpVRwtgXWjmmXjyPNrYdfSf/xuInswW8MFxZSoW0E0BlpuUxg
	NoWUYWpISukQadETwKuEdWDk956+ObggVqyC2kG5J7xAAzVeXErhLQ27l9Zr8LsSn0ahqbl0yCX
	9XJ0OYOJFd/R/bQ9OI4bpMYVNLjF1P+6oLSsSz8fYIB8WdfWcy6kvuKKEYW7PVr3XY831efUzDp
	ihQWpTM8aNK0lHZcKewP59s4t5p8lZF+6/N5+DyC9qovjkeXSOk/LOlzWQrnGdl/wVcL8nCqz3o
	GjawhhCBRmq2Cz/2w2rRltysU/6wsZIR1JmpZAaO7AXoyy1KnmdaB4G8yTGKjz/+TupqXbN8QpO
	8ipJvsJ8ku2joWv3+gc=
X-Received: by 2002:a05:6102:448d:b0:7a7:12b0:fd03 with SMTP id ada2fe7eead31-7cb361ccc15mr165871137.0.1791506144167;
        Thu, 08 Oct 2026 17:35:44 -0700 (PDT)
Received: from localhost.localdomain ([132.170.205.109])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7cb3539092esm488922137.3.2026.10.08.17.35.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Oct 2026 17:35:43 -0700 (PDT)
From: Sanan Hasanov <sanan.hasanou@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Sanan Hasanov <sanan.hasanov@ucf.edu>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+fa495e1497c48a6ed885@syzkaller.appspotmail.com
Subject: [PATCH v4 2/4] scsi: target: rd: Release protection space on allocation failure
Date: Thu,  8 Oct 2026 20:35:32 -0400
Message-ID: <20261009003537.62265-3-sanan.hasanou@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20261009003537.62265-1-sanan.hasanou@gmail.com>
References: <20261009003537.62265-1-sanan.hasanou@gmail.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sanan Hasanov <sanan.hasanov@ucf.edu>

When rd_allocate_sgl_table() fails, rd_build_prot_space() returns the
error but leaves the partially populated sg_prot_array in place.
pi_prot_type_store() then restores the previous protection type without
calling ->free_prot(), so the pages and scatterlists allocated so far
stay attached to the device. If the user writes pi_prot_type again,
rd_build_prot_space() overwrites sg_prot_array and the earlier
allocation is leaked.

Build the protection space in local variables, free them if the
allocation fails, and only store them in rd_dev on success. The error
path then only touches memory that this call allocated.

Fixes: d7e8eb5d9216 ("target/rd: Add support for protection SGL setup + release")
Signed-off-by: Sanan Hasanov <sanan.hasanov@ucf.edu>
---
 drivers/target/target_core_rd.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 97c63b122..b52d703d2 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -259,12 +259,14 @@ static int rd_build_prot_space(struct rd_dev *rd_dev, int prot_length, int block
 	if (!sg_table)
 		return -ENOMEM;
 
-	rd_dev->sg_prot_array = sg_table;
-	rd_dev->sg_prot_count = sg_tables;
-
 	rc = rd_allocate_sgl_table(rd_dev, sg_table, total_sg_needed, 0xff);
-	if (rc)
+	if (rc) {
+		rd_release_sgl_table(rd_dev, sg_table, sg_tables);
 		return rc;
+	}
+
+	rd_dev->sg_prot_array = sg_table;
+	rd_dev->sg_prot_count = sg_tables;
 
 	pr_debug("CORE_RD[%u] - Built Ramdisk Device ID: %u prot space of"
 		 " %u pages in %u tables\n", rd_dev->rd_host->rd_host_id,
-- 
2.48.1

