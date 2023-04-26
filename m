Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBEF3C7618E
	for <target-devel@archiver.kernel.org>; Wed, 26 Apr 2023 15:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240440AbjDZPj3 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 26 Apr 2023 11:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbjDZPj2 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 26 Apr 2023 11:39:28 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9275635B7
        for <target-devel@vger.kernel.org>; Wed, 26 Apr 2023 08:39:27 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33QEi2YC027861;
        Wed, 26 Apr 2023 15:39:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=EfH/Er/0k3M+HNODgC0w/sVB1JCUt8o0JjkVv3S870A=;
 b=LOdWbUSaBTwc+a5Iy+DszNqE9sTNeMgNmrkjDbkjpqtaBKSkGRUfg9XFyNgXN9nU6CUH
 OyUDklqSat31mECDXCe8TVHgr7nz3PpqXK/Chg/pVwRlQSIsCxT7NFY4DZAif9U3U73k
 VaeZxqJtQpov1l9hSN3bh1/5Cxixv6X2/YydntwQS5QMVjF5pwNpfEOWPXjVo9V3en6q
 ljqM6s1m9W+Vu82BhkRijDYpGE/0V7rvMAuIcrVCKHgfUzDn382XieLInrNbKmhWXMkj
 Jvh3dC+J+FAULI5nh5kbMQQ1NAMKRV5c+Sd977na3XuDQcBhMRq0BEQ4Xg2IRJHJJUl/ Xw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q47md1vvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Apr 2023 15:39:25 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33QF9CPq013302;
        Wed, 26 Apr 2023 15:39:24 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2047.outbound.protection.outlook.com [104.47.56.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3q4617v6he-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Apr 2023 15:39:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m1SRHyL3JkSNO2K9YGwK6rPo0msS+SoCqoWtG+iA5gVffEh5299BMSVo9cCfR4AIh/V9YwDXs8MmZs9Db3j/DyVV06S/tOpbh5x/2MXFYqVK1nwN/2pVq66LZ6AK1YH2hIRTQmJu3CYf4VstBH6feTcCJVPmWtCwSIlTtWUf4KC5cByGjjNX6CItyl95wY/dNsaq0Qnc4bKAVKlza0e3UoHEJCIiM/vVp4uWWoDcHVL86CHrVl22ZPfZARCvbOROKbhITaRgYmjSAiA/pbJTRpr/6Wh/obv6xUnGjQ2xDB3wgdSMRhSulVr12e/y79ht60BkbPpfOjE5bI7FhrSm7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EfH/Er/0k3M+HNODgC0w/sVB1JCUt8o0JjkVv3S870A=;
 b=AQQicHgJX27qfi26VuzsrbvsXlP15LxQQF08UAJu4/xW7AKRy7zb24lU2EV9SdUxtYiKAyNACwdRL4KpSCKdnczrDWyIvaTIcsnpUcVe3SI2wp45G09rFOr6Hv+ttJDGEiNzM3AGPX8cySG+XThK8HVsbUDmXp5CkVtTmhRq8vt93bLf3ZfBN62dr5/pkDjpp6csQcxsK5uPY5xGZD/tm2vg69+p3z2Vf6BZIndjqexG1rcSjcfmY8f7Y3h6suufphO4I5b8b5NQUhLRN1ed+OhglmsO/6dVkzgDFYXPTMYEhQS6RoGY3re29fBeJ+0m6vf0Q/ZWgNSDLrU7roMSog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EfH/Er/0k3M+HNODgC0w/sVB1JCUt8o0JjkVv3S870A=;
 b=Q3Ogc9W2r6CJRplj55A4/1ec6meh32qHe43aipisDHiCNsX0sHy6a6ESHweW8A2xDGHvM1NnuivAv+U+ha74Qq+q2TVe0BdQD+c7dsIUq0nFkKWNQFQngyHS+F2CRBdPWfX31pzfMorwRU+2fDrp4xRdPc+760fYSge4RflqYvI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH7PR10MB6555.namprd10.prod.outlook.com (2603:10b6:510:206::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Wed, 26 Apr
 2023 15:39:22 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::264c:5118:2153:91ef]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::264c:5118:2153:91ef%12]) with mapi id 15.20.6340.020; Wed, 26 Apr
 2023 15:39:22 +0000
