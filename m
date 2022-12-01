Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB00C43217
	for <target-devel@archiver.kernel.org>; Thu,  1 Dec 2022 03:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbiLADrG (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 30 Nov 2022 22:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiLADqN (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 30 Nov 2022 22:46:13 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4F79F4BB
        for <target-devel@vger.kernel.org>; Wed, 30 Nov 2022 19:46:01 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B13PoGB017334;
        Thu, 1 Dec 2022 03:45:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=CAFCSTcWN44kpMClfmHFTYF6XjnlVYokS1lCLeNch/Q=;
 b=ccyQFXsu0Q2rnwhC+l0RSpG0vFFaPn2PQCPMnAHXmvOv1LM6STjR28cAgyZzQt/2GsEV
 q+uaM2NiqC7lXuK10L4ufCchVmIevSdT62uOdyMvflMjzoI81TVMQ/bJZDHQ+W49FLO+
 X6aoGGxxN+qs94FomliTxh3lbK4H82kqB2rGa136LpT3rYNTSHgJwxkW9RSILETtyVDI
 sN6uMU1SflQU5BM9BVBtBx3diMhNIMHFi32Z24MPriM8jma14aHItl1rhD+LpA2q4m6b
 dDO0S9V4lTRCoM1c6Th8nOJT3eRGI9WYiVwc05aR4soV87bpbqKsn67c5/3xRHrLSQUB cg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m4aemjjp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:45:58 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B11wfW6007655;
        Thu, 1 Dec 2022 03:45:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m398a2cwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:45:58 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B13jbq2033801;
        Thu, 1 Dec 2022 03:45:57 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3m398a2cjs-21;
        Thu, 01 Dec 2022 03:45:57 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        michael.christie@oracle.com, target-devel@vger.kernel.org
Subject: Re: [PATCH V3] target: fix a race condition between login_work and the login thread
Date:   Thu,  1 Dec 2022 03:45:22 +0000
Message-Id: <166986602270.2101055.5295224615402081958.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221115125638.102517-1-mlombard@redhat.com>
References: <20221115125638.102517-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_02,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxlogscore=903 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010022
X-Proofpoint-ORIG-GUID: bzhlOiiIUpuIB3IRFRiHGZ9-7XVEMqzS
X-Proofpoint-GUID: bzhlOiiIUpuIB3IRFRiHGZ9-7XVEMqzS
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Tue, 15 Nov 2022 13:56:38 +0100, Maurizio Lombardi wrote:

> In case a malicious initiator sends some random data immediately after a
> login PDU; the iscsi_target_sk_data_ready() callback will
> schedule the login_work and, at the same time,
> the negotiation may end without clearing the LOGIN_FLAGS_INITIAL_PDU flag
> (because no additional PDU exchanges are required to complete the login).
> 
> The login has been completed but the login_work function
> will find the LOGIN_FLAGS_INITIAL_PDU flag set and will
> never stop from rescheduling itself;
> at this point, if the initiator drops the connection, the iscsit_conn
> structure will be freed, login_work will dereference a released
> socket structure and the kernel crashes.
> 
> [...]

Applied to 6.2/scsi-queue, thanks!

[1/1] target: fix a race condition between login_work and the login thread
      https://git.kernel.org/mkp/scsi/c/fec1b2fa62c1

-- 
Martin K. Petersen	Oracle Linux Engineering
