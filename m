Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85FFFC64EC4
	for <target-devel@archiver.kernel.org>; Tue,  7 Mar 2023 02:57:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjCGC5r (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 6 Mar 2023 21:57:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbjCGC5o (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 6 Mar 2023 21:57:44 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5815665057
        for <target-devel@vger.kernel.org>; Mon,  6 Mar 2023 18:57:43 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326Nwrgq024446;
        Tue, 7 Mar 2023 02:57:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=kROnrCaRTMEwpkf2c8lOvZoWzG0G7FbXztSnHoJ976Q=;
 b=BQY2Wj1W9R1ZNUGsF16N8BSy/yjbzjk/bnG4kYImFa1aH59lXqSnrJAN8sWo2qn/FgCG
 TE7R2jmg3XHbSRIyJ3gZ9Dgy1l7JT4WyU55Kv4gC0LgpoKi/BhvGOrVjRh4q8uggB3yw
 j/74qUiWMzGZcTGE8AM4q46IeEzjXghVzw9oLyRl5+zDDp60NL3uxDFYPoURcY1+5hjP
 dwVcmT1HXxz3RUsBCPwn/FQzGoDYjSUjqIinWC/gYBl5VWkhoy674UwWAvzQp1Ed2wM4
 pEglCohLOJYHGAqEjPVKyp9GRHgA+NDt4TPSw5JA3IIeEnax9yJgs4J+1lO003ZZ0AP8 Vw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p416wmgr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 02:57:41 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3271Sx3D037521;
        Tue, 7 Mar 2023 02:57:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p4txdvjkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 02:57:39 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3272vY2M009567;
        Tue, 7 Mar 2023 02:57:39 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3p4txdvjhj-7;
        Tue, 07 Mar 2023 02:57:39 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, michael.christie@oracle.com
Subject: Re: [PATCH] target: iscsi: fix an error message in iscsi_check_key()
Date:   Mon,  6 Mar 2023 21:57:24 -0500
Message-Id: <167815780194.2075334.1565439378309097994.b4-ty@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214141556.762047-1-mlombard@redhat.com>
References: <20230214141556.762047-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_14,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=0 mlxlogscore=656 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303070025
X-Proofpoint-GUID: kIVhr8sG5hJjhy2TWgtr3ffJp4kSMza-
X-Proofpoint-ORIG-GUID: kIVhr8sG5hJjhy2TWgtr3ffJp4kSMza-
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Tue, 14 Feb 2023 15:15:56 +0100, Maurizio Lombardi wrote:

> The first half of the error message is printed by pr_err(), the second
> half is printed by pr_debug().
> The user will therefore see only the first part of the message
> and will miss some useful information.
> 
> 

Applied to 6.3/scsi-fixes, thanks!

[1/1] target: iscsi: fix an error message in iscsi_check_key()
      https://git.kernel.org/mkp/scsi/c/6cc55c969b7c

-- 
Martin K. Petersen	Oracle Linux Engineering
