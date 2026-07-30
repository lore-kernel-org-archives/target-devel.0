Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E791B3FE36C
	for <target-devel@vger.kernel.org>; Thu, 30 Jul 2026 11:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785411877; cv=none; b=jnX4q515sm67WxrzpH1kgocpM+2BNStQaahT1m2Ih1N/o2Xq9ahx9D8y3Nv5Qre4qHBn7q2mP7WMWRqxh1UmiJQv4dX5rFtDk3dlO36NlJVuNF3O1c7dr4sqMZ5PnZA5Hex7/vecszNR3lulW0uLE5A68JAOIhxCxLVhk5t8zBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785411877; c=relaxed/simple;
	bh=k2DFnSUAYjUcmbd+6TchyY8n8uA7dVzhzQtvixzuO68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1gVlCjOdi9ePX42jsN0eFbLqidwP9X6bT16ahChuwfZnC15PvX5zJBBvZzW4w0Ji0oA0x2Qvs/D5aVCL8ZqgAoRutNgkByMNeFpYJ+9ZPBz/QHJvVqgEE3X0Q+QTu7Ryekg4IGakUaUSQc2aFVTR4pAVg1RTqrYbBZjlSr9PKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=XXl20C3Y; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="XXl20C3Y"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-848595b338cso2494777b3a.0
        for <target-devel@vger.kernel.org>; Thu, 30 Jul 2026 04:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785411875; x=1786016675; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZI/MFyfx0WYz9jr3ngUFK+Bz6mDWD6yJMRG/ycoLydg=;
        b=XXl20C3YzK/Ks/8u94jLe6pO4Doh1pNlHfD9Z+cNqlZb6IbBOQwek3PqW0RkXZGeLV
         KcAVzqVgT88f2mxSbx41EPzUTPOuEwCX+B4xZOmDH5wXk8dxtALqut0yJ96GUfg79D50
         KqqooKPj9vijnbSoF0+HEEKYobAWrVBEWSP7kiqUIXnxpGayd2yqkcXguZ9TDJ07yePO
         LGCQ8n1qLnVhfjCe73WvmOYM9HbG7PkLqI2KSmxV9GOQ6EcGhTwEwPBXE9llEqhNMUYo
         J1jw87bZ92EwESTVBncIJp4McJtecD9PN16VLqiX21CEfcUnxTCVQWmv1QrVLdGxKJOo
         EMGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785411875; x=1786016675;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZI/MFyfx0WYz9jr3ngUFK+Bz6mDWD6yJMRG/ycoLydg=;
        b=clfkoZ7XIt+ZpZOLkX6L2HQa5X9ZNvxFOAisXV4u1htUis+CBAR9DK/18Ouzf+WS0q
         vuSzdsrKw984Cnlk9wG+++ias7i8lPtkf64M/Pw5ZbbO/SaVRF5UVZ6CeFrufKJuDvKf
         Pc/NPArOSowffnHZjXP2SCgsiZ4lXMbQFqDI/eTURbCb+BHHG8ZqEWLUIolWNlB+dbEC
         btBJ/u38IA9yGIthRaoIgbXgiWQoCpDWJUo58qbEKb9QOFd8misrAvQDs1ARq2Z1D8Uv
         qm89/Ddif4k4+Wgb7Gp78aVFMxKvKs9YzVGojuMuOYoQkgd1OYkCzFJXh0x3TDp+/CJD
         mlIQ==
X-Forwarded-Encrypted: i=1; AHgh+RqbBzoy8z3dOpWR52OT4CHkC/HVafgsizBcW7Latg+WFLPpaBSnRHPy6A/wcor6OkC+MRmPVSFsv6QWeXc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAHLX2qGfLnnD2MqfxEbEYZaHb8GJCBFSjG6QedzEdIFrKCw2K
	/P2sNjIQFo3PY7xIz/4j7I1tJlzeJmSYYsHGyT7A5S6MmsomcOoLvuNqJ/LVAYl2bZI=
X-Gm-Gg: AR+sD13GuOgGRUw2JUD+c59TZfwHwgFNNQ+LzLa/LlVMYSTBDDtN6IBDUwaLi0bJ1VE
	lXUL32VOyXi/xi9G9vPxY0sANF3pByUfQhK/IB0eFQq3wPXCd11EtmeXRcsSxP61icKSBe2cmfu
	5IoLQI/ZkxZLdBSXlYo6X5MhYWGTtWOvC1/az3iMwADfZgCdq3uhQs96ewt9KhHGJpluPy/nAHr
	wJKSbOmeWHmlWw5V9nxL3h9gDXjn3Lr0vx3BkC6VCZHhxZESax5V7qzwW1/dL3NMT0NEj4x/JV9
	mRdCXeq+QXh9rHht346G8XtcnIn5aqdYweUHc5pby6zWve1ZTdMIFDar/k/IVVf9rAOrgKDtg3g
	X5zPc8kns7QdzFGUkdGzb0UNRTYWIeSuPI8tdHBfYQUagoTQtOPXEJ68UuGrxLaJNGhlmCk9QJN
	PWwS8WCUAmAZPh7wilO+5nDKqQOcZNKVXSVR21NaE2IiQ02DfcvR+eii0YQ+Bsvg13XEBh
X-Received: by 2002:a05:6a00:240a:b0:848:3d18:2700 with SMTP id d2e1a72fcca58-84ebc46f7a8mr2193712b3a.71.1785411875276;
        Thu, 30 Jul 2026 04:44:35 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ea02fa4c9sm2999201b3a.32.2026.07.30.04.44.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 04:44:34 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: michael.christie@oracle.com,
	martin.petersen@oracle.com,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] IB/isert: delay the final Login Response until the session is registered
Date: Thu, 30 Jul 2026 20:44:21 +0900
Message-ID: <20260730114421.1605304-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260730063124.1554460-1-yhlee@isslab.korea.ac.kr>
References: <20260730063124.1554460-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sashiko flagged two things on this v2, so please do not apply it as it
stands.

1/2 leaks the login_tx_desc DMA mapping when the connection is torn down
before isert_get_rx_pdu() posts the delayed response.  Nothing unmaps it:
isert_login_send_done() never runs, and isert_connect_release() does not
touch login_tx_desc.dma_addr.

2/2 reads isert_conn->state with READ_ONCE() in isert_recv_done().  A
control dependency does not order the loads that follow, so the se_tpg
dereference in isert_rx_opcode() can be hoisted ahead of the check; it
needs smp_load_acquire().

I will send v3 with both, and with the error path logging the value it
actually tested.

Best regards,
Yehyeong
