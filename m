Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E068C43219
	for <target-devel@archiver.kernel.org>; Mon,  9 May 2022 06:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiEIGWv (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 9 May 2022 02:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235682AbiEIGKx (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 9 May 2022 02:10:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27831514C8
        for <target-devel@vger.kernel.org>; Sun,  8 May 2022 23:06:55 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2490wLk6024435;
        Mon, 9 May 2022 06:06:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=KcAQLIHpHQZ3fB4ZsrXL+eLCQ9sbX7EqG8JOBv51Av4=;
 b=vvPUyZHrodou3fHFAOphHHJRcjM/FzlHMmVQWG2mUaaJJIHGV2gaRljdTAKloO841Yn/
 xFsKNJ+Clw8u3J9NeZ9XTrjtaXFsRvn1A4Guj+4puhUpUwIcdY1GDN1qMMP09ppg3GEA
 25z5s4GdoeFU1RSDI/BsaAkX/i3oofLbNBwN96rPrvI3U/mP9zrF6QeGncDgINLBmDYz
 tN3YBl6j7TAtSViRHU9yky/jZ9aAuX+gCqdhktV45HJGPcuKEXtwSGiVGsaKpbou6h4R
 FCWFu16xrA51DjwUXAQ8qYQhLPWFILysnuJjmWTQgNqT9wQolJRqYAkDIPX6xbG+7vov zQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwgcsjcjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 May 2022 06:06:08 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24961DBi035006;
        Mon, 9 May 2022 06:06:07 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf70hvrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 May 2022 06:06:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fxoA+gXUZBrdNLsJzitHWrUYqn3/gNp9JPJYn8jW7lbwN7tbc64l6nbm8Qe1VKtZoTYB6E26C2Cucr9s4g89Wm4Vujv+Gv6PwiOcFgNPvfi6OiBieBmVDK5Wi47jIvgzYE4d4sCMapl3kZMXO37In/Ci2dBBidJuGIsg0gvOJfYy1S4/B6TncELlqP4EuFiyLyUnfhfIKizDmO/MTMQqnvaBFkrsFo7HBZoNVjRXK5XcfXgzrz27F9rGp4deqn6hd0Ktr+8xvqdVEa3Ib831nM934qD1CJcrw9C24yI+wX+TX8cFkuuQEpznJ8xvbfwFzGEHCpbLf6+UTzLCZHc3eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KcAQLIHpHQZ3fB4ZsrXL+eLCQ9sbX7EqG8JOBv51Av4=;
 b=dZDJKUt6JP3DcC7ldEAiYpH2EA7pF4I3JsS4MZgEvZKNi1BB4lMjgnedBbZ3eA1eHMARCZxzEgE/Ltln/TWW1caRUnDQxKr1LhlGKvOFvVQV5FrlYwua3o2cQog+zD3RRUr05MyganUVRxiKM1XuH6r0M/X8VH1PgY1UiL+HpmOkO+VaphikbH4i4ZK+ZM4cF1j83B+2sGXsVrHVi/VPe1UXAk1PbwnjzSVWddJh39xvX6PGOlLD+FImEstKc/ulhX0zCllnZqty4lVpel0Y006f1U2UHNoXYbUgFvDxa92VtylQsi74CD+E5P20Pk1LpnNm42/wIqWT8ki9hW917w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KcAQLIHpHQZ3fB4ZsrXL+eLCQ9sbX7EqG8JOBv51Av4=;
 b=g+YeQEFPLw/aBah6EFOojH1m0XJ9C4WGscA0EzBobhRBIl1dv1KQNQJrHqsGvC0xiwRyAux6VJaxWPij/NwyQjIH/RXM8q8d2WjIcgvoFnUIVlXQKx8SUyq+tmQdJ5nBZGwgtK564iO5c3CxGyo6J7Sb/JgAg6XrDVCd4o1KdVk=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by PH0PR10MB4520.namprd10.prod.outlook.com
 (2603:10b6:510:43::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Mon, 9 May
 2022 06:06:05 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::c053:117c:bd99:89ba]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::c053:117c:bd99:89ba%5]) with mapi id 15.20.5227.020; Mon, 9 May 2022
 06:06:05 +0000
