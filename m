Received: from mail-m19731120.qiye.163.com (mail-m19731120.qiye.163.com [220.197.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F02378D82
	for <target-devel@vger.kernel.org>; Thu, 25 Jun 2026 11:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782388535; cv=none; b=EFXEbpXJjjxI21xpsW9W0t3+KO27KAv7TfJTArWbsgl3G5l52iaS3rmQhG+M+6qTUN22Mzq4g2YwC+y9Vb13D7NY78Q0MmfvQyC7RmkDs517P4Fuwus/PsZ7tHGwx26z3lp0yrbxUr4GB2dB4JkD+Ha8X4pATJMfyuIrCKfKEuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782388535; c=relaxed/simple;
	bh=OV3N4CO3ObQFMWeqaBhm8vjzeIvbqn3rCEkZDP3ObJw=;
	h=Content-Type:Message-ID:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:From:Date; b=Z+3dr+z6pabwaKgnebB33paSuWsNfErMT0s8QMjHYv9C4J15Pwexa6aEmlBRJykPlLTBl1Zdd6yhcy/cxNtFixyKxIA0TcMgaTuV52R2Gc3cCcetvQ5mbMwMDps5Aoaq/yXpmkreeWFUusvlOvR3MAe1Q5qCM4YwBxquRtgywp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=GuRgsp3u; arc=none smtp.client-ip=220.197.31.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="GuRgsp3u"
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Message-ID: <AOwAlgBuKqAuQ7p1144EIKrg.3.1782388214805.Hmail.220255722@seu.edu.cn>
To: "martin.petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, 
	target-devel <target-devel@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?UmU6W1BBVENIXSBzY3NpOiB0YXJnZXQ6IGNvcmU6IGFubm90YXRlIExVTiBobGlzdCB0cmF2ZXJzYWxz?=
X-Priority: 3
X-Mailer: HMail Webmail Server V2.0 Copyright (c) 2016-163.com Sirius_WEB_WIN_1.64.1
In-Reply-To: <20260625113807.574788-1-runyu.xiao@seu.edu.cn>
References: <20260625113807.574788-1-runyu.xiao@seu.edu.cn>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: from 220255722@seu.edu.cn( [221.228.238.82] ) by ajax-webmail ( [127.0.0.1] ) ; Thu, 25 Jun 2026 19:50:14 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
Date: Thu, 25 Jun 2026 19:50:14 +0800 (GMT+08:00)
X-HM-Tid: 0a9efe9d73ce02f2kunmab49e53f8cf9
X-HM-MType: 1
X-HM-NTES-SC: AL0_4z5B86Wr4Tz9jdMF+bhXMTUS6Y2fHkyPT6dc03QDwVaZPGiA09TnwhbhTj
	hLfuFZO94YXwX6xgvkjGVFFRKj5CTGmV59jsRUJIPmi941HdO6Ef7e9WS7F+OJBJjXnBvr+UwNQg
	mMmozmMC0NS0cX2hZ1Eu8c4Xpznz/iBuAICcU=
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDHxhPVh5CHk1LSRpCS0xKT1YVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUpVSUlDVUlIQ1VDSVlXWRYaDxIVHRRZQVlPS0hVSk
	tISk5OSFVKS0tVSkJLS1kG
DKIM-Signature: a=rsa-sha256;
	b=GuRgsp3untI2brSAOKJ9GnOX5RQUsNLwIHghS6SShQge1TQqy4V9DQKNeW7jUE5YWFcBlTqHMOyCzAxhXZ83rWu+FUeAZAK7EF76b3Ol/hieUyP3p4EQV85uK0TT7XKnbsBzqYRLtWZYtXPFPDqEkN+D0z1ah6E78syMWEuJPpY=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=OV3N4CO3ObQFMWeqaBhm8vjzeIvbqn3rCEkZDP3ObJw=;
	h=date:mime-version:subject:message-id:from;

SGksCgpTb3JyeSwgdGhpcyBwYXRjaCB3YXMgc2VudCB0d2ljZSBieSBtaXN0YWtlLiBQbGVhc2Ug
aWdub3JlIHRoaXMgZHVwbGljYXRlIGNvcHkuCgpUaGFua3MsClJ1bnl1Cgo=
