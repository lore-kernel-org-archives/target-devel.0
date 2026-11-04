Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793765025;
	b=bwEKFM/Ehtrm4A1FSxpEThrM9919aZxSy9I/nBZdFrsOcXG9m3wOdl03vWT1MXbC4iN8
	 K1iMZ7VFuNILaxvMrIRB2KjFkZPchCmtoNZUSUjMUPxh9YKUAqD09VwqFSrSBnx7JciLH
	 Q/1ni4Z09iYLumjP50MATE49LXyPJ3wTRcNdV3f6aiwKsnPsIq4gUtoa6MxfuIJ7u5EhA
	 67kv3aF0kLjLhHWPc3GPfE8aa2FCa5KDbNko5CAbsDcrF32fyRq+DYDx+Z9ouxp6RQlCe
	 Nx7WeTdvBb97q05a+z7G4OZ3WFsQ739dcz1y2bDOfiYCubugqPpkGp0dekj+u561gwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793765025;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ps3xULYoMvvKnRY6kKVrhGZs26Ls52NpvFL7YqNkFUg=;
	b=QCLCLxhKHt12eWZvQWQGHnusd6NzCSFazD65spgaLkzLG/2bdVZUxvp+Wz8pibfY6B6D
	 j/ExJzAsYrhahhgcH5LJUzPNwOcR64Wu8C9HWuhdxonBceRIrlUguD6ULgfp07lVBx9gx
	 IsjykPuikn8pPkPalhI5KflLQlIG1bKzCwy2ch7QtU+w1WpCniH7QuhyyVUmc+4Qn2cD5
	 WJpfItu25LQCcoKFRcXHFvVyO+SXP6hebr8daw0IRjegefIuX3TGvFvZQWhpJagn3rvG2
	 e+hgeYetXGDDLFDEWT6Ohn0NdhTjuaZCtRLanMTLOFtL0uWXLtWbb0YF9pXSU+dvidg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ZLiKkR0L;
	arc=none smtp.remote-ip=209.85.215.176
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A28606A33C
	for <target-devel@vger.kernel.org>; Wed,  4 Nov 2026 04:03:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4A28606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ZLiKkR0L
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cd67cc518a6so182542a12.1
        for <target-devel@vger.kernel.org>; Tue, 03 Nov 2026 20:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793765024; x=1794369824; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ps3xULYoMvvKnRY6kKVrhGZs26Ls52NpvFL7YqNkFUg=;
        b=ZLiKkR0L42nag7p2+/NNGmUD0mX74OJYykXkh/PsrPbxOqr3yBhh69MGfSsnkNrqjy
         Wwxmm/9hf0rGQdh5kVN+aOPpguwksmUtFQnnO8a1K3dVtoFlCvT+t6o9GOgxAPEkbSsQ
         hjIAneq6tzRINeJoF6NT7bVQJ2FvfhS3iQhxvrts0wx8Lfr76mZB9xu8sIyVexfq3Nbw
         3qdAWBen5sx1ggOhRomqKfmK2IQQxJaIR4SS3uwQWnB2FRLGQT+OVNHq/6sKv8En4mDk
         N9xrpNMAzjAXnJvbLp+8XyBxvgIiz69+Gvo3VCPvnSQ377Rtd0YEQUC2skHG2cVBUZAK
         OYrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793765024; x=1794369824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ps3xULYoMvvKnRY6kKVrhGZs26Ls52NpvFL7YqNkFUg=;
        b=mPjYWC56b3QWpt2vIHchbltuV4dlgf5hScE3QJr7qID2dNZIiynYNrmaSmeARqBOYb
         DqyraJgCO9EaDzVLd/OTWrpaxVxT5mjFVrvNZnKK4RMHda//avEGimRDL/DURspTPw9t
         O+b5aMcNfp9yfOUrgc/z82nLOB6dYuMg4ucBApihWRl4zsHO64SCXmwimbsDDKn2n3q1
         U/RNa1iYcdhTgktqeTkeRLYbnOY4ZynWxa5gR1nbU6+2aOhCwyqBcMbM3CStiPBvRbDo
         9KorOyBTRkVKPbWm8FiiymWqbQxS3unfl22FsL7VQFPN+jNZU1TvkbGjLDf/OrxPWcNq
         c5mQ==
