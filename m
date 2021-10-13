Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E981C433F5
	for <target-devel@archiver.kernel.org>; Wed, 13 Oct 2021 18:30:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2756060C49
	for <target-devel@archiver.kernel.org>; Wed, 13 Oct 2021 18:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhJMSct (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 13 Oct 2021 14:32:49 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:51834 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229814AbhJMSct (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 13 Oct 2021 14:32:49 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19DIDvJw009912;
        Wed, 13 Oct 2021 18:30:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=KVWNQJ2wf7OK93EIcHJE+M229U4oYILyxTmRYVeIVAo=;
 b=rqd3AM1uAx6kfVrKfduOxfxp+6SLWkH+sWvOymiijzWL4enpF/Sc3Vkqpw3gt2f1qIUe
 HjlhkgsNqvbMqi6ZQq+cooJ6WE9fJ/MXJZQnPctN88aoqWicdNBhvOYC3oJsnx1benIM
 09NWMolGg9TO4DcLcRcoQP/UAkvjzlx+KYSBtXyuAhc3GPJKGWrt89bYYP1LUVBNAaPN
 yfiwjPdSst02Jelw0vOFYUfF4NZgYuzjnNeDd22gqooFMwD+KT9v0zfUTIZ/Bgb7ssK7
 PMh9X/meVpoE/wZToTb5hxLGK/OalYWld0z35U8OydE+rAvIykfktV9R35O9YzWc6ZeH sA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bnkbuedh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 18:30:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19DIFA2B042664;
        Wed, 13 Oct 2021 18:30:37 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by userp3030.oracle.com with ESMTP id 3bkyvb99be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 18:30:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CjQGF/4+N1qZmoQq0OiLWtVnzZzu6+m1RsR6+/P+dKnvFu8iNSj0NxvqDIeAFZxD3UParRQWF1pTuPERANPNGK7gEi5yHT3seYzReq7O5X1WbL44qVjlpdhaankbyY2Ban2KDq9AXbvK5PRTF67RlKX49IUV+ZI6n4adsnyp+Nng6uTRw0E8XEWnV5OfsE8IJFQ/JRUT85w+vn9Yar6GBUKLUuWDTTRSxBjGfE+z7SA6aS2PMtadUU4K+5y+AeeoyEfxlHynM+fEsBZoq0s10gz/ZsvDf0Ucq9QcjjzbigTn6MFgSWyfexDq+MdhgQ+nsW16Luw7hwWjW2yETUDNTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KVWNQJ2wf7OK93EIcHJE+M229U4oYILyxTmRYVeIVAo=;
 b=KIR/v8VFGIL8WHLEYDrq0FNrgXZLTNfTQg3j0phAW6us3iVqBU6dCbRBiw5PWWd14WFHZIyzaBbiPTh1/VOf5sO9Y0nzMDCcXi/BkfxV4RXR8zENx4Qg9j71Ol2eZO2YZEl648+DSu/jqn4KCGJf/ZifnLqxNiw63yvHxreECI3WsZTRYtc6vjk8oaf/8mIDct8Ca+9LyIJd3hwzn6Ds4Z6rj+3vTx/N935cyq8rcdOyeop44RyUmtk4rxscRjg4lAFTNhH3k84no/mA/WluCpMgTikpP2z7wlkJT1M6ZI2Hbvj4U9vn3Z+22yZVum07kxwhePPjsfbE/gqdzd85zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVWNQJ2wf7OK93EIcHJE+M229U4oYILyxTmRYVeIVAo=;
 b=VklkQOg1jYjZIvlDkt4sAvn2TGCfoPsfsxaNKuo+rufEHbCj9dDfEBNMKgI3lybjExWh0sdKgUFddYFhom2hBuRy2A5jOD+bmYGIdpz8ox+iy3ZIqISuRCKlp2ATpjaY5XC2vZH9PX6kE32QXwvFQRk6UxqSWgBuBPnmmD591eY=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM5PR1001MB2266.namprd10.prod.outlook.com (2603:10b6:4:2d::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.26; Wed, 13 Oct 2021 18:30:34 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4587.030; Wed, 13 Oct 2021
 18:30:34 +0000
Message-ID: <6059cfab-5cbb-984b-7efc-eb193bddea7a@oracle.com>
Date:   Wed, 13 Oct 2021 13:30:32 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: iSCSI Abort Task and WRITE PENDING
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
To:     Konstantin Shelekhin <k.shelekhin@yadro.com>
Cc:     target-devel@vger.kernel.org, linux@yadro.com,
        Maurizio Lombardi <mlombard@redhat.com>
References: <YWbdbh1w1Eiw82Zr@yadro.com>
 <17647b68-f039-3fc3-808e-0feb652ddf8c@oracle.com>
 <YWcggfDyrHU1VhKN@yadro.com>
 <2e83aa6a-2746-8914-f295-30eea8954814@oracle.com>
In-Reply-To: <2e83aa6a-2746-8914-f295-30eea8954814@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR01CA0016.prod.exchangelabs.com (2603:10b6:5:296::21)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DM6PR01CA0016.prod.exchangelabs.com (2603:10b6:5:296::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Wed, 13 Oct 2021 18:30:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28a7fa40-39a9-4e45-69cb-08d98e778b58
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2266:
X-Microsoft-Antispam-PRVS: <DM5PR1001MB22663433FAFCC84407392294F1B79@DM5PR1001MB2266.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:76;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: umWTURiOuNLipyEla/tbfjg/piEz7GBEqfMglEkSzdlR7h/jqPyASEZq4Mnu246/CHL/6oKXlGA0PB1GQ/RKQP3WrigMr+agSctORvsfNyrkpvTDqz7GhTMfxDLGAJs66vYpyTIYr5+GokD5ljxL9/PlXnDJR0zZgJC7SHNLNG1xRpaAQCbO7RJXDWbb04GEoteD9/yEfoilzhAu+sDMk+9ETxESIl/KibzRcMG5CKKGj8hnDp2krxNb5mGgj95ssZLFovdInXsbLafn/V0Aqz6VnI/XpS/t1rX1ZH8yMkkUo7o/S3xtByolam/Te8etqsBvIrW/6w3OBlnqDEpAulQ1w+ivUPzdOt+GN+6hL0wfo6gh9lOzqoOs1/BI2JPPs2TQ7voKzITDOH40oBi8WSvaDSD4rPSqJi8hA4F9rl39d110KFqbJ6HdmsDj57HkZdnQ9ZDAkFhDuAMMJD2lkLSz/4z9tfQkBnM9atARgWhYQ5kc+a2Rtafx0KERmfeTwAia8JxtlTW+Va9nzKzsOKFHgWNtO7FfkDe2uI4iAbYayGraRLfW3Hb4ZJdCyt2XFNOKd9HIqHSMLh+5mjRh6XbiUNXAyzv7YobEd+6o1AhpEkQPfap6FZk+VpkYhFZUaL3LsPBDfE+NHux5+ZXJEJ8sZ/50ljN9qA1qI9TsQjEfVRNZhdp83D70x4mdjwSEBwx/L1rP8aAV1g+JWPnJkRv6z4w0NcNe0W8zig7nF4Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(4326008)(2616005)(2906002)(36756003)(6486002)(16576012)(6916009)(6706004)(316002)(31696002)(8676002)(83380400001)(66946007)(53546011)(8936002)(86362001)(66556008)(31686004)(956004)(66476007)(5660300002)(26005)(38100700002)(186003)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NjNWUEc0S2RhM3lhbVF4T3JFWXFvWVFDNDJFVUxlZFd3NjlSaEN2VldFOHBo?=
 =?utf-8?B?UmJpbzlFTlgyU2JvM29BOENwWXRNU2dSZk9GeHR5dGFFeXZoUmtDeUkrK3cz?=
 =?utf-8?B?Qmp4K1Rtemt6OEIyeEZhRyt4Tng2aXNHMHN4eGxSV3FEeVdBdEwrKzc0R3BO?=
 =?utf-8?B?OHdsd21ZOWFJNWZnYThPNWJwT3lGOURuZUE4cEU4ODNyTW0wY1lIRjFuZEFy?=
 =?utf-8?B?N0h1dGdUZTZXbjBKeXhEeWFaSmg5SS9lKy96eUsvMTAwd0ZaV1J0aEFXUzdT?=
 =?utf-8?B?aWhmUE8rcTVVUHFySVp5cVdCK216QXl1VnI4TkNrWEpCZEFHZldIVDFIc0p2?=
 =?utf-8?B?VnVseG5nOTJPOEFtTSs1QmhTTHU5WEt6ZTdFWnBXWHp4eUxsVU55MzBqekZh?=
 =?utf-8?B?aHpPMWhGU0VEcHRINE4wTm90N2pyeHJKUWNQTUNhUVplT3hFcE14WkFnWWRz?=
 =?utf-8?B?NkhPMlN1aHNZdksyYzcyUEROL0hBVUlGUWQyK3JuUWlHY01hTkdiaXhDNlhx?=
 =?utf-8?B?azZGTEQ0N29Ud1d6UEFFMXpaSXZ4TW5LcTBLeGFJYUZ6REVEenZvbnprSFFp?=
 =?utf-8?B?QjhoOGp6ZmxrL3RzRTNIRVFrV2psT2haeW5raDRQeDk2RlNwd3pDTG44eUhT?=
 =?utf-8?B?Y2Vma0dFNFBhWm1kUXJVZ0FVMHRiaitUeXhRbGJZVjhaOXJzbHBEeFNmYStM?=
 =?utf-8?B?cklxbTlxRFZHVFBVUzMwY3NraEVBSm0wemtiT1J6cHl0UGJnZTV2OXFjS3gz?=
 =?utf-8?B?d0pQa3QrZHc2eTBPTXltSnI5dnpZT3ZZOGVweEFTVUZHUEM5b3RYSFRwTGxx?=
 =?utf-8?B?aUdwaE5EcVkzUUozYit2a0wwRCs4MWdxd2FxbzdxeVVnUWlmV0dCWGZvNUhW?=
 =?utf-8?B?UXJ6VktiM1ZzVGV2c1BqTWZGRkpkbDI2ZnBGMmxST0pBSXQ0d0JES0hkQ1cx?=
 =?utf-8?B?NkxEZFpHY2xPRnd2T0NWdzBZN3ZBVmhFZWRWampIeENtbnhPbnpOMmhwUVRp?=
 =?utf-8?B?YnVhVEMwM3pUd3EvR01pZGVYWDAybEp1WmV4UDBhdUFZT1pSR2V5dEZncmdI?=
 =?utf-8?B?ZVdJeTRqQXEvT0VpWWdTUi85N2lOanJCaGJoQjRjMVlXdzdUNnpHNHNqaDZR?=
 =?utf-8?B?d0szck9MNkkwc0tGY052OGRudWNId3JESnJHSUp1aXVCWEtkbmgzbjhkNDRu?=
 =?utf-8?B?VFBhQW9WdzNva3lxdmt6ajRVVUdMNWw4anA4RVJpcnhLT1VUR1NSWXQxaThT?=
 =?utf-8?B?dmh6aXc2dmxSdDN0S2RvRzgxMGZ1WHBqdWdRRUJnUDZCbXROaEdaUFh2NzNj?=
 =?utf-8?B?WWgxNWkwbDR5QWpsMUVHNWl0RmEwTFdaTkd4MWlKaGVtbzZzM2UxdGhsYlQ0?=
 =?utf-8?B?WDBSRGZTWGQ5WHpHOVdpUitjNmJSRDNjQ1U0OW1UYXI3dTRwdUtOZUZzellv?=
 =?utf-8?B?dWYvUjhvQ2lmVzZObTE2c012SjlIVUpKeEtwb0JrZ1l0NVhGWm5QR0FWZ0t0?=
 =?utf-8?B?RHowalh2b3BtTWh3K0pNSmhkWVhNMlJITmRTc0NVODNIMFhROHpDWVgvb3lI?=
 =?utf-8?B?Z2dQdXdoa2NwUzVIU3VQODdDdWlyZ0lQWFQ4cmFSUSsvVEdPQlI0bi9WUVVG?=
 =?utf-8?B?WXgzeEM3amhSYWppVUZWamJQS0I2REE5L1Jrd3V2M1JpalJ6RFR2Q1NPME9o?=
 =?utf-8?B?THR3OFNwa1g2TjhjQlB0alpBSFhScFZYNTVvb2xXcW95bFFhU0FBak9EaWsy?=
 =?utf-8?Q?fPQYJ7RK4sMA0rCus3WvC/FnMyyFPeGTJiA9yKJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28a7fa40-39a9-4e45-69cb-08d98e778b58
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 18:30:34.1734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LSYOISbzjWP89QwJBBLa1Pj47tVsczBXQBhUAt/fnracQhyqyqwxdlfWFgUw/ZG4D5gkYDcv3mo7vgv31424pHA9CIGZhMkb3RMTelfOYco=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2266
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10136 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110130112
X-Proofpoint-ORIG-GUID: SyR4qleVX5fafPokdj6oFNaoI3Cm1zOy
X-Proofpoint-GUID: SyR4qleVX5fafPokdj6oFNaoI3Cm1zOy
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 10/13/21 1:24 PM, Mike Christie wrote:
> On 10/13/21 1:08 PM, Konstantin Shelekhin wrote:
>> On Wed, Oct 13, 2021 at 12:51:32PM -0500, Mike Christie wrote:
>>> On 10/13/21 8:21 AM, Konstantin Shelekhin wrote:
>>>> Hi,
>>>>
>>>> I really need the collective wisdom.
>>>>
>>>> Not long ago we've uncovered the problem with iSCSI and ABORT TASK
>>>> handling. Currently it's not possible to abort a WRITE_10 command in
>>>> TRANSPORT_WRITE_PENDING state, because ABORT TASK  will hang itself in
>>>> the process:
>>>>
>>>>   # dmesg | tail -2
>>>>   [   83.563505] ABORT_TASK: Found referenced iSCSI task_tag: 3372979269
>>>>   [   84.593545] Unable to recover from DataOut timeout while in ERL=0, closing iSCSI connection for I_T Nexus <nexus>
>>>>
>>>>   # ps aux | awk '$8 ~/D/'
>>>>   root        32  0.0  0.0      0     0 ?        D    15:19   0:00 [kworker/0:1+events]
>>>>   root      1187  0.0  0.0      0     0 ?        D    15:20   0:00 [iscsi_ttx]
>>>>
>>>>   # cat /proc/32/stack
>>>>   [<0>] target_put_cmd_and_wait+0x68/0xa0
>>>>   [<0>] core_tmr_abort_task.cold+0x16b/0x192
>>>>   [<0>] target_tmr_work+0x9e/0xe0
>>>>   [<0>] process_one_work+0x1d4/0x370
>>>>   [<0>] worker_thread+0x48/0x3d0
>>>>   [<0>] kthread+0x122/0x140
>>>>   [<0>] ret_from_fork+0x22/0x30
>>>>
>>>>   # cat /proc/1187/stack
>>>>   [<0>] __transport_wait_for_tasks+0xaf/0x100
>>>>   [<0>] transport_generic_free_cmd+0xe9/0x180
>>>>   [<0>] iscsit_free_cmd+0x50/0xb0
>>>>   [<0>] iscsit_close_connection+0x47d/0x8c0
>>>>   [<0>] iscsit_take_action_for_connection_exit+0x6f/0xf0
>>>>   [<0>] iscsi_target_tx_thread+0x184/0x200
>>>>   [<0>] kthread+0x122/0x140
>>>>   [<0>] ret_from_fork+0x22/0x30
>>>>
>>>> What happens:
>>>>
>>>>   1. Initiator sends WRITE_10 CDB
>>>>   2. Target parses the CDB and sends R2T
>>>>   3. Target starts the Data-Out timer
>>>>   4. Initiator sends ABORT TASK; no new data from Initiator after this
>>>>   5. Target starts aborting WRITE_10, gets into core_tmr_abort_task()
>>>>      and starts waiting for the request completion
>>>>   6. Nothing happens
>>>>   7. The Data-Out timers expires, connection teardown starts and gets
>>>>      stuck waiting for ABORT TASK that waits for WRITE_10
>>>>
>>>> The ABORT TASK processing looks roughly like this:
>>>>
>>>>   iscsi_rx_opcode
>>>>     iscsi_handle_task_mgt_cmd
>>>>       iscsi_tmr_abort_task
>>>>       transport_generic_handle_tmr
>>>>         if (tmr_cmd->transport_state & CMD_T_ABORTED)
>>>>           target_handle_abort
>>>>         else
>>>>           target_tmr_work
>>>>             if (tmr_cmd->transport_state & CMD_T_ABORTED)
>>>>               target_handle_abort
>>>>             else
>>>>               core_tmr_abort_task
>>>>                 ret = __target_check_io_state
>>>>                   if (write_cmd->transport_state & CMD_T_STOP)
>>>>                     return -1
>>>>                   write_cmd->transport_state |= CMD_T_ABORTED
>>>>                   return 0
>>>>                 if (!ret)
>>>>                   list_move_tail(&write_cmd->state_list, &aborted)
>>>>                   target_put_cmd_and_wait(&write_cmd)
>>>>
>>>> As I see it, the main problem is that the abort path can't initiate the
>>>> command termination, it simply waits for the request to handle this on
>>>> the execution path like in target_execute_cmd():
>>>>
>>>>   target_execute_cmd
>>>>     target_cmd_interrupted
>>>>       INIT_WORK(&cmd->work, target_abort_work)
>>>>
>>>> However, in this case the request is not going to be executed because
>>>> Initiator will not send the Data-Out buffer.
>>>>
>>>> I have a couple of ideas on how to fix this, but they all look kinda
>>>> ugly. The one that currently works around this for me:
>>>>
>>>>   core_tmr_abort_task():
>>>>
>>>>     [...]
>>>>
>>>>     spin_lock_irqsave(&se_cmd->t_state_lock, flags);
>>>>     write_pending = se_cmd->t_state == TRANSPORT_WRITE_PENDING;
>>>>     spin_unlock_irqrestore(&se_cmd->t_state_lock, flags);
>>>>     
>>>>     if (write_pending && se_cmd->se_tfo->abort_write_pending)
>>>>             se_cmd->se_tfo->abort_write_pending(se_cmd);
>>>>     
>>>>     target_put_cmd_and_wait(se_cmd);
>>>>
>>>>     [...]
>>>>
>>>> The new method abort_write_pending() is defined only for iSCSI and calls
>>>> target_handle_abort(). However, this opens up another can of worms
>>>> because this code heavily races with R2T sending and requires a couple
>>>> of checks to "work most of the time". Not ideal, by far.
>>>>
>>>> I can make this one better by introducing R2T list draining that ensures
>>>> the proper order during cleanup, but maybe there is a much easier way
>>>> that I'm not seeing here.
>>>
>>> Ccing Maurizio to make sure I don't add his original bug back.
>>>
>>> If I understand you, I think I added this bug in:
>>>
>>> commit f36199355c64a39fe82cfddc7623d827c7e050da
>>> Author: Mike Christie <michael.christie@oracle.com>
>>> Date:   Fri Nov 13 19:46:18 2020 -0600
>>>
>>>     scsi: target: iscsi: Fix cmd abort fabric stop race
>>>
>>> With that patch if the abort or a lun reset has got to lio core then we
>>> are going to be stuck waiting for the data which won't come because we
>>> killed the iscsi threads.
>>>
>>> Can go back to always having the iscsi target clean up the cmd, but if
>>> LIO has started to abort the cmd we take an extra ref so we don't free
>>> the cmd from under each other.
>>>
>>> This patch is completely untested:
>>>
>>>
>>> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
>>> index 2c54c5d8412d..d221e9be7468 100644
>>> --- a/drivers/target/iscsi/iscsi_target.c
>>> +++ b/drivers/target/iscsi/iscsi_target.c
>>> @@ -4090,12 +4090,13 @@ static void 	(struct iscsi_conn *conn)
>>>  			spin_lock_irq(&se_cmd->t_state_lock);
>>>  			if (se_cmd->transport_state & CMD_T_ABORTED) {
>>>  				/*
>>> -				 * LIO's abort path owns the cleanup for this,
>>> -				 * so put it back on the list and let
>>> -				 * aborted_task handle it.
>>> +				 * The LIO TMR handler owns the cmd but if
>>> +				 * we were waiting for data from the initiator
>>> +				 * then we need to internally cleanup to be
>>> +				 * able to complete it. Get an extra ref so
>>> +				 * we don't free the cmd from under LIO core.
>>>  				 */
>>> -				list_move_tail(&cmd->i_conn_node,
>>> -					       &conn->conn_cmd_list);
>>> +				target_get_sess_cmd(se_cmd, false);
>>>  			} else {
>>>  				se_cmd->transport_state |= CMD_T_FABRIC_STOP;
>>>  			}
>>
>> The bug was there before. I had to backport this patch in order to
>> introduce my fix. I can revert it and check what is different, but it's
>> there in some form.
>>
> 
> Don't waste your time. It's because iscsit_free_cmd's call to
> transport_generic_free_cmd has wait_for_tasks=true.
> 
> We then do transport_generic_free_cmd -> target_wait_free_cmd ->
> __transport_wait_for_tasks like you posted above.

That's wrong, it's the transport_generic_free_cmd wait:

        if (aborted) {
                pr_debug("Detected CMD_T_ABORTED for ITT: %llu\n", cmd->tag);
                wait_for_completion(&compl);
                ret = 1;

