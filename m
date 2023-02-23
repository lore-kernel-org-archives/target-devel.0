Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2FB0C636D6
	for <target-devel@archiver.kernel.org>; Thu, 23 Feb 2023 01:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjBWBuL (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 22 Feb 2023 20:50:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbjBWBuK (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 22 Feb 2023 20:50:10 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4020124
        for <target-devel@vger.kernel.org>; Wed, 22 Feb 2023 17:49:12 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31N042QI030944;
        Thu, 23 Feb 2023 01:48:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=RM4a4kQA0g9/WzNGPS3W5I/Ub+L1sb+j4YONBDN/z5E=;
 b=ll8i7lb/AP/sd5HhxcUT66lN1J+Lj06VGDzM2N49UVjFWDdxMMFirrRWMZ7FfGRBzc9s
 vODpcEPyWqLxPvhFWYXrRdS7/p57jqJYJvj08GqZRTtAjkeG6LJ9xBZ9gSOuf+lLtHBe
 WcLOb7A6uaDNvKsAjYvlq1jkgfp3xIWhrwnklDOQZ8zc3kdJ08V9Gm0OioohoEayaZ1E
 gcthcB9skFF2k4qAZzSwYVHTAkdrICkYiPUyywQhDnpTK2jBY5xRBYkaHihi1fFCjBR1
 hwBdm+0VAAVjnsUQguDZrSYk5VTmn0zLl4E7IgtjKCT9ju3SJEN8Cy8UMqoQJPbWcGPY 4g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntpqchgeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Feb 2023 01:48:19 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31N18mDh007068;
        Thu, 23 Feb 2023 01:48:18 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn4dxf8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Feb 2023 01:48:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mFzHtDImDICO2zqYrXVorzKyCcFpt60+NMKX4i6YRdoh7NPCKncmuD4MyjWfyW9RyEY97YxEr+YOqyWhoHKAS3sBX3jBVubT+SZACeJJpUAGEjTL3HBFz9Y0TgUFl9HrpHobMKOlMvASAsx9eE7TAlRsPSy1raFPqoFBs6VRvk0LQEhJAdHveNPEmQzbmQyif5hHeaQNTB8SFg/2hDTgW1g9PkYbjqgc9ltee9Z0FDXT2EWcrhVTj2ZtP01OGjx870cTpDPUR6aVgRb4nzkoPLPfDt471m0v2T/iaBW/+f2v9RCooDg8mKE1CYv8gu0sWb03Y2Q0v2i5Ue01+3Ah5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RM4a4kQA0g9/WzNGPS3W5I/Ub+L1sb+j4YONBDN/z5E=;
 b=VnoAVQUYDG8rgcS9umN0MMYg134R54z9JfgPLVkqzbunwP+KIz4zmsPdOs/YvhTX0fzizA6lpO7BtI4X407o5ot+yzdWe1LGwBKsVI/ZgubVp+yJH3dsL06jHtC2AVzRF3qMQNjr0GgDN6JQzfAB6s3aiExtj1eQDhuf8K0GXWfb+cQoNfrsT16qeJZdBvbRaRnh0qWHgKUMS8QppAP7azDUNjsEgaccJPrkcOEe4BsDJdHpUyOM1+mbguJboPxVhNiiIQciq18xKH/2OECkLRTA7p4YTwlZk3WZUvL0guV8XLFnlN0z5Du74cmDNN6CawY6amjo3HOS1/2CQcgIng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RM4a4kQA0g9/WzNGPS3W5I/Ub+L1sb+j4YONBDN/z5E=;
 b=fgqpX15pryKh4QEn4qe3AsMS47GuDMs/ivCiBszoUD4lfQl2roqJTDjp9srqL61AdlSZfYZHY5nodpH89nSTWdtpmk9IukaUDiITQOOxulmmZXUcoOI3yNKk9CljDKBTJJ8EQDmZKrA1Ho3feIITTUTNt4LyIwANXTMfoFOESnc=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by IA0PR10MB7231.namprd10.prod.outlook.com (2603:10b6:208:409::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.17; Thu, 23 Feb
 2023 01:48:16 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::dddb:e861:6afe:915b]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::dddb:e861:6afe:915b%12]) with mapi id 15.20.6134.019; Thu, 23 Feb
 2023 01:48:16 +0000
