Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 993A7C48BE0
	for <target-devel@archiver.kernel.org>; Fri, 11 Jun 2021 18:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75AAE61285
	for <target-devel@archiver.kernel.org>; Fri, 11 Jun 2021 18:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhFKSnr (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 11 Jun 2021 14:43:47 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60760 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbhFKSnq (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 14:43:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15BIY2PL194110;
        Fri, 11 Jun 2021 18:41:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=kpY56hoAD+y+N/GjSBDFZT0TFsojGuwWJ7Da7H9aen4=;
 b=AyCKxI5nB81h/8fQyyV9aREtvEBar1UtfM+hcpCNyZqj7WGe0TnIXvdLAp6nIxQwdoh4
 WmqEPkoLBHOXZ2BYDAIbgFdcUFV+JDwaDiR0Q98gHeDEVpFKpE9t0n8cAgUF5ClB9BJf
 Fp+FtQ8AJo6qJbdnLGXYLj0WVo+Aj1WWkAtELTW/bIAqkRTpLys4GjmCZjI5uddlSuBO
 fKFKrNT31TPnZbqhpCrvdU3prUC9mhTrx9PAiBc7DFEzKYTwOvYUYc3xCv5LwzSTVY33
 jKD92IUIGu9MhcyN0FO+OB/b9uTuwJsY3TtZpFGyCs+vsDR605UGmfgL1Cx5GLEuvqgq qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 39017nqepk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 18:41:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15BIb07a043681;
        Fri, 11 Jun 2021 18:41:46 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2047.outbound.protection.outlook.com [104.47.74.47])
        by aserp3020.oracle.com with ESMTP id 3922x39hc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 18:41:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mqw8rC9dnKvFynZK/rCKLwqt/2xdhPzpUqCdDNwP78aHZNcl5vbwJ827nDnIpCVejfcoPM9jrsmp0Ez0guKxveGUcrtk4if/JoQV8K5HO67ibNu/nPHnoaa4hAgpau+GydMxYfQMTNWDbaz/OI4WW3LSFg+lZUT8U3gd/hOB7pdHdP0R1SMkmUYTT7tn1WPrYS5bGS+WoBAl3ZGOVRoHRKmMR15ejYlLp3mH5p32lKsGGvfXz/8kpFbYizgdr1WxsjR+S/KT8gtXPoGFFt5Sgnpq5I9vpD0tpChQ2XhPu0RH5f4EykLplT7UpaSVtQ6gB7Phxe/lOPXCzD2AruClDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpY56hoAD+y+N/GjSBDFZT0TFsojGuwWJ7Da7H9aen4=;
 b=ffFepx9FtMfDnWejJgx5QNTd6JQFVdDKNy0gC39vrfkbLUZR/RtLEHJhRELo/aPQfWaQH80IrPTni/dtpU2NkiXCdpZQEv6sJZSbZDBXqW/xmKJ2/y5lUzwpqG4NSnOAJ1qjsTJ8I2TlfwybjPJvaLBCyuI0fseEUl0GH4TcYcsHJ09mOFkOe/BZY6qtyjJ36kPJx8SvoEQoM0SzLICT7zkWqTWobcg9Hj7bZn3G8ga7nT26J40XWw8gYxqWILi0msqBjeq6LzGx04u3/bMO0lcYREcdpKIoDAvUH14zd+XN8OFYpV0Ff1XclfL0gaRUYvSt7N0+vXVL8O9GhFQgOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpY56hoAD+y+N/GjSBDFZT0TFsojGuwWJ7Da7H9aen4=;
 b=UDtAgC+tjzCSZ4TUopEblJcs559pDsUThdxwJLBNDLZgUUhl4PE5qgjmHqiNct36RV+Pn1my68l9ASQKcvj4+1n+B/tKj2SBe6tierkcBl/KEcceushi25/cW3y23QIreKzwTsHbcNd5HlKhDWZZkgj1QNfYSmoJLV79BvPeCkY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4274.namprd10.prod.outlook.com (2603:10b6:a03:206::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.24; Fri, 11 Jun
 2021 18:41:42 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4219.024; Fri, 11 Jun 2021
 18:41:42 +0000
Subject: Re: [PATCH] target: remove the auth_type field from iscsi_session
To:     Maurizio Lombardi <mlombard@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     martin.petersen@oracle.com, target-devel@vger.kernel.org
References: <20210608164047.128763-1-mlombard@redhat.com>
 <YL/5074knGDS2Ska@SPB-NB-133.local>
 <CAFL455=Bi5aAfJtjpM0xzWdb4xoKW+JfnNO_2NJ2tvBQGfM6-g@mail.gmail.com>
From:   michael.christie@oracle.com
Message-ID: <c9c56f0f-2b50-3de3-f4f7-f5d2fa664a40@oracle.com>
Date:   Fri, 11 Jun 2021 13:41:40 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <CAFL455=Bi5aAfJtjpM0xzWdb4xoKW+JfnNO_2NJ2tvBQGfM6-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR07CA0120.namprd07.prod.outlook.com
 (2603:10b6:4:ae::49) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.12] (73.88.28.6) by DM5PR07CA0120.namprd07.prod.outlook.com (2603:10b6:4:ae::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22 via Frontend Transport; Fri, 11 Jun 2021 18:41:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84107e52-0679-4046-2753-08d92d088e7c
X-MS-TrafficTypeDiagnostic: BY5PR10MB4274:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4274C4941B051806F078062FF1349@BY5PR10MB4274.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z7lIC70Vwe7oDt4lHlGFn2vrec/Nvwf6io1pgVjEwOwo3aCxVSKNL7i8HRJuILFFPcw5lshz9k0n9Rkdf7+XysThA60E7evQknvSSsslYdknXbVT9IyyVfQkoH+5WRu5141cMyXUl8m5k6SfNVDRZ3bJKL8JjPUfLdG3oF9tT5EBW1pZ8R+oxXoSBBTx94TDWCWIQ4EIdRcxc8qwKcf+Rl2/q2JkF6X1hRRftD8qMzr5e2QQR/y0Ow7OEU3cAYIcKFCAuNYdJ1UpibmOuP4ozXnAKXms1lKbQLcTJWqLxr8EQ5j4bNrZVAz3TNzKIzqF3R2Ki1yKOtCNsee9Z+c7/hCd4WeFdD4UaTIeAmvhdBIkeC/jN3IVoS3oXPyJA1Mhf55JvLGUc8N8XvLOZRG38hTRtq3kfgb/LysXtkQXh4OJCOWTXIN0fFpkfOxJDe3oDAZdDSWBarY5fQSkHDHHlguL1ewuXaw24ktsZz8G2hdYlqiTiGmTJ3j1zr/lz72x1+g1NujfuUaV5fTe4aqRe12nHfk3g9xTC1X3q8L+dPTkhDgM6nrMQath6D0LQueTfFSLz37XSNJODs3CzLdmTz/hlpfN+PIG0UT9zWMagNpnETrkY9C5MfxD1mT0tngAdL2ZvmP0qqemV7J9L5VXGzsBxWx9jSNfz+H4UVz9ZHSO1QM3RGn9Jcp88HpMfnCu2v3BKYl49xlwlvQLDKHWRcSaiH+IyedRdmAJJSdQBz97tlvISPHe7oKHTXRLYeot+A0sgxijvrbVLs0VR1hXqT+laTYMEfPpzl3/pnP73L8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(396003)(346002)(376002)(8936002)(5660300002)(9686003)(2906002)(16526019)(186003)(956004)(26005)(966005)(16576012)(86362001)(4326008)(316002)(53546011)(6486002)(478600001)(66946007)(6706004)(66476007)(38100700002)(66556008)(110136005)(31696002)(8676002)(66574015)(36756003)(2616005)(83380400001)(31686004)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2tpbXk0L1N4WnNnSjQ1bFZUV2p5dCtQaEw5dXdSN3NCNW5YYU1iek9VSEFi?=
 =?utf-8?B?RkhZaXFNZnFGQktKNmhXcmZVZ2VHSnlRTXJxcTRYbDBGenpjUWxEcHk3RjhD?=
 =?utf-8?B?bDlMaWdmb0RITGV1Y01GSlUrekxpam9WWmJQMUtqMzlUYk5jTy8yeUZQaEZE?=
 =?utf-8?B?VVhqcmxhRW53TnB6ditSakQ3aE13RFYyakFSWW8vb0gxaUpDN2hOeHNVTjFO?=
 =?utf-8?B?M1ExRVBVMXdKMGtCVlVibzlaSUluMHdPbHZtaCtsQnQ3ZHgrd2pjSWVuN0Fy?=
 =?utf-8?B?dHVERmpGSk50QmM0ZS9KTHZ3aEpmUDA3N3Y0aXUzTmwyRmcrOGVBZ3MyNHR5?=
 =?utf-8?B?RzdJT1NOdEUzQ3E5cWxIeGNMN2pzU1I5TEZjeHJ5OWxkcEtVSENWdzNOc0JG?=
 =?utf-8?B?YkZQbGZpNHVWUkRqWk1nVXFnY0czbzJpR3JONG5kQ1EwY1VucUp2ZVBTU1pN?=
 =?utf-8?B?R0wrSHg0UmtINkFRdjU1MEh4dGZLUXdhb2t2YXBrampGa2hRUk0zU1BiTFc2?=
 =?utf-8?B?MlJHT2xyVktVcDYzMkRyUURLUm1OWjRaOUNoUk9rSWVrRWxxdVVTdHlUanQ0?=
 =?utf-8?B?aHUwcFExRFlPUWlqazhaZE8xQ0ZJTnB5M21uNDVHSzdPTDgrOFl6MTcwVUhR?=
 =?utf-8?B?b3lBMnBKZ3lxd3VpOUNIemhWSE1jdTVIZGlnbktpQ2ZZK2JXOGNPRHBHclo1?=
 =?utf-8?B?MXZ3a2k2bDRkSnB1OC9nckZGcGhsMm5CZ0dYZXhxYWRGd3JFWnRpcHNuS2o0?=
 =?utf-8?B?RDdDa3FKUlMxejlEOUtLU1UwL0kvZldxRTZYdnFCeUsveWNXWGM4clN3SGxH?=
 =?utf-8?B?UVgrc3pOdDBMVVI2YTN3THNQc2tnN1pRWFN2Sjlqdlk3WlR1TVdPVDFGcVg2?=
 =?utf-8?B?YmFBZmx0Y0JKZWtWZHJ3dmxnM3MxRy9BZURNRGRuTnEyaVB4WHpHMlFmTTk5?=
 =?utf-8?B?dStVVHFKQzIvT3RqdForV3pDdytUanNUMXVYa3l2aDRNNEd5WGUrUnhicWRQ?=
 =?utf-8?B?VHpvdkh6NjJYdmdRUzlKVmFxdEdXeWV4N2VxZ3VGT21GM3JWRHNMSEozdVBG?=
 =?utf-8?B?UVRRckRYczVRT2Y0RUNXcW9nalF2SDIxekEvb0piQk0zZ0hKRHZUS21OWUFo?=
 =?utf-8?B?SC9tajZJSDZjZXZxTEx2K2xQMkx4NTVYaStCcUlMYmNoOXhLdkk0SkRWaFVr?=
 =?utf-8?B?UFdPSSs2SFRXMC9wZXoxZGxBNUJmSXVTUmZOdjFpaE5mcWx3d1FOK3pSOXZy?=
 =?utf-8?B?VTRObUVYSjI3WENZMjMxdTcvNVZUdnJ6RFVWYXErSllUWWI2N1RlSlFhcURa?=
 =?utf-8?B?bjliMDBVcWZnNFZQZmJSSm5zUHRKc1UzclFpRVdLZXgwdGxJV0FWZElsaU45?=
 =?utf-8?B?NjlGYlJDMXhDeTltL1N5MWc3UUJVQ0EvZG96T3A2dExCdkFzS3hKdFhBR1A1?=
 =?utf-8?B?ZE53ZUlUS1doK2loKzVUNXkvTG85WW1sMnVEcFhRd3lVWTJCSmhMaFI5VnhO?=
 =?utf-8?B?WlhuSlloVWxoQ1Q5NkZWaUFHYlU1dGhyTGgrU0h6TjdaRDdkb3FXenY3QklW?=
 =?utf-8?B?ZzRlSFJ4SFpXZnc2dCsvZ05CVEtveHgyWXpVWGlTb1U2YWR5YkdlWHFwUDEr?=
 =?utf-8?B?TjZUNHlEWVlHSUlnMkVXNURXYUY2Mm5WaU5HdUc1aHNXemhlcFFIVGVod0JX?=
 =?utf-8?B?bDJvYXZCUU4rdThob3pCSDdkSGhJbjdqRjNoZVVpQ3RaM2l5M2FoOFl6VWlV?=
 =?utf-8?Q?OZu7vPjLhJKWYKkDgTxZdB94mssSkMWlyQXtfq3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84107e52-0679-4046-2753-08d92d088e7c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 18:41:42.6043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HmmWicbEE81CR50RpgDW7OVFzLlKg9FpwR/uTm525EBSemoQ3vthtvhPuBOet7NQ4J7nir06IKJd9ziwZ0IucrB++OE2nFRm4BJqC2Cy5bY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4274
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10012 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106110116
X-Proofpoint-GUID: hLT4xDUlHIsXZjhvCLUqu30KJ5u6LTfV
X-Proofpoint-ORIG-GUID: hLT4xDUlHIsXZjhvCLUqu30KJ5u6LTfV
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10012 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1011
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106110116
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 6/9/21 5:22 AM, Maurizio Lombardi wrote:
> st 9. 6. 2021 v 1:14 odesílatel Roman Bolshakov <r.bolshakov@yadro.com> napsal:
>>
>> Hi Maurizio,
>>
>> It might still be useful to carry the meaning of "effective auth_type"
>> in case of complex auth configuration. Otherwise there's no way to check
>> what auth settings took effect for a particular session/I_T nexus.
>>
>> I think we should rather print auth_type value someplace in configfs
>> than delete the field altogether.
> 
> Ok I see what you mean.
> 
> If acls are used, identifying the CHAP-protected sessions is
> trivial... you just have
> to look under configfs /tptg_1/acls/.../auth and tptg_1/acls/.../info
> 
> If dynamic sessions are allowed and the tgt parameter AuthMethod  is
> "CHAP,None",
> you could end up having some initiators using CHAP and some not...
> AFAIK, in this case, there is currently no way to find out if a
> particular session used CHAP or not.
> 
> If it could really be useful to know that, then one possible solution
> is to add this
> information to the "dynamic_sessions" list in configfs,
> but I'm not really sure this is acceptable because it could break the
> user applications
> that rely on this list.
> 
> Another solution that comes to my mind is to create a new configfs
> node "sessions_info"
> that contains a list of all connected initiators, their iqns,
> authentication method etc.
> but if the list is too long it could be truncated (attribute's max
> size is PAGE_SIZE).
> 
> Or we could create a new configfs directory "sessions" and each
> session would have it's own
> entry there.

I did that here if you guys want it:

https://www.spinics.net/lists/linux-scsi/msg143621.html
