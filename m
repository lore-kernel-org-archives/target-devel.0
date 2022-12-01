Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2AFFC43217
	for <target-devel@archiver.kernel.org>; Thu,  1 Dec 2022 03:46:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiLADqf (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 30 Nov 2022 22:46:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiLADqE (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 30 Nov 2022 22:46:04 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EC99AE2D
        for <target-devel@vger.kernel.org>; Wed, 30 Nov 2022 19:46:00 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B11PAiq017406;
        Thu, 1 Dec 2022 03:45:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=CQ+VtKJXuJW74b7nFE1g2pyGWkIU67CwPCGyOE8uWFs=;
 b=ow3nlWm5LEsyT1XZ+1xTBSGSlYDlCOeu9Hypwf+6KODDVqdvfZSGeSFX4ZbMvC2EhBVv
 Lm9Q/fp0JNymQubkbbIKVXaIl14gH6d5clE66pOSYz7t7Y1GZ0t4Jlky5/lOKFlhFdnJ
 2+OMPKibWSPRx00mHsA0mBIg1rrwKz6Wzj6X1t9QtvnrxI+zaN4k/JauetD+UZ0ufeYr
 kOnrbLO3iyopNydLqGmZvGkVHl72qnQbQ063LS5xtnbhzKNKQv+ZSO6UHoVTFLGDLha7
 mVdNXlvd8qtyUEYPGxvgL54RBKYbDwS3eWj92/S6RrQMY6rzb67KD91Qzoavr8mjX7Bn 0A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m40y43eph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:45:58 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B12EKVB007577;
        Thu, 1 Dec 2022 03:45:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m398a2cvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:45:57 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B13jbq0033801;
        Thu, 1 Dec 2022 03:45:57 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3m398a2cjs-20;
        Thu, 01 Dec 2022 03:45:56 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        michael.christie@oracle.com, linux@yadro.com,
        target-devel@vger.kernel.org
Subject: Re: [PATCH] target: iscsi: fix hard lockup when executing a compare-and-write command
Date:   Thu,  1 Dec 2022 03:45:21 +0000
Message-Id: <166986602271.2101055.5686284244931457350.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221121092703.316489-1-mlombard@redhat.com>
References: <20221121092703.316489-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_02,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxlogscore=782 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010022
X-Proofpoint-GUID: YB7w6rS8KzThdFNcquvR9PNDS9vFr9H0
X-Proofpoint-ORIG-GUID: YB7w6rS8KzThdFNcquvR9PNDS9vFr9H0
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Mon, 21 Nov 2022 10:27:03 +0100, Maurizio Lombardi wrote:

> While handling an I/O completion for the compare portion of a
> COMPARE_AND_WRITE command, it may happen that the
> compare_and_write_callback function submits new bio structs
> while still in softirq context.
> 
> low level drivers like md raid5 do not expect their make_request
> call to be used in softirq context, they call into schedule() and
> create a deadlocked system.
> 
> [...]

Applied to 6.2/scsi-queue, thanks!

[1/1] target: iscsi: fix hard lockup when executing a compare-and-write command
      https://git.kernel.org/mkp/scsi/c/a72629b5cdbc

-- 
Martin K. Petersen	Oracle Linux Engineering