X-Forwarded-Encrypted: i=1; AKwUvBxnoyjNuY6DsbdmjjmVzw+c1y/twlnpvzF4pjmiEtmNaFfb/mYarRIkZgWodHXplb1O+4TwkoiBrddXZJs=@vger.kernel.org
X-Gm-Message-State: APuU4Z9uElFacfx6Dgyf4J5uZD8WEnsTlbj0Ay5HPno29At4l8CKVjvK
	g6aDn9l6zKbnL3qjZXi2FMT7xCFD8sPewci8pJmhcguTD/dnFa0fAov4m009839uyx1mMS2+EOT
	PLJGNGGs=
X-Gm-Gg: AYBFou0aym6EcLRA4Hj3l4gTwhPR8mS0zL6ms/Bpm3XNe0alwJeBrpb+5GyS5O0wRli
	5RxZA3tkchlouTR5bpndQqw19L0Xi3ZeuX21E2sxbl4pk57A3zxgoVqr65NBHfmdwWQfFO2Ncl6
	gOGp2oawdrWkMyBSoqGx6eL8HQIMMfRlu9rKTG0ECBFCnsjV/vwROWRaK56ByqpKaLmit290kJ2
	kTEv/xQ97Kyhe09j2GV2H75BEk1yOpIY/gmLpDQw9JEnzFzIVKjtMCd5GpQMjCipOxrsAiHRQrH
	92IA/g7pqYb3RdZe8cIx85za9kMxYVkillaapCkxaRe6Ao+WqYMeK4NdTXkHiYml8rOPmpzMi5S
	7/PVPBR9mGfHKqsVFe47JSuplq89VAoYp3wauj+WChioFJP7SrAz5caNVqAc1o6Cg+CqHyOCKpf
	TYGZGIyZgXoxKGorbFU5FAOY7s/w9DdKQhmv1LehCJzUifrrUHhRWKAoaVlC38PFNXx4omgTi05
	A32Bo1Trt2Lo38thMXOaeJ7ljOJEfjsfCikRrI2BV0UIN0Rm/EaW1fIgWx8unG0lLJEXwWfakZQ
	BtBAv+ygP5uv7PcmfvEb4ijaEQCEULfu1ySMVcZRRejm1ZrBhJ8P5DKnJqtcbw/EgPX7gq+MIJ/
	e/hPQldBrvLjv+YP09uvsz0ESMIg/+jIpVTr35/qDl40CaSchg1N9r79e4A==
X-Received: by 2002:a17:90b:57cb:b0:3ac:b2e6:317d with SMTP id 98e67ed59e1d1-3ae89776ad0mr13265833a91.35.1793765023968;
        Tue, 03 Nov 2026 20:03:43 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:744:cf40:a7b2:e78f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b093d481a3sm1817053a91.1.2026.11.03.20.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 20:03:43 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH v8 5/6] IB/isert: do not build a new isert_device for a device being removed
Date: Wed,  4 Nov 2026 13:03:16 +0900
Message-ID: <20261104040318.1844865-6-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104040318.1844865-1-yhlee@isslab.korea.ac.kr>
References: <20261104040318.1844865-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

isert_device_get() looks the device up by node_guid and has no reason to
refuse one.  A CONNECT_REQUEST arriving while isert_remove_one() runs
therefore builds a new isert_device on an ib_device the core is about to
free, and nothing waits for its QP, CQ or PD.  cma_process_remove() waits
only for id destruction, and the core takes no device reference for them,
so ib_dealloc_device() can run while they are still being released.

node_guid is also the wrong key.  Two ib_devices can share one, and an
isert_device holds the PD and the DMA mappings of the device it was built
on, while isert_remove_one() looks it up by the ib_device pointer.

