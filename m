Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4254C77B7D
	for <target-devel@archiver.kernel.org>; Sat, 20 May 2023 17:42:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjETRmz (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Sat, 20 May 2023 13:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjETRmy (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Sat, 20 May 2023 13:42:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EAA5FA
        for <target-devel@vger.kernel.org>; Sat, 20 May 2023 10:42:53 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34KDlU7K014233;
        Sat, 20 May 2023 17:42:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=09fOVvxik/u5j0quRlfeBBg5oNvyKcwChQVCV/cz1w8=;
 b=bkv+X+6q4NffZ25uszjAk5AygPnXj3WtG/a6JAPO1B7fHweowLENKIeigRFvCG8wydyr
 AIsYAv0aH5HaAnPw6pO7DZ0jLaIGXj86/5T0rEiz4l/ErLY43yJstrX0K4Q4lvNd/M88
 Oy8dy6QTIXMtkgZGiooPVLDb2DXc/z59lni5hjYAC6q0LNTMUn1Vs5x/DM98rwOXn1tE
 iKA1T/PaDg8Ka54iOm9Sv0ICdsd3IFMgxQaU9y1RxPFWnm2QPzq1zgLDKEwklQOTXB5y
 r5NUcNSgzZAVkIDOp/b8LGK0tqgk+I2MOfyBGcIRhw6O3EvxD40+Lv0IpJ6QPxYywxks cQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp7yrhwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 May 2023 17:42:51 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34KGkCu3011168;
        Sat, 20 May 2023 17:42:50 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qpmn7ygcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 May 2023 17:42:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZCFomSez5UMeisMeh0i4HoD5RrdNxYlGZnKqScha0SgB3kAKhAAHUXL7v9OAqtcEkXMOesCX/iM+cKECq2CVqlCPARYYhIUOQghegx/6jXR4S3bsKxCi6o/zxG40lU29nIUfpl1gL2sM8+h5GCuuF6sB95pLMEJwr3pppAXLSNddgMQnM796j4M7k+ToLr1ADnZPFuB/EivrlT6gWcRIRdRh/VMzgmslxAlvGVQdy+Hmfj/jKnkQV6yImwWHVJWJiSzHWRSjlvo3tF2vqHDZhdw5N+xidqkuFSm5ncmlW4Rnccohsmdo1R1XrVpxdNKVZCr2HvDiw/oN8eItJxygDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=09fOVvxik/u5j0quRlfeBBg5oNvyKcwChQVCV/cz1w8=;
 b=GBDCbINL7kbtccxQmNfjg8tKSve1owM9BqC0pPLHY7FJ+9EWXKSVfbcjEIECGKEp8+i/Q6GcE3mXjm0aW+G82KeiLGwHEtbZTqmtAF/Ujmd5qR/AIXxcrRwUFg+s3pJcPoKukDRxfvNL2jhSh2EFWDvjIkluAl2MbbZKMq2fCV8tAScAj/7KcH1N14Juj736RyQ2V6A5pRYsE14BDDGDLJys/nRt6OR22i0UHXrfmzubnBp6VVjhxUZQLRrK54Uj4L3Lie4U9RAQCdfHz1IHlO3X1SDlFH0lBsbMl2rbRwYGkc0QtcwOAvTN0oDSnSaVvl6sxOwZkAg8UR0bSihVrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=09fOVvxik/u5j0quRlfeBBg5oNvyKcwChQVCV/cz1w8=;
 b=NC6J8K3phG1JsyxXPO4Ese+xfe5F1y5Donn8q1I46DOOVZMeHHazSyQiTG+EmvGY5SG1o2V0G6YZs92BR6SKssnNNEXAUL/oW1/I7XdvaAsLGcUOOpeb3LoYjXjdegEnHe63GdC1BXVOgkbk7bCzrUEX6V+uwcuCG9/Eb/OBQp8=
Received: from IA0PR10MB7255.namprd10.prod.outlook.com (2603:10b6:208:40c::10)
 by SN4PR10MB5640.namprd10.prod.outlook.com (2603:10b6:806:20b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.23; Sat, 20 May
 2023 17:42:49 +0000
Received: from IA0PR10MB7255.namprd10.prod.outlook.com
 ([fe80::6f12:fcdf:da87:2bfe]) by IA0PR10MB7255.namprd10.prod.outlook.com
 ([fe80::6f12:fcdf:da87:2bfe%7]) with mapi id 15.20.6411.025; Sat, 20 May 2023
 17:42:48 +0000
Message-ID: <1fdd58c3-0ba6-b526-a33a-7f19e81f000b@oracle.com>
Date:   Sat, 20 May 2023 12:42:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH V3 0/3] Fix possible hangs and race conditions during
 login
Content-Language: en-US
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org
References: <20230508162219.1731964-1-mlombard@redhat.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230508162219.1731964-1-mlombard@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR11CA0050.namprd11.prod.outlook.com
 (2603:10b6:5:14c::27) To IA0PR10MB7255.namprd10.prod.outlook.com
 (2603:10b6:208:40c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR10MB7255:EE_|SN4PR10MB5640:EE_
X-MS-Office365-Filtering-Correlation-Id: c9c2d41b-fbbd-4464-4952-08db5959a078
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uBjSyQ1MzKCN78vfR868+YuutcExzEuTIUKgu9voafArV03WYSEDM+RYhIUvTw0SFfFlSejL5MW26rNASEMe0SxpX+3HYCZ7xp9cuTsRdhaFTVtmHK3aiceS8uXPuIGisT6xp50qUfkuEH7nJG8S8uHvt7K/B7nH+VRuR2Dek3J+mQkfaUCsoOQZfBDDlu5Ah4MagpewZ1d/tLOTdwDnEI/i6Twp1536CaBGdfhbR/AP7ueVYP3DEqE5UwZ/vp5CjMwhAKaD8B8fXVoiEJN/huOShO4Lj4hkMC+JE5oPviBSD5mLurgylISDPf3e9SiZhrJujxOvifB6vgMKxNG6YWDdsFxTY3KIv41r8mg0qw76Lb2iT97hGq3/AienBq/fM2zOKu+DQ9XCfqND5T82EgLjSE26dd+YZSuNmDtTzNFgaEJGwFBwdmEJE6pUfy8FXu4QHTaodMvh2BoL6SktQEuFAn87M8XZfxe1yP6MlW6zYtjFRLmXihM9K2c88a5usVm6U1Jlj5+E75B1YG8we3cAKoJxU3oAvUkimIkqk7Fz7VuuvmvMiIQp6LiAQiCYgFYGqvjzgndOEdNeW0S5GK/sokkXfQOMhppx9r3+36gD3RWgEBNzegL1Omp/diQGSBL3EhyHMzCwy3HebSBxug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR10MB7255.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(136003)(396003)(376002)(39860400002)(451199021)(6486002)(478600001)(38100700002)(6512007)(2616005)(6506007)(186003)(26005)(53546011)(83380400001)(4744005)(36756003)(66946007)(2906002)(31696002)(86362001)(66476007)(4326008)(316002)(66556008)(6636002)(8936002)(8676002)(31686004)(5660300002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YWRZMVljbExFV0dGMnorcTVlc0tSSG43TnZQeXVUcEs2OWZvTThuRGpSWlVh?=
 =?utf-8?B?THVTMmhPbDlXQ2ZuYXU0ZEJldkRwWnZ4ck1tUlBDUVJGVnRibGdzOGpaUm41?=
 =?utf-8?B?d1prcHA4TFEzcWVWaFlqUGhpc0tzaVNMSmkxUDcyMkJCdEhKNzZUWjRJMG52?=
 =?utf-8?B?dE5FUm1XODZlbjBxM3Z5NUJOMUNESFlPRUhwRlBnYlg3MkZLeDhIUHI4S3h5?=
 =?utf-8?B?ZUxBSlRLK2N1eXp5UlRxaTYxL0lpU05YUHpoZDF4Rm9uOERvQUg0TEtxTUk4?=
 =?utf-8?B?NzE5QXV4czNpWE9GR1R1RXpZbHVpZms5eWQzQnl5T1NQMkUyYnhkbHdDU1Mw?=
 =?utf-8?B?Uk8rT1RySnFoZW9tSkJBVTlFRmJ2a3BrMEVlOEFHcG1PN2ljZ2tNbDAwandy?=
 =?utf-8?B?Yjh3MWNqUnV4YjBEbUxhTFN5c1VLV095RUdDVElpWlZxZXhhOFVIYWc1SHpn?=
 =?utf-8?B?K3hFanFUc1F2ZmQzczI4YWRZTmYrcUdZNjBKU2NodWliSDMya2NqUUIxTDBN?=
 =?utf-8?B?a3hTdk9tdkU4dHVXOHd1ejF4cDBxa0RaSWFQOTgzSjZyUEhDZGJvdklMeHM1?=
 =?utf-8?B?cHdzc2FHdDNNRGwrM3hwajNxYmNZcWd3RCsrNVhXL2tITWZYTUxsWCtabTRF?=
 =?utf-8?B?a1d3NUNUZnFCSmtPUWpodlhIZm13SFkrcTB5b054TVpDai9pczgxN1ROV3pt?=
 =?utf-8?B?VzJyQWJrME5PNlZPcmkxY25CNE5nWk5kNXAzMUUvNEdlVytHMTBzdjFhc2hH?=
 =?utf-8?B?RVFBcEdsR1BsVmM0eExiZmg1WWRLV2U4R05EeTZvVzJGdXB2VFVpeDVENmZx?=
 =?utf-8?B?RGRZa3FyNlA0YkZYZXl6aEhRbklibEJRaXZRenIxREVjL01XcC9TejR0SXV3?=
 =?utf-8?B?WW9ua1BmdmtRbEh6SExrQWg3dmdtMTJqS1ZGcVZQYlNQSGpsUTB0ZTJtS3E4?=
 =?utf-8?B?WXJrY2QyN2kvQURGcmhrOXVCQzJnMWJab2JEM0FSSkVXVitnNXhTM24wV29t?=
 =?utf-8?B?U0NXSUNEZW5xSXowaTQyU1VJZ2FoR1VibnR6aENweHozSWpWTkVDMzM3cHZs?=
 =?utf-8?B?dnlFSWNTTTFhZTd1cHJ4Q0pOMU02dkxXSFVZL1FWRmZaVkxUVHkrQTRtczVw?=
 =?utf-8?B?Nkl1aHhJTHhNajZtbEVsazY4cGRoLzZCRjJlNGpYSUUrY3NkRERqWkJoYU1q?=
 =?utf-8?B?SnBRdmlVZkZGRWZnR2g1USs1T3FoUXM5MVVoakRyNnBaMnBqK05uVTN2L3dP?=
 =?utf-8?B?Z2RwTGhXemtBMzFPT21KbW1LR3lhcEVLdU9xVFJvTXZvekVYUUlyKzJkMkhS?=
 =?utf-8?B?Tm43Nnc4Q0FSVDFreC9ML2RpUzNhcDBXMkEraFE0MG1SNFZQZUVlUUhZYkZH?=
 =?utf-8?B?bmRkTnk3eG5hWHp6amJUNTJnU1FiM3dFMDVrOFBJTkxMSGk5Y0RWMzBtRU5Q?=
 =?utf-8?B?NGJEQ0g3ZFRZU3NZM050MVlocWsxNnV6VkVsNUwrcWwrd1lHWllyMzh6S0px?=
 =?utf-8?B?YUdsOUh4QVUrUnVIVVBhY3dNYUtOY3ZxYUFXTHVFdlJYSjBOSVBtRSszMDZE?=
 =?utf-8?B?MlFaSldTWXJiYUJpckxReXdGdGpzSGdNQzNiOHZOUGE3cWtNNWZ0amhEUUJT?=
 =?utf-8?B?VjFZZndoUEYvcEpHKzRUT0Irc0ZwRFBkVDVUaXY2eE5WZkw2YkEvVzFqek1Z?=
 =?utf-8?B?MkQxa0wxSEhuV2w3L0ZEN0EwU0FtUmlsWi81YllOSUdDdlF1RURJaDBlZGJi?=
 =?utf-8?B?elFrNkIrZUJibnFRR21hNTZXRVI4bFlOOWV0R1k1ak0xU04zdnFaSTZvcHhV?=
 =?utf-8?B?cXE1cXRRUCtQQ3ZKNnF5ZHFvYTBwNkQwekorUDcwVGptQk1FM25CYXlkNXRy?=
 =?utf-8?B?b2FmeGovcVIxSm54azJtK3kxS2tLdndvckpRL0tHY2VHV2VvZWZlcVlSQ0h0?=
 =?utf-8?B?RllkdjNkaUJETEpNbTQrWVIzUDBNMkFhSDk5SnNQT3ZSeUwzTC9WR1FCaDRH?=
 =?utf-8?B?eWt0UUMySm9NZGczWVdkaVRTR0s4Y0orNk56R3JPTXpZL01GbjhQTlF2RXN5?=
 =?utf-8?B?N2lKN0tqYUZqVCtIdDl3eTBFdkJxa3JUcjNnUi9SbW9TTXlvYTVVbUgwN3p5?=
 =?utf-8?B?NUg3Q0gvL3JpYTNoUXpIb2ZRNFBvSnRMVlUrVU1UZFlOMU1nUGlqVmxqcFV5?=
 =?utf-8?B?bkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 2es4IKkfrkVLe5s/lS1Mie08A4gZmOdbo2Sp9uOxQcnOiuwZYx9H6mPdDIBvUzwiD7jHtbMs0FEQEzXWyo90CeWEKLBlh2urAUw81LgrTWRR2LUWHhS5CWYsRxiN4WR5mavBRv745B+tLcbsBBFp25vshIHeSdtpW9bUfLY0ChEH8x/OR4KCGOR5u284gP6/vFPSqGUHRXwwVvgIwwdwADR8MGGNpoPDLWA/H3j1kFwG7r+4EynVxlsWkQ6pLkQ4rMg+MqUdabpWGL3robXcTxPR9A1HalKJWxHn39A0YU7VKtKhxbxhKZccIEGk5bg6KkcDiESTTSRLRjdcadYS8Cdb9G4zpw41PHmfOgSLZjTjjV8dCmc1fn/4JL0MgnwZt+wCvmzWuMk1LICoJutjG83JkjVpycsGiT6vUSfUFAXd2mqceDBdchEEiq73e8CJlGlZkY/npj/1WZGK8uT9j2AvD8Uri9OHZuo1gkpX/Ymo3Cu11q1epBLUGa/MxXaBnVaPFbevA4BqbE3cReCQExOhYqhokIh9SrgpcIlFResr29/jBom3QGrl1NkhwVG3eKA92KqvS3TxAcTUXVXH0NPv37pkSEfTivD2NrnpmzjP3FLq5pQP9PNoQLc8pA++3crI1fxJIBv4rIIIvt4nZKUo686kYCH08lqa/Dorsf+oCUtiM1qLpEgrJFjvs4T61+jxJlYBot9DgyjI9zJXMk1eBSaYGMLQ8ZxFAGg9aliLK/y7vMNRyvI6CwafyGwTDnQr1Pgn3oWNL0V5senjx9CGp3EgETb2PabXKEj5rC0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9c2d41b-fbbd-4464-4952-08db5959a078
X-MS-Exchange-CrossTenant-AuthSource: IA0PR10MB7255.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2023 17:42:48.5888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /nOq/cNJXxgYXYF6KrGZqnuuKihly8DSohiip+SIuuWZnSmmOoW6s5WCkwc6bzj8NzCqPyceA8kiP3S9ouLX+gUX7h+Tyz2vgwyyD6jE/y0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5640
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-20_10,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 adultscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305200155
X-Proofpoint-ORIG-GUID: J8BXMKYvl6EwU4U6bWZO8npfeOGIFFfE
X-Proofpoint-GUID: J8BXMKYvl6EwU4U6bWZO8npfeOGIFFfE
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 5/8/23 11:22 AM, Maurizio Lombardi wrote:
> PATCH 1 fixes a possible hang when during a login operation the initiator
> stops sending data to the target and the login_work doesn't get scheduled.
> 
> PATCH 3 fixes a bug in iscsi_target_locate_portal(), in the error
> code path the login semaphore may end up being released even if
> no one called down() against it, this may allow
> multiple threads to access the semaphore-protected code.
> 
> v3: fix the comments' format
> 
> v2: the login timeout of 15 seconds now is relative to the entire
>     login operation and not per-PDU.
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>