Message-ID: <735d5493-1f5c-6650-a700-2f25ba06aa68@oracle.com>
Date:   Wed, 22 Feb 2023 19:48:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] target: iscsi: fix an error message in iscsi_check_key()
Content-Language: en-US
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org
References: <20230214141556.762047-1-mlombard@redhat.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230214141556.762047-1-mlombard@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7P222CA0029.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::28)
 To CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR10MB1463:EE_|IA0PR10MB7231:EE_
X-MS-Office365-Filtering-Correlation-Id: 03d3bffe-2d99-4a74-840c-08db1540081c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sf72m8e+sckpZ35E1h0CKqDbt1qoiFmM2CE3Mr5hHjmTNDYsPdhdUYfKDLruog8Pj4wiOzCxLUDa02A04DadwH0AjWJip1aU7G82hlK9jG0Nef6otkz9RFjXIms+RhKOHLMBz5ccVJSEAp1tImaFx9G/pod6HnbM6UHydD1EcfM5rF+UTmXb77FuLwWPt4VDljOYcFKiODL2MyqFA2a8d8z3hLBRp/A2I4Xm1NeMTOlBujRDQXio4Juw99t3G3PP2gecr/oI5ap9haJm+5xqxVaLrO/kIAnJUchqvaFIibJPHHluH55uqOwMm0jdUqMFMYNtT2Es+AAG/nnbtknqw7biz9K39HALVAP3BWPlogaoYOhA9q6brRDB6MbMmph1cmJ3b1qSGy76Vc1SICRI6WJAaHvwDHg1xtLbI/eChW07fpGMO2nMdpgVVmaa6c3+KuaYseFsqYdnargFZdkcPEniMI5F19BUsLlEja3SHzhKHoJ8fgx9aC5v0YPTjeHMMiBcxxT4MtLF0+gNOsj0zwG3TFtHgZ2+n//U0ZWwA8jNK5JR5OxClkMi5IXrIQwnUn6wCFh/Wxdl5Hplslg6Vsk5LhB9N/jLG0GKlvJrIS6pUBqBEM0kTVgBSq8MR+ZMUse2lH/Apu8LvD0tA4GoK1IdqaFqq6l4wRrDEZp8AX5WeaOULictyNSkbsQk8zY1Hz3tcK4ldJQT8SrZEGgJ9oHoK6k3OVO0SQ92AkVq7Lk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(366004)(396003)(136003)(346002)(451199018)(66946007)(31686004)(15650500001)(38100700002)(31696002)(86362001)(36756003)(2906002)(5660300002)(41300700001)(8936002)(83380400001)(6486002)(66556008)(6636002)(8676002)(66476007)(26005)(2616005)(6512007)(478600001)(53546011)(4326008)(316002)(186003)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WlVMZ3p0Y1BCam9NM0MvVjJNekFTUVJZR0JCMVlXZEx3dUF4dmVUc0MrcnBi?=
 =?utf-8?B?SHNsTWs4YWhyVmY1Z1NLUDczUzFYMHZvalZrQTFOU25ONC9yTE1XSklVUFFv?=
 =?utf-8?B?OGdBaVByKzIzM1gxWnZkRk1pN3d1SU95R0hFa00wSE1PbkdyWC9YTU1TMXNX?=
 =?utf-8?B?b1hLL0pSMjJMeXZYQ0x2eWFpTnpoek83RkVVZHJJcEhyajNCS3BHK0dQVUha?=
 =?utf-8?B?MGR4UDdLcVIwTXZncjM1cmN5YTF3dDZoOXVTWG84SzJkaHpQUWM4ZElYYWx4?=
 =?utf-8?B?Ym1KclV4dVlPQk0zZnhTNXljYXhrZE9sQkFVUFRKMHJrMXRDTGpaa0k5c3VT?=
 =?utf-8?B?WXhLbW9iQmxBdStINXZmOFowamlHODRpMkFCb3J5a3cyczlGd2tCTXRQbnNR?=
 =?utf-8?B?WjRYZzB5d2pPc3RLM29uOFF6OVdhUU0xVGhEMGNuUHAxTFNJU3JET21EaWpp?=
 =?utf-8?B?N3pwdjRqeG9KbitKbHFONmZpbHM2cmtzRlROVlJwcnQ0VllYbmZvbGUzNFJO?=
 =?utf-8?B?MjZuYVF0N3dDck1oN2J1WUhnOENlakYxVlNBVWxRVldwaERVRjJSMTJyWm5t?=
 =?utf-8?B?ZUxhTE5jSlVSaCtGSkJBV1l1aXpGalpWdnNWVXArM0tUd1N6VzBnMnVaQU5k?=
 =?utf-8?B?Wk5Fd3llTnlpUm04aGEzNHRPU1B2ak04dmxTWGNSZTg4ZnhzV3lTQzBWZ3lZ?=
 =?utf-8?B?QTBqY2dtR1FvbUhUdUhES09pS2Vwd2VUSi9YRXlNY1Q2RlA1a0FaYmFjQnk0?=
 =?utf-8?B?OVZQOXltU0lybkl4WkowZkpxam5pRm4xYzdSWFZSNWJDMWtIVk05MjMzS2lq?=
 =?utf-8?B?bWdkOUk2R3l1VjhvVjBCeDFtWklNWllNTlBpemRpeUt3dWMvekxqeE1DK0FY?=
 =?utf-8?B?RVdSOEEyRVZxT1RycmhrUEQ4Q1dUZ0lvY3B5VzlVZ1M3M2xSYldubzhtVjlV?=
 =?utf-8?B?ajRzdE9WUWZIMEQ4b1BmWTNUa1kvM1d3bEErcFYreE14TEFQYjByZTc0UTZs?=
 =?utf-8?B?YzEwaEIvMElzWG96aXljOWpnRTNUeW04U0ZROUgyREVDdS9hZ2k4bUZqNnpQ?=
 =?utf-8?B?MW94cnJLVXNNNXhlMjRQbFN2Nmw3MXExZ0NtMWtOTTVMMkVXOWJsTXN6K09G?=
 =?utf-8?B?bW12bmZkZExXRFltZFVoN1dJN25ha01VT0UwNzdmT2g0dEE4MHR5YkRIckpz?=
 =?utf-8?B?L05wVGllMyt1aTlIWkFXOVdXRlJveEZjZHplaUtIbGQ4T2dEMEhtd0U4VFV1?=
 =?utf-8?B?TmRtVnRSWjM2a3hzNGdFazFoVlJlcENhelNuS0xpLzBFRE1CNjFvMkNUR0E3?=
 =?utf-8?B?RUF3eVdzbGZLdUJMZ01sNDhKM3BmS2R4elRvZktqbUY2SmtTdk5UQ0lXZ3h3?=
 =?utf-8?B?Y1FVZ1pwZS9HRHNYUkk0dXZ2cHBIK2owRno3c2U5VlViVUFXTWMraCt0cWky?=
 =?utf-8?B?SUJhbEJIUzhNNUxtaHVUaHFGTjBzNGdiVlNydWxPU2VmVVpzaGdLNi9RTmJV?=
 =?utf-8?B?MEY1VmdWeEZCNEJlTE1RVllLMitwWExlN3l2eEI0ZG1CZ3J2U2JmNm94N1JG?=
 =?utf-8?B?QzVqSnFQRExkRkt1ZEh3WW1ZV0ZKL1NPK0g3UVUzdjQ4SHNVV1B2VlY2aDFx?=
 =?utf-8?B?KzVrMjNVNStMdUthY2FzbXVwSEZXbS9WRlhjZDFabEc2OURYS1lKQWZ5MytI?=
 =?utf-8?B?S3o5TkhwdFRZbFZJZjRub3dKdTlWRUFTRVpyMlVWS3ROcElkTXoxZjNlZUVS?=
 =?utf-8?B?MDE0dHVZUjZYbEJsL2ZXNUg3Z0hqYjVsa3RhUGJPNGFLT0lxSEd6OHJ2MVRS?=
 =?utf-8?B?NjZBaDVzbVRUWUlneTMxR3dnWitYT1RzSzBVNWl6d3lQcVoxWSszeGhiY0Qv?=
 =?utf-8?B?N2pWSUtpS2tjWGhxa3l0RWtXTHNzNmorYmxoZVJZVEovcDZzbW1mYlNIY2gx?=
 =?utf-8?B?bGZZMEVMQ2JZTkFpNHhERkhmeElaci9WZnNnOWdhLzJDckNsQVlIQmFGRWMv?=
 =?utf-8?B?RkVXcTZKT2dxOEVjVXUvVk5zaDJVNWx0OTNjREEwcHZVQi8ydmNqZm5JQnAr?=
 =?utf-8?B?TmUzaTlNa0FBOUZwK0VCb0Q4VElSSmJyYnRvUFkra0huM0ZhNkh3MFFXTVdE?=
 =?utf-8?B?OXNXRlRYcVhucVVNVjlIY2FnTGhpeTdQOHNFZEpWeGRGTFlHeWlDb3YxTDRs?=
 =?utf-8?B?YlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: xu/0BCn5Z8rtufMFhCtcCcF75utVlW+0H6iHC1YRVRAfuBkWAr0cM0tBv4Bi8GyuXh0PQqtJFD21D/PBfWUv77W++8sDf1fpf1ew/MzwCR4AqHftBh4QCcV7J4noo8A8FEWrQaKDk4xKVN+y6vlOlmEde1rgt7yut7nXLiWzlVHUmK8wN1UtjgpZbSo+9WZ5kq/vu3mchMp9zSXdXQ4BdAOQ7tmhWbXwCkglRaLzwPCKZ2EAH+nKK+06PP5sEN88PDLAO+7uvnRpSzTimuouDp48gr5jjAsatsM2twUT6pEwyAHxkOu3OfwJqDhEcEx/9Jx1w3qkW1aNc1PAK8SW3QgnMAZEv7nm2v1ffqbb5WyowFS7ica+6OOpjFCKPLfnXGS0ombXEvzCDRw1qisR1bQjf83njHNot7LYKwyZcD2IsHQCCgpDVuGlo3jJwR1SVPvxPgWpKC7FfOcB/NKYxrzdYSLq1ET7hWADroODB3cbThBNL6WdUAHr2jSSAjWrPgykoggrFADbPCy/j0OPaxNnyaz67mz+OfC0l50uicXev/CWtgV0F0t+OYbHzibMe21Kw6OdLdxT3NQSs1W3EEde0DMaeqSHAHTA7z/ZTXhHz0npRzVhgORV1sEyXc0ytA56Jai4B+SMjukUWQ2LENwf9TpDcRQmoenW7ie9Jr7r5fK68DqGAOTUif9Mo5ltbhOmugdco8XNpp09podNkM4pZ8T13kb8zqDR/kGvE1wk6/Lw8nv3BmVe9ByGptKWAt5x4sLRxQ4oPSmp/5nWoDw+LG/Uu3FCI/6sG538FLw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03d3bffe-2d99-4a74-840c-08db1540081c
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 01:48:16.3577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fnUy5enNCUhXWG1DHNzQURWGINWZPCQyO7ztQgFNsXNrz/MbP7GVmqPP+znzEY+bMcZo0ExIPZI0cjxQ8ZchW0ayz2smUfnd3ZQknGnkuIs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7231
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-22_12,2023-02-22_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302230014
X-Proofpoint-GUID: vcjo2gnsSeqSU-n_eVzMpxnwrxbVetlP
X-Proofpoint-ORIG-GUID: vcjo2gnsSeqSU-n_eVzMpxnwrxbVetlP
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 2/14/23 8:15 AM, Maurizio Lombardi wrote:
> The first half of the error message is printed by pr_err(), the second
> half is printed by pr_debug().
> The user will therefore see only the first part of the message
> and will miss some useful information.
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/target/iscsi/iscsi_target_parameters.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
> index 2317fb077db0..557516c642c3 100644
> --- a/drivers/target/iscsi/iscsi_target_parameters.c
> +++ b/drivers/target/iscsi/iscsi_target_parameters.c
> @@ -1262,18 +1262,20 @@ static struct iscsi_param *iscsi_check_key(
>  		return param;
>  
>  	if (!(param->phase & phase)) {
> -		pr_err("Key \"%s\" may not be negotiated during ",
> -				param->name);
> +		char *phase_name;
> +
>  		switch (phase) {
>  		case PHASE_SECURITY:
> -			pr_debug("Security phase.\n");
> +			phase_name = "Security";
>  			break;
>  		case PHASE_OPERATIONAL:
> -			pr_debug("Operational phase.\n");
> +			phase_name = "Operational";
>  			break;
>  		default:
> -			pr_debug("Unknown phase.\n");
> +			phase_name = "Unknown";
>  		}
> +		pr_err("Key \"%s\" may not be negotiated during %s phase.\n",
> +				param->name, phase_name);
>  		return NULL;
>  	}
>  

Reviewed-by: Mike Christie <michael.christie@oracle.com>
