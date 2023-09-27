Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84CA9E82CC9
	for <target-devel@archiver.kernel.org>; Wed, 27 Sep 2023 19:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjI0Tew (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 15:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjI0Tes (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 15:34:48 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18951136
        for <target-devel@vger.kernel.org>; Wed, 27 Sep 2023 12:34:36 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38RIxY40031600;
        Wed, 27 Sep 2023 19:34:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=OXmLiMHz4G+MMyvFGRgGzhFJQeZgiNOadw/yO2T1oIg=;
 b=nOzb1Ic5paawQB/g5frtBy1Uk3Xsg7dZpJG6mVp/eDDfRHE8giH6+s3kNwoTIQ4rrYpn
 cB6iQiLN8kbwN3vuMb8/el4JRTh15ld7Mzd2VBngaBhNDpB1EFwC8OYI6K06oeE8MQnW
 MCwrUg0ZSi5FzoYn/NwUo/l/QpjGXZHBqiIZMCTvaKlTwe2nRxnP35D7WBKIDQnXW5kn
 WboXJw6g36+xNH7CdMG8xdBSKOh84+TEU/oZKYF6LT90JM80fjCbr0UITx9uc9LhpWir
 ijKXh2QunIwN54WIy56YbiCTiJa8USnsPussjxWCmis+CuhyxWQ+2xkLDJk1PVZKApW8 2g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9pxc2jgd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Sep 2023 19:34:30 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38RI4waJ030613;
        Wed, 27 Sep 2023 19:34:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pf8cv0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Sep 2023 19:34:30 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38RJYTlp010018;
        Wed, 27 Sep 2023 19:34:29 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3t9pf8cuyr-1;
        Wed, 27 Sep 2023 19:34:29 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Mike Christie <mchristi@redhat.com>,
        Christoph Hellwig <hch@lst.de>, target-devel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] Replace most references to linux-iscsi.org
Date:   Wed, 27 Sep 2023 15:34:22 -0400
Message-Id: <169582723798.1126739.14021534946226072177.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230920200232.3721784-1-bvanassche@acm.org>
References: <20230920200232.3721784-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-27_12,2023-09-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=563 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309270166
X-Proofpoint-GUID: 23C2myBKpKONyzoJ0O8nnK0TwOUfTrGm
X-Proofpoint-ORIG-GUID: 23C2myBKpKONyzoJ0O8nnK0TwOUfTrGm
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Wed, 20 Sep 2023 13:00:18 -0700, Bart Van Assche wrote:

> Since the website www.linux-iscsi.org no longer exists, this patch series
> removes the references to that website. Please consider this patch series
> for the next merge window.
> 
> Thanks,
> 
> Bart.
> 
> [...]

Applied to 6.7/scsi-queue, thanks!

[1/3] scsi: target: Remove the references to http://www.linux-iscsi.org/
      https://git.kernel.org/mkp/scsi/c/f3f50c78649c

-- 
Martin K. Petersen	Oracle Linux Engineering
