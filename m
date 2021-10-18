Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82669C433EF
	for <target-devel@archiver.kernel.org>; Mon, 18 Oct 2021 17:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 648F2610C8
	for <target-devel@archiver.kernel.org>; Mon, 18 Oct 2021 17:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233872AbhJRRLB (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 18 Oct 2021 13:11:01 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:31134 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233828AbhJRRLA (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 18 Oct 2021 13:11:00 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19IGP9Nj014675;
        Mon, 18 Oct 2021 17:08:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ovg+u6wqMeFoPrBG2G33GFDsRS5YpmfuplTVOniPNPo=;
 b=jNMQWFMWYJwtTJ2AT3ANQlikw1CNHh6DBnuRi1gg7floQOEB0ME+KmePKNH7EKnBeRUz
 xoQj/XET642pQEwnEuE1zdnuvsLnC88O47z6THOFd5aQGA7fgGofZ3xxwCwToR9LZkVp
 GLRA3MT9VEh6/qSDB2woUUS+w9nTFBHYRwqnoAG4fr/m/mxumE8oBIrOscrL+q4Cg8q6
 fURkGTeO04kn2FisV2lArdsCO+4ve6oEy8aob2exzImUQXiySrfa/ylxposS5FcBCfxV
 H8V+I0DxDSuXpSZwbKPDHhO9W1NDfC8iyqQjsju9w0anSqc93rHXBLQyW0D1jUJGdx+4 RQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3brmkyddje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 17:08:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19IGl4Pp184477;
        Mon, 18 Oct 2021 17:08:30 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by aserp3020.oracle.com with ESMTP id 3bqpj432kg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 17:08:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WKqydm5mm8YMfYypaj90Ue/D4aK7T9q2DyHm5KOI4N3smD9FDbcYsFQRECvUzSzih1spawwrueZvhE/jxmupciU8rJrjl7Kv5iE+J1PwqjGkoX6MbkpZ3Q6kgGfyb+H62JCGXe8gahvJIZhDma8G6ZpEC7DpHknIAJQPUE5BzDimP84ZjMb1KpMTQ6LU8FN7ehcjOTUu6ADOeW7rgOqWMI+oO5LEJvpIY5j2s4G7MMB0IhXHdC1CGQ6ThmPtHT9V7BXoQpBrcsxH2/fZGUFVJqJsDsV4cBgjKPKUpMVFHjfPTOeMdoLkTRZKq4BVSmSNZrIIldnW7ppnYN8F1qMq5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ovg+u6wqMeFoPrBG2G33GFDsRS5YpmfuplTVOniPNPo=;
 b=BlIcvQM9w/bHvH1Shrj/HFZ9cDEHEF6FQHZ1GQZK86Bee/H4P9gxvwly3wyz3QfjqVy8WA6+UG82KAbQYIKGHfO7GoW+83ftKiccvouCbwOFhSqHU+uSgqdzqR0cT5oClb9JlAapP8ok1eSICJa9Xuxm/UvPo9NYRConQ0dUUH22nbmtRmh8v6RknYHQ6fO7jTIxNMhnP9yAQfBQuxsZFxEyRnJ3MWoHnZx8Je2sswrd3NSZAreGk+K85XCBmNYI5vbj73afNMh1mvo7gb6S/GF7HXZvQ6HTQ+uXhGiK4r/FTIP0Z/SWw+vVLLdNqww7fgtrjL3Ps02TwzEoPp/TGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovg+u6wqMeFoPrBG2G33GFDsRS5YpmfuplTVOniPNPo=;
 b=HgWp1GT5vtRJPCaUY1BHbuejZOtWgwqARi3dXpZNHiUOU4ayaUJiG9olR1GzzUsNEBAQW4mpBfgxYz8C1KPVwX9MMreH6HIsPjaesWWxGUXUP6uASFN+x6twWadHk/gQOUhazejeIEE08dBL7gkyUg44xEB391EMgKAC8K4WMqo=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5280.namprd10.prod.outlook.com (2603:10b6:5:3a7::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.18; Mon, 18 Oct 2021 17:08:28 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 17:08:28 +0000
Message-ID: <e4754a5e-9c40-993d-d21e-e566f0cb244d@oracle.com>
Date:   Mon, 18 Oct 2021 12:08:26 -0500
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
 <6059cfab-5cbb-984b-7efc-eb193bddea7a@oracle.com>
 <YWcsWKIn5RyN+UbD@yadro.com> <YWcs/8CQYn7C7G9T@yadro.com>
 <e76e1a95-dc88-ac9a-62b0-89533182aafd@oracle.com>
 <YWi5YumbN/Zzze5h@yadro.com>
 <d5035453-f35f-0ecf-d830-18c6b3040c97@oracle.com>
 <YW1g/OFXMHq44CYo@yadro.com>
 <2318e7d3-84c1-e5b0-62ce-dd25a21d3476@oracle.com>
In-Reply-To: <2318e7d3-84c1-e5b0-62ce-dd25a21d3476@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0191.namprd03.prod.outlook.com
 (2603:10b6:5:3b6::16) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DS7PR03CA0191.namprd03.prod.outlook.com (2603:10b6:5:3b6::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Mon, 18 Oct 2021 17:08:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39472f3c-3d29-4a2f-1d1d-08d99259e753
X-MS-TrafficTypeDiagnostic: DS7PR10MB5280:
X-Microsoft-Antispam-PRVS: <DS7PR10MB528020A6404C308ACC045BF0F1BC9@DS7PR10MB5280.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a1qlcIui44VcnaNWECKWh8PaOZZky/CmFmGBl85dRAIaO6kCfo56OGabwwGlrMiudevdCpJFvsMniCROsApifbEWmdsdmFS44tsHB6Qezl3tC63n+0vOfmjnP4WOU3SuE7PpBsPYsZH7wcNYLkHmOCAwR46NV3f8REtf6IQ/fyDg016ynJvWUEDglm3ykmE/vLYhUNcIo2CAYESfsZyGFK1/vBtCcPlcODNefiWrYVj6gxROiQqagDXfipECh+sZwZ7Psculqcaq4rKqoWyVbm3yMlnzOpR0X+on8SMmteeKIiLX1j+PIAwp8OAkhcEvGLLMC00P6FwYgs7+38qamNs/EnPHfoyvT7d1Bm1u4drvUZvgXgAEm3t6y9SjFSUfPeMq+qUiYY+jqpzheIe1DYH7/zodohG7vfrow2BgRJxc6OXPsEMCM0PQu3at/aky7luOVSJ7boPdRRWclm2OOZ7pBg+tQklCNDwrvc7fW88zSBPtbWl9AqQR5Ur92b9JaaDwQBKDJB3DZJK5K8WRqW7PUmb6qQcjQGJtdxhNokcJK5qVIgmVa/6KHVuWM+TKpYGgGlTwqJFRpRjv4KGJmTEVf9pNiUbl1qjsm3seJPgFyV+9dpb5dHIBywXbOW1b+jxpjo9FQ/WcSo1Tmsqpdo+g3dbB0T3GMFVqX6o8kc7SZPhosRM07vVXsKJT01KKeFQVJ9DMo9zuM5iy+cKYf4o6OS0sss82VIyOC8Rs+R9Yrh+4XX2Z5nK9BTRz5GCwLXKK6uSmx32jv1p0DtpkRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31686004)(16576012)(316002)(38100700002)(6486002)(36756003)(6916009)(6706004)(4326008)(26005)(8676002)(8936002)(2906002)(5660300002)(53546011)(31696002)(956004)(2616005)(508600001)(66946007)(66556008)(86362001)(66476007)(186003)(83380400001)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGs0Nk5NRFlGU1EzQkw5czFGMVhTWDN2a3V2bXh1VVRMN0dTT0ZwdWxYMlFZ?=
 =?utf-8?B?bGd3Nkc5cllRNXFlSUZ0dDEwWUZpd1FvdlM5YjA4RjRXaW83KzBFVm5Db25v?=
 =?utf-8?B?ZERjL3FLRXdROFRXaEpnV0RZVElYMC84MjE3VTU1czdYOGh4eUhjTk1JKzA0?=
 =?utf-8?B?MWpoZE9KR3dPZnd3Z2xVME1VU3lOaXBObFVLdGNIVGNNNzdNeVhQcnNJSGNB?=
 =?utf-8?B?bWI5UWtZOGVIb1lGbXVOZGx4Ym93MnZlbFRtOFh2NFg0UytJVkR1RkVySWxI?=
 =?utf-8?B?TG4yV1JNL3NXWDdCeVFqbUZiR0xjNmxkblA2UnZTZS9BdjA0S1hGeDh5RjBO?=
 =?utf-8?B?RWZvcFVTREVGZWpDWW80ejI2WVZQNGFueC9iUjVhNlg2RUFhd2Q5Zjg5WjBJ?=
 =?utf-8?B?UE5CZ25TbTVGOGhZQnJNQTRCTDUrREU3c1IvWm9JZFRpb2w0WExGejVuQlI4?=
 =?utf-8?B?RUdGcVBtcGMzRHFnUWo2d0J1R2xrUzBaVnpZYmdGbEVwRlduZnl0MHZyVVpU?=
 =?utf-8?B?MkJBeHBwN0dKUWJUQ1c4cVRPamFLRmk4UzRpOXVubXRLUFhtbWlwb0daUThi?=
 =?utf-8?B?L3MvL1NpMjBLcXNnZkpXS2NuWVc4cGxrZnNZME54N0MrU1UvZnV2THR0Ykdl?=
 =?utf-8?B?SGpmSEhXSXhHZGl6WXdTMHNZTGh1a1FXSU11TGJmb0hSS3pzYncrYllydjFq?=
 =?utf-8?B?ZnA1UkRWMU5HVmc2U054ZjNMZFMwaHZkaE5NekNudWx3c3NHVUwyV2hMRmM3?=
 =?utf-8?B?SnRzMnoxT0QxOWMrMyt1QWhHUmVOUkJPemZuZ3JXejhOWC8zVk9xVTV1YSt4?=
 =?utf-8?B?K203NWFMQVNkTXFsaXNSMHI5ZXBXclRLMFlSTi9yWVBBRm5IUHFiVnVyaWVM?=
 =?utf-8?B?UDQzZTUvd1htMm16SkV6cU55N0xsbXF0Zk54VVJzbVgrNTMxcmRhVDJXS0d3?=
 =?utf-8?B?QXRzdWZoZTF6Smx0dWdIVHoxZEtLYlplU0pjMDBDWE14aHBHbFhQUTRqbTVs?=
 =?utf-8?B?Mk55WkZwNnNrTVJxOWtXK0NpbE9iR0JMaE4wNVdyeU9qajNOSlI4MDYybW45?=
 =?utf-8?B?akJKVFJBYlhOOU43ZlB2RENKQldkRmd3ZWV3Z1pacEE4SHVLcHZRcWowcHVE?=
 =?utf-8?B?dlV1eFJJL0MrZXMxS0o0ZFJaNE9DRU1KNExrbGZrcGpxRWdqdmJRbmtlNUor?=
 =?utf-8?B?R3hKTnhpSXYybW0vOTdYZVFHWlBoYkxPdUdSWnc1TEtIWjFEVHFxdnRTVFUv?=
 =?utf-8?B?b3UzUHo3OVpIR3pacWlpa2ZNUURlWjhMTmNKNk1HaGFIejhqME9ZSUQyQUpM?=
 =?utf-8?B?bFJsMTRTcVlQVzJqSzFwakZweEt0ZkZwd1V0Vi95R2QrRWZ1M0lLb2g5K3kx?=
 =?utf-8?B?SzNESTlOa2RmY2lheXdZeVE2RVRWdTU0dkZRU0VyQ2JjUGlsUUp1REQ0djJP?=
 =?utf-8?B?WE9Zc0N6eGxKbEIyOGVUbU9KYlZOYTZBMGpYSGsrZ3VwR3pnVlBlc0VTRUxs?=
 =?utf-8?B?RHY0RGdVT0QwRlhRdVMxOHVteGRaZmE0dS9TVmIzbjh4VGhsZnBwKy9ranNR?=
 =?utf-8?B?eVRDYjdRM3J2TTNmTElCQUJJRHIvZVdWZHlUZFNGc1p5TGVsaXVNeEw5NUN2?=
 =?utf-8?B?Vk9QQnpvTTZ0cVJnUHo5TURoWmUyNVc2b08wbEJEbXVJZG9aazNBZ1JGaVhX?=
 =?utf-8?B?SWtaeTNxK0F3NlludmJnaEQvMjREWEtXbU9UcG9neEdQZjE1V2RxMUsveUxs?=
 =?utf-8?Q?mmsCnw/2swgkI9vzlv/USwMoREIDg1YkboSDomu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39472f3c-3d29-4a2f-1d1d-08d99259e753
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 17:08:28.1833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vzE0/XXSyo0/18xPXMNsExYdz22zGroleeXbaGs12qmdP58i3IBTHP6rBSgWjtBybKQVxiUhFJEE0ibHC645o10rU6K+P1E/J7CpBE8pZ58=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5280
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10141 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110180097
X-Proofpoint-GUID: mRDUV1aNPTFwgctmj56dKgYu7IaBEzuG
X-Proofpoint-ORIG-GUID: mRDUV1aNPTFwgctmj56dKgYu7IaBEzuG
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 10/18/21 11:29 AM, Mike Christie wrote:
> On 10/18/21 6:56 AM, Konstantin Shelekhin wrote:
>> On Thu, Oct 14, 2021 at 10:18:13PM -0500, michael.christie@oracle.com wrote:
>>>> If I understand this aproach correctly, it fixes the deadlock, but the
>>>> connection reinstatement will still happen, because WRITE_10 won't be
>>>> aborted and the connection will go down after the timeout.> 
>>>> IMO it's not ideal either, since now iSCSI will have a 50% chance to
>>>> have the connection (meaning SCSI session) killed on arbitrary ABOR
>>> I wouldn't call this an arbitrary abort. It's indicating a problem.
>>> When do you see this? Why do we need to fix it per cmd? Are you hitting
>>> the big command short timeout issue? Driver/fw bug?
>> It was triggered by ESXi. During some heavy IOPS intervals the backend
>> device cannot handle the load and some IOs get stuck for more than 30
>> seconds. I suspect that ABORT TASKSs are issued by the virtual machines.
>> So a series of ABORT TASK will come, and the unlucky one will hit the
>> issue.
> I didn't get this. If only the backend is backed up then we should
> still be transmitting the data out/R2Ts quickly and we shouldn't be
> hitting the issue where we got stuck waiting on them.
> 

Oh wait, I just remembered the bug you might be hitting. If you
are using iblock for example, then when the iscsi target calls
into LIO core to submit the cmd we can end up calling into the block
layer and blocking on a full queue (hitting the nr_requests limit).
The iscsi layer is then not able to do its normal R2T/DataOut handling
because one of the iscsi threads is stuck.

I'll send a patch to fix this issue.

We should still fix your TMF hang issue.
