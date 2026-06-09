Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA39331EDB
	for <target-devel@vger.kernel.org>; Tue,  9 Jun 2026 20:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781036538; cv=none; b=gs7Q2m7xMha1w5+b4kUM+w8nBV9yi3+kv4naQ3l5FcIxyV4vp+6iCnuF19s8JRoP8aQ1K10OzTb8quAxJ4oRrVzXiB/UuCnrJjIIzcTic+ntEajtxIEqnFQvFNytCUM0/A5IWFecl93/Fkg/R8r8j9WBXaeeCYV4zmjizhJM0sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781036538; c=relaxed/simple;
	bh=G7wiigdU6vV1lII5kNx4T7QY98PZzFdThZZfSKMMfXc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CFv0PJBSnRR7IHY01U6Y8sY6tqjxztuByjZbt5HYg4wYO1+zhGVJOwDnTju3Di3pTk2DhkprBTX6zyhdbYnHr4PUMkSoAjRF3RHFZGGduBJiRWF3wje6pMChoYYbMImNcGIdrPfIcYwk3egTm4dXthGTrO8vAWLSOvTDkQZcwnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nk3KPlxG; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nk3KPlxG"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-440ebc72386so3111882fac.3
        for <target-devel@vger.kernel.org>; Tue, 09 Jun 2026 13:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781036536; x=1781641336; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MyKzYwyN8XFtjIuYSRUDu+cXND7kKn1hDM3fJApHDs0=;
        b=Nk3KPlxGd44xFqU7OEXUEk5fPdOBw7KZDmaVRXQ4ofAfumI7qKLkvVxvtc7kU7Qc0e
         auAjkPve321iTUELE74kjaossDaW3hCMlGh8j0f7SPcrKrnMjVrXrpJ2QM8seiy1PUtr
         HyJ/qVnZivMr7AgjI16WkBBM75qNkoCFRgUMUJCkC7RRSplE2LPu4w1q12RQFDjRc9cm
         LlPor9a9rDqcHiWXR57rEAmRNaeepm5GvRnpoJqVLimzQVlnyBtMkHWfkOuHIuqA+LBA
         2/My4fl9zd5GGB4xWsKmwUWC8UJoDc2HDUrrVODrgeSRSjqtW7n4J4E5Wkjf4lkTpike
         jomw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781036536; x=1781641336;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MyKzYwyN8XFtjIuYSRUDu+cXND7kKn1hDM3fJApHDs0=;
        b=PyAuTmIFkwvT1zIjsypjPjOHlisDP6I0eFAQzNM4a1DZZp2EiGDLYNBp4UByA9wYbo
         PbBYFL5HXbiGeuXKpd1wGA2hR1FXQ3lHD2ZZB2g7/VNrpS6tYsX+7AdGwkZ9/vwJPIhS
         N5sJDo6QLG01mu8n2RmZqPBOxvlT16Wjdqtmu9OM1InXybNtbF8waUfJO3BkB1W1pvzO
         GD0vRin2rV7V1HU3O4A30LLT4k0gueLW2MSKlu46uJhBYIb46FfdGS0lbnASJtz2JdLH
         sTqkOeQUVQCl7dbVlYTWMue0BaguAPyaNP3jq73hH92BbhtCtRH8YMqicuCvBKzMLoER
         J49Q==
X-Forwarded-Encrypted: i=1; AFNElJ+hO4nFJx+eFEs9TcLB1KmBjWiWpPmufY9k8hJaSxBfNmJjqZ8+yrdeNSem4NUlxu/kT78R4fEr61ixj6M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXxQcUlhzzHWNm051L8c3LeDzmp766MtUVnHUFwAF7dkSBGm72
	A6zOqOCEcjv9EDTdDCfJbU1gP3cNbQUAkq+G2jh0H1BYBd3s5esWP0VL
X-Gm-Gg: Acq92OFfQDq2pH8BoB1pjhiRzB1p8u1yXTvqbguz7sFis+NEbp/gLs4w5ZuD7s3L/8D
	jIXHJw4wNfPnvwWMjpGdU9XxJQqi3z5s2I4nlv8RxH/N48z7uDqGxwgDu6gqVL4a3i4uz9WfUOv
	FBKrhm2t70tm6qwRlDU97CaA56hwZ5lew2hiqh3HDvgb7vKAxWlrQJ1WRLIZoiW21kMqbKbCO3A
	cq5HMw8oc0RzgFtbqP1yG6yUNFDNykvcVtdAtcLr3n3+e9fZAyDsmm6HcSsnIX0awHnHy+4XFgY
	B01yFwcdpxsvsyJzV1aIBhboq1flLcHh9hAGjU9MGVSUrddERJgvFyx7NIFMsUrJkBh0GAJEl8c
	JFLhmdEtJ8bvEAXDR9ErYjgBofmiA/EnicPsTCy6iXSq0nUMfFH4mLyTlH5lbThBiKb77IqdL89
	YfRpRxqlrq2XVJzO/2Jj2gnu188a+DoO2K/dL1vl0gKfumj8ykzfyju4iXMBj3TKca
X-Received: by 2002:a05:6808:1185:b0:484:afc2:eee3 with SMTP id 5614622812f47-4868dbf2a5fmr12532868b6e.5.1781036535807;
        Tue, 09 Jun 2026 13:22:15 -0700 (PDT)
Received: from localhost.localdomain ([143.166.81.254])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4865b5a5a64sm16888419b6e.4.2026.06.09.13.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 13:22:15 -0700 (PDT)
From: Stuart Hayes <stuart.w.hayes@gmail.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Stuart.Hayes@dell.com,
	Stuart Hayes <stuart.w.hayes@gmail.com>
Subject: [PATCH v2] scsi: target: Allow FUA if no write cache enabled
Date: Tue,  9 Jun 2026 15:21:56 -0500
Message-ID: <20260609202156.90700-1-stuart.w.hayes@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Modify target code to ignore FUA bit in commands to targets with no write
cache enabled.

Without this patch, accesses with FUA set will be rejected, even though
they always go directly to the media when there's no write cache.

This is needed because EDK2 FAT filesystem code sets the FUA bit when
writing, regardless of whether the device advertises support of DPOFUA. If
a UEFI pre-boot write fails, the filesystem can become inaccessible until a
reboot.  This can cause linux installs to iSCSI to be unbootable, because
some systems have firmware that will try to write a file in a
vendor-specific directory under /boot/EFI (such as /boot/EFI/Dell) before
attempting to boot to a UEFI boot entry pointing to a file in the FAT
filesystem.

Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
---
v1->v2:
	- change to only ignore FUA bit set when no write cache is
	  enabled, instead of advertising DPOFUA support
---
 drivers/target/target_core_sbc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 21f5cb86d70c..ffd2b6c9bd23 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -754,6 +754,12 @@ sbc_check_dpofua(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
 	}
 	if (cdb[1] & 0x8) {
 		if (!target_check_fua(dev)) {
+			/*
+			 * Silently ignore FUA if there's no write cache.
+			 */
+			if (!target_check_wce(dev))
+				return 0;
+
 			pr_err("Got CDB: 0x%02x with FUA bit set, but device"
 			       " does not advertise support for FUA write\n",
 			       cdb[0]);
-- 
2.47.3

