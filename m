Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC4EC7EE26
	for <target-devel@archiver.kernel.org>; Tue, 23 May 2023 15:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbjEWPke (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 23 May 2023 11:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233770AbjEWPkc (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 23 May 2023 11:40:32 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221EAFA
        for <target-devel@vger.kernel.org>; Tue, 23 May 2023 08:40:31 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34NFSmqB013507;
        Tue, 23 May 2023 15:40:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=KrXYaG3cC1ETBsbsDGp51cMGkqDpoIUYi/De1EYD4Xk=;
 b=KlX8SzbpP1OE7Yq6OBCWI976noRFiFSl5E2/pdpH8z9oyJiv77g6JgFakvKr2HAc+zEE
 Lis7q2mt2TSURP5fOiWd9ff3AlXKiOP3PCtdWcbQiXbFExOfeDeXswnUPHiKroMIZj0s
 AiFUzdHa/WoBBOJWqHsfBMEHVqMwhezq7tjqgLEwG2TZst/tINcss+Ry95ErgSVAMwUw
 GjxoF/tu7FgiDGrFLiiarYtfr7D0f5hl/nLAy8bbY3/fftEjOE16vq1gDyroSe8Mftne
 AY9ygbynfTM2jJiq4QlgPi00pJXZKJttJ6uMvzlSP84TaO3WputJy//5DP7K+6O7mmwV 8A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp3qnfa3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 15:40:30 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34NEsrET028711;
        Tue, 23 May 2023 15:40:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2r87qk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 15:40:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X9svyapqjMWv7OTW471taodKXfeX/GT1W7kR0zOzI6izZzWcqTuA0AnzfLLz80fPHFgtVSZ7YukauuS7RaR8+xp7//LjrooEmWs0x3dn4T29tZ1Zk/bF1oaxTZONgWLFBgukpPqL67IWMDzJQUDRCdCSiAQ4TrOwfzim89/oHYHwQKBgsJ2lqxOuWgLFefKVZbSnokOoVtyotxEZFtVSLuUZRPB7Ik5IolEB5v11gA5HFQG0LkAnmvC6GbWW1uj+kTwLo+z9q0NuO3pTr+CDjtjX3ByvYtDpGGiagDpfj7HjYCzPJqWDMm+yg8LQGXZc0mUUi0a7HNQOVQLJvpOiTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KrXYaG3cC1ETBsbsDGp51cMGkqDpoIUYi/De1EYD4Xk=;
 b=hzI16ZzFk36vjG7R4cUcCS4SZOV2oYojzCx/PiMmD2J9a4qEQfgVv5Ur8SGpfKtl6yWnrrFeyOAuKxc/0g2jOOgstevUFweCJK7koAK8Hda1gTo/bh8BeVzBGpjCgw1MqqRkbhMNsiTCiIxmkiIM8vmHwGGgbmHj1xsWryPEH2FfaSwt/M6HocXf0au2Tkoc28v4hPi0hJ40h/Z3wcWKEyO/KnAMUxUXBr5nVhulb6SFa2Lb3LoXLe6mqt5uOEfX+fken4TFhjZOHnplSzVe5i2aDnAZGAICbvE0tgltq91qqE9Vb3H8HdbWV80Gkqw1wF3Ucuh2MxPSw0RRp7jw2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KrXYaG3cC1ETBsbsDGp51cMGkqDpoIUYi/De1EYD4Xk=;
 b=C+u9dOIaspq6mMV4lq+MtihTafwlxB9Z5VFiBw2GC3JRYhyANSymCKFGgaCuZLMN3YS2q4By9pmdk4Mk7coDC33u5BlXkM+utpv/1hYSfOqZiHmFHmwFeN9dbdyn1bGVcTGGBsodmuHVErL144fGK+w2yWhd0jzD58G8Lz73btI=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CO1PR10MB4516.namprd10.prod.outlook.com (2603:10b6:303:6e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 15:40:27 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 15:40:27 +0000
Message-ID: <91f502dc-6d31-2d09-bec4-276851221b56@oracle.com>
Date:   Tue, 23 May 2023 10:40:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: SCSI target logs
Content-Language: en-US
To:     Konstantin Shelekhin <k.shelekhin@yadro.com>
Cc:     target-devel@vger.kernel.org
References: <ZF0MiCRW8HWm8YYj@yadro.com>
 <3b0540bc-28f8-70d2-d6e5-755f15005cb8@oracle.com>
 <ZGnmKCzlijw9W-qt@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <ZGnmKCzlijw9W-qt@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR08CA0030.namprd08.prod.outlook.com
 (2603:10b6:4:60::19) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CO1PR10MB4516:EE_
X-MS-Office365-Filtering-Correlation-Id: d4f35613-342f-48b7-81f9-08db5ba407df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Wq7BqLMasfGJp9l2znhdunQ55uT07T7IuT2p6AgvwM94+FUPh7oAgvXpFUy58/ay7hRLKQy/QADpAUfy2jRi+uqSamNQxrMzR5FnMMqdI2rEVKkvRnOradxn8lmhWMBxSCnT75RY65ywb8cuI8Mdn2YdFZ9pm4pCC12M7wcgi5TOuCQQyGqflyYn+/xLuhcKghXMX0k/75wioy3BSSvbm6jP25RV9LIcLUO+13rmIv3W9kCS9v2SRJGX52nIcR8ibZsMSQxJmCE029spp8tH0gnPORzkfwNpq+POyUrecNvf4EGL09hzlafJGqzlAxIyXLgoWNwSP71OMuuBwXkwQIC1Q531HEmKgk+87/EkCavFTHyeGyB9wCd600+jDNPNf1Smi2euleUwjbFJpo4jUBxLaGh2XPIjos+D677SZOljbK+k4J8jufYe0Drm56EI+3aFDw/HmsdQkfvl65zTCkWWWP3nv5C6QKk8/yF66OTUTQ6NFjH660gsvTOpd/C2PmawEMnFoBp/gwVSLCttEPPDTlPfNLeCVTk6JDeZpM2ComU5raS47ttuZinw8K3sM7QSDZuGfGGsp3wRFyulMXgFyPWwtT/Vsg2MY+tzrb+Hz+KJOv0myZw7cAr5PfYwScJik033RPighu2m+xqtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(136003)(39860400002)(366004)(346002)(451199021)(6916009)(4326008)(66946007)(66556008)(66476007)(478600001)(31686004)(86362001)(31696002)(41300700001)(6486002)(316002)(5660300002)(7116003)(8936002)(8676002)(38100700002)(6512007)(6506007)(26005)(186003)(53546011)(2906002)(3480700007)(36756003)(83380400001)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QU1GVzRDRDNjMzNzRlJBY0NNNEFqYytDZXc3SHBoRlEzWHNCbUhBVGd3RkRm?=
 =?utf-8?B?eEo0bmFoMHkwU2d4MVdyYUhxVnhPcS9FbU5BUk1uZTBNS2Ezb2s2THh2WlpP?=
 =?utf-8?B?blY0WkljbmEzeXE4QVc0bzNHVDNxSHlwVFI2M0hYeWJTTXlJd3NiQ2ZZQWl2?=
 =?utf-8?B?OUlPdU9Yd2VSbXRJYmhXRFl3WmtwOHdjY2pxY1pxY2tKM3YvT2M0VmlWMS96?=
 =?utf-8?B?WTF6NGdaL0xnRk4rY3o5MkJMRlJBY3F1WVhQelp2TjlKYmttWSs3TVlUY0Jo?=
 =?utf-8?B?cDF3M3N1MUVudVN0K2lpaHA4RnMrNUZyd3BLUnI3OWxuM3Jqd2gzb3czR1ZV?=
 =?utf-8?B?ejBlY1JLVndpeWpoYTJlTUJ1ZzJHYzcrc3NVV2NKREY2b0NicEx3STdIMEhi?=
 =?utf-8?B?VDEwUTV0dEhYb1NuUWZ3MHNUL21aSjdqMVg4N0RwVGdRdmVzNzNvL2FnNGQv?=
 =?utf-8?B?RlBmbHhGb05LTVRSU0hJaDE0TWJhSnV4Z3N2WE42ejYrcDJ2T1N5bVAwOWc0?=
 =?utf-8?B?Mk5kcDMvZXFPYzNYQllwaHl0OEovdi9OTXp3ZzI5NHFKNGFURUhuclNiL1BP?=
 =?utf-8?B?UmFlOTFPaktjbFVZbXRnVFYzREkySnN0US92UnFDVUFqQmppblY5T3NOclQw?=
 =?utf-8?B?QW9WYk9WTGNabzQ2b05QM2cwZTNMYUhYNUp4aHVyOWpFTVFncy9jckhBdWU0?=
 =?utf-8?B?dGgxYitpb1BFa09sck9jSHUrbU9qdzVPOWxTeFhsaTdXUmJyMW12WVJXcXBy?=
 =?utf-8?B?eUhWaWxkSUxHdFhnWHFRVWVNdFdwVGdkWUROdVpKUDNETTlRa3B1RDdPVGVp?=
 =?utf-8?B?Mm1uY09rM21nSkxRVWUwVElyM04zWmtzanZ6bXNkZW5lUFZKRFZRVWNUdEpU?=
 =?utf-8?B?Z1BZTWhZS3dIL2NxTjVGNGhlRGNKb2NXU21CK1Y1czRobGR4d1R0ZnkvbEpo?=
 =?utf-8?B?NTZYVDQvSzNIUDQ1dyt5dlpZM2hPSnRVcllUVThIOWw4dC9Ra2U4S2dwdGVv?=
 =?utf-8?B?Mkt3OWdDY01DRnVOci9aK1RiZkJlREVhR21ZZTVBVzlqZklXVXV6TnQxdERk?=
 =?utf-8?B?VzBKeDdiN3c2YjRnREdVZFJtSlpPcy8yWERIR1diQ1BjT25MeDhhbjdNZmxU?=
 =?utf-8?B?TE1qMlpyQjlaL3NnelQvUmFCanpuaGI4ZmQ4emtmeDRFdWo1ZnQ5UTh1M0wy?=
 =?utf-8?B?bzYyYXc3STgwNXRlNC8va0VsdWpTL2JvZGtDOFYvNnN4NnpxRGY3cFpQR1l6?=
 =?utf-8?B?djhVUloxNDEyWlRsS2tGVFpOZXJhYlpvMXZRaWJHY2xqN1I4WGZSNWFwWTNv?=
 =?utf-8?B?QnUwQnJKRGJXS29rR1FsOEFvSUN4SXdBVENlWnV0YWFlU0s1enpqcmpFWlh0?=
 =?utf-8?B?d3FMenphRzJ1WDRaZkJHOGJybUltcnZPeDR0eTB4dFlObEZGWW5idU93MVFS?=
 =?utf-8?B?UVBqdSsyN0RuU2JFTS8zc3VjdnhmQ2Q0bGEwTksxTXBsZVR5ZkRYcm5mUHlZ?=
 =?utf-8?B?bTVOTHRmWTRSaEJMRWp2QTVCSWZsZzV0ejRNNHZtbmJoVHVMdjFLVzZsWVdv?=
 =?utf-8?B?c2crMzlKbFJMRWFiZ3NmT3BaK1hJNXJTZllJb2dwMUxuTUptaGt0SnNpRGI3?=
 =?utf-8?B?ek1UY2luK0Rad01TT3NvdUZVOVIwYm05VENkSjBtNkhyazlTaFJabXpGWklj?=
 =?utf-8?B?QXY4V3BsNTFodnYwY0JVYklKcGJaZWUyVFM2ZllkQVJzdG10M21DdVdJb2Rx?=
 =?utf-8?B?TGFFUmsvN2FSUFBDeVZkL0p2VzZyQkpJaWJZVnBveUVqcFdKZHYvenQrY1Vu?=
 =?utf-8?B?dDZBOVppU1VnQkZ6Vkh0Qnp3KzI4cS9SWEZqN29OK0JoS0NKTTQyeTVDcHVu?=
 =?utf-8?B?ZWRZdUUyQnorVUtQZ0RQN3I1Tzkxd1JSUVRKaWluVHErSTMyVmFJeC9TL0NX?=
 =?utf-8?B?bjVydXJVVER6SDIvdkdDdlJQYjV2Y01iajhzTi9UQ2tLWCs4Y2NETDl5RDlU?=
 =?utf-8?B?VzVOTlBPMm4vb09yd2lYdVhVaHlMTEpGT3JFQ1B2YmpYWWltcFplK3Noaisv?=
 =?utf-8?B?bzhNNFJpcEtINWs2QVJiVWkrUUdvYjBiaUkwSGJ5UXNsWmdVSUkreHc2czRa?=
 =?utf-8?B?Q0NVTm5NVkhndzNJSkZvTjhKaVFzMjFjK3IyeVRQOFNKUGdleGJpOGFVYlNt?=
 =?utf-8?B?cFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0BLQBDajLG3d6/+pbBlspvmg/cvz3GKAbAgZQ8/Pw5dkxrifUwb7rG+huldHeG92a5K6CpBnbq9ZaxsJHc9e60j8nNH4TxQ/vslI0Vv1mcxSxmAmTPQJCIDpvtUG3atadZhYhg0m5mqPaENP/Axdbx5BjqSCjjASt80r7sKibwd2ACIO5DVCJLtx/XGeAD0+4PMKUiiH91qZIEDRHT+d0+NfBYZwnJwM6nArZP9swmDpdQRYkX8bKJueD01LVIz+0G0wc+QFzGcEufzz6aY5XL4j3QUkaKBFEQBfDUJRhPocsWfpnZf2vcpaJEU9hO9K2EkuOTwpXEwgEBoySHe2a+6h+FDcqyr4dlHMUE6nFM33WVfiunmH5QF7vCWzHvDPSCtmaMNoDYsln+tQXu5bZcYgmdUkYSlL9zZWH5I1nWBsumgRWLl4+GKLi1JCg1pJftyBfWveqkNQO2hmdJnaHR/9CcUqEJU/1CkUWZIAnToKWA6VHuGMWo6BFuDrDsNmOYRiRGB/yjXYPX00VCT+c0957bL03gTmj2bTmOI6cBjcu2V15ib0Om0XPuLmAy5Sl/V06e/JS2IHSFL8tueJPq9gmoFf0FGNT1o83nTyXt5B4gdntkUjIWGHXijKEhElg/vYUbFMspRFpDQhJAYufnk85h/Rh1X0ZWPuHbxiGKTtFznskVdKEverk8S2OnDYueSdJOyC0mRsFxjPTGVrou9jzlguH4vTcJRA18G7+Sc1zqphuVWbErsvINJCfYlqSloGjwh9BUzJ1drK0JB1MSWMJ1tms6DMPhuHaIJyfsU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4f35613-342f-48b7-81f9-08db5ba407df
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 15:40:27.1335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZxnwswMZo2TwATemUje2PcEQA+egUPWUIF067y6iW3/sbpQjGKEXOl2B4Pe8Bpi41mXSkiIfdzCLTKI0GaHTCBhUuUXvgA3NRhVOB/X3jsM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4516
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-23_10,2023-05-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305230124
X-Proofpoint-GUID: sXKJ_ztMkpoA_sqicgy8kbj5xDtcJAb-
X-Proofpoint-ORIG-GUID: sXKJ_ztMkpoA_sqicgy8kbj5xDtcJAb-
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 5/21/23 4:36 AM, Konstantin Shelekhin wrote:
> On Sat, May 20, 2023 at 12:56:29PM -0500, Mike Christie wrote:
>> On 5/11/23 10:40 AM, Konstantin Shelekhin wrote:
>>> So, my proposal. We should give all modules similar names:
>>>
>>>   tcm
>>>   tcm_iscsi
>>>   tcm_iser
>>>   tcm_qla2xxx
>>>   tcm_iblock
>>>   tcm_loop
>>>   tcm_cxgb
>> Do you mean you will rename the actual modules, or just have each module
>> have some define with a name like "tcm_$WHATEVER" that's used in the log
>> message?
>>
>> I don't think we can change the actual name because scripts might do
>> modprobe isert
>>
>> Unless there's a way to do some sort of automatic/magic alias then it
>> would be ok.
> We have MODULE_ALIAS(), so it's possible to do something similar to
> drivers/md/raid5.c:

Ah ok, nice.

What is the target_core_fabric_ops->fabric_name going to be?

I think that can't change or it will break userspace tools like rtslib/targetlci
right? It would change the /sys/kernel/config/target/$fabric_name path?

Do you want the module level error message to match to the fabric_name
or the module name? I think the fabric_name is nicer, because it's what
the users normally use to interact with the tools/kernel.

Other than that, I think it's ok.
