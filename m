Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A792C433EF
	for <target-devel@archiver.kernel.org>; Fri, 15 Oct 2021 03:18:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A6D060EE5
	for <target-devel@archiver.kernel.org>; Fri, 15 Oct 2021 03:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbhJODUd (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Thu, 14 Oct 2021 23:20:33 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:19562 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229526AbhJODUa (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 14 Oct 2021 23:20:30 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19F0pKWV029664;
        Fri, 15 Oct 2021 03:18:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Wli4EOjU/1RG6Yrzkhp2EPARaXhwQ92WkEmP1cCQ11o=;
 b=xY0ZiiTmgdZanEUq9Hjy+kk/O04Eot//I+4/cOpaX6GSWAKu1sMqXDxIHh9BEA9HLONS
 Z6l5CoDFh2RX6Zn6UBq/wqp8V++enQ2EzI1Pf4GhXwvXGzn6eKQqJe/CVRxtNHk2DeP+
 /OIUYugz3bUlJ/olZMc3GBeM93AGUJAwUeHQqMA7oXHXdf5zAnXcKmc3Pq5X2F9fETH+
 hCzahFoi9aZEmEDFISknOQ7Wc9lEgRn/x9t862KT+c8yWmgtB4RMtsXokK7ztCNk0qkY
 KBJOUZm65qNpG3sPfBd8PgDQzCmFBw9XjgczML5W1tMSu5kh2negUrHPtz8WVX9G30lT SQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bphhuddkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Oct 2021 03:18:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19F3Etur079604;
        Fri, 15 Oct 2021 03:18:17 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by aserp3020.oracle.com with ESMTP id 3bmae3mx7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Oct 2021 03:18:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KFAtFVgUaD0RTID0gaIExcIuRzD+AeTXp91tN/3OprXbCIQvLAwyvm4vt6kot0HrqRRNXknvcMkuZbtGaUHgb6DTqeXWbMY2kqWNR4aS1Bo/XpNQbMBTa+PDx9F9n6pWdh1DbZGTe81ce/8HPK5S7mw4YsWnXeAM268YKKIpAm1iWY5kijRhEE0OyfpD10WX5dNlUB4OjkNW84hNTIzdkpfttE8pFCqUfIvBde6D49ds8kL5zEIPiO9BEVUhEEVTZrwgO3mPTpiUdSk7TU2oom2cJVx5eIIpm37zmQJRGPVsxsE73fwkdINFOGNXplsX3RVH6MkC6Xyw928XMsObTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wli4EOjU/1RG6Yrzkhp2EPARaXhwQ92WkEmP1cCQ11o=;
 b=ka6H1uPof90yHYp8vdZU5Cc2u3e68J0eOPGOCCNZglKsN7WivvGSUQYDtpZRi0IVK8sscZHDzXPAJy1SN4BeefTMftSn/u9g/XYVEVO7LeiPzdashVH3o4GOPkrtb1oDrqbe0RgLPyFh/GejDTaqKJjhqilGdJHJRLoqGcTr8ZsjYbG4bpAJ41voq4W2FAFWeDKVFwLCdfazAv4J/jidnAuki6idcgYdtPWmY5xah99dve/CyWf4XVxCSqaYjYUV7g+fBMUkl3g8L7oKNA9ngSU5XUKr/htQYJay6sdd5lm5VnGES1MIMeKHbiZSWZW4YctgIXsLcKG8l+lVRuml7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wli4EOjU/1RG6Yrzkhp2EPARaXhwQ92WkEmP1cCQ11o=;
 b=ugMoWvAun7QNNDCW5e30uBo2akb1ZZ+Uee02kvZeXdyNvlD/U25znQH5TwmSymZ7Xj8lqBsoj/iDed0RSbz0xcFeOcFTR3ztCLB6O9OpzG9Hqpct1pdskpyXyU9smiEQUjMe98GnhosRLnvUp9A4fNU+CYTyUHzpsR0UT8cAyjE=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM5PR1001MB2154.namprd10.prod.outlook.com (2603:10b6:4:2e::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.17; Fri, 15 Oct 2021 03:18:15 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 03:18:15 +0000
Message-ID: <d5035453-f35f-0ecf-d830-18c6b3040c97@oracle.com>
Date:   Thu, 14 Oct 2021 22:18:13 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
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
 <e76e1a95-dc88-ac9a-62b0-89533182aafd@oracle.com>
 <YWi5YumbN/Zzze5h@yadro.com>
From:   michael.christie@oracle.com
In-Reply-To: <YWi5YumbN/Zzze5h@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR16CA0036.namprd16.prod.outlook.com
 (2603:10b6:4:15::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.7] (73.88.28.6) by DM5PR16CA0036.namprd16.prod.outlook.com (2603:10b6:4:15::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Fri, 15 Oct 2021 03:18:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b456387-6c0f-4af7-c9d6-08d98f8a6d2f
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2154:
X-Microsoft-Antispam-PRVS: <DM5PR1001MB21545250F9F5C21E83901F02F1B99@DM5PR1001MB2154.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ro7HieJw9V8A4WPqwzRKnAZcCQZplRCKBAu5fXSDdNSt+NRBPZA1L8/LZaW3q/35voKqOZ6+4gbwLtBvY4CkBu4W5p6R5OitVg60uxnfa+d6vNe/k1ahGTpmcOWEsY7zloddKj9lSpsRM0W7JyMbrQPMhvsRUhGxNSwvlakbGpKfXnLqfDACXQB2Uh1CD4y9pDs205ykEugyrTU2GwbF39CR6uWQ+b5qEjVXoJ9JEanPE9Gmgg7EkD94DmPkVJVrFgN80eFuxnVv7h2ew1yoOEnKVOoq2y1g2Sqlv8XC9jKWpt0PaoJiX5iFefyYp7dhQ5NfVSYKlYyKenzIf2gaaBA7xPPOEUmIh6QIjUO5o4SrXtPFimfGAPyr4cKQ8D2pF65dl8eII2JOvxFtggdQ5ORZk7992XbYRsiuPA+MkjVG8AXNAjOj/OegCryKjdaLFbEo7ngjvCv4gQUDW+IDEgJvqs913MF1wixzIkrGXEgdzU6yXjwSApc9aGI0PJFFJCrQsUKDQGgDsIMuLzlFLXNMkt7N20BlSazBYOeQiepIXXjRzoa0raOgBcKl+vGlhF9FHvxr3cr7Yi7V0S949Wu9B74S7UKt1G0AJ+5Av3QBXlToAYmsuIRtomGtE2CRghbk4MwGkNu9vL4LuFXKTI2Es+sG3bHhl8RbJIMHpMpjubArVym7yQcEzug0K4EV4//xp9BhRiETSKpXXvnYkJUAu2vTLknTSicedRz/nK0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(31686004)(31696002)(36756003)(956004)(2616005)(186003)(38100700002)(5660300002)(2906002)(508600001)(8676002)(4326008)(8936002)(86362001)(6916009)(316002)(6706004)(16576012)(9686003)(53546011)(26005)(66556008)(66476007)(66946007)(6486002)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QWs4K2VuaFptSERsM2h5Vm95amtsQk11M0JOUmw3dmVPYjdtOTI0QVVDRzRD?=
 =?utf-8?B?dEoyQ280akRIU21CSURnSlFVMHFUejFGZm1LL3VBSTYxQ3REL3VsTzcwUEd0?=
 =?utf-8?B?OGYwamJPLzI0WDdqN2FySFl0YU5pcmRTU3M3Y3VucUpQellZRStoV2I3YmM5?=
 =?utf-8?B?RDRaM0dnaVFJWldVRjVDZHlUNjJoSXBBd0l2TkQxK1hNVEwyL0hoZmlKaEdy?=
 =?utf-8?B?bVB0cFltK09hMlltRGhnT0JuakVRNEplNWVCbzEzbkR6YnhNMzRDd3lqVXhs?=
 =?utf-8?B?TE40a1ErK2laenZPajVhSXVkbERZNmVZWS96RzFQWkdseU44eHE2K3MyVys0?=
 =?utf-8?B?RlJ4dkhZV2N0NVV2clNFWXl2RzlVaUhObG5KWktNQ0Z3YU5WOGpBS2RmL3Z4?=
 =?utf-8?B?MG55WXEyNVM0dWduUk41c3cyeWJERjdSbVFBQ3lBbHhSaVVmYVVsUjBBZkpO?=
 =?utf-8?B?MHhhRUZkcjJQcEVKOW00Ti8vbEh2R3dTQmdDMjJtdUlROExQQklScXVVT2pZ?=
 =?utf-8?B?cTJRZ1RBZGxtKzV2OXpQOWVYR0s5TElHTDdWcWljOGdpNUg2Q1NTM1pBUkho?=
 =?utf-8?B?Z3JSaWtpZkZSUTNQY0lpZDFGcTFDdzRlMFI3ckFPN2VKamVvZFoxSGpnUTNu?=
 =?utf-8?B?ZWJTU0hYQkhkRlcyd2hCYzBwajljYmxCM3VWMk0zTEtsSWtBNWcrZEhqRzlS?=
 =?utf-8?B?R2xJLy9pczNacDZsN1JRb3pYY2xLaFdCT0R4NGZNNEpnZE5GSEV3SGFkblo5?=
 =?utf-8?B?bnZRS0J2Q1NpdkVYQ2dMREoxZzNWSUdkTFM4VjFtNXJlMnRIYWNsZkdjQTFw?=
 =?utf-8?B?N3JBdVkzREdIeUgrVnZhVTNlUys0aTl4QnFDV0t0QmpuNExrZUNRTFN0anJR?=
 =?utf-8?B?aUlBcUhiaVNSQmRadGhVMDhkN2hpOXF6WHR1U3oybG5iYW5WUmhwQk92K0pQ?=
 =?utf-8?B?V2FFWFBvSXJ5elhFMHdjSk1CT3hJUmFmMVFMTnhIRm5Bd0kreXZPUzhOc01X?=
 =?utf-8?B?Y3FneFFsQmhyTXozSEJ0OXN2dzY3V01aMm51eklqd2I4dWZUUjhDNGVOVjlD?=
 =?utf-8?B?aXJ0SE9KdVNIUys0d2VXUEw4MllCWURoaTRaMFZEZk9KSHhRM01WOFU3UElN?=
 =?utf-8?B?THVhMTFpWk0rVitncjN1cEF6aUMrUXZSSXNvbFV3WnFidWJFQytUWU9LUmU0?=
 =?utf-8?B?M3VhQ3lub2gyWWZvNWhHN1IzNU82cXdFWitCZ2o0WWZwam4vQnYvTHFDTFBT?=
 =?utf-8?B?Y0JoZFFlMkxlK2c0WU95VEtBU0FEVWM2UG9vT2RhblpnNWk3MTBqQ3pVMi9j?=
 =?utf-8?B?ZE5hTXNaWG04QWhqMEpCUzhtSVZhVDhVSUNPY085ZmtFS3lubW9lOXNEVStT?=
 =?utf-8?B?ME4wczJkV1FkdEgyc1dlSWpvdVZvbld4Y2trdWFBL3JSdkFENlZubFZEYWdB?=
 =?utf-8?B?SWNOQjgxcXBuQjkrUDdGMmVBV1M3NXh0VW01aWk0eHNWTEFMU3VmKzFqZzNQ?=
 =?utf-8?B?cWJmV1BRZ29SY0pHa09QRHdWNE1rWTAwbnNPbXhTWEp1cEd2K1VNeGRqRkJP?=
 =?utf-8?B?WCtDdHUxazFROTZQL0EwdW1xOU1BSmViS1pOZmJKZHo2TVhtcTNHVXRoaUVt?=
 =?utf-8?B?dy9pVHpuOUNCWVNhNDBqZzhQVldqVjNMVkZSNzk0L1Jza1lEdElEaXA2SEo3?=
 =?utf-8?B?RDd2ZXJiWEZpbkRxUFBZY3lFRjNRc0Y3bE5yYVB0SitpdzROeWZ1VnVVU1lM?=
 =?utf-8?Q?zgCowrxyNcSqo8yZxr+/bqg0mmyBUrvw1+QWkgV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b456387-6c0f-4af7-c9d6-08d98f8a6d2f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 03:18:15.1882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /01U6zCZu43fuiuiUwnYhAcYNOJzSdfh43UWadPnDovnABa1jUdawA3UtI3HzYwc6FL237yh/HLzEU6VWzz5mv4nvvUq1Lf8iaklDBgEIMI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2154
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10137 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110150018
X-Proofpoint-ORIG-GUID: kWbR2mI1fxQ-ephVahwEVNFkKzR1tIa1
X-Proofpoint-GUID: kWbR2mI1fxQ-ephVahwEVNFkKzR1tIa1
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 10/14/21 6:12 PM, Konstantin Shelekhin wrote:
> On Wed, Oct 13, 2021 at 03:21:19PM -0500, Mike Christie wrote:
>> For lun resets, let's take the abort case.
>>
>> 1. core_tmr_abort_task is waiting in target_put_cmd_and_wait for the WRITE.
>> 2. For the normal case where a cmd has been passed to LIO core then eventually
>> the cmd completes and we do:
>>
>> target_complete_cmd -> target_complete_cmd_with_sense -> target_cmd_interrupted
>> -> target_handle_abort. Ignoring TAS, that function then does the last puts on the
>> cmd which wakes up the TMR code in #1.
>>
>> For the case where we never submit the cmd to LIO core, then the puts will never
>> be done by that target_complete_cmd path. And, in this case where the iscsi connection
>> is closed we know the cmd will never be submitted to LIO core because the iscsi
>> threads have been killed. iscsi needs to do the last puts on the cmd so #1 wakes up
>> on that WRITE.
>>
>> So we need a cmd bit to set to indicate iscsi has called one of the submission
>> /execution functions in LIO. If it's not set then iscsit_release_commands_from_conn/
>> iscsit_free_cmd needs to do those last puts.
>>
>> Here in this example to better show what I mean, we detect if an abort has been sent
>> to LIO core for a cmd that has not been sent to LIO core. If that happens then
>> iscsit_free_cmd gets force_cleanup=true so transport_generic_free_cmd will do a put
>> and not wait, and then iscsit_free_cmd does the last target_put_sess_cmd which
>> will wake #1 above. The abort will then complete too.
>>
>> Note:
>> I don't think we have to worry about TAS in this case, because we never got a complete
>> SCSI command. The iscsi layer only got part of it and never submitted it to the SCSI
>> layer. We then escalated to session level recovery so we are not sending any responses
>> for any of the cmds or TMFs. The transport is killed at this point, so no responses
>> can even be sent.
>>
>>
>> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
>> index 2c54c5d8412d..d0e80a2b653b 100644
>> --- a/drivers/target/iscsi/iscsi_target.c
>> +++ b/drivers/target/iscsi/iscsi_target.c
>> @@ -4088,7 +4088,8 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
>>  
>>  		if (se_cmd->se_tfo != NULL) {
>>  			spin_lock_irq(&se_cmd->t_state_lock);
>> -			if (se_cmd->transport_state & CMD_T_ABORTED) {
>> +			if (se_cmd->transport_state & CMD_T_ABORTED &&
>> +			    se_cmd->transport_state & CMD_T_SUBMITTED) {
>>  				/*
>>  				 * LIO's abort path owns the cleanup for this,
>>  				 * so put it back on the list and let
>> @@ -4096,7 +4097,7 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
>>  				 */
>>  				list_move_tail(&cmd->i_conn_node,
>>  					       &conn->conn_cmd_list);
>> -			} else {
>> +			} else if (!(se_cmd->transport_state & CMD_T_ABORTED)) {
>>  				se_cmd->transport_state |= CMD_T_FABRIC_STOP;
>>  			}
>>  			spin_unlock_irq(&se_cmd->t_state_lock);
>> @@ -4108,8 +4109,12 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
>>  		list_del_init(&cmd->i_conn_node);
>>  
>>  		iscsit_increment_maxcmdsn(cmd, sess);
>> -		iscsit_free_cmd(cmd, true);
>>  
>> +		if (se_cmd->transport_state & CMD_T_ABORTED &&
>> +		    !(se_cmd->transport_state & CMD_T_SUBMITTED))
>> +			iscsit_free_cmd(cmd, false, true);
>> +		else
>> +			iscsit_free_cmd(cmd, true, false);
>>  	}
>>  }
>>  
>> diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
>> index 6dd5810e2af1..931586595044 100644
>> --- a/drivers/target/iscsi/iscsi_target_util.c
>> +++ b/drivers/target/iscsi/iscsi_target_util.c
>> @@ -742,7 +742,7 @@ void __iscsit_free_cmd(struct iscsi_cmd *cmd, bool check_queues)
>>  		conn->conn_transport->iscsit_unmap_cmd(conn, cmd);
>>  }
>>  
>> -void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
>> +void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown, bool force_cleanup)
>>  {
>>  	struct se_cmd *se_cmd = cmd->se_cmd.se_tfo ? &cmd->se_cmd : NULL;
>>  	int rc;
>> @@ -751,10 +751,14 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
>>  
>>  	__iscsit_free_cmd(cmd, shutdown);
>>  	if (se_cmd) {
>> -		rc = transport_generic_free_cmd(se_cmd, shutdown);
>> +		rc = transport_generic_free_cmd(se_cmd,
>> +					force_cleanup ? false : shutdown);
>>  		if (!rc && shutdown && se_cmd->se_sess) {
>>  			__iscsit_free_cmd(cmd, shutdown);
>>  			target_put_sess_cmd(se_cmd);
>> +		} else if (se_cmd->sess && force_cleanup) {
>> +			__iscsit_free_cmd(cmd, true);
>> +			target_put_sess_cmd(se_cmd);
>>  		}
>>  	} else {
>>  		iscsit_release_cmd(cmd);
>> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
>> index 14c6f2bb1b01..eb233ea8db65 100644
>> --- a/drivers/target/target_core_transport.c
>> +++ b/drivers/target/target_core_transport.c
>> @@ -1554,7 +1554,7 @@ int transport_handle_cdb_direct(
>>  	 * this to be called for initial descriptor submission.
>>  	 */
>>  	cmd->t_state = TRANSPORT_NEW_CMD;
>> -	cmd->transport_state |= CMD_T_ACTIVE;
>> +	cmd->transport_state |= (CMD_T_ACTIVE | CMD_T_SUBMITTED);
>>  
>>  	/*
>>  	 * transport_generic_new_cmd() is already handling QUEUE_FULL,
>> @@ -2221,7 +2221,7 @@ void target_execute_cmd(struct se_cmd *cmd)
>>  		return;
>>  
>>  	spin_lock_irq(&cmd->t_state_lock);
>> -	cmd->t_state = TRANSPORT_PROCESSING;
>> +	cmd->t_state = (TRANSPORT_PROCESSING | CMD_T_SUBMITTED);
>>  	cmd->transport_state |= CMD_T_ACTIVE | CMD_T_SENT;
>>  	spin_unlock_irq(&cmd->t_state_lock);
>>  
>> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
>> index fb11c7693b25..b759ec810fa9 100644
>> --- a/include/target/target_core_base.h
>> +++ b/include/target/target_core_base.h
>> @@ -511,6 +511,7 @@ struct se_cmd {
>>  #define CMD_T_COMPLETE		(1 << 2)
>>  #define CMD_T_SENT		(1 << 4)
>>  #define CMD_T_STOP		(1 << 5)
>> +#define CMD_T_SUBMITTED		(1 << 6)
>>  #define CMD_T_TAS		(1 << 10)
>>  #define CMD_T_FABRIC_STOP	(1 << 11)
>>  	spinlock_t		t_state_lock;
>>
>>
>>
>>
>>
> 
> If I understand this aproach correctly, it fixes the deadlock, but the
> connection reinstatement will still happen, because WRITE_10 won't be
> aborted and the connection will go down after the timeout.> 
> IMO it's not ideal either, since now iSCSI will have a 50% chance to
> have the connection (meaning SCSI session) killed on arbitrary ABOR

I wouldn't call this an arbitrary abort. It's indicating a problem.
When do you see this? Why do we need to fix it per cmd? Are you hitting
the big command short timeout issue? Driver/fw bug?

> TASK. While I'm sure most initiators will be able to recover from this
> event, such drastic measures will certanly cause a lot of confusion for
> people who are not familiar with TCM internals
How will this cause confusion vs the case where the cmd reaches the target
and we are waiting for it on the backend? In both cases, the initiator sends
an abort, it times out, the initiator or target drop the connection, we
relogin. Every initiator handles this.

With that said I am in favor of you fixing the code so we can cleanup
a partially sent cmd if it can be done sanely.

I personally would just leave the current behavior and fix the deadlock
because:

1. When I see this happening it's normally the network so we have to blow
away the group of commands and we end up dropping the connection one way
or another. I don't see the big command short timeout case often anymore.

2. Initiators just did not implement this right. I know this for sure
for open-iscsi at least. I started to fix my screw ups the other day but it
ends up breaking the targets.

For example,

- If we've sent a R2T and the initiator has sent a LUN RESET, what are
you going to have the target do? Send the response right away?

- If we've sent a R2T and the initiator has sent some of the data
PDUs to full fill it but has not sent the final PDU, then it sends the
LUN RESET, what do you do?

- You also have the immediate data case and the InitialR2T case.

The updated specs clarify how to handle this, and even have a FastAbort
key to specify which behavior we are going to do. But we don't support
it and I don't think many people implemented it.

So you are going to get a mix of behavior. Some initiators will send the
RESET and still send the data out PDUs and some will just stop sending
data outs after the RESET. To be safe do you wait for the initiator to
complete the sequence of data out PDUs? If so then you probably just hit
the same issue where we don't get the needed PDUs and the one side drops
the connection. If we send the ABORT response while the initiator is
still sending data outs, then we risk breaking them.

If you want to do it then go for it, but to answer you original email's
question the only easy way out is to just let it time out :)
