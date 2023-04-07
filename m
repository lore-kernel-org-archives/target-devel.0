Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BC69C6FD1D
	for <target-devel@archiver.kernel.org>; Fri,  7 Apr 2023 16:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjDGQfs (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 7 Apr 2023 12:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjDGQfp (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 7 Apr 2023 12:35:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3209B468
        for <target-devel@vger.kernel.org>; Fri,  7 Apr 2023 09:35:44 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 337Fx3ix014221;
        Fri, 7 Apr 2023 16:35:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=bIWgONj00uCwCOV78wWMDHXJym/LuxnYrn8MQFnWbbM=;
 b=r/xOSip3b2rJqdiB4XkFxSqCSeDNvheJn6PpForINiGMcIxm3NJairupsY0dUGoYh1f5
 VHpNigHFzLVMKqDKT3FVBn81b2yIJLvhWGvz9W+0tdWgYQL3q6LhEzoqziIhBf3ovWiu
 Y2ZR1mQzdXfutz2zpkZfTrBmuG8daGzzOheMYgFEbaV+AhE/VbXt08OY7NxpbUY7B1QB
 AXF7ozFkov1vPVONUOHKqvbTdizAxR8u0RNYSv7Cw+UFRBf7fFNfglKs8l++GFQiDeVF
 5G3PqvROFhw3zE5Zy1D1f6VoiOjyXHqMiuqg2N/CpNJsj/yVm+01oDPxZ7Jqf39tdba5 Ug== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppc7u5ep4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Apr 2023 16:35:42 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 337GYwsn009035;
        Fri, 7 Apr 2023 16:35:41 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ppt3mvb7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Apr 2023 16:35:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GVi8/0TjUGXkN6BXQ/JNgYThN0Hvz6+MNl1iL5JAjwC3yCxQiMoa+o6YOESEqobEUp6Yjn0AKMsr/USk+NkwBWwY/PdKH9QTaeqjmuSNUS808DDFFljjw/z8sVwU+iG+hfqtEHsd3K70sUDOooFA7qizWcPOjaqZKfB+eVYUOD35t5q9Etb83iiJe+KFAT8e9z6Qfu0O1HOjjhV9GiGXLIPIdcx9OUczCioXHi6xYuH8dQ+KYTxvJDana88n1Jsns4Bk4mNIUedVVTaElLnps9jiEFoppq6DfTImlclTyBYWfeFxY63sDvHNPpElCEBnZ/bOwXwFfO7QLIT/6VPGqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bIWgONj00uCwCOV78wWMDHXJym/LuxnYrn8MQFnWbbM=;
 b=FHUp9YH/1DaK8EqsbfaxfkJ8DaGMlEVQhY+k/bTCxFmEG3xr8Zt+loS5P2LPm3dvmhp5ItOa5C/qB5aBdHu9F7TWQznCF0Vi6oCQhCgRrTIZ6zcdhkTqNfFEBjynuzVBbUFfxuYM6Vkwzi3UddXaOq3Gh3gT7JStuCNfRtIoKyLV9EmCMQQsjcX8bJE9AZfrCFql+DJNhrwSN9sz7d+pP1iMD+6V0kmkrR+qs+zpPW/puHJyHddRDCCBZ0eIYm6Zk12F7X7ADDZfB0h3xIxSoecfvqJFBEHSX2ehGlOme6QgO7zzciemarws8tFjv34KSkX3e3tXDD/iJ65n6/1o2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bIWgONj00uCwCOV78wWMDHXJym/LuxnYrn8MQFnWbbM=;
 b=rjF+FXN81JyFIkm7x/VL0yKSigb4F1/aMNC/xlQgMBmhfoYKCXmh+3mRKByzDXbKToB+gOTWAeWMpJ+EzkKNw6KbRH70Ihy2dN8jLoYcqzOPYoHFSOho2CmJ2HOeYcC995VCcPwNCF2TWCmJ35Wcz4sk6Y0J6zIP04bS/vk+Ypk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH3PR10MB7495.namprd10.prod.outlook.com (2603:10b6:610:15f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6254.35; Fri, 7 Apr 2023 16:35:39 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::a870:411d:9426:21b3]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::a870:411d:9426:21b3%10]) with mapi id 15.20.6277.034; Fri, 7 Apr 2023
 16:35:38 +0000