Let the ib_client data say whether a device may be used, and match the
ib_device pointer.  isert_add_one() stores a non-NULL value,
isert_remove_one() clears it, and isert_device_get() refuses a device
whose data is NULL.  The clear, the lookup, the reference and the removing
flag are one device_list_mutex section.

A test-only delay before isert_device_get() let a connect build a new
isert_device while isert_remove_one() ran, and the removal then took
core warnings such as the one below.

Connecting on a second soft-RoCE device that shares a node_guid, after the
first one already has the isert_device, failed rdma_create_qp() twice in
both runs without this patch and not at all in two runs with it.

  WARNING: drivers/infiniband/core/cq.c:370 at ib_cq_pool_cleanup+0x189/0x250, CPU#0: rdma/202
  Modules linked in:
  CPU: 0 UID: 0 PID: 202 Comm: rdma Not tainted 7.4.0-rc1-NW4-00006-ga65579195c15 #125 PREEMPT(full)
  Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  RIP: 0010:ib_cq_pool_cleanup+0x189/0x250
  Code: 85 19 ff ff ff 48 8b 04 24 49 83 c4 10 49 39 c4 0f 85 cd fe ff ff 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 90 <0f> 0b 90 e9 20 ff ff ff 48 89 44 24 08 e8 15 16 0b fe 48 8b 44 24
  RSP: 0018:ffff88810c737308 EFLAGS: 00010206
  RAX: ffff88810a03fc40 RBX: ffff888104b5c000 RCX: 0000000000000007
  RDX: 000000000000010c RSI: 0000000000000000 RDI: ffff888104b5c02c
  RBP: dffffc0000000000 R08: 0000000000000001 R09: 00000000000000bf
  R10: 0000000000000003 R11: 00000000d3012b20 R12: ffff8881047f0ad0
  R13: dead000000000122 R14: dead000000000100 R15: ffff88810a03fc00
  FS:  00007f8b74df1740(0000) GS:ffff888189e5e000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f9e81f41000 CR3: 0000000105f2b002 CR4: 0000000000770ef0
  PKRU: 55555554
  Call Trace:
   <TASK>
   ? remove_client_context+0xb7/0xf0
   disable_device+0x13c/0x240
   ? __pfx_disable_device+0x10/0x10
   ? __pfx_mutex_lock+0x10/0x10
   __ib_unregister_device+0x226/0x3f0
   ? __pfx_mutex_unlock+0x10/0x10
   ib_unregister_device_and_put+0x50/0x70
   nldev_dellink+0x28e/0x3d0
   ? kernel_text_address+0xa7/0x130
   ? __pfx_nldev_dellink+0x10/0x10
   ? __pfx_down_read+0x10/0x10
   rdma_nl_rcv_msg+0x29c/0x4e0
   ? __pfx_rdma_nl_rcv_msg+0x10/0x10
   rdma_nl_rcv_skb.constprop.0.isra.0+0x21d/0x370
   ? __pfx_rdma_nl_rcv_skb.constprop.0.isra.0+0x10/0x10
   netlink_unicast+0x68f/0x940
   ? __pfx_selinux_socket_getpeersec_dgram+0x10/0x10
   ? __pfx_netlink_unicast+0x10/0x10
   netlink_sendmsg+0x810/0xf20
   ? __pfx_netlink_sendmsg+0x10/0x10
   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
   ? selinux_socket_sendmsg+0x8c/0x270
   ? __sys_sendto+0x337/0x390
   __sys_sendto+0x337/0x390
   ? __pfx___sys_sendto+0x10/0x10
   ? fdget+0x53/0x3b0
   __x64_sys_sendto+0xdb/0x1b0
   ? fpregs_assert_state_consistent+0x56/0xe0
   do_syscall_64+0xdd/0x4a0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  RIP: 0033:0x7f8b74f200d7
  Code: c7 c0 ff ff ff ff eb be 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 80 3d 75 ef 0d 00 00 41 89 ca 74 10 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 69 c3 55 48 89 e5 53 48 83 ec 38 44 89 4d d0
  RSP: 002b:00007ffd34f4ef18 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
  RAX: ffffffffffffffda RBX: 0000556b747c4390 RCX: 00007f8b74f200d7
  RDX: 0000000000000018 RSI: 0000556b747c32a0 RDI: 0000000000000004
  RBP: 00007ffd34f4ef50 R08: 00007f8b75017200 R09: 000000000000000c
  R10: 0000000000000000 R11: 0000000000000202 R12: 00007ffd34f4f140
  R13: 00007ffd34f4ef24 R14: 00007ffd34f4f160 R15: 00007ffd34f4f140
   </TASK>

