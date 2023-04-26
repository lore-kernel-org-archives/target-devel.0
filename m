Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 154BFC7618E
	for <target-devel@archiver.kernel.org>; Wed, 26 Apr 2023 15:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239512AbjDZPoj (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 26 Apr 2023 11:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbjDZPoi (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 26 Apr 2023 11:44:38 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A161E4ECA
        for <target-devel@vger.kernel.org>; Wed, 26 Apr 2023 08:44:36 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33QEiS3n003850;
        Wed, 26 Apr 2023 15:44:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=lr3sU0kPCtjfi2TVEVOfQJ1PIrF7wnYItMZSuUcGbSY=;
 b=g0GU9ooAeo9rv1ejCbcWSPUYq0cIkkM1GJhGbt/BtoEXFgcVeu4Prd2YkVQW2qYajAcH
 G9TJh4tyk6LtOh/m5DMh4bS3Qm3kXlKjq0HAgzGWD821ZVUumDzsP03TXjEF8tyGa9bm
 QR35WkXTunudA/lpnvWdCgEDK1YR0nzGcuQkmb8xRGtnNg1f/H6KpQCPQ3v4MuN9nNb+
 OHXza2lP81yvqVO/ghusv4EqOAb4H9Y2WzZFfuaXSePiol9easfL+ra+QaOeJlv2nelV
 DjiVeZU0gxzorqWtxfs/wQ1KOQouo9Dp83PT1lm6/rZQSj02ArplbYzuL8GRU+tApXGt yg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q484usrpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Apr 2023 15:44:34 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33QFfBZs013387;
        Wed, 26 Apr 2023 15:44:32 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3q4617vcr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Apr 2023 15:44:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m2T2IjI4JQln7pOzM0c0hXTZ/FexovTvo7clGg0DJfGmU+tDmr4OCVW1M0DdZIFRCE+C2Q78JV9JTqs2FwxScJThzw1eegb+dJf+yv/hdconrZkDuKPeqypNwSum2BOr03B9nkTYlbWHnpZIHRhyqmnPAKaFPNmMBzfEtOfchXSNaM0l94XSrrDBYkcg2NvNvGa5H9PVkV1fzUtA57VdmXjdFhC6xmII4evZx1Yj6J3WT2uangoDD0sKzr1H4meXcWtb2y3nqt1z/bjX/vZRrMMIZAD+1ZWT8BZ/0j0izZUdJHs9hU2Vxc+oUYKFPjaYHaYugVTbr9beX/RKPS8gNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lr3sU0kPCtjfi2TVEVOfQJ1PIrF7wnYItMZSuUcGbSY=;
 b=fK5dgG2NgAgv30RQiBDVuOdZzE/9N0i8WEywRZW1siUKTI9vUZpP1CZOcJ4m0WRy920J3QQcUTwhX1qvDl56GFla6guSdAd9fhalS0Uw1eaYpv1cFsfi+7tu65IX/W44lzkH93/ckog/EkqwyqRkMad5Qsk57a9Ivk9j02VyrlFXxAsc6xLKtUz4d7MK9kQM+QDa4Y5M/0J2ch+XIsMgKP/lTw4C6/SsxZqwv72LZPmZ2DuzR60ijf9bULPgbkiegK2W44X0Ci9B0hYNPECp/kYHEmCC9uI81qNCHZBelYLWOU7WEjgswHyy8mh9MolztrZv8VxWifQu4fHfKGUdGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lr3sU0kPCtjfi2TVEVOfQJ1PIrF7wnYItMZSuUcGbSY=;
 b=xFBlZkygb8QB3f0x/Lip5VPSq4pf3EMK2NtxBWhul6typr9c/kFQqKgdnmvZ/nUDOv1fFvNwEbwfRObfghBavnnwgWrwajEmzSDuH32ZsTEwykNaFiZdTUbY28R6TLU2GwOx6WkMMC/XMBkAnDY/2JRxNUwmqIIOrSRc3cuH3Y0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH7PR10MB6555.namprd10.prod.outlook.com (2603:10b6:510:206::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Wed, 26 Apr
 2023 15:44:28 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::264c:5118:2153:91ef]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::264c:5118:2153:91ef%12]) with mapi id 15.20.6340.020; Wed, 26 Apr
 2023 15:44:28 +0000
