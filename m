Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B591C6FD18
	for <target-devel@archiver.kernel.org>; Tue, 28 Mar 2023 17:15:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjC1RPt (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 28 Mar 2023 13:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjC1RPr (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 28 Mar 2023 13:15:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9797A5F8
        for <target-devel@vger.kernel.org>; Tue, 28 Mar 2023 10:15:45 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32SHEhEt019033;
        Tue, 28 Mar 2023 17:15:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=oX2PYIl237lUASa+5+X8vOWu4/6IvGTiw1zYrpy/7Co=;
 b=lhtmCA3T0iECXbFh01Trg6SFe36xFCLAjo16dTVqHqODJUasLXEkfLwzC2y/i+CoUvqz
 wp1LeqxLyA+b8x6M5g9iMv+UdCZQfp5lIfloytYUN9pZsG5XtqRFBUrbnQd7xFpUnBx6
 4QCRMNPiMnkzSWemwJ1Yxt0iEo52iCvy1IIB+cRg6ktLYFb7uXARgjpImigpZholNbvb
 oui2LqclGqvFequKju9Gu1NThAYr7gTI16H2Oi+V+igAfxWNLhFHybviySxuvT+dqTAi
 u4W2pxZQjHWmVwAMbe7HvmAPcoaQTtjw6zHTz4kPIDEi1zr0iFtA0wi5tEV505XTDhVU 4A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pm4f5g02u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Mar 2023 17:15:32 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32SFv0NP026701;
        Tue, 28 Mar 2023 17:15:20 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3phqdd85ew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Mar 2023 17:15:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WWSUWqnDtUZoD0+aloHr5a6YYEZrW8DyZTOnh1hccl5FyFATBa8g4T2wRZtNE5btXn6E4iuWwUYswf59fOE15y5Z6jdogY03BGpGhoM4LItx1QN+VOIKC7Sma7fXZMncdf/kIwdV7PQwE1v5k57264btTbLKcOizoOdyomXbZQaTaTslUfU89z3k4HykTv97Rbk7/A2SRyKIMCD4r4zr2cjyGTxYCbSdhgzRdpXQBpROg5QSo+DwdAaFxWyDLMZFKyq5vO33M57ithMXfs5EjZPokKnx8GKHW1lXax4DWujjsYjgh5t1X2xh71fWm03oWwubzPs/RbLlEtsE3O8zNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oX2PYIl237lUASa+5+X8vOWu4/6IvGTiw1zYrpy/7Co=;
 b=m9KvxPiWpn74VA+2zT/TRJXw8Ub5LXISsyoU9F/Qvvk5N+g7lgGfXuyd00M+u2tFan+GaGKrVCuKBifQw/UzrN+hEGLl9qxgo/673S8GnYbdw44W5QzPH4+ut6KMYJJhA1yvBa1/49jvNMqtEcVFJfDyKzNY/Jx3kYzKHyfQNGw/v1JIVT9WZOuVx4nCDhkE9mvce1+Hj0Qh2gQUcK/J2o37X7V2+HVqOPtRal8g2c7Ge5W1RP8QvVNf7mDwHSJEaK5753dqnUfb+vWy/dgpcpTvhjA1E6kGd9B0xxdne12XKettYdUYLHTmkfD0a426VPpr/n8eO8NBZkLLAH5Gpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oX2PYIl237lUASa+5+X8vOWu4/6IvGTiw1zYrpy/7Co=;
 b=O0lgaL6CLLeqkJZ6kA3zFPapLGeIKqv8vJPn4HLPeipCIxTd11qpBiNL9n+oj5y2190M5+edXZwtGQAevVUHqm21QOaO5lcQYqeml6Lp5c8jv5/hYAtIluooL/GBC8jRQ+LZenuqtQRSTR1XbOQxFrsK2SjhYOnUcZ1cWGBwjB8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB6374.namprd10.prod.outlook.com (2603:10b6:a03:47f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Tue, 28 Mar
 2023 17:15:18 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::dcf6:889b:21f3:7425]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::dcf6:889b:21f3:7425%6]) with mapi id 15.20.6222.033; Tue, 28 Mar 2023
 17:15:18 +0000
Message-ID: <fc351bf4-bff0-4d6b-f91a-c8c916e3ef64@oracle.com>
Date:   Tue, 28 Mar 2023 12:15:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH V2] target: iscsi: use GFP_NOIO with loopback connections
Content-Language: en-US
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org
References: <20230327104535.20984-1-mlombard@redhat.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230327104535.20984-1-mlombard@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0051.namprd03.prod.outlook.com
 (2603:10b6:5:3b5::26) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB6374:EE_
