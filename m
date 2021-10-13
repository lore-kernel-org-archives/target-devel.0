Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D56BFC433F5
	for <target-devel@archiver.kernel.org>; Wed, 13 Oct 2021 17:52:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3DC260EB4
	for <target-devel@archiver.kernel.org>; Wed, 13 Oct 2021 17:52:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhJMRyD (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 13 Oct 2021 13:54:03 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47874 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230301AbhJMRyC (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 13 Oct 2021 13:54:02 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19DHT68A006632;
        Wed, 13 Oct 2021 17:51:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=54xLa95WTf1+25YSRO1KXvNguMK0JSrNsSfNGPt+eYA=;
 b=yTMaQsA/oINr9kwq3Avc3DBtBDh+2Ab2SWb8I6ADe5oO9AxFTtsZFhW0usA4F+yCM7nW
 35xRKnvVenui2+7a5dZl6pwKExpL3LjWMiEm9VWN1nb+1NxhutH2fFHLeEy/Cx+75jyv
 THWmmKusPPOCLEKpc5xZyFDaEa/TOJMlxTYQewukoJIRpSUPxMfkd9hc9DWab87KKB+w
 NwlBit94KUBu23spHaHV+jq/5dMhADmCRBMjDVaCl7k7IkMlk0kB5kPafweo8F7JEo//
 qQD55jOev2YFGLBM4+Gifmyx45jvyOp+6g9Y4jVXqUAk8f/G/NRazw6LjXnr7KZjx/2P Ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bnkbh5p1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 17:51:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19DHoTCC101161;
        Wed, 13 Oct 2021 17:51:36 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by aserp3030.oracle.com with ESMTP id 3bkyxtw9kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 17:51:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jb+NrYFZwI4FOiTtWp/ekdnfviPWYbTvH8V6aMirUNILa5rfwOYQIIstZ2w3aRzmmGVrYHwBTmB87FqNKSytcXFDXM79xlUYmTJGK6H33Hk2oihf4MG1gnKOpOEcYl3LKfecThDFKVtsymIwqsNdfs1LcRPRQQkmo9rKERCJWv348P2AAVwyvSGlmmraAIXkD1B/1mN1TmffW0gcEEg9yDIWdqHBk3w5YFmvb5VTW3tKYbjs6LQRPcDosICi0kZ5iH5Auro2i7XFCbLjhXs3GFJryffLa32GN56x4l/W9qBBnTEsj4Njv9zzV/qpv5CkN3Enkkpn/FDdF1XYQ2R1GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=54xLa95WTf1+25YSRO1KXvNguMK0JSrNsSfNGPt+eYA=;
 b=lYHWO7QC08xQWN/+8sDR5HLMexlRjuUAGV+tyGyDnJJjj8ThkQUrRXvFi3olTfURJJkLqxIeDxXN4+dEGtZIMKxZQD0UcTCt0Jgp/8gLoHaeMgnRF5z2zlcLXCM8RlfU2qvLqoo8VYSRh1a62ZuUoQVb6qS+NO/cGkYqFAm9h2I3q6NMGf9gFNALLVN0ghZ37vY9emDiM5knfTWXAZBZ9N6iCN0jkTYC3ljOyg+qgpODnBxjP4DOS4CWiTGnfr6l4t7bT1Grr28flIfgQga1lWgqiNjzvict+uc9Nfrdx60Cay6gM0x2Q7KsrIJqhklx9jF0etyE7H73+z/xtTTDmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=54xLa95WTf1+25YSRO1KXvNguMK0JSrNsSfNGPt+eYA=;
 b=VcVkdoGZA/IICT4L7a/ZF6FLgwV9xIx0ePnjRyArWcm3hF+8Aqj/8p0ZmHyLFnBSjcj6xCgp2/DAOwBjqoN2Fa265VmC6UtGkSt913KyAh3hKkNDhYMPQBUMzIseXPemfZ2gbYQFijHRoEOljZdQyyUDrQjZkRLsCTphI8V4Oxk=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3387.namprd10.prod.outlook.com (2603:10b6:5:1aa::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.25; Wed, 13 Oct 2021 17:51:34 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4587.030; Wed, 13 Oct 2021
 17:51:34 +0000
Message-ID: <17647b68-f039-3fc3-808e-0feb652ddf8c@oracle.com>
Date:   Wed, 13 Oct 2021 12:51:32 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: iSCSI Abort Task and WRITE PENDING
Content-Language: en-US
To:     Konstantin Shelekhin <k.shelekhin@yadro.com>,
        target-devel@vger.kernel.org
Cc:     linux@yadro.com, Maurizio Lombardi <mlombard@redhat.com>
References: <YWbdbh1w1Eiw82Zr@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <YWbdbh1w1Eiw82Zr@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM3PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:0:50::24) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DM3PR03CA0014.namprd03.prod.outlook.com (2603:10b6:0:50::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Wed, 13 Oct 2021 17:51:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e24a0ab1-994c-43bf-ee3d-08d98e7218b3
X-MS-TrafficTypeDiagnostic: DM6PR10MB3387:
X-Microsoft-Antispam-PRVS: <DM6PR10MB33877EAF07D1DF43BF6FAB29F1B79@DM6PR10MB3387.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:59;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zfqjA4/+lGLseZZukdfIKxS+EIlSGodwEC1le2EtqOG751CLvieJ2+f/DSpfNWq3SKxmUK8mu1V88BA6vwgjIaC+Anaha7ZJDZxy11BRYlSNbGrmOPiUBDt84IZ+D9WgzVdWCKg2JGvAxrRo6pZoP7JoD8TFYUGtG8MIbjqnFt8BsW1O8TcCG+Ojkua92BTEE+QCuWCM8k22U4HFWKjT+iJOU98/kPw5NNkcxnVaaAt6bYSJFvvw2M1HYtChV36E1zMGz6JWfuSS9UXO9fu4cDv+IZRau9fz6K0/DJ5/HaIADhzWEfyUYPPLE/5mE2uDOGy29Rd+29iL0I4mfKY7B4/wk7Ft/YkdL5D5cTc6aBPf3mRaVE6uGZ+AS3zrccSctUxMBZegmBlW0uVwVbZtSEzbNUq+RAJ7dZze3BJyh2sxJMdf3i2pWNLtXHraVdRmxp/xp5XF8nPxwZ84zgIdvn8tIG5Jz8DwVNzsTDQNzgUCymLwtpMvvZ++7WukRREdLLBHTODYb1kPqDDcgWM3tI74KPGsMn4TCFoyw9lRMrUVtq4MkuWzz4Ar3GkRGkYr8OhEPpvvSY7VRVluRwalTZR0k+jgF9zIuKmSnotekw4D69oLIZzH0YBcxvwl2clAJyJs/A203J/C+h1bdtmzIULrbjTvhcMjA2FIbhsymCRdiLtXn9nPD6EXBj+tb2r/EsdOaaadZ2YBsKUVPEAGy/K9+T99sSTw/xdCQqg+9BthQSp12OGoLtctaU62U2lW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(4326008)(6706004)(16576012)(36756003)(38100700002)(66556008)(66946007)(956004)(53546011)(83380400001)(508600001)(66476007)(86362001)(31696002)(26005)(8676002)(316002)(186003)(5660300002)(2906002)(6486002)(8936002)(31686004)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TkdCU2l2Z2lia3FjcDRPSzVRa0JaRVp4djlSbVdQR1UvVkc2VTlHYmFWNTJQ?=
 =?utf-8?B?bEtvVXhvU3ZrWGV1Y3RnNytJazRaZXhyOWhUQ1lSNlVTTVEyN0M2Vk03YXo0?=
 =?utf-8?B?bjRZdWJrUllJdGxWakkzeDRtS2EyNFZpeUMzYjhjVEtvTnJxaVcrUzU5RXp5?=
 =?utf-8?B?UHdlcFBZTGJEREZIRGNxOWM5VVNkUmVadllkY3hBemxhYlZtYWkrOVZlMkxt?=
 =?utf-8?B?c2xhQ3p5WUZKTUwvYVNubEZSdHZlczFHVmp1MG9JM2xadmJEQ1lub0x0R3BT?=
 =?utf-8?B?Qk43bitjR3hUY2xMM0lYS2UvQnZZYlFqelZhQW01bHhqN0lxcXV2QXhMSks5?=
 =?utf-8?B?K0t6ajdXSnFRQ1VYWFR4cFBUMGVleWs5MDdEVkx3Ni9ybzRtbDJTclJNdUNY?=
 =?utf-8?B?YklJL0puNy90TDJsMXBSQ0tmTlFqZmhXelNOOEtUcUhUWWZYck1rVkI3RXl4?=
 =?utf-8?B?RkRISXpFR2pDejF5YllQL0tFaG5JSExpTmhlblZsU1RuRVNUNERCeW05Rm1E?=
 =?utf-8?B?a3F1VlR0bnA2U00wWWI4elAxaGo3SGVMSjBjTVdHc3RJNGJqNGJUL21RVTVR?=
 =?utf-8?B?VDJINkpaQnI0S2J5ZHlWZWZJQ0tjQm8vTFNVMEtCQjZyenVHNU9CdXNoNFQw?=
 =?utf-8?B?WHR2MU5ybnl1K1hrMXhQaXRZQmVmWjJLTjlkT2l2MHdNRFV6bkZVbjdYcS9a?=
 =?utf-8?B?U3hZa3hLMHJvY1ZJd2txZ0REVGw0QlVkVVZSYWE3VTViSld1a3ZVOTVRdktr?=
 =?utf-8?B?K2RFTUk2SkNUdy85ZStlNThjWUlySVoyVXNBQXRKZzN1SjFQSU9RYjE0VytF?=
 =?utf-8?B?Q2t6MmVkRzVubjI0ZmJVdCsyWktnb1NFZ0FaRlJyY2xMMHVRdWJabEk4bmdW?=
 =?utf-8?B?OVNmTlNVYVJaeEVDSE84Q1BadFhEUzBtVGI0UlFzM3dpeXZxbElOamRPQVl4?=
 =?utf-8?B?Rmp4cTVmbW5qRVM5ejVkVUNnU0NmVXpmM3JSS2RxT0gwOVA0d3B4dGZMVHJa?=
 =?utf-8?B?L3AxYkZiMXNxci9CWUtBb2FabzI4eGVBQUxyMWRoMUgvUUFLamFwMWlueUdE?=
 =?utf-8?B?WmNtRXUzNnltelhvU0FzVG93aCtoMkJadElEeGZZWkxTMXFOK2Y3clNMMGUv?=
 =?utf-8?B?Z2tBY01pK0Z1b2hCSC9zNmZuV2NpdWJIQm9xNDdvT0Mxd2IrYStleVcvU284?=
 =?utf-8?B?UmNLZ2p2SEpvUEtzUGV3b0FKeEwvUWpkYVFRa0krUHhwK3ZnaWt2djdTa25J?=
 =?utf-8?B?YS9GVzdJQ3g0MnpqMkxjaFpYbDZURkN2SHVJNTRhc1M3Zm9vZHBFVkFOZDdG?=
 =?utf-8?B?T1NINkk1R3hZRmRYL3M2RUlTTG4xc1lOV1NzODRzVXZnNm5FWlVIcTJEYmkv?=
 =?utf-8?B?QXFRUlpkc1pQRDI0S2d2VndzN3dFRi9rZnQ5aFYvNkxBb0RYSEpqQkdOUERx?=
 =?utf-8?B?VnRJSXhhdy8yV25CTlBOM2VZNUFpbG9FczJkWjdsTFg3dDZsYmJsL1ppdUtU?=
 =?utf-8?B?dXRYb3YwNm5KM1NmQ0lEKzdwQ3U0UVJzUUVWeGUrMVIyVEdqdGVVTU9vc21Q?=
 =?utf-8?B?Q0NnSDZ1SjUzeWVnQUZKa3ZBUmdHblFpNXFmdzlob1RvY2l6V1pMSS9MTENx?=
 =?utf-8?B?a3owZ3VzR1Z5VGFGbzBLb2wydS9hZDhEU3pkN3I1NnByT0JDVTFJV3RZYUZt?=
 =?utf-8?B?RWc4RzFzd1h5STNKc1EyRVRka2dqVm9qQXZkSE9PeDJ0T2xaUGJNZU4vUDF3?=
 =?utf-8?Q?oy+NQf6NgkBSDYRvEm70WDSzlL7MGmoE0yzQKMw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e24a0ab1-994c-43bf-ee3d-08d98e7218b3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 17:51:34.3086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZJdL9PqnRgDYQdEdO+u/Oc9srQjqxito7pReFkAiTeBTKWgvcZHeq6FoXmGgojlZvJALl05KKunsLhZzPeiCnNPgIyn6mAG0egLok7ekJkY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3387
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10136 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110130108
X-Proofpoint-GUID: RO9IYVFSeKvHPWj_jvXrfXVpnQ_9Blvp
X-Proofpoint-ORIG-GUID: RO9IYVFSeKvHPWj_jvXrfXVpnQ_9Blvp
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 10/13/21 8:21 AM, Konstantin Shelekhin wrote:
> Hi,
> 
> I really need the collective wisdom.
> 
> Not long ago we've uncovered the problem with iSCSI and ABORT TASK
> handling. Currently it's not possible to abort a WRITE_10 command in
> TRANSPORT_WRITE_PENDING state, because ABORT TASK  will hang itself in
> the process:
> 
>   # dmesg | tail -2
>   [   83.563505] ABORT_TASK: Found referenced iSCSI task_tag: 3372979269
>   [   84.593545] Unable to recover from DataOut timeout while in ERL=0, closing iSCSI connection for I_T Nexus <nexus>
> 
>   # ps aux | awk '$8 ~/D/'
>   root        32  0.0  0.0      0     0 ?        D    15:19   0:00 [kworker/0:1+events]
>   root      1187  0.0  0.0      0     0 ?        D    15:20   0:00 [iscsi_ttx]
> 
>   # cat /proc/32/stack
>   [<0>] target_put_cmd_and_wait+0x68/0xa0
>   [<0>] core_tmr_abort_task.cold+0x16b/0x192
>   [<0>] target_tmr_work+0x9e/0xe0
>   [<0>] process_one_work+0x1d4/0x370
>   [<0>] worker_thread+0x48/0x3d0
>   [<0>] kthread+0x122/0x140
>   [<0>] ret_from_fork+0x22/0x30
> 
>   # cat /proc/1187/stack
>   [<0>] __transport_wait_for_tasks+0xaf/0x100
>   [<0>] transport_generic_free_cmd+0xe9/0x180
>   [<0>] iscsit_free_cmd+0x50/0xb0
>   [<0>] iscsit_close_connection+0x47d/0x8c0
>   [<0>] iscsit_take_action_for_connection_exit+0x6f/0xf0
>   [<0>] iscsi_target_tx_thread+0x184/0x200
>   [<0>] kthread+0x122/0x140
>   [<0>] ret_from_fork+0x22/0x30
> 
> What happens:
> 
>   1. Initiator sends WRITE_10 CDB
>   2. Target parses the CDB and sends R2T
>   3. Target starts the Data-Out timer
>   4. Initiator sends ABORT TASK; no new data from Initiator after this
>   5. Target starts aborting WRITE_10, gets into core_tmr_abort_task()
>      and starts waiting for the request completion
>   6. Nothing happens
>   7. The Data-Out timers expires, connection teardown starts and gets
>      stuck waiting for ABORT TASK that waits for WRITE_10
> 
> The ABORT TASK processing looks roughly like this:
> 
>   iscsi_rx_opcode
>     iscsi_handle_task_mgt_cmd
>       iscsi_tmr_abort_task
>       transport_generic_handle_tmr
>         if (tmr_cmd->transport_state & CMD_T_ABORTED)
>           target_handle_abort
>         else
>           target_tmr_work
>             if (tmr_cmd->transport_state & CMD_T_ABORTED)
>               target_handle_abort
>             else
>               core_tmr_abort_task
>                 ret = __target_check_io_state
>                   if (write_cmd->transport_state & CMD_T_STOP)
>                     return -1
>                   write_cmd->transport_state |= CMD_T_ABORTED
>                   return 0
>                 if (!ret)
>                   list_move_tail(&write_cmd->state_list, &aborted)
>                   target_put_cmd_and_wait(&write_cmd)
> 
> As I see it, the main problem is that the abort path can't initiate the
> command termination, it simply waits for the request to handle this on
> the execution path like in target_execute_cmd():
> 
>   target_execute_cmd
>     target_cmd_interrupted
>       INIT_WORK(&cmd->work, target_abort_work)
> 
> However, in this case the request is not going to be executed because
> Initiator will not send the Data-Out buffer.
> 
> I have a couple of ideas on how to fix this, but they all look kinda
> ugly. The one that currently works around this for me:
> 
>   core_tmr_abort_task():
> 
>     [...]
> 
>     spin_lock_irqsave(&se_cmd->t_state_lock, flags);
>     write_pending = se_cmd->t_state == TRANSPORT_WRITE_PENDING;
>     spin_unlock_irqrestore(&se_cmd->t_state_lock, flags);
>     
>     if (write_pending && se_cmd->se_tfo->abort_write_pending)
>             se_cmd->se_tfo->abort_write_pending(se_cmd);
>     
>     target_put_cmd_and_wait(se_cmd);
> 
>     [...]
> 
> The new method abort_write_pending() is defined only for iSCSI and calls
> target_handle_abort(). However, this opens up another can of worms
> because this code heavily races with R2T sending and requires a couple
> of checks to "work most of the time". Not ideal, by far.
> 
> I can make this one better by introducing R2T list draining that ensures
> the proper order during cleanup, but maybe there is a much easier way
> that I'm not seeing here.

Ccing Maurizio to make sure I don't add his original bug back.

If I understand you, I think I added this bug in:

commit f36199355c64a39fe82cfddc7623d827c7e050da
Author: Mike Christie <michael.christie@oracle.com>
Date:   Fri Nov 13 19:46:18 2020 -0600

    scsi: target: iscsi: Fix cmd abort fabric stop race

With that patch if the abort or a lun reset has got to lio core then we
are going to be stuck waiting for the data which won't come because we
killed the iscsi threads.

Can go back to always having the iscsi target clean up the cmd, but if
LIO has started to abort the cmd we take an extra ref so we don't free
the cmd from under each other.

This patch is completely untested:


diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 2c54c5d8412d..d221e9be7468 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4090,12 +4090,13 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
 			spin_lock_irq(&se_cmd->t_state_lock);
 			if (se_cmd->transport_state & CMD_T_ABORTED) {
 				/*
-				 * LIO's abort path owns the cleanup for this,
-				 * so put it back on the list and let
-				 * aborted_task handle it.
+				 * The LIO TMR handler owns the cmd but if
+				 * we were waiting for data from the initiator
+				 * then we need to internally cleanup to be
+				 * able to complete it. Get an extra ref so
+				 * we don't free the cmd from under LIO core.
 				 */
-				list_move_tail(&cmd->i_conn_node,
-					       &conn->conn_cmd_list);
+				target_get_sess_cmd(se_cmd, false);
 			} else {
 				se_cmd->transport_state |= CMD_T_FABRIC_STOP;
 			}
