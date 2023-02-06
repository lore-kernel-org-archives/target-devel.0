Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76ACCC636D3
	for <target-devel@archiver.kernel.org>; Mon,  6 Feb 2023 15:52:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjBFPwY (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 6 Feb 2023 10:52:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjBFPwX (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 6 Feb 2023 10:52:23 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87282FE
        for <target-devel@vger.kernel.org>; Mon,  6 Feb 2023 07:52:22 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 316Dn2t3005348;
        Mon, 6 Feb 2023 15:52:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=XmlfePu6PHwX69OU33HSv06FswiO7AQs8yUxifryGpo=;
 b=er7GrliUz/iRDzG84/3PZc707pOZVVEH1gTZ13tcZtWsqdEvN3acqsIXsE8wcUA6Knil
 dp+wgZkCtMJRwT66gN2AhGYh1W9onyYsrzxFqOfNB6LXvRYBI+s+h3M12VAxxdF9/Zug
 LWpUOFjKXDj2882fLzbBLjdjgTYexKxf42Uc4R2CiaGS++GHUlWgtGnf1MjtD8rCHrIe
 QkiR0A1oNd84OACIbDhC8obfIw/rRH4i+3oLipO4g3AEz8jc/bMHqmWJ7R6k16SPkbNK
 p5LQ9IkFTo05wxWnl5mhTX/uwbk3Uav235ZFCe6zStJlsi6Sh4tZJ1bLEdSeF379HcyY Zg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdy137ty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Feb 2023 15:52:18 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 316F7eXE040924;
        Mon, 6 Feb 2023 15:52:17 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtaqpgn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Feb 2023 15:52:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ii2iJKlaLjAc6oCVhy/kBejBlaPHq5tn7HcwUMplPVIYeVdqoMPJw4XO0o7OreguGdst5ijYjei/F+f4RnorcRfMxFnvm/v10d7Fw4SGLuVNJDKe7LWiBVypia2ZkSAs51D5UyDdSOCZaHSeHIgovvVKobtj4KD2whpGUxOkQnoEXJO/Lx04gv+y4apjGHlVlf/Y286NnnENKMrpmith/FbBKLYRvPGiqB1jHwaM0uY+RR3QGbIotXPLpmtC1guTbGnXEF05ZRiw3QXOR6IoO1L3SrYP4hkz2NjogjKB5Z9bWqp5Od+NP8dJp5qLnWzavocWjCo/bWArIscPu8fypw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XmlfePu6PHwX69OU33HSv06FswiO7AQs8yUxifryGpo=;
 b=YpJFEw73FGBbwbG1Yb6VEn6N7t4Yv18CjoRDPYnF8AzGgcNI3L6rJK1mg0mqjjV/5iJBcraGhxtWQiOz5dPaN2FZF5FPkKoIgoyoJ1bDOLrDArrR0KjTE5GY4/99i046zpS9oQpfABdLukPlEhRVYAklrsmHzu6pxlKOZj68/09gK7T6ZcVQI3LVj84asEGGKIVHQUuak9S+cR/vhtHKlxM/sixgHzmzUHmIKdP/aqpIvs23XwjPtvgHBQGNDUBEds7nlbDFSxv/8wIM2A1QD3Nb1ZIFYKBW/Tf72mceNQFdyyxl4XcueZ+CSIaDOOWrBHwR6dkv+DoXew16d96IkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XmlfePu6PHwX69OU33HSv06FswiO7AQs8yUxifryGpo=;
 b=ut9/52TsjBe/JbMjIMOct8Fj9WwJQ1SnsEKf+O54nVePZC6kOCUv7fVIk0tVP3oV6s1qcKywYqZLUpi2WzlnF68DumZaEHuQIYb+AciYCUU+29XcHPVSa/KsWD3r1jlTwf40+r5ZsC+rpFWo1N6F7pZqD0ilbHWXZ6Y7TP3R3MA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4612.namprd10.prod.outlook.com (2603:10b6:303:9b::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.15; Mon, 6 Feb 2023 15:52:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6086.014; Mon, 6 Feb 2023
 15:52:14 +0000
Message-ID: <070d7170-ab17-6b85-23ad-ed275682716e@oracle.com>
Date:   Mon, 6 Feb 2023 09:52:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: deadlocks when the target server runs as initiator to itself
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     d.bogdanov@yadro.com, target-devel@vger.kernel.org,
        David Jeffery <djeffery@redhat.com>,
        Laurence Oberman <loberman@redhat.com>
References: <CAFL455m0amBULArG5dNHrrGKJ8Jg4n3SdnvzOavz4=i2FUR5Sg@mail.gmail.com>
 <f9f4057b-5711-e83d-aea1-20f79737f27c@oracle.com>
 <CAFL455k8m70cZHEOJML8HgeKotM=PsnswUtMJkLjocXxWY6_7w@mail.gmail.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <CAFL455k8m70cZHEOJML8HgeKotM=PsnswUtMJkLjocXxWY6_7w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7P222CA0008.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::29)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4612:EE_
X-MS-Office365-Filtering-Correlation-Id: edd1d5c3-f239-4b12-87e2-08db085a1dba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VjlpgwRAQzeZ8HB816IdrTgEVO+ai7nCALoG1ivM5YNE9FPvZ0Nh6NKC896/OagrPvBihHJg95t8/cuZVSoA11BQnlAj+QY073x/UxV2Sjk+fzBO8FKI8tIt5CqJrvvebikRam0/pvN11VWLzoaKge5kli1nh6B2yn+fmrZ3qdsl0NN8IapS44cZlVAYieX6ezSSSsldEacL7qOxmsLh25IDQnWOWsePSAWlYnKBgYid0oaZFim4LRQQ33hA8/WnKuycUiyZ+aCiBJG4tpVtUZIUfLWMlI7wbB/CQDvMFoDt01G13BgTL8bOVA4pPmMMpBvID2LcuJqgbG+R21H9wC1ZQFxzFBhO5nXN7iPFqHys88hlDW/uMt02ES4R3ehAxPJVLWxDQNkbkiEvrboDtKd8QXYeiZd4QjCmxsQNfSETqGpMepP6CVTg82CTFYfmb4r6mdrBThhbiD6X60hJvM/19MG0U5MGnh4RIeovR10cJhlLLAwWAJrOQQ3II+Lwrd1YICeC/K76ZC5y46AA3QbXC3dnEgpAMxX7eZeWIG7ga4SP7dnM4CSIyE7vuGPHUjr7BomYjI4mceRPxXSTZu+TVb5rvpx2wp077nuZ9gL7MelyeBL7Z5PR2rNZXeE6YTQ3s7Ackodtjb06oXtfBc/lEMjdwd3N3gJ73hla8HtHtbjCKLAvKPzWBhKrJy3RLioiiv7WF9VoGG624hvDd8JCZA6AL4We2OOL0fUYF9I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(396003)(346002)(376002)(366004)(451199018)(31686004)(66946007)(316002)(6916009)(54906003)(4326008)(8676002)(66556008)(66476007)(41300700001)(8936002)(86362001)(31696002)(38100700002)(36756003)(5660300002)(6506007)(6512007)(186003)(26005)(53546011)(66574015)(2906002)(6486002)(478600001)(2616005)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OU04NUdHTFVaT1pGMmJYNnlLelFDMGVYUER5aHBnS2FWMnBMWEhFNy9pckRv?=
 =?utf-8?B?QndVbTAzbWdMVUk3aXpQdURQOWNRMURKVEJWWUp4TWVEQXhXNm8vNGZvd0w2?=
 =?utf-8?B?TnoycjdoNWEweG00N2FSQXhEcVdGclQ2bHlZYkwwdFloRXRjVGdiWmlEZjdS?=
 =?utf-8?B?OW9aQmZ4MXRzUjVZYy9PdXcvbkxBSWtqYjlDUExNKy9VTmJqR2VUOCtZeWx2?=
 =?utf-8?B?QmxIZkcrc01xTXBtdW9ybkJ6dDM0L095YlVVOHJhK2dESHlPc2NlNzJxRlpX?=
 =?utf-8?B?aTR0eHkvZFVTMFdCTnI5eUZQaXEyY2I3ODYzT3RLQ0ZRK2xQZUVRMDJtME5t?=
 =?utf-8?B?WHpNVXpEeFRENGpPcDM1ZVVxZW4wcFJFVVlJankwNzl1VDdZUW9oU1VKYWtp?=
 =?utf-8?B?Wm9pS3lycTM0OXlhdnYrTzlsSWlwL2hsQXZNd1A3Vmt2cjFvRVhLdG1Hazdp?=
 =?utf-8?B?bjYxSE14WGwyZGZBTFhZU3FDTWZxSFNTWWhpK3lWTlk1YnY1dEVONm1CK0dN?=
 =?utf-8?B?NGpkWnpsVzhTazR2VFpaSWlqM09CM0V3K1BPdHhRUWt3dkRUcVNhWmljd3JC?=
 =?utf-8?B?UnRrYVJjOUsybStGQndPTVRJaWR3VTRFN0RiNkxVV1hOS1BWeDl2U3BPNHpI?=
 =?utf-8?B?RmVZNmxKS2NVMnhIczBDQXAvMEZTbzZHZ1ZKU2tCRjdKVWdEWFlMbjdRTXJR?=
 =?utf-8?B?RkV1aUx5WEpDT3NkZjUrOGhsUXNseHQ2blUzQ1p5cUdFK1l3WStCZk9uZnRF?=
 =?utf-8?B?c1FxUE1TTE51V0UyOW44d3k1MUJtZUU2bVBSRGlzcDU2YXBJZ0RSamg3R3U2?=
 =?utf-8?B?SllQbVlacHpQSm4xMGlRSXBiOGlMNnNVYjZGWEp0L29VVjZNU2JDczRVTmh3?=
 =?utf-8?B?WkJlTGtFM1cvUFpRNm85QnhPVWNKSVAwZi9LRnl6cGZFaXlDSHBRNjdKOVhV?=
 =?utf-8?B?MWgzbzRCaS9reXdJd0puQ3RyNVYyR1hydzhaVFZaZlRJWDdZa1lGbURMVHRp?=
 =?utf-8?B?OGtQMTdMaS9VQnd4T1JtanoxSXMvdVVtcXNnSFNPNjhRS3A1ZTc3aFVsQnhN?=
 =?utf-8?B?cXg0RGF2WlViZ1owWjIyU0w0MkNBcEdyOXlNdUlHYVk0cDU4L1czZmxmRk1C?=
 =?utf-8?B?TmV5bFpReFJZMDI4MDRia3JPbHdnQUJPODNhWVJHeVo5WGFnR1htS3ZIblZj?=
 =?utf-8?B?SUF3MWhsbEcwSXovUlBKbXZCRHNJZ0lYbThwRXpnN21NVUo3ZEVkck5pUW44?=
 =?utf-8?B?V1F1Nk9JL2c3YXEzWGE0ZVU1NndXdWNsUU82N05CdTl6WnpNcm40SHZNVGFj?=
 =?utf-8?B?RDFDVCs1UkZVSzRFb1FXbTQ5QWl2dHdGRkRBdWdMczh3NVdPQ3FnQTRVN1Jk?=
 =?utf-8?B?STBwN0luVG1sNGJqNTVGand3SFIwTDlzdkNraWtoR3ZyMVFrUFdBV2g0Qkxv?=
 =?utf-8?B?aHEzZlAzNVRhMW9qSXI2aHZiTG50V3pzdVZCNHR0QmpzNStoZ2Q4alY4bTQ0?=
 =?utf-8?B?WWJlajdXZThNbUp1VVkya3d0WmtSNDlkdEkrc2loUW80SkZ1YUxoVFROZ0Uv?=
 =?utf-8?B?K2FVZG11a2h3NllHdCtBMURwdWdXWHpnR2kvbkowblVaWlZXRURGeGh3OUJL?=
 =?utf-8?B?ZFJjRTYzVWhGcEs5Nks4dTQ0eUc0RlNEWDIzQUt0VDQ1WmR3ZnpGR29lTERM?=
 =?utf-8?B?bVloRTFKOFptdmRESExFWGwzdE9wUkZsRllyR1RvNk8wOEJGU1JBNXAzL0VI?=
 =?utf-8?B?YUxucFhnUTVCeW8wMVFIRmFtQ08yd29EbDRjbDM0L0JWY1dERkwybzArTDU4?=
 =?utf-8?B?VXAvSWRtY0lRWi9pQVlDSWJ2K3VQRVc5UlVaS2RrR3BLcTFLTThYZzROdU1E?=
 =?utf-8?B?M3RtRnhwU3NsRGdWUGlTNmpMNk5kZzZGRXBURGdrdUJtUVhvZzRwbGxsYTFG?=
 =?utf-8?B?cWNXSmNVUk05QU55YmpHRmxRc3RaNGJwKzZaSTNETTAvM1JQQWdLUExzTmtS?=
 =?utf-8?B?ZUlBZXQ4cGRPT2gyWDI4QTUwTjd3WUx1NUdIRXFhWUFPcnR1UzdmZ1FMd25W?=
 =?utf-8?B?ZW9jQXBrZkFRSDNYMDZwajJpbnkwMEZDUXFwTDBuNjF5bEdsMGdPQWk0Q1hM?=
 =?utf-8?B?YkF3RjJDOFF3MEl2cXNpWU9TeFhZWFBRWVlWN29HOGxDam1raloxczNFR3Vv?=
 =?utf-8?B?dEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: O9wRACdPreLWNK8C8znBnR1k3kFsi7/Y7GvZVn0auHZpbcHGV3fXFFrJ6cucf4cayLXFNKDIr6zC3Z8NxNSu9/fuhtD30hJmyE9RvPUal1fwE410qtz5bTkxs/yX3o0Qv9fg3gtQRFH8gI3tUuVFAaoMSwwCD0N/cvZxEJ4wXw9a+gBsgzIQHZxROJ2AelW96/dv2G/oI1f2epjLYJvCwxUNPtFMH+C+Ac7ep7SHtL5Px6+ElV9Y7QWtTXkpNcFWZ/a1ZlHnh4LwY18JDvwxPFfzJDPOhTtThgKNidW9kgesHvvywyluMPWXN4DL6Ri2OpQ0BGyNlYXWNG7syvpSDL0VjLOyVvSIyAq5wwDh3Q+EOowLJjoWaki7iAr5a3tOqTZtZkEdsXJ1ep/dDW05LrnsI6jOATn2X9kpgwj5N92oaelOOzaoJhZB/jQ/DA9mqUc0HB0oirScBhMky25ONl5vtp51cj516Ae3ExgTzrHnMZ4+A6ESbOmO38JqGzSCKO0LB0vQIk+xvknr4WKo8swOBtndMLg8UZlpUoOC/Uoc+pf2wo+I8KQobV0szq1PlHlUkjVuQ/tT74ImoipQSYC6C+KoX6rVfv8Dh2r7FA+BQbQxfZ//FGphfp+8uy6ig8PNIS29UYOndG8DuvbWo1WlRrROC+VVeK9egy5uYVP+yM7FF6vviiXDvtCv9hQ+YXJobxuuf0qvJkqsSzEdo70zFe+zjH2qzYZeRSEZh5kenLsr07bcf07FoYvWTicNifn966jdx067VMYNTIlvsRQn3cuQIEXSQ0xuT4SNcxxDSB2BLjycuH6Gae+DtUFH
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edd1d5c3-f239-4b12-87e2-08db085a1dba
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 15:52:14.6274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OoGTWXlS+MO682E7KQeZJdtlvqU5XEH6+8oMVox+cOyaUCqW+XQ3OoNv7XgyemclTe+89pGX25p3POtqPVW3+W5jDj1HTVE2+hfH7YRoXh0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4612
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-06_07,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302060137
X-Proofpoint-GUID: oNAy8jPb-M7Mucf8TDD8I-VDgXPs1Wdk
X-Proofpoint-ORIG-GUID: oNAy8jPb-M7Mucf8TDD8I-VDgXPs1Wdk
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 2/6/23 9:18 AM, Maurizio Lombardi wrote:
> po 30. 1. 2023 v 1:09 odesílatel Mike Christie
> <michael.christie@oracle.com> napsal:
>>
>> I don't think that's the best option because it's a rare use case and it
>> will affect other users. Why can't the user just use tcm loop for the local
>> use case?
>>
> 
> Hi Mike,
> our customer is still interested in getting iscsi in loopback work and I have
> also been informed that  this use case isn't rare among our users.

Why do people use it like this in production? Is it for some sort of clustering
or container use?

I was actually going to ping you and tell you loop could have issues because the
backend could still allocate mem with GFP_KERNEL, so that was just moving the
problem around.

> One of my colleagues suggested using the IFF_LOOPBACK flag to restrict
> the memalloc_noio_*()
> usage to only those connections that are in loopback, so other use
> cases would be left unaffected.

If it's ok to for us to access those flags like that, then it seems ok to me
if you have legitimate uses.
