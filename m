Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F2AC433EF
	for <target-devel@archiver.kernel.org>; Wed, 13 Oct 2021 20:21:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACE8C6101D
	for <target-devel@archiver.kernel.org>; Wed, 13 Oct 2021 20:21:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhJMUXp (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 13 Oct 2021 16:23:45 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:6040 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229629AbhJMUXp (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 13 Oct 2021 16:23:45 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19DJnjSw023793;
        Wed, 13 Oct 2021 20:21:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ZMpkytAly1RHvhMob5/4gwC4bIJY5Bod4hsR4muLtTE=;
 b=JgLNRgKydZu15mO2OdXezfOq4AJB6G/eimNfOP4ibRHBr80eW5Du5HV9KZYnl6pbybH/
 hW/p1Dwipz+bgwClibgY3DrSN89DBJqxEyfVUQ/Az0jALZ1l8yVKLYJy9/pey2ZBuvDt
 sCYrWEoC9aTb2vwH/IBcOJTCEj51G7lgl5F+x3sS0pgn2w891fmX+qGCCUREl0IPkOB6
 r+ECtGPbRHatqahJ8Yv0KNYF7x0wwXtiyL+pVRs0236yhOHP3MIjWD7ctqqU4t8jf65k
 Bfq2alKVnEVKdvoGKbaOyDAg/OLf5LBIX6nsDnwWnK8dTuExIioFTouea7ywCMga2YbQ YQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bnkbmy27k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 20:21:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19DKEmc4041555;
        Wed, 13 Oct 2021 20:21:23 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by aserp3020.oracle.com with ESMTP id 3bmae1evmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 20:21:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VYeTGk1g2VZcsJW4epj9n5CxdGKZSLE4EXBtVc0Rlp+AeXNk0UbE77v3ux3p1FM+D9s7wJUmBsphGumo/YbONpuRv25pZo8iu6T7dqWeszpa95KUoYS+5ZvFcH2Zgw+2ewPdLSbDzUj/g9RMgifzYPvWaW3IEIaQRnqTvEQCbl9TuJGB66QvAFv29Hox4sHljE8wzgfS3qr0AcT9v245o7icM0/TQn7LlO4/kbU+48QusrQxNd5qPZhyZ+Vz0MXL4hKKarWXSahbokAat70LSboiubUEJnU3oQtCoN3H2Jv77TaILnpQxv/eCpWqEwc10kgfoKZIFXtJrT0kZqZ1Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZMpkytAly1RHvhMob5/4gwC4bIJY5Bod4hsR4muLtTE=;
 b=UAPwmmfoLdmZC5oiseaCdUYo4pe98ZYZgcUYMG/WmHCyE5tS1ipBHye1NrmBVXP1rOhhdDVg64fZG3REsBjqxtByiQQSh5vITiNHsfAT054c2JLPficv/fYablb17qzfWtqXP5eXdQ+S4JX207aXtCkgiuuUVbDBFBt10f3yivTwfLHpy6P7ZTcGTC8NbyqHkbMbRt7mBMbSImmm2SmK/29ObXF16GdXXxFFAfk0dB8ycR4VD5fhZg9UrSWb2zeJQRJpKS2lry2Z6xJqrIQssxkt7Qg/j73Ga6tdJUjfGE9xWFKIpDgxzH3vkwicih9LrgGCiTT/12Y+zhs8eZrWbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZMpkytAly1RHvhMob5/4gwC4bIJY5Bod4hsR4muLtTE=;
 b=sM7Wj94hPIB7MCN/NDXoRiNZJ/QcqhvhpCErhROLZtqZxtuN3/eMa4HdiPCdu5siAhGnxZnnJngQTKDAO905wiu4DlTsjOL3rPZSBLF8RMfrdapTM3XEHGRP1/FZkcnK3X40YWaibHiKsxlL5f802FNk964lJ6eW0goSgH3TvSM=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3066.namprd10.prod.outlook.com (2603:10b6:5:68::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.25; Wed, 13 Oct 2021 20:21:20 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4587.030; Wed, 13 Oct 2021
 20:21:20 +0000
Message-ID: <e76e1a95-dc88-ac9a-62b0-89533182aafd@oracle.com>
Date:   Wed, 13 Oct 2021 15:21:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: iSCSI Abort Task and WRITE PENDING
Content-Language: en-US
To:     Konstantin Shelekhin <k.shelekhin@yadro.com>
Cc:     target-devel@vger.kernel.org, linux@yadro.com,
        Maurizio Lombardi <mlombard@redhat.com>
References: <YWbdbh1w1Eiw82Zr@yadro.com>
 <17647b68-f039-3fc3-808e-0feb652ddf8c@oracle.com>
 <YWcggfDyrHU1VhKN@yadro.com>
 <2e83aa6a-2746-8914-f295-30eea8954814@oracle.com>
 <6059cfab-5cbb-984b-7efc-eb193bddea7a@oracle.com>
 <YWcsWKIn5RyN+UbD@yadro.com> <YWcs/8CQYn7C7G9T@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <YWcs/8CQYn7C7G9T@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR07CA0084.namprd07.prod.outlook.com
 (2603:10b6:4:ad::49) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DM5PR07CA0084.namprd07.prod.outlook.com (2603:10b6:4:ad::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Wed, 13 Oct 2021 20:21:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f889b54e-93e2-4469-a933-08d98e8704ec
X-MS-TrafficTypeDiagnostic: DM6PR10MB3066:
X-Microsoft-Antispam-PRVS: <DM6PR10MB30669522F0A195062E450461F1B79@DM6PR10MB3066.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:83;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9lgc6VqClbHoZ0s68viiHLE8z+03uzZ/g3MDmhlaNdHwCZyxQlbp18SSZneR45lQAOfI0u7l+8lDMPsJznm0+4q/2L+ajL7gSTkfU2QY6aqitBXjSXNiPHJtqZmI8cjB7EIZhnk8nM/5lnihq6gloqaQ+hjZ+yyagxLmeQ18cYYwhpTxtHAOWzxR4lyfArN198CQl3VYh+uJRYX4djZyHFR8IOpyZaWvf0mfl2L6XzPkUNhfzm2MlMLKFPvj5jCHP3bgbTXzjgAtOL2Wg92WXmMMBZ3jttWMVaGvm11FQo96U9OvHU9FDrDmHocQUAoWfTuGrtHsE2LzC/4iQgBUhDMljAqBt7LGiLRgClAeKY+j+R2EjTaa6b0AXSbhaDmpw1H3Y7OtAeAS8oX4jojkEZcN+PD25LdE9TXqMNbjgW+nXwXpmjQyC6NVbqaaxP7W4/E85OJSkQOxKLdC7Ntn1xiLtodYxSJj4xMJwd9ooVUNLBpG3tBVXwiU8itdQ3CGqBkgBQiXHZNKS59M2YkzPwwBLNTcMJeFup+P9qW9gpiOF0Egdwx7WPotiYmyZGTpLCNuwvO8uj+MSvM7zMZva8LE78f4Z+3pL5npOrxEmm/mcd6OmMcbbxrCfDXWRVi1pdIXEDu5p/mKwWh+r/IGkbt6ltHiUjtADlR479Nih9qEzIqNx5L0aflljZexeETJlorywkUaPCIR9sNg2yWOsPhHzLI5Qi9nv9HZuhPbG8fsWRXkJ7KXoLseEWKphGhpFy/JNi3LTnGtimFOrbySAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(31696002)(36756003)(5660300002)(26005)(4326008)(86362001)(6486002)(2906002)(53546011)(186003)(16576012)(8676002)(956004)(38100700002)(31686004)(30864003)(6706004)(66476007)(2616005)(66556008)(508600001)(8936002)(83380400001)(66946007)(6916009)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WXRndGxKVW5QTlJ6VG9SYVB5NEg3eEU4RnRtRllUYk52Uk9GdXJYcHMwSzFs?=
 =?utf-8?B?TG5UakZVdVYzLzhiQ25yeDBHWC9zNTdxaHRKeEVwQU9YTFIrMC9oa0dCVmFT?=
 =?utf-8?B?WUQvUlV0MjJFKy9vVkJ6T0k1amd6MnNCTVRsbzI1eTdPMlR1K0d2U21zQ1Za?=
 =?utf-8?B?Wm1QamxXaGZuYlR5N2JZR1pHZGlvZTVJWDRpL0NzVkN3d2RjQWNZNEc0QW1x?=
 =?utf-8?B?Y3BFSzB1K0RnK09lNkt2NkU4Sm0yZGduQnk1MCs3SzROMlFsUXRXc3p3VTNN?=
 =?utf-8?B?VkZyeWMxODhMV1lwL2pUcjh1blNrbU1xek5uZ05WczN4SytKZytGYVFubHBO?=
 =?utf-8?B?U1Z5L1QvVlRkWW9tVmtwNjYxbTVya0xIQjFFTTVhUUZUeDR4VE9IUVRXR3BD?=
 =?utf-8?B?eDhLa1lEbG1uY1g1ZWRHUUFCUUkzQzVHbEk2RnE2RHJ4di9rS1RBV2YyaHFO?=
 =?utf-8?B?T3ZqdnFzMDBTUFdubkFsaW5RYmRlaThKZmM0cnZLMllsVmJSRytHWWVCNDJw?=
 =?utf-8?B?ampxMGRqb3d6U0ltT1JqT2E1eUpjSTd5Vk9aY0tSTEluckVXY2RydWFMVFh0?=
 =?utf-8?B?bTFyRWlEZTJ3ODljTE5iS2QxMTlxbHhZQ0J5c3J1R3ZKeTBrSnd4OWVCVFlB?=
 =?utf-8?B?WGFXTlZ3ei9LRHRkSTZhUWtiaWRZNllDK1JsZ1pvaWd0emlLT3QxYnBld1J4?=
 =?utf-8?B?b2JGRVF2OEtKN3BEUm1MOG4vekJ4NlNZN1pjV3RaZGlNMmFaaStmR2FxdHkv?=
 =?utf-8?B?a3RacUpwVWd4aXNFRkJ3VDZpbjZpUHFVcEo1Zm5VR1FrS2J3eGdDL09mMlBa?=
 =?utf-8?B?QklPd1NxVjg3cDhPK3dEZUk1eUQ2TXVnQ1Z3b0IvMVZJVUlVOVZrODJoSnpi?=
 =?utf-8?B?ZkxYWURjZHpKdnpDN0ltdGV0alVzc3pnN2V6OFNzOXVqczBUYjJyejZhK3d1?=
 =?utf-8?B?YS9WT1VwanA0WTJwVEtoWmtmUUlHQ1YvaVBsRkdKMElkdU5FVVMrRURSbDFx?=
 =?utf-8?B?Ym5GUHJCa1laY2VEUGxscktUcDBma3MrYUNhR2JvdWxuZGdOT1ZwQ1BmcnpJ?=
 =?utf-8?B?QSs0WkZWd1BGMGpHSERQV3FWSkhCRW40TEdLaVNNaEdKRUxvc2Z5TWRSajVs?=
 =?utf-8?B?MkRadG5MM0RVMS9IL0lZZlQ2RENwclVCamNJMkNrcEo0YTJlbGlwUDJuM29T?=
 =?utf-8?B?UzZ4bm80eVhoMGVVNVRwcGprM2VORlBCZGRaUE9aaXBjYU55K0pxeUZLRG90?=
 =?utf-8?B?Q3kzR3RKODdFRXVYNXpwaXdaU2Z3RXplRWlQdjUzaVdqZENhRFRGdGt0T0M0?=
 =?utf-8?B?cWZBSTVMUStXcUw0U3dBaFFLM2JBUmtHQkVPdWljNmg2Z0NzU1F5c1VDN0c3?=
 =?utf-8?B?cEozV3lLaExkakRIOU5SUHBGaStsOFlRb1lWSkkzVFdYQmIxZWI1bUp2a1M2?=
 =?utf-8?B?Y3NwZXRBM3lkRlRXU0dlbmFTeHpwS0pqTWZxbWlpcGF2d25GZjNvcXJacEwy?=
 =?utf-8?B?OExteEd3aVd6bTFsQmZpa2I2a0Q5NUFKT1NFR3pMS3VhSmxZVnlGVE9WUjR1?=
 =?utf-8?B?ZTF3VDZLcHZUajRDMGtCUTZNbnNLNGFXRnhOc1RCK3BYRmpkdjJRL0RwbFpm?=
 =?utf-8?B?QndJVDJTRDhwK2RWZFMyaitnMGkzYlk5bVV0ZkczWHc3c25FMklOTkdNSHpz?=
 =?utf-8?B?bDAyYUI2TGIwN1lXc3dzVUNlVVNUZWxrRjhMbXRiUjVuRjJMRDhXeEI4SkJY?=
 =?utf-8?Q?fv9jGv9T0uqKU9ZeG1sBBtALbsHMIFgh2p2gTkb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f889b54e-93e2-4469-a933-08d98e8704ec
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 20:21:20.6192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gREbgfIJ0SMc5NbyKeZNTlTUUk+hrpk1mrWdIzyymE1aG1zKbo7AS3/JzW//Vx/Ij3Y82f4cO2QMCiFWSqDMvO+Cv6CNb9UFVdqb0F0t4Uk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3066
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10136 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110130121
X-Proofpoint-ORIG-GUID: AKh8-GghbTvqvUh14ialEPVu5KO8HmMt
X-Proofpoint-GUID: AKh8-GghbTvqvUh14ialEPVu5KO8HmMt
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 10/13/21 2:01 PM, Konstantin Shelekhin wrote:
> On Wed, Oct 13, 2021 at 09:58:32PM +0300, Konstantin Shelekhin wrote:
>> On Wed, Oct 13, 2021 at 01:30:32PM -0500, Mike Christie wrote:
>>> On 10/13/21 1:24 PM, Mike Christie wrote:
>>>> On 10/13/21 1:08 PM, Konstantin Shelekhin wrote:
>>>>> On Wed, Oct 13, 2021 at 12:51:32PM -0500, Mike Christie wrote:
>>>>>> On 10/13/21 8:21 AM, Konstantin Shelekhin wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> I really need the collective wisdom.
>>>>>>>
>>>>>>> Not long ago we've uncovered the problem with iSCSI and ABORT TASK
>>>>>>> handling. Currently it's not possible to abort a WRITE_10 command in
>>>>>>> TRANSPORT_WRITE_PENDING state, because ABORT TASK  will hang itself in
>>>>>>> the process:
>>>>>>>
>>>>>>>   # dmesg | tail -2
>>>>>>>   [   83.563505] ABORT_TASK: Found referenced iSCSI task_tag: 3372979269
>>>>>>>   [   84.593545] Unable to recover from DataOut timeout while in ERL=0, closing iSCSI connection for I_T Nexus <nexus>
>>>>>>>
>>>>>>>   # ps aux | awk '$8 ~/D/'
>>>>>>>   root        32  0.0  0.0      0     0 ?        D    15:19   0:00 [kworker/0:1+events]
>>>>>>>   root      1187  0.0  0.0      0     0 ?        D    15:20   0:00 [iscsi_ttx]
>>>>>>>
>>>>>>>   # cat /proc/32/stack
>>>>>>>   [<0>] target_put_cmd_and_wait+0x68/0xa0
>>>>>>>   [<0>] core_tmr_abort_task.cold+0x16b/0x192
>>>>>>>   [<0>] target_tmr_work+0x9e/0xe0
>>>>>>>   [<0>] process_one_work+0x1d4/0x370
>>>>>>>   [<0>] worker_thread+0x48/0x3d0
>>>>>>>   [<0>] kthread+0x122/0x140
>>>>>>>   [<0>] ret_from_fork+0x22/0x30
>>>>>>>
>>>>>>>   # cat /proc/1187/stack
>>>>>>>   [<0>] __transport_wait_for_tasks+0xaf/0x100
>>>>>>>   [<0>] transport_generic_free_cmd+0xe9/0x180
>>>>>>>   [<0>] iscsit_free_cmd+0x50/0xb0
>>>>>>>   [<0>] iscsit_close_connection+0x47d/0x8c0
>>>>>>>   [<0>] iscsit_take_action_for_connection_exit+0x6f/0xf0
>>>>>>>   [<0>] iscsi_target_tx_thread+0x184/0x200
>>>>>>>   [<0>] kthread+0x122/0x140
>>>>>>>   [<0>] ret_from_fork+0x22/0x30
>>>>>>>
>>>>>>> What happens:
>>>>>>>
>>>>>>>   1. Initiator sends WRITE_10 CDB
>>>>>>>   2. Target parses the CDB and sends R2T
>>>>>>>   3. Target starts the Data-Out timer
>>>>>>>   4. Initiator sends ABORT TASK; no new data from Initiator after this
>>>>>>>   5. Target starts aborting WRITE_10, gets into core_tmr_abort_task()
>>>>>>>      and starts waiting for the request completion
>>>>>>>   6. Nothing happens
>>>>>>>   7. The Data-Out timers expires, connection teardown starts and gets
>>>>>>>      stuck waiting for ABORT TASK that waits for WRITE_10
>>>>>>>
>>>>>>> The ABORT TASK processing looks roughly like this:
>>>>>>>
>>>>>>>   iscsi_rx_opcode
>>>>>>>     iscsi_handle_task_mgt_cmd
>>>>>>>       iscsi_tmr_abort_task
>>>>>>>       transport_generic_handle_tmr
>>>>>>>         if (tmr_cmd->transport_state & CMD_T_ABORTED)
>>>>>>>           target_handle_abort
>>>>>>>         else
>>>>>>>           target_tmr_work
>>>>>>>             if (tmr_cmd->transport_state & CMD_T_ABORTED)
>>>>>>>               target_handle_abort
>>>>>>>             else
>>>>>>>               core_tmr_abort_task
>>>>>>>                 ret = __target_check_io_state
>>>>>>>                   if (write_cmd->transport_state & CMD_T_STOP)
>>>>>>>                     return -1
>>>>>>>                   write_cmd->transport_state |= CMD_T_ABORTED
>>>>>>>                   return 0
>>>>>>>                 if (!ret)
>>>>>>>                   list_move_tail(&write_cmd->state_list, &aborted)
>>>>>>>                   target_put_cmd_and_wait(&write_cmd)
>>>>>>>
>>>>>>> As I see it, the main problem is that the abort path can't initiate the
>>>>>>> command termination, it simply waits for the request to handle this on
>>>>>>> the execution path like in target_execute_cmd():
>>>>>>>
>>>>>>>   target_execute_cmd
>>>>>>>     target_cmd_interrupted
>>>>>>>       INIT_WORK(&cmd->work, target_abort_work)
>>>>>>>
>>>>>>> However, in this case the request is not going to be executed because
>>>>>>> Initiator will not send the Data-Out buffer.
>>>>>>>
>>>>>>> I have a couple of ideas on how to fix this, but they all look kinda
>>>>>>> ugly. The one that currently works around this for me:
>>>>>>>
>>>>>>>   core_tmr_abort_task():
>>>>>>>
>>>>>>>     [...]
>>>>>>>
>>>>>>>     spin_lock_irqsave(&se_cmd->t_state_lock, flags);
>>>>>>>     write_pending = se_cmd->t_state == TRANSPORT_WRITE_PENDING;
>>>>>>>     spin_unlock_irqrestore(&se_cmd->t_state_lock, flags);
>>>>>>>     
>>>>>>>     if (write_pending && se_cmd->se_tfo->abort_write_pending)
>>>>>>>             se_cmd->se_tfo->abort_write_pending(se_cmd);
>>>>>>>     
>>>>>>>     target_put_cmd_and_wait(se_cmd);
>>>>>>>
>>>>>>>     [...]
>>>>>>>
>>>>>>> The new method abort_write_pending() is defined only for iSCSI and calls
>>>>>>> target_handle_abort(). However, this opens up another can of worms
>>>>>>> because this code heavily races with R2T sending and requires a couple
>>>>>>> of checks to "work most of the time". Not ideal, by far.
>>>>>>>
>>>>>>> I can make this one better by introducing R2T list draining that ensures
>>>>>>> the proper order during cleanup, but maybe there is a much easier way
>>>>>>> that I'm not seeing here.
>>>>>>
>>>>>> Ccing Maurizio to make sure I don't add his original bug back.
>>>>>>
>>>>>> If I understand you, I think I added this bug in:
>>>>>>
>>>>>> commit f36199355c64a39fe82cfddc7623d827c7e050da
>>>>>> Author: Mike Christie <michael.christie@oracle.com>
>>>>>> Date:   Fri Nov 13 19:46:18 2020 -0600
>>>>>>
>>>>>>     scsi: target: iscsi: Fix cmd abort fabric stop race
>>>>>>
>>>>>> With that patch if the abort or a lun reset has got to lio core then we
>>>>>> are going to be stuck waiting for the data which won't come because we
>>>>>> killed the iscsi threads.
>>>>>>
>>>>>> Can go back to always having the iscsi target clean up the cmd, but if
>>>>>> LIO has started to abort the cmd we take an extra ref so we don't free
>>>>>> the cmd from under each other.
>>>>>>
>>>>>> This patch is completely untested:
>>>>>>
>>>>>>
>>>>>> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
>>>>>> index 2c54c5d8412d..d221e9be7468 100644
>>>>>> --- a/drivers/target/iscsi/iscsi_target.c
>>>>>> +++ b/drivers/target/iscsi/iscsi_target.c
>>>>>> @@ -4090,12 +4090,13 @@ static void 	(struct iscsi_conn *conn)
>>>>>>  			spin_lock_irq(&se_cmd->t_state_lock);
>>>>>>  			if (se_cmd->transport_state & CMD_T_ABORTED) {
>>>>>>  				/*
>>>>>> -				 * LIO's abort path owns the cleanup for this,
>>>>>> -				 * so put it back on the list and let
>>>>>> -				 * aborted_task handle it.
>>>>>> +				 * The LIO TMR handler owns the cmd but if
>>>>>> +				 * we were waiting for data from the initiator
>>>>>> +				 * then we need to internally cleanup to be
>>>>>> +				 * able to complete it. Get an extra ref so
>>>>>> +				 * we don't free the cmd from under LIO core.
>>>>>>  				 */
>>>>>> -				list_move_tail(&cmd->i_conn_node,
>>>>>> -					       &conn->conn_cmd_list);
>>>>>> +				target_get_sess_cmd(se_cmd, false);
>>>>>>  			} else {
>>>>>>  				se_cmd->transport_state |= CMD_T_FABRIC_STOP;
>>>>>>  			}
>>>>>
>>>>> The bug was there before. I had to backport this patch in order to
>>>>> introduce my fix. I can revert it and check what is different, but it's
>>>>> there in some form.
>>>>>
>>>>
>>>> Don't waste your time. It's because iscsit_free_cmd's call to
>>>> transport_generic_free_cmd has wait_for_tasks=true.
>>>>
>>>> We then do transport_generic_free_cmd -> target_wait_free_cmd ->
>>>> __transport_wait_for_tasks like you posted above.
>>>
>>> That's wrong, it's the transport_generic_free_cmd wait:
>>>
>>>         if (aborted) {
>>>                 pr_debug("Detected CMD_T_ABORTED for ITT: %llu\n", cmd->tag);
>>>                 wait_for_completion(&compl);
>>>                 ret = 1;
>>
>> I'm not sure I'm following you. The wait on master comes from this:
>>
>>  core_tmr_abort_task():
>>   [...]
>>   target_put_cmd_and_wait(se_cmd);
>>   [...]
>>
>> IMO it's kinda legit wait. And we can't just drop the references and
>> call it a day, because a request has to go through the
>> target_handle_abort() because it (at least) does some TAS magic. And
>> currently there is no code that calls target_handle_abort() for
>> WRITE_PENDING requests.
> 
> Ah, sorry, I should've mentioned it I guess. The
> transport_generic_free_cmd() bit is connection teardown waiting on ABORT TASK
> that waits for WRITE_10 task. That's part is completely fine IMO.
>


For lun resets, let's take the abort case.

1. core_tmr_abort_task is waiting in target_put_cmd_and_wait for the WRITE.
2. For the normal case where a cmd has been passed to LIO core then eventually
the cmd completes and we do:

target_complete_cmd -> target_complete_cmd_with_sense -> target_cmd_interrupted
-> target_handle_abort. Ignoring TAS, that function then does the last puts on the
cmd which wakes up the TMR code in #1.

For the case where we never submit the cmd to LIO core, then the puts will never
be done by that target_complete_cmd path. And, in this case where the iscsi connection
is closed we know the cmd will never be submitted to LIO core because the iscsi
threads have been killed. iscsi needs to do the last puts on the cmd so #1 wakes up
on that WRITE.

So we need a cmd bit to set to indicate iscsi has called one of the submission
/execution functions in LIO. If it's not set then iscsit_release_commands_from_conn/
iscsit_free_cmd needs to do those last puts.

Here in this example to better show what I mean, we detect if an abort has been sent
to LIO core for a cmd that has not been sent to LIO core. If that happens then
iscsit_free_cmd gets force_cleanup=true so transport_generic_free_cmd will do a put
and not wait, and then iscsit_free_cmd does the last target_put_sess_cmd which
will wake #1 above. The abort will then complete too.

Note:
I don't think we have to worry about TAS in this case, because we never got a complete
SCSI command. The iscsi layer only got part of it and never submitted it to the SCSI
layer. We then escalated to session level recovery so we are not sending any responses
for any of the cmds or TMFs. The transport is killed at this point, so no responses
can even be sent.


diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 2c54c5d8412d..d0e80a2b653b 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4088,7 +4088,8 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
 
 		if (se_cmd->se_tfo != NULL) {
 			spin_lock_irq(&se_cmd->t_state_lock);
-			if (se_cmd->transport_state & CMD_T_ABORTED) {
+			if (se_cmd->transport_state & CMD_T_ABORTED &&
+			    se_cmd->transport_state & CMD_T_SUBMITTED) {
 				/*
 				 * LIO's abort path owns the cleanup for this,
 				 * so put it back on the list and let
@@ -4096,7 +4097,7 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
 				 */
 				list_move_tail(&cmd->i_conn_node,
 					       &conn->conn_cmd_list);
-			} else {
+			} else if (!(se_cmd->transport_state & CMD_T_ABORTED)) {
 				se_cmd->transport_state |= CMD_T_FABRIC_STOP;
 			}
 			spin_unlock_irq(&se_cmd->t_state_lock);
@@ -4108,8 +4109,12 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
 		list_del_init(&cmd->i_conn_node);
 
 		iscsit_increment_maxcmdsn(cmd, sess);
-		iscsit_free_cmd(cmd, true);
 
+		if (se_cmd->transport_state & CMD_T_ABORTED &&
+		    !(se_cmd->transport_state & CMD_T_SUBMITTED))
+			iscsit_free_cmd(cmd, false, true);
+		else
+			iscsit_free_cmd(cmd, true, false);
 	}
 }
 
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 6dd5810e2af1..931586595044 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -742,7 +742,7 @@ void __iscsit_free_cmd(struct iscsi_cmd *cmd, bool check_queues)
 		conn->conn_transport->iscsit_unmap_cmd(conn, cmd);
 }
 
-void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
+void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown, bool force_cleanup)
 {
 	struct se_cmd *se_cmd = cmd->se_cmd.se_tfo ? &cmd->se_cmd : NULL;
 	int rc;
@@ -751,10 +751,14 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
 
 	__iscsit_free_cmd(cmd, shutdown);
 	if (se_cmd) {
-		rc = transport_generic_free_cmd(se_cmd, shutdown);
+		rc = transport_generic_free_cmd(se_cmd,
+					force_cleanup ? false : shutdown);
 		if (!rc && shutdown && se_cmd->se_sess) {
 			__iscsit_free_cmd(cmd, shutdown);
 			target_put_sess_cmd(se_cmd);
+		} else if (se_cmd->sess && force_cleanup) {
+			__iscsit_free_cmd(cmd, true);
+			target_put_sess_cmd(se_cmd);
 		}
 	} else {
 		iscsit_release_cmd(cmd);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 14c6f2bb1b01..eb233ea8db65 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1554,7 +1554,7 @@ int transport_handle_cdb_direct(
 	 * this to be called for initial descriptor submission.
 	 */
 	cmd->t_state = TRANSPORT_NEW_CMD;
-	cmd->transport_state |= CMD_T_ACTIVE;
+	cmd->transport_state |= (CMD_T_ACTIVE | CMD_T_SUBMITTED);
 
 	/*
 	 * transport_generic_new_cmd() is already handling QUEUE_FULL,
@@ -2221,7 +2221,7 @@ void target_execute_cmd(struct se_cmd *cmd)
 		return;
 
 	spin_lock_irq(&cmd->t_state_lock);
-	cmd->t_state = TRANSPORT_PROCESSING;
+	cmd->t_state = (TRANSPORT_PROCESSING | CMD_T_SUBMITTED);
 	cmd->transport_state |= CMD_T_ACTIVE | CMD_T_SENT;
 	spin_unlock_irq(&cmd->t_state_lock);
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index fb11c7693b25..b759ec810fa9 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -511,6 +511,7 @@ struct se_cmd {
 #define CMD_T_COMPLETE		(1 << 2)
 #define CMD_T_SENT		(1 << 4)
 #define CMD_T_STOP		(1 << 5)
+#define CMD_T_SUBMITTED		(1 << 6)
 #define CMD_T_TAS		(1 << 10)
 #define CMD_T_FABRIC_STOP	(1 << 11)
 	spinlock_t		t_state_lock;