Date:   Mon, 9 May 2022 09:05:45 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Bodo Stroesser <bostroesser@gmail.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     xiaoguang.wang@linux.alibaba.com, target-devel@vger.kernel.org
Subject: Re: [bug report] scsi: target: tcmu: Fix possible data corruption
Message-ID: <20220509060545.GI4031@kadam>
References: <YnKX+i4XeOJV1njK@kili>
 <748a23d4-6036-c62d-8e1f-4856d6c75439@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <748a23d4-6036-c62d-8e1f-4856d6c75439@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0035.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::19)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9817321e-8785-429f-5d6e-08da31820078
X-MS-TrafficTypeDiagnostic: PH0PR10MB4520:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4520E177B17275A439B091878EC69@PH0PR10MB4520.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OgesOBm7Xuu3tjLYIodYlkDY/Qo0vTBADkKW5ixfIDRfEC3aFvudb6r+l+RSk7fj1hiaLFFtCpSCNw4LTjBM4ZRa4DNB2A3EOENTkc2NyRD4VtGi8JrqSN1mfXXJVai3d1stX8s20Dgi6hH/55WCo+DDqOdhLl1bZYdcXhXvendP/fwU6ZUhe2VKiJXs01MA6amAcV++zg7A5BHnAUf/oZ5I6Di3lULasjuObUVQMSk27kK1FtOUUp5jFqu9FEUkTUDF6CCdUDrpjQqKGy75HKkynMXltzol7cUY0U0N5RSlgYseXV4sZa8eu6hwpM9gLMF23+DJcFm24SPVPsAkFELzoyiQYr0as6Lq3sFpT/j3ZOreaEkdhrRu+Vxy0lTLa4B2lqNYpQ9pr49U0RCPjYRlYHaT2IrD15EsElTIyJXuGSZke08sbg8tJAmCua5n7S+5HrQONQYxCaZJVX498nC6N7c83uuqXq25cBs9lsk5rQF7gpihEXpNqs9snmJn321/jn17P7klTXmVBWjKck75jD4I3ei8W7mGCkyAe1XAknQQnYOc8arH25Hmx7LyjIvDVThebHLat+sRYce7wey3naYDXIhEZMkH3JEJuh9tbm6yZcxZPYV62dKIzLVzaVxFjmv0sTL9db9HbpqRKVa+0Vg4z4BMnkm2Rfn6v+SZrAnMyM/p913EnyMFv0I+QzXeRpQcq7DjWGz/vsj/Fg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(33656002)(66946007)(66556008)(66476007)(8676002)(83380400001)(1076003)(508600001)(186003)(4326008)(6512007)(86362001)(26005)(6666004)(9686003)(6486002)(6506007)(316002)(110136005)(52116002)(53546011)(8936002)(33716001)(2906002)(44832011)(5660300002)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6GzlcEoV2daLmyOoZVIOB71ocAgqDe2eeVbNBVhunRC2Ps/4VyTzqxaJH+qp?=
 =?us-ascii?Q?REgQX+elf6yqkBI42N0pdBTJ/9tdBZyT1LtWUiuJLc+iO3ilKux+pl4iO3X+?=
 =?us-ascii?Q?T5dOswtW4y1vDZtm3aHmJKY+A6D4r7B7QXmm3d9A4l7fhdAhyl1Sf0567NBW?=
 =?us-ascii?Q?jJj0G8LdRoALKK7KANtT8+th2hUhxAIJWbIU3p6cC7g+eKaV1x9YivRmjdtC?=
 =?us-ascii?Q?uFHCxorfzgt4PaWO+cRhY2iY8VXyg1zeusombg2/3eZHCwYQcMPM7CehWeHz?=
 =?us-ascii?Q?Q5x4ZbvRsIFsTDwEt9cyKMemtxMhwmUc7iaMzJt2b3T7vFUuWtMpRfC+kx6v?=
 =?us-ascii?Q?owPWCcz695HCQ0dtfPi4/u1mpX/yAMAzL3of0B9Qke9ofqqPGH0OVAxLf599?=
 =?us-ascii?Q?o6cU2KwYn1ra19Uc/2Np/9d/tLHPzB0p1nDmz/RpXMSeArYIsRBjSjY1x32h?=
 =?us-ascii?Q?ykZxj7uHC20ft2bj2bnPR0X491cpDXr8LFwbmLLzsZQwTd61p2ELySxScFHY?=
 =?us-ascii?Q?mx4LMTZYlpoifglR3cURj6iXMUn7STs9kHoUFLKkYIgN61t78NpmugmuJl/O?=
 =?us-ascii?Q?AdiLsAVeIMgIFe9x6PWQ3RONAUfSEFFVP5FqM2ND/Wx/bGIbIs/iNCNaHRGn?=
 =?us-ascii?Q?OV9DEYvANsi3Ix+uBAQiqMwmJzC2sEILvDNBulawdxHg9zM31a2j2+7qR1u6?=
 =?us-ascii?Q?AXjv1GOgf0Fi+Gq2w0ZgN2QXGsdansTJGuKLfxGu4h2te+G/1YhxvhZ7FRaV?=
 =?us-ascii?Q?1dgBAX8n6Perl0poGLeMqBiW9qNH/VdAcuH+jfgWgzrfKVrt9uzrieQnrTXj?=
 =?us-ascii?Q?8dBdM7TizeRJKFWKUfHv1OejFTVXyvMH7TiO1eO8SLqRfKtdtYtVoYemfwcL?=
 =?us-ascii?Q?fBvVhZaPW79IwmivgTNcXyjSjTDd4dPz5WAULEZki4LHMdu3i3AWrhm9r2DN?=
 =?us-ascii?Q?v67F39TUoDEZISAdw3be26D1WEyOd6UdHVnTGCPEkOOlbKv7CSNvMGYfuZfe?=
 =?us-ascii?Q?N7e8EfH6Q1vlxHRGRM5NoYF/bLx49fU6ieuqbHccaUgfgZ1sHbkpSIbs3ZAk?=
 =?us-ascii?Q?QAbh0oISXKDVTvMD1notK/UtKs8Fqpe60Lc8k5rE7sesXAm1PS/kqm2UCU/e?=
 =?us-ascii?Q?f2HVE+4XjZROx+Gt8n2snI1Mfd/5OzFxy16QdipsRNMSor2V2A1FQAq9bOZ6?=
 =?us-ascii?Q?SNBZL9vcc9DzE2AdeEIgs9pnnw9Gmi0U+nCreqhHQE+HJ93nSfAo+RYbNpVJ?=
 =?us-ascii?Q?SuEkFjwWtC+gkTVAX52Jkan+uoPngPP0QM8xHAr28hw/YWXrgemJx4cfI0pX?=
 =?us-ascii?Q?YUX+WZF/RZYRaqhE1NgZTaqBBo5dURB+rn/3HDY5pBUKfi/URdOeB19ij7+g?=
 =?us-ascii?Q?HnCxtha1HARsEh/7IeFSf1ehAj50sgfhxAJKH83yFyrMf5yKheoCLpXBbmys?=
 =?us-ascii?Q?kl6PL2u/XWKH9Am5V7wBKB6ewLr5wOTWM87IdG0bPwhKY1ZM92aqKuhVA70E?=
 =?us-ascii?Q?7f2L8a7LmOm9PGlJ54MnB6sRg7vT5ENOvbGIX0mLQ2WkZTDSGB23mvPcx6yS?=
 =?us-ascii?Q?CRfI7SDlOKNRwl3iQmxwt64nfa93fFlBKkYh8OJAYs+vAorMngWZaGXPSckw?=
 =?us-ascii?Q?9/V9n9iMa7Z7JnYAi0UayKVUE97mcx/NXMcnx8443AS6/YxG8u6w5IHR+E3g?=
 =?us-ascii?Q?ubDhOeqMbH1ehBgPgfd+hiwG10EZO/6s9Vz4b0aj1nvhyJTAzISZnvle35qL?=
 =?us-ascii?Q?ry6kZ6tT6zi5I5QL45Rfv/9iFU0o4VY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9817321e-8785-429f-5d6e-08da31820078
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 06:06:05.2400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JDEiJuk3Tn2P301FOx/M9EHneAhuW0dvV1LQPxD/qzMITd+67m81R5obJ/BA1IklI6g79bdMdi0OY5XlPZF/JGppuIoK8PvwuvI4P1dAcNE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4520
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-09_01:2022-05-05,2022-05-09 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205090035
X-Proofpoint-GUID: mgeL95DWh9iZ3YfX-bcH0l4WKxBmnLk-
X-Proofpoint-ORIG-GUID: mgeL95DWh9iZ3YfX-bcH0l4WKxBmnLk-
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