X-MS-Office365-Filtering-Correlation-Id: b19335ea-46a6-4aa0-c60d-08db2fb0011a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: biebd+KWsffvu8hWcsFLQ9ejwSz45V2+q542PZR5e7VckrEw2sVREMnVHnK7WpTJeAY6ln6dRckNa7cXS47op5GNIwL/hFt4TGct2ea37V8pBtl13mjzT+3qYAdQa9So3fA8TTJwG+WRanKJNcEcsxee1pvWS9MvbsvwMkN4ogyAqEIMd9c45mhtaQmtvEUYMFbYg2LSh7kZTGa/dhpU5iJvd4yP9uGMWliNirCWsXMjRGADqLQ4kwhAbnq8Ox07yY7DZiuwrueEP+Oh6bR5XS3f7svhC+x3zLDKLdy6pYupUvX9yIpDl6GnVEDmq77Stspat7WRxdo6WzfEdSGhLnxR9eiyV+xxZ1o/cWz8pgkCWmELouzcGB3SLrekQXhpJM/mqlEHQt1LRQ5f9UCFOSOXc6KyAEXZ7i0Km3n+nX35he8aWONHciKljJ8dBV1tGEp0GawbgzvpAGQSNRYNGccSoeb3HKlnBb1TVHdIdjEgMg9j81fqZwYCV960tKTzLClXncNoWCdCQ2nPthV4jOueWZQULAUqemiasXWxCABKBhZ4HL/WEcTvUykNG41k1gcE6P3P8maGjNNSRJSEsJmQIhQSP/kCaqI8AaNqhAubRzcfmkfnTbJxHm0tNArKGmPkYR08bb5s+9eIi7qGuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199021)(2906002)(83380400001)(8936002)(5660300002)(36756003)(38100700002)(86362001)(31696002)(6636002)(6512007)(53546011)(6506007)(316002)(66556008)(8676002)(4326008)(66946007)(66476007)(186003)(26005)(6486002)(31686004)(2616005)(478600001)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NlJiTXdUMFNxTkJNR2tSMlRRMXV0dkhySVU3S0NKVUF0KzhCOFU3dDV1MUxu?=
 =?utf-8?B?bTE5SDM4ZTErWWg5aGZiaE00eENkQWNoYzZLVHJ1VXJMUkxoWHJnanpBUXcv?=
 =?utf-8?B?VTlQNVpBcFBRRjVrMFBoYjBzbG01QVFTWDRra3lpSCtoamZoNjVER0xWKzZD?=
 =?utf-8?B?NjQrVjV6RTQ2T0lXaEhka01yT3IyQXZEY0pLSmRIQ2VTV2JrT2hBZ0JKMEhJ?=
 =?utf-8?B?WHloNU5IL0MxeXJsUnhFWkx5SStWdW9GZ3dSYzJOcDZPRnF1b3BsWU1vbWJJ?=
 =?utf-8?B?NXNuZFhOSGg2c2xpczh1WXBlR05NQy9ubFZnMEpRUG1rOVpqMUxKelZhcWFG?=
 =?utf-8?B?eTRGamhsSDNyZjJ2a3V5MENMUXg0NktqcStMQ3Jrd1NBTCtKaUpQUlM2dU5p?=
 =?utf-8?B?WHNWdWU5MnVoRUJGQVc4UlpvMDMwK1F5aWh4L0YweTd4eXNmRFJLejdpUE10?=
 =?utf-8?B?QTJ1ZkF5WFdlcGtOTUVNZ2d4bmtvQWlpODZDWjI3MzZ1OG5McWlsQzNIcDVK?=
 =?utf-8?B?citLSGJaR3N4L1N0Mytqa3BUSS9JUE56NGxTYVNHM0t0MmZBT2ZzNlR2bVg5?=
 =?utf-8?B?U0g5ZnJSWHI0My9vSGdnOGU2b2hFd1JuNEtDOXNKNFNraG5pQWdIMXR0SDU1?=
 =?utf-8?B?dFZwcy9ZMW5lbGFnTHJvbG5GaS9KblphcVh5a25veDN2aW5QWVY3QWJQWVZu?=
 =?utf-8?B?NitZMGtoekU0blg4cWJEUFJPZXZCb2ZPUkRWZ1paamxaRGthMFV6dGVwUEI0?=
 =?utf-8?B?QjA4OUh4eEdDK1hRZk9IVldxY2hBckR1a0FjUVV6YXN5SDRtOHJBWXh6ZEdC?=
 =?utf-8?B?U0JPUnl6cjlKTDhzNkorTU8xMWdLK29xRFVVc05jbmVCdVZISnpadkQrWFNn?=
 =?utf-8?B?YkhxeE1zZ0dFRC9DVXFFVnVTRnFDTmI5cTlkeEpIOGlha0hwYkNoWVBUQ3Qr?=
 =?utf-8?B?WkVYTmtBU00yR3J1Wm1hZHJHMmtaNFQyZnRKMXVHNnhEOGxMeHFCZ0sraVN6?=
 =?utf-8?B?cXhHVTduc1dGQnZWc25YU0xmYXZsRFc3V015WEVPejg5Um9nbXRNblJKMkQx?=
 =?utf-8?B?a1BuVlhyR1l3QkFrT1NaYXlFZ1pkdzF0RFJ4QVQ0c1ZvdUVWVWpjVnJzOUdE?=
 =?utf-8?B?VmVyclFOWkhMUFB3WFBhdjBxVm16ek4xRDViU1FYMCtTQWpEWS9mdUNqbCsr?=
 =?utf-8?B?UElVQ295aWJUWGdmdHRKK1RVdkFJRFZZM3hHVlNITVA1cWMwTGl4cTg4OWpY?=
 =?utf-8?B?cDFxV2wwMkVUNmZFWWxOTUVXMEUzazZocUFVbDl1VE9SMWNYL1JjOUFPaDUv?=
 =?utf-8?B?b1hjY0hSL3lxQTJtc3ZGR3JVTTAwQUhjTGZLYUxHSExkeWhMaG94dFpMeDlD?=
 =?utf-8?B?ekxtbWZONDd3OU5nRkFraXpaZUZidXdQWGFMclNUNlFiQlYzY3VZcllxQTRM?=
 =?utf-8?B?d3FtWDN3bXZBemZ3cW1mSXdnZnJrWVhKbXpzYnZHd1dNVmQrcGxOTmZoWmhr?=
 =?utf-8?B?eDd6VTk4Y3I2YzZPc0dydGhPRloyY3h0dHo2d2tkVnE4ejI4WFZXMVMzWldI?=
 =?utf-8?B?R3lNcXJBQnpDOFM0QjRwOUNaelJUK3kzaVpjNjdzQkVWQitxQ1NnSFVodmZD?=
 =?utf-8?B?bUUwRWRVenR2QUdVOHo1YitHUEVyTnBmMitORFJNcnNtQ0lta3dZWlpkbVNC?=
 =?utf-8?B?N3VkS1FuTzBhS3E5WWJyVCszSFVJSkhydmxEcVlEcFdEbU5DYjIzNXRPYnVM?=
 =?utf-8?B?Y1VObmZWZmFPOTdKUExibzdvUm1iMWs3dTBzbDFNeU1Uenpuc3c5WEtjMTdt?=
 =?utf-8?B?ckZ3QmdmcTJob3RJUWViZzk5VVd4YlNJRktEN01kWWRsU3h2czk0OEZDRXpp?=
 =?utf-8?B?cWt6R0pwd2FFQ1M2ODdiaFlMdmp3bEZQT01VSU9wSWFaMnZ3eEpTS1dJbERL?=
 =?utf-8?B?bURIT2FBNzJkbmhFOG85Nys2M0xoREYvNWJpT2tJYStmR0Urd2JPUS9ZcjNU?=
 =?utf-8?B?SlEwdVM1QlJzZzNaSEVzSnY5eHRYdTVCdkVYSzZxbjlBZURqdUhrZDdXSlQ1?=
 =?utf-8?B?Wi9Kc2JraGpkcmRBNklhOUhrU3NGL3A1T0ZUSVl6VDNlTVNXeGkwWUtqeGNR?=
 =?utf-8?B?b1Fibm5YcEpsNS80TmpaTCt3VEhQeTNYMXYwbHJ3RmtCb3NHQjdCU1AvNjBK?=
 =?utf-8?B?cmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: IMEMvYxOMNOaKt1CRdWoIiilPMieK4PLK3UFn8M44PtvmZfdVHqbDmVRTnRWIWeO3g3vcBHMnsrmIlqsP2xiLQM3JkNKCYr1TP7b3CaFhAVT3HTJEHUsR8dr6qpJmV+g18iZ1Jl1iErUlyGABNld9XETs9pRmVE7uDBl3iCuuh4MbQAXRpAyYEERx2/4ZOcPAWmuDdqk+fpoBKOaT3ZMTEw0eKUO1HC0m2qYNfZ0TL3emlzFoGPqzX8oH75COGdgFzjbWQ2j4p+cuYs6ZohOtNA+9BVhClG0V5fSSUWsKGM1jRmmEUQCcqkcu+ROhAPbl6MqOnNTqCoozUEauW7BW6xqHQe/mvS4BUDDOXEa6vxJJPH6r94OpIq4+EOXZ6ZvX4cvuuGKOMpgabExF3CFOJhkl9x5bd5zpcH18sZll753N1cEZmJU2IP6jqKIYE5EY5IiHMmJn7NZTljQqcttNQwJ9tGA2tkjha/9mZ8bVdBSaFbOKHtq8fFXzpTPkPp3d2+QxUuNJX//3npg3KV6oBKOZZAifuOCIxOtmczsmodxFWYb+vx7RVbU2X+Q0eMWHAwrZe6qQF4208l3YqgupAUT9sUxoYW9GwIJGpDSgs/hmbL8szQbYnf7gV+oYwqoH1GLi5GACiCbweYTs4hmwYQw+0UuuFyeieKo9rDDZnMdoKiaHQgI7nsFlO822ksr/IYwQe+TcNemR55F0QRcFoSuC235SwfQp0JKWpTU3KJKDZpdOxcQno7LuVVXeK+vAZBRezF2i6+w6KKu5+TCQJJPp6ftzQjaRd5XTrJUe/g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b19335ea-46a6-4aa0-c60d-08db2fb0011a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 17:15:18.3892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b+JtetUZDnaRU78MKE/0ADkLv9Uu8NCrfUx6ZisH/A31LWzw9Si3VI7RZQojyndcEd4O/+RKrlAKnUaepp1lcos0shxX5zp5ii/wARaj7Xw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6374
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303280134
X-Proofpoint-ORIG-GUID: nKhYASnVKXhHLZZSMp-RV5ybD5cQ5THk
X-Proofpoint-GUID: nKhYASnVKXhHLZZSMp-RV5ybD5cQ5THk
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 3/27/23 5:45 AM, Maurizio Lombardi wrote:
> When an iscsi initiator is connected to a target running on the
> same machine, the system may trigger a deadlock when working
> under memory pressure.
> This may happen, for example, when the iscsi rx thread tries to
> allocate memory and a memory reclaim is performed, the rx thread may
> therefore end up waiting for the initiator to complete I/O operations,
> causing a deadlock.
> 
> Fix the issue by using memalloc_noio_*() to enable implicit GFP_NOIO
> in the vulnerable code paths, when the connection is in loopback.
> 
> 
> v2: Check the IFF_LOOPBACK flag in the iscsit_accept_np() callback,
>     where the conn->sock pointer is initialized.
> 
> Suggested-by: David Jeffery <djeffery@redhat.com>
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/target/iscsi/iscsi_target.c       | 19 ++++++++++++++++---
>  drivers/target/iscsi/iscsi_target_login.c |  7 +++++++
>  include/target/iscsi/iscsi_target_core.h  |  1 +
>  3 files changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index baf4da7bb3b4..4d997a049bf7 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -3918,9 +3918,9 @@ static int iscsit_handle_response_queue(struct iscsit_conn *conn)
>  
>  int iscsi_target_tx_thread(void *arg)
>  {
> -	int ret = 0;
> +	int ret = 0, flags;
>  	struct iscsit_conn *conn = arg;
> -	bool conn_freed = false;
> +	bool conn_freed = false, loopback;
>  
>  	/*
>  	 * Allow ourselves to be interrupted by SIGINT so that a
> @@ -3928,6 +3928,10 @@ int iscsi_target_tx_thread(void *arg)
>  	 */
>  	allow_signal(SIGINT);
>  
> +	loopback = conn->loopback;
> +	if (loopback)
> +		flags = memalloc_noio_save();
> +
>  	while (!kthread_should_stop()) {
>  		/*
>  		 * Ensure that both TX and RX per connection kthreads
> @@ -3966,6 +3970,9 @@ int iscsi_target_tx_thread(void *arg)
>  	if (conn->conn_state != TARG_CONN_STATE_IN_LOGIN)
>  		iscsit_take_action_for_connection_exit(conn, &conn_freed);
>  out:
> +	if (loopback)
> +		memalloc_noio_restore(flags);
> +
>  	if (!conn_freed) {
>  		while (!kthread_should_stop()) {
>  			msleep(100);
> @@ -4166,7 +4173,7 @@ static void iscsit_get_rx_pdu(struct iscsit_conn *conn)
>  
>  int iscsi_target_rx_thread(void *arg)
>  {
> -	int rc;
> +	int rc, flags;
>  	struct iscsit_conn *conn = arg;
>  	bool conn_freed = false;
>  
> @@ -4186,8 +4193,14 @@ int iscsi_target_rx_thread(void *arg)
>  	if (!conn->conn_transport->iscsit_get_rx_pdu)
>  		return 0;
>  
> +	if (conn->loopback)
> +		flags = memalloc_noio_save();

Do you need to do sk_set_memalloc on the socket as well or do we do all
net allocations from the the rx/tx threads? I know there are some net
allocations that are not going to take place from those threads, but
did you not set the socket flags because they are small allocations or
just forgot, or something else?

