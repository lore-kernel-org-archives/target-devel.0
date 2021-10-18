Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED14C433EF
	for <target-devel@archiver.kernel.org>; Mon, 18 Oct 2021 20:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 906B96108E
	for <target-devel@archiver.kernel.org>; Mon, 18 Oct 2021 20:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhJRUhF (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 18 Oct 2021 16:37:05 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:58278 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233070AbhJRUhE (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 18 Oct 2021 16:37:04 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19IJSYPV025779;
        Mon, 18 Oct 2021 20:34:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=loX0e560XytgRiMvl2bk7QtXWphXuQH+quJnnPJPTQc=;
 b=yRFwP2uBXOy6Trnhk2WpKkuGrJiAVz9zaZOw+MykFIXdjRBgQbi79aTQ5xuzBOPhfJpA
 9YHpEDysyu8DmV++aEXNgDPOoFZXi+V7eVXcM1aoZDAjyOmtqUyospn9R9g+0StREV3R
 OfMHdW45cU5473WJikHVGXbC/067xH4kNrwICLBJA7XGz1YyrEY5StckhyG7SIip9GD6
 Rs6fcjiYnbsfAxZBc3D9RhpEs//utEgQFhjDJGAErPAZgWBVX6pQ0aDyNvCsbaituIxS
 LbWadsA0KufW9epPX8XLPV/hP+Z/uQedxpOv0s+tLBooXy8POj44xXSvGxNOnI1sh/e2 VA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3brmkyeqyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 20:34:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19IKRLNn162145;
        Mon, 18 Oct 2021 20:34:49 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by aserp3020.oracle.com with ESMTP id 3bqpj4bd9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 20:34:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BnLSl8FrGPNjWrVfmZWwmeydVgYUDpzhKwQxvw0jFp+qokkDO0ZrUk0gMibgqndk+v06wGIXTA2+3PDvnUCXPfC3qvYCniRHQJYrv3N3aw6bnArilQsZkNIU/kwk3Gzkeg0yTdYxkShiveysyj+ZutobkzArx8uWd0Cw5TAIKrdNg7vjXpbX0f0W0nhXzSrzxADQqJQ99MgO+1UMJR/GmT6BQKC+MyUKEvnAD63811yNXH/wLdETtnzziriF//KutkZVjjzgtvmbenzMoClN8gzdBNyJm1BejaE7cygqiJqRukfEqWxihcvg1h1WNhYw1B3YGIjhxpPtIB2klXxCvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=loX0e560XytgRiMvl2bk7QtXWphXuQH+quJnnPJPTQc=;
 b=bef9XHgzvHIy/uHM4gIal9rjJpS4FhKIO5zmqXXWgT45OLxfveoBWBFH0ppo7Y7dO9yrgPwNabYN4PFNUcIjduP+alxoXnbzlu4m8zQ3BFXGQklEeuLQdOYL4wQRzm0/8xQHEuvUZywU4+IoHZbd09TzNJbERBM2Rp/vsHX0Gg8gh6VQH5bHzxcU9BEcZ6/g5OOexgQ+kep2J9WJFrArTrLC80qduizFS4deUiEA2KiFT8+aeZTrc5ojSqaj2+1KVns+sb7qN3wWqb33X+Hatrc9M/TGP7zsI6EW3hw9c/Oz3F/Qit5rVeTtQmiOUe2AHnRAfKV0iwhzwnEKIYeubg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=loX0e560XytgRiMvl2bk7QtXWphXuQH+quJnnPJPTQc=;
 b=pcnkjT4UQ+by5JjaOG2rRwiACK+2JmObmtYzAq3YK7JEyd0hGfKCRjqlJegaR2xuMd0Uk9hDePk7mRLVOKdOknm6vPUZSBbN7zAyiUbbtsOBB3cKuYudeuGM/khodAZr3CVBxX9+Y8BEGn8qxd5uVCKtKdvYV+8jKeHA0BIgDhs=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3947.namprd10.prod.outlook.com (2603:10b6:5:1d6::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.18; Mon, 18 Oct 2021 20:34:46 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 20:34:46 +0000
Message-ID: <1858f7c3-4874-6931-da3a-12518aa36719@oracle.com>
Date:   Mon, 18 Oct 2021 15:34:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: iSCSI Abort Task and WRITE PENDING
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
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
 <5731ecf9-f99f-f397-aad1-fe8b142c2748@oracle.com>
In-Reply-To: <5731ecf9-f99f-f397-aad1-fe8b142c2748@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0355.namprd03.prod.outlook.com
 (2603:10b6:8:55::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DS7PR03CA0355.namprd03.prod.outlook.com (2603:10b6:8:55::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Mon, 18 Oct 2021 20:34:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15d20683-8114-4898-edd3-08d99276b96a
X-MS-TrafficTypeDiagnostic: DM6PR10MB3947:
X-Microsoft-Antispam-PRVS: <DM6PR10MB3947168BE9E47DBDBC3A1ADFF1BC9@DM6PR10MB3947.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1ZzbW1MZ4CCxLZZk20M1jBcNoTX2NLyyOIuJpPI8dbN3hR2jxn5UoVHPdhEdicmBin7xT0n9/5eOZo5+snqMoYGe90m/ZgoCy6GPUajJI9O4jmwOqYB/crHgJAKXvp9o0dWM+ZNphDUDQq9ahAqRiJ01dWhPf4hJq1IBRqydZ1FZ2k8z0QMhV5qqpTtDj/9nDo/jpEbDq1VXouzDY7neOyGlh2mY2njRA7zmOWZwinY47I3P1j8mW0eBJxm5dSXeTAAE5lEXiiuiFZVxXTlf3mXCvdPCWIXkanDMPdhcNPV4Al7veE2Ug3G7B3WTSLAVD/SIcutJNZJfqubFRUdYLFis/8+gv6gDUme3DxIF93h81e3MQCsbFL8mNOxcnA0I4sd+JeedovlIpyeJ8dF6KAMinHLakPaiyIX5wit24o4g9qI2rA+RGQi4xe1fcAYENOVyQGH8QXDPTrffKBGQ6q+htHVYdZX2aNgaeide/rlgCBeFEvTgdLs+PdDHZAkIVV98p9uy5DqKcjdGEl9Envp92nmIOQzavyygWUaxuSYEpVTjzC8o4OxXDJ7Khxhv2v2uynPGTbnYEbpEkmUuQ3xSUv+4LpGh+X3CJimmQN0AZQ30DpZQuvU51hqBBFXTqlFPg/pcNO68CnfZ40rUVcyG2DXuMlsGfiMt1S+py2yv3w3OVnwwrJuyVywkl/eusDoRfVzNloZB/glKoBDqPjz67/lDyzfPYNKkZFXlsrjTT6kXfVft54ldz5b8qzBdI8XXUpOgM9ZtNb68m8hZyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(83380400001)(66946007)(66556008)(66476007)(36756003)(6706004)(2616005)(316002)(16576012)(956004)(31686004)(6916009)(26005)(31696002)(508600001)(2906002)(86362001)(186003)(8936002)(8676002)(5660300002)(38100700002)(4326008)(6486002)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDROYlI2bG9rd04yS2RPSWt6V2EvREdIdXZxY2t6N1JNMEZkaUFCTEt0Smpr?=
 =?utf-8?B?L1NtQ0VnVlVpQkFUK3RHYnVzTDNrTjRZblByOTNoaERpSTVHQlVsNDU0SlJm?=
 =?utf-8?B?Ylh2RlFEcE51SlQwc2VvYTRqSGNMTTlvSWU5RFAxakdISzhFNldNOUViR0h6?=
 =?utf-8?B?S3h0UHZnTEczcFRGTHI2dTZFbVRpNkhCcWlrYmJuc3RpSlUyYlNjWE8yeFgz?=
 =?utf-8?B?Nm41TitrUUd6RW5pbjJvMi9DZGx2M2tXNWpTNHRGMnBBWlNyV0dxdk5wMDNX?=
 =?utf-8?B?dm9MM01keGJRcnE4MVRkNitabmZGdTRQOXd6b3FRb2VLNmRwR1R2V0lhTVFy?=
 =?utf-8?B?SjFNV3IrR2tpOVdCS2tCKzlXNStZTmwrc1JteURmandlNkw4d3ZSSXNGcTdq?=
 =?utf-8?B?d2VyRUx4aGg2WE13cWxrc3Nlb1lhcEplY0hKYWcvbEpvV0RRd2t4cE5MWHI0?=
 =?utf-8?B?dVJWZmwxYU83R3RvK3pFT0JCVU5BUUR2TVlKN1c5OTMxYUw2YXRMZHYvUjB3?=
 =?utf-8?B?NXQvS3ZWT0NlcWtWRXlqaGduOVl4ZjRhb0xieGZ1NzFFeUhRZVk3eFVGbmh6?=
 =?utf-8?B?M1Y5dHNzNUc0QnpBbkcrNEtVU2hJZlNGSGRERW1TVWRKRmpQQU9nb2VkS0dv?=
 =?utf-8?B?bFd1YmV0NjRldzAyNFprbGVjbnlBS3pITXM0NGptOW1QclpnM2R0bE9UWlcz?=
 =?utf-8?B?OEl4K0dySEQwM1NpVEZQWGdLSTM2RS9FZGNDWlFFL01MdXlNeHlWOVkrOVRL?=
 =?utf-8?B?QXJtWVVkbVFhS3d3Y1Q3WjQ0ZFh1enNVM3A3OEZPaStSRFBEZ2dmVmlBZk1B?=
 =?utf-8?B?NWl3QVNQa0NzNk1DNjVJVStFTlNFYW1HK2NCcnloRTRkTEtpZDBHeXlSTTBa?=
 =?utf-8?B?YzNhRjBFcVAva0ppdURZUHQzY3FtQUpDTFZDaER2RXd2OGJ0dzJXSkNUeHpI?=
 =?utf-8?B?d2MrYjdsdjBtbUVaUHkraWt0aGVPaVMxZitFRTFrTFYrVFRrOFYvbXhNcHhk?=
 =?utf-8?B?dUJmM3h1VlhxVU0wbmRXcFd3eng0bXR6V1p4YkE2VWxMMENKdGZ5K2FhQWMy?=
 =?utf-8?B?UXJPdXFZSExiWHlFaWxkbGRMcDJ4VlRWT2phM3k4NWUxNGF5WjlKQUlJU29v?=
 =?utf-8?B?V1FNK2dhOXFKNTJadEg1TnYzYWVzQy9vS25BYnNRUG14cmRQOFB6UkNTLzAv?=
 =?utf-8?B?NE1QTXI0cVlCd1doeFl0L0xOVnFIQmlCQmxheG11YU1zSUlxY2hPcVNBVDln?=
 =?utf-8?B?MnlyZGY4TnVlV2M5RjlkT293bllqVjA5WituenZBVFZucURqb295MUdSM1FK?=
 =?utf-8?B?Q0J1ai9RUVQwRGpzd1lWbmFueDBmOE4wQ29QeTZ0enhKQzdNa0ZwNU4wVVlN?=
 =?utf-8?B?ZVREUDkzTjhiSXIwejFYQmVvZ3Rod2VLRlRuRjVrNDlIcGZyQ016S0JZMk1n?=
 =?utf-8?B?NU5ZZ1lYQnhaNG1zNFhkemp5Y051SEo5VysyVFpzQVBLV0tTMGtNSmo5dStB?=
 =?utf-8?B?QXF0Z0s1dyt6OW9XOTdPNm5VU0wzc1VPbVVHYUVlVXBZR2ovc0UxSTArME01?=
 =?utf-8?B?SzMwMWlKS2hTWlRyeVJoQ05DZldiSXhLU1JEcFVxK09VeDVJT0JLbThyWEE3?=
 =?utf-8?B?WXVrajh3eEdPWFBBTkh1V0V6OGRhNUhtMVorVmJJUEdUb1ZkaHdLTGFlZjVC?=
 =?utf-8?B?YjNOdndhSCtnMlFiQnVYVVlXQ21aV2xqK3ZnUEVHTTd0Tkoxd1gvdEJCVEk1?=
 =?utf-8?Q?hLZPxBg7MYt0LtXpgCcGSyuS975YC4MRGtrsLXK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15d20683-8114-4898-edd3-08d99276b96a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 20:34:46.5654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: chR7KENMJ4QWuz2AtXnI1v/jwKdd3nKf5ItvJKHe0lykITFHintxX+SOQjOaMaB6z9qlJmhhlYBPQ2czwR0/4TvenFIWPtUCct0ysdP4hk0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3947
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10141 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110180111
X-Proofpoint-GUID: c6PIS0g6afphH1jB-7TOiGoY8brnMHmu
X-Proofpoint-ORIG-GUID: c6PIS0g6afphH1jB-7TOiGoY8brnMHmu
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 10/18/21 3:20 PM, Mike Christie wrote:
> On 10/18/21 12:32 PM, Konstantin Shelekhin wrote:
>> On Mon, Oct 18, 2021 at 11:29:23AM -0500, Mike Christie wrote:
>>> On 10/18/21 6:56 AM, Konstantin Shelekhin wrote:
>>>> On Thu, Oct 14, 2021 at 10:18:13PM -0500, michael.christie@oracle.com wrote:
>>>>>> If I understand this aproach correctly, it fixes the deadlock, but the
>>>>>> connection reinstatement will still happen, because WRITE_10 won't be
>>>>>> aborted and the connection will go down after the timeout.> 
>>>>>> IMO it's not ideal either, since now iSCSI will have a 50% chance to
>>>>>> have the connection (meaning SCSI session) killed on arbitrary ABOR
>>>>>
>>>>> I wouldn't call this an arbitrary abort. It's indicating a problem.
>>>>> When do you see this? Why do we need to fix it per cmd? Are you hitting
>>>>> the big command short timeout issue? Driver/fw bug?
>>>>
>>>> It was triggered by ESXi. During some heavy IOPS intervals the backend
>>>> device cannot handle the load and some IOs get stuck for more than 30
>>>> seconds. I suspect that ABORT TASKSs are issued by the virtual machines.
>>>> So a series of ABORT TASK will come, and the unlucky one will hit the
>>>> issue.
>>>
>>> I didn't get this. If only the backend is backed up then we should
>>> still be transmitting the data out/R2Ts quickly and we shouldn't be
>>> hitting the issue where we got stuck waiting on them.
>>
>> We stuck waiting on them because the initiator will not send Data-Out
> 
> We are talking about different things here. Above I'm just asking about what
> leads to the cmd timeout.

Oh wait, I miss understood the "almost immediately" part in your #3.

Just tell me if you are running iscsi in the guest or hypervisor and if
the latter what version of ESXi,

> 
> You wrote before the abort is sent the backend gets backed up, and the back
> up causes IO to take long enough for the initiator cmd timeout to fire.
> I'm asking why before the initiator side cmd timeout and before the abort is sent,
> why aren't R2T/data_outs executing quickly if only the backend is backed up?
> 
> Is it the bug I mentioned where one of the iscsi threads is stuck on the
> submission to the block layer, so that thread can't handle iscsi IO?
> If so I have a patch for that.
> 
> I get that once the abort is sent we hit these other issues.
> 
> 
>> PDUs after sending ABORT TASK:
>>
>>   1. Initiator sends WRITE CDB
>>   2. Target sends R2T
>>   3. Almost immediately Initiator decides to abort the request and sends
> 
> Are you using iscsi in the VM or in the hypervisor? For the latter is
> timeout 15 seconds for normal READs/WRITEs? What version of ESXi?
> 
>>      ABORT TASK without sending any further Data-Out PDUs (maybe except for
>>      the first one); I believe it happens because the initiator tries to
>>      abort a larger batch of requests, and this unlucky request is just
>>      the last in series
>>   4. Target still waits for Data-Out PDUs and times out on Data-Out timer
>
