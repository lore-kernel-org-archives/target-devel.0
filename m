Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB6A1C4338F
	for <target-devel@archiver.kernel.org>; Sun,  1 Aug 2021 18:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 850E660527
	for <target-devel@archiver.kernel.org>; Sun,  1 Aug 2021 18:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhHAS4G (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Sun, 1 Aug 2021 14:56:06 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:39746 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229680AbhHAS4G (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Sun, 1 Aug 2021 14:56:06 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 171Iq6Ni021444;
        Sun, 1 Aug 2021 18:55:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=GFY6+E7D27BwFeMz7UvzIjt3FZE8xM7RhQclZeThGp0=;
 b=AzePOWyhrpTkwAO4XVS5SHwlN2r7IJ5z8SYp+j4XJjXc2Hcze+pZYAcGxtm6Tkh7GTgT
 sOOzbrJHIRjglk/6j/f1cto4ttLO+uIRchdbOByBmwy9iEOH6tZb2azU0iX3xdTxGse5
 RezV++puly3ib/dTBzhVgONW4jAmRGkrLYh96psQB/ln25OD5aTb4AQAlnS2cvm5anbQ
 i5XxpdyqXWNzSShUhA+q+C/G0P8L3jgyZs4P8YNaSPsCahfXyl2nrpjgWk09ghTvKjom
 c6GuqIdqbi7VZVP/q90mmQPOPa0JhqetYbzhYNMy/MoH9PUT8vHoTB2dmRfp3y/P2IWg Eg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=GFY6+E7D27BwFeMz7UvzIjt3FZE8xM7RhQclZeThGp0=;
 b=Iu8g4APMYxFQL59eSmQWGnhf2zQO8tfE06xhRBXL8p/ijbsAMAinOX/f+7Vak6vhIgHS
 cpGjc0B2kXMrMTBfy271NfkQkxqrxj2777ytBY3clQbKsuUH8kyhEaHhkQmxbhZ2EeRS
 a/guFukjxXdjSwHaQIFfy12xry6ToCpRgduu6k3ACsLelZcZsv7kKDVsoxGDT66o9rfS
 UW3lTflv6LNJIsobtEXkf+DNzUuE0E99gUUD0DnoNsMw8GUAZcJLEPRVdnxWVrN7m8S+
 TbBqj1Yxl0HvwoTcyyh4uFQY93gC15JPkkVIUGZtXZJyTUDQCZ/Co/8D7YpKefcAJbXx yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a5wy1g46y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Aug 2021 18:55:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 171Itkg8152518;
        Sun, 1 Aug 2021 18:55:55 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by aserp3020.oracle.com with ESMTP id 3a4xb3ra62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Aug 2021 18:55:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FVc4zFx4/Hr3PWZPKa5QxZE7CMNvaLGsYYq4S7WI/ROwE9GyqpsVGMgdLwfvcBS55GjMDm4HRHHJwljIRWRCR3OpkgFtGCCGMeZJKxzCXKOE7qhy7Y2ddbY3PrX876TJNjPgbHML+frdb50nzn+OFYeEa/Ea1g6evzHt2KwP1ejrdicy9+37i1+2ZqxDpxq7CTP/ICycR9j4JhP1B5VaCK6J5Hzb5yMFdNYswULylfTNZ5cNf+z07jOkPU267x4WedCCTLG9oOpEE4oW6qifSbo6QWJ048aJZHjuzpXpWBjczeMgwmHApcDxJImw50qjVUZR8VDZTa7iRIdtau3uwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GFY6+E7D27BwFeMz7UvzIjt3FZE8xM7RhQclZeThGp0=;
 b=CgYJMLFm9a7LQ7g7DKafxALsNPnLIDsawN+hFz7Lz/Uzvjicvw8AqEi6gjeLi35pr7I1m9ta4e8lolioBerO33lz3eUegvMNczBZwzO3WIgHJ1kCUdS6jJAFonkUy38J4kQh0PRjdVSCSkfjMb4+dxq69fYpfgQMXH8auuwSzsJhoZpE8zOvSnTFHeWD4CXUgq2lQZVy5LHS02PRweiyAJrrobz7WA73pAC82658pLUQ0YLZEBYNex5tFGOwAe6ly5mmWWZMn+T86X/xNwPf+bTdXNDaMto9zisQQSfkogG8/c0AZuc33N/SbSTbzowiV7qiybjSGX/lQTUi0rWlVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GFY6+E7D27BwFeMz7UvzIjt3FZE8xM7RhQclZeThGp0=;
 b=aR38mTKSvKrHnJM+l8Kh5UTGZUcINuAgC4+nw+DLTm7GLjaJXLUKCri1z0XPUCbde6ZA8Yytc2vHIaeFYnkep/ppHij3R2NEsE/Y1hr6l8riMstTw3bWcs0g7HAcwKL1td9elgq/tQ1HUjGybaLNbZQFbQHZ4kb80pSF/iBTgkA=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3014.namprd10.prod.outlook.com (2603:10b6:a03:87::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Sun, 1 Aug
 2021 18:55:53 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::5cdf:33ab:8d17:9708]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::5cdf:33ab:8d17:9708%7]) with mapi id 15.20.4373.026; Sun, 1 Aug 2021
 18:55:53 +0000
