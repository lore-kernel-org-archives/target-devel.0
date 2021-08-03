Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D219C4338F
	for <target-devel@archiver.kernel.org>; Tue,  3 Aug 2021 02:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F0CB600CD
	for <target-devel@archiver.kernel.org>; Tue,  3 Aug 2021 02:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbhHCC5V (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 2 Aug 2021 22:57:21 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:25298 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233436AbhHCC5U (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 22:57:20 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1732v0rH001878;
        Tue, 3 Aug 2021 02:57:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=cA8FYXhv5bqKvu7b/ikAW3isncVYS3o+V14fH70PBWw=;
 b=MTdBqUqY7bOvfx94NrysSuuuhm9HhQ2RB4HRrOIa7hGBqEOt86Xc1QLxY5uVJK2USWpT
 J7GlEpbtZt4x9XiCaEADdLnEyr7UzkjdURuMMrvYB5UWD9eN4oZ8pleGV1vGU9pA2FXx
 zjvC9fOYIYm/aUdg/anB4aQPbyoDX83/dhhXdiTL6DLQAvxnFL/iqJik3VtAl7CWmGyX
 0MFw73IvOl3TbFY/aXYYLWM/KfVe0uCUmwnoLtWt9DZmFMPgC/eAN15+RcAvSRoncqxd
 6+FQEDSxffeX8ZWqMvZ+mmzorCY9PKdi1FFfciFHAIFajfBnr7wSyGOFbF9wfTSRCvxr 0w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=cA8FYXhv5bqKvu7b/ikAW3isncVYS3o+V14fH70PBWw=;
 b=JbE9qRE58oNglW6UZWxK/N1kvblXDv7z1Oe1JOJlPrlo4je87Ofu0weYPIpOR61GXPPq
 RwCZtYfOHSGJBP4sBKERWFFTLjJwLyx0ym06V/Db1vjevvs/XKyD8kKqJmAEfdQ3YeUP
 nolO/DfczoUHi+rbxOwFiAskLxIwmc+/hB3jEOVBKSVqUIJxGJ6TwsapoBs36eqAT1KB
 A2BvXl5qC5C+KTwsXeCEjsB411pLjus/tS7pSHaCosOxrlnhshv20V1w1PuUz07fLwb6
 kSK4GDZ9I2dob6z27v1KLZ/fVWCvjdE1brHpRZk6XoxrNloX3GMkhJDP+KN+/IxXbwvX aQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a6cntj8d3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Aug 2021 02:57:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1732tFpI073997;
        Tue, 3 Aug 2021 02:57:07 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by userp3020.oracle.com with ESMTP id 3a5g9u7kdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Aug 2021 02:57:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cVM4vPKY7KWUw+em8w73hjSjz6IM8I1Wx/qSvPoQCyqzFnjL1sbnWVKiTtcyXShFiYOtAN/GjJNTihlgtBQO3NDrYqVt3hclwqjBfqa+nP9vrpD9asss45vtBB8UISRyxAV0K7jNV3zwdvwGi8cBbQrg62LDq351Yk4yeXnbhksg5P5RS5rRAXndUryHuIZMMCLK1uiI3TGRYpVZPeeX989iCxhnXOAmPKLMsV7CwJug7eRKx6gIGITjR2DQSr8MxTbbrA4wuDfqHVqZ0Gdy3sqdDP6qm4bh015hvmhhkHlvrMZON24cSvuaNJnB7EcNYjAtT2Y6QQYPy1o8mHQuwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cA8FYXhv5bqKvu7b/ikAW3isncVYS3o+V14fH70PBWw=;
 b=MkOsyAMwn4roWjnEEqfCNlBIdF94jhJQNYIrWIwT6vZUVyte38vrxvsQJ6wFXk9LRZBSsmGkbiOP5UnR9J1060JawbfGqteibbMjGmOafSupjP/yLJq8lmlsyGU8fZaC9jAMlYIYexfk3kpgv3S2uqwuSO31aFX/bRbZGetLWBMFl7K9LPmpceLbx+f7N+XJ7HuXSqDj0IOJYjrfEpm5humtHE5eT5UnaaDlBUlDmElZV7MrdNiO34bbj+9xGNkdwuChxL8vGRY9gtPEf06yKBHgCgLRgMnkpEfpwqFju1UcN71n4REzDv8kI035BNwj9S5DssHOVE3A59ICIasPUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cA8FYXhv5bqKvu7b/ikAW3isncVYS3o+V14fH70PBWw=;
 b=bEjyWXseUGQIihbfUMx8RkfMfxsGJyOYbRYxtBezg0hO8XwyP81h1s+MQaf21CETGE5y4+H4y8i+igqNE7pK8mcbQ7+i9WtPZ3Ic6c5y+C5eK1GOkpJr+0k3SmwrCUWCIiciAlNFsGy3yzOo695sXneAZz+TkEZMI5Gv9L6wvBg=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4438.namprd10.prod.outlook.com (2603:10b6:510:36::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Tue, 3 Aug
 2021 02:57:05 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 02:57:05 +0000
To:     David Disseldorp <ddiss@suse.de>
Cc:     target-devel@vger.kernel.org, martin.petersen@oracle.com,
        michael.christie@oracle.com
Subject: Re: [PATCH 0/3] scsi: target: se_cmd cleanups and race fix
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1fbjkwb.fsf@ca-mkp.ca.oracle.com>
References: <20210728115353.2396-1-ddiss@suse.de>
Date:   Mon, 02 Aug 2021 22:57:01 -0400
In-Reply-To: <20210728115353.2396-1-ddiss@suse.de> (David Disseldorp's message
        of "Wed, 28 Jul 2021 13:53:51 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0195.namprd04.prod.outlook.com
 (2603:10b6:806:126::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN7PR04CA0195.namprd04.prod.outlook.com (2603:10b6:806:126::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Tue, 3 Aug 2021 02:57:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6e8f666-3112-4cc8-8c9a-08d9562a5ff5
X-MS-TrafficTypeDiagnostic: PH0PR10MB4438:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB443876D33FBE0CDF11873BDB8EF09@PH0PR10MB4438.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yeQx133JKmoEyC1Rw3mLFocvV+vgAiLPUnqmxAOU/dQBQAhzywifIUxMv2pqPRvPk+paxxA+Q4ujApzW9KmsmqtOtXmYfTIKXHQ//DfPy9WrlOSjykWjO1c1rsyzFaDIBbbfhHNuidnwQcV6F+7efPYs9P9pefK29lG8fma4UUNY2EAXqMJx8zfa/jNfmqgBXbKfccAEOduDaSKz7WxcO8c327F+aJfMFmIKJbhr8zz2WydV7tGlyYW/FdT2PReLJC/qimup9YYjfg7DCGZGy5Q30R68rj8WdQUP3nvN3EQovmdQVsKvafhMA32aFWHY+HNXR4rdlyKraHW+OMwDB96Xg9mPWl9hdOFf/kC6IxaAB2vk3DqfHanjVcqor6z3YfNOvc1JyJWn/UDJhACNUYe1gSZBdCey2J7Makc+T05F4qc4V+tNjRrXn3Y536hO7CfjOdGI2b3jHh8mBBpH5Pfv/biHD+VoD6NR1h72JepSJqWIGSM4TaNYBm+vyzT6DyBzB1LoIv1XV3R+/G+mVFki8HsVC024lmJNCzgyM3SUzlgWg4ZWyviFrydz/9KRxfFk2F65eVThBuR9M2qTbuyGECkihIrRcm8wLx9tXH2fne7M4Yh9kBoVXPhgX9Mo5F0eSKPGn9mdf0c5DSh0PMxwJnvU+H4l9g2iys4munsHN7hI1jnLgRBu2vu/XfVp2ssMEmk/sPqy2TdKYqONQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(55016002)(8936002)(86362001)(66556008)(66476007)(38350700002)(38100700002)(8676002)(4326008)(5660300002)(6666004)(316002)(2906002)(4744005)(956004)(66946007)(26005)(508600001)(6916009)(107886003)(186003)(52116002)(36916002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?obEGyW9Pt2KUqpsV8087RnGh8T1wbBeW0hAiBbaXJZLXjmhYNi/2P086EzBv?=
 =?us-ascii?Q?wLgAoUeMeWiDkHoFTZJ6UiFUdc7qLwkecVkvn81nOtY4Hn1LXCIMtIImm5L+?=
 =?us-ascii?Q?k4kTWWjWBjNSxZu5t0qMwOrvDjtLCl4E7a2GOppfk8EiapNw9ZyxF9U7zlyn?=
 =?us-ascii?Q?t/f7dHqoOZ6LnMN+HqRFuaS6lD1p/A3zztQo22XYLM9nD08f6cjDnXG5P+/h?=
 =?us-ascii?Q?ATYz2QtBydN3OnvfiNXH2lTOJ0dNrqfv/wVgiIb3fa9Iu4HWtYxqRJNSZiF7?=
 =?us-ascii?Q?bfXT0zPxiYH9I7PTh574DFYpOvz4J948MsOqsRtUzc/yWcfeVRlcQ6mxfmI2?=
 =?us-ascii?Q?ArJmRF6Nvo3iRGOoUqhk2DuzfWrQ1rND3qypiU4lECJlNslMzAb/5vpADDL7?=
 =?us-ascii?Q?S9jFWK+PAt8WhH+UHuUO42G7E5heXoO//gIQKYAdLHm4U/vPMIiRPnhnAasj?=
 =?us-ascii?Q?mR/+LCz9/ekscAlnMZ54vtJxaF974GdqDOA9KOBMDaadj/mpZJ5fEjI6jakB?=
 =?us-ascii?Q?YP8axdsOgMGBAR/6We105GroIFGXzG/rS5AruBe56S4Rq/BzmlW7ehLrU7T+?=
 =?us-ascii?Q?SzboZk2XQDgUTpkURN+Wunuayit41w8TKZUnfV5KsFB+G/TXKmdRZHlczoGs?=
 =?us-ascii?Q?+k2QYDizFKAV2Mfan4luTIPCIQaus2iHvVn+bN2K9oOxN2Mi7Wquii90rC4L?=
 =?us-ascii?Q?1+9ugBP7FLjlULCNpnm83lJoe+O6kv5T5lMLreIMZw2Bcyb9EMpLQixSBZG6?=
 =?us-ascii?Q?S6XHkhP0EhoxaYvMNz1KGyeFwgcGFIrpDEVkf7M5DpFP78wkYzbVl3JH1Wbh?=
 =?us-ascii?Q?y4KkpmVbHGrlNXkl69GbcO4ORALfJjPh11QxP+QstN10rhLuGOJ+c0RveRJF?=
 =?us-ascii?Q?TlJ0Lemwy+iTa0U7pQrFt6NHJT09dqfxEkg3QpN5Hb8+ISyS0EBe1pbEZNbq?=
 =?us-ascii?Q?G2OqPc4/8wpTF3qQBxyxMleTPUY9r2f5GY5AMLUpQtfmr5Npbx6U2bixXr9/?=
 =?us-ascii?Q?ttkbP52CxzaN3Qdne/2Pc/fouGS0lVVCYZ+1NCcQCppZp3P5tr0LaL1wDkpn?=
 =?us-ascii?Q?S4owIKn05fsm8rzae0bFYXmf4nuKmcyKWOGBGUZLoZ8+A8ryUsVWdpMKb7xq?=
 =?us-ascii?Q?XFr+sNN49y2UjJUZMrIj98xPf5zja3fFy0m4mqNIqe2cw0tNF5gmJ/tTY6fo?=
 =?us-ascii?Q?A1QdPU723oOUMZhlhvvmwZftbwbgSnKCA1pveGjvdFdUNPKRXwmHjRVhvk1o?=
 =?us-ascii?Q?azGq1rY6Ea+sUhlyZNirv7ngmWa/dF2dh1yGDYVpwQnIpdQ4y1loHA5T37Dp?=
 =?us-ascii?Q?GMES4syntd4u0rj1P5AAMKPk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6e8f666-3112-4cc8-8c9a-08d9562a5ff5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 02:57:04.9204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QtupGqLPkuU6nJfzj+ShzR4JOTygKNTucvU1BRsqh5oVOUAWlzWILIyjqZS5B3n4fWkULp0cgsU5KWfzu7R4RpYPZLzcrz4dE4XV1zPudiM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4438
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10064 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108030014
X-Proofpoint-ORIG-GUID: 9DvZQNY2w9pqrsceMGz1-wBbVmPmHed1
X-Proofpoint-GUID: 9DvZQNY2w9pqrsceMGz1-wBbVmPmHed1
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org


David,

> While looking into XCOPY sense propagation issues (see Sergey's
> patchset), I came across some se_cmd members which are unneeded. This
> series also carries a fix for a theoretical lun_tg_pt_gp race condition.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
