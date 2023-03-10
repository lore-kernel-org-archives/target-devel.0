Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFB53C6FD19
	for <target-devel@archiver.kernel.org>; Fri, 10 Mar 2023 19:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbjCJTxY (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 10 Mar 2023 14:53:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbjCJTxX (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 10 Mar 2023 14:53:23 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47AB5CC2F
        for <target-devel@vger.kernel.org>; Fri, 10 Mar 2023 11:53:19 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32AF4A36025900;
        Fri, 10 Mar 2023 19:53:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=2NY7CWIRA4MK209DmQ6jU6dSvZIZYnsrJxxprq49xxE=;
 b=uXMF44nuoC4XUZ/GhRyR0ugv/CbLf32e80l+CTj0VRthx56fFFp6uFAMrmS7Rc+QaavJ
 GrOcyLKX2t21XU4HC26Qw1kiMong5+IC3HPUiPD+ClpFFwOUE9t2FS3NB7F7k369AEHp
 SgDiLTrkJ+ermCauSDhyuANxx77G2DfTmzyS16IiD4tikWE+GstrUJ+uMHHIT/PwQIzn
 tIvV5wt/jwsaN6Db0+xY/GSFbgAswryc6xrTlREJeRGsZvW0e2Sn81bThcepJMNjEbj4
 JTtGJ5MP55tj10KmwW6BTpg+pBndxLI2U2wX9gujNuyn+VsgR6eUZTGprwG8cswMAfys mQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p7v3w1s09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 19:53:17 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32AJaBVg025801;
        Fri, 10 Mar 2023 19:53:16 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g48vh7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 19:53:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/wDkSshdRfbSs5XrL7kF3lMR5YtyHp5C0iLVwhxigXzuA3eiNxVQvJVB5t2dTJeutBTSOYXXY8MF6nQjAHIGYrQCCHd/ob2gJUC3j6FQkGgGFbd6fCszPCABOfSj9HTMnUs0xmcfSnvYx7p+j5YLdnvaP3ALI+pCsa4mQ8Rzhews6YAHH6Ga9vIbp3FttKQwTUvYsPOj1+85eI+x0Rjg0tTFHu3v1CcuNXCoe7hsJsKo2roQhlg9UrlSe4/FhRubq9HO3kiO0TgYkm0mEHrG6Q93cXLADlI+zXk6mIGYrPqzR/3Ri3Pl0cIhs2/uSTmI3aWgeOhUXETaBsNRiAWLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2NY7CWIRA4MK209DmQ6jU6dSvZIZYnsrJxxprq49xxE=;
 b=kVGRKIQfTXG2KtbiEKzLUSo7pVzEogwSRMmrQwQoNJHgkk9jSiJKG5Tk0g6NlU6SiKJX4b2rxeRhLlhBJ2koAvSgnhRT20UQspid5YoTYx/cWsuqtwllHUrkk4I0+ijgVDUHxYL9cIsgDacYLZqKdRAQIuwYyiSdZ1kf6AoXYi4lETTCj+Yp0Sg/WCCFuOfQzKZ64Yuc7jbGZAdyYizF2+eGHojEQwEzd2YEmqrMp/KR4ehKxWBg93EcnlzFOJZrtXd26zRpAwngZf9VnmB+e/HZaS+Yu0F9+l46Fqa86CeqHQV6KEtXWwpRcCikNajqHEXYiP2ZcohpTwyXLbbJFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2NY7CWIRA4MK209DmQ6jU6dSvZIZYnsrJxxprq49xxE=;
 b=lzZdih+axVnIhKGLvzRX876kkAhfJxDMK3mK1BxkF/lAFSRUxpo+ZmIvo9+aabvHzPCc8yKW+dOlE5YE6EHjrxNGI3t/HpWuMO5ovMKjOh0Ya26CB21RQHYKsFzZSyzal6ZkCzImgeGKAaHDPn6xWzJpWyGD16f1GwtwBOw8SrQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5571.namprd10.prod.outlook.com (2603:10b6:303:146::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 19:53:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 19:53:14 +0000
Message-ID: <cf7d047d-bd71-6793-802f-c1c38a7a2afa@oracle.com>
Date:   Fri, 10 Mar 2023 13:53:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/3] target: iscsi: fix hang in the iSCSI login code
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     serapheim.dimitro@delphix.com, target-devel@vger.kernel.org
References: <20230310100423.1258256-1-mlombard@redhat.com>
 <20230310100423.1258256-2-mlombard@redhat.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230310100423.1258256-2-mlombard@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:610:b0::24) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO6PR10MB5571:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f386fac-7db1-4c97-11cb-08db21a115b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TDoNDpCm6QiQ9xKlXj+vBkt3FAA+nYdH+Ld/KMDnyugGiU8dUMys2BXQa8eAN1LEBPonS2H19CEfLf0mdMFrpAqTrSQAEuFRrsO2oCRXvBbwIp3ThNkLTRH3HSCW8dV1ikzWBIUMCtrGSXoO45B8EebEGHsgWbFwTuJKtof8dqHtJx7xiO9CYG+ELMab3A5i9TWwyqmw8NoM6zyswtH5JdPhZg85kBA8LByYvR/XH0WlAqSvb2fjB7t4ZUZqvANVydnGwkIY8zbHS4uaNr9LXCZSorW/ekLiJOOOuhXYXm2bCkksbdIW5pwYwGswOsHgaSoHlVtMoVjjhdT4El4N+Jfkkr33ZqXa5QUWb7VdZySD8q5PBBmEiwl+OKE43NdMEA3+rK+lh7HQJbrB6GojWHYYGBr5OWi7nUef9DJxXETFFGBlZkscdO/Xz0H+ueYdwt6XXbuvxtenDfbU6rjKGV1SKnZYM4eHllZXO+yOeXU7XjaS6vSE4zNDGKsYFaPAKRbpUNiTR1o7JA9eUrEq+j1VQHcNxZ6gN4iv7HTu7Op6vMj7XkLVnT8wwoNVi8UbhL5z3aF1cCwgCleIlMKi4D7cv8uReMdXz1eBlL1gzF6wXbq9PTy60zuccjCzz+RzQ8NxdGo9HRSPseHCB+zInKu4LQwbsed474UKcMccJcGr6WQGlxBE3+hgMs9GtRppugtDCbyNCTA7x5Av5HMWvTePw6437T0Bz+BHiMRugts=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(39860400002)(396003)(136003)(366004)(451199018)(31686004)(316002)(6636002)(36756003)(38100700002)(86362001)(6506007)(31696002)(26005)(53546011)(83380400001)(186003)(2616005)(6512007)(5660300002)(478600001)(6486002)(8936002)(41300700001)(2906002)(66556008)(66946007)(4326008)(66476007)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S2xBQmtDV2tZMEdRL1BoMmpKMG82bTZuMDB3UEtKZnpkVGdueldjOFl2OGdu?=
 =?utf-8?B?OTM0dlk0Q3oxMjlYUFVLUDJ6YXVUajlxN0JaMVg0ZGxNNTBoTjlaMkVXRHB3?=
 =?utf-8?B?WStWM05pb0paVkJEVGVaT0F2WUY5eDJWTVdvY0xSa212a3lXYkhreXhoR0ZJ?=
 =?utf-8?B?OXI4SUJrWFRld2FyMlB6UnBrNzNHc2RIaWJmQytzUWkwT3I5REhySUV4MHFs?=
 =?utf-8?B?bThFNk9QV3A3bjVFci9nVVEyOGUyMUFZOHZBVWdkTlJZdC9xN2ZIMm8xVm01?=
 =?utf-8?B?b3BtZEpUMmsyR21GZm1hQTBGbUVycTg0eHN0eCtWTHo3RUtzYmVSeXVhbUdy?=
 =?utf-8?B?THMyaFZ4YjY0WWI3VWlrT1BidWNQT3o4VjkvYjNuNGcrY0hrSUxVdXJGbERa?=
 =?utf-8?B?Sk81VCthN1pLbmdIc0N5RlhvWlhySmpMMFdtSzlzaHJDUWkzSEl1dnFFMkZo?=
 =?utf-8?B?TXR6UVhkRys5QjcycWlKL1RrcmtOaFByRld0SWFudGI2and3OGkvYWtOZzhy?=
 =?utf-8?B?TWIzQlNnSjQ0d2N4QndBY1BGaWpxclpCZHdJSCtlSktMcVRaTHJJd2hyQzJF?=
 =?utf-8?B?SkJ4SG41NFNBSVFsbXZNUVltcUoxT1NCejFEQVdxSVk0MWpGSThYMWZ3Wllu?=
 =?utf-8?B?aThuTjFuaURiRldtQUw3R3ZPeU12dlZxVUpaNjRJWnhqUGRWWjhjWnhLdCt3?=
 =?utf-8?B?YnBEa21rbytiN2VnU1NDa2FjMkxvOVNIS09xU2tQWVdJUnJ5UEhXdXVFMG9t?=
 =?utf-8?B?Ylh1a1lGejJjN2prOFRKbk5OVEovaUc3SDROYlJaR2FMbWxyZUMrek5hdWlW?=
 =?utf-8?B?NERPRTRBRm85TUJ1UU1TUGxxRHh5amlyeTVZTnRHQVRRWFc2Sk5wd1J1K0E3?=
 =?utf-8?B?N1F3VmJVaTh3Q3ZOUFNFcS9POEpXbVh4N1JOR1NqRlZxVVoyTk1scFFMVUox?=
 =?utf-8?B?dWNFRnF2Umg1ZHE5Qi9Dc1diRzZoVjNBeFVMd1labHd3M1lRSnZjNmNTL00v?=
 =?utf-8?B?K3FObDFqUFgyOHhRalY0N0ZCTkJXcmlVL1U3MzZPQmFucXJoeEdGY0kwTXJT?=
 =?utf-8?B?RWo0eHFURHZBd0VjS2xMQTZibVhUZ0FzSEl6QmJHUFBZQmFNWWVIVGZPaEdK?=
 =?utf-8?B?bHduU3lHODhEdWRydXJLRGROQnlJdDRLTUFHNzRIK1NMVWtQTSs5eHprSFp1?=
 =?utf-8?B?Vk1aTWRUL3QzSXp5WUpiM1dFQ05IQmt5MDMvVWEzYVBFRS9zamc4WVFFcWtM?=
 =?utf-8?B?aStNYnl1YTFhd3lLam9US09WNE1ZS2xjV3lpTUV3c015MXFFWmZ0MFhZOUxF?=
 =?utf-8?B?Q25GMTVSK3FLNjJ3QkVZM3d3bHA0TnR1OGJ5WXBqUWpOY1hyMitPUmZHTHho?=
 =?utf-8?B?dTFKSjZjZWU3SE8rbWMzUDFmdDdmNVRmVmVqcGUveHo1OWlhNlVNSS9NeWE3?=
 =?utf-8?B?VTNzaHlhS0wwY3pIczUvK0ZwYzUwc2VVMTVsdENHeW5xc1JWaUQwamxPK2xI?=
 =?utf-8?B?WExpODYvQWZ1TzF2cmgvTlJET0hiYWI0ZFBzK3JnRlVoQzVKK0U3Rm5lTUtQ?=
 =?utf-8?B?bVNEcVdqU1cyNXdoVUNSNGpZMVhvMnR1QUszMlVxNVZqRVFhOW0xRGJ4R0Nw?=
 =?utf-8?B?NExTTWZGLzYvY0sxWkhYWU15RE5RWGlZT2FxWGpyWldjMmlVdGJPNm15cHRZ?=
 =?utf-8?B?VDFYd1NTMERHYTlpdXoydHlTTEN4Tk5VWXpKL1R1Sm9IZVNwNWREMllFRGNY?=
 =?utf-8?B?TmdBMnlXbEZkZmdBWU1UVG5yRURBZlZBM1B6L2hjb1hoNFNOVVlSY2NCclB6?=
 =?utf-8?B?NmVualB1R0krR3Y0Z0NuSWEwMnJNcTQ5N2k5QzdTbmptT25odTI0S3gyaVFZ?=
 =?utf-8?B?SmozaklCRjJrRCtrd1lQZVJ3N2wremx6Qy92eWp1SENyUU4vSTNQYlBvMlVG?=
 =?utf-8?B?dURjM21qdEtReEhxYTNkN2JqN2wwYkNlcmNpNitBUlAwTXdrZlpjd3ZPS01V?=
 =?utf-8?B?bzFXbG1icEhsYWxxRkZYNUphWTRwT0JvRktHR3hBSWVZV3JWd3dOU2RIM2VX?=
 =?utf-8?B?bUo0ZUdxcDJGUEJZRDV6UXowS1p3bzg2Q2xWaXhxcWlZSWt5OUxRL3FtMzJq?=
 =?utf-8?B?ditUbDB5ZUk1dll5UEtIQnhTVm15TjhJUXQzamdVRnFjTlRUSTBFeW4xZUVW?=
 =?utf-8?B?OFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 8Odm/CnDfgF2C9qRBQgNl1yR0qfsrYl7HVuaP5aUN6FalLeFneottBE8OCaZsyRmcwOLsrlmusdO0KhXCPcnuebedaaf/MZbGTn/3Gl3RUBd0h9iGfgHQ6rgdOCFyqOgNzbCkybtKYLQuc/GexFdTbiQ16C8xir81FDSSu2vEuokRHCoE4QA7G/5nr8AyIvPguHz6BRb4ustkaHAh2fWVFMe0MmwW5GvFmrgZyAmPD0SLktRfHeVfGb8i8Q8OTyReeTUTgiL1+yv+1qFqToJNuw0/obuFHvFEFKr8Ks/xPRBbHF/i00abECYTRK8TYrf4L5ovQfYIDUXrS/fZqPtbn8nY8DonedRwTofxejzqpIfJ2MtAR8xqlW5oMnphPF+JaR2Rd5FmPrpUBpOaoyLRcHG4L/iwjEv/kjdLIMDcS68ghR5Qd7QwT64baXuoeFl4kXtOYezWo8pakcOukHGewx2OJ3d2otmr0rAeFy77iMmxJXP5k7pTUooMJnro9Y1dTJpOZvjdPTIwcsAUVD50IU01Uo37dwC3R98cemaXemJaaK1/Os2Rw+A3nJuYfViLv+bZumGCKJOJzQCFKsZ0drtVDe1x3b8s+rOLhGFPZf/EFk2ANQ0mSVUUDh5G/wwWNnvNWVNIjM9LzJYctidHWCiKumqQLQ4cL4c5Cv0g7hcAZIXvuEZYKl+ewjvHvDDldLN7wFngCSkxiRe5bnxM+XFwD1W/Gq3cOB4QLwUY/MElQIoNjTwy2OHHQ2I7klOu0AD2XTNYIpQTsU+R8F3duNtLwVLvQvXMoXDdaiulZNcXHt5kmR4VK6+k+tuyZHA
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f386fac-7db1-4c97-11cb-08db21a115b3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 19:53:14.3065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rQVjr+LFr4XqGbE2qFfSzNk6Z4JOw+SkBxzxzVcemCiyqWadCfo0PwKociwKmGzQc9OkOKztBa/9mdVheu/xtMwpiieS9BjCPT7J/aJdAuM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5571
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-10_10,2023-03-10_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303100158
X-Proofpoint-ORIG-GUID: A0Zi5317q84iwb9iWAXMj06Uqhj6Cfyh
X-Proofpoint-GUID: A0Zi5317q84iwb9iWAXMj06Uqhj6Cfyh
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 3/10/23 4:04 AM, Maurizio Lombardi wrote:
> If the initiator suddenly stops sending data during a login while
> keeping the TCP connection open, the sk_data_ready callback won't
> schedule the login_work and the latter
> will never timeout and release the login semaphore.
> 
> All the other login operations will therefore get stuck waiting
> for the semaphore to be released.
> 

You mean np_login_sem right? Do you know why we have to serialize access
to the np during login? Is it just a simple way to handle the internal
target variables for things like MC/s, reinstatement, etc? I saw the tsih
case, but am wondering how easy it is to remove.

If we need the sem why do we use the sk_callback/non-blocking type of
approach when we can only do 1 login at a time per tpg? We end up
creating 2 threads per connection after FFP, so it seems like we would
have enough resources for a temp login thread before FFP. Looking over
the commit history, we seem to hit a good number of bugs in this code.

It seems like we could simplify the login code by do a blocking type of
implementation where:

1. __iscsi_target_login_thread starts a workstruct that runs
iscsi_target_start_negotiation.  It would then run iscsi_target_do_login_rx
which just waits for a response. When we get one, it does iscsi_target_do_login
and if we need more PDUs loops. We have one timer for all this.

2. We can remove the np_login_sem. It would be replaced by a workstruct
in the np. __iscsi_target_login_thread would just flush the work to make sure
we are not running a login on the same np already.

3. We can remove all the sk_callback* related code for iscsit tcp since
recvmsg just return failure when the state changes.

4. It looks like cxgbit will work with some small changes because I think it
just kicks off iscsi_target_do_login_rx after sending a login PDU, then it
just waits in its iscsit_get_login_rx.

5. It looks like isert will also work, because it's isert_get_login_rx can
just wait on the login_req_comp/login_comp already.