Fixes: b8d26b3be8b3 ("iser-target: Add iSCSI Extensions for RDMA (iSER) target driver")
Fixes: 63b268d232b8 ("IB/isert: Properly release resources on DEVICE_REMOVAL")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 40 ++++++++++++++++++-------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 980bcc0fb23183..a9bd2cc786cebb 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -41,6 +41,11 @@ module_param_cb(sg_tablesize, &sg_tablesize_ops, &isert_sg_tablesize, 0644);
 MODULE_PARM_DESC(sg_tablesize,
 		 "Number of gather/scatter entries in a single scsi command, should >= 128 (default: 128, max: 4096)");
 
+static struct ib_client isert_ib_client;
+
+/* Non-NULL client data on a device means it may be used. */
+static char isert_device_enabled;
+
 static DEFINE_MUTEX(device_list_mutex);
 static LIST_HEAD(device_list);
 static DEFINE_MUTEX(isert_conn_mutex);
@@ -275,14 +280,18 @@ isert_device_get(struct rdma_cm_id *cma_id)
 	int ret;
 
 	mutex_lock(&device_list_mutex);
+	if (!ib_get_client_data(cma_id->device, &isert_ib_client)) {
+		mutex_unlock(&device_list_mutex);
+		return ERR_PTR(-ENODEV);
+	}
 	list_for_each_entry(device, &device_list, dev_node) {
-		if (device->ib_device->node_guid == cma_id->device->node_guid) {
-			device->refcount++;
-			isert_info("Found iser device %p refcount %d\n",
-				   device, device->refcount);
-			mutex_unlock(&device_list_mutex);
-			return device;
-		}
+		if (device->ib_device != cma_id->device)
+			continue;
+		device->refcount++;
+		isert_info("Found iser device %p refcount %d\n",
+			   device, device->refcount);
+		mutex_unlock(&device_list_mutex);
+		return device;
 	}
 
 	device = kzalloc_obj(struct isert_device);
@@ -2789,22 +2798,25 @@ isert_remove_one(struct ib_device *ib_device, void *client_data)
 	struct isert_conn *isert_conn, *tmp;
 	LIST_HEAD(removal_list);
 
+	mutex_lock(&isert_conn_mutex);
 	mutex_lock(&device_list_mutex);
+	ib_set_client_data(ib_device, &isert_ib_client, NULL);
 	list_for_each_entry(device, &device_list, dev_node) {
 		if (device->ib_device != ib_device)
 			continue;
 		device->refcount++;
 		device->removal_comp = &removal_comp;
+		device->removing = true;
 		found = device;
 		break;
 	}
 	mutex_unlock(&device_list_mutex);
 
-	if (!found)
+	if (!found) {
+		mutex_unlock(&isert_conn_mutex);
 		return;
+	}
 
-	mutex_lock(&isert_conn_mutex);
-	found->removing = true;
 	list_for_each_entry(isert_conn, &isert_conn_list, conn_list) {
 		if (isert_conn->device != found)
 			continue;
@@ -2827,8 +2839,16 @@ isert_remove_one(struct ib_device *ib_device, void *client_data)
 	wait_for_completion(&removal_comp);
 }
 
+static int isert_add_one(struct ib_device *ib_device)
+{
+	ib_set_client_data(ib_device, &isert_ib_client, &isert_device_enabled);
+
+	return 0;
+}
+
 static struct ib_client isert_ib_client = {
 	.name   = "isert",
+	.add    = isert_add_one,
 	.remove = isert_remove_one,
 };
 
-- 
2.43.0