Subject: Re: [PATCH 0/3] scsi: target: se_cmd cleanups and race fix
To:     David Disseldorp <ddiss@suse.de>, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com
References: <20210728115353.2396-1-ddiss@suse.de>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <64cf0311-1b67-00fd-fc3b-f847ccde80d2@oracle.com>
Date:   Sun, 1 Aug 2021 13:55:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210728115353.2396-1-ddiss@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR08CA0049.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::23) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM6PR08CA0049.namprd08.prod.outlook.com (2603:10b6:5:1e0::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Sun, 1 Aug 2021 18:55:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98579571-bd20-4dfa-6e65-08d9551dfcd4
X-MS-TrafficTypeDiagnostic: BYAPR10MB3014:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3014B4A38871F090FFDE811CF1EE9@BYAPR10MB3014.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:353;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zwva5QnPHI4oPN5TrQPt/Tqp5YjzK9CrIV2tfF5+hV2wgBNwRpoGDs5NUxj3zM1OBLqKlJESB0BHFVN9M18TVSK0M6RETbR1B/aW6vADoJLbEVU+xk083i1ziyiUmIu3Ky31e69NYfsvCK2LclXDRmaP81RQgbzXG4sHfiCMu8+gosceZCPHPgGEVTX1ejjw444p2Vp7g2alj31Zkz+bx8kmUZZAbq47yCUdBF/kiTD4jvDIeTsQNMa3cLYAJZSE1wrYv0KzC/42Tw2Qfqmvd/4YYtdBRL4M1j/RbztbFRTk9nqbwwJhZ1Mu/qZvkzCqWSDGodcdXpJTJh4NH7Jqf8bH/xUNx81SymIem9wxYXvatrAj7SOlqZyBET2gPqwby394QpcqnqGupjIcR6VN+1L2lI7SxIR/KZDx6EgfjqgOcXGMxC5CPsJDvab/OXDhgqqCOIfSGl+6P7ZVoGgbcfdd927ROqzXviWlNM4MAx5DYwJGBN5tY4Eub8TGQe5vIjqtcy+BjwMB9nL89iiHBV2+rJDR3CzFhIFcH9N4qjaT8oCaA6idvnHsuKHVwxsqVNyVvXsoPgcPKH9ekRF/0DRTETBqspmJ4UFHyWe02aIkRsSwyVjg0SG76K83k1HRBeLDpn4DtJRdfk/DDTLHGZUtFos/GGKw6GhKurSosEdgLOep+xiBgnTuLPUiY8Zf5WSoT/R+XhqeuP7J2Hjv93u8NkkPUE3GIAck6JIgOhnoqNMBOb2+LNwCvHH4SzFVKQh9DbYDb5IcuC9UmeXjfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(39860400002)(376002)(346002)(4744005)(107886003)(8676002)(8936002)(26005)(38100700002)(186003)(6706004)(53546011)(31686004)(66556008)(2616005)(956004)(83380400001)(16576012)(6486002)(66476007)(36756003)(5660300002)(4326008)(66946007)(86362001)(2906002)(478600001)(316002)(31696002)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NjlIQzE5bTNLN2JqcUMxck43c3owZ20zZXIzYXpzRlRiL2tiRFkwR3V3RS8w?=
 =?utf-8?B?UXNYWDA4Zk8xNDU2U0trOHNobmJsV0xpMzJBaC81a0haVVo2WjM4QUlHUlBz?=
 =?utf-8?B?dk44anplWXI5SGNRaE8xSGZTVi83Um1CdC9RS3dpS0RVV2NzMXViVXBKRG10?=
 =?utf-8?B?S0Z2S1pKa1RuMS9WcUZMSEhNQnRLQ3hZYkdOT3NvUVRWNG1GbVNRdjBjbG5r?=
 =?utf-8?B?NHdwQi9aNkkyWGRqMzJ1bFR5UmhIY2lrR2I1Z21vQzJnWXpWVTZ1TE9TcHV0?=
 =?utf-8?B?MVNra0UxSnB6dE1XTmM3WnFwdlJwQ2Q4TS9lYU5sejJ3NTBubUNoWk02REJU?=
 =?utf-8?B?dkdrMWh1VmRlMG0vRXdMNC8vY2EzaWJ0aDlNeFUxK20xYnVoNVVRakNJbHNx?=
 =?utf-8?B?aGdtUVdSRVNiSDZPTm1ReHczSSszMkFLOGMrQ0Y0dmxkcDlKaXpucG8ralll?=
 =?utf-8?B?anRhYlRMYWhoeHhGYjVvZkRJVk1tWlAvZUZZUUlQYUhPVlh1TjBHTGlsUmMr?=
 =?utf-8?B?MENkNVAySjA2RkxGaVZJZGNMc2xlWG9HMVhhUERYSjFzOURub1gwT1ZMdHZ4?=
 =?utf-8?B?K2J1aldiTFlMcDlhajBVRVUxRVFmN1VxZWtIWGwyZWZITkNHandzaEtoUkpN?=
 =?utf-8?B?R05kZzc3cjZSL2tGSUV5dmVUT0MrRThRdjRPNkZvejB2MlB1SWRtZ0VJcXk1?=
 =?utf-8?B?c3Jnbi9GQzVUT0s1c1VhWXZ4ZHFLS3dXV3FOdlN1RmY0dWV2aW5MdzBPbHIy?=
 =?utf-8?B?UEt6NkdUZitHbGJKNzUxVFNhTkd6ZWlaVEwxMGJNUVhnMTlEWmRYQW15bW80?=
 =?utf-8?B?SUxPUWFVeld6azNsaFlMVWpXRDY2QkgyNS8wMW5icExQNitWNFpWc1l4MS9v?=
 =?utf-8?B?QnpOQlBWSndFbTNCakFySmM4RVhsU1hmc2NvdUI5THlnQmhNdmk5eFNtcHhw?=
 =?utf-8?B?dENKcXhBMFQyRmZDQzlzQzk3STZKeW9iSkJiZ2NMYUtRc0NxaDRjRVBjZnNL?=
 =?utf-8?B?aGlUa1lKa0dDaFVGdjZ3Rk9aQ3VwdmI4M2xaMUN1QVZkYnU0SXRNbFdBWUtM?=
 =?utf-8?B?TkxvaUZBTnNhOGxLeE9IT09uNUNMOWlGdkFqczl2MkZ3WTk3b2JscTR5eC9w?=
 =?utf-8?B?L1d5SmE5ZGNVK29tRUZVU05OWWhwMGNxOFdOU0hTdnFIUWRtNmJiNG5pMW1L?=
 =?utf-8?B?cllHYm54ZE5Nb2ZtOHZNNHVJanlyMHVJdmk3UkxVSkVrQStwS3h2ZVlxditw?=
 =?utf-8?B?aXE1NkJHT25ETFNMak5zc0JJTWRHeEp2bFFFVnBIR0JlS01uWWYvQ0FNWG1m?=
 =?utf-8?B?TDJieEFLendqSmc3ZDY3b2dRRFFOTzdmdjAxNkNRU3k5MnFxOW9velkxR2to?=
 =?utf-8?B?bE8yY3h6SFdjVkcvOGxVdm5nVGs5TjFHdERtY3hpNGJaNTJySUxKR3Y5bW9u?=
 =?utf-8?B?U0J4Z0xYNUoraFlsbFhYODJZYmxSSFhvWmFweWtzSWZEQUxOMFJiUlcrQTg0?=
 =?utf-8?B?SFVWelUzK1RERFEvZzNxVTlDM2lXZ1dyeE5zRmlyWGxPNjBBWDVHYkwvU1Ni?=
 =?utf-8?B?c2tWYWpubWNMNEFWT3hZSlRzb0hZOS8vNXhjc1JZZlpVeWhHd1lXYUQ4aGJy?=
 =?utf-8?B?YzBuZ1NuSGtHU1JBenNPUG5vZjM1ZWdHVjBXSkMyb1FudkR6WGtTN2hVS0di?=
 =?utf-8?B?aVkrU1M1MHQxb3U0UlovRTJaSnpESGhxcVk3NnJkTFRSRlNESVlxMW84aURs?=
 =?utf-8?Q?wHh0A6t5dzqWDq+UCL8fEUJfe3FcD5BlpwpHOGP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98579571-bd20-4dfa-6e65-08d9551dfcd4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2021 18:55:53.5967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: layx0shb+ExOkJhaXTaoT6KdRcK+BmIUDqlCWRAtK4f7aKesQSpBfdKrdCPUZq/tsdh7AoSSdaxwuZJEFAQCvfrz/EmjkyRv6qFL8dlKcM4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3014
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10062 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108010135
X-Proofpoint-GUID: Oby35t1AQWYQkZ4NbTCdJuFXPzNsmGDD
X-Proofpoint-ORIG-GUID: Oby35t1AQWYQkZ4NbTCdJuFXPzNsmGDD
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 7/28/21 6:53 AM, David Disseldorp wrote:
> While looking into XCOPY sense propagation issues (see Sergey's
> patchset), I came across some se_cmd members which are unneeded. This
> series also carries a fix for a theoretical lun_tg_pt_gp race condition.
> 
> Cheers, David
> 
> 
>  drivers/target/sbp/sbp_target.c        |  4 +-
>  drivers/target/target_core_alua.c      | 94 ++++++++++----------------
>  drivers/target/target_core_transport.c | 33 ++++++---
>  include/target/target_core_base.h      |  8 ++-
>  4 files changed, 66 insertions(+), 73 deletions(-)
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>
