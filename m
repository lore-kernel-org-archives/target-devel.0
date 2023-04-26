Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2375C7618E
	for <target-devel@archiver.kernel.org>; Wed, 26 Apr 2023 15:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241262AbjDZPfS (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 26 Apr 2023 11:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240786AbjDZPfR (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 26 Apr 2023 11:35:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419BA35A6
        for <target-devel@vger.kernel.org>; Wed, 26 Apr 2023 08:35:16 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33QEiPAx015480;
        Wed, 26 Apr 2023 15:35:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=OvkKXEJBrrtxKECSBny85qq3NkqJsu4CTAQbZ3MJZA4=;
 b=K3yq5JGVYT4F5p6zH8PjEkI7NjVyp+CYYvaJfsj/jEXZarmc1V9MEX1oa5jhYn9W0UDe
 YY/36MEx9ilPzq8a2CvJ0sK5kaZUywTP/aso1A7d4mKH9WMKalXbZ+PWcX36C72/WUqD
 P2BJooHcuL9V8vyxUTcS/sw9bQyK+PUHtNfaME8cfn8zP5QCMOPKoMHqBpDDYweyCBCQ
 eD/6BR52MSGVMaf4/8ffZLba4Q5LSIe9NgQP0uiGuDZZppR4P5r44//o+Kj2M74FG06H
 D8p6dykTFmAcvVra1nzUgUKD4CAX9eLe3ATImgnToMyEMO+2Wh0QqVhnbkTWYneDOZ7I 6g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q47fasnxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Apr 2023 15:35:14 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33QEOXLY006752;
        Wed, 26 Apr 2023 15:35:12 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3q46183wej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Apr 2023 15:35:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RAMyI6mkBiiFpT3HK1dAbfLMPFD8xeN9r3GLjtLwnQnoDdR0g/u7NYvoweR/ckqBrbtkV4Yxu8dTu4AhtCgOmoGvZXnpCZHBvci61zbwgambn/GJKMUjPVpXrsQ7SeHnYTvCDh0NS/RRHbVh3G6zBCElibkXpXf2aZrO8FKGHlBnDw8Yeqyco4bCAt8A/ykhpj1Ggl6iBtT7q71u2R3QAYKL1BU0yKGsd1cUfNmKaukjPoFJDDcef57rIH4wdGmu5goPbvzUL9pSVLnQeqK6UKtA5J49wXWSkj0Yl64AXca37JxeNR46aAcOrv7+Ktl2DrLMI9ss2GkhYngiKwr4WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OvkKXEJBrrtxKECSBny85qq3NkqJsu4CTAQbZ3MJZA4=;
 b=F0dzAcI7oBnRntn6BY8m1LbNSdpsF1VMPmzsjj0Fm2nnl0KWuOCtBmHAxFRKiSWm3+GlhbL9QdLvCtqMdAoHHvAVum5ljwvuL2INChPymlAB1iBJzepnihH86f+fJNvAgS9wft09plgWeSGbQKUhMa2XC4p+4Hru9Nu8x629znF8lIN7DULGwy0dR5+NCyuTKxIpucesvYVVtRY4LDUe0Yr9XGNAhQH9LUmacFJPaNC2rkIIvRavVGjO/KKkCZvGR7JEAuPgZSgtcE9CmvWXoEzOmLJZPylUgC9eSGodoZMltC9LtWWOo4Efza+cTBYA1C7cUR5PktDKpQgebUoLiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OvkKXEJBrrtxKECSBny85qq3NkqJsu4CTAQbZ3MJZA4=;
 b=bEZwA3FCYFvroahPAkIHh8o+Qi1h2mbvk0XktV4XlY3b6QL1NYSKpGGsTCWGLg9U7Z7ht9oQ+zOSbIoaU5p78NQBnPCZVGbrNi5nOl98KvMz1u5IOydxXg3rogWQySk9jpDGAd/WhX8JHxq7CK1RKAdB/fvAmx7hEk6qL+wu+Iw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB4369.namprd10.prod.outlook.com (2603:10b6:a03:204::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 15:35:10 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::264c:5118:2153:91ef]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::264c:5118:2153:91ef%12]) with mapi id 15.20.6340.020; Wed, 26 Apr
 2023 15:35:10 +0000
