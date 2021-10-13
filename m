Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82F1BC433F5
	for <target-devel@archiver.kernel.org>; Wed, 13 Oct 2021 18:05:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6528D60ED4
	for <target-devel@archiver.kernel.org>; Wed, 13 Oct 2021 18:05:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbhJMSHg (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 13 Oct 2021 14:07:36 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:14834 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229967AbhJMSHg (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 13 Oct 2021 14:07:36 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19DHNj69008157;
        Wed, 13 Oct 2021 18:05:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=3CUapQsZmadSNW8hiDNVkTKq5aXEz3v98BL6DPnBvAE=;
 b=mOOwUNbtPiF+0KnnvjXN2RV7JHyy9zIKYG5LjBGfYuGSdRVGkEBuUKwOYtSV3SglvvQC
 uh4OfSK8Oj0xvo1bPwlnFFy4+Ee5jBs1LvelAo5EQ9F4Q1nG4EBS54ZAwza+aENvJWDH
 9ValJHemXaOWLKsMOrt01biDfF7f6oydKmkk6lPeBg6kiIH/ZRsS4K+Rg2lL/BzoBnCe
 z1g5G20o9W6YVzwlx6mOdYZyGOCIyZvMdnyORSioozChbYFCA5c+mQgNZZ8f5QmSisVB
 2hY0LHQ34+E0EwJgfjJGdXuB9CVGydgWgkT3FDmtSdzP1HqPm/q/R0hEb2DscPH51WR2 OA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bnkbj6bef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 18:05:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19DI0VAj148015;
        Wed, 13 Oct 2021 18:05:29 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by aserp3030.oracle.com with ESMTP id 3bkyxtwwnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 18:05:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VjxV+ruD6fQ8jU6GEB94u1AXBTXNrcZU5OhjoQZHPwOTR44I+88PMW/67WuuRFe4+UibRjSiC0IYnwiwFHeY6PdqOfXXUZZJtV9sHxQaovVCecnz+/zShEvVpj9YAXLfgdTbI6CPuemRQrQ4a5r2A3KX//zZknHHiKM3OqxWzVQc3R3QSzk16L+aw+OKDrY+gt8c7gGLjC03SEwprbWR1mTytcY4uWZwsI+jekVu5YgaqU6vFkpVpGeDBPX/igjmyTHwawDfe8gOGVZINjRDg/7/N8m1mW1lHpHhN61wMPgnjiskHMuX30+WUERWZiOyLx5ta+yACRvceieiq6o5CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3CUapQsZmadSNW8hiDNVkTKq5aXEz3v98BL6DPnBvAE=;
 b=lr2rvaPdJbP3SDNjv6NPCeBLe+G2BzLQPNzllu8xQpXo7fBCLNZNNUqVgAtwOoFXtgcGywaJx3q1wMXV1anhkWzZuyMNgv02MRLIbt+3fzJWz/MFBUEwyZdHY4mPsjhh97LiJrMRjYRYbODNfZFJqtNlhTZxdZxG2Z1QMGZQlq4gN5WMR8bCg1PRcwStpjG/TwQuGE6jVYv0t7Ky/1gsqQ9UmIdDFUVMAWRLmtcE59xkOaDVU9x7OoLkj6ImhhAnwHWuZ0TaaW/8pZNEZnbW8G9VsAkAnGyYuhsK7k35W99+C756/DEoSrss6Cn3cKP0eSl6LNmp8vJ4kxF9oObeAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3CUapQsZmadSNW8hiDNVkTKq5aXEz3v98BL6DPnBvAE=;
 b=XlYfn/4s05X6vob4cAVuNfW3+H2/2vCXTyHwBmjNNZIxXOmMUMvv7dhY3lYUGajfVS5hYjo5xVwx+Lv1iqnCXBx84T/IVdXpouPRYFTDVNAjEt5cMU6w1FuInie67Pg15Z0JjJOGfGQdb3StVDjkaeJdv3nRIjk9w4Or74MLuaA=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2668.namprd10.prod.outlook.com (2603:10b6:5:b2::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.22; Wed, 13 Oct 2021 18:05:27 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4587.030; Wed, 13 Oct 2021
 18:05:27 +0000
Message-ID: <b49d2f3b-4762-832f-55ff-7543e08f387b@oracle.com>
Date:   Wed, 13 Oct 2021 13:05:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: iSCSI Abort Task and WRITE PENDING
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
To:     Konstantin Shelekhin <k.shelekhin@yadro.com>,
        target-devel@vger.kernel.org
Cc:     linux@yadro.com, Maurizio Lombardi <mlombard@redhat.com>
References: <YWbdbh1w1Eiw82Zr@yadro.com>
 <17647b68-f039-3fc3-808e-0feb652ddf8c@oracle.com>
In-Reply-To: <17647b68-f039-3fc3-808e-0feb652ddf8c@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR15CA0063.namprd15.prod.outlook.com
 (2603:10b6:3:ae::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DM5PR15CA0063.namprd15.prod.outlook.com (2603:10b6:3:ae::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 18:05:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf8f375f-05c7-402d-5bd0-08d98e740984
X-MS-TrafficTypeDiagnostic: DM6PR10MB2668:
X-Microsoft-Antispam-PRVS: <DM6PR10MB26680B37849AF9E6A5D0EB88F1B79@DM6PR10MB2668.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:397;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qfChq869NPiKeNEr2gmEkR5m6sNt4L81EpKn1SkQl/AF8zPrUKJ1M6FFpyTrNEhmEsUUaygJpUEuH2TXuLjDSYqStGiY1WQkJvw5pLrYr2WR+DaEkvHHXYWjWtCdBlG+x0R3NIjb6QLFKssTks47OXJuGvwjV/oVOzMgoUoumwsRGfA+fZmc/FJslvVZCTDrKL1zxG9J4o2ppymKEh7n9rdhe2CzZ2wmiUYDt374NFZ3xv+1bNs1FVY+dviGH3dE00T04SNNG0V+RhS8feg7d9urcPbY9wIMbx15QZaLP2jdCdlCz7mhCimqQCiPbAtO3J3SFEfA0+sE0nYXFp3hNbkfwzu/dApugr486lGrzQB1ZD3qrVSQfd7+XW0GtlSuvSF406/fOhWEv7dJMfeITIOX9ill+xP6e04XOfv5diG22NdcfmpfoIAdA7azpCT09IFPyHEzZ1FegCoSOWb+1m46Awcany1CeHC8BtyQZonLh30KbrTR9dnflo7//441WmyuoKQhdReKecLWT1rf+Lo+jFC1qi2BEUhPXYb+jdDObFVBa9OU0ebre4b8eer+adQaRazHb25ub/6/ZQAfMCXeT94dtEJtBnm7n5RP5XikEyXCxkx9B23GpwVzmpL8xaDHvQ26nd2GgdaEZK5mlL7kVJQgksWfIXyOklSj9bUBkiClxXpYAuMvJJPbEHoeKRPrJif6tXksWO1IX8nY1qUC3Ct2TcGrb7YDJn6asoj7jCuEKiPEMiGf3MR4072UNcFOAfHllgKdGye15i43tg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(6486002)(66556008)(31686004)(2616005)(6706004)(38100700002)(53546011)(5660300002)(186003)(66946007)(508600001)(956004)(16576012)(4326008)(316002)(36756003)(8936002)(86362001)(8676002)(2906002)(83380400001)(26005)(31696002)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RThTZHZyNlZTSCtXRVFLaUo1dmcrVXY0UEdvR1ozc3htbTEzN2g0OHVLSkRh?=
 =?utf-8?B?Rmp5MG5mY2FYZ2FKWkcyWEVvekhBNnZ4em9YNk9CVGtyR2dZNXkvZGVvWXhG?=
 =?utf-8?B?SVBrS0VhckNwL2tsNmVXd055ZHlJN2xITnJFQlhGcy9LN0Zod3Z5ZEllUGRU?=
 =?utf-8?B?YzgvR0dnQ1RsbC9oZ1JGMTVLUVRFQWhQUUdiZmkvL1h0SHdlWks0K21UQTRF?=
 =?utf-8?B?Y1pqNEJoMG8rVlVmRjFrV1JFdG13MVlLSFpoYmczbGpJMGdVWmhCd2tPM05D?=
 =?utf-8?B?VmhtMU4xZTF1MFZWa0ZxNEx1TUJQdkNSdk9FSk5jWFh3Z25YRVlIMXBuTnZ3?=
 =?utf-8?B?dXpSUHM4VEROb2srZEtkcFBaUUlOcWZ1VGMzK2t1a2tPU3JKRUtDRmxRLzRX?=
 =?utf-8?B?dGN0RHNCUFNMeXJJRUVhRTFwRXpJNzdFMUEyZVRQMzUxUGIrcnQ1cWZFeWYz?=
 =?utf-8?B?Y0owS25KQlVuaEVORXJKeE9JUWY2UEF6K3pJZ0xyeWpTQUkzSTNmeFBJYXpQ?=
 =?utf-8?B?c0tCRXNYT1JJRCswMU9jQ3JESzY2aTVBb2JOQjFOamdPUGoyUnJBaW1qRDRF?=
 =?utf-8?B?V1QvVFkrdkdKR0dBS1pkWWxMbkwzL1paMDRpdGZ2WWUwNHgvWGNNVnFGN3h2?=
 =?utf-8?B?WnJMZ2xYM3dzcXRpRndYYmdZWG5zUEp6dTh5eFBEYjZMNE0zK3I1eGx2MEZI?=
 =?utf-8?B?UWlnTkxDRW5VbzJOTDNoVDJBOWFUQXdvTGdvdzdUbjNaQ0Z4endXNi9BR0s5?=
 =?utf-8?B?cmtzRkFVY252dHhxNGtrWVpSeWVVaHRiNk90TDRWL3pyMit3ZzZEaUZ5Q0Fz?=
 =?utf-8?B?QmZtaVNFMUw1WkRRbDlibTVlbXcydk1hWDdacFc2cElwOGpkL29admtiaEpL?=
 =?utf-8?B?cnBybGdIcXJlaW04Q1pSZG1HeSt3N2VsYjJKcG5TdUpoV05TQzBYL0M1Rkti?=
 =?utf-8?B?U3Q0a1drblJVSG05ZVRXaHF1Q0o2STl3WHNpdU1JSnNza21YWUVtUHRMLzF2?=
 =?utf-8?B?MHFsVW96NnVKMlFzN3RtaGtZdzVMY3ljN3VGTHlteWhDTFFKc1BzdXl1dkR4?=
 =?utf-8?B?NnBmc1A1MXlLakkreDFhRHFibjVjaUQvaERRa21MSkZyNWFzQXByWDJTK1Z5?=
 =?utf-8?B?eXhOcnZjNVlVS0hwRXA0Unl2akEzS3UxM2ppaWhIcktoRkhxeU9tdFNFZytv?=
 =?utf-8?B?M01CZ1NRdjZCQUpXYU00cHd4UHk1dGVmbmhrYm4ya0d2QitPL3lhVTdMcnF0?=
 =?utf-8?B?RkoyRlJLL0ErNTFvY0duNmRRcjR3MTBxcUlXRFg2NmtXeU9GYzlXZ0xlY1dI?=
 =?utf-8?B?QUFzY2VJWG1ZNERxL2JmclI3ZnVTbVZQaUY0aXRhV2F1cEJGWFBYalE5VlBk?=
 =?utf-8?B?bG5hV1FFV1lZNzVGczF2a3BvMFVqZmFpb0Q3dVRZL28vZjlmQkViamNHUFBW?=
 =?utf-8?B?NVRIQThVL2RoUVFWZmJBZ2dmM2ppNUV2d245WHMvOHAvVkV3YVRpazNFaVN1?=
 =?utf-8?B?QmFaTzhXb3JpcVFYNFduck5yRkV4OFNPMWFmalB4K2dneFA2ZDhXN2k4S29k?=
 =?utf-8?B?cDhKWWlIdktiZmRRdk9ZY3YyUlRYOWJrKzR4dGxNdTN2OTJlT2xHYmhxd1Ir?=
 =?utf-8?B?QXFLNEtlTlBWQzZsaitNdWxLS3gxTVpSeGJCbHZhYWRGNFJsN3lmQzNyQWFy?=
 =?utf-8?B?V3E5enlGL0lMU3VUQm1UYXRZUTdsWnQ2dTUyVXhmM2RrRW5LSXVWVlp0ZjZ5?=
 =?utf-8?Q?cq8iFcSlZsQBrn9UsWpc9nxRB+kP7+5uBOv+db9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf8f375f-05c7-402d-5bd0-08d98e740984
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 18:05:27.8044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rFQAu6w16i3HMCfHUVkX2Hrdbjo9K7NYB7qIzb76zESgsWEmv9VlkS45Dtzc2aVzUIdT4pvbheuTp19JylPNReUeUCy643pzJ4qEegC8Nbw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2668
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10136 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110130110
X-Proofpoint-ORIG-GUID: vKRjFnPM0kXxagYka0iOiVgkFIOkVucp
X-Proofpoint-GUID: vKRjFnPM0kXxagYka0iOiVgkFIOkVucp
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 10/13/21 12:51 PM, Mike Christie wrote:
> On 10/13/21 8:21 AM, Konstantin Shelekhin wrote:
>> Hi,
>>
>> I really need the collective wisdom.
>>
>> Not long ago we've uncovered the problem with iSCSI and ABORT TASK
>> handling. Currently it's not possible to abort a WRITE_10 command in
>> TRANSPORT_WRITE_PENDING state, because ABORT TASK  will hang itself in
>> the process:
>>
>>   # dmesg | tail -2
>>   [   83.563505] ABORT_TASK: Found referenced iSCSI task_tag: 3372979269
>>   [   84.593545] Unable to recover from DataOut timeout while in ERL=0, closing iSCSI connection for I_T Nexus <nexus>
>>
>>   # ps aux | awk '$8 ~/D/'
>>   root        32  0.0  0.0      0     0 ?        D    15:19   0:00 [kworker/0:1+events]
>>   root      1187  0.0  0.0      0     0 ?        D    15:20   0:00 [iscsi_ttx]
>>
>>   # cat /proc/32/stack
>>   [<0>] target_put_cmd_and_wait+0x68/0xa0
>>   [<0>] core_tmr_abort_task.cold+0x16b/0x192
>>   [<0>] target_tmr_work+0x9e/0xe0
>>   [<0>] process_one_work+0x1d4/0x370
>>   [<0>] worker_thread+0x48/0x3d0
>>   [<0>] kthread+0x122/0x140
>>   [<0>] ret_from_fork+0x22/0x30
>>
>>   # cat /proc/1187/stack
>>   [<0>] __transport_wait_for_tasks+0xaf/0x100
>>   [<0>] transport_generic_free_cmd+0xe9/0x180
>>   [<0>] iscsit_free_cmd+0x50/0xb0
>>   [<0>] iscsit_close_connection+0x47d/0x8c0
>>   [<0>] iscsit_take_action_for_connection_exit+0x6f/0xf0
>>   [<0>] iscsi_target_tx_thread+0x184/0x200
>>   [<0>] kthread+0x122/0x140
>>   [<0>] ret_from_fork+0x22/0x30
>>
>> What happens:
>>
>>   1. Initiator sends WRITE_10 CDB
>>   2. Target parses the CDB and sends R2T
>>   3. Target starts the Data-Out timer
>>   4. Initiator sends ABORT TASK; no new data from Initiator after this
>>   5. Target starts aborting WRITE_10, gets into core_tmr_abort_task()
>>      and starts waiting for the request completion
>>   6. Nothing happens
>>   7. The Data-Out timers expires, connection teardown starts and gets
>>      stuck waiting for ABORT TASK that waits for WRITE_10
>>
>> The ABORT TASK processing looks roughly like this:
>>
>>   iscsi_rx_opcode
>>     iscsi_handle_task_mgt_cmd
>>       iscsi_tmr_abort_task
>>       transport_generic_handle_tmr
>>         if (tmr_cmd->transport_state & CMD_T_ABORTED)
>>           target_handle_abort
>>         else
>>           target_tmr_work
>>             if (tmr_cmd->transport_state & CMD_T_ABORTED)
>>               target_handle_abort
>>             else
>>               core_tmr_abort_task
>>                 ret = __target_check_io_state
>>                   if (write_cmd->transport_state & CMD_T_STOP)
>>                     return -1
>>                   write_cmd->transport_state |= CMD_T_ABORTED
>>                   return 0
>>                 if (!ret)
>>                   list_move_tail(&write_cmd->state_list, &aborted)
>>                   target_put_cmd_and_wait(&write_cmd)
>>
>> As I see it, the main problem is that the abort path can't initiate the
>> command termination, it simply waits for the request to handle this on
>> the execution path like in target_execute_cmd():
>>
>>   target_execute_cmd
>>     target_cmd_interrupted
>>       INIT_WORK(&cmd->work, target_abort_work)
>>
>> However, in this case the request is not going to be executed because
>> Initiator will not send the Data-Out buffer.
>>
>> I have a couple of ideas on how to fix this, but they all look kinda
>> ugly. The one that currently works around this for me:
>>
>>   core_tmr_abort_task():
>>
>>     [...]
>>
>>     spin_lock_irqsave(&se_cmd->t_state_lock, flags);
>>     write_pending = se_cmd->t_state == TRANSPORT_WRITE_PENDING;
>>     spin_unlock_irqrestore(&se_cmd->t_state_lock, flags);
>>     
>>     if (write_pending && se_cmd->se_tfo->abort_write_pending)
>>             se_cmd->se_tfo->abort_write_pending(se_cmd);
>>     
>>     target_put_cmd_and_wait(se_cmd);
>>
>>     [...]
>>
>> The new method abort_write_pending() is defined only for iSCSI and calls
>> target_handle_abort(). However, this opens up another can of worms
>> because this code heavily races with R2T sending and requires a couple
>> of checks to "work most of the time". Not ideal, by far.
>>
>> I can make this one better by introducing R2T list draining that ensures
>> the proper order during cleanup, but maybe there is a much easier way
>> that I'm not seeing here.
> 
> Ccing Maurizio to make sure I don't add his original bug back.
> 
> If I understand you, I think I added this bug in:
> 
> commit f36199355c64a39fe82cfddc7623d827c7e050da
> Author: Mike Christie <michael.christie@oracle.com>
> Date:   Fri Nov 13 19:46:18 2020 -0600
> 
>     scsi: target: iscsi: Fix cmd abort fabric stop race
> 
> With that patch if the abort or a lun reset has got to lio core then we
> are going to be stuck waiting for the data which won't come because we
> killed the iscsi threads.
> 
> Can go back to always having the iscsi target clean up the cmd, but if
> LIO has started to abort the cmd we take an extra ref so we don't free
> the cmd from under each other.
> 
> This patch is completely untested:
> 
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 2c54c5d8412d..d221e9be7468 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -4090,12 +4090,13 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
>  			spin_lock_irq(&se_cmd->t_state_lock);
>  			if (se_cmd->transport_state & CMD_T_ABORTED) {
>  				/*
> -				 * LIO's abort path owns the cleanup for this,
> -				 * so put it back on the list and let
> -				 * aborted_task handle it.
> +				 * The LIO TMR handler owns the cmd but if
> +				 * we were waiting for data from the initiator
> +				 * then we need to internally cleanup to be
> +				 * able to complete it. Get an extra ref so
> +				 * we don't free the cmd from under LIO core.
>  				 */
> -				list_move_tail(&cmd->i_conn_node,
> -					       &conn->conn_cmd_list);
> +				target_get_sess_cmd(se_cmd, false);
>  			} else {
>  				se_cmd->transport_state |= CMD_T_FABRIC_STOP;
>  			}
> 

Another alternative would be to have iscsi check if it was waiting on
data before sending a TMR to LIO core. If it is, then it would just cleanup
internally and complete the TMR with success/failed depending on the TMR or
drop it and let the initiator escalate.
