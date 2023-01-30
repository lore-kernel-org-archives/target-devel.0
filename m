Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3B04C05027
	for <target-devel@archiver.kernel.org>; Mon, 30 Jan 2023 00:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjA3AJY (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Sun, 29 Jan 2023 19:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjA3AJX (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Sun, 29 Jan 2023 19:09:23 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0064117CDC
        for <target-devel@vger.kernel.org>; Sun, 29 Jan 2023 16:09:20 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30T538of016015;
        Mon, 30 Jan 2023 00:09:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=eAgSC4Brs7gTZxygBbkStDUp2l9t0dmKo5alJqfyMqs=;
 b=qhxkeLfW3GUx7qFTTFIseV5Rs3054yOzPmeN+5vOucYYCVSdUYN5oe2Hi6qtlmcwea7Y
 D6oQGokLAiBsQKFkqngP8wlZs+Hjzd6poUkZ3H7+7h/pmmfKwOUoaqf7plznjPUWQHqL
 dB2FKjx65XnFnzxWmfJ9n7xrf2vdCYIlFdFWal57pExJJVrxLntv9VnZ/50JlV5OPvpO
 izj79UdRUwLFcFNBYOGTxzeQAyPmgx+wwQ4gKl43demtowq8y1xnhPWJZoibj9ryWY8R
 fhKbJ2f+Kw609AzGzWIhgAP+S8MwdNS2NberUj4NS5cpmmNSLuwp29G/OYus83UYQAbe FA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvrjsrum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Jan 2023 00:09:18 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30TJ5GVR024776;
        Mon, 30 Jan 2023 00:09:17 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct53nyp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Jan 2023 00:09:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dCCAjY/wut2zLihP5rTqYXT6ARIAI0MGNifDsP5JkuduUJQ3XmRtXmvhcmSAWQxnYQBnOtiZ+PYfSfFONJkGJhEK20qdJ9WKAhXWwd3HaXXl8k7/qensmxH11Wxdh7b4PSg7pubpizE6W/GWL73aOy1kkopdWNV4qWwnB71roRMziqW52h0TGJKAEY5qxuXF1XpqtIMfmpPdUKe+s0da/bulHTSgU28WzYlnOvEKoxmeFLKnmy1RE0oWgHnDSSb8ANv/cZtR5EfAz8LVsoNqXN1rhoiuTsa8pWak09dCWEWPkq+rByeTLXrvjkyIsSNaSTpl2khyOleDu/DQfJQ6BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eAgSC4Brs7gTZxygBbkStDUp2l9t0dmKo5alJqfyMqs=;
 b=Ei/K0/YL/0ytrKPhhUXlUwBW0t50WKnVEPLQR4j769lURLDnrV1HB4zxpkiIEXzkPgY5kSKjTbAQRFv1x/Vr1GiMf1LNWk/z8WSud9wlU2U7u/OuU/LKlJpuZJaA148YKX6mtrTPqU3qDZ04CCalXWM3llJsx8hMjwNl8kyqKsrVgyEsNDzRxsSlRIoS3BQhJ7Fl6v7jUPHfAI5dWt5L21A0rSkkC2us2xEKKGM1DsT2L8S+oW7ZDAgCAXCFUw+rEvZ2Nm0r/eyDVFkSXZs0JF+ba8Ipq0uBQIF5QjYriQ/G/gJkniwjdWBqV94a4IKoNWGuNcORUbt+yYliXqthpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eAgSC4Brs7gTZxygBbkStDUp2l9t0dmKo5alJqfyMqs=;
 b=a17CIxt5zZrLHrGhWSuLSHfV29m1yG/eV3eZsDlA0e7EdGO6DfV9+uQCHnHFmN98sVr4tkBARpHkczU8KCmiXdjiZV/w6vAfkmnUms6KKFMGgKevggLUV8NQbzUxl4woyGkky2o+NnyTmP2iLNEbbQ4GZ7Mop4sg7BF3J05iylc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB4704.namprd10.prod.outlook.com (2603:10b6:a03:2db::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.20; Mon, 30 Jan
 2023 00:09:10 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6064.017; Mon, 30 Jan 2023
 00:09:09 +0000
Message-ID: <f9f4057b-5711-e83d-aea1-20f79737f27c@oracle.com>
Date:   Sun, 29 Jan 2023 18:09:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: deadlocks when the target server runs as initiator to itself
To:     Maurizio Lombardi <mlombard@redhat.com>, d.bogdanov@yadro.com
Cc:     target-devel@vger.kernel.org
References: <CAFL455m0amBULArG5dNHrrGKJ8Jg4n3SdnvzOavz4=i2FUR5Sg@mail.gmail.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <CAFL455m0amBULArG5dNHrrGKJ8Jg4n3SdnvzOavz4=i2FUR5Sg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR13CA0010.namprd13.prod.outlook.com
 (2603:10b6:610:b1::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB4704:EE_
X-MS-Office365-Filtering-Correlation-Id: 943328b5-1c4c-4860-d60c-08db0256356c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ySDFtxQzz9rU4pefphMbxXNdpB/jqCo6GyDQzBBuUMXtGhe8swbWrw9Wn8C3FKWeEGxFutspRWoSagJXN0JcXghkZEYzRUc6NxWeD2bLnRmLDkiiiEf+WGU+MkxdFUWU10b6RLLfwWSaHimXbsiBavJaEkpbLZH5MdYtKGciP53hMlgfPcwixwzofcn1qSVB4XxIbNQ4HJze4U4r5X+h6CNcWOnpBsiXNILWE+Gy0lsZhohjvVFHLDujVtY7+FvYEejMYBsn7NWbc3tyZub/Tb/Qd1s4lVct73WwjtSqiCg4RhX9skXPk+V5yrQvoO+T5Tsj0zogKYlFc8rbswVEj4FbfUM2NWf/WXkrpQC4YfWE+EqaLb9qQZLnQ/iDU5VAUfX6q6L7xEoCXqOo14Nb8pDIpcQLTNzj9A2XrEII7Yo2w5r10lWppde6M0drns80QXpx7ZTNkLaSfee7Blvup6QSntWKxtgsXMkJK/12mSPH122uRFyzsdhKZQIuB4StHzWf8v9QLATD8rXMi2iSU0kN86xvLLVcMJPnb1taB00Ck1jD/m9Qls/ONSGB1qMaZZZw04/kVksn5la39LgoDIc1hbL8RH34m8Ol3FkKchdGv425v9duHVIS2XevthY8VDiApIrgVwrSrj6kSb2pENDY7yh9HLkXjdhAyCb7a7VK7Co9YLOya0OIfTOsoKIQlxFNNkVAGvhUfkQ5nWxY0kqdDlW64EBbPTNxa7IA6AQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199018)(31686004)(36756003)(2906002)(478600001)(41300700001)(6486002)(38100700002)(86362001)(31696002)(2616005)(6506007)(53546011)(66556008)(66476007)(8676002)(4326008)(316002)(66946007)(8936002)(5660300002)(26005)(186003)(6512007)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QmpTUGVmNmtXTTVVdEMxUW53dFlZanJqR3FIVklSQmpLL1RwK1hXMHY1UWdi?=
 =?utf-8?B?SDcvVks4WHU2VU9GREdlMDgzdnI2a2xicS8xTTE5bU94ZnU0MnlyNFRiS3d2?=
 =?utf-8?B?eURaN21UOXpaOWhFR0pJdFVHbUR3OHkvZ2IzMEJXaEtGeTZXSXpWdFpCWmx3?=
 =?utf-8?B?eThFZmVmWEo1UkV3cnFkNW5sb3dWVk5TVlBCUkx5Zm04QXRzYzd0a1ZObHNL?=
 =?utf-8?B?UmFaMS90NTFObUxPMGZFNFJ2K05HQysxOTRIbWtJWTArSDdZZk5yeTZtNk9h?=
 =?utf-8?B?MHluSnJ2aEZPSWRla1ZpQ2dYdEJXMGt3czdNT2VlSXdyb3hyYmtlOXFlM3ow?=
 =?utf-8?B?YUFTckZ4OWNqVWlUSks0MFd3ZExJV0czd3JUVDY1QUp0ZCtlZStuekhLcUEy?=
 =?utf-8?B?RjM0Q0UvNkR6S2l2QWwrUlVIN2VZYk90R3RrRU85amJuRTE0dnhMakMzUmt0?=
 =?utf-8?B?dHd4T2xqWlk5Kzl6TmJyL0xIOVhYTXIwVmFMMHo2YUdOanhlWGVpN2FyZXc0?=
 =?utf-8?B?d3JqV3p3VXdmeFpOZisyeFBWK1hiK1N3Tnc4bjFkUk1CZlVtWjgrdGtBcWlr?=
 =?utf-8?B?c2FkTXZ6VGFoSWJBUWVyL0d5aGphTzJNT1JLSGorY3V6UHp4Q1RNVktDaEhZ?=
 =?utf-8?B?YlB1R2FiMnF3YmF0eThlZDlJQ0dOTnBvSFpnMnJyVDNuRWlDcjl6QUZtb3Bi?=
 =?utf-8?B?N2J5eGZnREJvQW9nbEE4YjVJR3djZWtMUThLbnp6Q2xqQkV5UXZMOTAycTBi?=
 =?utf-8?B?bVZnUDJzWWdnV1h1MDhJSmxQeVV4UklRWnBZR0hpV2kzZ0xOWEtqbG8zUUU3?=
 =?utf-8?B?TGlTaGErUklwei8rN21WeEpGYmRUbmhmL0pmZDA2dVcvcGdUMEhTS3BlZjdZ?=
 =?utf-8?B?aTlBZ2tSZVd2V1lBS0NqVTJCRlh2N2tmNGlJVTVQanh6ODVMQk0wRnNFeFo4?=
 =?utf-8?B?YjJjK0hhRUdaZlNnQWQ5Q2pORXIrbXJqcHlOdWU1MERMSHRGZTR3bmJkbzRy?=
 =?utf-8?B?ZytMUlBoZkFMc1pWS2JKYzJGdXpyM0lLRFhiS3lpZE5IR3BBV2RuZVA2enpz?=
 =?utf-8?B?djU3c2hKaVBCeWp2YU50aW5YczVmajU5TXVxRnVET0pORWFNT0t3OCtTSW9p?=
 =?utf-8?B?WERNVURnbVZqQ1pQTzNYRXZJWVBiOVJ2NnB0MksySXBLbTMvSVZoWGRDMjl1?=
 =?utf-8?B?Z09Mc0NSeTJkb3pUNlFRNm5DM3FSY3BLY29HOEJJbjJqQXVTemxvU1drTUtl?=
 =?utf-8?B?UzBhR3ZLWTBQSW1hUG8wOWI0Z051VjZEaTFqdmRxUkhIVW00K001UHd5a3BI?=
 =?utf-8?B?SXRRcFgzTEk3dFM5NGpiakZjSm81aTRLdHIwVWM0dG82VnA3Z2hjTUlWL2Fr?=
 =?utf-8?B?K3NOUm1pWTJLN1J6UGNjMHdRbVd0SWtEU05uTStzdW1YaW5FTFlObnhpdENO?=
 =?utf-8?B?QUR3dkVMbE54RGZZSWJiWWkrdGErYnF6QjdsTVBDVEFRbGF3ck9xcWFOa04z?=
 =?utf-8?B?QW8vaU1SRENYYkIxVzlndkd5dFJkTnVocU45VGR5eVlTOFY4c1dOeXlhaU5J?=
 =?utf-8?B?WFpCK09KdU1QUkpidXVPUWU3alF6dVFacU03WEtsRFFuVDA5UUhEQlFjTnBX?=
 =?utf-8?B?K2dUTGxZT0VZdktmK2FQMjJDOGNCRUtuajZDd05DN3ZPZGxDUFdTdFh1L1h3?=
 =?utf-8?B?RXh4a0JydEt5azRRMlE1UUIvd0hZU284dHFzSDE4ZUZJYnhGZTEwcy9FdFJ5?=
 =?utf-8?B?YlFvZ0VUNEN4VVVMK2JIaTJhVThjb2cwa05Dd0NuMGRyZDkrYzQ2RXhrUmdy?=
 =?utf-8?B?SUtKV1YzQUpnaVluQzZzYmxxZDJPMkM1SjJLSmpjbjhUYVRhVVJWdmd4cDdr?=
 =?utf-8?B?R3lXR3RVUHFuYlNKV01wTnp5bTIxZTVxTGJPRXBrUmdlVDJUNFJNcXFuOUcy?=
 =?utf-8?B?d21ZR0lDMFd0eFRRUWtaeWJzcjJpaUNtczFsTytIMFg2SDdCUTlIcFljcmtR?=
 =?utf-8?B?bGFMamRPV2d0RlF3Y2gzZHpLTWFiQWZTeWh6MFZ1QUJUTHAyaVluMzlWNkVv?=
 =?utf-8?B?ZTZ2Zmw0dG9IaHRuVitBTTJVVmFQSWNOV2RtU1RkSVRkRDkzVGhwbWxDemVC?=
 =?utf-8?B?c1ZDNEEvN2picEhDdUt6NXI1R09SczJrVWhmcmdOZXhjcGtJRmtyMUwxNm9o?=
 =?utf-8?B?SGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: L3ZdBp2dNzlJRnfBchvnQP1Qtr77LTHGGu0GaS7wLULKaBw/8cYwoCWhbDEGGeFfMzu4MQsEHg3YGZkZpkggNOVvPwJHNqyL1TbgpkDy7RFMvLe7QLYoDkAtb+CCRUlfXPdo7bTwV7usCNwEnyhzhUlKWS179p6btuwACSh757KdufCOPku17IoDzihaQMOjguZa/LqC5lMUhxssAmAhi/2eeg1+eheVaHE2UMPf9OMTq2lBfpDPHTWVYmoTIVmaFcg9h4vG2pCZoFrCqLhW+mE1+cAOdj5LhtVMFOe1rgqeglvYiV4yYEJuDipHEltTfVnM3A2qkl8ufMOuQhdyzEmU+Do5mMzfkpFL17T4sldH939skRQV7QhidTRwagJ4J8qHephNA3BV6PV7E0vbV4pOelf/d4uXzEIJ9uE0qB3nBwnmefBdJEhhTiGAAoNuNPvtsnc4RRDoKVsCleQkxMqEP1x7Zpl8iRLV1gIbrPmaDDvPDR9ZQH9Rpje5XX2/rTWcMy9xsjs2YqOy4pIdzJqvLhIA5e0y95rXbD0FaScP3jidxCjh4PVefA04Z3jyHRu7FgnZF1v1+URQa98Y7VcSDzuY9+l5gEulLhOUS12ptgaC465Sp1kuIojn494jf89nT6ydmxuZwj+yeQ4ex3bHIIVmc7l/IqRLQ3KpGtmEtpCtjZQAXEWkpMpWCA9MQFEuJ7DC8Ot9v4WZ2LXoR+uPDzwkPzjW6fnXhkwdtTwBd/UrU1deOjHIZ7bR43cSIDgvDcW1KjqgcpWi8q89jzNhdhzHLmtQFap0hUb4S5WCah8XhrdZZBPXShV3IIAi
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 943328b5-1c4c-4860-d60c-08db0256356c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 00:09:09.1700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W5gzks7q8NaW4frmKWAgFpvk5WA7R5bDL+QbHwV83HSz0ZaXIQbFdyzcWcFof1Q+Hi0V54jKZrVUHijuXseWJffUxRxsHHMVfchcYPtfqHA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4704
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-29_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301300000
X-Proofpoint-GUID: KkCxEYYzL-FaxFxnYmi-lFAMJ4oOuvL4
X-Proofpoint-ORIG-GUID: KkCxEYYzL-FaxFxnYmi-lFAMJ4oOuvL4
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 1/27/23 03:58, Maurizio Lombardi wrote:
> Hello Mike, Dmitry,
> 
> A customer of ours needs an unusual configuration where an iSCSI initiator
> runs on the same host of the target;
> in other words, the host sees an iSCSI disk which is in fact just a local disk.
> 
> The problem is that under heavy load sometimes the system hangs,
> example of backtrace:
> 
>     crash> bt 2037117
>     PID: 2037117  TASK: ffff8bb4c901dac0  CPU: 0    COMMAND: "iscsi_trx"
>      #0 [ffffa3f4199db378] __schedule at ffffffff9134b2ed
>      #1 [ffffa3f4199db408] schedule at ffffffff9134b7c8
>      #2 [ffffa3f4199db418] io_schedule at ffffffff9134bbe2
>      #3 [ffffa3f4199db428] rq_qos_wait at ffffffff90e61245
>      #4 [ffffa3f4199db4b0] wbt_wait at ffffffff90e7bb99
>      #5 [ffffa3f4199db4f0] __rq_qos_throttle at ffffffff90e60fc3
>      #6 [ffffa3f4199db508] blk_mq_make_request at ffffffff90e5159d
>      #7 [ffffa3f4199db598] generic_make_request at ffffffff90e4592f
>      #8 [ffffa3f4199db600] submit_bio at ffffffff90e45bcc
>      #9 [ffffa3f4199db640] xlog_state_release_iclog at ffffffffc0358cae [xfs]
>     #10 [ffffa3f4199db668] __xfs_log_force_lsn at ffffffffc0359059 [xfs]
>     #11 [ffffa3f4199db6d8] xfs_log_force_lsn at ffffffffc035a21f [xfs]
>     #12 [ffffa3f4199db710] __xfs_iunpin_wait at ffffffffc03454e6 [xfs]
>     #13 [ffffa3f4199db780] xfs_reclaim_inode at ffffffffc033c203 [xfs]
>     #14 [ffffa3f4199db7c8] xfs_reclaim_inodes_ag at ffffffffc033c620 [xfs]
>     #15 [ffffa3f4199db948] xfs_reclaim_inodes_nr at ffffffffc033d851 [xfs]
>     #16 [ffffa3f4199db960] super_cache_scan at ffffffff90d1cad2
>     #17 [ffffa3f4199db9b0] do_shrink_slab at ffffffff90c73e9c
>     #18 [ffffa3f4199dba20] shrink_slab at ffffffff90c74761
>     #19 [ffffa3f4199dbaa0] shrink_node at ffffffff90c7908c
>     #20 [ffffa3f4199dbb20] do_try_to_free_pages at ffffffff90c79659
>     #21 [ffffa3f4199dbb70] try_to_free_pages at ffffffff90c79a5f
>     #22 [ffffa3f4199dbc10] __alloc_pages_slowpath at ffffffff90cbcd31
>     #23 [ffffa3f4199dbd08] __alloc_pages_nodemask at ffffffff90cbd953
>     #24 [ffffa3f4199dbd68] sgl_alloc_order at ffffffff90e80e08
>     #25 [ffffa3f4199dbdb8] transport_generic_new_cmd at
> ffffffffc0972ce5 [target_core_mod]
>     #26 [ffffa3f4199dbdf8] iscsit_process_scsi_cmd at ffffffffc09eabf5
> [iscsi_target_mod]
>     #27 [ffffa3f4199dbe18] iscsit_get_rx_pdu at ffffffffc09ec239
> [iscsi_target_mod]
>     #28 [ffffa3f4199dbed8] iscsi_target_rx_thread at ffffffffc09eda61
> [iscsi_target_mod]
>     #29 [ffffa3f4199dbf10] kthread at ffffffff90b036c6
> 
> This is what I think it may happen:
> 
> The rx thread receives an iscsi command, calls sgl_alloc() but the
> kernel needs to reclaim memory to satisfy the allocation; the memory
> reclaim code starts a flush against the filesystem mounted on top of
> the iscsi device, this ends up in a deadlock because the filesystem
> needs the
> target driver to complete the task, but the iscsi_rx thread is stuck
> in sgl_alloc().
> 
> Sounds correct to you?

Yeah, I think nbd and rbd have similar issues. I think they just say don't
do that.

> 
> What do you think about using memalloc_noio_*() in the iscsi_rx thread
> to prevent the memory reclaim code from starting I/O operations? Any
> alternative ideas?

I don't think that's the best option because it's a rare use case and it
will affect other users. Why can't the user just use tcm loop for the local
use case?
