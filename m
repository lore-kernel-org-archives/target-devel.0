Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E9113B2B8
	for <target-devel@vger.kernel.org>; Tue,  3 Dec 2024 19:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733253434; cv=none; b=MOJpedXHlRYpSfL4zUDlWAcDC/+TpmzYHjaF15AoWUzXyHmLYIQPNO/Ji/u+xWEQbsdJQnxNBPZNCCrpdqvvnNh5wLFJVvacE+i677+coNySLT7/0pzrBwENG/aVk3iDk+ynzXZDMUu8L1nl/B+YJEv7hkUiKkoAH1M1RqCKS0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733253434; c=relaxed/simple;
	bh=k5O7DAp6vfkbonZQML+9XMYQ0zCC34xZlufUGtqimW0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=OizKHAWOin7k696/7JNRuuIqNSsKNmVAVyoEZexBYvBesw5HrasVl7h/KzuyRFzDYRQacsnt+MJLx+zYV2eGxSUMNZj9zu7rdqok2KXb73ahNJbcD5PE4WJ4N1qXhkj8DdX3StfM0iydEw7zUALQlAZB+Vn0wYNIP5A38MxgIIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UGQNHDkV; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UGQNHDkV"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B3HtZfR030203;
	Tue, 3 Dec 2024 19:17:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2023-11-20; bh=k5O7DAp6vfkbonZQML+9XMYQ0zCC3
	4xZlufUGtqimW0=; b=UGQNHDkVVABqcZKGtwWDc2d0IkgXvZXt+hit+iyFip6hi
	QvleE/3OV6EwkEAs6SV9AZRo0wTWFfY/C1rVqJ+pEJ+UDlRDaXUI1r9ksbBetdpP
	WyOfyJQoZ/l+j7bBEtL0rc/dRe5BkesOY7t9uYfx55Ng3HqCAnd3DOcvPtVD/5my
	+WCA382Bn6AF7MQ4aiKSiLJ9sWH3smD+tAqtMbpZRVeWHO8JB6knGgVRya9u6obT
	VMjIK0av8ZfKoW2dkwP2zmNNA7SWOjUb1KUgQho3Bdt8DvlL6/N7FUXrGyVyvlv9
	tVNaRdjkdKbOtqNSVU2fbHMpLzectOAejrnKZRXwA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437tas6sar-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Dec 2024 19:17:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B3I0jN5000822;
	Tue, 3 Dec 2024 19:17:08 GMT
Received: from mnc-mac.us.oracle.com (dhcp-10-65-163-31.vpn.oracle.com [10.65.163.31])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 437s58ak94-1;
	Tue, 03 Dec 2024 19:17:08 +0000
From: Mike Christie <michael.christie@oracle.com>
To: stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, pbonzini@redhat.com, target-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v2 0/8] vhost-scsi: Memory reduction patches
Date: Tue,  3 Dec 2024 13:15:07 -0600
Message-ID: <20241203191705.19431-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-03_08,2024-12-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=770
 adultscore=0 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412030159
X-Proofpoint-GUID: wS9Lbh5xAnCYp_cQcufmP-WT-iWpUr0q
X-Proofpoint-ORIG-GUID: wS9Lbh5xAnCYp_cQcufmP-WT-iWpUr0q

The following patches were made over Linus's tree and also apply over
the mst vhost branch. They reduce the memory use for vhost-scsi.

For a simple device with 1 queue and 128 cmds we use around 25 MB. These
patches allow us to reduce that to 8.2 MB when supporting up to 128 8 MB
IOs (the current passthrough max size).

For a more complex device with 16 queues we use around 2.5 GB. These
patches allow us to reduce that to 77.1 MB when supporting 1024 8 MB IOs.

v2
- Rebase against current trees/branches.
- Fix email threading.