> If there is no other way to avoid the Smatch warning,

The Smatch warning is not the issue.  If we're holding a spinlock and
we call might_sleep() then that generates a stack trace at runtime if
you have CONFIG_DEBUG_ATOMIC_SLEEP enabled.  Probably enabling
CONFIG_DEBUG_ATOMIC_SLEEP should just be a standard part of the QC
process.

Anyway, it sounds you're just doing the locking to silence a warning in
xarray.  Let's ask Matthew if he has a hint.

regards,
dan carpenter

On Sun, May 08, 2022 at 08:03:14PM +0200, Bodo Stroesser wrote:
> Hi Dan,
> 
> Thank you for the report.
> 
> I'm quite sure that our code does not cause any problems, because
> in tcmu we explicitly or implicitly take the xarray's lock only while
> holding the so called cmdr_lock mutex. Also, we take the lock without
> disabling irq or bh. So I think there is no problem if lock_page sleeps
> while we hold the xarray's lock.
> 
> Of course, we wouldn't need the xarray lock at all, but xarray code
> forces us to take it to avoid warnings.
> 
> In tcmu_blocks_release we use the advanced xarray API to keep the
> overhead small. It allows us to lock/unlock before and after the loop
> only. If there is no other way to avoid the Smatch warning, we could
> easily put additional xas_unlock() and xas_lock() around the
> lock_page/unlock_page block.
> 
> But if there is a way to avoid the warning without imposing overhead,
> I would of course prefer it.
> 
> Regards,
> Bodo
> 
> 
> On 04.05.22 17:12, Dan Carpenter wrote:
> > Hello Xiaoguang Wang,
> > 
> > The patch bb9b9eb0ae2e: "scsi: target: tcmu: Fix possible data
> > corruption" from Apr 21, 2022, leads to the following Smatch static
> > checker warning:
> > 
> > 	drivers/target/target_core_user.c:1689 tcmu_blocks_release()
> > 	warn: sleeping in atomic context
> > 
> > drivers/target/target_core_user.c
> >      1661 static u32 tcmu_blocks_release(struct tcmu_dev *udev, unsigned long first,
> >      1662                                 unsigned long last)
> >      1663 {
> >      1664         XA_STATE(xas, &udev->data_pages, first * udev->data_pages_per_blk);
> >      1665         struct page *page;
> >      1666         u32 pages_freed = 0;
> >      1667
> >      1668         xas_lock(&xas);
> >                   ^^^^^^^^^^^^^^
> > We take a spinlock here.
> > 
> > 
> >      1669         xas_for_each(&xas, page, (last + 1) * udev->data_pages_per_blk - 1) {
> >      1670                 xas_store(&xas, NULL);
> >      1671                 /*
> >      1672                  * While reaching here there may be page faults occurring on
> >      1673                  * the to-be-released pages. A race condition may occur if
> >      1674                  * unmap_mapping_range() is called before page faults on these
> >      1675                  * pages have completed; a valid but stale map is created.
> >      1676                  *
> >      1677                  * If another command subsequently runs and needs to extend
> >      1678                  * dbi_thresh, it may reuse the slot corresponding to the
> >      1679                  * previous page in data_bitmap. Though we will allocate a new
> >      1680                  * page for the slot in data_area, no page fault will happen
> >      1681                  * because we have a valid map. Therefore the command's data
> >      1682                  * will be lost.
> >      1683                  *
> >      1684                  * We lock and unlock pages that are to be released to ensure
> >      1685                  * all page faults have completed. This way
> >      1686                  * unmap_mapping_range() can ensure stale maps are cleanly
> >      1687                  * removed.
> >      1688                  */
> > --> 1689                 lock_page(page);
> >                           ^^^^^^^^^^^^^^^
> > The lock_page() function calls might_sleep() (inside the declaration
> > block).
> > 
> >      1690                 unlock_page(page);
> >      1691                 __free_page(page);
> >      1692                 pages_freed++;
> >      1693         }
> >      1694         xas_unlock(&xas);
> >                   ^^^^^^^^^^^^^^^^^
> > Unlock
> > 
> >      1695
> >      1696         atomic_sub(pages_freed, &global_page_count);
> >      1697
> >      1698         return pages_freed;
> >      1699 }
> > 
> > regards,
> > dan carpenter
