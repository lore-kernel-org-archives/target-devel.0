Received: from outbound.mr.icloud.com (p-west2-cluster1-host2-snip4-10.eps.apple.com [57.103.68.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3D33C9452
	for <target-devel@vger.kernel.org>; Tue, 10 Mar 2026 17:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.68.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773164745; cv=none; b=EB88nkiDflEtFQ861d1aQhTD61ssp7+CJYwbnMHij+yq0FqY7XIev/908j5XjMSj8hww1m8AIBBbzd1qiX8Dbiov0LtdHQf6hrw+4r2wT+JI9RTwjD34TrIV4p+MupkDl4rusLmu1ro8qoCXWhkDlgDMyFSYqi0DN8+wh9ASAfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773164745; c=relaxed/simple;
	bh=4nLO5SuvB0slRA6APF3+oC4t4JNgarBqJE16O0xHkTE=;
	h=Content-Type:From:Mime-Version:Date:Subject:Message-Id:To; b=asjXgPAIIfzx40skT94cooOzzRWNZzpKIeQqECj15WM21sCY5lqG3wMXPFdA9M1arXd6Hj6URNrJlbcAklYLlh5ZnzbWRNYklb/dCKd8B5fdYcbOos/zODNZreWUa9pStY82v1U2pYJ0BhVW+3tFfk6chuw7zos9oDm5lF3lIGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=ipyDweY9; arc=none smtp.client-ip=57.103.68.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="ipyDweY9"
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-2 (Postfix) with ESMTPS id 0B1721800875
	for <target-devel@vger.kernel.org>; Tue, 10 Mar 2026 17:45:41 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1773164743; x=1775756743; bh=KxRuuUg7T2PioEkHOmmQzyIWfSgpZlL4qv4CCi1Yn8c=; h=Content-Type:From:Mime-Version:Date:Subject:Message-Id:To:x-icloud-hme; b=ipyDweY9OFjv5kmQQSvDNsZUKkdFI8CaD2LA33boD9hwaQ9Gy0SXRrYq/r6Av8nUIb1QB785pE0fjyqo2JPuvyuYbf4ovJ2UxeQh1t6KCzcUp6EGxdFKWANdyUjDcMXDruTDa45zxU4yBu91CfdE9nQETAULsgLkVzGZC4YP1Q+gJFiSowECyH5LzN0jKmyxeu4pwbhvpxo5Zt5vvdRX+CE4j4jVYL+i/b6otRnAA8/4xexIjRhkQcgVrrdQsu/6sU/2BkDQkVDH403RWVNziQsboh752gb1De/JlPsxY9OxEN8RUVrnTWwESAYTfNYrScNSnr2vwdHmmA+wSSswzg==
Received: from smtpclient.apple (unknown [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-2 (Postfix) with ESMTPSA id A3EDB1800103
	for <target-devel@vger.kernel.org>; Tue, 10 Mar 2026 17:45:40 +0000 (UTC)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: pittie1984@icloud.com
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Date: Wed, 11 Mar 2026 04:45:37 +1100
Subject: Unsubscribe asap
Message-Id: <270343DA-D2A2-4FDB-ACDA-4E3A2128E165@icloud.com>
To: target-devel@vger.kernel.org
X-Mailer: iPhone Mail (23D8133)
X-Proofpoint-GUID: fP7xBhDnRuMZw1Fwqd0hrDNPw0Ucj252
X-Proofpoint-ORIG-GUID: fP7xBhDnRuMZw1Fwqd0hrDNPw0Ucj252
X-Authority-Info-Out: v=2.4 cv=Af683nXG c=1 sm=1 tr=0 ts=69b058c6
 cx=c_apl:c_pps:t_out a=9OgfyREA4BUYbbCgc0Y0oA==:117
 a=9OgfyREA4BUYbbCgc0Y0oA==:17 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10
 a=x7bEGLp0ZPQA:10 a=S9SC8c2Z1okA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=gvGBBiDt2HSIUaBLT3EA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE1NCBTYWx0ZWRfX6OSEEBkIkMUE
 gc73lX1xzo+61jPLMSp8WhA1f3avUQAW8UzgyPvGCNeKDBLK+h9Ys3cNE6hE7T5VhIxH5e4KHOO
 nnNd+WZ0Knds4r8MwGCSTF6NEHdRlyOQoQUJrYjOfxCB6Ulh23zRsYg61Py92hxMrjSKTcflL2H
 L7Vwp4IUXnVrx3ZAZUPHRRyzQFcN60Oz1scWqhdMYi1kxNiDmP1PDaGRqlf46TQUAShwnuZeQXL
 oDosbmbP6UcqfJ8SDWKF6Cc8vacSlGuKI9ON2QJBYNUypiDKGnBpfCSQNPCg7ewtTl7sbL2sFvo
 T2FRtwp6gS7ZyseBnhTX+2PwPDyHDL4XmVhJO9BATear5PB16nqTw8MzRt2vsk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=1
 mlxlogscore=598 malwarescore=0 phishscore=0 mlxscore=0 clxscore=1011
 spamscore=0 adultscore=0 suspectscore=0 lowpriorityscore=1 classifier=spam
 authscore=0 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2603100154
X-JNJ: AAAAAAAB0QMIvyQ1Mwc/kQmuRwAPR2MF/bpGR6kNwygfnq1GXGDtngBHeWOBoVN71q9OLlcLsCnPKDIpMamOI6VRkWPLgVY/ugnbmXaLavuQ4ScTiIxTQZAN7dhlymL0lHgMmbMhnUQYd8C5zdsS91F4hDrP4aGMEd8a50+IuyTLLIP7Vglop6QemP74GZ8lInmiV/6iRp8SN5DpzytJiNS3EJNK60yKrr86LjWpGrw+gM/Jhb4ggbgTScmlQa+5TwR+vUo9ePExYQpwpip6yeHTjBxDqIpNZXSLLUfzuVSjknVAKov6zR7u/gxmBWZJ1A/2TzbomN7SgGYpYRZY+U96DDP5sQT7BQ0GCd1VcwxSFqKRzi/zbDCqJqTDGrIOMn/FBTt3r4Fg5Qp8spOK3ZZ5VOd0TuIpeDs/WgZZSRTVDaVce16D9gBXr80+6VYBr2JveCEemUgXDgmZ/VEzwWTm0G4+4BxvoBlyK9qx4CPS8pL4Rt6KN2CXQCGSCow6+J1nDhnP5SakBq7uLKr9A1X6YgKRxlFH8+a3riQlNwQwGr2UwiqUX4/qeCNMcklQq97teIVNLphhtujmD2TPTk1JT8PG5iEJox+BPBCiHmRqikD+yLGNGnu2oJ0r618ZV4o=

Unsubscribe asap Or legal action will be taken
Regards please check if sender legitimate 
