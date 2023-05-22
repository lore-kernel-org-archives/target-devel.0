Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27CCBC77B73
	for <target-devel@archiver.kernel.org>; Mon, 22 May 2023 22:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbjEVWqA (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 22 May 2023 18:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234649AbjEVWpy (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 22 May 2023 18:45:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E9C11F
        for <target-devel@vger.kernel.org>; Mon, 22 May 2023 15:45:47 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34MKO0oj010849;
        Mon, 22 May 2023 22:45:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=sAWmSTsFNmUGEw41TZMhDSz3uZv61r4Ba0AiqPNSfsU=;
 b=pk0Nm00qmPrpUmwzRj9Uam+zFVQHrgN1K1OhMwF482qWqHK/FkYJo+y5wO51RjvyOefp
 JRlDtsMWBOBV+dtVP1Z+gGdZjaOlobtFZ/kTmP1PL3kp4wAoT/9MtIJ0JFP8Nud1SqA5
 cJPdSQQwYJ+n/Vd+JFid1hAXV3j+mNz0gebuxK4IFVFuRQcQkg3AIgVv3o5eqFdK3eRa
 +Q7496WVDfCGe5lgI1YkyBZfiEgiCbIPZ7cE7tu+5geBJ3d74SVIsWFXJ+vay+3iLu8D
 Pm+OC6UzV4Kqh03/16MYL86NPQXxf5AorDLo1xYe1bBaD2/nz+MPeCyfbMwL1F0DNHEN aw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp7yuts7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 May 2023 22:45:45 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34MM0N8a013061;
        Mon, 22 May 2023 22:45:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk7e2n9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 May 2023 22:45:45 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34MMjiVW023074;
        Mon, 22 May 2023 22:45:44 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3qqk7e2n9a-2;
        Mon, 22 May 2023 22:45:44 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        michael.christie@oracle.com, target-devel@vger.kernel.org
Subject: Re: [PATCH V3 0/3] Fix possible hangs and race conditions during login
Date:   Mon, 22 May 2023 18:45:39 -0400
Message-Id: <168479546537.1263525.11716567178385507185.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508162219.1731964-1-mlombard@redhat.com>
References: <20230508162219.1731964-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-22_16,2023-05-22_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=565 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305220192
X-Proofpoint-ORIG-GUID: aecccFm2vI2K39nN-fJiybKKS9Oda7_S
X-Proofpoint-GUID: aecccFm2vI2K39nN-fJiybKKS9Oda7_S
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Mon, 08 May 2023 18:22:16 +0200, Maurizio Lombardi wrote:

> PATCH 1 fixes a possible hang when during a login operation the initiator
> stops sending data to the target and the login_work doesn't get scheduled.
> 
> PATCH 3 fixes a bug in iscsi_target_locate_portal(), in the error
> code path the login semaphore may end up being released even if
> no one called down() against it, this may allow
> multiple threads to access the semaphore-protected code.
> 
> [...]

Applied to 6.4/scsi-fixes, thanks!

[1/3] target: iscsi: fix hang in the iSCSI login code
      https://git.kernel.org/mkp/scsi/c/13247018d68f
[2/3] target: iscsi: remove unused transport_timer
      https://git.kernel.org/mkp/scsi/c/98a8c2bf938a
[3/3] target: iscsi: prevent login threads from racing between each other
      https://git.kernel.org/mkp/scsi/c/2a737d3b8c79

-- 
Martin K. Petersen	Oracle Linux Engineering
