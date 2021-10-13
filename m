Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E23DC433EF
	for <target-devel@archiver.kernel.org>; Wed, 13 Oct 2021 18:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42207610E8
	for <target-devel@archiver.kernel.org>; Wed, 13 Oct 2021 18:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbhJMS0q (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 13 Oct 2021 14:26:46 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:33612 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229814AbhJMS0p (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 13 Oct 2021 14:26:45 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19DI1MOH021011;
        Wed, 13 Oct 2021 18:24:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=XEaPs/HnQltTwI207Q0eXRViMCKjmjcNhTkapdLijno=;
 b=HoqIujyvkVhpMQ893A8ki1CoFUlgngK4V6bYD60O7s/CwtqxeJ858Jc0Z7I9yLzk2Y+k
 RJd5pQFjC6miWaKChHcpRrq6SnN+4P9U56kWBfDZImNr+dW8qSlA0nLH3225shkCs2ri
 H2nJs8uL2Iif+BctHZM2UNaBTt3VxhDrZZ3NSikYS+sDTJgU6cWmhEyCFP7E6yyrZ3Q0
 OZc/3ETO+o9e9RmcHCXihouoF/VqUiQne15Sibn9VzUj4nT5zlPCWigw0CAfPcpXdL31
 ZXwnKVk6t+Z3vcXN13s+9h/c60q1dASdVyO7rO5CCLvj5xJhEXb66WvaibbBuJB0/WPK GQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bnkbkdpr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 18:24:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19DIFAnf042599;
        Wed, 13 Oct 2021 18:24:37 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2043.outbound.protection.outlook.com [104.47.74.43])
        by userp3030.oracle.com with ESMTP id 3bkyvb9124-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 18:24:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N1mHN3KiD57pM424+FkY8tgN3abNRENo2h1e6HdGBWpIp5u0YgMEN/YNlMyy6TbNj5OMTY6nPZ7SCLDkKa5lYhJPfrwged05yMTVuDEOL7rFy/cWHUvRpnape+RhwuXQihy1LXW+njqi07eE4nux9ba+QbYauYL6/CojyjGOyiLeNZLC4ZgW8x0wKkE5lWmL8v5u6uMzwSih0Udc1XT632hXTFlOhTEUvKFx6r6qbfvX/FjzsYXj3L+hjSmnhIwdVCwIDWaGEs9R4mCoComtw82o2GoREsAGg57LKm9AunypoZ+uFi9iutbvnsZw6D/bVFd1DNHu7BBNeUqYssSaIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XEaPs/HnQltTwI207Q0eXRViMCKjmjcNhTkapdLijno=;
 b=md8DT9h5q7Y6PFTHTrd87/jrmd4hw3hQh/mQ1TIMhswYRIhPNY5P8i2zINkbxJvTdJO2XwKo7TBx35ABbIkoEcQiIhVt3MvGMND3gxw9KSc44QIGkVgG3aOamLFOjEmxIxqGQbqBz8meMOaONwXZSXwQeBwcO1mOtUKTz9U+Oy4mGRpxmVxQDhIFmCTNq/MtSZXlSatV709M+QA6X4qptFNPSvG6oiWvYqCjuEpRTFXFq3QhsbrsngoK4Ckarz2zNQqhhgQCSZIVSJkU1JdVGJqWBgFKFIwUGgxb3p4TPwYgOVhUxc5uJ1z7HLM2dwmWZ/yadN9A5nz9EeZH+KLE6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEaPs/HnQltTwI207Q0eXRViMCKjmjcNhTkapdLijno=;
 b=owkdNw2knnk+PhwuGaK52lmu98qBeR7HlGrzrEOa+Ln0RjNi1Mo98A/1Sgcbrh3+sWEsP/OB03Bl80ODu+d7ACx7I8aXWykxAgNxsdcRmP8nQinfW43OuZ96ne7WenPqvg7oBUaDANbXLfZdGg6L0sxa1PF3wEDbn9NlSOnWOWs=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2587.namprd10.prod.outlook.com (2603:10b6:5:b1::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.20; Wed, 13 Oct 2021 18:24:35 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4587.030; Wed, 13 Oct 2021
 18:24:35 +0000
Message-ID: <2e83aa6a-2746-8914-f295-30eea8954814@oracle.com>
Date:   Wed, 13 Oct 2021 13:24:34 -0500
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
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <YWcggfDyrHU1VhKN@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR10CA0034.namprd10.prod.outlook.com
 (2603:10b6:5:60::47) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DM6PR10CA0034.namprd10.prod.outlook.com (2603:10b6:5:60::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 18:24:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc1be20e-370c-4b7a-11ef-08d98e76b575
X-MS-TrafficTypeDiagnostic: DM6PR10MB2587:
X-Microsoft-Antispam-PRVS: <DM6PR10MB2587ECD6D34A9DAC7570047AF1B79@DM6PR10MB2587.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:76;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GQY/1rsYBk0bmSt28G+aS0cNlvx/Cc9CopCQ0pSX7zohY5B/4LbwtBV+uRs6pI3Hbg8jAGSB6lNmxMi1tVlLmTIRf9PDSZC9pVt6ZgG31aCUMWAopmkIO8L7/qQHvmEzK5lk5hxkRCWgZJDDF2TGMxm8a8vuXlZTaD4ro9KeOrE5XP21RYEuHZzZW6GC6lYLvSX32NIccnbxGToPl7KSACNwrAtVNfkm8Fk0TK/Jyk5uBqB9PqubtHkLl8Cqs6Q7EQQtPeldcffMVFJoTCTJXadM+0rZYJoNrc55amJI1W3FwHzte7J+NLHZdOyCLBArAf7iKf2iAmv93m0svFvlPTn1SxL82n9gX1qDOROZ97fbSYOfCcTTGKJOs/rUAqzIR/PU9q2SDBnoQqhveKKOPzQzirudvYvIRkmA/fnb/6XiM6XiiCibDRjxt28WlPCZQnn+oY76Um5Lh4bpJL9gK6LIWG9P3g02U66Kx9CitUSU7TUp49N3rYzaoOVU+gjpcUKtl0GhNIci8GB8ghJzKLEsq3zwv+0crICbEIUg3sLG/rbFp+RMAYoqWHPXyF8f3BU5yJPFACq/Vn9G3HWI+NwPbXJU98p0Hhm06k0udOedzeyxf9qh8ypkCG4rS61r4J2D/IpAm6RMG2lH6OAarkWmXq01ncPxByq1uKw9Fvx9gM0IG6H9fTykoPzoq2lBGHvDbrrQei2xlckZVQKkYKjvJVcsLl9jFEDWzLhQ/mcTJdpbvoT1r8znxfUFwD231OlQFewlqoRCk8dhexuV+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(316002)(36756003)(6486002)(83380400001)(8936002)(2906002)(53546011)(8676002)(16576012)(2616005)(31696002)(26005)(6706004)(86362001)(4326008)(508600001)(956004)(5660300002)(66476007)(31686004)(6916009)(66946007)(66556008)(38100700002)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L0M2UUdyYVIyalY1clZCdG8wNXlCaTE0alFpaFhUN0xmdFVKUUE3Q041L1BR?=
 =?utf-8?B?b1M2V2ltZDhETmN2WWlGQnNMM1Y5byt2aC9TekFlZ1p6VFRhVmdQMnZVclBD?=
 =?utf-8?B?ayt2YXp4S2xCd2t6TXE0NkhZa2k1Q0xtb3dtR2ozM3gxSm52MXltMlFTY25p?=
 =?utf-8?B?NytxQXR0akM3eVoreW15SS9YVzlubFlsSzFad3AvWTU1cmFuc1pYRmprUUFn?=
 =?utf-8?B?akptSkxQQ0NiOW9XK08rMEhHemRqUlh6ekRxLy9ad2JmVnN5MDEzTmk5WmR0?=
 =?utf-8?B?OVJ1MzQwNHJJU2RlQTV0NjVsSHJJeCtjUWhOUzJNWGZ3dkgvMCt1WVpEQ2xU?=
 =?utf-8?B?a2pwclVaYlNBemdJZk15NWR6U2ZwcEFBckFwaXArVHoxVDdlRUFFcjh3aW44?=
 =?utf-8?B?bzhuMU03cGI3Vmh0U052N2YwWlRlYlhzcE80bGdRWDlJbFdwT1k2b2RSVm5u?=
 =?utf-8?B?VStOaVdabkNkN2VabkIrWkZ5M3g0Um1FYkI5SUxKZHcxS2ZiZHJ0djBqWkk2?=
 =?utf-8?B?RDBCK1ZOclVyNnN4andMYUx1ZTJndTJ4dnBJcUlpeGtTR21zREJ5dHhMTStK?=
 =?utf-8?B?bVpaN0lHY0dPZ3VQVnQ5di9ndy9kYkxUUmpBTGQ4QStvY3pyek5oaHZPMTFh?=
 =?utf-8?B?dFRxOVc1dkVIdWV6NjJTRTdXenFBMFBTK3dKR0hFT0FBSkphVmtKbGw0eGI2?=
 =?utf-8?B?dXc5S3RzUVZxNjhrbE5Vc3hsQlFwdjh0czV6Z2E0b21ySHNhdmNWTW9Tb0lO?=
 =?utf-8?B?ZktlUEptZ0QyR0IwL05VaWQzUVFwYmwxdUxodm96R082UXJCY0pJWjAyTWM0?=
 =?utf-8?B?SC9FY0s5WkpEcFYwQmtYR3JJTVFwN2VUVWJiYjBXbWFIazBaM1E1bUgxTGgy?=
 =?utf-8?B?Sk8zZWlweUZWOCt6Z3FkUWtJYm41dmlkVTBPZE1uWDUyUHhDYXp4QjkrYmpa?=
 =?utf-8?B?SnVyMU5UeG1IY0RsUFdaWDFrNC9RSWhMYVRtYkMzVWlGQkJJZmx4YkpmNGQr?=
 =?utf-8?B?Ympmc2U4Y21BdHZmUGxud2MranNPSllXekpETWZ2dHQ4WVgyL29ad3Q1dkVB?=
 =?utf-8?B?eGttaStBR2huV3E3TnZBMG5UdHM2OVFZM3lpOVFxMmQ0S29vcjZ1NE8zdDd4?=
 =?utf-8?B?Q2dPdnQzVXV4Z0RsdWVsb0hZdXcySEg0b3JQNXFNWlZ0SWZkMlg3MzJLNGRF?=
 =?utf-8?B?Z2VHYVlwRWRZVkFxZ3phajBmTnRXYzAwSUhJbHg2OTZKa3Baa1p6UVdwL2Qw?=
 =?utf-8?B?dmZ2dWJDb1U2TUxmNXF4Q1ZJOVBreU02TTJwUGFtbkRWQWpxdFVXQ0piaWh5?=
 =?utf-8?B?Mit6Z2o3MnpWWU1RSElBZ3N3SWhKc2k3anRBVnBtY2xyRGZtT2FQZTkvZmE0?=
 =?utf-8?B?K2NubEhZbStsdnZhYmNNajRtRjJJdFpJZEwzOERxN3p6Y3BuYjhkWTJRYVVh?=
 =?utf-8?B?OXNrK1Rnbi9YeUR3NkNOdDFqSHB0b2l3WnVmclpDSm9aa0Uzd0gvaTVOSEQ4?=
 =?utf-8?B?Q3NQZ2loaXIycUczZWY0d0lFWXJyd2RJUGxkNUFQMWp2REMzc1gvM0lIdDky?=
 =?utf-8?B?aVlpWVdrRjlyQ01hZ1A3MUNEYzdtTTBsVlo3VEEwM05xTDF5eHI1R0ZiUHhG?=
 =?utf-8?B?QVNEOWNqTmx1V3NSbFlTWldHaFpTV1ZTRHNXQWdmcWR6bXFySXdHWHJoTTFv?=
 =?utf-8?B?TXdjZExNY2xaOFBHRHlFcEs5MlE2eUxmNDREVjliQzV3RFhMVy9STGV1YlpP?=
 =?utf-8?Q?KWoTwkLNUgYPWCywMKQU+uzAZk6dgGJfsE5rtCb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc1be20e-370c-4b7a-11ef-08d98e76b575
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 18:24:35.2848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gxKP0QnodfJIRjz3+MINR5O+bUvrk7GAs/pdLofTE8cY5J+4WOiCjgwbiHeKtwblVh8mL3hkBjBq6MOPKuDxoJf7eLPinqdj5eYVXEXUnr0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2587
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10136 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110130112
X-Proofpoint-GUID: 2OXYeOG8nr_4-GxdVcnb6y7fv2XPJrb3
X-Proofpoint-ORIG-GUID: 2OXYeOG8nr_4-GxdVcnb6y7fv2XPJrb3
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 10/13/21 1:08 PM, Konstantin Shelekhin wrote:
> On Wed, Oct 13, 2021 at 12:51:32PM -0500, Mike Christie wrote:
>> On 10/13/21 8:21 AM, Konstantin Shelekhin wrote:
>>> Hi,
>>>
>>> I really need the collective wisdom.
>>>
>>> Not long ago we've uncovered the problem with iSCSI and ABORT TASK
>>> handling. Currently it's not possible to abort a WRITE_10 command in
>>> TRANSPORT_WRITE_PENDING state, because ABORT TASK  will hang itself in
>>> the process:
>>>
>>>   # dmesg | tail -2
>>>   [   83.563505] ABORT_TASK: Found referenced iSCSI task_tag: 3372979269
>>>   [   84.593545] Unable to recover from DataOut timeout while in ERL=0, closing iSCSI connection for I_T Nexus <nexus>
>>>
>>>   # ps aux | awk '$8 ~/D/'
>>>   root        32  0.0  0.0      0     0 ?        D    15:19   0:00 [kworker/0:1+events]
>>>   root      1187  0.0  0.0      0     0 ?        D    15:20   0:00 [iscsi_ttx]
>>>
>>>   # cat /proc/32/stack
>>>   [<0>] target_put_cmd_and_wait+0x68/0xa0
>>>   [<0>] core_tmr_abort_task.cold+0x16b/0x192
>>>   [<0>] target_tmr_work+0x9e/0xe0
>>>   [<0>] process_one_work+0x1d4/0x370
>>>   [<0>] worker_thread+0x48/0x3d0
>>>   [<0>] kthread+0x122/0x140
>>>   [<0>] ret_from_fork+0x22/0x30
>>>
>>>   # cat /proc/1187/stack
>>>   [<0>] __transport_wait_for_tasks+0xaf/0x100
>>>   [<0>] transport_generic_free_cmd+0xe9/0x180
>>>   [<0>] iscsit_free_cmd+0x50/0xb0
>>>   [<0>] iscsit_close_connection+0x47d/0x8c0
>>>   [<0>] iscsit_take_action_for_connection_exit+0x6f/0xf0
>>>   [<0>] iscsi_target_tx_thread+0x184/0x200
>>>   [<0>] kthread+0x122/0x140
>>>   [<0>] ret_from_fork+0x22/0x30
>>>
>>> What happens:
>>>
>>>   1. Initiator sends WRITE_10 CDB
>>>   2. Target parses the CDB and sends R2T
>>>   3. Target starts the Data-Out timer
>>>   4. Initiator sends ABORT TASK; no new data from Initiator after this
>>>   5. Target starts aborting WRITE_10, gets into core_tmr_abort_task()
>>>      and starts waiting for the request completion
>>>   6. Nothing happens
>>>   7. The Data-Out timers expires, connection teardown starts and gets
>>>      stuck waiting for ABORT TASK that waits for WRITE_10
>>>
>>> The ABORT TASK processing looks roughly like this:
>>>
>>>   iscsi_rx_opcode
>>>     iscsi_handle_task_mgt_cmd
>>>       iscsi_tmr_abort_task
>>>       transport_generic_handle_tmr
>>>         if (tmr_cmd->transport_state & CMD_T_ABORTED)
>>>           target_handle_abort
>>>         else
>>>           target_tmr_work
>>>             if (tmr_cmd->transport_state & CMD_T_ABORTED)
>>>               target_handle_abort
>>>             else
>>>               core_tmr_abort_task
>>>                 ret = __target_check_io_state
>>>                   if (write_cmd->transport_state & CMD_T_STOP)
>>>                     return -1
>>>                   write_cmd->transport_state |= CMD_T_ABORTED
>>>                   return 0
>>>                 if (!ret)
>>>                   list_move_tail(&write_cmd->state_list, &aborted)
>>>                   target_put_cmd_and_wait(&write_cmd)
>>>
>>> As I see it, the main problem is that the abort path can't initiate the
>>> command termination, it simply waits for the request to handle this on
>>> the execution path like in target_execute_cmd():
>>>
>>>   target_execute_cmd
>>>     target_cmd_interrupted
>>>       INIT_WORK(&cmd->work, target_abort_work)
>>>
>>> However, in this case the request is not going to be executed because
>>> Initiator will not send the Data-Out buffer.
>>>
>>> I have a couple of ideas on how to fix this, but they all look kinda
>>> ugly. The one that currently works around this for me:
>>>
>>>   core_tmr_abort_task():
>>>
>>>     [...]
>>>
>>>     spin_lock_irqsave(&se_cmd->t_state_lock, flags);
>>>     write_pending = se_cmd->t_state == TRANSPORT_WRITE_PENDING;
>>>     spin_unlock_irqrestore(&se_cmd->t_state_lock, flags);
>>>     
>>>     if (write_pending && se_cmd->se_tfo->abort_write_pending)
>>>             se_cmd->se_tfo->abort_write_pending(se_cmd);
>>>     
>>>     target_put_cmd_and_wait(se_cmd);
>>>
>>>     [...]
>>>
>>> The new method abort_write_pending() is defined only for iSCSI and calls
>>> target_handle_abort(). However, this opens up another can of worms
>>> because this code heavily races with R2T sending and requires a couple
>>> of checks to "work most of the time". Not ideal, by far.
>>>
>>> I can make this one better by introducing R2T list draining that ensures
>>> the proper order during cleanup, but maybe there is a much easier way
>>> that I'm not seeing here.
>>
>> Ccing Maurizio to make sure I don't add his original bug back.
>>
>> If I understand you, I think I added this bug in:
>>
>> commit f36199355c64a39fe82cfddc7623d827c7e050da
>> Author: Mike Christie <michael.christie@oracle.com>
>> Date:   Fri Nov 13 19:46:18 2020 -0600
>>
>>     scsi: target: iscsi: Fix cmd abort fabric stop race
>>
>> With that patch if the abort or a lun reset has got to lio core then we
>> are going to be stuck waiting for the data which won't come because we
>> killed the iscsi threads.
>>
>> Can go back to always having the iscsi target clean up the cmd, but if
>> LIO has started to abort the cmd we take an extra ref so we don't free
>> the cmd from under each other.
>>
>> This patch is completely untested:
>>
>>
>> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
>> index 2c54c5d8412d..d221e9be7468 100644
>> --- a/drivers/target/iscsi/iscsi_target.c
>> +++ b/drivers/target/iscsi/iscsi_target.c
>> @@ -4090,12 +4090,13 @@ static void 	(struct iscsi_conn *conn)
>>  			spin_lock_irq(&se_cmd->t_state_lock);
>>  			if (se_cmd->transport_state & CMD_T_ABORTED) {
>>  				/*
>> -				 * LIO's abort path owns the cleanup for this,
>> -				 * so put it back on the list and let
>> -				 * aborted_task handle it.
>> +				 * The LIO TMR handler owns the cmd but if
>> +				 * we were waiting for data from the initiator
>> +				 * then we need to internally cleanup to be
>> +				 * able to complete it. Get an extra ref so
>> +				 * we don't free the cmd from under LIO core.
>>  				 */
>> -				list_move_tail(&cmd->i_conn_node,
>> -					       &conn->conn_cmd_list);
>> +				target_get_sess_cmd(se_cmd, false);
>>  			} else {
>>  				se_cmd->transport_state |= CMD_T_FABRIC_STOP;
>>  			}
> 
> The bug was there before. I had to backport this patch in order to
> introduce my fix. I can revert it and check what is different, but it's
> there in some form.
> 

Don't waste your time. It's because iscsit_free_cmd's call to
transport_generic_free_cmd has wait_for_tasks=true.

We then do transport_generic_free_cmd -> target_wait_free_cmd ->
__transport_wait_for_tasks like you posted above.

We need to be able to do the wake up instead of wait for
this case.