Message-ID: <f7a7e2fd-67a0-92ba-3386-d523c5936237@oracle.com>
Date:   Fri, 7 Apr 2023 11:35:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] target: core: fix invalid memory access
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org, d.bogdanov@yadro.com
References: <20230407130033.556644-1-mlombard@redhat.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230407130033.556644-1-mlombard@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR12CA0022.namprd12.prod.outlook.com
 (2603:10b6:5:1c0::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH3PR10MB7495:EE_
X-MS-Office365-Filtering-Correlation-Id: baf19772-1ea3-44c1-5cfa-08db37861e99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vJRZOEKqkTGkcD9BbFHQ8WJF+Osn2FVnm3nn7fYHWe7Jm730OMDlo9xuIt9vj4E1atQBO5A1nLUPVz9C/+MrMvIL7hGYjW8gbsmD60pKYTykHl+LVy1cIrcuQCLVJ5UCdRWMpyuSlBvjfxVhKpBwjOWULHndAocEB10/QR/DyGS0+4+dk1Z5ZDSboJTgQaEjrzQUD8aONfFJtULZ1+0E4EFUBRNXAUm8IM905c4Usi0zBrWtah/utTEzffcjIkX9+6IMXtRF841RzV7s07PHAzhJhnEQyuIBvWlCBUwpZRjIBxYu4xaE7WJ8b/G7ESiJDQ/X6wj2+RFq2ZGW1/jQQPthCTL5tMYF1KqVdD704VAuTxbubESATLgIorsR3iW9UGDpyLS12E6kKFIy7KfpRRYM2Jh2OpxVS3vfQhJQlPLzC3u0UqWnrFz5DriFWO4F/uQUK3UWIKdV1cwkTYwTxcRwATIT+t+M34QlZS0h/MfFafVaZ/xExHNsT47ZBA1jZRjoB09RHJhP01BF5DSfhhB+NPT3In7mmpSB/YgFVToHBsAWUoWGsBSaYd+oxS+FerWlHz2SUgRq0UVgjL7rLis6IgivdMY6nH69chleN69FHUSrlawEH1PomekIvCPmrrdU3Gaqf9XewxnR/dhN3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(366004)(136003)(346002)(451199021)(36756003)(316002)(4326008)(6486002)(53546011)(66476007)(66556008)(6636002)(66946007)(8676002)(8936002)(2616005)(478600001)(41300700001)(2906002)(5660300002)(86362001)(31696002)(38100700002)(26005)(83380400001)(6512007)(6506007)(186003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZjJ6ZHc2YkRGYUh5NCtOQVpGcHorQlROVDlLbExBemg1V09VMStnY1NkUUVV?=
 =?utf-8?B?SHlEaTc1MHN1eDBZa3lWc0NCQnBFY3orT296TEo1MitrenlCZUw2TUF2dUFw?=
 =?utf-8?B?dUxRRjhINVVjKzlrbklGQ2RielhpbUJpMVRUekROeEVFd3MzVjFFNFJ1d2pI?=
 =?utf-8?B?UFUyQmIwNnZNYVFuVnpOSDNtOWkzcGZ1WWgvVFZsRkw0eGQ5L215ZEsxc2I4?=
 =?utf-8?B?Q1BabWNiOTdKWlpVTDYvbUV6YUlHbkNWR1dURndUbW5kZDYwQlEwL3Y2SW1h?=
 =?utf-8?B?NWJLdGNTYzAvaHorb1Y4cytmY09YaVlTVzZCZ0lnQlRDM0I3aDFtUllpYWVr?=
 =?utf-8?B?Qzk4bHhJNWQ0R3llUmRGSXE3Tyt4NW9ldGViYmVZS0xsWm9yNzIvSlhFazFG?=
 =?utf-8?B?Um5aQzZQMXgzTnRVaEJuNjFYY2JGMk9wTWlPMWpJVHJOYUFJdSsweGtJRndo?=
 =?utf-8?B?cHVYTUd5bXE0N2pRc1AxRHdRMTRybDRBbjlDRCt6RlBWTzR4VWlud1l6Z1c2?=
 =?utf-8?B?cERhSFJpNG9JMmx3bnNJNE9sblcyUG1uS3RWR0NId3cwWW9STE9mQUJ4MHJy?=
 =?utf-8?B?OS9Eb0FucnZnWHpQa1R1SnFVY0VuVFVJaXdvOTdqYURlR3FSWTV4ZFFJeDBC?=
 =?utf-8?B?MmFSUVJ3MjFHNzd0ZUcyUVg3Qm5LN2JpZDZzbEoyOXh0Vk9GZVg4YW5rZHVB?=
 =?utf-8?B?bCtxM1NBUXJmckpwc1dqOENHM1JUbDlDVHdUN2dUNnNLbkQyaWFsZVAxT0lF?=
 =?utf-8?B?Y01uYVZheXgyVjBKSTBkVFU3aVZGR3ZDTlZXMmxiVkxTREtHT0FMaVI4cmNm?=
 =?utf-8?B?bi9lSWl5L1dMS09GWjcxaVJhbmlVY3EyMGxPNCtWZWFDNlZiek1McDRISTE5?=
 =?utf-8?B?eEhGQlVnVy9xQkphbmRlUWl6eFljZDBjZzFVZkxZZ2RZRVVsQ0pPSkZKNzU5?=
 =?utf-8?B?ajcxQjZMeWYzeWgxZVV0V1BGdkxVNzgzRUVlQVpZT1RpKzIyQm9YOW1aUEJW?=
 =?utf-8?B?OWNYd05SU2JYdmJGUmlLNjQvczRITVYwc3ZRdXNEZWxKckw5TVNzeHJJOTA5?=
 =?utf-8?B?d1l3TE5ZVXUvVU5mYzhFdzFEQk5EeVNXQ2lxNEpQeCtsVUE3YkM0NlRiNHV3?=
 =?utf-8?B?WnFLWC94Qi93cHNNa1U4T3VZTEtvY0IrcVhXTzB6TUxaVm9OdkxLSGtaQlJV?=
 =?utf-8?B?aDVSSmc0dXRhaGdsY3FJR2FkVWg0ZitMeTExV1U0S3ZWT2FDbEtWVk80SzJI?=
 =?utf-8?B?Q2M1VmtaMUY0NjNUTlJSaksyL0MyMGZ1aDdFNGpsVml4RitHak54SnRnV0Vr?=
 =?utf-8?B?SjgybFBYUG1rWFM4SDRFaGJOZ0VET1FVTHVacUhlK0l0b0ZlSzIwODRleGhv?=
 =?utf-8?B?czc4N3JPb29OU0tyMm5XQUVjT0JKdytDTC82cHduK2RnV3ltbUZYQkhsOFl4?=
 =?utf-8?B?NW5ia3NpUm5BbGEwbGtNOHNLWXNpRFhUQmtLek10N3JOdkp3ZVU5ZEhSUGp2?=
 =?utf-8?B?c1VFN0t4ZlJxTm93TFdQZWpzS2h1RXUxQkUwR2N1VnBuaTg2WlpTOGlLZFRv?=
 =?utf-8?B?cHZVbE1QMlVLN3dhaDRvYkRkejJuUGp5SDF6YnBtTS9FNGpqOGVFZDRZSmFq?=
 =?utf-8?B?emZRb0MxN2ZaS0JmblgvUHlJNTRkNTQ3SGplS0dxZ0MxM1l5eW5ubmJ2UDVs?=
 =?utf-8?B?VkEwSTdzR21QWnRqaTl3azU4enZGQjNYMmtSKytST1dvaWFjRWFKUWNnbEp6?=
 =?utf-8?B?WXcvRWtsWjNPY0tXTXdMUGxZY3JCRWhEZjBYRDk3SElFN1c3WUQ2V1VHOFdD?=
 =?utf-8?B?L0htQllDZ0wvTEQvTkVuSE5pQ1RXRjk3aHFJV2FpNjA3NEx3VjVFQ2RYM2dy?=
 =?utf-8?B?ZkN1eUNQQ0hwYkM4ZkJpWW53SXlNUGJseE5LYnFOVTJTczhWWC9Xbm8rTzVy?=
 =?utf-8?B?cHhucjIvT2x2UGl0WWtuTklBL1RYSy9YcWwva3p6cFNSRzZHaEdMTkR6eHpR?=
 =?utf-8?B?SkpNaDJlWlptc3JVMkJvV1JkRWdJdDBrZXlVRTZXOE5BeGU1V1ZqUTFEMS85?=
 =?utf-8?B?TVFxUXI0b3RwTnkrNmpXYVNMdVhPbXB1RE5FV1RDN05Bb0pIeDNzeldCU21R?=
 =?utf-8?B?ejgzWGtIT3BaUW8xUUZRYVo2Q1JNdVVwaVRSUURVdnQ0WStIY1JBTzFtTUZY?=
 =?utf-8?B?emc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: cjT+4YgjLvy92ax8jGVOAQSPJD4teTtUrAveSreImjfbi6MAGmRfWLRuKkY9yz1WeL5gvnCKOguDbOkchVCc1EMC7MIrkrihisBpLZPttuhoBkjQ1K3vN5mYbJaAG0NCI/BbkPn68vK9I2R6BFf3oRFOC1YE6FVG9bZcHAeWdLImk7ji0oJoYwjXgcQbX8XwNiczPEeE70N8XCQZq0YjWYwDxkCEaK3LmzgkN6uUJOlZlTcFq5Raho9QAfCoMXMKC2+FwvXJRV7QFC2oBAeshqa8P03+izUDXnLNCv6dshasEii9qLggHxE6yhXoRcgi4XFZ3uIvlbJEoGU1CfdOMzbPy1t7QreUgbyhwBmSqXhjOdlAeqGe1tPqDH4vxxQiRyGiftBk2BS+/dg3vbPmrwqChB8q4Cgynh4zDdpmkww9DqlzMEyKnG2PfizspR7JxR2RzrM5TOxtmsnJnjdQ+0rHK+Yn8PGu7l4t2tEzo1cPdjVecdAKkbkI0ZnjDtEuarVaUmQ6x4RLn7F/wkLNrBlq4ubaUN9loDjo0TbA7dTs2xLSBaTLo0fAEjD2NpP+o040vX7QkMm+ekmPzlSENKuewg1IXcXztLB/vLlM18VUIk2Qmo5UgifsCEXgc4AtDgNfK26fEmX9PdvoWdDY20fh+c10oPtOKUcgZE48NIA70ZBpXzZod4uKb91vobA2IaOg4icJdAbZJvF2FOOPRDA+3xT4mdvXljiG13NULxO89lz2x9VgEQ3NUGPf9ygoA1FV71/LzAC8COJ0sT+oQfvWcWrFRQYLrGOGeELp9+6r+l3UHiajsyQslE+zN+tS
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: baf19772-1ea3-44c1-5cfa-08db37861e99
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 16:35:38.3408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YSw+O9jtjGbjhYBGRfrpdCzUm9javm9uGp3qoa/8cZBxIu0lCf7G95huOggp5/1I7Z3yqrV5dVqBHwT0Y8vJW5dCzVWw/wQELn4VUmxf1Ks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7495
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-07_10,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304070152
X-Proofpoint-ORIG-GUID: -89wCD0oVO6OC_K_rwgC8vSC87nnm_ne
X-Proofpoint-GUID: -89wCD0oVO6OC_K_rwgC8vSC87nnm_ne
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 4/7/23 8:00 AM, Maurizio Lombardi wrote:
> nr_attrs should start counting from zero, otherwise we
> will end up dereferencing an invalid memory address.
> 
> $ targetcli /loopback create
> 
>  general protection fault
>  RIP: 0010:configfs_create_file+0x12/0x70
>  Call Trace:
>   <TASK>
>   configfs_attach_item.part.0+0x5f/0x150
>   configfs_attach_group.isra.0+0x49/0x120
>   configfs_mkdir+0x24f/0x4d0
>   vfs_mkdir+0x192/0x240
>   do_mkdirat+0x131/0x160
>   __x64_sys_mkdir+0x48/0x70
>   do_syscall_64+0x5c/0x90
> 
> Fixes: 31177b74790c ("scsi: target: core: Add RTPI attribute for target port")
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/target/target_core_fabric_configfs.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
> index 0ce47e21e0c8..b7c637644cd4 100644
> --- a/drivers/target/target_core_fabric_configfs.c
> +++ b/drivers/target/target_core_fabric_configfs.c
> @@ -885,7 +885,7 @@ target_fabric_setup_tpg_base_cit(struct target_fabric_configfs *tf)
>  {
>  	struct config_item_type *cit = &tf->tf_tpg_base_cit;
>  	struct configfs_attribute **attrs = NULL;
> -	size_t nr_attrs = 1;
> +	size_t nr_attrs = 0;
>  	int i = 0;
>  
>  	if (tf->tf_ops->tfc_tpg_base_attrs)
> @@ -895,8 +895,8 @@ target_fabric_setup_tpg_base_cit(struct target_fabric_configfs *tf)
>  	if (tf->tf_ops->fabric_enable_tpg)
>  		nr_attrs++;
>  
> -	if (nr_attrs == 0)
> -		goto done;
> +	/* + 1 for target_fabric_tpg_base_attr_rtpi */
> +	nr_attrs++;
>  
>  	/* + 1 for final NULL in the array */
>  	attrs = kcalloc(nr_attrs + 1, sizeof(*attrs), GFP_KERNEL);
> @@ -912,7 +912,6 @@ target_fabric_setup_tpg_base_cit(struct target_fabric_configfs *tf)
>  
>  	attrs[i++] = &target_fabric_tpg_base_attr_rtpi;
>  
> -done:
>  	cit->ct_item_ops = &target_fabric_tpg_base_item_ops;
>  	cit->ct_attrs = attrs;
>  	cit->ct_owner = tf->tf_ops->module;

Reviewed-by: Mike Christie <michael.christie@oracle.com>
