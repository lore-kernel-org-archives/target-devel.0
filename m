Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1802FC54E94
	for <target-devel@archiver.kernel.org>; Tue, 24 Jan 2023 23:58:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjAXX6u (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 24 Jan 2023 18:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbjAXX6n (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 24 Jan 2023 18:58:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E1446D6F
        for <target-devel@vger.kernel.org>; Tue, 24 Jan 2023 15:58:38 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30OKtQDt022131;
        Tue, 24 Jan 2023 23:58:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=VkmYIV0Q4yrxVbXB4qmDofgFz+ia3JNaaabG177NY5U=;
 b=gQNcTWuAuxu1xnED3qJXViiEWWUsxfIQrkz1NLQm30GLU/3F45L3BkeY5d5onf85jVhX
 4dh84+4v2KnYvbklT8yhNRp3ICmvA7fH1NAxo1P2N88U2IW8jWyrar6swY13z29HPXWv
 QiY4Ma/wLh0QqKi/zjKG6IBsCzqQWJjX5mTbRqFNvcjHFZvZ7QaoQNl7Pgu6YupSj3mo
 cWOperSOa92g2Mq7/Rr6zjBx6JNU1/l+WxvLzAC0XD1Jy2ilQ4cQ5Bve3UFcLPGTsP8U
 VHwl8R/zLcDucB0HIeqvkKpGGhFlAxkLAVo3SyHDqbbGkDBGaugqyl4ADTQee/npDa29 Zg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87xa6ren-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 23:58:35 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30OMOxAC021287;
        Tue, 24 Jan 2023 23:58:34 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g5pv6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 23:58:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DdaqQkd9Vs+8PpYHo5Zjpr8vs7gD2Ngo24NZg1hVm9Rq26+vjJ+dyaPPmWHnoVnh13K3/Z2Au5CHILULS3ILNXolQFGaWeLlOGWnPOJBPNSXFJ9k9rAGC0GvTBcyvE0LxGBsSfI3fbOgtr+jJt+4Y8Xuth1KqV1HR1vs/OO3Xq7ovB4Y6vInsZGWg/CAF+jUZ5r9H0R/Ml7TSszBjGd5r+b/dq/t5S61G1TLejx1Or/z3aCd7OOyD7R0q0ItQyf+5KVN4GLmxuV7SAy6+oY18Q0S6pUeOJE4qLZwma4a5N5zlqxCJgNty8WK5J99yaMrqTlovwY0vd7j16+24HSlTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VkmYIV0Q4yrxVbXB4qmDofgFz+ia3JNaaabG177NY5U=;
 b=hP80zwoqDVFUvgHt5GbgVZQtgKBHnKAYr7WdTi3dc07h2gc8/wz5FgB39djjmZeRllaV0n9zOP1cyQw8kjcorSQAmsusH/pCLkH8BgBT0zdo90j0HLn7apNrkHMZl75bpyGAwY4mDppxlq8l6QgiExOcgl2MJsPsjQnk763VHPR4R4xbuhoEsMcfD8wVwFjIv94YxlQS+jvJFHDVU1xa9spvafeMhXD50T+ernQ8uBBoPd4NYIiqlrUejH0pnjDZXcJ4C7rgvpXNvvwTD/0D2KkPsxtiuMlxX7H4IAfKWMnF+aYvQhidJyemty/7ZT7HWYl/ptx300PzwR2ddZn7Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VkmYIV0Q4yrxVbXB4qmDofgFz+ia3JNaaabG177NY5U=;
 b=k1c80ML+nnvqD071bQON/SO5VZaiTA+Ry5PZYU/hXTlcQkrfLjO4j+l1y/R41+Lwz4tX12ETp/EvauoSwLxXKEtWe1DleWwXj8QJGPmOuInHFzi6jvsC8y9k7kX0P9xfhecOWjoB76+Dm5jAMVDoVv0Yl9lt5X9BknCVVLphmqs=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MW4PR10MB6463.namprd10.prod.outlook.com (2603:10b6:303:220::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.17; Tue, 24 Jan 2023 23:58:32 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.017; Tue, 24 Jan 2023
 23:58:32 +0000
Message-ID: <0d52151e-f3cc-f1a3-0e6f-2144ab588189@oracle.com>
Date:   Tue, 24 Jan 2023 17:58:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: iSCSI target: kernel: NULL pointer dereference
To:     Forza <forza@tnonline.net>, target-devel@vger.kernel.org
References: <cd1ab2c.ace55083.185e577f69d@tnonline.net>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <cd1ab2c.ace55083.185e577f69d@tnonline.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR21CA0021.namprd21.prod.outlook.com
 (2603:10b6:5:174::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MW4PR10MB6463:EE_
X-MS-Office365-Filtering-Correlation-Id: 97fe536a-62ba-4171-574b-08dafe66e5ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c9g6CQTHQ+WCqbIp1feK2lAMe/FNpjNf/7YttsL6dqA4dyHKpwjgCqAPBn/YUrmpYCGA/BeNmhSk+ANqkXzKvsc1RGDSiVCCh6NIPJgtERrlV0TPyP24DpEEFa9RlQBLYzZ77neTB9mFI9VYIddvdlB2koI2H7kaxx2jbvBqjD+BdAuJRxrPvCpwPvbC/zbHWkwNMSm8qgH9WZUuXmr2qmqBqEuRWN7lQXo9j7nUS/ysK7QuiqmfHQJOG71nAEWoVLmJTYFJHUaQJAPsVSEN8CgSRvNW+/ybmfRZSE4Oq20ZtXHz0Xhl1lFurooGpHmMF9kuxkwYjY5S0Dx41Uf2a1XYIOoSjSGg+CT/rWURQXJXWXy1t8FM+FANSJHOTGtc9dgcRFfYLBuXevKfnjAceFTWaRfJX2joAw2Uvdp3j9yPXoafKKW8JksRkXY31UvVSGKNakqKNDvYxVTWMT+tMpeh1du1wW01ywFoDrGmeowwX1JLFcIEfkaegu0dBj81ddH0CgqpZr3vveuTW0EntpnoMqClRaZjBqtkJDA4p+LdX2e4929AfoMHAIRB9yLGIKJ/ABOSUBEnWnY+mjm2hWl4cmZRZsB5u4viGBOeYcYo/rVTg7sigZ6NIJ5CYWopSC/r3Atcq3h0F3lDrDrj59+GFwhoaipEt3iaHBFMA6ADF/6qJH0QtH+rEAUF4M5fCyOigw6Fp9/PQXC9y6gavVM5KFG4+nBmoNUcEpfDTDr3rrigkKOVaE5z+IWyvMxBsiTVQmceWIntG+shuDEKmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(376002)(366004)(39860400002)(396003)(451199018)(8936002)(2906002)(5660300002)(478600001)(26005)(6486002)(966005)(186003)(83380400001)(6512007)(53546011)(66556008)(66946007)(66476007)(8676002)(6506007)(2616005)(31696002)(41300700001)(86362001)(38100700002)(36756003)(316002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SEdyZkRmQlVqRmlJaEpHSVQyRU5Ybit5ZWgzL3JZMDMzREFQNjYwRUR2VnJr?=
 =?utf-8?B?VGsva0ZXelZGSUFYeEpRMG4rdmRyN2NwWWdOY1VIZjU5dkRHbEdOUDlVZUhm?=
 =?utf-8?B?MEJCRmlydEpiSGYwMk5JZnJIRkZJdWdheVFUMWpmcWdIa0RvNDZNVmIyam4v?=
 =?utf-8?B?L2d4bkhhTDFPaGlPUXNkT1hLcTByRmF2ak8yUVFicEpIaU5GMGVHakI4R0Mz?=
 =?utf-8?B?STlPRndqZldKMi9hZFYzSTh4QjFmL08wNDFYK2lVMFcvUG8zaUlXditMbWQw?=
 =?utf-8?B?aDBCRFdrdTk5c3ZqT0k2ME8rNWNHTmozekNkZnRsUnpKdGtucDc2N3UyR2RN?=
 =?utf-8?B?b05yZ1BDWXNUR0tGSUtxSFRwbkd3bkJJb1NGMDdFaEtDajdUdFNBdzJPUWpX?=
 =?utf-8?B?ckZFa2RzRVNaM3M1Wm1ZQXBSS3FFbk9rM0NkQnpEMkhHMXdFWnlMVTN0cG8z?=
 =?utf-8?B?LzdONHBYY3BXMlhtMWpmdEdJeDNuSXpzUXhaRmVwRFJxTm9SdWJyelM1V2lw?=
 =?utf-8?B?cEdOemFwUTRGZW9NeVZmdWZTb2RkNzkrdDdackh3SzI5UjdkaUZYNVpXN0Fh?=
 =?utf-8?B?UXByZjhQb0RWTHM3d1hNd2V1UzJaSklwNkJ3SlF4MHFPNy9VeUYwZDRlNVA1?=
 =?utf-8?B?ZEdqMmxEMktHeW1JTWZwYmhoUWV0RmdzQ3B3d0MwOWNMZGNSVUFFOTVmOWVw?=
 =?utf-8?B?Uml4K0dTS1hxSkZKM2lPeTZoVXAxaXB5ZVZoWnhvVTJZMmNjL2FVZWFqMDgx?=
 =?utf-8?B?K2VzOUVNaWpSOVpTelhTa0t6NHowRHRYQ0VFeldjd2FJeVI1Nk9zNGhzTWkx?=
 =?utf-8?B?RGRtQ29NdjY4NnVyNC8yRU9MTzZnOFF1NDhPcDZ6M2p6UnNnUEFLRlZ1bmtL?=
 =?utf-8?B?Q2FKMVJKRUxKRVUycUJEWTdxL2E3RzVidnBkV2tJaFQvdUpkbjJIUFpyMGZt?=
 =?utf-8?B?NG1BSEJpZzhaNTE5MnNLbXJNM0ZDUExNTllRSzN4cmwwM1lEMmluVVJhWC9a?=
 =?utf-8?B?V0diVm5EN2VWeEVET3hVNy9ST0c5aEpaQWc5Y25PSnlrZjJNT1NPNUo5UzJx?=
 =?utf-8?B?elM3UGZVUW5BQ2VJYllXZDhrMWdqeUxKMCtkOENFeXdlbDFyQ2FlbUJrVlhW?=
 =?utf-8?B?Uk9sRDBBYzd0L0VkcUM2dXJRTFNnck0wOVV0THlDR3U3VG00bU5YK2NFSEtl?=
 =?utf-8?B?K2ZPbURUaTVLN1R4MEVyaEVlRkNldkxZVnpHMlFVUkg2LzRmdlljejVFbktz?=
 =?utf-8?B?RW9XQkhzOGtHcHhQbTdZVEw3TGs1MURrbmlWV1pySWtkalhEcU85cHlKMkx4?=
 =?utf-8?B?b0xzbDJCdmFnbG42cXdIN3lNdjJ6b3B3a05uL1VqRXo2ckx3TkFHRU1SOEwz?=
 =?utf-8?B?MWUxd20ramdjL3llckM0dXg4NHB5NS9GM05MZXRHUFppTnUrVDVDK0FhQ1Q0?=
 =?utf-8?B?c2lIK29oSHFidmNTcTFxa0wxTmplb0QyMlc1NnV1VG5aOUwvUEw3czV4NWlz?=
 =?utf-8?B?RFlWZTBXR2RKcjRyY0ViSkNYUFI0N25uWWpqUGppSTA1VHBIeG81RlhaTWZC?=
 =?utf-8?B?UnozTVIvZHhkcDk4ZnNTS3JUbHhsdGZOMnBkbkZJNm4xcEkxSEU5Nk5uWWxl?=
 =?utf-8?B?WlF3ZTN5WmlENkthNHJtODA1Y24zTEJQRUkya1lqR0Rldmt4amZzTHFlNlU4?=
 =?utf-8?B?ZzJrZk1YUEw4VjNHOGx0MHNaSkVGd1VweUVRRkFXYlpobzk5QW05Tkt0OWZN?=
 =?utf-8?B?VE5nN3hyQmpiYUxqaDV1NHdBZmZtZGdweURTYUExNExkKzJTN2pqd1ptRTZJ?=
 =?utf-8?B?NlJBQVIzNkpRSWlDeHYrWForc2x2Nlpwekh1TnJrNE1ESnNBOU5lekVhcEhk?=
 =?utf-8?B?azFhVzNiZ21iKzh1TmdTQU4yZ0lmMzByalhtQWM0dHZYcmd2VlNoc0JRK0Za?=
 =?utf-8?B?d3Z4Rk9qeW9pcm1ZdVRqOU0vT2syWnRtcVM2eVRIYlJyZEdJZEFZRzNwYThD?=
 =?utf-8?B?aXVWMFRoNmFoNDlXa0UrcEFVdDF3K0dMSG0rejdiUWNlK1BOZUN2M3dxcEY1?=
 =?utf-8?B?YXNlU3VXKzFMb29yRWk5aFdja3FDZjEwMzNaWHdaalBhVjlSREFrUmhMUGI3?=
 =?utf-8?B?VkEzbDNBV0FtMXFHK0trQUVKZXk4Tk9TejdVeFdZVFZNdlhzcEhhdUpPQytD?=
 =?utf-8?B?eUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 7StVg/AgyXAL301H/DLUAEp7Ry07EcIq6mMB7O1/t/Kzw91pC6R2P3au9EkyYQ9awZtylT9tv1OpQ/iZWn5EaPRkZfG7dHzjXfMW0MtsLh5LLXmNuUdea3BSQV+olJuOLcw8nWvP0iqyetnikFVfjhnaVa1U06KTDObXqSWSXQxSRZQmb2DRvNov/OVAVsfXih6kkwP73mSqn4Fw/BwjSKHUq7JYt3tINs1dX1LrrMwFwwGiPZqYzdxVCWJq11Tqu19Ja5DdTWpUXIsQAtKLzDYscoLEi4SqAg0VBe2gyVoHYOrLonpgI20t18zG4pA39I+84Q/j3nRxJ35+X1wPZvTjRC+q+c+NnFmvYr+FLR8ElYmRVHJG/12RnTU8Lm2qYdSq41nr1rqX1rVBKFwKm8C8gsqFu9qDAS1275jyUkrlceRzIVlFu+P7dKsw7BcwkhZN59b3yQxZjyCKsqBu6vGmw/zjkzTwlh0zjbaHu5xAvElQvdyVN3ugiv39nYECErJcKVoE8LBr8H33r0k2FZAZPQZcpAQ1B/p7SZN7sOaER9J8rK9LrnG7LhSpDSArcxZrZcYCY8xjFA/oufGZmDlRChC5jQKnB1gwjCyL9CJPrwTm8E4llvfsXKtCkWsBxd73rnDB8HKS1YuybdGUmFdTLaz/cQNUvgcFvq2K792EdPcBPS/FLoT3hRaPBlLP+z8W41g6sFW993ogv2elwHxS1e6XPN9eoJeAHdutvvAfvGYw0eZJfOxpUsWhZP/nKAjSeE+qqNtR/v62O1BB/1QD4LH9m+Ct3Kp8y+rjIy8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97fe536a-62ba-4171-574b-08dafe66e5ce
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 23:58:32.4158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6hK/de7+xVUkXrBypX+MPHuGl4Pz3NDIRE2+J/9J3bjUqX0SFO/7wc+0ZaMWrYt1md8QtOremK9Jg6qJBaKR6+KtbkJEw7zI/YROwaPXTXM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6463
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-24_17,2023-01-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240221
X-Proofpoint-GUID: zXkdH_moXuyYpcA1DRpf07132o9hpgXj
X-Proofpoint-ORIG-GUID: zXkdH_moXuyYpcA1DRpf07132o9hpgXj
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 1/24/23 14:28, Forza wrote:
> For the past year I have been experiencing spontaneous reboots with days or weeks between each time. So eventually I got a tip to enable pstore and was able to capture several traces, and all are the same. See below. 
> 
> I am using Alpine Linux with kernels 5.15.x all the way up to 6.1.6, but the issue is the same. The issue seems to be mostly triggered when Windows 2016 servers that have some attached storage are rebooting during maintenance. They do not boot over iscsi, it's just extra storage for some apps on those servers.
> 
> The target backingstore is using FILEIO ontop of a Btrfs filesystem (i.e. no pass-through to sas controller, etc). There is write caching enabled, but it happens even without it. I opened a report on bugzilla, earlier. There is a saveconfig.json from targetcli attached there: 
> https://bugzilla.kernel.org/show_bug.cgi?id=216959
> 
> The issue seems pretty reproducible, but I am not sure how to debug further. Please advice. 
> 

Are you using iscsi's multiple connections per session (MC/s) feature?

If you just use a single connection session or multiple sessions with each
session having one connection with MPIO does it work ok?
