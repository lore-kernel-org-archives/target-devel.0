Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C6D1C4332F
	for <target-devel@archiver.kernel.org>; Tue, 22 Nov 2022 03:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiKVDx4 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 22:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiKVDxz (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 22:53:55 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBCC22D1CF
        for <target-devel@vger.kernel.org>; Mon, 21 Nov 2022 19:53:52 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM3PVFc005007;
        Tue, 22 Nov 2022 03:53:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Moi4lq7g8ytjaDv6g1+bckuhV9OllIW0qDW9w4IpzKg=;
 b=jy2FA+LNg2P1tIfsdPLxVtRjQpx/DYTEnLYb/TMDtYKnPBbw1c2Y8X6mcwIt3tcoj99+
 VCF47MehWWcINIkRrGROjQ+YAnODaBow6MANg75MmnekJiRkcp7cBNAaGKsyY68f+JQA
 nsvH07wSROAXWk0RoFH1mskpImeOcgKjsta4t1/2FFskessTsdCVFMVL62kSQxOj0VPb
 QWeRDjO9+Mr/GJy3IA+pSQW6WAhZMSw/pFyW8fslJqUIsfliFfUzn8PmbEBwhfwZzEJj
 IS/Z8PKpCo9OFxNa+rhTSCJCVMhsSTxruE08dEXt6xiAQQzTBkOVHRwIQR82qIpDey7I 2Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0gas0yhh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:53:50 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AM17Cxa007548;
        Tue, 22 Nov 2022 03:53:49 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk4yj6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:53:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lLQJkqkasEAVKXN9plhe0eOZ6w/owyJwwvIdK/nLbHxQsHAsKuemfpQPIggj2C4mDqoe8s8ekhLYg78L+iYGonmfDDdBASFV7RWgqii37sMpTtSY2K8g4zH2uvogT5mjBzZO6DMjrLpgDbh8KRJCCiEW3gCcfIcCMBKMVzXvdefsshou2ux7IQu1nBIQ/u7hLXJMqKvUDnJWvAt3NRXao5A9QWbN/aMKcJ6HggowTP2FvYvfhGHN8uh+QOd1TyRLWr35f4SVmFvk9v9NyBluXHUcm8uhGn7D2vQ5kvZ6ROq1JZ0U/xR3Lfsvk4Is3cs0NwuABB11V5R2o1sMr/ljMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Moi4lq7g8ytjaDv6g1+bckuhV9OllIW0qDW9w4IpzKg=;
 b=oF4TVcg/sw1ApKeqBp0oEyRpQxImgOFoEi73h6i50qQcsqi8QAURhxesx48SKkOv1IGCHK0LrOLE4w1MxeKal167uIZNdU8eLpsqnsTzDKYvkTfkLDbH9JAlVK8jF3FXj/KWZftLFDM6qpv2DcyOrLdD65EuQG5Ite4W2JwkeKC+082t3j9Hf3jo54hbRU7HNGPIU3KDkKi/bouemzypiBonWXGfO4F91acRtWgzBMVYoT0MM9CGEtKhRMaOc9N8NAO5x9Qst1LtatBcP19oxthOgqRSzlx6NUgGPPqBl+FkFK0kYraDm7YlePiEojk/uvr46nFucBa+rRxKkuKd2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Moi4lq7g8ytjaDv6g1+bckuhV9OllIW0qDW9w4IpzKg=;
 b=Fh/vradzMKvncIr9G85E745yk66p//aWmKT/sBgfBPGpk6KE6dBvfzEx2tVXf24GWpq+AG/YPxv1rieiJ96jKGJ+oktQ8tjAcoaAhTeS8KLD80NOO2pkge0Xgokz/NJ7+IZhqJjwTf7JYfao7ic0ajaW2Wb8tkmO6uGMpMfNhMw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB4869.namprd10.prod.outlook.com (2603:10b6:408:121::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 03:53:47 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 03:53:47 +0000
Message-ID: <a25ca04d-e44c-b0cf-db8c-9cbed5dd9bdd@oracle.com>
Date:   Mon, 21 Nov 2022 21:53:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] target: iscsi: fix hard lockup when executing a
 compare-and-write command
