Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ADE4EE0212
	for <target-devel@archiver.kernel.org>; Thu, 14 Sep 2023 01:40:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbjINBk5 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 21:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233638AbjINBk4 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 21:40:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEFB1BD5
        for <target-devel@vger.kernel.org>; Wed, 13 Sep 2023 18:40:52 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38DMqOpP014714;
        Thu, 14 Sep 2023 01:40:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=8XMm4zYxuRjjAaOI3V+6niilhqxr2ytR8bgoumMZj7s=;
 b=oyilbjJaAR61ZcVy8Tf9heLhiWkNILZN8mEDSeuCQOTJ555KHx3pIuMVOiqh1IvDgxYG
 mBGvh7nxjGrD6QUYYBJCWJ+I6/3PssgsSlsoeMCci41pTLFyvjm8xATG60qYugSLb4CP
 dwZYIWulZRirmstL6qyfwTsl5uvt89LV7jS4vIZ+N11KOrScSEgRJc7dy1rW0n499WN4
 gEHtxJOrjpd6H9s01OtOdgCJ5T6TDEIGTRF6hAq51GKbZJxpykdVFbtmNDCCh+73WmjT
 tL36eLLxyo89qsNxG8Cymk6wzN+iOPTYPvx8KQVbMUVnR19fp0CZbPdoqirjvQIf1vQ4 fQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t2y7pkk3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 01:40:44 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38DNr84X007718;
        Thu, 14 Sep 2023 01:40:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f581r1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 01:40:44 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38E1efpR038417;
        Thu, 14 Sep 2023 01:40:43 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3t0f581qyy-3;
        Thu, 14 Sep 2023 01:40:43 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     target-devel@vger.kernel.org, David Disseldorp <ddiss@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH] scsi: target: fix target_cmd_counter leak
Date:   Wed, 13 Sep 2023 21:40:26 -0400
Message-Id: <169465549437.730690.8029315979343900502.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230831183459.6938-1-ddiss@suse.de>
References: <20230831183459.6938-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_19,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxscore=0 mlxlogscore=994 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309140013
X-Proofpoint-GUID: l_IgDFxOm2JZOreHsOlBUHEIAaQQtOUB
X-Proofpoint-ORIG-GUID: l_IgDFxOm2JZOreHsOlBUHEIAaQQtOUB
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Thu, 31 Aug 2023 20:34:59 +0200, David Disseldorp wrote:

> The target_cmd_counter struct allocated via target_alloc_cmd_counter()
> is never free'd, resulting in leaks across various transport types,
> e.g.:
> 
>  unreferenced object 0xffff88801f920120 (size 96):
>   comm "sh", pid 102, jiffies 4294892535 (age 713.412s)
>   hex dump (first 32 bytes):
>     07 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 38 01 92 1f 80 88 ff ff  ........8.......
>   backtrace:
>     [<00000000e58a6252>] kmalloc_trace+0x11/0x20
>     [<0000000043af4b2f>] target_alloc_cmd_counter+0x17/0x90 [target_core_mod]
>     [<000000007da2dfa7>] target_setup_session+0x2d/0x140 [target_core_mod]
>     [<0000000068feef86>] tcm_loop_tpg_nexus_store+0x19b/0x350 [tcm_loop]
>     [<000000006a80e021>] configfs_write_iter+0xb1/0x120
>     [<00000000e9f4d860>] vfs_write+0x2e4/0x3c0
>     [<000000008143433b>] ksys_write+0x80/0xb0
>     [<00000000a7df29b2>] do_syscall_64+0x42/0x90
>     [<0000000053f45fb8>] entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> 
> [...]

Applied to 6.6/scsi-fixes, thanks!

[1/1] scsi: target: fix target_cmd_counter leak
      https://git.kernel.org/mkp/scsi/c/d14e3e553e05

-- 
Martin K. Petersen	Oracle Linux Engineering
