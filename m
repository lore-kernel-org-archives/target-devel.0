Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D38AC433F5
	for <target-devel@archiver.kernel.org>; Wed,  4 May 2022 15:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352011AbiEDPQ5 (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Wed, 4 May 2022 11:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352021AbiEDPQz (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 4 May 2022 11:16:55 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F42194348E
        for <target-devel@vger.kernel.org>; Wed,  4 May 2022 08:13:17 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 244EZLDZ018676;
        Wed, 4 May 2022 15:13:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=JZCvnxqezMApdVu6O21qekLQbXS85OD7ad3yruz4IMI=;
 b=lM97VkNC5Ebr5pI7/EEQLGE41e48PP0J3OZCKfBAwAzWHtd0nK0aOCUK2/ubV2cO9Aft
 zK7Jn3+yi8qJELi59EVhAA/3P/pDKczSxRX5q0aCGmBIxEElRRspjQ6grfr+UaNXrq12
 ewMmWHxsTBBInrKjHk1djrU8ThjAgMCsLE+H9pJe8Hjv4lAOqs/qdfze+tX49L4GVium
 dbkZpa98fGvOPUGi/QJnzXs8Pp/nrbe22s5sPcZcB3e2ClLSumKejZfwPRO5s1nKF+Uk
 hB+0baCD0ADzYBzMqMd8lOh3FWrhQwbflp25hsO0Z3uon9h0PsQ20IMSAed8SYh0keN1 kg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frwnt8sfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 May 2022 15:13:13 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 244FAp8e034859;
        Wed, 4 May 2022 15:13:09 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fruj3fs3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 May 2022 15:13:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eH4cDVC3VX1JrQYskOcM2sAhrMjyNIl8ICEyy82jNlStkM5BNNRH+IQWPaUp+C90m3SwhSwIFsdV7Xcz9DEoa0LDl9wXo9FIc+sjbBdMbf3auv0W3P0KnZq2uNqaEfsNSNWqSvaPcQLTVlQQ2p+RBbQgLHOTUH1FVZ0fHbIJIyc1Dy54cm1y2TZTl2bl3W7ecGsoilvEMHFtn/nCKIwO+XDhXGFlRf9sDd5HiY+gQaS22zfrrLoCH7YJRiO0AVrg2t18SK4cS27o94zej81hEgIw8W8V6IcuLYS2xTSPct1TAptK7uNfvf1sGoPyc5idHgXuScvEmRXXauc7Cu93gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JZCvnxqezMApdVu6O21qekLQbXS85OD7ad3yruz4IMI=;
 b=SqMx8i/Kry9QmX6tqwjgF7HPVm5prPbRgU9j1XV4o7rVeYsErrcnAB/yqF8UCp2/HDPI0g8aTSsc1pwZkiAjuIBCHTPcMN9Rmda6/7Gq0TFLSk2a2gVfZlnPEFXsmt5VULSAjzZOkGRRIJi8F5Ndk9rdxvMu0yj7maNsqBHyhaHCIq60fnQjuQk6lmP4aaYQEmKy3MR8S/0MEsTYpqQShHzntFZXdM3bwPK2+yMlVOcQOkQiwBfVm27veBP1mNmlyEzjMOvFL44N6q0gHcyWd/Ve2T7nGkTMWa7gfz/VE7dEBsGc/smNdnk2QNiiYoYCSvejeiXl/Padn6r13PIrYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZCvnxqezMApdVu6O21qekLQbXS85OD7ad3yruz4IMI=;
 b=ypzzIfDIw8eY4nRvLhiY/I3BUezvSPx90ncw9+9hi9m/oBvYDFpdHFDQrD5yurHvZDbJAGtaRZjGnVKne9c36C8LAQYM2WW1S3c4t9NITUa2WJMXj4Sir8xTaSMpUebDqQowjHlBzyGH9azngXeNaaaXe6b8cM6/rouK0CFxFnk=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BL0PR10MB3042.namprd10.prod.outlook.com
 (2603:10b6:208:30::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Wed, 4 May
 2022 15:13:07 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87%5]) with mapi id 15.20.5164.025; Wed, 4 May 2022
 15:13:07 +0000
Date:   Wed, 4 May 2022 18:12:58 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     xiaoguang.wang@linux.alibaba.com
Cc:     target-devel@vger.kernel.org
Subject: [bug report] scsi: target: tcmu: Fix possible data corruption
Message-ID: <YnKX+i4XeOJV1njK@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: ZR0P278CA0127.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::6) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd1356c2-8531-46b0-ce5f-08da2de097c9
X-MS-TrafficTypeDiagnostic: BL0PR10MB3042:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB3042043B29A0432D9A765E608EC39@BL0PR10MB3042.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ktCk/kroa1QXVzsp+riTYD+9rBPwjV1U99VD7sciwcMrYaFLa06GSDTPg17e8pjN2mKYtQ4F+9YwAp1/R6LCRTkbrA4L2R8XBo82F3nyu4AgdYaogTk4r6GP7ATRtveQ0jYVj4jhv7x2qcWcKFBkMU8CqYg0y1zT9RqJ+15AeZWC8SHmpH57OjuACDeTimWjNzF2ruHGj1oJhB4lG9KfLFDwvtuUq2vyAPNVVjwvetg0W7apz0sJ9H03t6/Gmlta7q8uz4ww68FwLGYo5uEcxKuoTwca+4vPjUJI21pu9Vn7Jbv3AzdqFcDvtEQ90byDSuAZk97ey95nluXAGWS9f3m+qbCEz1szBfSAcIW9BlHaoaoH5OVxaFF8cZ6xGBu0Nq1zwASc/PvzJ6aInr8zUGAsypsvhP3KTZLYKgtc3D9KXyoPA/aj29QDXjuzryKAbh0QCH/jDr3GI9TnkW3L0ommdbTZem4cl8b5F6pL/moP5hJJrE1ux4fMMlHtNIdM2Qal031yHTbwWz5nKOyRMroDHcuvvjjiB4MLnwu4yVw8M5usUvOT00KKUnwxcxc5qeYXHpm8FdHHBRFG4dlF9wfvg268ysFxjhbuTeDZcEqimGIbXRn3KC7Hc714yhy9z1zZTxL7uqVSCWBAAjTbjRxOo3atpEMH1hb8QO48K0Bn/Jn9j2UdQ9kPEI5rjo7obJKHILd3C19DT5ZIitt2IoafQCmIyq+/eJUdYQkFTOs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(83380400001)(86362001)(6666004)(52116002)(6506007)(508600001)(38100700002)(6486002)(38350700002)(186003)(26005)(6512007)(9686003)(8936002)(316002)(6916009)(4326008)(8676002)(66476007)(66556008)(44832011)(2906002)(5660300002)(33716001)(66946007)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XXSjafgbjCUZIXNM2yym6PWiOIkuggXTnegSxW8PGx+eVEBPyAEX7SetSUxI?=
 =?us-ascii?Q?4fBGEdoS0KNqL+t1Kvm1xT+ySveaRKLfhaHCT7UKQEs8Zjd34YSYLHp6WTBH?=
 =?us-ascii?Q?/GPk4e+BUflvLCqSzUUnF6z0QsyIhJxn/+TCnwP27ad6k4zaMQM27WvUWR47?=
 =?us-ascii?Q?o3afsIFZPoYZ6bZnRT0t8GpdTZi9rEoctktZECOOYkW/65/ynDxNSuk1QUBc?=
 =?us-ascii?Q?ApPZKcXjzDGWg0zScwSsuTGylnY47B/tWDUzz9sijhFvFKwy2Jqk3Ed/S/zB?=
 =?us-ascii?Q?et0roI9kHoiNneESnHpiEKoOlr92byKxx+/f2xudvWYzrtO8pucjFeZmeNCC?=
 =?us-ascii?Q?Qm59e+y6VGLrwjOnsMkeM0XCHzGqs6cbOz3TBwiLjektI1wh16EdUiYurWsO?=
 =?us-ascii?Q?xwdKf7eVTc39SpXmygTzPIqFVYpUooTOtZjSB/crOnXhCMvMLqlTY5XI0Oja?=
 =?us-ascii?Q?QAWOM4ut552S5apPg2pybHkexRWyGgBmB8Pw8y9C5c+hae29LFzYg+mf1tVf?=
 =?us-ascii?Q?xpvahZ73maXjIvrMVc3QJQmibptEvaorNk0Pl26PmDTiKuuFhNrcQMYDCr1h?=
 =?us-ascii?Q?CpuhVPpLy9JbAt9sGRh+/1q8GLLao+TBvDApGP7Qi2kwHP2/aZCCzof9Wssq?=
 =?us-ascii?Q?1+qDsjzj3lfgznIEH4DBaU8D69guqERlxWb/b+ckfigORHG3N04NJadIryNt?=
 =?us-ascii?Q?ZogEFOzjm/bAlyyVnF67hFRNjJLwokS7XOUWUFsFYOuLgFMpuaPYsVmUcEJQ?=
 =?us-ascii?Q?xnlD7LwTFxGSmHe4Olj72YBFUC2Z+t80kia7ywxcQaJNreD6rk1KhNnRTdkN?=
 =?us-ascii?Q?z+LbG6Ljzi+69pblbJxbbH1N9tq5xFNJwR1M/RqDkirj/WTc8XmpU0U4mpaq?=
 =?us-ascii?Q?uP5Z01zPBv2AfI/mNtdYlsv1OVfRKuunCIaLOOhMvbAk4QkSFddI+R1N76AM?=
 =?us-ascii?Q?xpxwIa3Pxrultd40ZSGVWq9/ZTpeOm7JS+mUiXI6hvLM0AjKV/D7yt6cE/Z9?=
 =?us-ascii?Q?vNqhTAss2Gpl9/HpEa4GwFIwpLQurDb7EkpYWvoFxV6icDUJeD9jpxs+s/Sf?=
 =?us-ascii?Q?UHjbvhQ13yS2oAD7CiidMlEnXUwXVKAl873n6U4OFaCJgd5lq4WBJHCjx7s3?=
 =?us-ascii?Q?bJAdRlpdg7ws5N/N3JEF5SHMTMZ+33hfO4e2S1G/I43R9CNkIS3Mvzx7nksL?=
 =?us-ascii?Q?uvVNzR7cN1JEjikgGj2kpaky5H/P5q3bcHe5SocUzJcJ7n+7CVt/ekf+kokv?=
 =?us-ascii?Q?XaUMacHAawMMwp39K4KCvyPLBIaaYUJLe6SCWZZ/Hrb7XfAzIkPl8UaRJvSX?=
 =?us-ascii?Q?FB1qB16QHQyVQIKe6Y/uGJITfi3PsNAskbidT2Gc5+u4BHbR7gwqLsFmYHax?=
 =?us-ascii?Q?kpDFIoNa5aU1pNhiyyWGHXtrdR9jJCNIEghjPst5Tdk16hBBW6Y1t7q51uf7?=
 =?us-ascii?Q?rRLNz/buULZ+aI4jxNW0zzW+EffAn7E8AHeIHlFTmzGlZLf58Ao92dAtJaqC?=
 =?us-ascii?Q?rTxIRcAN01vajmCZwpeHYi+GT++zgeY/KynwihdcibIb3ZLNcR+s3TDprWv1?=
 =?us-ascii?Q?ifKLLrGFiiaGcW1aVBJBLhh8Q9UafAf9/Ls82FEygjGQG9ZWbKJHvkDyMopK?=
 =?us-ascii?Q?SIo22P7VlJfmvENg7IMU6VvzqwcQJP4I+1fxL3ZaTmx9AiLpf0/lkqxVSzHi?=
 =?us-ascii?Q?pOh7ImB+vXavKBTpNsAPNG+2CzOq9kkFMaIDHvQKosdOGqOZhTp0HEeBYeKY?=
 =?us-ascii?Q?UNHAx/sZEX7+sONYqcHzSFPRcNXp11k=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd1356c2-8531-46b0-ce5f-08da2de097c9
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 15:13:07.0886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5oawkjAgpC52pUOLoPGOjGwUFeWJ6StDBGQQBwzQJy6P66gk1xOePEUGDF2jk1jUnS46zhSxnfUx/BOhZ0CYiX9LZ0EYzpQu+1ynfa4vsj0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB3042
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-04_04:2022-05-04,2022-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205040097
X-Proofpoint-ORIG-GUID: MzBVYS19wfXQomLjpzdGi2EAAQ1IDd6B
X-Proofpoint-GUID: MzBVYS19wfXQomLjpzdGi2EAAQ1IDd6B
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hello Xiaoguang Wang,

