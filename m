Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D89CFEB64D9
	for <target-devel@archiver.kernel.org>; Thu,  6 Jul 2023 16:36:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbjGFQgT (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Thu, 6 Jul 2023 12:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbjGFQgR (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 6 Jul 2023 12:36:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4341727
        for <target-devel@vger.kernel.org>; Thu,  6 Jul 2023 09:36:16 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 366G3lil002012;
        Thu, 6 Jul 2023 16:36:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=tCBvzqdZ+b8OMlNhylYH9NMbuzP+skilDqYLubIEooA=;
 b=Ot5b2/HOPXszA3p98wkCHWeEWrer02hY63DtTEiZDyQGZqUcEqtkZhlrBBeOSbAFRkoq
 IVxueNwEHS2YEEF11kn/1iEUcOzTw1V6d+1ukSJemL1Ze042bYx/CAdCNAF7ymkv7T1q
 O9iVNC+f0yWFIzntzr5VhavmRa1X4VQLzReakSQmKBI+lNYPUGqUu2iTfcYEjS4N76ii
 YSRLJtpdqSex54oZlNMV2z81ypOHJLbYjfqLaa/8OCFWgNLQ6Ul223U6BfRolYpor1UL
 V8JDPbquLYsPL7kmWT/132cbWOsULxBgKLUbx8NW+9yUhjiVI/T8/7geZuspQV/vOPH1 QA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rjc6cs8kc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jul 2023 16:36:14 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 366FDSZQ013499;
        Thu, 6 Jul 2023 16:36:14 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rjak7as51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jul 2023 16:36:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=moTwMiH9MAInLxqw4+yDw31rYTMB8C+2k5VPJfeo7NUjA4wt+7CTUxAJsZK4zsx0iIS/5PyUYBCoCnJ/6JHOFcHwnQuzcrEWs7l8N1H+Y0JHmpndus8cfpFFfwuYKja6GjPAQ0as0RHa+4+dsvgIs8Kdrno777mdwDVoiohrbNcXXUXRUZWGtwPi+wreCABsae+tpY0ZDGwu2BzH7923TlySXGd2d2MlFak2HEMJq9E/9g/ZI2HMjl7GTVHtt4VSIdQd+iIbs2Z8MBUCQnPoPLPzyjWD2YLqFvTVJpY2Go+yOCbdXM9s3fg78pCqR+Ao+m41cuM8gIBfGWFscLG8HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tCBvzqdZ+b8OMlNhylYH9NMbuzP+skilDqYLubIEooA=;
 b=CUbuLb/7vXyd4hK/XgV5hHfQfrFB5twfGcKa6lbMxAGVyJE4TR3GM0IvLLrpqlsNgstbpS+ondEWCc4Zdo28RoX0pjXbgLbM7/bZVNJcZnmWumpdpgsIP9vV+1BsuFpTSeqZkR0YqxzDwMSJxemJSMsAPNpuA4p8YszaGtcGN7x3VBSComLWH5XQ9LNeEsw40zAiCd/SE1+ufb9NgvvedBRnrD24h/O//JAFm0thEq0ZGa8EkxTgH49eS79M9WReVGEmVaroBsd/ONiVOe6Es6jTGXvyQNKpT5KYRZAffcOm85l1Ls4bZT+HNUgpFb5TjnmKd5bHNFcD2p2l7XDDIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tCBvzqdZ+b8OMlNhylYH9NMbuzP+skilDqYLubIEooA=;
 b=V1kwJQ2fyZhq0faIz7U2UC/qmUvqJWd+fdplOZHfHZE0yWMeYjMe3f/wm7ltdjE9i7G0xLh0/Vu+eLEkjtcVX33xn+B+03Ogu+dR7vfTyMEHrHjFq2lVWM0NpcGipE8bwko4HohHkuL4ceFbcoi2mMt1MHnlRQFq0Q4eJoXked4=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SN4PR10MB5575.namprd10.prod.outlook.com (2603:10b6:806:206::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.17; Thu, 6 Jul
 2023 16:36:12 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.016; Thu, 6 Jul 2023
 16:36:11 +0000
Message-ID: <ca8eeb50-066a-0407-78dc-dcb5b6b1a82f@oracle.com>
Date:   Thu, 6 Jul 2023 11:36:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] target: iscsi: remove the unused netif_timeout attribute
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org
References: <20230630155309.46061-1-mlombard@redhat.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230630155309.46061-1-mlombard@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR07CA0024.namprd07.prod.outlook.com
 (2603:10b6:5:3af::6) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SN4PR10MB5575:EE_
X-MS-Office365-Filtering-Correlation-Id: 604decd2-2fb3-4088-213a-08db7e3f1b8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fxswAMbE9Tt1Prt3YBPt3ROCTQCYtLSTecG6QMugGkPRONm35jmFwTcHnzkx5DlAjNv/97EYGPZLZsMvmOM8+U255d2/3GTCw6HUbSoye0vax3EdG4u+//tkiiAeSb0ac99jaoqXPR/lkSscPWjISx1FB/2D5/tqUCBw5ZjwneWginzPgdsHFB56e461O1H/D3WV37LQuW5Om5UNSnmZVX707cpe4YVdw+yta7R85tN3+B+hX+Z6tgFAEb7hqHDEWxBY2YdWes/i29BG2JbIahFyy1AyhPBSLeJvEbqRHsBCMBFuaxgeHTQIqDW2uAenjG4Xo1DSEiIIZR22AMJFTqF7GVCDyW0gI3Qb7cgE+8nnFhe5iNMr6EP/5eiSchHv52Af1cUM24PW0YELzIeqS5giMEK0uuQzijIavP9nzw9FWeNyulKXq1q0SMweWlznmSHLkRm/7a74fucWLEjvXY3lY4rBViwLuUKBIqJ1M/hqgfwUAW2OzP9BlC7NJZo+zg22wDqswoECmARYz1qVCcXzq3dLKFJjbjwPRJQC27fkAya5swUCXplLSBGJ/g9TLrW7W9Y90EOVG1DUFFb1KEU9/CAMHrJoly4n3nEZc1QJ32bu/38GupcfHKWxqFKP/zRUiKbgC5ax0fpf8zVthQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(376002)(366004)(136003)(451199021)(36756003)(31686004)(5660300002)(31696002)(558084003)(86362001)(2906002)(6512007)(66476007)(186003)(6506007)(26005)(53546011)(66946007)(6486002)(66556008)(38100700002)(316002)(2616005)(6636002)(8936002)(478600001)(8676002)(4326008)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UkJSZ1ZmQmh2bEJqWWI2ODRLZ3gyZDFibEptYTJvMTdUYUFnSDhUQWdVcVA4?=
 =?utf-8?B?SWI2SGdCMVR0dXM3ZFFXQ1VOSDY4TEorY1locmtiMWpNb2Jncm5oYm9mdFZj?=
 =?utf-8?B?OVpmNmoyUTNQQWJyZlcwVDVOOXhzc0hSblFXcnhLUXNmMkZrQXFKbmFYcnU3?=
 =?utf-8?B?SDdIK0VlZXdoS1pIc3B6UnJFNkNCV1Z6TTdOUE9RdE9QbEtSc29rNVZzSTV6?=
 =?utf-8?B?S1g2QWVOK2hQV0VkdGdsZ20xVERvbit1OUs3Vm12M1hWcnZkck5FR2hzT2NZ?=
 =?utf-8?B?NTllTjRjNVl3V0pDdkhsSUo4dldCVHNNT2ZCSndXME1sMEVpWmRreUVRL1Zz?=
 =?utf-8?B?Y2RRTk9DTHpNV1dNc2ozc0xyandTSCs1Vkw0WDB1TUE1VjdoaG9vQ21YMWxp?=
 =?utf-8?B?WWd0RU5jLytiRkdqU3ZKV0JSYUhMeDBpakZWbytGT1hoTXEzMnkwMUxLLzZx?=
 =?utf-8?B?K3ZGZWdtOW83NUNFaytiVUd5b3ZxUWxES0txeVJ1MmNabk5GYWdsTnRHM2tq?=
 =?utf-8?B?WEUvVlJvaGVZYlJ5MG0zTWlpY3IrSEl4d2hTVHBrR1pTc0t4d0JmalBqbHpC?=
 =?utf-8?B?YWtFUW1YdXlyVGpnWGZ2MVpVMU9ialJNa3d6MUtVWHordVRiYmZ6ZnRrcm1a?=
 =?utf-8?B?S2FSd2JMZHB2bGZvcW5Ydy9CaDBHVkZ2USsxMXl6cS9vWElTc3FmSVc3cGZJ?=
 =?utf-8?B?R2hnbzBjTlhoRnJRT3libXNFeGpQbVMxYzRZaHJOeHpiclVjU2tGSDVHVjJo?=
 =?utf-8?B?U3cxM3JQbC8rRnlTMEF5eDR6WTF2UE9NTEQrYmtYeVdhMFJCZkgzSzFxL0tj?=
 =?utf-8?B?UHJ6Vm1DS2FKdmlVcytkVUtaYjk5ZWlWKzdBQ25rcWxSNEhQU1VQSWY0RkdW?=
 =?utf-8?B?UkhLTWpHTldmOEd0aUhpU1ZRN3BoQ1N6NWtYSjdTKzk2RTZ2TWszcXliYXMw?=
 =?utf-8?B?YUl2bHVVMUVtLzN0c2hvTHFybHVwQTFDZzMyTXo5OVFBZ1VGQzBveWhVUmtW?=
 =?utf-8?B?MDQwUm00RmdRcXFFc01yRi9OdVFnOE90UHU3UERFU3hWeTBJRE8wWE1OWENH?=
 =?utf-8?B?M25QS21YNjhQd2FSV1BtaWwvYkRsd2JqUlYrSDdKaEJUOEFLZ3BMNkJPUllW?=
 =?utf-8?B?OWRGZVVmUXJ2WUw3dzNZZWJCd2Y0K0k5QkJoWU43NjB4NmJWaG5ZREZSOVpR?=
 =?utf-8?B?eWhRenQyMm4xUFNGM0RWVloyUmJvc1V5L2tYWUY5clppMUJBNlVTMmYyb2U0?=
 =?utf-8?B?K3FYdFJkSSt5Vlk1M3dwWDBQNjBhalN3bHV6LzBCalpDcDZJRXdkNVZ6QW1r?=
 =?utf-8?B?RnN5ZERKeWFMMHNoSWdkZ3RrTHcyalo0TWhOV3BsblFab1RSS1pNL1NURWZj?=
 =?utf-8?B?YXRmUFlMc1o0ZFBRYjdIM0ZGaUdmUk9Cd3dFbVk2M3ZKL3hyS0h2VS9Rd05D?=
 =?utf-8?B?dHV1TnNnb0hjOXAyWmtCTmUvSUEvTCtFZUpTNHhMOHNyY2F1K1Ryby82YzFI?=
 =?utf-8?B?Q3VxeUR3YlBkTXcyamJuK0lNUDVja09vcWwydWR4cXVSLytvOVRwbkRGVjhG?=
 =?utf-8?B?M3lPZndVeklFTWNmdGF6Uy9kM1gyN2w4V292NVg1UUVja3YxSHhqcXBVUmhU?=
 =?utf-8?B?emNvbFFEY0J3UWV3RlF6MWN3UkZ5R1FSTW9GOTE0bjMvNVI0eGFxaFQwQnoy?=
 =?utf-8?B?ZkF1WVloOTdZcDdKY2hHeU1hbDZKSTJyeDRkVU9wM3FVNWNvOUIvc1JhL2I2?=
 =?utf-8?B?K1NWWFlxbFcrYzFtN1F6UGFJRm9Gdmphd3pnZ0kxZDEvTHE1MjgrcE8zZm1O?=
 =?utf-8?B?NnhORGs5NFlndjBlaGxJRkNMMGc1RkFJRVZhNG41aXRyVFF6ZTZ3MjJOVnFm?=
 =?utf-8?B?aHR6NnE4aVlsbEFhQnNsMVdHOFJNQ1hxT0hwNlpUdEQ0QTRFNzlmd25kWGFO?=
 =?utf-8?B?elQwRXNuUDh3TGg2d1hhNnBQVDZXTitTYU5LdWJueGM0Y2NrL3duWXFOTnVR?=
 =?utf-8?B?T2ExR1RYQ09XNlFGSEgwd3NEVzZpalY4Uk5jWkVQcHNNU0xDdnlEMlVYbHp4?=
 =?utf-8?B?Z29OTnp3TUhLSnB5U1FNaXpBcWo1aTY3L1BiSElySWxlTlVBTzFWSFN3V1pn?=
 =?utf-8?B?aTEyZkZiQW1obWRMb2psNDFsRGxhcGE0YktUY1RzTlBXTDdRdEdUMGFHQ0U2?=
 =?utf-8?B?TGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: p+RfSFj0uIrRszGrBGf6mrvw40Bq8iYz80XvjR8OB3kpdeMaP+czru++lD3IEfEnXPQd8qIdqFKuEVk6kVk0lAo3fqlBp07/EP+g3dkReJCfoqGFGwFaraQ4bQ7aJrMEWnvwhfNPEA8M/xYutth0f59MKmN9tx2MwJHcnsWdM66odGNkSGBJ2H6eedxHjvgJTgEYVVBGZSFKuK3TVa2welwBHyDG+3Wl7GgUsg33bY0LovVOL+DfhYMZ47xkNWbxy/FgVf8/emwh+hk5IaVvyR0kJI3P4C/TJlLfhvaKmvbrA5HJK71CdVSUeLSDN2czblE1RlzQgNAgS9jbZI4HW0YPvpAp8zJcOjZSV6w9g8sjQj6iA1kHOdPhX1Ft/wBTecXvMNNhbmbxy3L0cl/8ClNI804wOB7igA4RdsSwVrwTFvV6ePdggDqdD+6PV1tdxWNOJyZBt+oJlBg1mA0dsuZwQreBjP2s7Mm6wDC+4y9VCZnXGdtE8oQVIzMtXOolkqpkWSceSA9uBJ7YzEeCNmF4BYNRFASrVBZ7MeJlhciJdIpjAwMqohHdjjxINjB4fvN1OuBfaa2fiQ1HpafB5TZsAYXWAxSXt1cijnkkFnoJkv6r676xvqKdYMK2zKBjENDpwbKwLwhqd1dNichuyrJfmHDoyUvqOvJPMnhjuWMmJfqIXjQ70Kihi4InLs9xMN6TxeMxdFttgZxnE9SK8rTWqqQ2jALuhO6RqRKD8gCE4mNjM9+j/f/jOVvkUCOB9Ua9YHlt6ro1KoWQ9wGKbHWDu4Ky0WfBdS2upO2B+uE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 604decd2-2fb3-4088-213a-08db7e3f1b8d
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2023 16:36:11.5648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9EpNiFoeLMBJP0Z5lKIXLhc61fQCejPxzY9+RFbPJ/BDJpbHY5UOG2+0sjEYBKviglQcGtNg6E7faXx9dd3/fQ/0/T7lkCJo7T2/E8P3l5g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5575
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-06_11,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307060149
X-Proofpoint-GUID: vcHLoqyUYQ05NkG0jrFnRSz17G1h0Thm
X-Proofpoint-ORIG-GUID: vcHLoqyUYQ05NkG0jrFnRSz17G1h0Thm
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 6/30/23 10:53 AM, Maurizio Lombardi wrote:
> This attribute has never been used, remove it.
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>

Reviewed-by: Mike Christie <michael.christie@oracle.com>

