Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8342A327BEC
	for <target-devel@vger.kernel.org>; Sat, 19 Sep 2026 17:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789840170; cv=none; b=f5oJRZMsD/24wQyenDDKBr9trFrmP/OaYm8+pbXUG0Z3xY9dg5IwhL04Yj4Tz9jfJB7qpRLza1TE4P2zAiVrn4ZwGn68DtIb7s7fFrWiEHIWkbwcYbK9BMrAxF5tDOcnqmDq3cl3jziwBN4bZut17JUn/gVmsD3zXJ8jaXqcFAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789840170; c=relaxed/simple;
	bh=g6tsjX6Qa/+gUKGSA+7Kv+QYuIKzwo+FzO1cUxU6D7I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NvFpaXZb8jobKHVfcWO3rIH4Cvn4RtJZ/hLYMCJL/+WrX/jNEpx4opTVB8+xae3YaNd7ATre9/2sablZe3VdDZubmLs97l/Cps6XjI2uwLXlNQH6oU8/hDU1LtqQyNC/8bWhjYqnDmPzloLvwrhd39pmmEKoL7SBkLbctPDhTAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BVP5UP2a; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BVP5UP2a"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-398c066106cso1426498a91.1
        for <target-devel@vger.kernel.org>; Sat, 19 Sep 2026 10:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789840169; x=1790444969; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GMcAlqV/8gbRvywKZc2/TEvRO6KQIityZ14E3909GDg=;
        b=BVP5UP2aW+2uHY3qAE4/6Zk6A93dSwyAhMeED0JxnSybyosnaeXzuYlEEr1dZiBVhN
         d0K1nol3825CTjwTo46tEIAVP3NHaDapyiIP8JviZ0vq5zFf6KZ2wT0mq8fFbPVvSjEC
         FXfQ+9fKZbkBw3ylxmrYLScG2IzUMMgjfXrWyQmKkfu6mND/QuUiV8b6zPs9wUb/7ypO
         bK87KU4ctFDjcuf94jYlrMean+x4fon2KIO+rtBhHl5X9bX5vuhBFnoUwyohGVnA+5mP
         NfCc1VJj0sBzPBnNsiSE6B7ZTlJcp8Zo4RaisAsmIjeOWY3N87xAU7tufhHo5UFiXXaX
         xpmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789840169; x=1790444969;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GMcAlqV/8gbRvywKZc2/TEvRO6KQIityZ14E3909GDg=;
        b=uo7qptYxXiejABhGB7PrwLJJizxNKi6hrSzMl62IUceC512vIL7MDGXvjr+nrFpYgj
         GCIua/Ujwag88QBTPPq4KxkBmiKw9gKMRXsTGqSWtXsKwCXiNIR6vVYzjxg6gKPZa0fY
         MrhioqJ6Ubctl4otBTvmMTrZBBrKWGuKOIQjipgZUiEDDv5/fsaeq2d1vzDmlglMlAn6
         SlJKOpZDuqvzT8ZsJeBDWdKMS9xraU6YIEjetUrSFOq4SWrJmr+ZxEJ15+PYiZAy3Hp3
         0JCXUNRMbjWWV9mvN9Iiq47+oJw78JqH1Hn3iBrCjZKAmyrfT3zVBS9bqnlWQtOrLq4T
         b+aw==
X-Forwarded-Encrypted: i=1; AKwUvBwVcrwiNn0G4sGiu1rGUI9ziGwJ25b2ma4bMHOtJoAWGeCWyS9nN3CI+Dq+t0yeVMLPQ56BB9NMK2+NrDs=@vger.kernel.org
X-Gm-Message-State: AFuF++mXDUe8zmLiRJ180juxiHHWgqzKy5Q0+SKeMSDdTJzEF/k+rkuI
	vpOTjgS9hXSLPDyQJcQIFRqhZYsQclJHuurx7SGE9p6B7nB1EAs3+xKH
