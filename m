Received: from cdmsr1.hinet.net (210-65-1-144.hinet-ip.hinet.net [210.65.1.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F8F2EB873
	for <target-devel@vger.kernel.org>; Sat, 18 Oct 2025 10:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.65.1.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760783388; cv=none; b=Rwk8AP66S2jXFbg5MjFb7Ic3CDUDFCD7O1fIKIWKTv1cTKGi1mdLoSRaV4Lx6SMosbvcEBxCpj34iJDNOJzIDAOK334Gx89E/0Dhakai9z1wG42sLW2X04fEs5IVmL4wdqoN31vvwGd5MTaSgW0CHo4X1XSF68FzXBZ2srQ6mos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760783388; c=relaxed/simple;
	bh=DbLYlW0tj8hhfHozmdsrbobnKw0EX89lBEBJls8R2HE=;
	h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type; b=CG6JGppbfw8Y+BYLxIvEIAsRiL+DxL4dxv7f3EEk9SwqXEekBiOOkTc+W2kmq7GSgR6MWfzek1zKYAznmPPrMuZ+qCsYhDshyIy1n/5HP0y7/x0VymiefhGKkzdY3543xu954k64uGipqFGfGRgza5l7CLaG6DcwvrCp/XyFwC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ms29.hinet.net; spf=pass smtp.mailfrom=ms29.hinet.net; dkim=pass (1024-bit key) header.d=ms29.hinet.net header.i=@ms29.hinet.net header.b=BN61O+mE; arc=none smtp.client-ip=210.65.1.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ms29.hinet.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ms29.hinet.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ms29.hinet.net header.i=@ms29.hinet.net header.b="BN61O+mE"
Received: from cmsr7.hinet.net ([10.199.216.86])
	by cdmsr1.hinet.net (8.15.2/8.15.2) with ESMTPS id 59IATgmW866983
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO)
	for <target-devel@vger.kernel.org>; Sat, 18 Oct 2025 18:29:44 +0800
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=ms29.hinet.net;
	s=default; t=1760783384; bh=IPTv4XKnhtnIKBlcGzmZUwTaDMk=;
	h=From:To:Subject:Date;
	b=BN61O+mEF/ShpCIkh4mbRFedn264EyhMclElGPnOJLHYVavaRRsQlHEVCvVoYyoJZ
	 eGiXGZ8Mwwmia5ZLptNg0gYv5VR2eezp2IJH+AZz9FWedRTOiX3+nJ9o7GJcCmsQC2
	 rjQmCFpyKJIr2xmEKI2Jj4WfbaL8nTVb1XiIi/tk=
Received: from [127.0.0.1] (1-173-52-52.dynamic-ip.hinet.net [1.173.52.52])
	by cmsr7.hinet.net (8.15.2/8.15.2) with ESMTPS id 59IAGCFn305900
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO)
	for <target-devel@vger.kernel.org>; Sat, 18 Oct 2025 18:23:40 +0800
From: "Sales - iGTI 345" <Target-devel@ms29.hinet.net>
To: target-devel@vger.kernel.org
Reply-To: "Sales - iGTI." <sales@igti.space>
Subject: =?UTF-8?B?Rmlyc3QgT3JkZXIgQ29uZmlybWF0aW9uICYgTmV4dCBTdGVwcw==?=
Message-ID: <b6c9473f-73fd-b140-065c-816b7223c8f7@ms29.hinet.net>
Content-Transfer-Encoding: quoted-printable
Date: Sat, 18 Oct 2025 10:23:39 +0000
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-HiNet-Brightmail: Spam
X-CMAE-Score: 100
X-CMAE-Analysis: v=2.4 cv=KMH5D0Fo c=0 sm=1 tr=0 ts=68f36aad
	p=ggywIp0tIZrEgnU2bSAA:9 a=bms3psZGNEWHF9wUkq/6dA==:117 a=IkcTkHD0fZMA:10
	a=5KLPUuaC_9wA:10

Hi Target-devel,

I hope this message finds you well.

We are a diversified general trading company with multiple business streams=
 and affiliated sister companies. While our operations span various sectors=
, we currently have a strong focus on the resale of general machandise and =
services on several products to our partners and associates in the UAE and =
UK.

Having reviewed your website and product offerings, we are pleased to move =
forward with our first order. To proceed, we would like to align on the =
following key details:

-Minimum Order Quantity (MOQ)
-Delivery timelines
-Payment terms
-Potential for a long-term partnership

To facilitate this discussion and finalize next steps, we will be sharing a=
 Zoom meeting invitation shortly.

We look forward to your confirmation and the opportunity to build a =
mutually beneficial relationship.

Best regards,
Leo Viera
Purchasing Director
sales@igti.space
iGeneral Trading Co Ltd
igt.ae - igti.space
