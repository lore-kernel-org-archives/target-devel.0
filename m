Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA3AFC433DB
	for <target-devel@archiver.kernel.org>; Fri, 26 Feb 2021 03:42:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88B8A64EC3
	for <target-devel@archiver.kernel.org>; Fri, 26 Feb 2021 03:42:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhBZDmA (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Thu, 25 Feb 2021 22:42:00 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42340 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhBZDlz (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 25 Feb 2021 22:41:55 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q3TNla135622;
        Fri, 26 Feb 2021 03:41:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=6F2Bsg2WI7k/Ew2gjQuwDdFMPu6hvrmeJ7KbJHSK4ts=;
 b=kFculOF4shFrMCzPMLhMoh4zsg/4F/kXuo6jARTXPJfp/o0eA/ryJYeOibwgISPg6skv
 NIrVMpbF0ynnKNNM9Dq2PUJTHEhvtbQvhsSPH9pL1pdYaCzNKiugtaNVq2oNEkhiqvF+
 jXoZr12xKxgqOAa6DQ15/7Ma6Gigihk882AoFFSqj2jQVhh7wwODifxG3i5+hM+1LfXI
 qs8MUs9M4PZdT1vIPRYLXLRqZQX6PipPSTVzcMQwt60wr2sZwPx5Z3QQoEblKbihnO0S
 vybfQ1Vm7LKG77euigmY0CbEl1P7CZNrqc46LiLTZbRrZzOkZhXBkwcYcQQK/gyuObJP cA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 36tsur8msm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 03:41:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q3Qm40152530;
        Fri, 26 Feb 2021 03:41:03 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2050.outbound.protection.outlook.com [104.47.38.50])
        by aserp3030.oracle.com with ESMTP id 36v9m84ff1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 03:41:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBsWUI2WVGUam4Jx8RiqLwCBaMBVxQBHRuTVmr/vRElQqv0Q6DThykZQx6o1dCk2p+0w/456lOkpm1qdyeYFMDDYRC+n+tW3GQvYQ3o65F1U14q4qHdHgACD/xZBiEXU7hiJ9Vkcu4971WVTUvj4aPNlT2AaycDCxlTXf0V/nEY99JAUInBXLrqEaOYMZLGEHBTwqYXy3jCVwJQZT8npODRDCobw6PcCpSVTTuv7oFBmar+5X9e2p9h9jZgftdQrK1/A9Ve71kHSBW+9jg050R/ch0E/yybHPExFD/DMtT17u7jsI0yakPuG6JFlJNvC27hwHlx2bYW7QgwmrclIFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6F2Bsg2WI7k/Ew2gjQuwDdFMPu6hvrmeJ7KbJHSK4ts=;
 b=ay8yRpYD/l4taHSoNVcy205EhDWyfXClxxf3SmsB8xd97itj5x9/jLOi+Mku6xFGbdbAtnOj9o/P/ZMiRFt3Oyx8IAUwZpr7/GBw5JwkJidLaZnGg/6c/OiBuyVYs1CrJV+vjBbxxiVHcCBKJoXuoweFgcdqgotBttzNG2dM6/QDp+RKcR1A6SDmM39HHSe7hokGAv/egsSxZVKqk7EBD1g5HBjunZ+bcO76KqaSL2XnuNL2Te9qaXR2UsJ78blCP7pGxaIXQ5IXQHL9MOuKIkb8ZSpiNDoNPZIAHTJsRfksjDuUjXo3LUs76cvdwEv695nytcBVSIlgvfla8NLqCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6F2Bsg2WI7k/Ew2gjQuwDdFMPu6hvrmeJ7KbJHSK4ts=;
 b=rqlPBladXi0WnyuOf8qvIoiRG3BB+eZw/n/t+2F8ygkJd+T200mZUgQlak5NWumxL2CUFWuWhqMB33JjmQXR4RiFmzEmCunf0ypLFxs3QTHc76f/rdIdH6xjL1Xu3tyEmrYsQrQIz5fXBBMzzne/jon25GeKLbcShV+a+l3am9Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM5PR10MB1516.namprd10.prod.outlook.com (2603:10b6:3:7::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3868.32; Fri, 26 Feb 2021 03:41:01 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Fri, 26 Feb 2021
 03:41:01 +0000
Subject: Re: Stability of FILEIO as backing store?
To:     Forza <forza@tnonline.net>, target-devel@vger.kernel.org
References: <af031d3.b2327dec.177db1f2641@tnonline.net>
From:   michael.christie@oracle.com
Message-ID: <b4397eb1-db51-7cf2-b881-88fe7bcfa7bb@oracle.com>
Date:   Thu, 25 Feb 2021 21:41:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
In-Reply-To: <af031d3.b2327dec.177db1f2641@tnonline.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR11CA0011.namprd11.prod.outlook.com
 (2603:10b6:610:54::21) To DM6PR10MB3577.namprd10.prod.outlook.com
 (2603:10b6:5:152::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.5] (73.88.28.6) by CH2PR11CA0011.namprd11.prod.outlook.com (2603:10b6:610:54::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Fri, 26 Feb 2021 03:41:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3780c2a-4488-4c9f-841e-08d8da085640
X-MS-TrafficTypeDiagnostic: DM5PR10MB1516:
X-Microsoft-Antispam-PRVS: <DM5PR10MB1516AFD670D16B401FE5370CF19D9@DM5PR10MB1516.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ojbNeBjabjxCCQZGyC4YUK38lyI9nm1GmAALaV4pGJP4MnmvQ1OKJbiCb6WoRQQUpwO1PgmfoH3zr1SOXSXRQVXenYwTmyM+bh8Wu8Z3CpIl6dq1x3ajIf50FJF3Yv2pUyCjXs6MAsTt1JUC73wWGGDyBTIze1/dL96IIKMjI9f+EaX6dACUJP4hhrZLPTg0tx2c7/cTGkSgEUIdbuDHVTUO+qtQ0jYCPCv6Ef87jzNj5GAngV5XgiCdOPB02ilzSpEjyzMNQq+mSJkQe5OZq8ucNJySduaN19+VK+3GntIQDAZWPW6VWoVs+QsDPE7cqh8Q8clgSeasMHe6+LISsJT93H0cVc06tDDvpw7P8fxu7z+DFKR3WGtK6uYLswiDTkcH/Ok1tc8n3+LhGHp1+Il2fkwTNBplUXxJyzwpb+sUZ8qblNHSq5FUuJdogDRzXJyaWDpmpl137UqPmob5wCO5TtSW0KYrFWVoPNDPlblSzT4AR+yKbXGtao1FHH47Xduq+Kjb0+MCIxCDcP8geRDMlCrgW3RSDe0wx/lS7LtMibzkTxLkqZuzFYXPDVMhAl9IFfNZu+44xvx/iVqep0w8qAhOwBavqnxcUDzM0sc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(136003)(376002)(366004)(2906002)(86362001)(6706004)(8676002)(53546011)(6486002)(956004)(31686004)(31696002)(5660300002)(2616005)(26005)(66556008)(83380400001)(9686003)(16576012)(36756003)(186003)(16526019)(4744005)(478600001)(66946007)(66476007)(316002)(8936002)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QUJ0NkRXSUI1T1llREFYSVFjcWJFM2R5TVB5QUE0dmNvdmNOMSswcUZpazN4?=
 =?utf-8?B?MVNkL0pVbnVzZ2c3NXR4TU50T1FlVjIxbi9iSnlCdFp5VUF1MHlsck80cjJX?=
 =?utf-8?B?QUFjQStzY1FaUy9OVE1EV2lFUGFZZjBwVi9veHR4TGxoS0NNQW5nSWYzOWRq?=
 =?utf-8?B?YmxBL0RjTDdPdURXTHJLZTd5U1FqaDRadzc2YldTMXRrR3dZU1h3ZzhTOUZy?=
 =?utf-8?B?dE5lcDdsR0NFUm14ZGliRk5qTE5hSHFobjhsazFzTksxZHA0VDEwMVVTbC9u?=
 =?utf-8?B?allaSkJlaFhnZ0FzeERack5TQUtDZG9EN0Y0OFEyUS9wdHErL1RUaVpOVG9q?=
 =?utf-8?B?K2pHdnBicWJsa2ZzL3VJNmRISExicVdIb1ljekdSN3JWWVJ5UHNFVVQwcHRX?=
 =?utf-8?B?Z2ZNQlZzSEQ0OE1PQzlqajhuZW9vbnNZbGtvN2E5d0tEaUtkUkxLQU1OVWJH?=
 =?utf-8?B?QWhTSEZXMHVzWWoxK2h6azMrYmNqV29lSUp1WllPQTU2d3JZamtSQjJoOFlK?=
 =?utf-8?B?d0hHaTUwb0poNU92dUYyaEdaUTJBSEg2UXhEaEV1Qm9XcEV3UFpvQkRxT0pq?=
 =?utf-8?B?NnlrNVdmRG1yMmhJSklLZ0k4Z0NXOWhHZ1k0dWFsQWoyUU9oMzRtRXdUMzJr?=
 =?utf-8?B?WXFXME5PK3NSQUk4VFFkRTc3Skg3OHd1Q0srVHVEYWc3dURNNGNjeDhSK0h5?=
 =?utf-8?B?TEFoVTZaRUducHl2QmxwWUZvdUpxNGNzMzc4SjFBSTZpcG5RWXg4Z0xmMmJw?=
 =?utf-8?B?TXNMcFJiR2xha01oa2ZQbUdSQmV0a2I3RGs4bTIvOERqV0paUVZvSjBFTXhp?=
 =?utf-8?B?dWo2ZXd5aHVSZ2wwZTNLdjlJS3FscVRUazQ3QXBzYlA5ZFN4MzFSNEVWY2gw?=
 =?utf-8?B?MWQzYTVQS2pheXhPNzlwdGdNM1EwUjQrYnR1eHBNbS82Q083eXlqalZPMVVW?=
 =?utf-8?B?SlgvcWdzcHR5UzdXaG1BOTNjZlNvZEo5aVVPUEQ2Q2JzY2U3Zm5oQVNsdDFF?=
 =?utf-8?B?TUNHb1dxNXFFa3hmWUQwNWxWVjlEdm84M3c5TW1zR0dWNkwrNVU5OERGL3RE?=
 =?utf-8?B?UUprV1hDRmFkeGMwRGszY0VMaEZSTFg0MkVaaW84NWVtd2NqdVJjRitWYUdS?=
 =?utf-8?B?L0pNbUVKSnM3T3BNWEN4QWxySXlDVlJtRmk4QUljM2xscGJnWThuZERQMnZ4?=
 =?utf-8?B?aXdmN29WZ2h3Zm9OYUZPTnlCTDRBOExHc0dOTWpNdXdnZ284VGR4NmlRZFZB?=
 =?utf-8?B?a3dmakdpTCtwT1NKQ0tMSXV2V1ZrdUtDL1djRkdNOXd2TktlVTluNThIQWYz?=
 =?utf-8?B?SXdReGJLaTlGb0tXZWVmamZ6RXRuYzh0RzVKWUxkTVJkcS9tZ1d5OEQ1Q0Ny?=
 =?utf-8?B?NzRVaW10TzRicW5takZNWWxDTVh4Wk9XaHJDM3ROdldYVTV3enU1djNnZVBX?=
 =?utf-8?B?U2FhSnRKMW5SVGdsVFJqeTdvN0ovbElXU2M1SXdHZzNXc0NRRHozSmxtYXZK?=
 =?utf-8?B?SWhrVU9rdU9kUFhVU1phbjFRcmdiTCttWWpQdWJrZjc2VjBUWHpjaEpVQmJK?=
 =?utf-8?B?cEp0WDRIZ1dVVWloOTRjMk1VS255aTREcy9JQzZQL3ZCaW9TeTFPVHJsNHlt?=
 =?utf-8?B?VjI0QUJWcWpuNjVnZmZJYzVoMWU3STZvZms2STVlM2hXMkkrR0RmYlE1bHdN?=
 =?utf-8?B?eVBoWnFZeTdqTmEwTjJEKzFmcjdMTEQwNFVJSXkwRTZVZXZRemI1Z3BlQkRC?=
 =?utf-8?Q?pxm1efM/vpDtguMCtMpjyvSxoZqMpUt5OlzoOtk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3780c2a-4488-4c9f-841e-08d8da085640
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2021 03:41:01.6686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 68PcicTVx1yiNksJYiTsIGOnHMrt3854NxyI1OGI8XESUDZZNafYEzQT9ATP8pwDplovzlLR2IRlU6YsVkrblXV6PLozrei3KnfktXTvlIE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1516
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260025
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1011 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260025
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 2/25/21 3:36 PM, Forza wrote:
> Hi,
> 
> I have a weird issue with using a file as backing store with a Win2016 server as initiator. 
> 
> Very often if I reboot the Linux server the disk image becomes corrupt so that Windows cannot even detect the gpt partition table on it. It can happen even if I shut down the Windows machine before I reboot the Linux server.
> 
> Initially I thought I would be write cache. But I've disabled that with no benefit to this problem. 
> 

How are you disabling the write cache? What tools do you use? Is
it targetcli or are you doing this manually via configfs?

What is the output of

cat /sys/kernel/config/target/core/fileio_$N/$name/info
cat /sys/kernel/config/target/core/fileio_$N/$name/attrib/write_cache

?

If you do a sync manually after shutting down windows does it help?

Are you accessing this from multiple windows machines at the same time?

What target driver are you using?