X-Gm-Gg: AYBFou0Vbpqj4QHBI6DPKI+xVi4afjioLwGHN9+yF+UBy0MOFGoK9cN/AUDcLuuBQgF
	luLgP3H14NJFtBUdlfPEB61zfI4Ez99MZZjY3OG1yLy0HHKgkS36FbwsLuMXfwH/jN6zL9KY0sX
	JeNEYtXT27HV6T1P0P8LQw19L+gFcvqSl2jfR4Efrws5zb4wTYzt7n/tuHAvjcVu5BF902BbQmI
	pqvWrGgAxaQ+yvEjHCuju+aHqO8XcLX+5a2bn8ZkR0tev8Yq95PQ1skqvIRpXeEre9x1nT3YNmC
	ThBI2dqMBv236keC+An+BA37fUYu5yPiiO1dPpT2+qh3Jce2CwI1rXu4Cl5UKn5UHJ4L60Zj5eS
	9JQ+EH6iFMmDQ6wRx9e65ESXdo8CZb83VvrwB79tBUOcvG13+izw7vm8eLvQ9fOmizQhhtnuCfr
	4Ve0ehyp1AN26jptUydA5AbCot3C2S0wjqruxcN2ugQDfbpkZJ4iBsmabBFTXnT9gO8bbF
X-Received: by 2002:a17:90b:4c46:b0:366:3517:1aa2 with SMTP id 98e67ed59e1d1-39e54922644mr15032744a91.0.1789840168712;
        Sat, 19 Sep 2026 10:49:28 -0700 (PDT)
Received: from lgs.. ([101.76.249.46])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6d83e253sm2082331a91.1.2026.09.19.10.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 10:49:28 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kees Cook <kees@kernel.org>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Daniel Wagner <dwagner@suse.de>,
	James Smart <jsmart2021@gmail.com>,
	Hannes Reinecke <hare@suse.de>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH] scsi: elx: efct: fix Scsi_Host memory leaks on add failure
Date: Sun, 20 Sep 2026 01:48:35 +0800
Message-ID: <20260919174835.3729156-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

efct_scsi_new_device() and efct_scsi_new_vport() allocate a Scsi_Host
with scsi_host_alloc() before registering it with
scsi_add_host_with_dma().

If scsi_add_host_with_dma() fails, both functions return without
dropping the initial host reference returned by scsi_host_alloc().
Although scsi_add_host_with_dma() unwinds the resources acquired while
adding the host, it does not release that initial reference. As a result,
scsi_host_dev_release() is never reached and the Scsi_Host allocation is
leaked.

Call scsi_host_put() on both failure paths so the initial reference is
dropped and scsi_host_dev_release() can free the host. Also clear
efct->shost on the physical host failure path since it is assigned before
the host is registered.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: 4df84e846624 ("scsi: elx: efct: Driver initialization routines")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/scsi/elx/efct/efct_xport.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/elx/efct/efct_xport.c b/drivers/scsi/elx/efct/efct_xport.c
index 9dcaef6fc188..c00ad9176aee 100644
--- a/drivers/scsi/elx/efct/efct_xport.c
+++ b/drivers/scsi/elx/efct/efct_xport.c
@@ -416,6 +416,8 @@ efct_scsi_new_device(struct efct *efct)
 				       &efct->pci->dev);
 	if (error) {
 		efc_log_debug(efct, "failed scsi_add_host_with_dma\n");
+		efct->shost = NULL;
+		scsi_host_put(shost);
 		return -EIO;
 	}
 
@@ -930,6 +932,7 @@ efct_scsi_new_vport(struct efct *efct, struct device *dev)
 	error = scsi_add_host_with_dma(shost, dev, &efct->pci->dev);
 	if (error) {
 		efc_log_debug(efct, "failed scsi_add_host_with_dma\n");
+		scsi_host_put(shost);
 		return NULL;
 	}
 
-- 
2.43.0