Message-ID: <792bbf44-f88d-7919-b7ce-09e30f9f347f@oracle.com>
Date:   Wed, 26 Apr 2023 10:44:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH V2 3/3] target: iscsi: prevent login threads from racing
 between each other
Content-Language: en-US
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org
References: <20230417171801.208122-1-mlombard@redhat.com>
 <20230417171801.208122-4-mlombard@redhat.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230417171801.208122-4-mlombard@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0186.namprd03.prod.outlook.com
 (2603:10b6:5:3b6::11) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH7PR10MB6555:EE_
X-MS-Office365-Filtering-Correlation-Id: b91b80de-f8b1-4f70-f76b-08db466d1eb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9+nHHkk8fUsAAzNJGW3yIgPKlHtE6Ee6RQAHSuEQF4qppltQFIgXmqm7sDquBLHLesNYJCMuxZneePehcOyUXUS0oKwGwesCBj51CELmpNA0x82d0ovV8w0hMzM3nSr3VIsBqIpT5ym/5ywdVlf0aIeVcY/jvP7dEo0uor+4sYdJJBvUApogDYe+h9emJ/K/5VL3UMGYtB/PfdV5Tr+r5A/9Vj16/lGRgTCfkPj3GUkM/0fGbeiKhwM64yXfnkFpoj0WVkUJ6qirb0mxTGMYazBZlrWUyWTDhKe3Ywz3lo7w8IvRLXoDG15Z6XoADRwFKRZ3LcABM2aS+ynJA+d4TmPSPNs6hBkNo0kp/Ov8nZ5dNBiB2kpkXJsSX0NuJOVxo1GSoNamPlqqpZ/AaTgbcIxVsbOHVIWp5LaUez7wTCSchW0f8LuCOBqdM8wykEr05B7g7oXntuvx9IWVqWy9wGdmYn+IcvVZ0FJlgn7gNm5Y0IvvSUs7tl8sMcFifkwwG8JO2abDI5ykrcKMlpTmpE2AmnYAtpq4IENBBd1eD9mUMJJJV96Ini7J5+mgFmdgxY23UP+zjkiQc/ZTPxbnyz1s3oOz5BFE7WsuRZXwcpKKo70ISA77nzf8Mim139WwQMXnzBDPx3S9Aau6yADOww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(366004)(376002)(136003)(451199021)(186003)(38100700002)(2906002)(4744005)(2616005)(6512007)(53546011)(26005)(6506007)(6486002)(83380400001)(86362001)(36756003)(5660300002)(31696002)(41300700001)(66946007)(478600001)(66556008)(8936002)(66476007)(8676002)(316002)(4326008)(31686004)(6636002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjYxaWNuMlRHL1hUMXoxOHl0NXFjNU9aZjJhYW80SGZJQVA0bFVjYk01Qzh1?=
 =?utf-8?B?NE12eWZVM055bTBBL2ZEN1o4SFE5TjVxOWw4RUJ1Skc1NGRiZVpnaGxMMGIw?=
 =?utf-8?B?clZBckx4cHRZWXpVYlQ0TnlrRitaa21mWnFaMTNGSnQ1SlE1UVB1Q01QOGt6?=
 =?utf-8?B?d0Ryb1RnVXNqZUJFSHRWVE55VDFlSjNJakoyek1xWUhzL1FEU29TY2h5c0tV?=
 =?utf-8?B?azhPWXBnVVB4bkFUVUVVYnFwUW5wRWIrMVl3QVp3S21Mc3A3c2g0ZGJUeHFP?=
 =?utf-8?B?NXhqdFJ2Nk9pazB3Q0pNcTJJMDdzUGxkbWNOT0FNOU5KZFN6L1BCcFdZazVa?=
 =?utf-8?B?TjVhMVJSZ3REaXB1QzBiMXBCdWVJREY2NXVZYkVPQnhkb3ZZdjBCUVVSVzl1?=
 =?utf-8?B?UGhDNEh2Y1ZCUThrdDMwWUZpd09XcnBnWnREdGxpaXZXYXJWMDQzYVBEWGRH?=
 =?utf-8?B?ZlUxUXVQSlZudG9wbDBRdTNpUG4xNHlUOG1xMDhDc0hacCtMVFJNWWtMK29h?=
 =?utf-8?B?cGE1ZmZWT0xWYmlYaFhRb3NjOVhUR2FOSGtIVGNlMlZhaWkvMGNScXBkZG5B?=
 =?utf-8?B?K0NVNklKL3FoYjRqQnpyYTBQS0VMV2xjQlJiUFd2U1ovYVNjWG94Z3BLZHQ0?=
 =?utf-8?B?V1lGUjIxajh0M3JaYS9UejJkV0gydXk0eGVxWVBnTjMwdFFRdzNUcUlpQ1pE?=
 =?utf-8?B?MUpDb25IWWlFbFZKakdyQXZOZFIvRkhDQithei9vcFcxM2FFcS9GSTl4M3Yr?=
 =?utf-8?B?dTk3QTNVT0ovejJFME54cWhGMmtsdGNMeGxNVmRvQlorbm1xTytiQkpLaDRD?=
 =?utf-8?B?N0VPK0dNNTJWQnVoN3FsYVNxT3QwTmoxOVc0ZVBPb3lOd1FWK2o0UmZ3ZCtQ?=
 =?utf-8?B?VzlQcTJUdWdvU05KODcvcmNqakZacGd3T0ZqMjVZTHJmcVliakpYdXYzZGM1?=
 =?utf-8?B?NVVKV21FdjdZbHpTbXluMGVvejEyMjl3YlQ2STV0VG4xU3NoU0Q3Y01NRnpR?=
 =?utf-8?B?MVd1c3VBSXI0U0RNU0lyVVNhVklxZXVDTHRMaW9nSkF0cnpDRkpldFBIaTFt?=
 =?utf-8?B?SmdWVUg5MVVpQzZtbVEwbUw3WDUwUEJuWDJxRSsrcFVCZVp3c2tYYUZ2MXE1?=
 =?utf-8?B?dUo5WTcvSitROHVtVmJPRy9jTmFBN3BKNDM0d2ZaeUNhTGxzYWo3aSs2S3VG?=
 =?utf-8?B?MUpuQnVFTm4rdTlVRmRRVURiOCs0WGFRZWtrN212eUxwUCtsdWM3dXpPZTJD?=
 =?utf-8?B?YThLdkR2UkwzUEIvRjdIcjVMeEJkU3IxNy94QzNKT3BuTlF2K2s4VjcyVnBh?=
 =?utf-8?B?bzk2c0FDNCtqZndtQ3VuaHVBK1g4TXZZeHZsK2tvWDl6NFF3eEw5WDFveDVT?=
 =?utf-8?B?QkwrenI4T2txd2NVaCtkOFRYZ1RzSzY2RGZFOVpqYnRvYVI3TmVSTXArUEJQ?=
 =?utf-8?B?ckE1aTZwNWNLNkg5ZGp5bzY5MnJrR0pMMCs0aG0vK2NuTThiQXJuT2NHQlNu?=
 =?utf-8?B?d3pPNUJScFZOdCs4bXBwNjhFOEQyVzdiQjArQ1RhLzZJZmsvd0ROamxhUU81?=
 =?utf-8?B?bTJGc3RsV0FRZ1RhSDVIRmtJeHk4MEc3azA3NnRPNi8rR2JvNXd1R2xoZHVU?=
 =?utf-8?B?NnBmY3pDVmFicVpHTVF1ODh2K0NkUGNFVVczd25CWnZLVkF2QWZ4RktQb2Nw?=
 =?utf-8?B?dmptUVhSeS9hTit3MWNYUzVqbHlKekJFRXNvMW1XYnYvcE10RmNuc3Fxa04w?=
 =?utf-8?B?YmFDZ0pGM3J6SnF3V1ZxcHJCazBSVnM1YktKZVlUeWJRYmJMK05nV0pSSTA1?=
 =?utf-8?B?Umo0NHZ1ZWRCeUtIZkNaRng3S3ordXdVVDErY0hMOWl1VDRsbjNhWWoyc0JN?=
 =?utf-8?B?b3JLejE3NG1FRFhWZFZhM2R0Ym05L0ZIQzJnaXRtK0REWkswRkFPNjByRFIw?=
 =?utf-8?B?UkJzRVRDZ3pqU0NZelB2eEh0akRjR3FwRkEvTXlxRVlYb1d4V0VaWHFYTndn?=
 =?utf-8?B?TXVPdHdBdWJiYnlZdHI2dUJCZXNLYUZjYzFEVDhBY1IzK1oxcmtmSVhnMVEv?=
 =?utf-8?B?THczWWJQbktVSDVTMG9PeHdibTJIWVlaWjVXck9LblRPL0dxTHRqU1pDSG41?=
 =?utf-8?B?L1lFWDFwMVdDMkpVVG1oT2J5ZTJma0svNUpyV2JJWmVDQTFhSHNQZXFWdlNt?=
 =?utf-8?B?cmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Icymk21eilz6tpt15gr6iBRKh1kOOlRSR77ZnoJCqEgTM33lWPhbM5JxpqFpzmsxxNdkiNUu6QXZ2FEs17ohDCUcqdtnItV2wU013l9ttQMmgTcvSobfVJIWqnPhzRIdZ66glQPb311mhj4iW7zxd6cS7H5Y8rOQhtsYNeJ8oKp+ngS5+IIhmoSSdEXLFQeO98bDbdd+Dit9COgGAo+CWSpTAzE/gEKeWFCYCXuZcf9KQM18HtGgZE8Dc7OTv0RL3oChrxvW8vcV+1CgqXVyyHB/RE0vuRKnORZ9IP6pgt0yXYuiSOxEwqoupMdeFZAeCIrWBr9waO/BkGQmSoMKoTT7KmtArCUkRkwpbzmGkQmitsclk5htRF+NZFkvJ+I5+uAViId+lhWZELPloqEBnWKwhB8I1tJs8fFVWRpPZ+ED26VysyfJdtCxFi3UDj/bgw8ltZt49hybYR/9vkWSms4dQDG8OE0lxLK5KeSAF/J/NFWEd18dv/oA1xjDIh7avZMewU6P0RGwD9pQRaekJ1dUwveSno0Prtn1ylWoldJXn7X0BJTv1dcohalYmUpXZGDS7b1mqlUN1aLuUzrncitq30QWKZsTvPzrjOYI+lOOl8TvDlNreHOLOzwBdTaJMni4ZnmAxWvJMOWSq0iwe02xC7dflJLFvzbpEOPJVQme4iz1QK6Ar5NVrNCKuecQ6vt5e6gduVzveuWB9w4iOIZZdgBufPNd8RrhCj3TO1go0hPMycisCFmwyspWz07PI3cUyLScgBi4ryyyivlTIZeh/wYnjdnJcOOh9vNTueM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b91b80de-f8b1-4f70-f76b-08db466d1eb3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 15:44:28.4662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Pp/jUsjfoLw7+30O32L8ogXTEGcyB2HwQbgSaa52ySeLSBl+x5oqYEqdIfcijUlMjgUrVb49IgqczJJ9GgqusujE7L89gwx/EVsMZXXrRw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6555
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_07,2023-04-26_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304260140
X-Proofpoint-GUID: HAdSenrUXGzsXo_VbUUCyUL73TPPynHj
X-Proofpoint-ORIG-GUID: HAdSenrUXGzsXo_VbUUCyUL73TPPynHj
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 4/17/23 12:18 PM, Maurizio Lombardi wrote:
> The tpg->np_login_sem is a semaphore that is used to serialize the login
> process when multiple login threads run concurrently against the same
> target portal group.
> 
> The iscsi_target_locate_portal() function finds the tpg,
> calls iscsit_access_np() against the np_login_sem semaphore
> and saves the tpg pointer in conn->tpg;
> 
> If iscsi_target_locate_portal() fails, the caller will check for the
> conn->tpg pointer and, if it's not NULL, then it will assume
> that iscsi_target_locate_portal() called iscsit_access_np() on the
> semaphore.
> 
> Make sure that conn->tpg gets initialized only if iscsit_access_np()
> was successful, otherwise iscsit_deaccess_np() may end up
> being called against a semaphore we never took, allowing more than one
> thread to access the same tpg.
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>

Reviewed-by: Mike Christie <michael.christie@oracle.com>

