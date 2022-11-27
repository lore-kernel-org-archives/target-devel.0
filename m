Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15009C43217
	for <target-devel@archiver.kernel.org>; Sun, 27 Nov 2022 19:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiK0S77 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Sun, 27 Nov 2022 13:59:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiK0S76 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Sun, 27 Nov 2022 13:59:58 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF89CE2F
        for <target-devel@vger.kernel.org>; Sun, 27 Nov 2022 10:59:53 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ARIL4bb004542;
        Sun, 27 Nov 2022 18:59:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=QFV2OsqtLTTHGSVpSfS2Tza248IkSULmk+rTdp8Fk18=;
 b=1ZfhdbktCVespcrewWonMA7mba+c6Eq8LtWTHOi3h/pKl+geUB8w43upX3P/0rt5MgQS
 w03tOixW57cKUnAmOOC6ExzaA1918qF72Q22oFJUzOU+sMm+SMGobzn4o9TLI+i1yCc9
 pu5CJTwJ5QkQDoeiow3mqMMsS4Qf3h5CEgIXD67pR/hId5mI1wZBU8CZiR5rDHviA7md
 J7okl4pLlywN82YQxiYVwHwcAkhKZUaf+QUfOPntPEOu4ZgNLDpJslxY1SAVahuzEmeT
 zOMS11gQHdmz4WjM6P8fB3iD52INkcoO9iIcX46FpSxJVvvaVeUPoGH+VRxX+ekTLZ9D 2w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m3xht0wb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 27 Nov 2022 18:59:50 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ARFwOZI009947;
        Sun, 27 Nov 2022 18:59:48 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m398aa1ur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 27 Nov 2022 18:59:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kWzvNKI6PK86SoqoL67sFplADAQ9i5nA1QIpTt9nx2pYR1p0JyH86Y3EXnw0IXuWuFx5LYuszFJu5NXJjg8Ym+2JZ+QCfqAfUWJR0F7SyhFJKzwxZio8NswzDsDj2Vw60+OUEHDjVkWY6bdXTJtD3IHUFJkl2kzFBOYGRC2jK4urlJ5TQGplFkoNpk0XCvCfZqF2Vzl/Cm8cgnbzS7Hhkfx9vTfykyectNS/8oEx3ZRsnCTp+erNoL3QvSWVtG2GP6YOFWEciq5UBVG/A7kwI6c84f4rUj2WKg5CtWMZrCcUjvGGkqJKoxFIbqpGbRHsmcwSCRQO2CTBURcEqDkcVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QFV2OsqtLTTHGSVpSfS2Tza248IkSULmk+rTdp8Fk18=;
 b=erFKYLFJvmPC/5sSi0P6Xu9H88ylQIdOF0u9Uo1rKDMtL/NIvgwEWxvNosvX1X5OyEyXqhTa861hmEk5WO0aix14nZ9z+h8rGvsvOskc5ketWDt6kTTcuX+izuJwzaT0v/1IlTvLXPAArYhS4WNiLOLJR++3sF3sI1v79Hf40/ru0cawsQ0D9lK6WZY48gMp6sgpGwE7Y5yLWBwyRkGyROxZLa/ZfldUKcqg9CRcBtDoASa31cfO3J9P8apeLA47K4QQSvqGEqaVtVw9tJpuPiShg/RxEIbmTki1icZ3n92OqA1hGlms2iI2PS3J1Fo4THzIyxCAN5fO+r2cIYztwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QFV2OsqtLTTHGSVpSfS2Tza248IkSULmk+rTdp8Fk18=;
 b=BaoRnpT7sHBnku7kQ2AzxH5BqoZiCk2jCaGwmzFnx/6STZvDq7Wv3Peb6MfHug67VcYDM6bYH779k3gujd4Ejm9nOZkbmnZJcxRzXttrJk8v/wy0pYQZ643gyyzcV7xbkI1xQOKaOR3BuZz98P5KRGk5tqPxKkvYa7VAqoi7i+k=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by DM4PR10MB6792.namprd10.prod.outlook.com (2603:10b6:8:108::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Sun, 27 Nov
 2022 18:59:47 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99%6]) with mapi id 15.20.5857.022; Sun, 27 Nov 2022
 18:59:47 +0000
Message-ID: <0a6eb2d4-1158-5268-27d5-454edbf9f566@oracle.com>
Date:   Sun, 27 Nov 2022 12:59:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: tcm_loop and aborted TMRs
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Bodo Stroesser <bostroesser@gmail.com>,
        Maurizio Lombardi <mlombard@redhat.com>,
        target-devel@vger.kernel.org