Message-ID: <6ecde91d-aa5c-0123-ba2e-dde093dd056c@oracle.com>
Date:   Wed, 26 Apr 2023 10:35:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH V2 1/3] target: iscsi: fix hang in the iSCSI login code
Content-Language: en-US
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org
References: <20230417171801.208122-1-mlombard@redhat.com>
 <20230417171801.208122-2-mlombard@redhat.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230417171801.208122-2-mlombard@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR11CA0049.namprd11.prod.outlook.com
 (2603:10b6:5:14c::26) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BY5PR10MB4369:EE_
X-MS-Office365-Filtering-Correlation-Id: 55b3e0eb-aaba-442f-bf37-08db466bd208
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WbqfVW6aayNHkOdIJlFqYcqi6zHtkvCBsbfYWnGL2IbRMEvhTQiz1+Xht0r/JImM4n0Y5eUeARJKYdqdhwAlA0cTZgonGvcuELYiBmCXtMIR9XxOhmM6fx1XTcVsE/FDx+50vuReeRSKWcKtRax6u0zEEmMUAB0lnzVcqbLQ2HtkV4uhW0XJFZpnytqYcBcm58zK0fyA9hZ5YRScVtpIknkMYkTfWpZjzde9GzBglLLwQ961AnXBtt5X8+2Bbb7DxGWjMeTqCECAvjTy4/7FTDH5DxIt7R8h3mXmL3EFVVsvlxHUz6gpseNjpYjDSH+RgaMwRKQlBokaLOiAFgJUWJtRS9tmMvN+NrXaQ97RFh34AF86+GbJBnB4RdcX9B455+3L8+0uce6uzaaRGgsUL2gquEW9lfFWPuC48sCZTmcYJ9kNrAIQyHR+8pWjK0WiANlxBkHDTUI1YJRBL/PRLlnvE8kZ7B7EwvWw0QgNSQAfEeWOPnrCMIUHyDi5af6iU4vDq6BmwrdgQoRCXdeBG3ZwVeoFPfwsqI9wqBk+F0fbovQRSSvCNP/cITwiHpZPI6KqVkvPs9U7qodEwpFJoSb4mEIGFzVx8uBR/iSaFnWAMYU4bvjv55vfTbAA7Imwn/Bb649dypbmnJFIE6ENeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(396003)(366004)(39860400002)(376002)(451199021)(38100700002)(26005)(6506007)(6512007)(186003)(53546011)(83380400001)(2616005)(2906002)(8936002)(8676002)(5660300002)(36756003)(4326008)(86362001)(6636002)(478600001)(6486002)(31696002)(66476007)(66556008)(41300700001)(66946007)(316002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RTlLN1lrVkxKU0QxM3dKRlFxUTF3d01acXBSNUxFdzV3VGd2MDNaei9lbDVx?=
 =?utf-8?B?L0ZzNjJtM1pDOE96TXNzK1o1YlBmUUl2MjlvZVBWZTlFU0ttU3JqcFRtWElw?=
 =?utf-8?B?V0ZabGVDM2dQUmt2OUE4bXlsV1MwbjN0VlhzUXlPRSt1dWU4QU1KaVZvc0p3?=
 =?utf-8?B?TGFkMVZzK3N4Z05QRStuUHJSbi9aN0pWb2Y1cW5LcUxwY0ZRTXBYS01ZeXVM?=
 =?utf-8?B?ank1d2QxNkdRMnNsNFV1NnZxTGxGbWJtZnIxMTR4VFViVzlUQUR2VVdzZTRK?=
 =?utf-8?B?R3ZzZVZxTmorTExZRS9VSGFUbVluVUMyNjZaUzJQZGY0andOU3piaDFLRzVS?=
 =?utf-8?B?azlhajVndUVMRkh1SzZMZXkrUkFEc2R2S2MrMnZ0MlVlMGxhTmU2NDY5Q09q?=
 =?utf-8?B?SldGa1hPb0F6dm1reE5rcWFwTmljcDFOS3V5bCtsenF4a1dXelhaZDRjRHFk?=
 =?utf-8?B?aDdCTzRGL2lnZ040eVlXR1J0RDJWVHhHS3lhRVh0elhuQVZraGVMRzNISXYw?=
 =?utf-8?B?R0cxNXNBa20yRldHOW9admJhZ2xFSUdiQWtoZ0QyWWhGS0FZVUdUWkI3bXJ4?=
 =?utf-8?B?VmplaVlJRHpTUnVSTCtRNXhxR0FCaDRMaG9zVzh5OTdjMmszSy9LY3ZLNUdK?=
 =?utf-8?B?NGlneE9sSm56dk5QY2d1RU9IMVdzeUNYT0c4UyszamNkRjVxWVdNWnRzamFG?=
 =?utf-8?B?NldDYk9vWm5CLzRkZ21wQXZjWGNKaUVobDA5azdLcEZPaVdBRndZcTdFb1J5?=
 =?utf-8?B?bTBYL2hMVzVGcVdMUE45ZnBlelQxWkZmKzk4aTUxQ0RRVjd6dFRKbGtHUW0r?=
 =?utf-8?B?dEhUV0F4aXJJUVRsb1hVajdtZkZ4WHVmVU0yM0dZVVgwYWZseTFPa1JwV3ZE?=
 =?utf-8?B?S0tGWSt1Z3NwM0pyR0hYOWhJdXJjWmRlRHlVZW9FTE5Pb3lIZTlxdnhPcXl3?=
 =?utf-8?B?UWZSajN5VDhHSk55ejVUVTczN0RrT2NqVUx4QmVObjByWE1VREU5VUdNaDNE?=
 =?utf-8?B?Q25VN2lwRWc0Y0NxbzQ0YTJQUDdFUlUzQ0t4UHBiSU5mNzQyQ0c1aTU5eEcy?=
 =?utf-8?B?R0hIbVFNM1FGYUhTVHJpeFZDalJWUHEwdktZeUJiL2o3QlJJT1Z5empDcWxv?=
 =?utf-8?B?MHpIOGlPSXVFRG15ellWRitaVEF6VDJzZmFJVThtdThLRGZsYjRmRG5VQ1Z6?=
 =?utf-8?B?Nk5FeHRPa2ZtbEZxS2hxUW5DbGJLcUJIdWo0Vm5FRWgwUmE0ekdONHNsQitB?=
 =?utf-8?B?MEZwU042UGRPM21NTWo2MHVBbzc5U3hGNzk0eU9yNEZ5S1ZtS0Q0ekxlZG1X?=
 =?utf-8?B?clMwQU9zRUtYTjkzUjJEbk5XOU85aGtiKzZhc20xMW0vOFMrc1F6SXJkbG9X?=
 =?utf-8?B?V2Iybm0zcE9zbmNLMXZ3Q2tiUUZmK0w1T1hNaXFRc2ZLT255Ri9EMWhqOHJS?=
 =?utf-8?B?eG04aGZieTNhTGV0Yllkelk4a3Z6Sy9POTVZVnovN1NzUW9MVkt1bllSa3RW?=
 =?utf-8?B?UUNPU2ZFWlk3V1N3ZEVhQjFQU0JGa0xscXM4UEFtMkN6VkxRZC91NkYzQjRV?=
 =?utf-8?B?aEJOVVRMVHllZFZUMmNPaWVPSXlIT2RGUHp4cnNyaUltR0Urb2ljUUJvbnRT?=
 =?utf-8?B?YkNRV3hEM044R2tpUFNQeFdlenFSMFcrZTJ1RnMxcG9wUldQVWVPeFhJNFY3?=
 =?utf-8?B?OWQ5SGJPVW5VUjROUTI5U3EyZk9mcnNzMTNwWHBXTXRlcWtnL3cya0ZwczJJ?=
 =?utf-8?B?clp3ZFlPeDk5MHY0RDFlVllmSi9OMyt1TnZNNzVhd1kxU2F4YkExY1ZhMHgw?=
 =?utf-8?B?L1V1M1hiYllORk1KUXBkKy9RUTVmV1dHUUtETktNYmtScXlqZG1RSGJkRHJK?=
 =?utf-8?B?SjlhSFdRQmlrb282U3dVSzd1SWxpZnZnaHRabEl1eDdxOWVBTEswK2ROODky?=
 =?utf-8?B?UkxORVhDT21yUkwyajQ4UDZ1SE5BUGhEMTNCNjRLWVk2ZHpGaXpBK3FkRFFR?=
 =?utf-8?B?NURmSFFuZ0RpS1htYW94Z1dKN3JxSGRYZ0ZSNGxSL3FKa0ZuRWxaeHdqaUds?=
 =?utf-8?B?aHhZdnIyTDRrQlB3ZVF5cUpUNnhLby9ta0NMS2hxRzYvUmtxYS9Ha0xTaFlJ?=
 =?utf-8?B?bVVlbnluL1E5b3RPSDNPdGdCT3pTR0lXVWZsYy9qSVRIQVFUZzluYUh2Ry9x?=
 =?utf-8?B?dGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: KLcHAlHvQtu5ds7KRYZSKcOD7aUdJ1Ig24IicKlERXP21KyxK6xizpZMCzIB1k9IoXckaZAAS1cPowmU0OGKKbegXBrvieHjaMjpNcXTrAnSRvJh98cIAaOBIBt9pjrEyI9uHywiVPrY0D79gX5iWpLOrfdIa96wNPSw7KvPxI2qf1/aWxZionfoDl0DauizhW0k2axmB/pEGRoUicTcqPlMhBq+qZWFTZlpfh/hKYNrUB1svrkDuCahESZzI5DUGQdlrxXqPsp/Ur0fAz/u8rPY4CCLt+S/MkHYuounpGFKlPmuW/Jm0tgIPLfLkNerPOyqsXLTZzLNJO9c82fM8dDUgTba8dE7620V5DKw/R49oyfXgefvo8efPQboY6MRWZo9TJjhNJ51fRfiw0Otx382Itf0Tmt0G6VzrpXZbhSUeKqcbtNGwzru1oITV6CA2yUkhLFHS5XtrKPVgn92e0YAWjsAarFrKkYLvv02Lg6Zyt9RrJcxt1x3bBt2bi3r+lcC7W4/SzEabylaxocM5pH59V0mVA6OKcs6PgShATRqzCjbk4zSHJIHh2dJn8x5tTsrNuHcibX3tO3Q119w1MhhoojZNgyrR49eznpMVWGStCGYgcxo/y4PhRlTx5uOMAcU2J8wZMS/Pka3taB6eTcbLdJfy3TtsvDem8Z07Ylgq3L7LNfrl9I3a4fytCH3is3fmq7pw7fAh6zMaf+lUEtm1VaIjfKiemk7u1pD4s4cTIq4kVauTcjsUbWRzKq08PKw+DszUTN9iuSEgAB7oePFdwFVaaSUcmJbuAtA7fw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55b3e0eb-aaba-442f-bf37-08db466bd208
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 15:35:10.4012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E9KTz3rrKNvhhvCnhL5stwAxu8Xk80yTEBJUMfxIlzIeii2NUE88seXA8++mEWT6xBp7KmbMkHF5kvPkT/h+Hkl6q5XasTsttS4hwxdv5MA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4369
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_07,2023-04-26_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=842
 adultscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304260139
X-Proofpoint-ORIG-GUID: beVOa7E8yEGQ2pIXgzj2N4EabAjnuGMZ
X-Proofpoint-GUID: beVOa7E8yEGQ2pIXgzj2N4EabAjnuGMZ
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 4/17/23 12:17 PM, Maurizio Lombardi wrote:
>  static void iscsi_target_do_login_rx(struct work_struct *work)
>  {
>  	struct iscsit_conn *conn = container_of(work,
> @@ -562,12 +543,15 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
>  	struct iscsi_np *np = login->np;
>  	struct iscsi_portal_group *tpg = conn->tpg;
>  	struct iscsi_tpg_np *tpg_np = conn->tpg_np;
> -	struct conn_timeout timeout;
>  	int rc, zero_tsih = login->zero_tsih;
>  	bool state;
>  
>  	pr_debug("entering iscsi_target_do_login_rx, conn: %p, %s:%d\n",
>  			conn, current->comm, current->pid);
> +
> +	spin_lock(&conn->login_worker_lock);
> +	set_bit(LOGIN_FLAGS_WORKER_RUNNING, &conn->login_flags);
> +	spin_unlock(&conn->login_worker_lock);


I think the locking bh use is reversed. You are in thread context here so you need to
do spin_lock/unlock_bh to prevent a softirq on the same cpu from interrupting us and 
running your timeout function which would try to grab the login_worker_lock.

iscsit_login_timeout is run from softirq context so you wouldn't need to do the _bh
calls from it.


>  	/*
>  	 * If iscsi_target_do_login_rx() has been invoked by ->sk_data_ready()
>  	 * before initial PDU processing in iscsi_target_start_negotiation()
> @@ -597,19 +581,16 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
>  		goto err;
>  	}
>  
> -	conn->login_kworker = current;
>  	allow_signal(SIGINT);
> -
> -	timeout.conn = conn;
> -	timer_setup_on_stack(&timeout.timer, iscsi_target_login_timeout, 0);
> -	mod_timer(&timeout.timer, jiffies + TA_LOGIN_TIMEOUT * HZ);
> -	pr_debug("Starting login timer for %s/%d\n", current->comm, current->pid);
> +	rc = iscsit_set_login_timer_kworker(conn, current);
> +	if (rc < 0) {
> +		/* The login timer has already expired */
> +		pr_debug("iscsi_target_do_login_rx, login failed\n");
> +		goto err;
> +	}
>  
>  	rc = conn->conn_transport->iscsit_get_login_rx(conn, login);
> -	del_timer_sync(&timeout.timer);
> -	destroy_timer_on_stack(&timeout.timer);
>  	flush_signals(current);
> -	conn->login_kworker = NULL;
>  
>  	if (rc < 0)
>  		goto err;
> @@ -646,7 +627,16 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
>  		if (iscsi_target_sk_check_and_clear(conn,
>  						    LOGIN_FLAGS_WRITE_ACTIVE))
>  			goto err;
> +
> +		/* Set the login timer thread pointer to NULL to prevent the
> +		 * login process from getting stuck if the initiator
> +		 * stops sending data.
> +		 */

Use the more common comment style we have in the target code (there was some other
cases below):

/*
 * Set the...



> +		rc = iscsit_set_login_timer_kworker(conn, NULL);
> +		if (rc < 0)
> +			goto err;
>  	} else if (rc == 1) {
> +		iscsit_stop_login_timer(conn);
>  		cancel_delayed_work(&conn->login_work);
>  		iscsi_target_nego_release(conn);
>  		iscsi_post_login_handler(np, conn, zero_tsih);
> @@ -656,6 +646,7 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
>  
>  err:
>  	iscsi_target_restore_sock_callbacks(conn);
> +	iscsit_stop_login_timer(conn);
>  	cancel_delayed_work(&conn->login_work);
>  	iscsi_target_login_drop(conn, login);
>  	iscsit_deaccess_np(np, tpg, tpg_np);
> @@ -1368,14 +1359,29 @@ int iscsi_target_start_negotiation(
>  	 * and perform connection cleanup now.
>  	 */
>  	ret = iscsi_target_do_login(conn, login);
> -	if (!ret && iscsi_target_sk_check_and_clear(conn, LOGIN_FLAGS_INITIAL_PDU))
> -		ret = -1;
> +	if (!ret) {
> +		spin_lock(&conn->login_worker_lock);

Same locking comment.

> +
> +		if (iscsi_target_sk_check_and_clear(conn, LOGIN_FLAGS_INITIAL_PDU))
> +			ret = -1;
> +		else if (!test_bit(LOGIN_FLAGS_WORKER_RUNNING, &conn->login_flags)) {
> +			if (iscsit_set_login_timer_kworker(conn, NULL) < 0) {

I think this will deadlock because iscsit_set_login_timer_kworker tries to take the
login_worker_lock we took above.
