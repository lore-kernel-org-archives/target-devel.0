Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79416C6FD1F
	for <target-devel@archiver.kernel.org>; Tue, 14 Mar 2023 21:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjCNVXQ (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 14 Mar 2023 17:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjCNVXP (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 14 Mar 2023 17:23:15 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C667F29430
        for <target-devel@vger.kernel.org>; Tue, 14 Mar 2023 14:23:11 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32EKIn1j011621;
        Tue, 14 Mar 2023 21:23:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=RRPLKbIHc4gfdhJ5RrnRwRodGCWYlleljhULyXC/wbw=;
 b=XJ+W/qWkLGLFbpS01/L8P4H+xaB/nqT5/CGgYAh2YBGmyOsZRJ0h82BMcbssxpJZmMrk
 KC1ihFYUqe8y71bBsyCdBgJKRZ/aq3FQIWhJ7mYZLE4z0QYHpWi8463I6dEkB9wbqgrz
 lqX4uwVUHDS6k9nRZvfFvLYjQgiUg225kTVigslG0jpkcFHPm/FwnNbhQL3/kcEiEXcw
 Nqgy83Yra6S9MPZ+QBPxcshD1+O5BhhHfVR0EfjOP2rHAycAkoggumrTrdS0iD6qxS2L
 JEMIezIMzePbqkkBt0RlEH0tXngI8u8ZT1xKW3A53mitS9Skq0Oyd+PYGI2EhUfrLbxP ig== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p8ge2yg73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Mar 2023 21:23:09 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32EL2mWm010624;
        Tue, 14 Mar 2023 21:23:08 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p8g36faqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Mar 2023 21:23:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lIeBHuTnfd3hF8jPwFdTXoOecGsu9K2myxLRKtkJ96rloeSXd2GzFvqkwKVUaSl2b7W+upszw5gye3Y3oieX4Sq/J5gkpi6bFSgFnoLhSOviuAriyUtVxel+FBIwn1zLodV3rWdTNR3ssDlAjppODCc/UtPDayns3a2V6CBFb30KldrNJpIK1lQcIOsKkVVoH/Av6ccuuZsQ3fb6euTedqoBokx6nVtJP+j2yz89btUweFUwuc8QEgRQJJhl0xpXDSRPBcX0z6H9Pa+McjOZyGhlR4FFJHwg2uvqfMvtdqPvqR0cjNtYjei0a5EOKiCdnACMhyXO4I3s8m2DEpU34A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RRPLKbIHc4gfdhJ5RrnRwRodGCWYlleljhULyXC/wbw=;
 b=YJddVtnUv6s8FZbvTcwHVDW1ZIFhtEDtYwPK0kotZQ7HrmNQBinncxygXhRpDwVLSJBTOjwPrFE3DBJCkDSJf7YZBbUQKQceparBxpFE0Xqm+KnzVD1CvX2oUi3uMEiWcNYeRWMNrZRJltTpYa10yhkJOJamQ9II6kf4zHiJcXfrD23Y2JtCRpneOhpdBBkBTGuxVLbJLz1IWtvjEMm16pgo9zlZQiHMkQsR1x+V/5PBby8tgIpcpVi7sfombfFsce0HgoNClcyedqjW3P0upY7CCCFJIloPAnbpka9ubxucG8prUpESW8Hu4KGo28LPhAQF6O1ndLypFwmwrphjnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RRPLKbIHc4gfdhJ5RrnRwRodGCWYlleljhULyXC/wbw=;
 b=c2uHwLYCF0NvSwe6Mjdxc7A9AuZqRjO6fE3CMbr4gvwDh1IrgdFQb2XmmafjyukbyENwmYUTbortPk/ckEGp9okhvvy0Lk/c6aI5ocFo+Cqsk3MTuHKFed2w72qsDYuAh2HH9QjzCmLCEgOpeV8iwSbqYpq13zFU0388AGU1AQ0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB7286.namprd10.prod.outlook.com (2603:10b6:208:3ff::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 21:23:06 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 21:23:06 +0000
Message-ID: <afb25e86-3b1a-3b19-f257-e748d0900005@oracle.com>
Date:   Tue, 14 Mar 2023 16:23:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/3] target: iscsi: fix hang in the iSCSI login code
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     martin.petersen@oracle.com, serapheim.dimitro@delphix.com,
        target-devel@vger.kernel.org
References: <20230310100423.1258256-1-mlombard@redhat.com>
 <20230310100423.1258256-2-mlombard@redhat.com>
 <f492ed26-58fd-0f4d-b1f2-b4cbd2cca233@oracle.com>
 <CAFL455=HQ9-juB5fCqRJYmLK-jH3RuLCQM1Rk6bzG4QA-yWq4Q@mail.gmail.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <CAFL455=HQ9-juB5fCqRJYmLK-jH3RuLCQM1Rk6bzG4QA-yWq4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR07CA0108.namprd07.prod.outlook.com
 (2603:10b6:5:330::14) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA1PR10MB7286:EE_
X-MS-Office365-Filtering-Correlation-Id: f571d2ab-7e21-40aa-c64e-08db24d24d0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vy8fNOOV1tjzVdf7S2YCU7RvEcvCi68ThF4z9o894kqSjcNHGpWmDOzVn0pGMd37nCpFfCkC2l8kFhtRD+0VgVDrRzcgQq1rT4lU1tN8svNo+spvwZQEtXJU4n0nyJKJUW09CuYKzPKLvmblWJ92JpDEYQlVPKbS5MdvcSJiHtdYZIrB40p/YC0Y7jXzA4LSFFtgxNvhkQFMYYH70R1jW9A9ulqr8624N0Swjiu1hOjV//HD5IuSbrwPvK8byugfQw/zyFlabQvwGtwx9IVXFxHCAVtqHgc8aW1yuHbBMN1pmDiCM26Xp5sA3KJLdJ3Mftxi/wPr+AzlbkddMwyOZD/E6GHtpZUFTDffYwIJzp5NFhRF9Cr/YMVUc8Hs/voDsO62xuZcOqqG82bqVVt86UTx42hy3p8NLGSJFbGVmjM9NHQ/xWEaMA3zTQlU9boUWnOi6C659YEpCkpOQ4zwn9v15pm9iz4m5KY/RWx28AzyiMNpeySwNfzHK/pgXN29x99lT/xfnUx9bpDUYNALiIDz3au8QuNp1ErWR5MrLwrbUxkuzwrliJ1R0JW/MH7NOtp89WWMYLwFe9+0Lhg0N1w1CdFYvyomvQe/Aoy31GdlcktoQD8pPRnHaLM3JnkXhV13Eku+bZyhsnd6Hv1dmgQujKBCrkcEx48f+/ZoluFhXiku6R4vR8eNGqsVst5BSTsU2k3SC92jSoSxr7vIVEbpqV2b8HR/G2EzuOKc0NA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(346002)(39860400002)(376002)(136003)(451199018)(31686004)(2906002)(83380400001)(36756003)(5660300002)(66946007)(316002)(6916009)(8936002)(66476007)(41300700001)(66556008)(8676002)(4326008)(38100700002)(31696002)(86362001)(478600001)(66574015)(186003)(53546011)(6512007)(6486002)(26005)(6506007)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZE1vdkwxY1ZQZWgxVVJnMHFJNjFmaHdNVGFYSldWa1NCdG9zcEtraVRPVnhF?=
 =?utf-8?B?VFpRcDgzS1gwSWd6cFZCUUw3NVRjUHdCQTA4ZE1VMUt6L2tBcE1GTjg0ak8z?=
 =?utf-8?B?aXo3bE1BeWt6Q1IzNWREMm1OUmp2ZDZtcWZnVjFaZHhiVkVKZ05Zb0lFTG9q?=
 =?utf-8?B?TmVDZWZwSEFjZzZXSnVqc051NTMvaDMybXpadFpuNGhZK2k3QVU3bmYzV1hl?=
 =?utf-8?B?SE1ya2N2MWlHSVU2d1pEdUQxWmJkeGdUUGFsdXZKR3M2T1FTZVJESXVFMm9o?=
 =?utf-8?B?T1Rkb3FhbVBVWnRVUTdsM3A5RW11cGRBV0VxNm4wVW4wNFpGTytLejlQQSs5?=
 =?utf-8?B?VlBKVjZjLzhwbm1RODRNRkNjMy8rTVlGcjIrNlN4Tkh2aFh1eG5UMTRiNnhW?=
 =?utf-8?B?V2E5eDFJYUVncDVKM3ZGakY5Y0tUYmcvU2JwQWNPOTdNRVViWndkUGpuMHpU?=
 =?utf-8?B?RHdFQlFaeTR2UkpHQnJZK0FvOEN3WDVaVElSbnZhYTYxRDBNREloRnh1MGo5?=
 =?utf-8?B?L21NcFhaSS9ERTl1c0V3Qno0dUZ0WXQ4cXFJdllNNVFBNjlEVGQwUzh2dkxo?=
 =?utf-8?B?Y0FKSFhWKzV0ZkxYMUVSWGRpTG5Jb2lkdG4yNEkxWStTOWJLZ3AyYWcwMi9t?=
 =?utf-8?B?d0FTWFpxSm4vRWVmV1VKemtYSXpNbEdGVHVmckRCQnI0clFxZnJiY2k5Wi8y?=
 =?utf-8?B?RkdrY2NxOUx3U3l2OWdxa3NDcERFWmVqdHRyNndjSFIwNzhRWXhtM0RoaytZ?=
 =?utf-8?B?NnFmemRMUWgyT0hZRGxzbFh6SDFqM0taaWFLMCtDb0lhUnpKQmhwa0NRU0l1?=
 =?utf-8?B?Mlpld0RBWjB0aXIwRm03bnJyeU9PVmc3RU1UWmZUeXZTZDh6NlRFVjVWRXVw?=
 =?utf-8?B?bXdmZTc2eFVJNXFMUDcrRCtUclRsMmZCOXdLNEJETFFJWUsxRmliemNHaHZx?=
 =?utf-8?B?S0hVUFRTUFdqcDhOYzVJMWo4MVNOdC9iaml4YmJNbTI1OThSdEZPRExYS0Js?=
 =?utf-8?B?TlB2MGVjRTVTTDZMVGhtdnVZMDBFR0pEelFKMUFoRkFwdkVmNWFSeFZRcDVQ?=
 =?utf-8?B?WFdWL1FnRWl2bkVSTXJTdDJZSnk2RkFuNTJoMlh1Um1EZ0tJQjUxcEYzZEV6?=
 =?utf-8?B?VWFGWFhUZVd2NytvOWxTVEZUeVZGRUVqb0VxeGw5RHNxOHpLRjFWbytkLzVa?=
 =?utf-8?B?cTV2WFJicE5NV1AwN3R5WXBjcVd0QUhTbytaZVlQbWRZTE11MHNNd2dNOXJn?=
 =?utf-8?B?dEVsWXhWT1pONnZIUlU4MXJTempTdDRoaC8va1pQYWFTU1ZBdWJzVHFWcE1p?=
 =?utf-8?B?ZWIyR05EL3U2TFVEZ1BxRGJCb2xGQ2FsSng2N2dlbm1CUHN5bWc1VXBncXh3?=
 =?utf-8?B?dDVmRVc2OWNTVzNaUVZoTUU2eFpqWXJQc1o0WTEvLzh4UDNNMnIybFVtVmpv?=
 =?utf-8?B?bnJkbW1hbytHWG9KVjI0T3VzamZYcDBEV2VmcG91WVpaNXVWSHhsTkJNZ1lP?=
 =?utf-8?B?UlM1Zm5Ib3VYMXd3ZXQwMHRZVTY3UzArWWZvd0FKRHJQdmRsWmJQWFdnTjN4?=
 =?utf-8?B?RWorS1lWQ2FRNGRIaXh5YWpIbURPakdMaGltOTRBckM4dkw4N0lJMVhrb2ZT?=
 =?utf-8?B?RXdIRHJJUnBqVmE2Y2Ixekt6REZZRDFLSUZ5ekxJWjhjS0dnc2FxTUVvOWNO?=
 =?utf-8?B?U0Y4bnV0NWdUNkwrYlQxcmRNWDJqQWVpQUNuemJLRWJlVmlacE9td0JMNDg1?=
 =?utf-8?B?VGtGZDl6Mk5FejROT1MzelJtWjc4ckpIRGJjYTRhbjdiNGI1MVJ3cjRnU213?=
 =?utf-8?B?UERkWHpETThCZ292eURxcUNsTUxUZzJGeCtqbmMwVVpPQURqNXgydzI4aWNt?=
 =?utf-8?B?aFJCZCtzc2FGNjNZSzJNSzN3SWRycDAxbEpWRmVHMjdoTXhFYUNDamQxUU5Y?=
 =?utf-8?B?Q2kyR1JLU2F6RGxVT21MWkVvYmdnQUt5elJqTlRGdzN1QWhZNVhqdlNYVXJp?=
 =?utf-8?B?OFljRjFvVFRRMHlFU1ZqanZub2h3ZjNVZG0yY1R1K3BTc3psVWYyVEVtWkIv?=
 =?utf-8?B?VzhIZTBZWllZbGQ3YUlJVUROZGRIQzhWeFp4RVZvTmN4SHMxTmZOYmZUOXlp?=
 =?utf-8?B?NGxlazdoMmxGTmRPTW1Bc25RZjZjU0psMUVnTVdwVGhzY0hUVStIckk5STh0?=
 =?utf-8?B?MXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 5RzzjZxFfH+EknlzbyDcwFzKDX/w7CXK5gcd55kxHlg6ShT7HrTJQ52sW3Ae2ubCpmAEXhR5zfkQqb8EswJNxj+u7U1tPmUM7OA30BMGf8nuVBJHzv30NdhOJkYCQAU265sY5Mp6NAbmxIei+5iViI0yHbuOuzs6htrmWHOyJVjU+j4aioSID7Kg7ynGgRIS3kw5GUs9IWUjb8FP6dgi9tFwe3gjySF2rxlMWWsDq2vZAqMRn3KaHagLonD2a0m1iwUi7Qv6Ty54A7+1mkZlA3P+RTqobnZ2deNZu1m8PwRZzTM2nxBWTh/9DtXiVRYl1OxneXM6tgfoDcBDCwBoHaZA2EqZQk4CGC/PUAtf2YcV/+h5k1OEOp9C/d5BvtUGU7hvXfsuxeAoLxJMSSk0K5gd0UlUk4xNOZfMIqC6ZwM3xDExU/dzCUtc0m48dfK+8xh+Bb9BUNO9HuX5qDKZepLTDG4HqGrxGsVKeIvFllA04mW9yQgByzGQaosGyHcJ0G88p5VcrzeHQ3mgLI3+MlgEs9gem0msmlYjFvVZD5lhMFvEegPbTfkGlhtv/2Ox4vF/zMapo2aJvza//mVdQ+Qp8ifs6+gNpMMLjjdx7OirVhTcLZ0IDfmnRhtZ3SjzyFp4BRzzvp1OVFYY9IUJNc2lIgTCLqs5afjPFcz6F0NyDs046Trc05crUhv6wQ7jcKMYA+Al20Yt0wTwcYsP8UiS0TiA0us4oCm1JyOA3/tHbjVEg2XxS30ISoSFW0TmxsJlEwTxgYxXCzLYTDTJUwt/cGa/dB2QajiVl0A3NBUe5W3pF1bcj+KEkTczMx3j
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f571d2ab-7e21-40aa-c64e-08db24d24d0b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 21:23:05.9906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Jbq8Z45k46lFPLYc0+bHP7rc9GjDhhrCvc07zmACim32S4GR5J9DcR4b6q/0TqI3zaAwFmSOovVTxkOJyWN7PVd6+1+9SX/6R2N7E+p+do=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7286
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-14_14,2023-03-14_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303140170
X-Proofpoint-GUID: YYkc8eQ7PkzgTBSr6FnhqpoQsMdtEoEV
X-Proofpoint-ORIG-GUID: YYkc8eQ7PkzgTBSr6FnhqpoQsMdtEoEV
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 3/14/23 6:09 AM, Maurizio Lombardi wrote:
> út 14. 3. 2023 v 0:52 odesílatel Mike Christie
> <michael.christie@oracle.com> napsal:
>>
>>> +     case TCP_CLOSE:
>>> +             pr_debug("__iscsi_target_sk_check_close: socket closing,"
>>>                       "returning TRUE\n");
>>
>> Don't need to break up a string. We do it a lot in the lio code, but we've
>> been trying not to in new code.
>>
>>> +             /*
>>> +              * Restart the login timer to prevent the
>>> +              * login process from getting stuck if the initiator
>>
>> I would fix up the formatting so the first line is longer.
> 
> Ok
> 
>>> @@ -1358,6 +1348,9 @@ int iscsi_target_start_negotiation(
>>>               set_bit(LOGIN_FLAGS_INITIAL_PDU, &conn->login_flags);
>>>               write_unlock_bh(&sk->sk_callback_lock);
>>>       }
>>> +
>>> +     iscsit_start_login_timer(conn);
>>
>> At this time, we have the np->np_login_timer running right?
> 
> Yes.
> 
>>
>> Don't we only need to start this new timer when we know there are
>> more PDUs and the connection is good (iscsi_target_do_login returns
>> 0 and iscsi_target_sk_check_and_clear returns 0)?
> 
> The moment iscsi_target_sk_check_and_clear() clears the
> LOGIN_FLAGS_INITIAL_PDU flag
> and returns 0, the login worker may be already running.
> If we start the timer after the call to
> iscsi_target_sk_check_and_clear(), we could have a race condition:
> 
> 1) login_work runs and reschedules itself non-stop because
> LOGIN_FLAGS_INITIAL_PDU is set
> 2) login kthread calls  iscsi_target_sk_check_and_clear() and clears
> LOGIN_FLAGS_INITIAL_PDU
> 3) login work runs and completes the login
> 4) login kthread starts the timer
> 5) No one stops the timer, it fires and kills the connection despite
> the fact the login was successful.
> 
> I could however replace this code:
>
> ret = iscsi_target_do_login(conn, login);
>  if (!ret && iscsi_target_sk_check_and_clear(conn, LOGIN_FLAGS_INITIAL_PDU))
>            ret = -1;
> 
> with the following, if you like it more:
> 
> ret = iscsi_target_do_login(conn, login);
> if (!ret) {
>       iscsit_start_login_timer(conn);
>       if (iscsi_target_sk_check_and_clear(conn, LOGIN_FLAGS_INITIAL_PDU)) {
>            iscsit_stop_login_timer(conn);
>            ret = -1;
>       }
> }

Ah yeah, I wasn't thinking specifically about this race when I wrote the
above comment. With the combined timer below, I was thinking this is handled
when you set/check the login_kworker thread.

> 
>>
>> I think you can just kill np timer and only use the login_timer for
>> both cases. So I mean set the thread to kill as the login one and start
>> this login_timer in __iscsi_target_login_thread where we used to call
>> iscsi_start_login_thread_timer. You would then mod the timer when we
>> transition from iscsi_target_start_negotiation to waiting for the next
>> PDU.
>>
> 
> Yes, maybe, but I would need to find a way to detect if conn->login_kworker
> is pointing to the login thread or to the login_work's thread, because
> the np_login_timer is supposed to clear the ISCSI_TF_RUNNING flag.
> 
> maybe something like this:
> 
> if (conn->login_kworker == conn->tpg_np->tpg_np->np_thread) {
>      spin_lock_bh(&np->np_thread_lock);
>      if (!(np->np_login_timer_flags & ISCSI_TF_STOP))
>            np->np_login_timer_flags &= ~ISCSI_TF_RUNNING;
>      spin_unlock_bh(&np->np_thread_lock);
> }

We don't need any of the np_login_timer_flags code if we are using your per
conn login_timer do we?

For the new timer:
- We are adding one per conn timer.
- We use that for both the initial pdu and later ones.
- The timeout function, sends a signal if there is a thread set or does whatever
we figure out below for the case where there is no thread (we don't do any
np_login_timer_flags stuff).
- We probably don't need to do both the signal and whatever we decide below.
Or, we need to check some of the LOGIN_FLAGS since for example we don't
need to queue the login_work and set LOGIN_FLAGS_CLOSED if LOGIN_FLAGS_INITIAL_PDU
is set.
- The iscsi_start_login_timer function handles setting the login_kworker thread.

So we do:
1. Replace iscsi_start_login_thread_timer/iscsi_stop_login_thread_timer with
iscsit_start_login_timer/iscsit_stop_login_timer

__iscsi_target_login_thread only calls iscsit_stop_login_timer on failure.
On success it will either timeout waiting for the next PDU or
iscsi_target_do_login_rx will called and reset the timer.

2. You also have a iscsit_mod_login_timer depending on how you want to handle
the race you described above.
3. iscsi_target_start_negotiation only mods the timer if iscsi_target_do_login/
iscsi_target_sk_check_and_clear is successful and if iscsi_target_do_login_rx
has not already run.

For the latter, in iscsi_start/mod_login_timer you could add a check like your
np_thread above where if the login_work has already reset login_kworker then
we just return. Or we can add a new LOGIN_FLAGS flag, or add a bool arg to
iscsi_start/mod_login_timer where if set to true and if the login_kworker thread
does not equal current, then you know iscsi_target_do_login_rx already took over
the timer and do nothing.

4. You call iscsit_start_login_timer/iscsit_stop_login_timer like you are in
iscsi_target_do_login_rx.

> 
>> For isert and cxgbit we won't have conn->sock set so I think you need some
>> sort of callout for those drivers, or maybe set LOGIN_FLAGS_CLOSED and queue
>> the login_work. Maybe the latter will work for all drivers as well. You probably
>> need some extra locking and LOGIN_FLAGS checks to handle an issue similar to
>> below.
> 
> Hmm, that would need to be tested, because LOGIN_FLAGS_CLOSED is supposed> to be set when the socket is already in the process of getting closed
> (it's state is TCP_CLOSE_WAIT or TCP_FIN_WAIT* or whatever)
> So If I set LOGIN_FLAGS_CLOSED in the timer and the socket is
> TCP_ESTABLISHED it means that I am trying to
> do the opposite, will the socket be properly closed
> by isert/cxgbit in this case?

I'm open to suggestions. I don't really care how we fix it, but it should
work for all the drivers.

If we go the login_work route, ignore LOGIN_FLAGS_CLOSED for a second. I'm
just talking about the code path we use for error handling in this type of
case. We can easily just add a new bit.

- For iscsit tcp, if we are reading in data in iscsit_get_login_rx, and the
timer fires and we get a signal, iscsit_get_login_rx will return a failure
and we do the goto err path. So in this case we, the connection is not closed
and we go through iscsi_target_login_drop, so we know it works.

isert/cxgbit doesn't use sockets. We don't hit any of the LOGIN_FLAGS or
sk_state checks for them. The tcp connection might or might not be closed
for both drivers when the timer fires.

- For cxgbit, we can be waiting in iscsit_get_login_rx. It seems to kick this off
after we send a login PDU. The connection might be open or closed, then we timeout
and get a signal and break from our wait in iscsit_get_login_rx. We then do the
goto err path like iscsit tcp.

- For isert, after the first PDU we queue login_work when we get a login PDU.
So, I don't think we do anything right now if after the first PDU nothing is
sent like in your bug. iscsi_target_login_sess_out works for the initial PDU
timing out though, so we know we can call it when the conn is open.

Note: The isert_disconnected_handler is sort of like tcp's sk_state_change callout,
but isert just calls to iscsit_cause_connection_reinstatement which doesn't do
anything (it doesn't set LOGIN_FLAGS and iscsi_target_nego.c doesn't have any
checks for what isert is doing).

My suggestion to set LOGIN_FLAGS_CLOSED and then to queue the login work would
work like the iscsit tcp case above. When the work runs, it sees the bit and we
go down the goto err path and run iscsi_target_login_drop.

- If your concern is that we would abuse LOGIN_FLAGS_CLOSED, then we can add a
new bit.
- I didn't write out everything. Like the ordering of cancel_delayed_work and
iscsit_stop_login_timer would need to be reversed. We probably can add some
more LOGIN_FLAGS checks like in iscsi_target_sk_state_change so we don't always
queue the login_work like is done when the ACTIVE bits are set (or we could
kill that and just always queue the login_work).

If your concern was that we have no idea about all the code paths then yeah
it needs testing.
