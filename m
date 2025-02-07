Received: from mail.tasknomic.com (mail.tasknomic.com [141.95.16.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99E63BBF0
	for <target-devel@vger.kernel.org>; Fri,  7 Feb 2025 09:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.95.16.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738918900; cv=none; b=Uas/n22uSys/Bgw9IwesHrIJvaMyWPGgbTTBa3YMLZw4zPrcWy8sTPOX7yPEJJ/2RiuI1EYTwSOFnHgrUxJKJ6fN7LVPyh/E3jh4rmlw31zlzS0SUsMc6pMRBlLcD3gp9v5+vStirtcKmQFd30eX0xr2q+6lrya5LZMQ2QbzuBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738918900; c=relaxed/simple;
	bh=qhPXDtX36VH1dBuRhQTg7JW2X59vA6pMbLgMkEPcRoI=;
	h=Message-ID:Date:From:To:Subject:MIME-Version:Content-Type; b=bYw44Xm4F86i4TZfrAHiT1oEGPqz9roonI8u1192kklkzlwkXSuQeFosfmBCAc+kH5us1B5b8rsQM1KuTHB/po2ss/I9IFhreoZbx0NDbMDIUC/73sxHW8lyULzPDDV9tQY8D9wWLzcLHXRKZ3Lvp2I1nYvhxev0+8zWR69vQjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tasknomic.com; spf=pass smtp.mailfrom=tasknomic.com; dkim=pass (2048-bit key) header.d=tasknomic.com header.i=@tasknomic.com header.b=cf2g412Z; arc=none smtp.client-ip=141.95.16.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tasknomic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tasknomic.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tasknomic.com header.i=@tasknomic.com header.b="cf2g412Z"
Received: by mail.tasknomic.com (Postfix, from userid 1002)
	id C5FA3A42CC; Fri,  7 Feb 2025 10:01:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tasknomic.com;
	s=mail; t=1738918894;
	bh=qhPXDtX36VH1dBuRhQTg7JW2X59vA6pMbLgMkEPcRoI=;
	h=Date:From:To:Subject:From;
	b=cf2g412ZCMx0qlyplXspbAhFC/uTJkeJ2NYrASVUd2wzzgBhT6UQFB0Zq79Gi5iZe
	 RFR5756tVzFzEjWvBnlngND4KrMyD4Etz37s1adMZltleTkj1/xPPXbNUXn3YDMvFM
	 CEbnC4xCLgRbNO6M+1GOyhd6hy14kxf3uR6JlMlB320iFLxLfGd7IrEU0TJke2u68t
	 mBL1rC1YdwTveNzlCG8nOicipq6cqlLQIpUUSx+wezjCf/UK88L1MLINZYqTx5uqpO
	 abSm0O2Fz0Vq6zt51zolq3uvY8pOfA9HHnQdIkGC9vat2RbEf91smb76skmhd0faDV
	 +B9RzGqzNF0tg==
Received: by mail.tasknomic.com for <target-devel@vger.kernel.org>; Fri,  7 Feb 2025 09:01:13 GMT
Message-ID: <20250207084500-0.1.h1.xuyv.0.o4u318lcoh@tasknomic.com>
Date: Fri,  7 Feb 2025 09:01:13 GMT
From: "Jon Brennan" <jon.brennan@tasknomic.com>
To: <target-devel@vger.kernel.org>
Subject: Informacje o dostawie
X-Mailer: mail.tasknomic.com
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

How often do companies give up comfortable space for customers due to fir=
e safety requirements?

We produce wall-mounted chairs that take up only 12 cm of space when fold=
ed. When needed, it provides a comfortable place to sit, and when the esc=
ape route needs to be clear, it virtually disappears against the wall.

Would you like to check how a simple solution can so significantly improv=
e the functionality of a space?


Sincerely
Jon Brennan
