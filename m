Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC19FC433EF
	for <target-devel@archiver.kernel.org>; Mon, 18 Oct 2021 16:29:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC97761002
	for <target-devel@archiver.kernel.org>; Mon, 18 Oct 2021 16:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbhJRQcA (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 18 Oct 2021 12:32:00 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:14172 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232159AbhJRQb7 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 18 Oct 2021 12:31:59 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19IGN8AZ014705;
        Mon, 18 Oct 2021 16:29:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ta/odcwGsidnEgo4XfSSauMEykZ9r1xilDQ+eZAmPpM=;
 b=JJ5Bge34HaSUQ2zivkcjSGnQZmL3So5LvKHLraSLk1Jb5qfQ7nUaadS1EEggENkjFbhV
 5qluOGHTKC9BP6HY7R0f+2cAEb65GlZMR0MToM2WqlqSNdJXtwbwtZ35sPI3jQyc7w4V
 I5Ewu1h4Z8mdIgxFMRknXA+N42w4gc8GdgfgJgZqOzqBE0bKlcFR/9h1pPMxTLHxQi3U
 L5zKhY2bDOM+2ECMSxrRj/oIZb9w8bU6Q30XVunwQNJn0XxPl4vVza8aCqsWkLcMI3vz
 olurWrIJL1u+yDuHm7Ls/vbLkFU8Svv/PQLAizqRHk0z4nJ0xWYIlsGRnmnSK2UKDbC3 hg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3brmkyd45j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 16:29:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19IGL55P049055;
        Mon, 18 Oct 2021 16:29:26 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by aserp3020.oracle.com with ESMTP id 3bqpj4162a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 16:29:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h0QmsWpRcn/cjv8SRoPzeFIa/uupyrNebJCNnFWePZPTFS510Bmg5EBkKPY7mycyeriJ0vak51me4vrZ83Bv3mzbVmfNPA6vouIi28YkxTtkRg6kK7YFcYkdhgUv0ujqIA0R6mxvtpfZ2foFmMrXFCfy0HNFXXqV7bjWY0W1nmIvuC/nhT2IUr7fhm1zaL6qtBoGf783sJQpgcKqCZVUDCipFH7eXeRyJ0kIkqWq4hMUHS/x4ayx80DTUettWp6/b6qQ7hCVt+twAw23cRwQd/ZAysvuY9wnqUaYUQpPfQMcfqiMmOhl3MbCqilh9VybnOGVvZq5shKNJzFczltHaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ta/odcwGsidnEgo4XfSSauMEykZ9r1xilDQ+eZAmPpM=;
 b=BWqn+7MhRnIdLmI1IT+tpD1GWls5wslcxVsOZRJwf8OIOV8q65ACc0r0q6I1GDiqAQefeRMU8vUkdyDO3ilRyJVNbGsvgBJgiAcDMel2Kl84zyX2PrSmWL4TPUn7beDRXdXMZ7NiTY4eiqRthywPy8Cul7pgB2OH9okyYp/3BlNxF6+inPnlxq/yLc52g9Omlr6ib7ZuNUvhS0bvRihm5myqvcdzzWu9HUN8MnEjrXlec2dNBW+QE10On+1OkoRatojJDKGsDrCoKYD6fQtT2M7eKV2N136a270qH1qdE7CQp7Qy2VntQMRN3BTs63Or+VOmeGc1L3MfQlTcumtgMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ta/odcwGsidnEgo4XfSSauMEykZ9r1xilDQ+eZAmPpM=;
 b=p4qCIy/RCDGkv7Upt+PX7kIhxxZg4RjNqacc0agDa/K3NzDBrvE7m7JvJz4F1zlDCp6U0IBHKRErHjm8/fVJtsyv6dhWBYviVjzvT5igv1kfKI14FQZ60y5qYjpPiQDHn7IQPQEYLQGCBialzVE1S/5yR5FzACD3PHPwNUUgPM8=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3548.namprd10.prod.outlook.com (2603:10b6:5:17b::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.18; Mon, 18 Oct 2021 16:29:24 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 16:29:24 +0000
Message-ID: <2318e7d3-84c1-e5b0-62ce-dd25a21d3476@oracle.com>
Date:   Mon, 18 Oct 2021 11:29:23 -0500
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
 <e76e1a95-dc88-ac9a-62b0-89533182aafd@oracle.com>
 <YWi5YumbN/Zzze5h@yadro.com>
 <d5035453-f35f-0ecf-d830-18c6b3040c97@oracle.com>
 <YW1g/OFXMHq44CYo@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <YW1g/OFXMHq44CYo@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR18CA0096.namprd18.prod.outlook.com (2603:10b6:3:3::34)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DM5PR18CA0096.namprd18.prod.outlook.com (2603:10b6:3:3::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Mon, 18 Oct 2021 16:29:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6847c7e-2890-46e2-f230-08d992547253
X-MS-TrafficTypeDiagnostic: DM6PR10MB3548:
X-Microsoft-Antispam-PRVS: <DM6PR10MB3548D0362E641E5028CABA2AF1BC9@DM6PR10MB3548.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ahu1EiRlXd/cmEbwqVLGZNGy6z0TRoByHdcScQzY5Id0mbCAv+7gd42osH+ca7K5UE0mllVCqxgty9W0fY+0CX6RkOriMNDrmzcykcI1CVngJvRQjvaA9oHei0C1dv599fRNYtYW2wRGBXcVk15AhE3DTLdjlVlLF0woNpfhhczxH35LxfOOr1sjopUa9cTi2ZMkStLs/R/eD8l95VQyDMkdHB+Bb3X8Wk/2zDGmDdaeO3JHZHRaK70/f+NNiCeRuQNtUxheHlSNqb3WQw7Rv4ilOjpsL8kPxb3fXspVb3QpPE8UExsp1I48hXVD5RySkMrx/ARAkerdSHv7mRYjBtynm9RjAZyEDw5Rx+JxmjbSRHURRwqNj4LNogex4IXMlWZQtcNzU74/znFFzROV9cT+x/UJEtyMcpI+8knbgSdjDOxAMU+OhEcLBaRs+KoDAh3RXkefUZCNiQAKTOMg/AbZGEELwUSS8EUN793zCEk+vh1H9FqVo6O6MpRIqavd6kewb9TBoa8Y//rsOCfEwpkxHU6ttZlorBsYwwlg0lfZZRNuxuB9YPZKL2vGaTuooLW9drUFKgTPC7uBnpQnD27kqguAKxPtt7VD1+dBY2Xme6XN4reMUMb71PQbMwdZxH1JNqrdDTcikPi0nAm1Qr+XrqKz4Eb4sZhYfMU1v4+beaPbhMubr8cXqdzWalHcIQkau/Z8iJ1QvGrhg3f4jPthUVh6pIjRnB7QmSyPJv2XKGcD0rMm+873rEJToB8ZDItxOCvQoMha8zWswrdM46r0C4wddiITz5FsPcJDnODW8qCy/4CM5qnVNMps8sDFynjcG8iXywvDGPJatjJXxdmD/xxP5U7rpZ3GltM8R+l31GRnTo2N7EERirFF0rzE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(2616005)(6916009)(6706004)(508600001)(956004)(2906002)(6486002)(31696002)(36756003)(31686004)(16576012)(966005)(66946007)(316002)(5660300002)(53546011)(66476007)(8676002)(38100700002)(8936002)(186003)(4326008)(83380400001)(26005)(66556008)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEJHU2NTKzJpR2VCMVlVWFI4dzVzVzU1NjkrSU9VQ2xneFhHNG9sODBFVU1R?=
 =?utf-8?B?UzZCdFpkSVlNQlI5ZXY5MkNrcHMveGFGKzdYWkQzdDdMNERVYUdLa1c0VmFi?=
 =?utf-8?B?WEhqSHJ2Q2NQZ2dzR2RyTElNWGFSNFpMbW1zRStaS21IUzU4QTNZOWJVdXor?=
 =?utf-8?B?V2ZCY2c3aWNxakVualhwRXMyeDlINFBMR3Z6aTRHQXpqc1ZZOUdqQkhrc25l?=
 =?utf-8?B?cnFtV0laeFdyRU1QVm1Qcjg3R0FNaFN0N2oyMmxiRHlCSHkrcnV4U0NQRDRq?=
 =?utf-8?B?NzA1Z0lXWUxxWXZtQ09qbXJDZmNWNjRnTHplckJucU0zUnkwb212emdEOU1L?=
 =?utf-8?B?ZytnVVVFKzRGeUUvcm5zSVF5K3BvM1ZMTmxtdzZsdlJTbDdpelVZclJ2OE0z?=
 =?utf-8?B?aldyREpnVU1EcUgzSXhkM3VFb2dzZm9yN1pwYkdhZHVvSTFOdFhzSFgwWGxy?=
 =?utf-8?B?ZHh4em1nckpUVWo4S3QzVVNDbTVQYVJPTWZkWkdNWDV3clNDcXVOOFRHS0RK?=
 =?utf-8?B?UnV1b2pOTWJpaEJQZGw0Rjc1ak9ta0J1SFNEb0V5OFpLUUJXMnV1T1hvRkc3?=
 =?utf-8?B?YUlQZDhvZmJJazlUZEpwSkZva3FOUkpmOEFHQ21vMkcxZEEwYVZvUk8ySlFj?=
 =?utf-8?B?YVBwWmZSNXhYeFJQTlJrVHBzbUVjYWN5ZFh2cWVQNUgyQW03SlpLSVB0R2tL?=
 =?utf-8?B?VFViYkFUMGg0QmFRZmxzMldzVjdmUVd4ZWFqM0M5ZStlUzJKcmFIK3k3RFhL?=
 =?utf-8?B?clFpckVKejhqTVREdzdPeWNvUVRzYnNoMnR1a2ZGeEF1cUdTWXF2TUk0RlpQ?=
 =?utf-8?B?RFAxYlgvT3dHQWtqMDNQLzhpMjdnSFIrTkRSaExlV3psMHBzcXJIRHhOeTlI?=
 =?utf-8?B?d3BuNWx4UzQ1Y1ZoVGl3bUN0VWY1Mytqek5XVDFQRHRaRDhKaU5YaVg2Q3gw?=
 =?utf-8?B?RUJGbUNIYUwvcGQzeEhvLzBrNERiMzNKWHJ4TUI0ZGJNa1lJUXpuZjBnWk1t?=
 =?utf-8?B?VXVqN1krbVM5VnBoR3NrWWxBL2NtU2NsWlBISVdvQjFDaXk4T2Q4a3ZCZ3dE?=
 =?utf-8?B?T1d3aDBqTERLbjl2ZHpreDhWUGptTlBlZFdzOWFROWkxbUdnNno1bGZUMkRu?=
 =?utf-8?B?OVBUaDJ6UjRVOVpNT25nVmxGdUdwWGtwK3NkYnlyMUY3cTZXMXlJZmRvTTVp?=
 =?utf-8?B?blduMEtCOVhQY3VsdkhjZnMxREtNMGRYNE4zcWg0d2JsSHZ3S2NWTDBPWUVK?=
 =?utf-8?B?Qk1JMTF6VVREVHdxUHFiSnNqSDJxTXFlZS9iQ0JsZGxrNVUrSExyVG1lVFNr?=
 =?utf-8?B?OGpTQWZCYjhKcE43UkV2NERDSFhYanRpM0F3RFhrNi85R1pocE1PWlM2ZktB?=
 =?utf-8?B?UmNPNnZwRjhrUXgzSENKYlFUdlF6MDhTTE11TkJWQkcvOVYzTGpqaFR1Z3J5?=
 =?utf-8?B?cnZZRXpta25mMzM0ZGtpT2ZYQ3NmazNrLzdQNkdaQ0hSbUVJSElqYlA3aWxV?=
 =?utf-8?B?U3ZjYUxGUW90NEtFOEdXOFBFUGYzbFlRbWsraFE5cUp1UHZtNDBCeTJqN3lD?=
 =?utf-8?B?SHlRSzh2OVFKdDRWK0FKY085aERINkUzYy9RNWNMNG82ZmViRHhjRFB6d21p?=
 =?utf-8?B?bUR6VzdtWUh4YzBlalQyZy9BQmJtbDRYVnJrV0p5bXcvUmRxOG9RWG1UYVJu?=
 =?utf-8?B?ZDM5L2p2ZDV0eWFSZyt4bWFhSnEreDhhbUlCTUtEeTFpZkhlamJMeUo3VTl6?=
 =?utf-8?Q?UTZC5tFOXpKQZbYuIsV1lE10I9/txbZgMn/Elhg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6847c7e-2890-46e2-f230-08d992547253
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 16:29:24.4857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 68PahjSZStvXPe3lwQ0jqVF6ppbibJE9l/9HbYLSesKsI1NrFp/9N0hjVMBU7TTW1O8RlvbBDDP3fNSHZRhrZl/llEwEKWa22obXLRWSXgc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3548
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10141 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110180096
X-Proofpoint-GUID: mnQpYFefz6DTXFHw4Pi2gRU0QJonSAJP
X-Proofpoint-ORIG-GUID: mnQpYFefz6DTXFHw4Pi2gRU0QJonSAJP
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 10/18/21 6:56 AM, Konstantin Shelekhin wrote:
> On Thu, Oct 14, 2021 at 10:18:13PM -0500, michael.christie@oracle.com wrote:
>>> If I understand this aproach correctly, it fixes the deadlock, but the
>>> connection reinstatement will still happen, because WRITE_10 won't be
>>> aborted and the connection will go down after the timeout.> 
>>> IMO it's not ideal either, since now iSCSI will have a 50% chance to
>>> have the connection (meaning SCSI session) killed on arbitrary ABOR
>>
>> I wouldn't call this an arbitrary abort. It's indicating a problem.
>> When do you see this? Why do we need to fix it per cmd? Are you hitting
>> the big command short timeout issue? Driver/fw bug?
> 
> It was triggered by ESXi. During some heavy IOPS intervals the backend
> device cannot handle the load and some IOs get stuck for more than 30
> seconds. I suspect that ABORT TASKSs are issued by the virtual machines.
> So a series of ABORT TASK will come, and the unlucky one will hit the
> issue.

I didn't get this. If only the backend is backed up then we should
still be transmitting the data out/R2Ts quickly and we shouldn't be
hitting the issue where we got stuck waiting on them.

>  
>>> TASK. While I'm sure most initiators will be able to recover from this
>>> event, such drastic measures will certanly cause a lot of confusion for
>>> people who are not familiar with TCM internals
>> How will this cause confusion vs the case where the cmd reaches the target
>> and we are waiting for it on the backend? In both cases, the initiator sends
>> an abort, it times out, the initiator or target drop the connection, we
>> relogin. Every initiator handles this.
> 
> Because usually (when a WRITE request is past the WRITE PENDING state)

Ah I think we were talking about different things here. I thought you meant
users and I was just saying they wouldn't see a difference. But for ESXi
it's going to work differently than I was thinking. I thought the initiator
was going to escalate to LUN RESET then we hit the issue I mention
below in the FastAbort part of the mail where we end up dropping the
connection waiting on the data outs.


> the ABORT TASK does not trigger relogin. In my experience the initiator
> just waits for the TMR completion and goes on.
> 
> And from a blackbox perspective it looks suspicious:
> 
>   1. ABORT TASK sent to WRITE_10 tag 0x1; waits for it's completion
>   2. ABORT TASK sent to WRITE_10 tag 0x2; almost immediately the connection is dropped


I didn't get this part where the connection is dropped almost immediately.
If only the backend is backed up, what is dropping the connection right
away? The data out timers shouldn't be firing right? It sounds like above
the network between the initiator and target were ok so data outs and R2Ts
should be executing quickly like normal right?

> 
> The only difference between #1 and #2 is that the command 0x1 is past
> the WRITE PENDING state.
> 
>> With that said I am in favor of you fixing the code so we can cleanup
>> a partially sent cmd if it can be done sanely.
>>
>> I personally would just leave the current behavior and fix the deadlock
>> because:
>>
>> 1. When I see this happening it's normally the network so we have to blow
>> away the group of commands and we end up dropping the connection one way
>> or another. I don't see the big command short timeout case often anymore.
>>
>> 2. Initiators just did not implement this right. I know this for sure
>> for open-iscsi at least. I started to fix my screw ups the other day but it
>> ends up breaking the targets.
>>
>> For example,
>>
>> - If we've sent a R2T and the initiator has sent a LUN RESET, what are
>> you going to have the target do? Send the response right away?
> 
> AFAIR the spec says "nuke it, there will be no data after this".> 
>> - If we've sent a R2T and the initiator has sent some of the data
>> PDUs to full fill it but has not sent the final PDU, then it sends the
>> LUN RESET, what do you do?
> 
> The same. However, I understand the interoperability concerns. I'll
> check what other targets do
I think maybe you are replying about aborts, but I was asking about
LUN RESET which is opposite but will also hit the same hang if the
connection is dropped after one is sent.

For aborts it works like you wrote above. For LUN RESET it's opposite.
In 3270, it doesn't say how to handle aborts, but on the pdl lists it
came up and they said equivalent of your nuke it. However, for TMFs
that affect multiple tasks they clarified it in later versions of the
specs.

In the original it only says how to handle abort/clear task set, but in

https://datatracker.ietf.org/doc/html/rfc5048

the behavior was clarified and in 7143 we have the original/default
way:

https://datatracker.ietf.org/doc/html/rfc7143#section-4.2.3.3

which says to wait for the data outs.

And then we have FastAbort which is nuke it:

https://datatracker.ietf.org/doc/html/rfc7143#section-4.2.3.4

>  
>> - You also have the immediate data case and the InitialR2T case.
> 
> True.
>  
>> The updated specs clarify how to handle this, and even have a FastAbort
>> key to specify which behavior we are going to do. But we don't support
>> it and I don't think many people implemented it.


So here I was saying I don't think anyone implemented the ability to
negotiate for TaskReporting=FastAbort, so most might do the original behavior.
If that's right then we just end up dropping the connection for windows and
linux and newer versions of ESXi if that session drop setting is set
(I can't remember the setting), when they end up timing out their TMFs.
