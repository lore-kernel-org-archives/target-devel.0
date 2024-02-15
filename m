Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0586813246B
	for <target-devel@vger.kernel.org>; Thu, 15 Feb 2024 14:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708007998; cv=none; b=c38A5ca8F3ct5qzgkRbv5BbLsyqdJxPAaqVL8TDTzBksVYFnqjk1zHfeaCPpLTHUeQRgm0bRA8zjAUsbguokKiptSX3gClAv7P2fKpOijCb0aoOBrmD7H8X1dJ30Nz5OsGJkWklYe6JCAoISNdQ78fGEEOp4KtZaqwdKHbp92WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708007998; c=relaxed/simple;
	bh=5QjbBfVEkcElXu49JZBLrmwO07FcPAyl3bJ/GQNX4go=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U8zZXPavxqDa6Xf4bls7DpZYM3LPYsNMKsEi/J+SxyGh347152pz96+n6s3qEMcqTqZLg1J9zze+yfXYOyT+JILpbFdrd19ysw07KAyym4RGwtdqi1Z+buP1+2nWfq4CnCWjRpxHWNxQnmDS/ui9R+3s0Y4MEpYZm8vdfHP/I7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c30MvFDG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c30MvFDG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708007995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fTaL/Wmwx0q9eUMq67PddSTgAdguaj7sxRsXalaYDMc=;
	b=c30MvFDGsJvnir8ADtEsd9S+PwnGkMbL2WTmShHbcqRHv6/MQL18TcfVmqFQQOFsUm1iPS
	7zBLJ4CD35ZFlNJ2RFReOhvod8b1fyUfVg+gXbvCQEmpmFJdrxbu+tTC6laVogiGXzmXmM
	6NrGmwalNAR8HBZnKlJVbParwUziN8s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-371-0HoolzCJPsq-gon2v2_CHQ-1; Thu, 15 Feb 2024 09:39:50 -0500
X-MC-Unique: 0HoolzCJPsq-gon2v2_CHQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 59C9F8A0110;
	Thu, 15 Feb 2024 14:39:50 +0000 (UTC)
Received: from kalibr.redhat.com (unknown [10.47.238.145])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7C0AC40153A7;
	Thu, 15 Feb 2024 14:39:48 +0000 (UTC)
From: Maurizio Lombardi <mlombard@redhat.com>
To: michael.christie@oracle.com
Cc: d.bogdanov@yadro.com,
	target-devel@vger.kernel.org,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	james.bottomley@hansenpartnership.com
Subject: [PATCH V2 1/2] target: fix selinux error when systemd-modules loads the target module
Date: Thu, 15 Feb 2024 15:39:43 +0100
Message-Id: <20240215143944.847184-2-mlombard@redhat.com>
In-Reply-To: <20240215143944.847184-1-mlombard@redhat.com>
References: <20240215143944.847184-1-mlombard@redhat.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

If the systemd-modules service loads the target module, the credentials
of that userspace process will be used to validate the access to the
target db directory.
selinux will prevent it, reporting an error like the following:

kernel: audit: type=1400 audit(1676301082.205:4): avc: denied  { read }
for  pid=1020 comm="systemd-modules" name="target" dev="dm-3"
ino=4657583 scontext=system_u:system_r:systemd_modules_load_t:s0
tcontext=system_u:object_r:targetd_etc_rw_t:s0 tclass=dir permissive=0

Fix the error by using the kernel credentials to access the db directory

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---

v2: call target_xcopy_release_pt() to destroy the xcopy_wq in case of failure

 drivers/target/target_core_configfs.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index a5f58988130a..3f3dd0c0ce8c 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3656,6 +3656,8 @@ static int __init target_core_init_configfs(void)
 {
 	struct configfs_subsystem *subsys = &target_core_fabrics;
 	struct t10_alua_lu_gp *lu_gp;
+	struct cred *kern_cred;
+	const struct cred *old_cred;
 	int ret;
 
 	pr_debug("TARGET_CORE[0]: Loading Generic Kernel Storage"
@@ -3732,11 +3734,21 @@ static int __init target_core_init_configfs(void)
 	if (ret < 0)
 		goto out;
 
+	/* We use the kernel credentials to access the target directory */
+	kern_cred = prepare_kernel_cred(&init_task);
+	if (!kern_cred) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	old_cred = override_creds(kern_cred);
 	target_init_dbroot();
+	revert_creds(old_cred);
+	put_cred(kern_cred);
 
 	return 0;
 
 out:
+	target_xcopy_release_pt();
 	configfs_unregister_subsystem(subsys);
 	core_dev_release_virtual_lun0();
 	rd_module_exit();
-- 
2.39.3

