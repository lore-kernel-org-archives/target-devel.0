Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8956BC4332F
	for <target-devel@archiver.kernel.org>; Wed, 16 Nov 2022 21:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbiKPVSL (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 16 Nov 2022 16:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232408AbiKPVSK (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 16 Nov 2022 16:18:10 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF53D554E0
        for <target-devel@vger.kernel.org>; Wed, 16 Nov 2022 13:18:09 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AGJ8WO8024571;
        Wed, 16 Nov 2022 21:18:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=paOpHtmRImh/6kdN5oEacvDk/Uxq9y0jx1r4U0Kbhes=;
 b=PcYzgQJGRGs1dtG+2fdYrfItf8UU61hO6jEETLMn4IxdJ9fVs2rZS6Ha4MrmyTcQfcFU
 AtCK9uXnXvx1kjQVrW3w4EHIA4uG6boCSgnlPKz0riXLyCPNpWfn7FSfMIa39NsgncmE
 dYKTg8afrL/XaDw4cAXHML0toMPpcGFGmJcqKH1ZgWTaBPGNDBwY4pweaiv9Ht+kpilX
 63g7guIkTXtalq0lRFghPWLAtBUE/V8Ly4f8kN3MbQp1D2KTCffyjgP9nKcH5nLZd74Y
 Jhrez0sw1u4nxxtzDwjSaRinkdSMyxYE3lgTnM92GHrd3pFCPIBroitU7Q/nRrLJTDQ9 gA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kv3n16qbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Nov 2022 21:18:07 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AGL2uS6012432;
        Wed, 16 Nov 2022 21:18:07 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kt1xed57h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Nov 2022 21:18:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iJjp7qsMDPZYG7b7a0LpeeMNlaTqK1C+Si5GLd7uek80wBCe0wLj8hiDLEzX0LifcbZBc6M5Xv+wyTbsPbqA+nVd+8GjWEKvTu1vCDl6+B6mIGvnoLafES0zAgWFOB5two3VV3H7Y5FA+EEne6pLtdollo1UMSujPilZWBoSTHBGXLcGmWuznMbusbf47hJesuY9o4Fx220zMG4ca8hsH7Ckpi0kO5KaT9wvhtyU1msBtLlh4Pk1fb3IOQYGE/k0KZYbWzOLcCKBJ25SJVUVDKVli/Q41slygdIUMyytBMFEBTGMdCLZvLZt5gno729X51Y004NZYq/jtVwIR00DLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=paOpHtmRImh/6kdN5oEacvDk/Uxq9y0jx1r4U0Kbhes=;
 b=gjDsAIM6tS4qcg92J5uUZMMPIA/lRA5cTGoj9kSrf3H9Eq1UUt0v21BEFD9Det53rSmu4runTK579ejeRsMCecZEAmnRAYNmrshCUGh8/VpR7JYuksgPdAxBiN+yAi68Rrv2gkp19/xLxazyw+NKqlKYLtKX2ODSPez/189pfsyNKZOJDc8Yed5wqe7JSR7opFoof2uoehZ0kjldvH4KIcpLmpOxkWN5qbib4S1RWDtcZVxZkfnI6aTLdoHyIp/jhUuNlbqjthMDVwZbA/xFinYnrFsqeCtesvlKjykPxOwA/0Y6SgXdQXYgK3wndqB1t+Ke3pArSH66NoGCXHEzBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=paOpHtmRImh/6kdN5oEacvDk/Uxq9y0jx1r4U0Kbhes=;
 b=g8uSOPujLiou80W/fWDlE8V4OrF0MagieX+ntAAF9JTifJ2QXx7Xg99ozFyozibGwHGcFv3gGiDfNNbZiQSGnJg6MwSGhIcSLoWYxnx5nMAnb1zyQimLx/qlh6srhFKFSDZvqko2D3ppklNJ4OY08KsLIhEeT9ncA/Ffzn5GEvA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4697.namprd10.prod.outlook.com (2603:10b6:806:112::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Wed, 16 Nov
 2022 21:18:04 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 21:18:04 +0000
Message-ID: <15f2c782-2cd7-da56-2f27-a8a366cf53ce@oracle.com>
Date:   Wed, 16 Nov 2022 15:18:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH V3] target: fix a race condition between login_work and
 the login thread
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org
References: <20221115125638.102517-1-mlombard@redhat.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221115125638.102517-1-mlombard@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR13CA0031.namprd13.prod.outlook.com
 (2603:10b6:610:b2::6) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4697:EE_
X-MS-Office365-Filtering-Correlation-Id: df706b86-6b61-41f2-df18-08dac8180c94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PP2atazFKrb0FktU8RxssoP1Wu07Y35u36T9jGVQ30b6CEVLHYqkPWBSB54+8INUFOiiC0aI7VSdLIl7kitWhycfbGSgK0cvaMDLukyRYVo2emG/Lf940b5yr36cY+jcUUJt1a9Il1XecZJYaa7as33q4rRIdFhtra91r07HlPjG3aop7/bHlIEu4Ot0luPliHihG7aIrSVPcHwWPmdFNSkmdHk4xQTtrVcVDnPIoRJEDtE+hA9/wbIOxwLaURl4o4s01BBPQgkZE1yZsr+l/zwA2hG3o4I5IPBBuRSblU8ugu4mLsmiiHD/eoOR3y7B0yHWSz+SXps6N3CdB1UyP8YgPX0rPmvFBINoUm0vHd3z2hZYE+n/JUeL5vADHjT8nyR0z+N0hR5Jb4taGVcb+LRDCqg5THxIGy/FHbtuTeUysbjxpdRUnjP2b5DX6b1IGle2RxFhi505IbVfvlkUfZzwYPRbZm05xqTfgZ0KjGBwmSzXaoTzA6e/3unMVMDYJRyfPUvBCo9pp3RRreCQg4h80qkyCUVzK4f2wjh42JsdzBPVF49vvOdnT/irh8lNWQ6Gog5AAOQNU9CdrmyqwMjkcPqFG1ak1+JZaxrfds4GhMjLAjzAJq8z8g/tV2zdswrHNtEfrSqXXJDgiFatVhB4nrxDfMZN9X2UP9809uFJS/FcwCsQD8sjQxDBYHx0sHs9hJ/ajLc4zxuugsORpzmdCiTipWs8Tp9IyFI2bcv08qFmzrqTB8LfBoZPzH1xWxjFym4ndmaFNugEO0zobDmAAXmjL7URDYJO98Snfyo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(136003)(366004)(396003)(451199015)(478600001)(36756003)(6486002)(5660300002)(38100700002)(31696002)(6506007)(4326008)(53546011)(8676002)(66946007)(66556008)(66476007)(8936002)(316002)(86362001)(41300700001)(31686004)(6636002)(83380400001)(2616005)(186003)(26005)(6512007)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eU1SdXllalM3eVU0cXRkaVYrbHpTK3BMbjRyUzFSMk5yb0xMTTArUVROOE5H?=
 =?utf-8?B?emYwQTc4OXgvYVpzbi81NjJBMUYyMW05UHNMT1lVNVdPVUU3cHJucGJHb0dM?=
 =?utf-8?B?NUFkMDlOVFJ4VmI2cWptYUtyK1dXeVNrT0tLQktsVEs0TlkyMWxnREdDMDZU?=
 =?utf-8?B?alNuQ0M4TE1JYjJKNzJ6Z2tPdlhKV0sycVMwZEVubVpiaTljRXVRZkhrY2F4?=
 =?utf-8?B?aTZWL0RVZ0Z1TWJKd2M4djZsb29TM0NGMmgrZ2QrUnYwNlZzRFU2QkdVMlh1?=
 =?utf-8?B?Yi9mcTA0ZlY0N2twZkJsczUzTU4xU016anExODc2cGp0dE9rdWlSWHRkb2hq?=
 =?utf-8?B?L1JzRUU5a0lvYm9BdjRobUEwb2NnSURYc0VFVmhBSVJVZUdaSUROUHBORDZL?=
 =?utf-8?B?U2lmcHk1WWVTT1ZhbVlFd2pwTDlOZTd0MVR1TGVKeEpqajlWbE5vUy9OVUhU?=
 =?utf-8?B?TlRXZzhMRk1GbjYyRTJzT2RidldKQ0lsaDZaRXpwSTVLMXNDN0pROGJ6cERD?=
 =?utf-8?B?TFovMzF0Z2VzRTNyK1E0a0k3UmpTenFkMVcvMnU1dXNWVk9GTWJLbSt4NW9a?=
 =?utf-8?B?UW5XQkJ0ZWdSc0dLbUlrY2t3QW9lVkcvdGZTQUcrK0ZRN0pRTGVmem5uMGJq?=
 =?utf-8?B?aW9nZ2FGRkVuSlM5N1UzN1M5ZSt6VEpDNHkvVFQ2aFVuNEdHeHRvMk53NGs1?=
 =?utf-8?B?WWhPczFsVm9VTzIrUVNXUDNaREt3WWp3VFlYYUtxVDg2dmlpS29NekZzanpS?=
 =?utf-8?B?TTBzQ2RyMndPd1RiNHM4UVVwMFkzcG1Vbkd4VmpQMkZ1N2gxTnRRUkpBUEdB?=
 =?utf-8?B?Q1c5MVBjQk4xVnByaS9NVmZKZy9aWjgwN2RLUkdMYWJ5NHVpb2UxWFFxalhK?=
 =?utf-8?B?RTZCY2QxUGhyY1dSWDRZb0xZLzBZZk1JK0pnM1JrTndKWlAvU3lQWnNUc2Vs?=
 =?utf-8?B?UXZuc09zNTI5Z2RJMVJhbkhjbHlMN3hyZUVXS0p1azlVN3ZFVTNQdVhqYkIx?=
 =?utf-8?B?N3hoZ3NYdzhFMDYvT2w4V0daWXl2OGF4MWxmK3FVeEJ3YW9UQjZxVGpCa2tQ?=
 =?utf-8?B?dTVVTDVoVEI2ak9VZTh6VHMxVEM1a3VhUm0rNXp2QlZLNitoYnZwRmdOdW5P?=
 =?utf-8?B?U01RMElpbnpJM0FtV1ltbUEyYk5zbHFFU1dZczM3RXBoWk1wWE1pSG9LMUtx?=
 =?utf-8?B?QjBmNkl1V0lRR21GNWJKTTRvaUFNckZHTTBTbWdRdWMvbEE4dnZldHZsaFpp?=
 =?utf-8?B?eVRSNGlYbHI0SklyWFArRkFBakVRSDRteHlUZHZSdDAxc3gxRjhvNU1JVUVx?=
 =?utf-8?B?OUlBWkwzZDVBenB6VFpFUzJKZ0UvRkR4N2dacW9kZ2ZYckgzVzVhbEh0M1ps?=
 =?utf-8?B?UWFaNEFTOTNwUC9QbitmZlVPTlA0a1JNcEJabVZFQWJiTWZubnMvamRnd1Bw?=
 =?utf-8?B?cENyUGpreDc3SUJaMjBWU25CR3k0UHAvSUYyNXhwV3VWaUx4dWxscmJWTHRs?=
 =?utf-8?B?WUI1Qkk5VHJWNmdkZmJmNHJjRXVKekJOV3QrWGFEY1V3U0gwNjNleVZtU2oy?=
 =?utf-8?B?YmREOTRMYUtLL3pZMFg0ZHlQem9rRFZyUHR6TnZlbEE2WlRwUnlDTFduRDlM?=
 =?utf-8?B?ZlZsZlpYYUt4VDJxcG1ZV0VpVUhhNEFNcU9vcTJzbndFK29PeXBvVGlyWEpw?=
 =?utf-8?B?eXo0RFI4WXp1ZTNpQlduWTJjeld5WTZFTWFSM1NxVFI5OGVHc295UVIwSzNO?=
 =?utf-8?B?RWx6R0xuUE9ydU4xU2JyM1ZSSUhDbW9Iay96S3dxaEdWaW9ERjAvUkttcjlp?=
 =?utf-8?B?d0FlQVhwc0N4N3dRZnE4SGpDOFF5VVBVQ1d0UUxaQjdEbkRCcHBpeHN0Mml0?=
 =?utf-8?B?SFkzN0VhZDJoZ1FJU055T29nWm5Xb3VIbEdZQURLWDk0MW1oS1g5cUZPTC83?=
 =?utf-8?B?TVM3eWhKL3RNUkF2OS9UTHNBYTc4WXJqSjVVTG9zNVFaNURERjk0UkthSEov?=
 =?utf-8?B?K0t4RUtjNnBrRFFZSGQ0UzBMSnlUZU50OUVaNEJKSWMrVTF1b3FGcVVid0Zl?=
 =?utf-8?B?OVg1OVJiZnZGUnd0d2RTR3EyOGZKQVpnb296V2w2MmR6RHNnMmdISWljM1Va?=
 =?utf-8?B?eHZ4N3pOS2JGdzdtVXkwYjRDOC8rbVpVWmYxOHkzTHh4Vzh0N092bUcxWno2?=
 =?utf-8?B?UEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: eLuWussmheZxxcTdATJ501j4cDiroNl5OvE1UvRGhsLpBVU5dPJujoV8j4X6wwiA0veKOYePbzRa1X6pQZXuG+BtRMAIO5S7YO07i+XJUBDP3jAyNZ2myOgLPb0mnUlUK5kftMSkXAw0ZCTUpxe+GE/E3bwttrCiiX8esXZpgOCyvhszeFaovRQOqShyLFn8vnhaAA756W99V99hBCHHJhkp8W8Bq7uWyrA7unpdmCBw1+Ye11o0kA3iAwl8mNy5pe/WZr9IX7VcAUFWKd1UVfROj8JEvv687TlXHtq7mEBSNDabV8ZSgRR3tkw7/7bauotZzFI1E9GKI/P6VdqCS4BBZ921y0lJ3SFSlRyPEc5ySXJYPkdfq6bJjSoIiRRLoY4Lwrj9i3pg96LOOEfy8h+IiFLsTDta4+35RHihCAhe24hrSysPNjE5r5dg2nYMsvMxHyAVjmbYwAhi94fjBshIBI/U5EizzGVAeAjL+6/aPIjtB/Xh8//npql4R5z7CMMP9wQZZZInwGn3dZqbTG7HV3Zzg0IIuyqfcL80ZD17MV/EkOYQPT5T8topAP4wZWR48SYtRmQ83VE7aHDICc1uI9puzMR5ohZnrvWl8PNyS1EprGqhcRYCacZqm1HQ7Aew/xOAfopH3MId/7iFxwxGo9l7M7GH5bWJ/IWk5Gp5jUGi7snlcGcun/V5t4UHBh3llFGgAfzvA8j0rOSyTAlknsOvR0+ZNV7+7kdhBOjY0yz2pdsCf0jSGN8EEdCFQXDhGJ0B3StdN4WdGmmpyS27ZsFeM91j8PNS3NuFsfI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df706b86-6b61-41f2-df18-08dac8180c94
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 21:18:04.7668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K7f1XDnsU0HkkN8CH1eOgR7ScSkXRN9gG3hEW0yYe+Bo1NTZBHQSiDRZM570IkSvVTso0Ebae+f0GqymDZQ/BgSdIrsCDss+2/CfR1CALDw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4697
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-16_03,2022-11-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211160145
X-Proofpoint-GUID: U4BoxEa6aWk-93np-EvSLgOTVM_xMhBa
X-Proofpoint-ORIG-GUID: U4BoxEa6aWk-93np-EvSLgOTVM_xMhBa
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 11/15/22 6:56 AM, Maurizio Lombardi wrote:
> In case a malicious initiator sends some random data immediately after a
> login PDU; the iscsi_target_sk_data_ready() callback will
> schedule the login_work and, at the same time,
> the negotiation may end without clearing the LOGIN_FLAGS_INITIAL_PDU flag
> (because no additional PDU exchanges are required to complete the login).
> 
> The login has been completed but the login_work function
> will find the LOGIN_FLAGS_INITIAL_PDU flag set and will
> never stop from rescheduling itself;
> at this point, if the initiator drops the connection, the iscsit_conn
> structure will be freed, login_work will dereference a released
> socket structure and the kernel crashes.
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000230
> PF: supervisor write access in kernel mode
> PF: error_code(0x0002) - not-present page
> Workqueue: events iscsi_target_do_login_rx [iscsi_target_mod]
> RIP: 0010:_raw_read_lock_bh+0x15/0x30
> Call trace:
>  iscsi_target_do_login_rx+0x75/0x3f0 [iscsi_target_mod]
>  process_one_work+0x1e8/0x3c0
> 
> Fix this bug by forcing login_work to stop after the login has been
> completed and the socket callbacks have been restored.
> 
> Add a comment to clearify the return values of iscsi_target_do_login()
> 
> v3: cancel_delayed_work_sync() should be called by
>     iscsi_target_start_negotiation(), because the latter is only executed
>     in login_thread context
> 
> V2: remove an unnecessary call to cancel_delayed_work();
>     fix a potential race condition in iscsi_start_negotiation() and
>     in iscsi_target_do_login_rx()'s error paths
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>

Reviewed-by: Mike Christie <michael.christie@oracle.com>