The patch bb9b9eb0ae2e: "scsi: target: tcmu: Fix possible data
corruption" from Apr 21, 2022, leads to the following Smatch static
checker warning:

	drivers/target/target_core_user.c:1689 tcmu_blocks_release()
	warn: sleeping in atomic context

drivers/target/target_core_user.c
    1661 static u32 tcmu_blocks_release(struct tcmu_dev *udev, unsigned long first,
    1662                                 unsigned long last)
    1663 {
    1664         XA_STATE(xas, &udev->data_pages, first * udev->data_pages_per_blk);
    1665         struct page *page;
    1666         u32 pages_freed = 0;
    1667 
    1668         xas_lock(&xas);
                 ^^^^^^^^^^^^^^
We take a spinlock here.


    1669         xas_for_each(&xas, page, (last + 1) * udev->data_pages_per_blk - 1) {
    1670                 xas_store(&xas, NULL);
    1671                 /*
    1672                  * While reaching here there may be page faults occurring on
    1673                  * the to-be-released pages. A race condition may occur if
    1674                  * unmap_mapping_range() is called before page faults on these
    1675                  * pages have completed; a valid but stale map is created.
    1676                  *
    1677                  * If another command subsequently runs and needs to extend
    1678                  * dbi_thresh, it may reuse the slot corresponding to the
    1679                  * previous page in data_bitmap. Though we will allocate a new
    1680                  * page for the slot in data_area, no page fault will happen
    1681                  * because we have a valid map. Therefore the command's data
    1682                  * will be lost.
    1683                  *
    1684                  * We lock and unlock pages that are to be released to ensure
    1685                  * all page faults have completed. This way
    1686                  * unmap_mapping_range() can ensure stale maps are cleanly
    1687                  * removed.
    1688                  */
--> 1689                 lock_page(page);
                         ^^^^^^^^^^^^^^^
The lock_page() function calls might_sleep() (inside the declaration
block).

    1690                 unlock_page(page);
    1691                 __free_page(page);
    1692                 pages_freed++;
    1693         }
    1694         xas_unlock(&xas);
                 ^^^^^^^^^^^^^^^^^
Unlock

    1695 
    1696         atomic_sub(pages_freed, &global_page_count);
    1697 
    1698         return pages_freed;
    1699 }

regards,
dan carpenter