Message-ID: <4bd86bf3-95e5-daa3-46d2-4e46fb306934@oracle.com>
Date:   Wed, 26 Apr 2023 10:39:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH V2 1/3] target: iscsi: fix hang in the iSCSI login code
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org
References: <20230417171801.208122-1-mlombard@redhat.com>
 <20230417171801.208122-2-mlombard@redhat.com>
 <6ecde91d-aa5c-0123-ba2e-dde093dd056c@oracle.com>
In-Reply-To: <6ecde91d-aa5c-0123-ba2e-dde093dd056c@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0260.namprd03.prod.outlook.com
 (2603:10b6:5:3b3::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH7PR10MB6555:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fdfe2d1-bcad-49fb-a6bb-08db466c6807
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J5uN1ElzpiTI6uzngKBavshwUeeOLORA5Q0kMDFD9MAZ6W/oq/LfO4m6005fCRn1KIjVZi7ESbr9SNIhi4vXR+3bxycMfUpI8eN71knconrwh5rYD9vCC9TU7KqRrkXMWuoaawJBkbl32lO7FPn8N8IL7yjMXzy5Nwyom8Nose0ryJ6aWbuptvJ9l0RShIwdU803UncHzxpJ57iKHJv/vBnTBRGi1Nk2hKkCNuBrKYEXcR9tBTQkOLWEos+WSlX1i4I+qHmTlWaTvJ+RlnHNYTi22QBA8JtXQni0zUJUzArBQC83zVfEu/X+xWPM/GOHOOxAqbMvMbthXAZsQeOWVrMbiuO9Kh9TnEJrePHZM39aa9C7wMCC14+tgxqooMYW/wHA7OLVOhyjh/aiJCYLxDFYiQ9X2/B2zffsqwdhGIXPHZ8HUyPt0tDUnvjerlmIjxnz/q/m7n9r1skBs+T0vciGde32/biOKpFdGLmQIKnsia4BsRRyH1DrblfD5x306OSWRgSf2B3LxoxZVKP211S8RVhoRJT1Px94srxqcBsV+ouXEwzkS4NJMbEVamWFrF9a50jl02d0Zx9VebJ69IQqCBryKXUsDzEV29Kl0vImxb2mu/A+gnHIvJPByNQQ8GFqoBSK0xd97FPUYt4msQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(366004)(376002)(136003)(451199021)(186003)(38100700002)(2906002)(2616005)(6512007)(53546011)(26005)(6506007)(6486002)(83380400001)(86362001)(36756003)(5660300002)(31696002)(41300700001)(66946007)(478600001)(66556008)(8936002)(66476007)(8676002)(316002)(4326008)(31686004)(6636002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aTNFcWZ6cW5FQmY1WjNRRTdyc2F4RGZJMzJGRmxDTHNpL3RoTmcvUk1hL3Q0?=
 =?utf-8?B?VlVDYWwvY1phRUwzeWhjUDBqMHJlK09vWWg5NFdTYllkK3dKVFRkSGsrRFJ0?=
 =?utf-8?B?Yjh6MTFTaTkwVnNWQ0xqb09YVzhtWmxtSFB4b0R6czlsK0NFdlRHczFjK3RO?=
 =?utf-8?B?SHY1cEVEMHpkdGNlMi9qR3JyMXlzUjlJRlI3Y1dITmpHdTVDRU9nSmlTb1Ey?=
 =?utf-8?B?ekJRQjdFdTZzYUNma1I5d3o5YkNrK09ES1Q4YVBvRnloaTlCTHE2WFRqVFZy?=
 =?utf-8?B?NUlZdEJranQ4MFhZRWRiQXgrYkJHWmthb0t5OERmOTdOeGJxejU3K3YraXJF?=
 =?utf-8?B?TkJwakxHNDBiZ3ljKytGUEFjRDdmeW5KV1ZkSFg4SGp5OHFiOUNnN2RFejBS?=
 =?utf-8?B?S0ZBRWlqRE9OR01tTkdxa3lPZHNYbVJVL1FpcWQyWmEwUFBzMzRQWUV6YmNr?=
 =?utf-8?B?Y09jbFM3aVhQOHMxMDN4MVI1ZEFNb2dYbFpRVlhBWFQzbW1WeSt6QS9CcEpo?=
 =?utf-8?B?ako2QUVreVdLS3hmSk5QekdVb0xrSmd1b0JFNVZjcDF3b1BXTjUzS2hIWVFp?=
 =?utf-8?B?TzkrV1UyNEV6Rm9laWllSkdweHE5MEREVjNpTmU2WVBRQVdVc2cwSkpxK2px?=
 =?utf-8?B?YXNSMnFzL2hOY3JuWjBjcVcyRDBaT0Y1MWFHdDd2a3l4aWttaERwczVVR3Bu?=
 =?utf-8?B?c00vU3JmdE9wSDRhOWxxY3pObTNkMkJ6RXcxOUdQRFFOYmNURHB2SzhiMDdF?=
 =?utf-8?B?dWVNajdtbGpvSnFpK3ZHVDNGWEwvVTNLUHRncUx1R2FBL3NBYUhad0s1NUo1?=
 =?utf-8?B?ZWZvOWdXWVBxeCtLNmtBRFpPUUx4b1dqOVI2RVp4Mkl1WVhmeDBsczN6cExx?=
 =?utf-8?B?c3Zadi9Ta2c3Q254OTNzWXNRYlhGQzVFL1FCaWh5OTVRRDBwL2RxdmF3VmhT?=
 =?utf-8?B?eWQ1SkhCWXhOQlMwMjdxOUl3SldTYjRLei9EVXkwUDRxdU9VY2UyU1dLQUlZ?=
 =?utf-8?B?Skh6QTF0T3dETSt1WHhhM25obm1pWUFZb1pnVkQ3WjJzSHpzZ3pMcVkrUXA2?=
 =?utf-8?B?ZUNUQzRXR2o0Z1ZxWlg2Sk9VSFVaTW4wcjhTTFNzMWIvTGRWeUlmT0N3RzJ1?=
 =?utf-8?B?YkQ1NWNUTWZPTzZtMDQzcFp6UEZkYkFjeGY2YVVSZXhCcFJvOExjbHZka1VF?=
 =?utf-8?B?OWNGd2hRQTAydjRlWVM2bFRxeitzdVU0aG9lM2NycEs1QXM5WE5KWjFZZkZz?=
 =?utf-8?B?SGVHcUpZY1F6S0pBcUZxanZ4L00rZUxVR3dWR0pSMkVYcUJsdXNuRVgwSjJm?=
 =?utf-8?B?emt3eTE3SXBySXFXSDNYbmFpczdrVTRraXEwNVhsaU1VRFdYREJaZ0VwTmhE?=
 =?utf-8?B?YitoWWgyak5yOEljZVVwMjFCU1F0K2QzUmZlVTBzUFlDNEZmZkhGK2VYYmZE?=
 =?utf-8?B?ZlZldWF6a0RQcmJtd3NWc3JVUVRabG90ckltTkZ5TkV3TUNpNG55M1c3elBk?=
 =?utf-8?B?ampVbW9QVC9INVVWRFdaK2lYRzJtam8xaXNRTStVdjNabTRqUm4xTkxOZGNQ?=
 =?utf-8?B?V0lNSkdlTXcrd3NqRDRhVkx3VXpyTThpSFV0RFNwK2t0di8xWEs4S2RLeUhn?=
 =?utf-8?B?VlhJeFVDMWlpaFhFQ1lqZ3dDWjhrNDd3ZGVZSmtjc0l6dnBFbi84MUhVem1E?=
 =?utf-8?B?TGcwTndCWTk0ZmM1aVdEMERtWSsvc25JenNGYU1jeStZN05CT1pueWdHTVRs?=
 =?utf-8?B?WkxybGpjMVkwanJWeDl5Slh0eHcxMlhDb25Ma0hrRVZSQUJXa1IyTXc4bU5v?=
 =?utf-8?B?SFhkcWxaN1dBY2EvQzRTSjU2ckJMdW9sSmpjTEd5Q0FkRkd5SHVZNFBMNGpN?=
 =?utf-8?B?bmhZRTVheGZ6azRGK0txRlQ4dkpRTCtyTDFZalB2M2txMTN2Y1BuTUM3UUlt?=
 =?utf-8?B?UDJFY3hxU0FJeUU0SjBrMFJ3VUpXV25udEJCc0NCdytWVXI4QVpGUmVxL01K?=
 =?utf-8?B?cmd5cGF3alVadXBZazQvYzhRUHlUN052K0tSeU9zOW5kQ2ZOUmYrVkFSajBW?=
 =?utf-8?B?ckpnQXJpT09jckVMLzREL2tQQ1Z3RnZoU3I2OWhWT1ZVOWlmVTU1cm9DbHZP?=
 =?utf-8?B?SnR6M29VUVVEL2NXLzc0M045WStoa2o0alpET0tRL3JGRmE0R1EvcVZ2SG8y?=
 =?utf-8?B?alE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: xovfzHi3zp2vgdczoggT5Q6a7I3PN2SEuIRtTWAE0zTveQq4Yq4sl8QOGgT3SOqZFN/r68zoyRYstKhP8vEW554pPWISBZDK2+y4vbNJ+QMsAaW+PAk6hsXIj7OklviOeUp7dpt06fwhFRok5zqPf+sOdBmSznbt/Nry9vKgpQ1irTI8nvrvMDxbDMvABW6EQmmbUpiqH9cRDYUiFHidBIXzqfi14ORdEhTFYQT1nCj+AuWven6hG0c6vOBERe2ltcczkiMo4qCUD8v8IjMVPSpUzF+6RHjbwzm+AWzI1KWB5sKtL0zkGgJ6vmJRVrDAfK/pvbYXyW2DzBZSgiylReG10mD08pxggTXfRcCwOZPSbcr3Sz3LK//wofZsTEaFXn/4QgbOZJi2s55ShTnb0VJ1MECO663NI4fUWlOefsWjSxifj6mR4accsYaHmo0wbKbVa32Soqu368Vfn9GNSKvxTmyU9EW9Kv027ltakmIVAOT1j9iXtIFfyy8j4pNgZ8E/IEflCLZGRtNKRZ26ubr2yyUS2AGEwmE1Zt00AEcj/4itLQI1X3SidOFwBPEEvHnInko2lb5WX/xJQUCyEMjAOdETZfhvRZ9t4EszRFQ2aMClPvLDEmPFSeU1925HBzBPNLjKEWfAgteCpmeFV+ZMhwlM/MNmHyaqjbV/g6MiN+ZswaKG15qXPOxP7gQ8idzMQ/JD3Ti5QLjq53wGCnD6vUdwxbx9UmdPtgh2Zwkd1a5KrUke7fjpqpoaFOlwlYxTbLukW2B5FY4g4wT1AFe+sjwDiKptg4L+DDjRfgE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fdfe2d1-bcad-49fb-a6bb-08db466c6807
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 15:39:22.0029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BKqdCnFdj9RXkVpyZVn5TjcB1phROpPikanudn8jv2tLpVPxVS14psaycYhiPpRD/RYPp7MFpibY6Cbk5Vm5EKgucR0EEZwYzZ72jOU75JA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6555
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_07,2023-04-26_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304260139
X-Proofpoint-GUID: Wa4L21kSIoWDFFUyD8llL1N8xv2fddaS
X-Proofpoint-ORIG-GUID: Wa4L21kSIoWDFFUyD8llL1N8xv2fddaS
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 4/26/23 10:35 AM, Mike Christie wrote:
> On 4/17/23 12:17 PM, Maurizio Lombardi wrote:
>>  static void iscsi_target_do_login_rx(struct work_struct *work)
>>  {
>>  	struct iscsit_conn *conn = container_of(work,
>> @@ -562,12 +543,15 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
>>  	struct iscsi_np *np = login->np;
>>  	struct iscsi_portal_group *tpg = conn->tpg;
>>  	struct iscsi_tpg_np *tpg_np = conn->tpg_np;
>> -	struct conn_timeout timeout;
>>  	int rc, zero_tsih = login->zero_tsih;
>>  	bool state;
>>  
>>  	pr_debug("entering iscsi_target_do_login_rx, conn: %p, %s:%d\n",
>>  			conn, current->comm, current->pid);
>> +
>> +	spin_lock(&conn->login_worker_lock);
>> +	set_bit(LOGIN_FLAGS_WORKER_RUNNING, &conn->login_flags);
>> +	spin_unlock(&conn->login_worker_lock);
> 
> 
> I think the locking bh use is reversed.

Ignore the locking comment like here and below. I see there are 2 locks.


>> +
>> +		if (iscsi_target_sk_check_and_clear(conn, LOGIN_FLAGS_INITIAL_PDU))
>> +			ret = -1;
>> +		else if (!test_bit(LOGIN_FLAGS_WORKER_RUNNING, &conn->login_flags)) {
>> +			if (iscsit_set_login_timer_kworker(conn, NULL) < 0) {
> 
> I think this will deadlock because iscsit_set_login_timer_kworker tries to take the
> login_worker_lock we took above.

