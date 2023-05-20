Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CE71C77B7D
	for <target-devel@archiver.kernel.org>; Sat, 20 May 2023 17:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjETR4i (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Sat, 20 May 2023 13:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjETR4i (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Sat, 20 May 2023 13:56:38 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C487AFE
        for <target-devel@vger.kernel.org>; Sat, 20 May 2023 10:56:36 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34KHtkcT013159;
        Sat, 20 May 2023 17:56:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=D4wB70+BSmRv/bO9vCETc3a5CCKnrwl69i3s6B8IyM0=;
 b=jtmSOlJ0GgF4Eks+Oi7ztPuaF5iMEHOzgI6zkbSzP369KYMzc//tDzCTXJLruyh4AGpI
 lIbhQFbtK7qsVLy5qLVkqBJFBqTg/9SQL4gPCIpANt0EGVXXUk99wcToeARhbCuA5JT2
 I0UNiXubH2Jp6ouAbC9pXXpEhUl+aL7onQ41mrRg4inrVfy/ddtl2qciqatDVyjsVSYh
 FuyggAKEJFVk5gu9s0hkeCE4QYufSBnjQ/vyQIM/qIZ/+f7aj97g3R+TKkHX97VUS3/G
 q7pphErFCL5X4ehDzVSxobf4cG4VYoJmUttkHwMe4E/7rlQdR3zwlJ11MQCXvETgVMK7 Fw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp7yrj3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 May 2023 17:56:35 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34KG2S26001363;
        Sat, 20 May 2023 17:56:34 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qpmn1g07e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 May 2023 17:56:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lpv1DoDSf7Pl0atYpxocnFm2T8mdnxvwsbwT+TulPzCUkiYSooB3PkyJekm2jHyXKQ5wjy0CuR6Fgl0koHcZ+nEHZ3JQtCpdKKdVt0RZWVj0ObPDCA8VV2rbfXVWzNvQxWdtqKOrozrFpqeaMTRNQFfSPmwxNghfi9xllNc3N2FLhLOyMctM6ZJSg48P9j9OD4YCogi7V/oP3npQwnPzLXhDV2hjL71BbWXemAs7iJKh2OLJkU81ay+knEUMHhRn3x7U+kGf8Yn9/ZIf1sDOq48TXG1zZvY8DX7Q666xdVLHpsWkSiPe+tonLnQiBfR2cUnn9Bjghv7wWxOi8oOC9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D4wB70+BSmRv/bO9vCETc3a5CCKnrwl69i3s6B8IyM0=;
 b=aJ+jt5DJs4RP5QqxNNSDkavkt3n0OpLBVHD7Uu4dBvEk0r5dkN5BN07jqhu6vqQpamj/NCs0Mwg4OAxVTsoKATviN0B6wblxMVuE+uM2L5RyTkHRY1lcm66a2gMe82euThi/G4tkaEasv8uapqjg95KdRnBNYCTbXOpL0Wm2kzn575JEkROwXrO8julg1PE6wxyqnzCdGovWhxiSUFO+w/ZRQ2grEsuSdO9HB2wC17xmUOpeZx78kHlGTPRFnHAKGry2ilnoDC96tMzm2gIThNzHGQyiJpxDDsIv7EGenV4AU4r3lF+Lf59Fe8LzPHmMJjq4LvVTfUsk9H/ujXjSFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4wB70+BSmRv/bO9vCETc3a5CCKnrwl69i3s6B8IyM0=;
 b=UPrwjnNEjnlG+Fi1KwhOKDzPflx36fFhymGI22fQITJ7qNE1A4rxG4OzgQOhgTlmU5daHC8Kk+YVzO9dSrgbe+x3vLbcfzof+sYUFOMm3VAHihuW3KtjpJ/6df0HuFbFjV8CJn4E9z9Sx6JEK+C+jj3OVQKnt01mlIdskfsA8k8=
Received: from IA0PR10MB7255.namprd10.prod.outlook.com (2603:10b6:208:40c::10)
 by DM4PR10MB6088.namprd10.prod.outlook.com (2603:10b6:8:8a::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.19; Sat, 20 May 2023 17:56:32 +0000
Received: from IA0PR10MB7255.namprd10.prod.outlook.com
 ([fe80::6f12:fcdf:da87:2bfe]) by IA0PR10MB7255.namprd10.prod.outlook.com
 ([fe80::6f12:fcdf:da87:2bfe%7]) with mapi id 15.20.6411.025; Sat, 20 May 2023
 17:56:31 +0000
Message-ID: <3b0540bc-28f8-70d2-d6e5-755f15005cb8@oracle.com>
Date:   Sat, 20 May 2023 12:56:29 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: SCSI target logs
Content-Language: en-US
To:     Konstantin Shelekhin <k.shelekhin@yadro.com>,
        target-devel@vger.kernel.org
References: <ZF0MiCRW8HWm8YYj@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <ZF0MiCRW8HWm8YYj@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:5:3b8::14) To IA0PR10MB7255.namprd10.prod.outlook.com
 (2603:10b6:208:40c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR10MB7255:EE_|DM4PR10MB6088:EE_
X-MS-Office365-Filtering-Correlation-Id: d82d2a8d-e19b-4d77-d4c9-08db595b8b0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V4TjvKRQttKzc5GX3qwCrBojS49fHO34TelwQ/rAhVacREwo8xgXa0Sc1mIOlQNA7f2jIW5PomRvcvBSByk0TxnqmPWir7eCSreJFgeQeQk3+secspZrg908WYRTbyBD6YIwF5S6vvX5xmVTHTjErUl1O2+/Bk1m7+33ngUmhzQ/nZFueid8cW28RN1hL6pxT0z2beEF7+hJOLDIZqzHkzmlBUUUV9d9IkbcT7Bhh1+9jqGo6AvEn3uLX6tqW8K7CZgtK/BrOmnsJTxdaOpwLtyM6Z0y49kaoUJAwg6o7Jox905kZU1hT6FJcr2xDkgc/5TX6vsArX7JqLvqR10HOT02EGVJyNYBl9E41fkGuLhaNXvvtD9UucJbzu71xizW77CTbBTV+aCkGw2WAt1WzhxplZcesAjY6YB26KkXO77ILCsJh4noycTB0BUhdvkr6QegKCtRoGl1EqL1fLzpF/nNzlZz7d+h87VwI2CrMUm4358NIOhYO8qp3w+/3jswHO87WIBxpC211wO5y0t/khMc5Cr+nlNx39OZqneMPanbh2g5ZqZg5D+iSEtF83HEmaIjorViQxmDUbqSLUIzUF9+VqgUVoNsixzlA5ySThsCSIxydMJFqpCOxZbDd38LU7TPn37pAGpy8MBM6F9V7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR10MB7255.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(346002)(136003)(376002)(366004)(451199021)(2906002)(316002)(478600001)(31686004)(7116003)(41300700001)(8676002)(8936002)(6486002)(66946007)(66476007)(66556008)(5660300002)(53546011)(6506007)(26005)(6512007)(38100700002)(186003)(2616005)(83380400001)(3480700007)(36756003)(86362001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bk5lNTl6c3pOV2dPTVFVUS9CbHE2b3N6REJWU0VPQzJqNktGZ1JMdDlnT09i?=
 =?utf-8?B?cCtRU2Frb0l6aTBaNWNTMUFyN28wT1pucW5ralB1elkvWTVxWHRsL1V5dU55?=
 =?utf-8?B?TnBqVVROTkN5dklEakphUW0wcEhrTWJ6UVp3RmdHWjRnejRHbS8yRzlsQUh1?=
 =?utf-8?B?SmVLdFFWZlN0M2UvQlRhTkJpR2hLVmhmQ3B0SVRza083ZHdhekNLeWZGbDBR?=
 =?utf-8?B?c3FBZnJFV0p0VDVMNEhQN1NULzVEdW11enlGMVNndHVXaUoxaUc4clFrL1NR?=
 =?utf-8?B?TXdRLytFdVlWSTlBV3Nadkp3RngvMnZVUmFuNVZXVzhLRVRXZHBuTEM4cXdJ?=
 =?utf-8?B?bVZhT3NnOCsrZFhoS3F3MGJlZFFKQXRpVDFuL0xtTE84WlJmUXNIYkVkVExl?=
 =?utf-8?B?dVBxMXphbjhYZzdFYUFpV3F5TjJBS1d2Q3dIRlRyN0JTWUw4bk9oQ0NMUDM4?=
 =?utf-8?B?T1VpYUpqWTBVZmU5Q01xTFdrYmlMRmFDR2llcFc3ZW9heVhEbzdscU5XNGpP?=
 =?utf-8?B?Q0c2WndmYWhva3l5Y1ZQUVlhd3d1YjFDMzVzVCszVEFJSno1YTZGVUIxMERE?=
 =?utf-8?B?Q1VIRC9kbFdkR2xJbmlNa094TWs0MjhpOHFFZEltOXNxYWZ5ZDVVWWRMaDIz?=
 =?utf-8?B?czlDN1plTVo2YkFFNWM4bS9WUW0zTUdxSjN4RExES2hiUXBMdnBGaU9xL1lm?=
 =?utf-8?B?RmpiYlF6b2Z0SjFmSGFudStXRUlIaWNwRWlkMVh5bFFGK1FwbmVqRGxyZ1pB?=
 =?utf-8?B?c1pQc2hTYnM2a2lvZlZwUzRnYjFnTldoZGgrMDNDbkNZV1JIQWV4RVB1VG9K?=
 =?utf-8?B?eFkyektDTEY0M1J0TE1BZEZGZ0ZpNmI3a1o0M2xqZEFWMzYraGxzUWVHVzE2?=
 =?utf-8?B?WnRNSU9xallxQVRwQTBqemVrQ1VpSWhJNDVPc1NSNHc1NVNScXN1VFlBWnBZ?=
 =?utf-8?B?ZmtjNDc5cmpENEVmR0FzOWN2dktRdElqODFRbkZicDV2MzJObmtKWE5PUkNt?=
 =?utf-8?B?TWhtTTBITjlLRTVXTDVFRlZpaVlYV0w1UjZwNklPd2tMeC9OOHhzODI4Rlh0?=
 =?utf-8?B?N0hpZ1pNWkRJZTZkU2NRTE5veUgzM0pYTExVZmN5MGhFdVoxV2VFZGJtcUZJ?=
 =?utf-8?B?S1pseE5aMkM4Qm82T0lLU29wZkEycE9QUzlrWFNpQWxMdFV4S3NJMmM0K1hO?=
 =?utf-8?B?bVd6ZmdCdnlCWUdReElEZzJhdGFSQlI4L1JqcHpZYWR4VGIyOE8wdUNEL0JH?=
 =?utf-8?B?QU96NjRwQURvQkljQXBwd0pOeDVlejc1bk41UmZuZTFmL0VYdHlCK3VKbytz?=
 =?utf-8?B?SnRDdU5HRUVOaXR2MTMxMWhoSGNtOGJPTzJvWWV4UU9BaXE1d1BneHJCaUV3?=
 =?utf-8?B?bk1pZFZtT0tIbzNSYjhwMldRSE5Ha3VCQVZIR0NHSVBOQ1h5RUcvc09FRFY1?=
 =?utf-8?B?WC9jSjVlbGdZM1lPbXk2UFlyM3IyZ3p2UGg5U2N1Z0lsVXBGQVIwdEdjakh2?=
 =?utf-8?B?U1k4T1BZNkFZMSs3UTd0L2xrSkRZY2ZHYk50aDdWUmFTUFFQVWZXL1kzaGg1?=
 =?utf-8?B?LzVQTU5yZUZnM1BtNkhIQ01oR1JwSVpWRjVNWkR2MzlZMjlsVUc3TlVndGpH?=
 =?utf-8?B?dFpUWTB0ZWJnQXhLME1BYmVKNng1TVdxS3lmNHFwQ2xHMnczekVLQ0NDYloy?=
 =?utf-8?B?YnM1TVcwdkxBTHZXMWFDUkVMVmdwMm8wemUyTWxkYzZUb08rSVk4M3lNWDlk?=
 =?utf-8?B?SkhqQW80L3hIb3h2NjVOekR6SG4zdXJHZ1Nrd3lMRjhnM2ZJaHRTMjh4cWFW?=
 =?utf-8?B?VThzLzQzSFB1T3BrVEhPZ1lSSWZSUVdXbEovMmM0RCtUd0JlUVZDMFJoUFJw?=
 =?utf-8?B?ZVNrUGw1QktQNTdjckpHYkhsTjQvRGc0VmkyK25jdTJLR1B5dHdmK28vUTVw?=
 =?utf-8?B?bi80TVNMbTk1Tkd2cG03WXo0OUF2cGRINjNyd3Z2N3l3RTdnQzlRQUVpcUh5?=
 =?utf-8?B?c2xWVE45Y0tVKzlqTW5GMzZyQjlmZExhbDZWYkV0b0lSd2N1Z05wWmlHcXhI?=
 =?utf-8?B?ajdZaEpWRTNZeDBEY0JwWUx1c3pnU1A0TmJzK3NlbXkzOWx2d1lMYlBrYUd1?=
 =?utf-8?B?T3B4ckFIWmhwOS9qNG1oMmt2UGJteFhIeEVza2dxSDM1VmZxcjFueEVjUnZ6?=
 =?utf-8?B?WGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: OS6mO5OetQbNUiLNTfdhGT3fTVlAGyMjn8HtnAZ4czlmvxfqJ+4AubNF34LaOWDJLZCOjKNPRjaszjA3EfBjN9RrZGaQPIolc4Qn6xm6nDdHSqV1aH+U7jge2d+T3Lv3hBwpC4c+ourDEcxGbUW7KsVYBROGnhG4ig4WHhACeeNDD+zY8g/dxiR0GdLZUOgSl+5k8Tdd+zjRe4I/887ocOeb0nnOGEy+kIAOxY2yEReKyfocnAo7jVm2Dvj2TOBsN0r1fe95uqCLCk1W7662QD4rIkS6gYiOObY9bpc2t4VswadS9eeD85FFSyRn3Kwc66jg+SeeHF7LQ2FwLdidBSqzJvO7GZbLZ0RTZJVwgKzZpDynEA+9CfmpOkP1Qrz4qCK6hBHu2V4241v93CfpBaDTuGMrhQWFZti99Dv5FjaTTfsYPevFxvt0HNPlFsmFB0w19PrchcjkigJzI0tfJEVmbgtkZrVJafpxwcpX9sSb92u2sMB8sqoQ136BXJ6RcfmTKl/LqhfVILlKYaxmMbl6kjnT4RHiLSnGzGSh7wMk0sunoNFZWluht68sub8SFNaf1A4sHMurwsTrhL/J8BlkXLYJoQz2QSsKOWvn1sb8+7iEqeZm3ynlEi+a5sWx62cMfsDhhqulTRcDvbGTbUlwgrlqLSctlpPdIpH7TsK8Fs32Qc9ZKSUPAcjGV2fOOnUuGklEar1EmEP3n70y8q3k6cluqX7jlV5Rgz+MgqOENx1kkiTyAxVvrLRXRu1Ct5yAk34ttHWiaeek15ap+f0bBOpu2RkBgdYoOYDJtW4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d82d2a8d-e19b-4d77-d4c9-08db595b8b0b
X-MS-Exchange-CrossTenant-AuthSource: IA0PR10MB7255.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2023 17:56:31.4287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9HGLOs701x3R9mWGb+sR4XaABLHaRtRU6W09Z+IumJclM++rdSgE/ybJbEncEg+IH6Ot8SGVHmM0DQMTYLMb6dJ1cYmVo8CZJi7WFEoeAWA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6088
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-20_10,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305200157
X-Proofpoint-ORIG-GUID: 2qkc2VQ-vAyaOd6lMWwO73wpfj6AMWkK
X-Proofpoint-GUID: 2qkc2VQ-vAyaOd6lMWwO73wpfj6AMWkK
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 5/11/23 10:40 AM, Konstantin Shelekhin wrote:
> Hi,
> 
> For the last couple of days I've been thinking how to improve the target
> logs. My pain points:
> 
>   1. There is no common prefix for the subsystem
>   2. It's kinda hard to determine which I-T-L nexus was affected
> 
> For example:
> 
>   [Thu May 11 00:00:00 2023] Waiting for running cmds to complete.
> 
> Or something even more sinister:
> 
>   [Thu May 11 00:00:00 2023] bio error: 0xfffffffff, err 10
> 
> Only someone familiar with the kernel code can tell that this is
> actually target_core_iblock discovering an I/O error.
> 
> While all of this is not a blocker per se, because a skilled enough
> developer can connect all the dots, such analysis requires a lot of time
> and patience on large systems with hundreds of ACLs and several TPGs.
> 
> Okay, so what the others do? PCI and USB subsystems clearly enjoy having
> a unique ID:
> 
>   [Thu May 11 00:00:00 2023] iwlwifi 0000:00:14.3: WFPM_UMAC_PD_NOTIFICATION: 0x1f
>   [Thu May 11 00:00:00 2023] usb 3-7: reset high-speed USB device number 2 using xhci_hcd
> 
> Quick look at the lspci/lsusb output is all it takes to understand which
> device was affected.
> 
> Network interfaces enjoy having a user-friendly name:
> 
>   [Thu May 11 00:00:00 2023] wlan0: authenticate with cc:2d:e0:10:8d:b9
> 
> Same goes for file systems and block devices.
> 
> NVMe target uses pr_info(), benefiting from having neatly chosen module
> names:
> 
>   [Thu May 11 00:00:00 2023] nvmet: Foo happened (NVMe core)
>   [Thu May 11 00:00:00 2023] nvmet_fc: Bar happened (NVMe over FC)
>   [Thu May 11 00:00:00 2023] nvmet_tcp: Foo happened (NVMe overTCP)
> 
> However, we don't get to known which NVMe Host was affected unless the
> log line already contains the necessary info.
> 
> Back to the target. The simplest solution that at least gives the user
> some context is to put this in each C file:
> 
>   #define pr_fmt(fmt) KBUILD_MODENAME  ": " fmt
> 
> But since target modules all named differently, one can't just
> 
>   $ dmesg | grep target_
> 
> like with NVMe target. You'll have to do this:
> 
>   $ dmesg | grep -E '_target_|tcm_|isert|cxgbit'
> 
> That's because we have target_core_mod, isert, cxgbit, iscsi_target_mod,
> tcm_qla2xxx and so on. Yikes, but this is still an improvement. However,
> it does not give us any clue about the affected I-T-L nexus.
> 
> So, my proposal. We should give all modules similar names:
> 
>   tcm
>   tcm_iscsi
>   tcm_iser
>   tcm_qla2xxx
>   tcm_iblock
>   tcm_loop
>   tcm_cxgb

Do you mean you will rename the actual modules, or just have each module
have some define with a name like "tcm_$WHATEVER" that's used in the log
message?

I don't think we can change the actual name because scripts might do

modprobe isert

Unless there's a way to do some sort of automatic/magic alias then it
would be ok.


> 
> I would prefer scsit_ instead of tcm_, but I guess this ship has sailed.
> 
> Next, let's introduce some macros: tcm_LEVEL(), tcm_sess_LEVEL() and


We've been switching new code to the "target_" prefix.


> tcm_lun_LEVEL():
> 
>   tcm_err("This module blew up\n")
>   [Thu May 11 00:00:00 2023] tcm_iser: This module blew up
>                              ^^^^^^^^
>                              |
>                              Module name
> 
>   tcm_sess_err(&se_sess, "Waiting for running cmds to complete.\n")
>   [Thu May 11 00:00:00 2023] tcm_iscsi [iqn.2023-01.com.example:blah-blah -> 10]: Waiting for running cmds to complete.
>                              ^^^^^^^^^  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^    ^^
>                              |          |                                    |
>                              |          |                                    RTPI
>                              |          Initiator port
>                              Module name
> 
>   tcm_lun_err(&se_lun, "bio error %p, err: %d\n", bio, bio_status)
>   [Thu May 11 00:00:00 2023] tcm_iblock [iqn.2023-01.com.example:blah-blah -> 10/5]: bio error: 0xfffffffff, err 10
>                              ^^^^^^^^^^  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^    ^^ ^
>                              |           |                                    |  |
>                              |           |                                    |  MAPPED LUN
>                              |           |                                    RTPI
>                              |           Initiator port
>                              Module name


Nice.