From:   Mike Christie <michael.christie@oracle.com>
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org, linux@yadro.com
References: <20221121092703.316489-1-mlombard@redhat.com>
 <7169fd19-dfd6-d8a6-be71-e92bb6086390@oracle.com>
Content-Language: en-US
In-Reply-To: <7169fd19-dfd6-d8a6-be71-e92bb6086390@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR04CA0020.namprd04.prod.outlook.com
 (2603:10b6:610:52::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB4869:EE_
X-MS-Office365-Filtering-Correlation-Id: 047a7404-3c61-4667-a798-08dacc3d285d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W4qTsgBr5xn7+OmkBpB7oe4rRdPfmWni0FYBPoeS6VJld6LzuuIdcRTfb2upr3RK9ofsqggZfgi0fbf1GaA3pFWc8/rY/3kkajXAuO8OXC03sD5vl/fOL7R/okzt8dxjI2Jgb1sJl9A/z9ppGE3YMGL8wxwRzc38z7W/1Q6Ooa6iWs14eQSZRbJC/Fvzf+mUg1JeUk4p8oapzFiObvIXZLMHgjaNpDeqwuFoHEIm+luOE5T+A/vGiMqsqm26CnEdapbIBdRaa325sy63P1WWVfA3p2cSLGCFcc6awGNhm5T75Woo/bl2DbaErnXEfK3ZTOeYIUIuaE5tKW0ym9ZOijJ400UpMkvd1MSqG0qzBLuBRIZyFs7/6duD/Sw9IogIHra2QUkOlw1jlzaZIxvX0GTI1Hzj6G2FDKEHVmWZpM6/RNSQcLsbIvmHoEf2bqk0hOB1Tlvy1GKtQSoXVrtXCj2cM1Me97Z9i2dwsN4KOtGfKf9VrvKiawIjjWBwO2VAO4LL0A6pM9rxoooSQnLMv2paDxBEaagCw/97TxZgjDXb6Yb7tK9JhA6/hcNHkQOwlhlJnUFKB1ztPxTXdh/Rvnil91CCqELbKI44O00bzHosUhTOR2iGHCP32lJ/cKPMh19NbJnW6JwGIHpL6pvXl/VO937D/Bv18UpRQAPLjnlfRKvFekRF4a0TrxnOZQ8yB+LJd784t9/ChJDQrxKmnHnsEn8dOQ767QbIIJqPZyg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(39860400002)(366004)(451199015)(31696002)(36756003)(86362001)(4326008)(53546011)(41300700001)(66946007)(2616005)(66556008)(66476007)(186003)(6486002)(8936002)(8676002)(5660300002)(26005)(478600001)(6512007)(316002)(38100700002)(6506007)(6636002)(83380400001)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bXZoM1YzNnpRY29Majhqb0ZCTk5CMFU2MGhpVmlSRll4SFY2a3lOWDJqVTdQ?=
 =?utf-8?B?eHcyRk9tdGtYTDdhbTFSUVlPeFVyc21CR21mN2o2cGo1TXgwdXlVMXJuQ0Rr?=
 =?utf-8?B?eG9jMWZZS0VQOEJnNGdvNHhkQ1Q0OVZNRW05aXhNRjJ6VFpmWXVsNjFRVjlt?=
 =?utf-8?B?V3ZIY2RkaEg1c3Q0b0lNTnNpN3lkT3h4RGtCajBPMmNmNkdTeUJzS2pPRHBw?=
 =?utf-8?B?bHQ2TlVlaDAzeEppQzFhd2l1ZTJBMU1qc3plZytNYVlYblJXbUtoeXhEVTV0?=
 =?utf-8?B?cXJKdmxEYnVRSHM5Sys1YS9nUTNGTDVGbDk2cFZvMmlkZGF6Uk1RSEo2a0U3?=
 =?utf-8?B?Z3R2eEJrZmNZRTZhTVdBcjNaZ0hzbldxNEdlMHNlTFhscVB5UE5La0FjZWpa?=
 =?utf-8?B?TWtRdEZDZkNjVDgrSVhxNFdxQVJvREhxZTljelA1Lzk3dnIzdGJsQVhlMnpL?=
 =?utf-8?B?bVFyUWFqeURudVRXTnIvc2prNmwydW4vSWxBdGw1ZWVQRzBaeS9NRTBhQUs4?=
 =?utf-8?B?bE1GcjdoOFJKNm5BakR0MExzYmdTWFNEc0JwTWprOFZ0TmgralJpQVg3Y25s?=
 =?utf-8?B?VTR1UnhYTEROYThKSVd1cFZ4TkR6NUJ4Slh4QjhpdTFVSXFFZkcvSjhsVkRT?=
 =?utf-8?B?Tm1vTFphS2ZjOHBQSlM2VnR6ZnVla2xoTjFBd29PYndSMzlKVytSenVWRmFJ?=
 =?utf-8?B?eVV4aUFTZC9ZZ0IzQTM0V2NFUThpVVBHbmZXdkRMR01XR01XMVY4b09PbXpD?=
 =?utf-8?B?SVkvN2RRa2J4UDA0b0I5WjkrRHNNUWRMN1l3RlEwMDN5VEhLVnIxSW5CL2FJ?=
 =?utf-8?B?clgreWd6S1djcEhsamRsVlZqUGdhaXJmeEdHZi9ReWo2UWtSQTlVeDVwRE84?=
 =?utf-8?B?c1UyZkdNeGJDV0dtd0RjOTMvOEhJMm1zNStFdnVBZHpSQWc1cmg3RjJkN1hN?=
 =?utf-8?B?clpiMnNhSEhyeW5ScDVxL3ZKT2thTk1PbldQaWY1QUtPWkV1Z2NRWTN5ZUZY?=
 =?utf-8?B?ZVZFaWU5TVB5NzA0QjhIalZsazhTdkFQdjlSdkNCS1NLelA1VFljQW9RSHFs?=
 =?utf-8?B?TkNuSjlqZnl1S0FkbGM1SEpLL2hYTGY0Q3FIL2JjUU00cGcyWkQvbkdGNS9y?=
 =?utf-8?B?QnBXUTJRdnUzUklOOHkxMkxLMnZObW5UM2xGeTdqQXYzT0RTL0hCdkR5RG1U?=
 =?utf-8?B?Z1RYNEpxSDVBVmVlNjNra2F1Z1B4K1NtY1RYcnpVcHl4M3pZaU5FQ1FZSmEr?=
 =?utf-8?B?WXFMQTBVSUI5bzNFclhyV3BMeEVSYko3dERZb2hYRXpjbDJDL3NUTTcxbENw?=
 =?utf-8?B?eDJqcUhPZUM0NVZWOVNHQWk5STlwanRSZEFobmREdU9XWmdxU2tsYXlaSWlr?=
 =?utf-8?B?R28xaVpyK1NCWFVIY05QcmJNdTVNdi8vbW9nZlJIanIzVGt2YnFVQVJieHJs?=
 =?utf-8?B?QUp5K1pPNy9yelJNM2NhTXcwUDRIbjEyR2FFWUNMTndmKy9Yb3FQS0dnSnVo?=
 =?utf-8?B?QzhJVmFRdXFCRFBYa0Y3cXZEcEhJd0NZTTZBdU1VNW5KalgyRkN2ZWNrTzhi?=
 =?utf-8?B?TzI2UUp1V2pzbWs2aVFsbGx3YTRWaTVKTzUwbXl6b0pYVkxDR2xUQTc3eHFE?=
 =?utf-8?B?dHBDMk42emNLNTc4Nks4UmNrcFArSjlwbDZGTzRveUszYUJ2MzhmZkV2TzF5?=
 =?utf-8?B?eENjRXdqenVvQlo3M1RtbVIzbkpsM2VWMzRQekpqN1NVUXZyajNyUUtHQzky?=
 =?utf-8?B?bWcxbFJEcmlwMnduRHpmNlhqT3l3Um1WcnJQbjFIVW52Y3h1ZTVubkZrUlJ2?=
 =?utf-8?B?MEVXeGtQcnlEcVkyeDZoNjlaZk5sUDZBU2VROGc1NlRWalAyYVdsMlVCQWFL?=
 =?utf-8?B?MFFGV2pYZUFKWUpTelFSeHV6MGg5NlljN085bjJJTXV2UGF1SUo3TE5PRndz?=
 =?utf-8?B?V2lhMlFTSmswL1NPWlN3NkRMRk1xcjJqazZjTlc0R2lDYTBrVlV5NWhYK2U2?=
 =?utf-8?B?QlZmV0RHODUxTmJsMUMzOWsrTzdyOFBTMkl4aVZKa1YvMjdGUjVUTjc5VzZQ?=
 =?utf-8?B?MlNLcCtQc201NlRxYURNajBMdzBwTzlobzFIaGNFZjdsYjBpek54Qnl0Mk9F?=
 =?utf-8?B?Uk5RV29jbzgyT0Z6MkdqcjFvNityajUveW9XRi9lNDlJYktJdXFzaTNyeG0r?=
 =?utf-8?B?bkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ABznuQVrpD1jAJ+QVKgzxjJoJjN4rxUS30C1CdizNYp0qt4DO7sy4xeCqmrtxo8LaP9kO0CcGC1tuWsVb/53AdLmbbv2QqtGGw3XYKuyr9YrybJTaoj07bxhzTKNv/oV7z1a8r0wWEKJxFFgjOoF5w0LX7BFzk8APwfF8Qs4m+FcHlAScYtKp4Q7hNJFJ3ZHzM8h/JH7OqAeEFM2Q7Ky+w0V68faJgMs9VkaoSjPrVWVywcmGBDn0FoH2m5o1amrDJrJgb+U22aZw1K6aRIyogBSS7IUirPgTgQZqImOxc5wlLtIDZIwimJjxbxr+zXgocbvsqeZX34EGzwEfR5vo03X/6oy5toy43RqP/94KHI9SggDQny/9qOY+XnLBokh0gWthELzkXOVdJY54ICmzfV8UV9cmk0xwUrDrDyTXMh8EARjXIEchYPC3XAqe0OgpMPtO2/LM/f55/LkWu2CTxEUg1XrW+HAK7BIOg6uDgGhjZOwXjjAzKqhIoQxRigV3PHT8BYWjl3U/tSm+nJpj0IQxxlEIbeYm+hhBfiPj4GDUYtVhW8pKphzPNVBzHW3s5F2mvKXZqmyC9fOtZvbqEiXObM7t9fYvqvcCO6lRG43gXOAcCZBbsX/N3rMbk9pK8SS3M66wNGhdqCbAUdiCOjjrGQ8H9k9LPFZozkxijg8jtIr4r56yGzJBBEaGNyjVtR3Pr5GjkRjfgXvQyicG6skLeE11csor0N9HRCDaT8UKPPvDeJTtdLg6wSfu1w089DZ4I/IUfZWKcdwzDbmZpq5ujhas5N4t6cHOSJRuT07RKKx5yEkM9kWDc3UI9is
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 047a7404-3c61-4667-a798-08dacc3d285d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 03:53:46.9737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vsYP9+9d7Zuj6X0Sk9CPsvR03ABxT2yGUnKjEE3Usr7jB1uYva8isWKDWkOlMzKT8UxTc1juseOO/bP5o6YGCMQxVDEV5THayDzoZqhniP4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4869
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-22_01,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211220026
X-Proofpoint-GUID: bXabhSoRn3jXxAoczwTzQ5binOTJxZF6
X-Proofpoint-ORIG-GUID: bXabhSoRn3jXxAoczwTzQ5binOTJxZF6
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 11/21/22 2:02 PM, Mike Christie wrote:
> On 11/21/22 3:27 AM, Maurizio Lombardi wrote:
>> While handling an I/O completion for the compare portion of a
>> COMPARE_AND_WRITE command, it may happen that the
>> compare_and_write_callback function submits new bio structs
>> while still in softirq context.
>>
>> low level drivers like md raid5 do not expect their make_request
>> call to be used in softirq context, they call into schedule() and
>> create a deadlocked system.
>>
>>  __schedule at ffffffff873a0807
>>  schedule at ffffffff873a0cc5
>>  raid5_get_active_stripe at ffffffffc0875744 [raid456]
>>  raid5_make_request at ffffffffc0875a50 [raid456]
>>  md_handle_request at ffffffff8713b9f9
>>  md_make_request at ffffffff8713bacb
>>  generic_make_request at ffffffff86e6f14b
>>  submit_bio at ffffffff86e6f27c
>>  iblock_submit_bios at ffffffffc0b4e4dc [target_core_iblock]
>>  iblock_execute_rw at ffffffffc0b4f3ce [target_core_iblock]
>>  __target_execute_cmd at ffffffffc1090079 [target_core_mod]
>>  compare_and_write_callback at ffffffffc1093602 [target_core_mod]
>>  target_cmd_interrupted at ffffffffc108d1ec [target_core_mod]
>>  target_complete_cmd_with_sense at ffffffffc108d27c [target_core_mod]
>>  iblock_complete_cmd at ffffffffc0b4e23a [target_core_iblock]
>>  dm_io_dec_pending at ffffffffc00db29e [dm_mod]
>>  clone_endio at ffffffffc00dbf07 [dm_mod]
>>  raid5_align_endio at ffffffffc086d6c2 [raid456]
>>  blk_update_request at ffffffff86e6d950
>>  scsi_end_request at ffffffff87063d48
>>  scsi_io_completion at ffffffff87063ee8
>>  blk_complete_reqs at ffffffff86e77b05
>>  __softirqentry_text_start at ffffffff876000d7
>>
>> This problem appears to be an issue between target_cmd_interrupted()
>> and compare_and_write_callback(). target_cmd_interrupted() calls the
>> se_cmd's transport_complete_callback function pointer if the se_cmd
>> is being stopped or aborted, and CMD_T_ABORTED was set on the se_cmd.
>>
>> When calling compare_and_write_callback(), the success parameter
>> was set to false. target_cmd_interrupted() seems to expect this
>> means the callback will do cleanup that does not require a process
>> context. But compare_and_write_callback() ignores the parameter if
>> there was I/O done for the compare part of COMPARE_AND_WRITE.
>>
>> Since there was data, the function continued on, passed the compare,
>> and issued a write while ignoring the value of the success parameter.
>> The submit of a bio for the write portion of the COMPARE_AND_WRITE
>> then causes schedule to be unsafely called from the softirq context.
>>
>> Fix the bug in compare_and_write_callback by jumping
>> to the out label if success == "false",  after checking if
>> we have been called by transport_generic_request_failure();
>> The command is being aborted or stopped so there is no
>> need to submit the write bio for the write part
>> of the COMPARE_AND_WRITE command.
>>
>> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
>> ---
>>  drivers/target/target_core_sbc.c | 22 ++++++++++++++++------
>>  1 file changed, 16 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
>> index 1e3216de1e04..80d7a4419c4c 100644
>> --- a/drivers/target/target_core_sbc.c
>> +++ b/drivers/target/target_core_sbc.c
>> @@ -454,12 +454,22 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
>>  	sense_reason_t ret = TCM_NO_SENSE;
>>  	int i;
>>  
>> -	/*
>> -	 * Handle early failure in transport_generic_request_failure(),
>> -	 * which will not have taken ->caw_sem yet..
>> -	 */
>> -	if (!success && (!cmd->t_data_sg || !cmd->t_bidi_data_sg))
>> -		return TCM_NO_SENSE;
>> +	if (!success) {
>> +		/*
>> +		 * Handle early failure in transport_generic_request_failure(),
>> +		 * which will not have taken ->caw_sem yet..
>> +		 */
>> +		if (!cmd->t_data_sg || !cmd->t_bidi_data_sg)
>> +			return TCM_NO_SENSE;
>> +
>> +		/*
>> +		 * The command has been stopped or aborted so
>> +		 * we don't have to perform the write operation.
>> +		 */
>> +		WARN_ON(!(cmd->transport_state &
>> +			(CMD_T_ABORTED | CMD_T_STOP)));
>> +		goto out;
>> +	}
> 
> Instead of having the "bool success" arg then the callback figuring out the
> context/state it's being called from, would it be nicer to have the caller
> tell us. Change the bool to a:
> 
> enum target_callback_state {
> 	TARGET_CALLBACK_STATE_SUCCESS,
> 	TARGET_CALLBACK_STATE_ABORTED,
> 	TARGET_CALLBACK_STATE_FAILED,
> };
> 

Was thinking about this more. That might not be as nice as I thought, because we
have to determine when it fails vs fails early. We only have the one user now, so
it might be overkill to change all the callers.

Your patch seems ok.

Reviewed-by: Mike Christie <michael.christie@oracle.com>


