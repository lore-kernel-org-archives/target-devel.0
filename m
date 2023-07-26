Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55526EB64DD
	for <target-devel@archiver.kernel.org>; Wed, 26 Jul 2023 02:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjGZCFQ (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 25 Jul 2023 22:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjGZCFP (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 25 Jul 2023 22:05:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C302D121
        for <target-devel@vger.kernel.org>; Tue, 25 Jul 2023 19:05:14 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36PJIoDw017652;
        Wed, 26 Jul 2023 02:05:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=FtSfa4E1glWyOzBRpuSCQu6UGyqQDknwX7nwcwiaFLM=;
 b=Dy+P5f3+9w2GcGkUEhAdKzjCIYUY+ZDR/UO5vCIRLFWa2NKnr3d+znP9J366qr92F1qz
 iG5fT+mbDoeYROQ9UgF2tBPfw1CZuR4PZRGVGpnqxmroEa/++Thaau+yRSm9eqHuYZjK
 j0u5H5CVh+/oJPXF3GpsIx5w9rA2GKqMSmgr+zzInj8fpHbyoGhHkcCukKI81z2N4gLZ
 FUX45pVpWUF6uk+xTWC4kzmvrKK0xBo+lfGSUxmeI3yCE4Mn0mL0Lr2T0h6A5uua0iYY
 0VroxoLPYpP0E+lkiKEnKzS6wDJ1x4Z4m6m+Kr1gh15Sybs21qxPQf6XJS6yGgaxGxP/ Xg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s061c6fqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 02:05:12 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36Q0Rk8U023169;
        Wed, 26 Jul 2023 02:05:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j5jd1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 02:05:11 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36Q253Nb038905;
        Wed, 26 Jul 2023 02:05:11 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3s05j5jcwf-6;
        Wed, 26 Jul 2023 02:05:11 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, michael.christie@oracle.com
Subject: Re: [PATCH] target: iscsi: remove the unused netif_timeout attribute
Date:   Tue, 25 Jul 2023 22:04:51 -0400
Message-Id: <169033702286.2256288.7730282274323636636.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230630155309.46061-1-mlombard@redhat.com>
References: <20230630155309.46061-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_14,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=562
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307260016
X-Proofpoint-ORIG-GUID: NRpAS11-i5ZyaUmOT6TTtNRqzdo2rYH0
X-Proofpoint-GUID: NRpAS11-i5ZyaUmOT6TTtNRqzdo2rYH0
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Fri, 30 Jun 2023 17:53:09 +0200, Maurizio Lombardi wrote:

> This attribute has never been used, remove it.
> 
> 

Applied to 6.6/scsi-queue, thanks!

[1/1] target: iscsi: remove the unused netif_timeout attribute
      https://git.kernel.org/mkp/scsi/c/30a5b62e1c83

-- 
Martin K. Petersen	Oracle Linux Engineering
