Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 143E8C433E6
	for <target-devel@archiver.kernel.org>; Fri, 26 Feb 2021 16:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6D5F64EF3
	for <target-devel@archiver.kernel.org>; Fri, 26 Feb 2021 16:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhBZQND (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 26 Feb 2021 11:13:03 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54078 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhBZQM5 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 26 Feb 2021 11:12:57 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11QG8fuo025656;
        Fri, 26 Feb 2021 16:12:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=j2c6nkP6/u4k9ETWcLl3xP60IH69DzkoISfI+HRmgas=;
 b=UYWojmFQ3QusfA3AUqQ04OeQQRTQC6r4lfOfDNd9RXKCkDIEDcnjJB4SQ/Fm91ev7KSV
 IA1okPs4FLkVtYno8ziHDTSmK9Cf2sQJQRvlzCXbRsD6W8sescwYUD6p6AK4zAjzNPfB
 HIy9b2RPcV3Aw9c9R7Xp5wj/w4ioe1mAfozWKVohV4wCtB4l57OiibVIzWIMRk9Zxa8n
 PkUE8MPBNDb4HjRQy/Yjmzslysverqp+as/ESQjblMLVMB8XNeEfKxWpzKajMvjfh14h
 sxIUWZlf9FwT1VRSv3AZ4CO7P5BPmZ3leZK8NB0GTKKp2LSqk5Pswjvs2I0GyO5Xjmzq nA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36ugq3sckg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 16:12:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11QGAg1u111983;
        Fri, 26 Feb 2021 16:12:08 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by userp3030.oracle.com with ESMTP id 36ucc2t6b6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 16:12:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lhbQkgmKlrkG0CmcQf9YKCnEVXjYGw02OhjQs4CvHxFVOmuO2l886IvhPNmM5Qsktjq7LMjE7CORTi58KN0U2a0TG6dDcb0HVURBv4LvcPxoKzxAuVxDdbaxyUME0vvU+7e7Tq7EDDOC7/rHeqT0zr0p57M/evV8NWNw32+lu39V74JjyS7X3fEfTnexdxoMaLYwUOX4iNc4Du0GCC56FYZurizU2yk6C971hifTP/krlVpRylFUUuLouXtgG3m5SWfXTHPoOcHxcAeVPwluNT23+dv34HnGPkyJBPth1aZyRhkhGjoySwn/goUUmue2+/YI1DL79KfdnyE5xOY8XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j2c6nkP6/u4k9ETWcLl3xP60IH69DzkoISfI+HRmgas=;
 b=Bo1IerY1wJmB2HhgmTsgGEM35JqlONJC3SVIAwy+C9KDVvu3nNGvbXiEIcSW8JqHltafA1ejd7+oMBYNF4YvArP4W2VMOui6rr1x9QShuLalGgHpoR+II9KlUGX+DrOz7ns1659jIj8O75JSC98J5N+CUYbLY94v2hDxnR9DKFL5T/7Frqedp4mU36Ce3dHYzOULb59omPA8PCPjVMlwkZ2rOznLOzgMsuDGvQNkvw2IizZZ38ZhSYPuU9nYN+QWipJm3huFv08yDrY2dodLUum/txlkozjpMszZDk4JLIYOvJXsR2ivUr3D5y55J9V7exiPIWrzsqIS5nROZxSyOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j2c6nkP6/u4k9ETWcLl3xP60IH69DzkoISfI+HRmgas=;
 b=bnl3Aj6ZBSl1IV9e7Z9fBZp0pFVk0GPEiHTBBS7dTKPF1M+MtfqxMsgRj7IzdamDcTiq17nSGAcOVWfEnx/DfahnwDrrt1sNFs2Ca78FclxB/GjA7MU5FnYIFE6NO4H1/50DYA/qy+qfJNJfoRCcJCv1vRxCpxBthKAAmOyxwB4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DS7PR10MB5389.namprd10.prod.outlook.com (2603:10b6:5:3a7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Fri, 26 Feb
 2021 16:12:07 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Fri, 26 Feb 2021
 16:12:07 +0000
Subject: Re: Stability of FILEIO as backing store?
To:     Forza <forza@tnonline.net>, target-devel@vger.kernel.org
References: <af031d3.b2327dec.177db1f2641@tnonline.net>
 <b4397eb1-db51-7cf2-b881-88fe7bcfa7bb@oracle.com>
 <24226ad.50248908.177dd3502ec@tnonline.net>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <0d561b83-1bb5-aa4c-8adc-953036e2f003@oracle.com>
Date:   Fri, 26 Feb 2021 10:12:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <24226ad.50248908.177dd3502ec@tnonline.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR12CA0014.namprd12.prod.outlook.com
 (2603:10b6:610:57::24) To DM6PR10MB3577.namprd10.prod.outlook.com
 (2603:10b6:5:152::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by CH2PR12CA0014.namprd12.prod.outlook.com (2603:10b6:610:57::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20 via Frontend Transport; Fri, 26 Feb 2021 16:12:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b49f12da-b0d3-43c5-afba-08d8da714350
X-MS-TrafficTypeDiagnostic: DS7PR10MB5389:
X-Microsoft-Antispam-PRVS: <DS7PR10MB5389069E2EF06B534DAED487F19D9@DS7PR10MB5389.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VjEcnHf6KKGat6744eVCAqgrHFxiboVoDLUKuo4SIPoQCq/JtM+hQSTk530py3FCaJAIaptMS9dCMKMM+X5lW2DWgERd0u5B7l+uCi1peiq1R4/qsqFBWDwsunYiiw6rZB06rqSYK7TmmyxQe7tQWvtzhr/FL+yF1I4rkLIUUPNdJXipuQXIGvYStv4j/HtT4NAjZbznLNl4YGi+hXXkYYeyt7xOLPee6K0OYMmwH46byJTUSrlae1jNIwZy0bS8hBZvCdJ5eeNEZuZ9FJXiqI2Z9CvzDcHUtfx6pFxki8SQOVxk8kyG+77kDZzX8dv68t4DG+OMqzY1rQ81qtEjVDcGHcjotLv6btWSO2PaWsyGzSEC4TDXEpX9VaRiopkSz74a4UyIlCw3Sc4i6HC9Kh4GPYE80Aov+i55sLQqtSzFI/6I3EWUtbs72ch7nzobTVP3MiROYDgTpun17uddnZcE9oJnuNQtt0PhMC256g05SZsTl6nVjS7tCduyvN4lRLAVrNoNKlLv3dTx4vxaXPwIL8Dr2ETbWEa4k8PA8pNHj1cbb/wWLwPmR23BeKVx+qdYNY5JFbDpFnDecq1WatIUqqyIDiqFPGCMPSjwRnp5Vwa5MYTs0bDJDCs9ogbPUX4nR3BIw7gLFrvCHk4NZWMfEbTqe6aI9PZ3siB9J/vrD8FEDnuizA2iyoNFmA/QXKK3BTUBDStEMsqbsCONbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(136003)(396003)(346002)(366004)(31686004)(8936002)(53546011)(16576012)(2906002)(8676002)(478600001)(36756003)(86362001)(31696002)(966005)(316002)(2616005)(6486002)(83380400001)(66946007)(66556008)(66476007)(956004)(26005)(186003)(5660300002)(6706004)(16526019)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NW8yeXliUWpHbFR2Y0NGbU0yQnhsQldPSjVnUk43N0tYVVdZWGNHRml5WU1C?=
 =?utf-8?B?RllkTWNoWFVTak1FVlZ2TzBOUDVNaWZtWDVZYlJQbHF2Z2dCNTlYcDhvZnpa?=
 =?utf-8?B?TDd6UE5Cd0hMY2pMRkl2dEJsV3JGaEx6ZCtRcUVUd1lkaE8yNnB5bldXNEQ4?=
 =?utf-8?B?RVJDYnQwMldBQXZMSStLalZHWkRhcCtrOE1WbnUxb0Y5aHBhc3VoaC9qalMv?=
 =?utf-8?B?MnA0MTVwcmxNWSs1RHdKcmhTZHZUZm5Ub0pDK2srbklBNEtGTzNrb05NaTU2?=
 =?utf-8?B?LzRWSUlNMHBGYzJReW5JR1ZHNWtzQUFIeUhnNDFsMG9PUDY3ZjgreXNqUlAv?=
 =?utf-8?B?VG1MUGVnRTh2TFpEMTF0RkhMZUlzOFplL3dlSVlCVXk3WHBVOTZ6cy9iRFNM?=
 =?utf-8?B?OUNJS2xmMnZDZ0JLTDJkME5mSXpiaGVNd0Y3b0NSeHgvbGxSN21JV1ZURWtk?=
 =?utf-8?B?cXVVVkRUSVI3VUlvS3dTcEJjN29pV1pDcFVRN3NvdFd6WFJ4cXpvQjdlVnlM?=
 =?utf-8?B?VnFKdTJFWnA3MFB4V1VFUTVTblJFLzlWekUrM0Y3bE9saGkyOU8yaVJoWGZK?=
 =?utf-8?B?bjYraTl4QkVPMmw5a0RISUxWQTVUMW5GMHpCQVVSTWxxa1JMVUREUFhkY00w?=
 =?utf-8?B?RnVpVUcrUHEybTRqdlRVaXIwUVdKeUVqaFZrOFRPajAzQWNPUEkyV1U4V1Fp?=
 =?utf-8?B?M1pNM21MdzNsUnR6L3duZVNMdVc2bWZKRkU3QXFPUitVdHFFamliTlRnTktj?=
 =?utf-8?B?eWpzMkVkbzNiTlk4aDBvUDNQMG1DdHpYQWZYSkVuMHZ4b2ZMQlNMbzRxYW5q?=
 =?utf-8?B?bHpacTVFMkVyb0hmU2FlVk0vS3VxVzlKajA4TzJoL3FMaTRlQy9zNDRBU01s?=
 =?utf-8?B?cC9SZEFKVzduc01uNkdxT0VxVWlEcktYUGtsVUQ3WGNrMHdOdHczREx1YjZh?=
 =?utf-8?B?TWhVenF0NHFwcG5iOVd1OFVOcXRNMnNQeGxmTUpFaVZld1g5N2hUWXJuRHc0?=
 =?utf-8?B?L09Fd0F5bjROd1dZcEM4ZmwvSGplWnM4WGlUanFXbjV3KzZadHE3dk9nTkxp?=
 =?utf-8?B?QnRIQzB6ZnVaa0FYdytHK3JIK2JkZkxxKzllSVh1UHIvay9xZGZtY3oxMkhT?=
 =?utf-8?B?eTBBekw1cE1FRml1bXBXQ2J4L2k0V0pEa0pnbTNQcnQ0RkxSODNCbjU5ZFow?=
 =?utf-8?B?bTA0YWpoSXVJdmxZbGNUWGNSZ1dPUFpzb3BqNkJhUFNOcjlhcDRING4wOWYv?=
 =?utf-8?B?cGZtTDBSb3ZJQ2RJZFM3NUNMeGlnTS94cytaVzVqNThGaUh1enRFTkF2NEpJ?=
 =?utf-8?B?cEQ5T1ZZenYzVytSMFl6d0F2ZFoxTHZBYy9lVXlTdStDOGRiUjRnd2FSQWs5?=
 =?utf-8?B?a3lEVG1hZjByMWpOa2VsdWorWkZpb3dkUDlIeFhkbytIenNRU2RtbGIyOFRl?=
 =?utf-8?B?b2V6alhzS0dvbU4yNVFsZk9kanNxWk5LVFlxTUNQT1lGYlFsd1ZZK0luSVhC?=
 =?utf-8?B?N0hNcjlZVDRPa2E2MWY4Wmt4OWFQUHBCQnByUjkzcTNmeFRkQWh3TE1KdUtE?=
 =?utf-8?B?d0Fqa2IrR2ZTTDlVL3hnTGhKYWIvQzBXNGNZUkQ4MTAyK0p6aFFrS2pQeENR?=
 =?utf-8?B?dENsVkZveEpVdXE3WXgxOWdHQ2htZmVZN01iSHNYMVorbGZrNUFvc0x6TUI1?=
 =?utf-8?B?YlNqT3ZjeXZOeStoZ2pyUjlNTGJ6TGc0VFF1Vko5Z0lTYjRaUm1BMk1yWWtk?=
 =?utf-8?Q?yJrY0cLPvwnCsScodjVYXbqXNe1tiJyabNGQiBF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b49f12da-b0d3-43c5-afba-08d8da714350
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2021 16:12:07.0864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YLZTj991IOvZMMncJ8JA1vlyAnlLPnRkXDfVWS2VtJR65l/eMvijuhUFd6baGp05oGoSb+d5uIqpnw/8Y6R5Z0w3dRRs6Db5+MUHzTSxFBQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5389
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260122
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260122
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 2/26/21 1:19 AM, Forza wrote:
> 
> 
> ---- From: michael.christie@oracle.com -- Sent: 2021-02-26 - 04:41 ----
> 
>> On 2/25/21 3:36 PM, Forza wrote:
>>> Hi,
>>>
>>> I have a weird issue with using a file as backing store with a Win2016 server as initiator. 
>>>
>>> Very often if I reboot the Linux server the disk image becomes corrupt so that Windows cannot even detect the gpt partition table on it. It can happen even if I shut down the Windows machine before I reboot the Linux server.
>>>
>>> Initially I thought I would be write cache. But I've disabled that with no benefit to this problem. 
>>>
>>
>> How are you disabling the write cache? What tools do you use? Is
>> it targetcli or are you doing this manually via configfs?
> 
> I am using targetcli, using the documentation https://urldefense.com/v3/__http://linux-iscsi.org/Doc/LIO*20Admin*20Manual.pdf__;JSU!!GqivPVa7Brio!OYNbrN3Fseq8PE_-n67Mmb8_JdUUU_yWw_LcbeKvyKgKgP_iVH-X2u1vrU9RasK-Nvhz$ 
> I created the backstore/fileio with write_back=false but this might not have disabled cache sinze I see in the saveconfig.json that it is still set to true. So I guess this can still be an issue =( 
> 
> 
>>
>> What is the output of
>>
>> cat /sys/kernel/config/target/core/fileio_$N/$name/info
> 
> Status: ACTIVATED  Max Queue Depth: 128  SectorSize: 512  HwMaxSectors: 16384
>         TCM FILEIO ID: 0        File: /media/iscsi-tgt/dx_media_3.img  Size: 429496729600  Mode: Buffered-WCE Async: 0
> 

I think you need to ask the people that maintain your tools (fedora or upstream
https://github.com/open-iscsi/targetcli-fb), because for upstream's master branch
it looks like doing write_back=false should work, but above we see "Mode: Buffered-WCE"
and below we see emulate_write_cache=1 kike you mentioned.

> 
>> cat /sys/kernel/config/target/core/fileio_$N/$name/attrib/write_cache
> 
> This does not exist. The curent files are:
> 

Sorry, I meant emulate_write_cache.

> # grep . *
> alua_support:1
> block_size:512
> emulate_3pc:1
> emulate_caw:1
> emulate_dpo:1
> emulate_fua_read:1
> emulate_fua_write:1
> emulate_model_alias:1
> emulate_pr:1
> emulate_rest_reord:0
> emulate_tas:1
> emulate_tpu:0
> emulate_tpws:0
> emulate_ua_intlck_ctrl:0
> emulate_write_cache:1
> enforce_pr_isids:1
> force_pr_aptpl:0
> hw_block_size:512
> hw_max_sectors:16384
> hw_pi_prot_type:0
> hw_queue_depth:128
> is_nonrot:0
> max_unmap_block_desc_count:1
> max_unmap_lba_count:8192
> max_write_same_len:4096
> optimal_sectors:16384
> pgr_support:1
> pi_prot_format:0
> pi_prot_type:0
> pi_prot_verify:0
> queue_depth:128
> unmap_granularity:1
> unmap_granularity_alignment:0
> unmap_zeroes_data:0