References: <CAFL455kjQeqvPqd1CUqs7f6xUjrrDqR1h7edizusAtj130HCPg@mail.gmail.com>
 <caad6a7a-c30c-a3ac-7932-f5a19c877ffc@oracle.com>
 <e07f0fa5-d59d-36f2-d99b-73e32af3282e@gmail.com>
 <20221121133550.GB5248@yadro.com>
 <addec585-4271-cd9c-fcf0-fd780f269aa8@oracle.com>
 <20221125084920.GC5248@yadro.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221125084920.GC5248@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR04CA0030.namprd04.prod.outlook.com
 (2603:10b6:610:52::40) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR10MB1463:EE_|DM4PR10MB6792:EE_
X-MS-Office365-Filtering-Correlation-Id: 92086c26-70ff-4d93-7298-08dad0a98d02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ksnApOdHFUM731eNDz2wJMVFq5hRzjq93IoevU2DEcWAne+vkSuhCFYclLD5iRhrTac0urdGl6Z3RFgRVe+ffKxjoeeE9bgU4Cac8Onlc70K/FukepR9uAeP+O4M6Iw1jutWMUqCTQcnvqScvtvNMTFav9vKFPmBh+l+26TA5L16ILxW2s7C+OipvriwtVXlUYU6L44EvbrVcnX4S+8H4/6syv9PkZZ3dfYOdg5MRhc2pIe5xtZexk5fYi3N+G1XvMXmeLUagerlTkHnYaJit2133BMloXrfCn9152wyfeOE35KtVyUTDRS+ourvxo/f30zkUgy11MJSl8LVdmh0pDkG0hNe3nW1zl93SWaX9PNN5OWHgbjQpJKwRy+YtIYTpeK9FYvZhWTPptrRkzhp7qjRTNdeSeN86UOcV4gYYpTPmYZJZSZKvLMaaq7Rb47DQ4sUBbijNqUeh/0RCqZ+kGu0TSctkN3s0qbmKOfAkrBenslujyBOKH9u2w5EK3zwfO9MrhIfAYVHpIgnBQCIoNPAeMvC+1NYvvufCGHkimJZeZTs+xRWPGsoVr1RZ+ewawuZpnzt9dBFeZuOOSa4YI/Ta2/LOub5CCVxxrEHDIakqc9zpA+bZIVLIIJvGB6jKLJsfjlIeOiBZID8/eUy07cVCbOy7aAUbTfSQO6jysElz73CZHmkoWX2B8oZH4gitD3Jf1/1EiNAskS9P2l5fVynDXkg9SjGRW6rvUIKTc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199015)(186003)(8936002)(6666004)(36756003)(316002)(26005)(6512007)(66476007)(66946007)(8676002)(4326008)(66556008)(2616005)(6506007)(31696002)(53546011)(86362001)(38100700002)(5660300002)(6916009)(41300700001)(54906003)(83380400001)(31686004)(2906002)(478600001)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHNKYmZlT29ySnZiRDhLSWljRkFZYU1QcVZzNmgwcEtyY1BEOEdHYWtUYTRj?=
 =?utf-8?B?R2ppMjVQVHVMaVNidXQzVEhDbStWeDEzUm42NlVQNzN2WFcyQk54Zmdjd1px?=
 =?utf-8?B?YXRYak93dnRhR2ZHNFFCZDRoMHBBVmY1RGtVV0pTeXlEcmJrdGZMN2h4WFZv?=
 =?utf-8?B?eWtaeGVQTElFUW1HMExOUEVmTkcyaFlKNXZvTVlEUmd5T3E0LzlabHBtL3I3?=
 =?utf-8?B?VXlXQ1FDRU4vOEJBWVV4QU51empBbEtVbVVKZmczT3pNZmRvaGRaYkkzV0FV?=
 =?utf-8?B?S05aaU9LUFZMQlBYSldpbUZ3bkhnVWhhZkpGU2FtR1RxYjJPZkJib0hGZjFv?=
 =?utf-8?B?dDN6R1FTL1l5Yks3WWcxTW1QSVh6STUyMXJ6YU85aUNuZ1BydU1leGNqT1Z2?=
 =?utf-8?B?Sy9rTFpKNU1jT1h1TC80Vy9RSGhrUTNzU0k4R3dWOG1CdnlXWTZZYUtzN1BW?=
 =?utf-8?B?SGZORDA5T2hKdDljMzBLWkprNGI3MmxvWUtZZTdCSW95NDFOM1VmcHJNZE1X?=
 =?utf-8?B?Nmdhd2VOMVA2aS91VWNMa3hZeW5FWG9WUzhiQUxQYUlqSUxLbkVMVzJFYzRh?=
 =?utf-8?B?dlBvTXgwU1NkM25mbHB4d3ZpQUpYem0rODhramNHY1c1dCtmcXEvcnVnRjla?=
 =?utf-8?B?N3VTZ2RXSjlKUVV4N1FDN2lkRXBwZndUeDd3N3pzd2hTVkoxSHFVK2FSNGo3?=
 =?utf-8?B?WEQ1b3k0TWFKdDZZdHVFL2ZrYTY2QnZrS1B6TWkxcXYybkRnNlh3dkZPcFFN?=
 =?utf-8?B?KzZwTUFOUVZHMHVZeHdFT2ZUelpOZEk4dDN5TUFQZS9LVjJ0a09QdDcxcGhK?=
 =?utf-8?B?Tml0bWxEbnZvbXptQ2Z3QmlYdG5lRkd3WEJmSi9EWWVjZTZVNEFYS0RjQmNL?=
 =?utf-8?B?WFM2WnFGaGl2b09tTHh3eEVpSStIWk14MzgvK0J6RmpLSFhVOFo3anBRRkNi?=
 =?utf-8?B?bzZtcXdQYWs1V0kxVVBhWXB0ck5WRHg5dWlxL0JwTU15WXhxNFVLaEpjVjVC?=
 =?utf-8?B?SXJocVJ3aFZIYTkyZDhob1duMEtpWGpPcE84bmh1V1k1c0NkTHY0djNwUkpo?=
 =?utf-8?B?K21PWXNWcmtyNU1kK1lrVUQ5YVdaK3lzKy9HWGpLVnQ1ajB5WFc2Q1pWMGQ2?=
 =?utf-8?B?eHRjNDJVWE1WeTVRUVF2Slo0THBiYWNYS2hvWGtPQzcrYzkvM0ltbVZaMGRL?=
 =?utf-8?B?aGRoQXNWYW9YdWxtc1gycDZJNEpsSERVemxyYVJBNlVTWFVrQkFWTWVVQm1o?=
 =?utf-8?B?M1prVmozWjd1U1lrMVB1MXZvMWllK1ZmU3FKUVRHQXJFRThHMllEVGhTNC9V?=
 =?utf-8?B?RHV4ZUlUYUk0d3hzSHFJTlorVHZ1bXRNbzYxR2w5ZVJXQm1lYWlPVlRINUl0?=
 =?utf-8?B?RUlWcXg0RmdxOWNEUzR2MlFZUnhSU2R3c2hsdkFUNVUzR013ZnQvVkM0ekF2?=
 =?utf-8?B?R2hWc0tDMXFqWkg5Qyt3dGQ1Wk8yanV6cU94Y2tCcjEzVlVXbWxRY0FtV1lw?=
 =?utf-8?B?QngwNzZidGhzZHFkRjlZaC93cCtSQ3pOYm1qUVFLKzhmN3M1TGJHQ3VnWGpx?=
 =?utf-8?B?cXB6WTlXVm83NVA4WnBjeUVROWV1TFdoaHlrUm40MCs5aUM5elNVZXRMOEUy?=
 =?utf-8?B?eG04TlVzRi9STTI5djNDSXY4T094MGk2SE9UZUs5dFZWaS9nWmhGbVZ6QVY4?=
 =?utf-8?B?eFMwTjZEZUhoNGNDdDh5MzFSN05JRmliNnZSc05TTGticGF1VklDaHRvNU9p?=
 =?utf-8?B?ZG5TeXQralU1MWlyRlJNc1preUFTT2YvQlhERjY0enRpYkwxSFliYXY4SHNk?=
 =?utf-8?B?bHNYNllRWVlKSy85Yy83SDQ0bXNCR2xiU2F3dTdDUFc4bmp3TkxTNEFTY2wy?=
 =?utf-8?B?aTMxRUx1bnVuOGM1TmRPL1l6UHBTcmV0S0I3ekZqcjRUMndlYUxyekJQQzEw?=
 =?utf-8?B?Ymc3dVVrQTBWOFV2UW84NFJ2NElQem1YdTU5ZWxwRXRUWEZSMGZnTnBZTVhz?=
 =?utf-8?B?dU8zVVhuTkg5VFFUb1d1UFdNczEzaU9pNzMxWHlhODI4b3hDVzVubjFrcE1E?=
 =?utf-8?B?MXFMZDdETWFmRmRWc1Q4b3BSVUZTdDVraEtPUTVHNUpHK3Zub1dyK1pGN0Fn?=
 =?utf-8?B?cDdadjBzZmIyQmFsY0V1bThJSHlVUHB5S0VIZlJLejdvUFlDYkErY1U2WTZp?=
 =?utf-8?B?Q0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: dFgEVpiw39ewXbWONkbjrb1nr6xQjPDNDUCbn9NrC9UWYhozNN3KoVjrnJmdbmPmsLYtj3nzb2EZcX1KCqD4BKcBin5fk2opF4+oyK7ev1XCav+MBepelR380tXBBXiItvgh9Fs/5HZNVE0m/8OqBgJezaBLUG2yVfCM7BySX3BK3aAErSIEftU6eQOn9R3QiSu0Ku4bcmuWscJO+ntMADqhDiMBN2fnurGnEqmf32kYagu8T/0hOgmNWP8tdBxKx0ueFcyn/AZoF9K4hxgVRltyQmNO5cA41FWzj70pFJ2OEkAEF6eEy9vrInsmSQC4FGCfHE2qpqNjJlY8OwxUg1086jhEDj4xQbiSnDHdGuFbr9nSX7daJH7igvPl4OHA7ytpRGHsNrcxRX90r2VWbPp+ul1YzmIB0R255a6wFxozzIwapTOX5R7f+jWtI8dfI081aKzjUqC2+/4gipHaPYMLDxDVMDwQfaw0X7f5Y0x216Gn2TGX2cOHmp9nmGtviMHpcPJEshcxm0rB2I6FCRho4VjZ0Wm58GvoMVxTWoRcZJI/Sq7IOV6Tmy9Geqsy7njrQxyIphSI79EDqEPi8dDM4DXI2nkzx0E24n32O/7FYLYJvICtV62idkbyYrSZA7x+UpjmtJ9eCr1KoqeNXq5EUeO02m3tWF0wRXWXSjTHkW36Rssh+jNk3WOqrmCG+M/zgP1v8n5u7kfaqGO0Di2qfiAS+MKs2raS+d81UZSOqLzb/pa+Nn8UcWm8lApD3mqiWLecxGdSzUQdDYkzLxoHYca4D69zewX1DN3u/O7I4g1gYhIi6X9U1twOpk0n2jaBf52e9RHs8TGXsZEc9nySnAw5Nf7UbbtFK53mvBI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92086c26-70ff-4d93-7298-08dad0a98d02
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2022 18:59:47.3737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b4Vd1kgugP/rJAqILPKfhhxKQmquzLobGAXnEXA1XzU4E445xjQheniV48dymLOxp8EUnipVK7q0JoRav+XVsr6Bw3mEe3KL91xXr6oQ/1E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6792
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-27_08,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211270159
X-Proofpoint-GUID: suGvuOsv02aT-1Vpt2-f1eOAAjrL1LhK
X-Proofpoint-ORIG-GUID: suGvuOsv02aT-1Vpt2-f1eOAAjrL1LhK
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 11/25/22 3:34 AM, Dmitry Bogdanov wrote:
> On Mon, Nov 21, 2022 at 01:25:55PM -0600, Mike Christie wrote:
>>
>> On 11/21/22 7:35 AM, Dmitry Bogdanov wrote:
>>>>
>>> I will vote to your old patch. qla2xxx was fixed long time ago.
>>
>> What is the qla fix? I think we still leak. In commit
>>
>> commit 605e74025f953b995a3a241ead43bde71c1c99b5
>> Author: Mike Christie <michael.christie@oracle.com>
>> Date:   Sun Nov 1 12:59:31 2020 -0600
>>
>>     scsi: qla2xxx: Move sess cmd list/lock to driver
>>
>> when I changed the locking I had added the check:
>>
>> static void tcm_qla2xxx_aborted_task(struct se_cmd *se_cmd)
>> {
>>         struct qla_tgt_cmd *cmd;
>>         unsigned long flags;
>>
>>         if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
>>                 return;
>>
> Yes, I was thinking about that commit.
>> because tmrs are not on the sess_cmd_list that's accessed the
>> next line down. We don't crash as a result, but I think we need
>> to add code to send the cleanup command to the FW. Bodo and I
>> were working on that part, but someone with more qla experience
>> needed to work on it so it could be properly tested. We didn't
>> hear back from the qla engineers so progress had stalled.
>>
> Yes, you are right, FW expects some response on every ABORT IOCB
> to clear its resources.
> 
> I can prepare the patch for qla2xxx.

That would be awesome.

> 
> But still, I do not see a sense of new Bodo's solution.

Drivers are crashing in the aborted_task callout. His idea was a
workaround/hack so we would call the queue_tm_rsp callout instead of
aborted_ask like we did before which would avoid the crashes but
allow us to keep the async behavior.

To the initiator's it would work like before where it looks like a
race where the abort response is received right after it has sent
the lun reset. His assumption is that initiators handled that before
so it would continue to work.

If you fix qla, then we can easily fix loop and xen and we can do
the correct behavior and keep the async feature.

