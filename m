Received: from ns1.suksangroup.com (ns1.suksangroup.com [103.13.31.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AC5332610
	for <target-devel@vger.kernel.org>; Tue, 14 Jul 2026 05:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.13.31.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784007097; cv=none; b=pCNqPNoEdcAzvH2ozc0Rd4FKUN4lRL0PX8oYaTZQzARugEULvEKgROR6kkmM/Uv9Jc3vCSp5Rq+LrcvAXb7NBkYm72jOypLWFKakYrYIqK24lxMksaY6ISDwczB0yzd4lsF9tLsQX5QJMc+r0M6DcBdDi4NKovIUo+0xEHGH6VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784007097; c=relaxed/simple;
	bh=bGYUnpSQpEquBQPwRF8fR1SDGghdQ+6rKQPPerlf8FI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mm7bN5f7E2A8JaovV3ebtHdYdwqvoAug+AJq+PfnXmERha7Hw85vswD55fBYrPjWyoeBAl98X1JVxQo9QmsmCp67S+ZohbOEp+lJM8KqLKPfYNGIY2wFbwz5XH2uB0CdwJoMjwmaoAXdVS1m0mmE8tqSMAiGQO+oGfcnxf9KOJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=inbox.org; spf=fail smtp.mailfrom=inbox.org; dkim=pass (2048-bit key) header.d=suksangroup.co.th header.i=@suksangroup.co.th header.b=fJnf1HKX; arc=none smtp.client-ip=103.13.31.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=inbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=inbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suksangroup.co.th header.i=@suksangroup.co.th header.b="fJnf1HKX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=suksangroup.co.th; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:To:From:Reply-To:Sender:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=bGYUnpSQpEquBQPwRF8fR1SDGghdQ+6rKQPPerlf8FI=; b=fJnf1HKX+Z5Fw+mUa5/MI3fB7A
	+HuA1ubqab1y8pP7ZKvu1BhLzfM+C07B1MfRqYqrJ6XliNYuo3R41xr/Y7PY/dVzEn2rINmO/I0aQ
	VwVEYKhBI8qyqFf/0nUM2YKTDjkgGbqB/KtRZqLFbavYjziFtH1iPuipKSwnWGrVSdZ9Mn5yxzy/a
	iaHP1HWzvLthVX3gjfWsyhnI/VRMF2d+gDWndJ6j7b7wW6zcHbg0ax7GujOYVbEft/MfGS2y5EPee
	hGHzx0zsZghg6LgoTfK26x0zayDxA6oZdLYuUuTo3NVGkYrsKOvYNwWTksiCs7vS3WEVdXIBFQf93
	ePVXlfbQ==;
Received: from [207.189.26.187] (port=65383)
	by ns1.suksangroup.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.4)
	(envelope-from <info@inbox.org>)
	id 1wjVjz-0000000G25b-0SP9
	for target-devel@vger.kernel.org;
	Tue, 14 Jul 2026 12:31:34 +0700
Reply-To: hanns.schofield@lexcapitalgrowth.com
From: Harry Schofield ESQ <info@inbox.org>
To: target-devel@vger.kernel.org
Subject: Dear target-devel@vger.kernel.org, 
Date: 14 Jul 2026 00:31:30 -0500
Message-ID: <20260714003130.E72555F637C9528D@inbox.org>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ns1.suksangroup.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - inbox.org
X-Get-Message-Sender-Via: ns1.suksangroup.com: authenticated_id: smtp@suksangroup.co.th
X-Authenticated-Sender: ns1.suksangroup.com: smtp@suksangroup.co.th
X-Source: 
X-Source-Args: 
X-Source-Dir: 


Re:Good day target-devel,

Please let me know if this is best email to send you the project=20
info.

Kind regards,

Harry Schofield, ceMBA


