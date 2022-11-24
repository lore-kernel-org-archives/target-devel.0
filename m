Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 987CEC4332F
	for <target-devel@archiver.kernel.org>; Thu, 24 Nov 2022 03:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiKXD2g (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 23 Nov 2022 22:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiKXD2e (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 23 Nov 2022 22:28:34 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE02956D68
        for <target-devel@vger.kernel.org>; Wed, 23 Nov 2022 19:28:31 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AO2iKE2028162;
        Thu, 24 Nov 2022 03:28:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=wMRaWjmaeV5Z6SPGQsRYQiG/B5R7cCvSBMShYkVzKWM=;
 b=HSJui3cJxxLPNIIJ42ioARYwJMKu36Ayt92opUqzIcJsRbRcaXNlawlmXGh8Zs4MCwHu
 1N93b5bfh9WgZpIYlEm9EsD6PW+E0so7ctlw2N3tVUDc16cm/wrj7X8iM4O6jIwCJHEu
 4T0P6QHkzYpG03M4st0iSfId9C7oecAxt9d5kQ0f3aocdVx7eK6VVRQbj5mgyzz7/y71
 xdM/kQi0KWCUnAFv0pFcu7IVYgapyoVjzxAARSmiCsNtxsl9KSJFG4kfn8I93PwgYOAs
 yZdMs5ELhZCOGn7BG9sTTS3/U/kNbsWgtCe0xLpz2N9SwgAaf+F+cQ1zs4l7FrMX7JbX vQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m1p5fhgvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Nov 2022 03:28:29 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AO0KfbG015892;
        Thu, 24 Nov 2022 03:28:28 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk7m4s7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Nov 2022 03:28:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXCt+vjFWjyRBvtHCRE7QPhpEpxS8G2jf/Eg/CnOlARAN3hRyh2qlVvsyCtbK1dhVCvf/DS+PBKG1b0PwOHKWoKOhCHa0pygTLeoq+EpyMz93LzkI4LMZnFOF8XrmOHmFcgOcXtOn2xxgk9z5ddy709dp4BtClxs7llUWbm3dYYxO8Sgonm5pmYDavalojZ5U9Q2j8kBEAtbrs2NWHdv+0S07OsY25H3SZBS7+HtseDpwNh5cdn/a3NTkZzvarKxPzFHW6DGdbOOelI82YIxYfYlq1W4XKQuthbBf1dRMcUqKXjLIQiCmsEhYPoE4M2s/VOWbLT5zvM3/PCuGXCZqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wMRaWjmaeV5Z6SPGQsRYQiG/B5R7cCvSBMShYkVzKWM=;
 b=kcwvZ+88kdHRZYtC1ubzy4nxko/wSvKkGaXn691827qx5fw7cdIF+UMQ+SPj+xAigSnOGzKDgxnf7GIQY9I27KdLg/Pleteyg2TZKrH1Lbaij9D0u8H4+9VSVTyzujNHVLXuDo0oyXsrziXO4m/uyYYwc6VmEEFgFA5sHmRqn4898wI5zl0sad4+hGUPpm68PzKsG3gnMmqxAvSqhsX/IAG+OLWHoERUxOU1eXhNAlElh2FCYHJyMNLtT8mfttiEoJGjlpZEYycc3WYLRGoO1B1ncpetM2JHKEUSZWPnBh8KoaYWc01z3p04ldrUd+Tgt4HrWYoojFlRwLjrMyzpwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wMRaWjmaeV5Z6SPGQsRYQiG/B5R7cCvSBMShYkVzKWM=;
 b=cLVgkMUTcCKUwqI+FlZAUKAn/YGc5OAyRQdKADYdHaNhUBAu3ZE4PqAifhdfIHYiaM/fG14Xm8w3shNEvKO0W144YHj824YC1WHuTX4GcWgpUA6JBVgBHzGQ02pUr6kRnz/t5xOqxkEgDixt5rSR5uL5AGdAWtvPg8/rgzalbvc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB5181.namprd10.prod.outlook.com (2603:10b6:5:3a1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.18; Thu, 24 Nov
 2022 03:28:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a%8]) with mapi id 15.20.5857.019; Thu, 24 Nov 2022
 03:28:26 +0000
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     martin.petersen@oracle.com, michael.christie@oracle.com,
        target-devel@vger.kernel.org, linux@yadro.com
Subject: Re: [PATCH] target: iscsi: fix hard lockup when executing a
 compare-and-write command
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zgchrpyp.fsf@ca-mkp.ca.oracle.com>
References: <20221121092703.316489-1-mlombard@redhat.com>
Date:   Wed, 23 Nov 2022 22:28:23 -0500
In-Reply-To: <20221121092703.316489-1-mlombard@redhat.com> (Maurizio
        Lombardi's message of "Mon, 21 Nov 2022 10:27:03 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS7PR10MB5181:EE_
X-MS-Office365-Filtering-Correlation-Id: f5b5e67e-3dbd-4df1-7168-08dacdcbf313
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N9PHW14fMpGsv85EWWscmKO70j3bsk+9KQun/eU5DldV2zhbkn28+NbUI1k4+Emg63g5OP6nDUWQmWwXvv6RqvRGuJqJq1cmGMlShU20GWakPZzOjGkG4ALa9JvkFZPLxA2SspHaabHX+o7uV6+j7PkTgfKMsls8ymNExKz4MwwwVeI8lY7o0THpNtv5aeAUlsyNhYCXIPZTlmgbYGbj0juBN37NADNcxhDdfc1Y6f4HO8s35N9eW2KPnSn+aEbwzJB0l+6HFJOJZO/mcVVg8pWGzcTRAGHT4NHmglACw/z8Hmf++Tk4E8zcpWqHhrPvxoCZE2EzB2LDvTjS2ZpnBHvcPAICzvy6qyFuAqy8VEp2f4jm7WQiWQjDtPPawEXVyQOrX5/O2KFILjUbkOx7K9LlQzp2CUaSw31/Q+RzxzAKF1kPaK5APviHJafn9HfNu7bD8dC3b8spIOOtW9aIv2FBeAuPcjtag0ri4WfVuPF/iiaLPtSB8vXgMWQaKnjWDpbDIK2BeedqEbYxQPHCHuHJAwLhXz0pk433bbuhoY2hDn2SHy/Jnzn+lw77vuWdAtSp9gMP8ZXE2cHA+SXRCeVJ6DmNJ4oN7R0vc2wH8swWHOJdgJ0ND6M74abDfh+8sUrPfR8u2h1mU5mDL98GgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(396003)(366004)(136003)(376002)(451199015)(478600001)(6506007)(6666004)(36916002)(6486002)(8676002)(4326008)(26005)(316002)(6916009)(66946007)(6512007)(66476007)(66556008)(41300700001)(8936002)(5660300002)(186003)(2906002)(4744005)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/aTNqWrfC9T3fn5DlreVi456gjlS+PUuE5eNT42stXvvcj9R6Z5VLQq8dGet?=
 =?us-ascii?Q?BJoQQb4tm9i1o63Bk/SvrWYwQwWFywmeWE7jFOZUBZ9Ub59KsKbu1PC1VR7Q?=
 =?us-ascii?Q?eubhQaiUe4YwtaFYsCAbzerj8kLENFqsTJvStFVMGP9W2Gf+ikppUr+txfg4?=
 =?us-ascii?Q?uy+YCKyPoLleQBczcDZX0759uwYEO11Gl/KKF5Z+2SQXh71Xf6a6lZZkwsil?=
 =?us-ascii?Q?8IEBseG2MLIKcHrPpcDeX5gOlDgIcWoTVPhBM2QDxlRHXgWJ98LJJbHfb33b?=
 =?us-ascii?Q?Up5/IpJxA4lUStZ44dX9jb090B5ascq4XEKUaUbNkDwE4Yp3Y/2pVNw915fE?=
 =?us-ascii?Q?yCKtII8i1tRTBZBBUp27IYyfi2Dtu6M1uCUqVRTQE5UZ8QofgHi0ADzCiPzL?=
 =?us-ascii?Q?QbAg08QBB9c4Uabi7Xj6kWqUYSXScWRbTxzzMxck/n9BN3ZJp0oIpDLB0N3N?=
 =?us-ascii?Q?VktGT9gRv7JPsSN9ZxHX/4rTas3EFqyiRFGDthdwDfso1ZLwIYSWQKPynkrW?=
 =?us-ascii?Q?npXatdDxm1hTd53r6ZceeEeuZHxolJkaltU6EUiG+0iFs/xdcXPjOmjG2Cyq?=
 =?us-ascii?Q?mNOlYUANxCGrI1fG8LxlTSCu5/EGqkYr5WLlNohBuGRX4bqdFkVLrt7jLaH2?=
 =?us-ascii?Q?VQGjWPufBbJf47TU+PdbJOzS1rG4h0wOX0aOvI6QFPn7e5DMybc5Kbr2I4Z2?=
 =?us-ascii?Q?D/xfjPQdkqY6b2VQ+Gck2Q6ce0zmSaP090RrblY3nc2ljzUjGRf51zRatkqt?=
 =?us-ascii?Q?H6sQs+oF87Y9543Ge7cJI/Sy5tjuBqFxhnTOKbrOeoPWtN7y+v1jlfRAcgs7?=
 =?us-ascii?Q?mTOGiQ8xAcF4wNWduI5apmh5we67seHyNUPD7OwP8/KeD5Xe7AiVOxvdnAZr?=
 =?us-ascii?Q?AsqYusg7XQY1bXdpG7dNmZqQ7xlJZkKk7NVRoolNiBinr8CcXUUOQJ9UqDbp?=
 =?us-ascii?Q?jj4J+g0jDW+mhKx5pgMdq/PZRHZjoE9t7YbiOl8oNY+GHt266xbPCs9zqGEt?=
 =?us-ascii?Q?dq34Ku+8/dfh5ciTSd03f+TZtaVNZGlRukFqRSchef58pEuKIFiG0vOrWKkD?=
 =?us-ascii?Q?lkt4gmNz0f4BEXeNKuZAfgG/M6nASru2cJYb1bNIqsfLpdcO12jaPR5JLrrK?=
 =?us-ascii?Q?Pf9qYQhlJZnKzcKf6yLIsyy/IHZgVLG+IkQJZ/KazxuyhPCUBg1T05URelue?=
 =?us-ascii?Q?VYHJkyqA6Zv4vynYKbGTmAxcZaWT87XZLKpHksx9Ey0aegY848ux+O5enfgo?=
 =?us-ascii?Q?7Zj7WSX+eNgLhEog5PcVFXqxhLPS4lgUoeD9MhLpkuxufDnxz57CSwMewo1S?=
 =?us-ascii?Q?Uh+FeTmyItRKrVkSIBdmNO+VEpGDdn6FQtnh1gIRTblssAK5nChG/FW+9xuq?=
 =?us-ascii?Q?Yxp8+5TRHqYUEn17OBVbI7g3VeMpnwJ5VMgG+8sc3KmPq0z1InXVEqNGRWTy?=
 =?us-ascii?Q?BrWxtOEdtU8NPMwEDRQwKPdXwjydMpjyrijWVPJFm4bH7pdNO4P7Rj8qDDOz?=
 =?us-ascii?Q?wgp1eO9FU3r4kpaBQA0NZqS4Lri8Fp06VX6wjoBcEZ3B6NM1rH0npddpMzee?=
 =?us-ascii?Q?zJJjGiHxR4sK40oeJdKS3y3x72Oqw7GIWFeWGCSJ/prI8O6cxVLJv8UznNCV?=
 =?us-ascii?Q?VQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: sMQXBjrwoLmXpESEDRH6kr+zawWHzVgQjeSVZbb9pB9CeAXvG/y5PalLhF1aI2I4qJrF2dQq8c/ODwS9IqutRo9SZSRkr14MW+EYMkvMcqtAJyeGIccHEvDnZKdfLap8tMDIilzGD06jGx7y8INIQ/RR9FTb/eo1TelwajzPHK2a79C80g5lSiRyB8rB+KWNACa6KMBhbbTTvGAqsZnQ1QiQPdjeiakCmVfM8ev37flrGSUhRFj+cc2pEAhtt6wSuArrZ47yzeoGRT5mPRDSYWE10owQ3xCXM+Oy86D6GfFeAW9lo2/5KILR22yipTvFSO+CFqmj24BauT3xRs8otP7D3BV4+zRcnwILMaG+NLGJ7kXzoeD3jNWGshXw910m1jRdbSP66vaXljDzHTrl0HGMnwkaH+k6Olf09tm56Q6b7j3akYgFTvAxknBs8q/JKSVOqzCNGiO+KhvG1lKktqvr7htvtPGGj+bL9NZWqPshCKSb5IjnMcNbV502jRyUhW2hFBnudjLoDR5yr9U5BQM10wYf+rVGMdEsjM2LbfY10r8ZpeaGZdXtrbmrAb/6ysYSsQ2+xPa5XM9cgqokSqWXGDlDD+ijMsM76FwRC/0jPC/j2frCyVQ1ltMd2bmUsfqsV7LG4akq1QDTFUQgOuMILmezbOIZwyQvQVd0PkFk9B6ootu30Htp6D9L51Tv0yCE8Rvn3RPLhkjrvKzgfU4DGwz46fd6gdm0fmZgvR8nI/unxZCYLzORDAN/ohj8/x7oW24Oa/UcdM2hmDj/9lYSIYzRmMoEnbgUctekwM0uDg5J8UI0zg5QyWil1LhR
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5b5e67e-3dbd-4df1-7168-08dacdcbf313
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 03:28:26.8101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dhLyYzrZbdLmdzZVe1rOR+ubWuuSP132vmuEXs/ZMFYIkM8uRSSrY5c3O0kSfDqlfaY4GO9Libe0yt3VqNLfn2rdtnfV3BWVb8rtNS5LkFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5181
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_02,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=738 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211240025
X-Proofpoint-ORIG-GUID: qoWjEQ3ZP7qbHqq2Cm_F6H_4N88bv4fC
X-Proofpoint-GUID: qoWjEQ3ZP7qbHqq2Cm_F6H_4N88bv4fC
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org


Maurizio,

> While handling an I/O completion for the compare portion of a
> COMPARE_AND_WRITE command, it may happen that the
> compare_and_write_callback function submits new bio structs while
> still in softirq context.

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
