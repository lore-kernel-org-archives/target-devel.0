Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08F25C433F5
	for <target-devel@archiver.kernel.org>; Mon, 18 Oct 2021 20:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DADA760F9E
	for <target-devel@archiver.kernel.org>; Mon, 18 Oct 2021 20:20:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbhJRUW7 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 18 Oct 2021 16:22:59 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:26690 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229941AbhJRUW7 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 18 Oct 2021 16:22:59 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19IJQWj3015253;
        Mon, 18 Oct 2021 20:20:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=PRRHS4Qv462A8K2eHMSsZTSAhsM1qBAEqK7tn1bCyG4=;
 b=y/FPbzuXzv+uOe9uZyE683bkTm8CQPwtAbbA0WSc2HCz2t96DB6E4bzXYuGYf5ziWZWJ
 4Pdy+5VmR+te9jUD6wiI/QKGoB4rCoTGAeb217lSUoxkwpNezgkNUBUGr6xQnpCygLKU
 zL2SYadLHiBgzCD5BEFIgTeFLEmhlEwPwEojzrMgtQQQ7P5uPP+YLogMYmVdorle0TJ5
 hbQ9bhhVwYlaOGAJCR8LKOVA2jGftE+dWAbDao7jV60qhP4pJR98kRyQnjEdt9TStOJY
 a4MPmf47auJ5ToVWFXYSwDFsKJOSWJdm8X8XnOxhKf8Y8kuAw340hOSWzYbEX3AcZZEo Yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3brnfhpndq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 20:20:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19IK1Jrw060790;
        Mon, 18 Oct 2021 20:20:44 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by aserp3020.oracle.com with ESMTP id 3bqpj4ayr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 20:20:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AINrgxA5cc0COaSNmRVgeWbEx/9QVjKvsKe5bOKYXMA8dmX7vMzHBxVUmBO3IwfFYu7PSBzZC5i/32r25Up/+dldpidiG81T2ykEOm/hsltfVuLRQXlQr/TbqtjN0yg2/ubs+6zU/+4/1QTD3HMbzmgyscoczauBehL3O91yzKgnTBHTW4S+DJ4rTBDfp4FVoGIWPcQ5ItBTYgmTSFDHbFAV1CrG1icdlE9G25elCy5SqdC4l95sP5hPpBbC4Aab7QiLcr4ERViwHd5vPwkuOTm6079x6QEqPZXH79vnMtkC9MGns3E5O1lpepFc+ewYW8+k5wHcmpFo+gmoToG5DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PRRHS4Qv462A8K2eHMSsZTSAhsM1qBAEqK7tn1bCyG4=;
 b=dX6y8Eyca0AdSJrU+pCdqWRawFqOcjv7SoqqKH/biofdIl1QssryuJU3+AI35qylhscSkJcOwNTm6IF6Yo+nl8QvjKxqkYHMbqzGRngK+3EONiYD8I6psdoH6eDYRD/T9Ux1JkIVVly6stcpxiXjlbbBIvTP0EieDn19mvGe+fTx6jV0NPSGYtFpFb0O8V74GbWD3X1CMGotSFsBh2gUPXmYbSV74gfJ900bpR8cHQwJoOuFvUSJthr732yCFvg17GMmJn7wbZEDquVS/CfxMbPODKBCrtbXb5HStei8AmuVYEgJODOGaLC0h3KJQGpCC19hjcmg353jRjPAnpiCcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PRRHS4Qv462A8K2eHMSsZTSAhsM1qBAEqK7tn1bCyG4=;
 b=nOHYmLDx+o0wx/KFjAXH9/Qr4Mwr95gRB2Sb/qF9UiyFgvUxgJXuA8LTY4PjqNgHqr1oVMvCZfQp3VSdtJ7woGFrNzlHTrG3kwdbQeR7l9vCAeiLj2szLZYfaMguxINVkb1qls4bg/jrTpbpihniwN1Tfhv51YM5JWQHDkrLxdE=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2953.namprd10.prod.outlook.com (2603:10b6:5:6a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.18; Mon, 18 Oct 2021 20:20:42 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 20:20:42 +0000
Message-ID: <5731ecf9-f99f-f397-aad1-fe8b142c2748@oracle.com>
Date:   Mon, 18 Oct 2021 15:20:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: iSCSI Abort Task and WRITE PENDING
Content-Language: en-US
To:     Konstantin Shelekhin <k.shelekhin@yadro.com>
Cc:     target-devel@vger.kernel.org, linux@yadro.com,
        Maurizio Lombardi <mlombard@redhat.com>
References: <YWcggfDyrHU1VhKN@yadro.com>
 <2e83aa6a-2746-8914-f295-30eea8954814@oracle.com>
 <6059cfab-5cbb-984b-7efc-eb193bddea7a@oracle.com>
 <YWcsWKIn5RyN+UbD@yadro.com> <YWcs/8CQYn7C7G9T@yadro.com>
 <e76e1a95-dc88-ac9a-62b0-89533182aafd@oracle.com>
 <YWi5YumbN/Zzze5h@yadro.com>
 <d5035453-f35f-0ecf-d830-18c6b3040c97@oracle.com>
 <YW1g/OFXMHq44CYo@yadro.com>
 <2318e7d3-84c1-e5b0-62ce-dd25a21d3476@oracle.com>
 <YW2vvr8CpBzRPRNP@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <YW2vvr8CpBzRPRNP@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0156.namprd03.prod.outlook.com
 (2603:10b6:5:3b2::11) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DS7PR03CA0156.namprd03.prod.outlook.com (2603:10b6:5:3b2::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Mon, 18 Oct 2021 20:20:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12b2418c-7d58-4678-b09f-08d99274c265
X-MS-TrafficTypeDiagnostic: DM6PR10MB2953:
X-Microsoft-Antispam-PRVS: <DM6PR10MB2953FD73ADCA38BAD9A2057BF1BC9@DM6PR10MB2953.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9i5KjX11vR5yx9hbHqYjVVaO2/VlTb6p1TYDVsJFixRzNGDP7Ot/hNt18hhjyDcrZ7mXbGPfCYYzulOin0ffJC8rOotXoNBsBzk8svj4pYtjArR1+f6n17R/1NJptayVtQw+ue6E/r1bXPbDvzuwVKB+Yy+leqkQ7s6UdnbrjlgkEPUoNZ8OTx9H0WIPGM+2yXMiWgF6b92apbdSq+YNV2bBMJPSJgRvGlYUxIskrUREC3gRUPJZyp0DuKcDW7K7JtnCICslp8E0CEbtvocF0XtY/L9N5NLVxfuucXTKnuLLOsLsbZNIV0TlXZwSqajKSym8y3AqkSFd0x8j/8bPnmzFzRqxJZ6AKlxm7gdTYheud0pElIRVX1V5bZ94EST4gbWhnkX10LAdYUTN4EwtE8fyYwjbMztIm+3XOV/x5F0BNicQ0j4mVicGJIQ8K0uO3fvinmmHxnCJaW2UVTiKRHX2xld+nz4UU7tRAknfPupABdK8C1wTuHCcihs2NoHatHgz+/fKU10+RKLb5CLidKAWq8pG3EO2qoDrAxRFi35iFtTvn6r06qO740fpvTdN1grIiz0EU5zsvaFmlkfm/WhitKpGq9I18UgSkelu9UTBbBSDAvWUt4yoC/m0RjCSjpR3BHWzkvOmhScgcpGgyhcUJh3vRFzp8e6nNyP8r+b3SELeqmG9i3/clZzucfUjN5OSVOnwEDtXGm6z8lGc0DDc5LS/iUZ9g2FWAGdeXvegZWBqJlF30RAXYIgetnkp4DkrvIhY5sZeYmJCmZcxTaMJKkZo3HkeK4y/5iIy3P+wdA0Qa2N8/b4p55BrlmbgH9zfLm5tNO4VKHhdKX6J+yk4+IGydXZgObk3dOzqjWR1rHoetYBX0TTwG55gO8nh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(6916009)(966005)(508600001)(2616005)(31696002)(8936002)(6486002)(86362001)(31686004)(6706004)(2906002)(53546011)(4326008)(66946007)(16576012)(66556008)(5660300002)(38100700002)(36756003)(316002)(66476007)(186003)(83380400001)(8676002)(956004)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZElVSzhITHNJcjFlbnJBQU91SnpyVXlMODNoSDVGWDJLQkcyVy9ZRWI3QWo2?=
 =?utf-8?B?YmU5L1czS1ZyQmhwcTExM3N0UUNJWkM4OGptOUNHemxTMi8vMFZVZmpuaWN4?=
 =?utf-8?B?YXo3cmJYUmFMV05kRHg1WnI3NE5yenVBcDlMOEtQVHNMOHNxVWwydkVPQ0VL?=
 =?utf-8?B?NEY0djk3alhtRjBZNmkvcWNhZGg5SzVXRzJ0ZGR6ZUMra2JCTDc1dG9mMkxY?=
 =?utf-8?B?UUk2bGN3R01DaXdLK0VycU1ZUkJnQkVselJycVViaU9adE9XRU0wSkpaZTBl?=
 =?utf-8?B?eWdVODdVaHVaa2pZaWtOR1Qvb2J0S2N0RnJNaUtKZGtBQ3kwNG1hWjJCK252?=
 =?utf-8?B?VUVRVlVNTDF4SXNmbHhoa2NyM29IUmw5dmV5dDdVTnJaNGY4N2k3L2dLMGVk?=
 =?utf-8?B?V2pHNGlLL2RCSlk5ZmVUK1dqdWs0MWhqdXFqM3NlR0ZSSHdPUW5tTVBqRUMw?=
 =?utf-8?B?eWNkajJpSEtVczB0VCtXVlgrUE9ZRWppZlRtd081a1B6U0NrcUxKT0ZzTThF?=
 =?utf-8?B?dzJyTEZlMUkvZW9OL1NsRDlsTCswbDYveTU1Z0c1eWIrRWlGays3Y3JVUDNY?=
 =?utf-8?B?ZjRKSGEwRmt2ck5rTnljZ0FQalg0eG1GUXVFaUw0RTZ6dmhhaEdic25tTWE1?=
 =?utf-8?B?YXk0aXAwSitON1FPR1pqMS80YVZMT0QrQytHYmdHZ0R1clFyUmN4d3k2NXpB?=
 =?utf-8?B?MWpYL1ZIaVQ5OHE3QVBYdytualo1WmdRL1FBUEhRUkpqMlI0bEZ6ejdrL0Z5?=
 =?utf-8?B?aXh4ZTFheDRQQVl3bmxiYWlpRUJGZ3I0dkhhS3BpeXc1TythTVhwNUtsZng2?=
 =?utf-8?B?eER0aHEycDJYSWw4ODRBVXNTa2ovdzcyaFMvTDlTT1dLSmExVXN3TXExSU1M?=
 =?utf-8?B?OUhlTmZIbTAzazlrOGpaUW1TdXFpNHA3S2xhb3N1OTU4d1NDYUNhaXpFTGt0?=
 =?utf-8?B?T0hzemY3czlzaXVYbml2SjNoUFQ3SDkwUDRjRmpFWHhxUVlGN0QvamVFSzN4?=
 =?utf-8?B?eldSWFA3RnJ1YUJoVThTZ2FFNzV0dkZzTjBwNWI0eW5TWlUrQkFGSzE1NkJZ?=
 =?utf-8?B?ZWN4RGpTWjZ1R05rc3FacjVkR0FtOHFOQUhmTlY5UWJlSHUwYm1HMzVOcGEw?=
 =?utf-8?B?R0RpMno1M0FIQUpKNExSa01hVTZhODZJWFdJTkU3YmhQQmlzNXlUNUlLalVs?=
 =?utf-8?B?REpjZDQxcEh6MStKa0lJbDlhMC9WNDhMVXUvcUJBM1pDYnpPTTJhT2lnYy9B?=
 =?utf-8?B?ckIzZXEyUzEvVHJpempxU04xallsYVJiYVJFSG8xRDYwaCt5cXhLdEVtc05U?=
 =?utf-8?B?UXRzaURvK0ZMQ1E5dm1FeEdvNWI5VWs4dnlWR3RJdC9MZHdyZXBHZXB4M09V?=
 =?utf-8?B?dDdaNjRoYTBRQ1BNbzdKMC9aaFYvN3NLTFNNMTgvdzVrZkgyVFlLaXZMWnlV?=
 =?utf-8?B?RlFWN1pkald6a0ZYNUF4V21MTy9GaFpvUmhSYlA4bmdqd09DM1d5U2VNRS9U?=
 =?utf-8?B?M1RsM1BJVGdhbjF5Wit3M3daNDV4cDgwYXF6YUJITkwwRFFJQjBJTzJnNld4?=
 =?utf-8?B?VW9rWlR1eUVDSHZtWjNUOWlBazMzTWVrOGFoSDRYdlY4Z28wNFZvMmwxZVUw?=
 =?utf-8?B?VktzY2QvbXVVeDRwS0J6WnEvNnhKNk5GdjEzRWFDdHYrY0lxb25nTW53VjdN?=
 =?utf-8?B?eFp6UFZlQ2h5cUtIQjZDb2pmdnlVMEtxbFZqRjFEenFpMnlvcEpJTG5Rb2dD?=
 =?utf-8?Q?wYMpdCO8XLgBYBKLZWWGHmgHjru6IPggJ1297Vs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12b2418c-7d58-4678-b09f-08d99274c265
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 20:20:42.6620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F32jVc0Nia8iH7GjTpNi2ClRqB4ESVbSiB0IvKeoZiHsTI3N6Z6tVtOXkxViPeVb/g4OSJvy1J5rp5t70H5PMLY/62moSMEMrsP9XGon+6w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2953
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10141 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110180110
X-Proofpoint-ORIG-GUID: eVe4SS7AfBJGRFzsIjcqgBkwzFWbVTK5
X-Proofpoint-GUID: eVe4SS7AfBJGRFzsIjcqgBkwzFWbVTK5
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 10/18/21 12:32 PM, Konstantin Shelekhin wrote:
> On Mon, Oct 18, 2021 at 11:29:23AM -0500, Mike Christie wrote:
>> On 10/18/21 6:56 AM, Konstantin Shelekhin wrote:
>>> On Thu, Oct 14, 2021 at 10:18:13PM -0500, michael.christie@oracle.com wrote:
>>>>> If I understand this aproach correctly, it fixes the deadlock, but the
>>>>> connection reinstatement will still happen, because WRITE_10 won't be
>>>>> aborted and the connection will go down after the timeout.> 
>>>>> IMO it's not ideal either, since now iSCSI will have a 50% chance to
>>>>> have the connection (meaning SCSI session) killed on arbitrary ABOR
>>>>
>>>> I wouldn't call this an arbitrary abort. It's indicating a problem.
>>>> When do you see this? Why do we need to fix it per cmd? Are you hitting
>>>> the big command short timeout issue? Driver/fw bug?
>>>
>>> It was triggered by ESXi. During some heavy IOPS intervals the backend
>>> device cannot handle the load and some IOs get stuck for more than 30
>>> seconds. I suspect that ABORT TASKSs are issued by the virtual machines.
>>> So a series of ABORT TASK will come, and the unlucky one will hit the
>>> issue.
>>
>> I didn't get this. If only the backend is backed up then we should
>> still be transmitting the data out/R2Ts quickly and we shouldn't be
>> hitting the issue where we got stuck waiting on them.
> 
> We stuck waiting on them because the initiator will not send Data-Out

We are talking about different things here. Above I'm just asking about what
leads to the cmd timeout.

You wrote before the abort is sent the backend gets backed up, and the back
up causes IO to take long enough for the initiator cmd timeout to fire.
I'm asking why before the initiator side cmd timeout and before the abort is sent,
why aren't R2T/data_outs executing quickly if only the backend is backed up?

Is it the bug I mentioned where one of the iscsi threads is stuck on the
submission to the block layer, so that thread can't handle iscsi IO?
If so I have a patch for that.

I get that once the abort is sent we hit these other issues.


> PDUs after sending ABORT TASK:
> 
>   1. Initiator sends WRITE CDB
>   2. Target sends R2T
>   3. Almost immediately Initiator decides to abort the request and sends

Are you using iscsi in the VM or in the hypervisor? For the latter is
timeout 15 seconds for normal READs/WRITEs? What version of ESXi?

>      ABORT TASK without sending any further Data-Out PDUs (maybe except for
>      the first one); I believe it happens because the initiator tries to
>      abort a larger batch of requests, and this unlucky request is just
>      the last in series
>   4. Target still waits for Data-Out PDUs and times out on Data-Out timer
> 
> The problem is that between #3 and #4 there is no code that will
> actually abort the task, meaning stopping the Data-Out timer, sending
> the responses if TAS is requires and so on.
> 
>>>>> TASK. While I'm sure most initiators will be able to recover from this
>>>>> event, such drastic measures will certanly cause a lot of confusion for
>>>>> people who are not familiar with TCM internals
>>>> How will this cause confusion vs the case where the cmd reaches the target
>>>> and we are waiting for it on the backend? In both cases, the initiator sends
>>>> an abort, it times out, the initiator or target drop the connection, we
>>>> relogin. Every initiator handles this.
>>>
>>> Because usually (when a WRITE request is past the WRITE PENDING state)
>>
>> Ah I think we were talking about different things here. I thought you meant
>> users and I was just saying they wouldn't see a difference. But for ESXi
>> it's going to work differently than I was thinking. I thought the initiator
>> was going to escalate to LUN RESET then we hit the issue I mention
>> below in the FastAbort part of the mail where we end up dropping the
>> connection waiting on the data outs.
> 
> Oh, I see.
> 
>>> the ABORT TASK does not trigger relogin. In my experience the initiator
>>> just waits for the TMR completion and goes on.
>>>
>>> And from a blackbox perspective it looks suspicious:
>>>
>>>   1. ABORT TASK sent to WRITE_10 tag 0x1; waits for it's completion
>>>   2. ABORT TASK sent to WRITE_10 tag 0x2; almost immediately the connection is dropped
>>
>>
>> I didn't get this part where the connection is dropped almost immediately.
>> If only the backend is backed up, what is dropping the connection right
>> away? The data out timers shouldn't be firing right? It sounds like above
>> the network between the initiator and target were ok so data outs and R2Ts
>> should be executing quickly like normal right?
> 
> I was talking about the patch you proposed. Waiting for the Data-Out
> timeout means that the reconnection will be triggered. And this creates
> duality of a sort. If ABORT TASK was issued after we received all the
> Data-Out PDUs, the target will wait for the WRITE request to complete.
> But if we didn't receive them, the target will just wait unless the
> Data-Out timer expires and close the session>  
>>> The only difference between #1 and #2 is that the command 0x1 is past
>>> the WRITE PENDING state.
>>>
>>>> With that said I am in favor of you fixing the code so we can cleanup
>>>> a partially sent cmd if it can be done sanely.
>>>>
>>>> I personally would just leave the current behavior and fix the deadlock
>>>> because:
>>>>
>>>> 1. When I see this happening it's normally the network so we have to blow
>>>> away the group of commands and we end up dropping the connection one way
>>>> or another. I don't see the big command short timeout case often anymore.
>>>>
>>>> 2. Initiators just did not implement this right. I know this for sure
>>>> for open-iscsi at least. I started to fix my screw ups the other day but it
>>>> ends up breaking the targets.
>>>>
>>>> For example,
>>>>
>>>> - If we've sent a R2T and the initiator has sent a LUN RESET, what are
>>>> you going to have the target do? Send the response right away?
>>>
>>> AFAIR the spec says "nuke it, there will be no data after this".> 
>>>> - If we've sent a R2T and the initiator has sent some of the data
>>>> PDUs to full fill it but has not sent the final PDU, then it sends the
>>>> LUN RESET, what do you do?
>>>
>>> The same. However, I understand the interoperability concerns. I'll
>>> check what other targets do
>> I think maybe you are replying about aborts, but I was asking about
>> LUN RESET which is opposite but will also hit the same hang if the
>> connection is dropped after one is sent.
>>
>> For aborts it works like you wrote above. For LUN RESET it's opposite.
>> In 3270, it doesn't say how to handle aborts, but on the pdl lists it
>> came up and they said equivalent of your nuke it. However, for TMFs
>> that affect multiple tasks they clarified it in later versions of the
>> specs.
>>
>> In the original it only says how to handle abort/clear task set, but in
>>
>> https://urldefense.com/v3/__https://datatracker.ietf.org/doc/html/rfc5048__;!!ACWV5N9M2RV99hQ!YiQjBP1k-nr1NNEI8Cyc2MEwcl5cd_eYzOONU5pcJMTx34q95jrx6zPUrrXfFS95VLYa$ 
>>
>> the behavior was clarified and in 7143 we have the original/default
>> way:
>>
>> https://urldefense.com/v3/__https://datatracker.ietf.org/doc/html/rfc7143*section-4.2.3.3__;Iw!!ACWV5N9M2RV99hQ!YiQjBP1k-nr1NNEI8Cyc2MEwcl5cd_eYzOONU5pcJMTx34q95jrx6zPUrrXfFcgM734S$ 
>>
>> which says to wait for the data outs.
>>
>> And then we have FastAbort which is nuke it:
>>
>> https://urldefense.com/v3/__https://datatracker.ietf.org/doc/html/rfc7143*section-4.2.3.4__;Iw!!ACWV5N9M2RV99hQ!YiQjBP1k-nr1NNEI8Cyc2MEwcl5cd_eYzOONU5pcJMTx34q95jrx6zPUrrXfFXbAD6Jb$ 
> 
> For Target it says the following even for ABORT TASK:
> 
>   a) MUST wait for responses on currently valid Target Transfer Tags
>      of the affected tasks from the issuing initiator. MAY wait for
>      responses on currently valid Target Transfer Tags of the affected
>      tasks from third-party initiators.

Where do you see "ABORT TASK" in there? That RFC chunk from 4.2.3.3;

https://datatracker.ietf.org/doc/html/rfc7143#section-4.2.3.3

lists the TMFs it covers:

The execution of ABORT TASK SET, CLEAR TASK SET, LOGICAL UNIT RESET, TARGET
WARM RESET, and TARGET COLD RESET TMF  Requests

But in the link, the "SET" part of "ABORT TASK SET" is on the next line so
you might have just scanned over it wrong.


> 
> So either ESXi violates the RFC or just not RFC7143 compliant. However> I'm getting hit with this even on Linux. I'll try to get some TCP dumps.

Linux is wrong for different reasons and was why I was saying initiators
just did not do things right and you can get a crazy mix of behavior.
I basically programed it for how targets were working and not being strict
RFC wise.

1. For aborts, it will send the abort then not send anything else.

2. For LUN/target resets, it "sort of" does FastAbort. I wrote the linux
code before FastAbort was a thing so it's all messed up. Basically, we
send the LUN RESET, then the default is to just stop sending DataOuts
for WRITEs.

However, we implemented that code before RFC 7143 so we don't negotiate
for TaskReporting. It's just a iscsid.conf setting node.session.iscsi.FastAbort.
