Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB9FC433FE
	for <target-devel@archiver.kernel.org>; Mon, 21 Nov 2022 19:26:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbiKUT0M (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 14:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbiKUT0G (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 14:26:06 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B538CBA4
        for <target-devel@vger.kernel.org>; Mon, 21 Nov 2022 11:26:03 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALJODqc014637;
        Mon, 21 Nov 2022 19:26:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=gAwGQ0qMzhjfi+mbBCy1/qlELr136oWV+fXVlIglxAQ=;
 b=doY5N7N3D8RFjNjdQO/cBql8hvOgY5yKAFS0y24IPCg5TX3dIF6bMb1mqUguf0X7FsIZ
 dUu8/xkkzcovSxLK593KKcJu5Yb0l3dMceoDQlLyLERGH+Ko/QTpT+Hn1boZ1m9V3/bw
 uXsh/sCACRwOqaADfRofM/JcpapOsKAAjrvOVEV0cwimjC3bpYoNa9m1Qi4EVTp3gdLz
 gcgnNO3IMcy4mkR4sQ6GNzeVtjh8mTVcDFPOllNEUbXHN5BAFwV8IB9TH+kFom20gdya
 0ZxPuIx4WJ4LELDlnUu4iEaf+j112JqOLIKYPHg4vuD0YRnP3IlwBILaYFZo0AUIJkDm /Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0f1d83a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 19:25:59 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ALIgF7E038779;
        Mon, 21 Nov 2022 19:25:59 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk46jht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 19:25:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mzEr3uh/hTvxi029Q4NeyxsM3+MWxjms6XfE5Bm/+qBoeDTE5W0fGDeOjId4CaeRbZ8m+rJI3TS3am8YfhNcKLGgCLhZW2GFKJgLyQDTOWjs2T8X841tmtadM+13bgleyqhvF9oXbvVkHMRU19Hvco8r4Fvvp8r/JOZ17FILYbb2oU0pUKnVVIbASYh+4Wvt72OuUuuw103URvGDIOEdrUw6irlyODQol6KCPjsbIZIDdGY9PEy0YcO28Q8V6kvd7XEnY1wmaC6KpoyS9qHRygGZsVVEKRzgfQXNoWqPQjvARiYDcuiOqHdqOlHxbNQqvr5o23of4GG25aAkFxTzSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gAwGQ0qMzhjfi+mbBCy1/qlELr136oWV+fXVlIglxAQ=;
 b=Pi0Ipw3lJVCU0lNfwKlte+YqKCqil+zd7yDI471qQaGIwhUHLuIfRvuyN5cTy2T6orltRS3hMP5nowTsYfBjDqpluPYRXtzeFgUpcLGa7r1v5Qvuts/1LnAl2SijqYnt9I6QbjKixJZFl8KjC5qPrkZzqR7vMHE2Xd2r5Q/Pa9NwOrzmkQ8iLO1JK9tJmWOwnGmNnrz13jo8wmkiycPQ1giBRO9Pu0liQv46ynG/sWWXtyoZkTqXCCKBefrVHv8Snth6JvbSfjE5fUymmAali8EXnkFt7UncQIXui+OYjbKQ8nZ6PRwVxr9Tp/YTSMIg39iOk1vsrM+boyE2Ntw9aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gAwGQ0qMzhjfi+mbBCy1/qlELr136oWV+fXVlIglxAQ=;
 b=pRM7ua8rwj4xD6SayGML8iGLKxfvEPiWZEkw2pKGliWZNZtxhKFBEfd0uBzxWLcenpyV2C74c4DiPQdc1TizO/97MMe7P5SVHHNsxQcO8h3MjmRcnYsCvlHmLh5rrn6qNxQG0NcT/14quaXFajkc3aoBgC2ZNt7Obd5A/NiTCXk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BL3PR10MB6044.namprd10.prod.outlook.com (2603:10b6:208:3b4::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.20; Mon, 21 Nov 2022 19:25:57 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 19:25:57 +0000
Message-ID: <addec585-4271-cd9c-fcf0-fd780f269aa8@oracle.com>
Date:   Mon, 21 Nov 2022 13:25:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: tcm_loop and aborted TMRs
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Bodo Stroesser <bostroesser@gmail.com>
Cc:     Maurizio Lombardi <mlombard@redhat.com>,
        target-devel@vger.kernel.org
References: <CAFL455kjQeqvPqd1CUqs7f6xUjrrDqR1h7edizusAtj130HCPg@mail.gmail.com>
 <caad6a7a-c30c-a3ac-7932-f5a19c877ffc@oracle.com>
 <e07f0fa5-d59d-36f2-d99b-73e32af3282e@gmail.com>
 <20221121133550.GB5248@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221121133550.GB5248@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR11CA0019.namprd11.prod.outlook.com
 (2603:10b6:610:54::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BL3PR10MB6044:EE_
X-MS-Office365-Filtering-Correlation-Id: f139d46c-7dc8-4b70-0a20-08dacbf636cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6aisRWp5FWIjSrvb6AxPv8AqpteqPBVL2IUiwW0DBw2SfjRTFXftVhTzxUqiny+OD2Nm5gad9K8IayHIauUMONj2PhPxTilCLCMAhVZpa6x8N0fFdjTTxt1BUSJJleeVEEVTv+8qyI3m5z9q2n/ypHfoobysNkr4IGQYAS+T4LMMIF0zN/Iy0joxnUOIIdfkPtyi24l8wvbiOwoEdhDfTEZ1AOUms/tidmVhr8YyRn6Q+Ya6R0W1KeaU9FAvH1sKKiLLDi3nSj4VEH1bD/B0Phwe+ZSAiXVfNBNANwPdbjDbHZlfisGml8jk2FldFBs1ONsGyepARg57/yXCAIAyDwMbv4t9gVQk42AEhPCEVE5TmhhhQ4UMD9c86YZvtU6JmRqXRwxaTAD6QyGkQ8ncp0rC12XKuiGR2852NZFGFSmwJWX8+qrbOcUBKZu1Djke9OeBjBo8BD6ynluBo4qMLLDY0U3SDVOy4x9gAvwexO1WzxTSCCDY1pfUDW5Wau7EZZ9zBy0uorJ0RYaViUhcVfbJ7G1p6Uc3898EArV9B6s4o24rKcmSK4c4c024Sr6WuD1G5U/LtNffs72npxV2QI/Ghl1zlps884LN9lUEim+4pxzsEn9aiBnVC54zGxxck0FBFwsRpHUDodyG58qgv8s2fFpJOHvOr7no2QyAE3VnaPOxZJ1gt104nnEOfBxFhfuUMfmdcFpvdzEYMghAvvpHf5CxAKVknvjJdCbhJfM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(366004)(346002)(136003)(39860400002)(451199015)(26005)(38100700002)(86362001)(31696002)(478600001)(6506007)(41300700001)(8936002)(6486002)(316002)(5660300002)(110136005)(66556008)(4326008)(8676002)(66946007)(66476007)(83380400001)(4744005)(2906002)(186003)(2616005)(53546011)(6512007)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WVd0OWJWS3RsQkIwSTZFL0tZWE11REtWRWhnbEt3MFg2QkJYU0FyalliK0Fi?=
 =?utf-8?B?MjVIV0JtbFAvOTlpbEd2Q2I1SFovZDBYbnNZOStIUmQveVY0eTg1d0psUmMw?=
 =?utf-8?B?Um43UE9Od0VjanlYTGtuamtlMTN1cHpnaGcwUXpUSWl0b1g3aW5oeXdBb0RH?=
 =?utf-8?B?aEQ3MFJRTGp3UWtaaFJpajZmM1pINmtwWjFuTGo2Y3dOV0FYQngxa1Fyam9a?=
 =?utf-8?B?MXhlRTlPcUhYalJJRVJvbTlqVS9TTmYyVkxieHp4cFd6S2lhWW5KSU5qQm56?=
 =?utf-8?B?QVN4SGdTejNpWm5OUG5HKysveERON1d4OWpKNmlpc21kdDc0WDdvdzJrYkZH?=
 =?utf-8?B?SEptMlZ2K0hPSXh6OTdsK3BMWWlKRjdMZWM4bW5SZFNDZlhKY29yVWd3SlpR?=
 =?utf-8?B?cm01bm9YV25uamRIY1NoZ1hiMWV4ZHE4Zm9SZWJQR3dFajc5eUthaHMwTWlS?=
 =?utf-8?B?Q0M5cFEvOEk0TnlqQkdyOGxaSTF2V0F2bGRSeVNWYzdmSnZPUmk5WVFpSXRP?=
 =?utf-8?B?RTk5VW80VXRBcThmTWhrZGVTa29yeFp1RkZhQ0E5SHR4MjRVZmlEdXlSOXlV?=
 =?utf-8?B?d25VTStodkE4bFoxRzdBL1k4L0VUTWZoR1E3R0xKSHd1b3Y0elIvbUQ4VGpB?=
 =?utf-8?B?L2xFbkQwTDhlVGdtRWJzazZHcUFRWXRGaXFpOUV3VTQwM0FnYWlnbTBWK1M3?=
 =?utf-8?B?TDRnSGQ4SlI3U0FpazJ6WEtCZTlWOTlzT1ZGbk43VmdyWGFxNDFIcENVZk5L?=
 =?utf-8?B?N0c2S1I2MmFUbmRqdmY0ZENNVENvNTRBbHNvbWQ5R1M0aXdTaWJYTk5ob2Rl?=
 =?utf-8?B?bGZJME1ocTdnTjN6aVVvdklQd3hvSEJNN0NwTms5bkxheWp4NUhNOWpLd3Ja?=
 =?utf-8?B?a0R2N2RwNkY3M1NhekQxWUlnSmJQV3JUMHNRUDN2M3BaQTR3QktZSUFEeExF?=
 =?utf-8?B?ell4YnN3bXhNMjNpRXB1KzhOcXlHZ252bENhTHIwNHBtUThFajNzUGdrbmhM?=
 =?utf-8?B?Mm5RWklXeWYwcGdtdUxQSlU0UWwrNUdTMWlnMUR1UGQyOC9RTWMzaU9Eb3NL?=
 =?utf-8?B?aUdDL1RmWGk5U1JMbUN2a0ZYTlRGckhZejJDTE5oMTVUK0VnUUJLNWNpQ1Bh?=
 =?utf-8?B?M2JDbk1xbjM1b2gyWW43MXN2Zy9PR05OWDRCRTJFQ2szMGVjR01lZDQ1NmRN?=
 =?utf-8?B?d0xHMDBnZk13aWxRbmpiVm9IMG5rbWc4UnE1elQ5Z2VqQi90RFdoWFROWlFP?=
 =?utf-8?B?NWYycFVnbUFSRXg0SStmV05IL3hZdlpPYTlFYTB5SVMvM3F4M1M3bFNXTjNP?=
 =?utf-8?B?V0tKUnpDcWd0dVpWRzd0bFRBQ3BmV2gvcmcrMFE2RmNaQ0h1REFPVmwwQzdP?=
 =?utf-8?B?OTdGejlmWk1pQ3FaYTlCY2hFdysrVjhtVWhUcFNIZ1FLbFpmajdCck5ybU9K?=
 =?utf-8?B?dGR6MUl3YnpnLzFyNnhnYjVJSUJPbFRZTEFKVWJmMncxZ20zanBybGNackNs?=
 =?utf-8?B?THE4YXhxbzlsL1VEZDdUTXo5UmhlL2RLUmFYRWZvTENZSi9zNU9pMjBsWXJT?=
 =?utf-8?B?L0wyS0VZbnJaRXE2akxvTzdFVUVFU2JWdW0wc1JxWkZuWkhkclFmTFJ1d0x4?=
 =?utf-8?B?aTNaK2trRlNkVm5uT2VmTDRYNVdtWWYzZ0J0eEtHNm1wMEZOWmhHek9DTFRI?=
 =?utf-8?B?VWo1SUFtaVVPaloreVlwVDZHZ3ZNZnhianM0Und4ZjVaSVVQSEtyQ2xsNmtW?=
 =?utf-8?B?WG5VVk9JV3NKZmlhNU9FNStmR0RPVUhQVk8wTys5YkVwSVFJS2YvTC9vTDFM?=
 =?utf-8?B?TWFHaGFHS0FwejdFWkl6emtUM1I2cU1QM1pSaGliV3NZOWYyQUVGR01KVEtw?=
 =?utf-8?B?SVRNVmhGaXB5MFJMUVNleVpLWjRFV2p4VUxGUFNzWndSQkVDa0h3UW96WDds?=
 =?utf-8?B?UEY3Yk5BOEtUeVViaWNtL2dCcjVscCtvdFVEeWNja2FaQ0FzemtlV2kzRVp0?=
 =?utf-8?B?ZTZPVG5WU3A1aUVnSXRvNnhzNEJQakY0NFBIZGZ4TmpXSUxQb1lrcE0xeXND?=
 =?utf-8?B?ZnNuWTIxaDNZS0VwRXA1eThheTRDYWlHRGtVZldvWnZpVTBnYW1NR2RNSGZt?=
 =?utf-8?B?TnQ5QjJ6QjZObm1vZFRZZ3JBanVEZGYvbUdvdWlNZGo3aHp0b09GVlFTODYw?=
 =?utf-8?B?b3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: hsNHc4BNRGzUn1awTGTTEgCeO5BezklVwGH4vOkGKgmhXp3sSnZbyzMwU/FQUGAdJGBZFIw8eMtntUO+BcHLJRW//DLKmWnnOVTVvaYPlSiY/fBKNSPsTjVbvDaOR4VeDl6U0qQ9/9hRatMKSFrAb1/KaO6FPBUSJKfXiXbksx59AAyCA1n+ZdeQpF8VPwarNAKGLFe3xTgyXZc99HSH2+R0KbJuKuwz0FQ1j2EwzeXRKB7ZWB1omKB9qP/XwOeyASSv49o74dK/5zd7nlTCKV9Eodneo0YOrJwtpRHsQKR3FFOQglznzXsGf72mGe+U3yFXpLMOkB7orGfpSnV9wMHzemc8dgZb8WFMFjE2UIy7N3ZGNJ8ighoA6vwsDgCx0b7Jc57OMple5+cNZ04AucpNcB9S0/UWtMKdfSyr+J1Jnpp24aLSxYSCZolLeagpuqCSwrS9nNDeEPkfp0Nyr7nq0p2Ah8Uf7CRmVsJGXnK4mkW2Fi1WginmEuoj0u0+H42AazQ4hb9DvcTpchM+QkeksE5gYR5PRrtYi/yFnIiVKQqu9yQVFPshfPoXDQakZbV/zMxdP3n7KNlSfI11hPfTwGRFDw9oAmFA9XeSQJKDDYdu68xvXUH76qeD7qeCQnc+7sOMKZYHAAPlcoiBSLJLEFH7NxtsB2ZkiVpsDPUE7le0MR+i6MsF2zfaeIdJz0B0ZUc1gcOgFggLSVC/Xk9jHYp/89cFyZfEALNs/Kc0cQEmNgo7edXe720tdDKxf1V0S1BBobqUedjJ3cbTeOaVPTptF4JOra42Zu4V4TGs7YAtBUsFmWPkvT0MHVikextmkKntbbLXy7D2KmkbsG3xpdiym1yiT1nM//Xecjw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f139d46c-7dc8-4b70-0a20-08dacbf636cf
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 19:25:57.2027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qUX7pTV+UPq/P+B900iQ7VEtdK9nRdgVxb00v5YzQQjAtrckb1lJoxGuLDxRj591SpuPLm9fIN/0PFuOCUa0T2yLlMRZNku+m25qSj/9qB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6044
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_16,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211210146
X-Proofpoint-ORIG-GUID: fUhG7dI-rpoofbdo8dnH1tYY3EctNXHw
X-Proofpoint-GUID: fUhG7dI-rpoofbdo8dnH1tYY3EctNXHw
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 11/21/22 7:35 AM, Dmitry Bogdanov wrote:
>>
> I will vote to your old patch. qla2xxx was fixed long time ago.

What is the qla fix? I think we still leak. In commit

commit 605e74025f953b995a3a241ead43bde71c1c99b5
Author: Mike Christie <michael.christie@oracle.com>
Date:   Sun Nov 1 12:59:31 2020 -0600

    scsi: qla2xxx: Move sess cmd list/lock to driver

when I changed the locking I had added the check:

static void tcm_qla2xxx_aborted_task(struct se_cmd *se_cmd)
{
        struct qla_tgt_cmd *cmd;
        unsigned long flags;

        if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
                return;

because tmrs are not on the sess_cmd_list that's accessed the
next line down. We don't crash as a result, but I think we need
to add code to send the cleanup command to the FW. Bodo and I
were working on that part, but someone with more qla experience
needed to work on it so it could be properly tested. We didn't
hear back from the qla engineers so progress had stalled.
