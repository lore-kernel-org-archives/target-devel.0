Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D88C4332F
	for <target-devel@archiver.kernel.org>; Fri, 11 Nov 2022 21:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbiKKVT0 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 11 Nov 2022 16:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbiKKVTZ (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 11 Nov 2022 16:19:25 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A51F5BD5B
        for <target-devel@vger.kernel.org>; Fri, 11 Nov 2022 13:19:24 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABLEIQg011150;
        Fri, 11 Nov 2022 21:19:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=1up1SF8b0afFDYM3oRsmN6MeXVP0RRcnEq2iebTyFp0=;
 b=0udqsWW7E8aBYmB+2ijWkGBfZE2zRx5TpkBpT85bZxAHXVBmdFCW9SoGAy7jZ2RAOi5h
 AWvI9Ny+kJPcOZ9KFVjeKhT0NLv1Vy6yBD+h+7SuL9mTqhNny32dupDstakN+9XKXbr5
 N5XmrRK3uZ8vhpR0CGJDXkxBtwJd7GFff7/OWUo/pQKhRWJYsJt5d80UCoTqby8cpkZj
 nfXv+PUNgunQeScZfTnWx0eoTM0e1cqtTEnOUk5lhypGAfwRquQWuNf4sKruIVfR1zAl
 RSjU3ncFc8//Xc5fpw3XmY1mo4SuKhLB807b2NRBd1wmm4y9WEiLzTRxgElt+UojkndQ CA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ksx4qg0ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 21:19:22 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABL0GD2009088;
        Fri, 11 Nov 2022 21:19:21 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqmxks9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 21:19:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G2/+OSdQxKy7Mt64/EujOdQKkC711zdw3urZW7/Q8EQJp42S9NFfbz98E0ZIOXp1YiWgPydFhZntOrNBD1lq+Y1lJeW0B6uzvisY9AQtFpNABu73w0J1UfqxyvFkVIuQ1bXb3ayVX51GmicmWvWIGg+S/Ytpgu7vkbjRWQuuVZEwbypuNKk0N+l8wuK6Nv1NkCq5E9aT+xeMwKrXB3UPCb30YN9eVBI5D8goPdqQ3FsyRI2P3LJfLHtiPLrXrzzMTwWTTgdweSFB0qXyEBnsBcTh2eYLx5gXIR2gi8RemRsnqYW9cRtVD/xQzkjI9VbR9EODpCwwjUxznqlZGgo+cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1up1SF8b0afFDYM3oRsmN6MeXVP0RRcnEq2iebTyFp0=;
 b=n9upozkiRZzroiktyVih/Q2V1ALLfmvLrHFYfmmBHXHC9hgiBbOI9n+Zl2gIae2NehkgmvxIti804bd6C8mDyWwwEB6u2v2bzRtZRpHEWAqpVahdJsp0W1hl5jhHWPUylGrH/b8mCNxNtnWEQfmUxp6A9Xj4KrWKJ8YP+JbxD/vxG7sO+pu9gFqcMq2Mf5VfTR/9vyyTQEZpp06+FZnunc5UyeaCoM8G0JbFkSgjy96Gtgulx7lZQY3zRlKa3G5lBg0UryldrRkn95Hh2AmSjx7wzbQNHIgNCRic5ucF9HT4W2LK2kZbc3xDMhWW9Fp+ig0DL8JSrpeiaeCVCzzOTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1up1SF8b0afFDYM3oRsmN6MeXVP0RRcnEq2iebTyFp0=;
 b=yJBna0V+9vJiyj1h6oOmRE31++JEvDFNS/p7tFZr47U04FJyXrdQQfAqpWc8AICxGrmczDBU5DwPBXB2lZYHIqY1EllCL/bmvUIOHHTSfjkpy9coGtxLji8tZnnIhycC2ffV0mSe8UYx8xxriODUrO9+feRyLz0OiWitfnFCk5c=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH2PR10MB4213.namprd10.prod.outlook.com (2603:10b6:610:7f::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.14; Fri, 11 Nov 2022 21:19:19 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 21:19:19 +0000
Message-ID: <caad6a7a-c30c-a3ac-7932-f5a19c877ffc@oracle.com>
Date:   Fri, 11 Nov 2022 15:18:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: tcm_loop and aborted TMRs
To:     Maurizio Lombardi <mlombard@redhat.com>,
        Bodo Stroesser <bostroesser@gmail.com>
Cc:     target-devel@vger.kernel.org
References: <CAFL455kjQeqvPqd1CUqs7f6xUjrrDqR1h7edizusAtj130HCPg@mail.gmail.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <CAFL455kjQeqvPqd1CUqs7f6xUjrrDqR1h7edizusAtj130HCPg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0270.namprd03.prod.outlook.com
 (2603:10b6:610:e5::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH2PR10MB4213:EE_
X-MS-Office365-Filtering-Correlation-Id: 49667c9a-950e-49c3-d041-08dac42a582c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B3M448n4yhqqYBgJ7vcZ2ZolV+7xPf/SUzLwm/HPY6qO3CJw+fEk98AYj0xx3KepGicu+NWrK/pKbaq6vAFK2pM8qkKS6iZ1MXcrIx17p853ZLXk2lX6UldWk2Ume+0uHaYuO0J+xOdh//TGDMXsKcqtqjdvRtdFePoubwuvjCi0yicV3XBCPRkFpyG0RoZimRxmq7ynNoDoGCqmkVC6E5RJb3iPGx4ziJGZbrE5xploz13X+d9Q/BkOdLmJEgyXEwVNnuU5R/dIP02EHCWtlNc4l5ldU3rywzDGuN4HsdQW8cHT1AnY/ts8jxLwFPbRykt39q4NBZMiOycaGPzaTCgmQ2cNa9PmT4n/zF9PNGVbLlxevVMiSm31zDocITYmj7fJnxrbafLUPFyTDd2khY3HwQ0/ryjTDDGVCU2Qm971gkoPe7R19sHUM1gPRoEmy+tLXV58ZF5cbv1hlq300jz9CSZGxy4D5q9OCPIvy9ztPtZEWkP2HkNxqZxedB5i+TSpdPZD62eNW91YVdi/zMWLYPIDZfd6BcK29zx54x9tOLUM6jlObspfMxXteyzbsDMm/fT0FptFJPFAIc+Ne7MqqnmDhOgTX2mUIN7SVVxbHRo5qNKG+2RW49+DjLDXYjc1cbloZ3fI38Uiu13nJaYlpXvgMVpEnWX3V2nHi9pSXXDr67xnOPzAVUGi5sNGRr2NoRBdMRfNJTMom3DXd2YIGN3WnlqlKTFm99rgnb4Yk1JVmqeiM3/Zw35MZ3zCSX16nZFXFANotmEL5wtMgU18iYzocwJ4PMvQT+LtzSY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(39860400002)(366004)(451199015)(83380400001)(31696002)(86362001)(38100700002)(2906002)(41300700001)(4326008)(8676002)(8936002)(5660300002)(6512007)(6666004)(6506007)(26005)(53546011)(2616005)(186003)(66946007)(66556008)(316002)(66476007)(478600001)(6486002)(110136005)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3RkT2l5b2pzM0RwYjdTc3JuK0UxRm9CSnBzam93ZDAvV2tqSVFaUFU5dHNU?=
 =?utf-8?B?REljQVhyK1BIc2NxTFZKVCsvSWYvTi9ucWlBSzhLYkc3UHJWWFpvTTBFQ0t3?=
 =?utf-8?B?cFllclJnY1FWcld5RUZyZ2UybWUwTk1yV3VzLzdiVmwwTWpNN0NSUmpLZ210?=
 =?utf-8?B?Tk8zem9SN2h2MTdnYTZyTXhTdEVER252d1NTZVNMSFhiSmlMYVpqRnRFcDE5?=
 =?utf-8?B?VHZEaW5FRHdXa3d5WWtzYWQySXNhVk5JTVZoeWt6cGNQTFpFdE8xV0VjMmla?=
 =?utf-8?B?QW01emxGQndkQmowbUpZd2NhN1dxdDNOTFlSVDlvL2N2S05scHlYT2FQYS8v?=
 =?utf-8?B?L2RFSUQxOTgvd3JObG5mblAxb1ZYUnYwVGY1TGE0SnZIWE5WeE1lMGlMaEU0?=
 =?utf-8?B?RS9KN1VtNHlmOFdnMGZRanNzdjJLcnBnZFQ0bGR2WjNLNmlwYmRRUXNlUUsv?=
 =?utf-8?B?dk90dDgyYXRFRHVZZHV3c2NyNjdFRjZncnBXWXphcm9WWlRTczhGSTkreTJB?=
 =?utf-8?B?eW1NSUExT01Ucnk5S1NST3FaK0E2ZTRSTTRYWHA1aG5KV2lLNnFnenhtcFBs?=
 =?utf-8?B?bjY5UEJUVlJIckQxM29JSnJ5OWFTeVYzU2hwYnEwelMxbTkrbmorekd1K0FG?=
 =?utf-8?B?c2dqcEZIdUhSVmlQeUFpL0lFT21RSjUvV0NrbVFFZ0x2REx4SXl5STY0YWpr?=
 =?utf-8?B?dTNoTnZ2YlFia1BYZm9tTWdjSXBFQjhqWFRrSmtCd3Qvd25vS2Jrc2RKYk13?=
 =?utf-8?B?VzI4dURmeDdnVXRPT3NxYTZuQVFuUC9IakgxbUg0cWhzbVpoZzJCTmtmcmVs?=
 =?utf-8?B?ZUVMUEhGZ0ZRMEd0aHc4WStNUlJDYTVNdW1MQTQzcVdkdlFWWUJTeWZnZzkv?=
 =?utf-8?B?V2F6bFdlV0NxSU1vUnU5NjJLRnBkWk5VVWFkNDIrY0RtSytaMmJldnVFL1lk?=
 =?utf-8?B?Y1BWb2orU1NVN0VKUHRGTjdzZkk1WXg0d1NoekVFVnNlc2tCZkxURUdWVmhw?=
 =?utf-8?B?akVJeW9SMS9KUktGdVBZTm5IMzQycElxdWpXcUJxRXF4Z3FFRTNXUVI1djJy?=
 =?utf-8?B?cC9YNC9IMGJFWS8rTDJUWGNsNkMyNmpNTExLSW1TM1ZjUWRDTVA0Y09NczNu?=
 =?utf-8?B?ODdLb0F4dndqTGlZa0ZwYjRuN0JpY3hmTzVYd0FWNlhzOVF6dDU0ZW9LTW9E?=
 =?utf-8?B?UzVIVUZQanpncXFuc1c5dnUwYWgyaHJTM250L0ZrRnczY01CUlowVk5iVzRN?=
 =?utf-8?B?TG1UY0FNVG91SVgrUzJUVFJTSndXK0pCemFmVTk2eERrd3FDcDFQLzNyY2dy?=
 =?utf-8?B?Y0R5VFh3SFBFbGRjQWp4U3Q3ZStLZ0R5VlcxWG1MRjI4dnJkV3dRdlhiVnJP?=
 =?utf-8?B?dmpVT3BKZDM1d2VnL3NxMnRGK3h1bUI3R3ZIYlkrN3dab2dPUU9VWUMvK1Nu?=
 =?utf-8?B?QUl5aTVwTkhGT28rWDY3QlNNbUpJRkZmaFh5ZUM4dFovT2UrSmxyNHBaK29W?=
 =?utf-8?B?QzFoRks4SmxiaTB3VUt5d2lOWXhjaFNVUllLSkxWWTVZbG9XZUV6ait4dW0r?=
 =?utf-8?B?bUtsWUx3T3ZVL3VkTkpoOE9WVWZoWTRPNERMeXJYSUMrcXYvd0xhUnNJZ3VC?=
 =?utf-8?B?Vjd2bDZHL0Q0blRGV1ZuVmt1SVdrc1ZIdWZja0p2STlwRXRZNjlZSWlHcFZX?=
 =?utf-8?B?V241QUJ1UEVHWjlrTWVSTGZXc3E0VDBZY2U1V3hEV1FQcnFvLzdjdk9wZ1FJ?=
 =?utf-8?B?SFduRngyNmNLOW1lazRtdFgzVkE3TmcwdVRBWklUdGNlUUo1ajErd3puMk1W?=
 =?utf-8?B?S3JzaG12QlUvK1JKZHZEc2xxbWE5akhxQnU1L0g3bXRJb28vYUQ2ekZSTjZU?=
 =?utf-8?B?Vkw2TEdFM29qZWdvaU9FaHRYYlUvcEt3VmJNNmd2cHQydHNZN2JPdndTSzhl?=
 =?utf-8?B?WFplSXhnT0x0akZ6Ujc3L0twWFdDODV1eTBkaXVHM2RIUm5xZmQzNnpEUUtU?=
 =?utf-8?B?NnhwYUNXdDhUdUNQSm5HSlZPQ2gzZERsKzhFcGg0RjBmSE54aEJveXg2ODFq?=
 =?utf-8?B?SG9sUnEzOFhUWWlXdHNWZW9yOTlUVE05aGUvQjVORWVuQk5Fd29ZYmRubjYx?=
 =?utf-8?B?ZU0xWU1GTnE4Qk1WOXdKOWJNR1d4QmYxVnNaZy81WmQxTkl2RUYwUXFZaUJ4?=
 =?utf-8?B?a1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: SDeZMsWC5dbk9xClIpP05yaTeWOII4ScoZv+Cx/GCLlVAzdwC4LRuQevFGm2+DuJyfJ/E1nB0W3Ku7RkXGdZJLX291hLNvLKjSMJddThiA6eKCK3H/M40dfLmXAnhMXYKCAnA82X6DhsbAzgbBzYOjhLKUk0odHWtvST/A52aznYpztBAC49pbPf/QyoainHobHevRaYENmCL8OAKwV04o2+pJUdh/Xi5Pk5ZWVCMzBBxIR4zS5jJ8uNgs+CAmANN1g5ifFbTrXvqKhtS4a4cxEJSbp/epriQIPhMey+YbMej6K5ZyeQt7EKTjvNuzzvfkGMeljm9I8QFSO/KrIMz95UP+esgXHBQo6mDZmFMvH1HXbpycSlBzWdCYww9VO/OrFa49jaM+UM6jZDfC0gEZ//ecfK+/ZmnqDOqDsxe9QT7C+JXMpxCSF6mZ5/BHPnuRx5HhxTMfqyMev0TKomKQ3+JRSPQVavkcyJEjXOgoLQOvABEU2/uqAj74kTTdMkK10mUoC3suOqmTMROwjcrnfGe9Kv1vAMD8I1KjDJJHbFTHfi4zPp9CpO2Q7T4Hp7sa7D/56wUGJsHGhWCGcanNAb4Dn4Ksc9e5w1Y1BjVuxLFJZcL/+36GzpcgSBnyMOATKX3tfQS7RxBovDH52Ck2zyRE3Kzv6rmnzrjTvcOkiDQ6b86C7ahZcCLqcs3mbHI1iFqqzS3bDayzHiQ7lxtSR5fT9YG8P76EdniTcVaMvFQJbclOOtLSVVunm6yJUZKwIYIh2HRGm9RSSJGjBMzyOsLllcXaOep7nV+VziHOqgzZeklC4OJ69ITBRO18LS
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49667c9a-950e-49c3-d041-08dac42a582c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 21:19:19.4893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ocFxFW1gAFUZSgLsPKDp9e2Sf5hU8e84cQtrk9enPYwVecdRSpA6I63nGGCWX+cwIv/itMHjD5FszfHoUEVyTSsWxKTDlDKW6EdW3IrxB0o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_11,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211110144
X-Proofpoint-GUID: ZZT14A9f2sKahdQfnKdoNJD8FyE8ljKz
X-Proofpoint-ORIG-GUID: ZZT14A9f2sKahdQfnKdoNJD8FyE8ljKz
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 11/11/22 10:20 AM, Maurizio Lombardi wrote:
> Hello Bodo, Mike,
> 
> Some of our customers reported that the tcm_loop module is unable
> to handle aborted TMRs, resulting in kernel hangs.
> 
> I noticed that Bodo submitted a patch some time ago (our customers
> confirm it works),
> Mike instead proposed to revert
> commit db5b21a24e01d354  "scsi: target/core: Use system workqueues for TMF".
> 
> The discussion unfortunately died out without reaching a conclusion.
> 
> Personally, I think that if the handling of aborted TMRs was working
> before the "Use system workqueues" commit then this should be
> considered as a regression and the commit should be reverted.
> 

I'm fine with reverting it because multiple drivers are affected. I had
talked to Bart offlist back then and he was also ok since we couldn't
fix up the drivers.

I think Bodo and I tried to convert qla, but it was difficult without
marvell's help (we both pinged them but didn't hear back) because from
what I could tell we needed to send some hw/fw commands to perform cleanup
to fully handle that case.
