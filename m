Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A43FEC6FD19
	for <target-devel@archiver.kernel.org>; Mon, 13 Mar 2023 23:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjCMXwy (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 13 Mar 2023 19:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjCMXwx (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 13 Mar 2023 19:52:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1457687A3E
        for <target-devel@vger.kernel.org>; Mon, 13 Mar 2023 16:52:50 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32DNJUda008583;
        Mon, 13 Mar 2023 23:52:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=wrDChY+3leeqkEM2WyOTJgN3ESxOb1BvnBtWZMLNcdw=;
 b=FYJuQnXRMHFaai/Lwj0jFSwSbwJpOlrBnGWIYn+wfvirmVzi3NZ8sZHHWyITAIgq9TkF
 26XY0i29UTRW3rv/SnK8ENqPDJU2pNLcnTM2hbCk6i7g5BRfKGQ7HrJzjpRXQ2cAv89U
 5OGdpi8ZvbaJUNXXVy7beoV2gpr0Tlss+UMQvpwHedwNzzfSLgzZkCS/pN47JIZomddv
 Po/5uBLGOHgCJcLbKxPRI7jC9bxx1XT9UqGEpGXx3nEUzDtEAdEuMPXZ4JRLE5/RO7uk
 XCF8XL+LOWnqfVBkkSfp/jQwVkCtr+UeZ02j1jfkK6ABgIxTXQr/3g39SJb/4gvZ2bMW zg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p8hhad6vj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Mar 2023 23:52:47 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32DLAkdc008311;
        Mon, 13 Mar 2023 23:52:47 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p8g35bern-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Mar 2023 23:52:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QrL9b8QgEsb/l3QQPsySyQwTjGIqwYvFk8aanl/0rQl/DcgJQ5svK7/v/3tXiSZ2j2gY7aq3Y42ixA3voSiPGmRP5t0ugsX5krpGT+wRlUaJRqW8cFBg357ajzA8zuvDWNrsElrqFSMD9uYAv5r2KRamL7x2/UfXkTxxONkr/ibDp+NuDaEMPopNcTm4pR5+OBpTn6hEs4aEnbXz6nNaBG7z2ZKKJLdWOXqy9iFWu9n1tQ9ErmQRDHYqYrf6I5P0vQ/4PClJXMzeCBkOdihh8Ag2XJuzLu+c+Wb6oDKMBCdEKu54gWMYLrnbDDmVoZ3I/C7Ih6Yt+hUHBIaWk2yDtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wrDChY+3leeqkEM2WyOTJgN3ESxOb1BvnBtWZMLNcdw=;
 b=TZ5/LgqeYvvQWqz5lIBFP72lnw6WJvg5w/2x50PGk3/eaF9qSDHiIG2vKaMq1eDT8adeHjKHmTPLPS8LdQKppCwm8NdIf7XyWD0QA4tX54lvUd1BK6qQq4VS9aJGt8BG0N94u8A2/IHui6GU7CGmVlTrQfwHtC9FZFf4r/lJqdQMwOQtY6Ip42x4RpGDlMae6zTy62yzO0G4WC261r3YuUneEaUgdXyqVpMnOHe9XlB5mRgxVo2wZLWBu5e6f/1lbI8xYRHPbL/L3SEPrObo3UM3v7bhIshcBmT7pxQjORBvYc+aHgwJTTCW4BDecDG5bTR6+DSmnzZ03lh4lpLnBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wrDChY+3leeqkEM2WyOTJgN3ESxOb1BvnBtWZMLNcdw=;
 b=iaXmHvaFFLfI0Q/2PjcNaZqEs9w0Jor08X5QpoVhZsZxTdq641clV4ue5ZYR2nCAZabQPM4DrIb2g/llPYBDaVUqq4D+8vOeYcMFKEJmZDLRRB3v0ppUXx4VbzqQ2ySzlfG41n3Ix1/uV5j1A0zLcMWpPLSj8Z1mhGOEaF2Hwzo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH7PR10MB5721.namprd10.prod.outlook.com (2603:10b6:510:130::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Mon, 13 Mar 2023 23:52:44 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.026; Mon, 13 Mar 2023
 23:52:44 +0000
Message-ID: <f492ed26-58fd-0f4d-b1f2-b4cbd2cca233@oracle.com>
Date:   Mon, 13 Mar 2023 18:52:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/3] target: iscsi: fix hang in the iSCSI login code
Content-Language: en-US
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     serapheim.dimitro@delphix.com, target-devel@vger.kernel.org
References: <20230310100423.1258256-1-mlombard@redhat.com>
 <20230310100423.1258256-2-mlombard@redhat.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230310100423.1258256-2-mlombard@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR21CA0026.namprd21.prod.outlook.com
 (2603:10b6:5:174::36) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH7PR10MB5721:EE_
X-MS-Office365-Filtering-Correlation-Id: c28ea3ca-aca6-4040-0b6b-08db241e09d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lAgtw+rNRBqUZ25ThL0CXCh7vO1NKoRwjzVzwn7dqTZMV52HXXSFCGleag+/0rGfzEzuingHTvDuABYoo4r0EfnjSqgj97QgLku2TH2kh6W0ywedVTdqhsHNEuyPrzlK3EOCUU6ZSbByHiyVW7JKShA9ymUtQOnO8wgM0WCucyT7InJkW8C2c+XqUF9h0OiKo63xoJIdVkGW0toe8h0U5qBA0D0iYUb8wGlORMa6I9vZzXQM6AR64vk6VQQZOA9okVdP1A4vOPctjgN6wrIq+0biW+FuSjrX9vttnLGFtv3cLFLXwqi2g14R4vOM1Bp/q3LSAdLreHuslmDQrcpO1o60/7JcZ0Mrmz49dBCw3YYZaTtoUk1vW7cft9Z8j/tg6BPaBVN5QqkvKbCnlNJfZIMFpo18OGMAMKvYK8g6pq3PHc2UP2dS1keMK1uSYzQaC5hou1nEb4g4eZJaDF5N/X3/ZXVEvgzHeXDaHi7rh6Of2/eKJxgwb2Gy9s6QwHDCkWNrarXHtm3Z1yuQ2C1flp0+COtspvaEQQ8I+Sk2B3wHN9JsBZLw+Et3nD0mXLmC3Xv88BWdaooD7owFQn8Tfq+AgKNrWfTnUaMxcNvNf1mH6hIztci0a8J0ceXdHwy65E6ompu/zjWChF9ltsr4hDleOBIUq5RXIicerHMpAP2dxeDUHyYNDDBXa1UFSiigvltYTaHO1fwBawJydtF8nfvaJqY056mWnDqyAqVcD/0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(39860400002)(136003)(366004)(346002)(451199018)(2906002)(31686004)(83380400001)(36756003)(5660300002)(6636002)(66946007)(41300700001)(8676002)(8936002)(66556008)(66476007)(4326008)(316002)(38100700002)(86362001)(31696002)(478600001)(186003)(2616005)(53546011)(26005)(6486002)(6512007)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ti9UNWNheFBadUJnT0RtT2hMeDlBZWU4a0dRQWZBMUhON0dVeU01RUZDWDVR?=
 =?utf-8?B?VCthV25ESE9SZE1JMW8wbmVtUkNvRGZ4L2tIYk93YUs2RkF2b2NXZ2ZWNnFI?=
 =?utf-8?B?RWxnL1dCTlZGb1lrRUhqcytZM08yNWVYNnI1MmU3c0xJdnZYVC8xZFVKdmVz?=
 =?utf-8?B?dnZ4dm14ZHkraDdTdXBpb2FJdUhtMkN3eWk0UkpJdE0yTnByNjhvSGRVVW5t?=
 =?utf-8?B?VVVVWkZvSkN0UlQ0TzdWYWJDR21ET1N2bkR5eXpYM0hpa0RVRHZNZDZpdS9O?=
 =?utf-8?B?R2J5R0I0UzZWbk1wQ1pNbHBLQzUwNkwzb1M5dzJmS3hKUG80dmlpM3ZOczE0?=
 =?utf-8?B?dG5JTTFZWFl1dkhFT1k1RXJUZkR5MG0zTFlXd1RrNEdIM3RLUTcvZlcvaVdE?=
 =?utf-8?B?TjU0Z1cvbDFZUnBiZ1VEaUh2M0crWEdLaEJlSXl1SHp5R0ZsYWVXeDJJWldL?=
 =?utf-8?B?ZE13YXlKbkhiNWtQT3lEc1hyaHJoZ0pId2FPNm5nQ3NHN0FaQ3FEa1ZsOFlz?=
 =?utf-8?B?UU14NHhZbWZ6bXB2UDc2THJKeHN4NktSeEVCOUl1SDZaQkRQaGFKUU9jdUVQ?=
 =?utf-8?B?VmtKYWorVVFNbWh2TVNJTTMrdnllMklhbWh2ZFZLRGtzd0JzYXppa0I3eTNw?=
 =?utf-8?B?dUpQMVNiV0h2ZldSU2dTK3NPNFN0TFQ2N2lLa211bW5RaENYMEx3NEtndUJF?=
 =?utf-8?B?NzFCRy9SejZ5SnNKeTMrUGdUWHZLSEt2MWJpMUs2WXMwV0pua2lucDcwQ3dN?=
 =?utf-8?B?bTBMdnBxTC8zZ0xMTEhQRHlyRVNzV3BZazlhaVFreW5GTlRSSmdsM2dpSHBx?=
 =?utf-8?B?WjNNT01oUXBZb2hrNVhTY1JFdTVuaFJLRWdQSzdkdjdVZitUTXM4a3EvRlN4?=
 =?utf-8?B?bnAwclJBSWUyOWZXdktHcWMwMFJmcGxtcHROcG45bVlEY2hYQWU5cUwyaUZs?=
 =?utf-8?B?Nm8vRkRxZmorZ3g1cXdTVXFzY0pjb1FDQXZzNXJiUEkvaVdsYnpkNGloMWNm?=
 =?utf-8?B?U3l1VHdLcVpUUHRzenpYczVZeE4wVE55Mnc1am1BS0xVdTNxbTVsU1llOHZu?=
 =?utf-8?B?TVV6QlZpTytyUHlidE1pYVFYbXR6b1E3a1UxQ0U1U0o4MjlRMkxSRVhGQW52?=
 =?utf-8?B?RXRzc1BxeFNHSjZrMmR2am9BVkdRVG1WL1duM2Qzb2tIeWxSTnlzK3FtQ3RM?=
 =?utf-8?B?WHd5RFNHOHRiYnBpT1JUb2lvdlBLVjlXdlRTcXZBSjM0Y0FiR0tsSXFaNTVF?=
 =?utf-8?B?TzFYdGpvanhldUczVmlqaDZNWjlkWmtCNlVNTHJqdklqL2QxLzZ2VzkweFpx?=
 =?utf-8?B?bnRUODBXVHA0SXhwMUVsSkM2R1F6TDcycmlUd0xXanlVdTc4dk5YaGhzY011?=
 =?utf-8?B?QU16b09iV0lMdElxWms3MVlBRzg4bUdHbmhrdkc0c084YlN3emkwbVMzcDla?=
 =?utf-8?B?YzJ6SWY1WGdGL2IrMWFkdndhTVRCNnhERmRXcFEvcVM3blNKYjBibmJwS1dD?=
 =?utf-8?B?NkhlbFlRdmZtTHVONElKa0k1M1BUNHlXVzBFa1ZqSjAveEpMQjBRYXBaZ0FJ?=
 =?utf-8?B?YnhHeVcxR3ltQ0Zkb3BYNlN6REl1SDFyWmJrR2daM21nbS85clBqdUJidExK?=
 =?utf-8?B?MTlHMTc3ZGl4ZjVJYlMvQUM1cUhrNjV3b0k2bjdKTmVHeXhiVzFZWk9ub3Rh?=
 =?utf-8?B?RE1MbTcwdFQxTjE5STgwaFJjY3V1Ym9YTThyRnI0cjk2NXJZdk16REVlV0NO?=
 =?utf-8?B?MFNWWGpWMHZ3Q1RybWF5Rkt4V3A1K0hlRDh3ZmNESHBQRnh2M0lOcTJPMDZM?=
 =?utf-8?B?VUVKYTlBR2ZNa2lwRjlONGVNcUpTWTlKRloxSHJEVnhNRG9nK3dwbHdsdTlx?=
 =?utf-8?B?OHU2SVNIbVJkRVcwc3hzSnd2V3lZbm5nVzZaSWZ2NHVlZkxmeGJLMnZEcnBa?=
 =?utf-8?B?Zk42OTFPc3ZFNmJWd3hEUXR0SzVhZlNaWHhPQzQwZlhnNW1IODFjaDh4d1A3?=
 =?utf-8?B?VTRPSmJueEFnWHc5MTgvQ3BWb2E1N2lsRkhWTFpsMDBMVzF2RUFQRldhVkdK?=
 =?utf-8?B?UmpUQkR6dzUvY1d5T2NCMmV5L0MzaTVINzY5dWk1clk1bzVJNklBNFRVK2pD?=
 =?utf-8?B?OHVINXIrWDQ1cHc0K1h4R2MxMmNNUzJhS0VHL2R3TkJyN2huYlVsRlJoRW8z?=
 =?utf-8?B?Smc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: lbXJKdqNKYGj4cVBGZMk1/iswnGYtT7AfEu9F5vaejYOBDnNEyd9HHl+ObN7R2ExBQNjJ9VDw2RHx052il9QFwM1YEtYJxt2dBZcx/X9h3ksnHgwdU02C6xfQimuX34dH65OjhkQN4gC8+06LmnpuESsHqPnzMbYXGEzHjfnMRLhkwxvkR8Zt/DAgenW1dL9NS2k8p3imt6rMtoDxBTSR924Ecj0w5/uzOohd3CFx/SS8nKjQZ+LwAqD6UgJDzpioxtOrr1EBafLg9pU7Cp6UDpEvgNGT29jRwcgPb25J9DI5TolUDfYTwcCB8KX/MT0mlWSBEc+rWbsZLkIDVWO1D3XjD1IyBdTTk76rosRWLpPqGfya21kIvpJBVNp9hwV2xJHBjacaDOOhHXy+h1WhhTX31IB/1zi3r1kIJPCDvA9CzniZXepHYaIZTDf8J4jMidVsDwUnu62cuZa56QP7KRsjbne/ZhpxZnDqyE4IRHcIT05M8lQWYkMTTiqJ9ugUfMtR1VfvCLhBtt4IXA7Xjec6CB59koqMcl8E2mjiI7PR+XrCmfvoE8A1V1ZXAKDMwbnxVKx9KV9tN1NZPJQRs7b5wX4GjSUJHje+75xRL8wy+MEin7mZVjwfcM8Vfi7idU9iGygpdQz3MKAorQ3pR+XXvNk3t5dLStG/Pu1W4C46ehDpRF9ncFizgE+ETwt0lgzwE3ZNfc59j+zNOAewv4eOYvC7+4m1qfbY26TJXDFEcSDpt7iyCIDd324TG8o3vKsdLsD0/8mHbHyuQOzCJveBjxKp1vYgQ2aj/jcPY5NBbmrCEsjpudpzj7lbuAoj+3Yuc9avtgEfZbXK1K7Gg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c28ea3ca-aca6-4040-0b6b-08db241e09d9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 23:52:43.8238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h8Tw2KZhvmHkGezSEW80Hx0L2IvCRb11d10QzoPgKX98ZVmcoGghbnfFYfQYH/D2Xshc/rw366l+styVhL+lIlWuYlDyWTQwoB+8Y+At7WE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5721
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-13_11,2023-03-13_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303130188
X-Proofpoint-GUID: vj0n6jEgglWeZFlMV7SuRW5OJuzNtPms
X-Proofpoint-ORIG-GUID: vj0n6jEgglWeZFlMV7SuRW5OJuzNtPms
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 3/10/23 4:04 AM, Maurizio Lombardi wrote:
> If the initiator suddenly stops sending data during a login while
> keeping the TCP connection open, the sk_data_ready callback won't
> schedule the login_work and the latter
> will never timeout and release the login semaphore.
> 
> All the other login operations will therefore get stuck waiting
> for the semaphore to be released.
> 
> Add a timer to check if the initiator became unresponsive, this is how it
> works:
> 
>   * The timer is started in iscsi_target_start_negotiation(), before
>     clearing tre LOGIN_FLAGS_INITIAL_PDU flag.
>   * If iscsi_target_do_login() returned a non-zero value, this means that
>     the login operation either failed or didn't require additional PDUs;
>     in this case the timer is immediately stopped.
>   * If iscsi_target_do_login() returned zero then the control of
>     the login operation is passed to login_work that will take over the
>     responsibility of releasing the login semaphore and stopping the timer.
>   * If login_work gets stuck, the login timer will expire and
>     will force the login to fail (by sending a SIGINT to the login kthread
>     and by closing the socket).
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/target/iscsi/iscsi_target_login.c |  1 +
>  drivers/target/iscsi/iscsi_target_nego.c  | 56 ++++++++++-------------
>  drivers/target/iscsi/iscsi_target_util.c  | 26 +++++++++++
>  drivers/target/iscsi/iscsi_target_util.h  |  3 ++
>  include/target/iscsi/iscsi_target_core.h  |  1 +
>  5 files changed, 56 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
> index 27e448c2d066..bb7d5a596266 100644
> --- a/drivers/target/iscsi/iscsi_target_login.c
> +++ b/drivers/target/iscsi/iscsi_target_login.c
> @@ -1127,6 +1127,7 @@ static struct iscsit_conn *iscsit_alloc_conn(struct iscsi_np *np)
>  	timer_setup(&conn->nopin_response_timer,
>  		    iscsit_handle_nopin_response_timeout, 0);
>  	timer_setup(&conn->nopin_timer, iscsit_handle_nopin_timeout, 0);
> +	timer_setup(&conn->login_timer, iscsit_login_timeout, 0);
>  
>  	if (iscsit_conn_set_transport(conn, np->np_transport) < 0)
>  		goto free_conn;
> diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
> index 24040c118e49..f901a7231c48 100644
> --- a/drivers/target/iscsi/iscsi_target_nego.c
> +++ b/drivers/target/iscsi/iscsi_target_nego.c
> @@ -472,12 +472,18 @@ static int iscsi_target_do_login(struct iscsit_conn *, struct iscsi_login *);
>  
>  static bool __iscsi_target_sk_check_close(struct sock *sk)
>  {
> -	if (sk->sk_state == TCP_CLOSE_WAIT || sk->sk_state == TCP_CLOSE) {
> -		pr_debug("__iscsi_target_sk_check_close: TCP_CLOSE_WAIT|TCP_CLOSE,"
> +	switch (sk->sk_state) {
> +	case TCP_FIN_WAIT1:
> +	case TCP_FIN_WAIT2:
> +	case TCP_CLOSE_WAIT:
> +	case TCP_LAST_ACK:
> +	case TCP_CLOSE:
> +		pr_debug("__iscsi_target_sk_check_close: socket closing,"
>  			"returning TRUE\n");

Don't need to break up a string. We do it a lot in the lio code, but we've
been trying not to in new code.

>  		return true;
> +	default:
> +		return false;
>  	}
> -	return false;
>  }
>  
>  static bool iscsi_target_sk_check_close(struct iscsit_conn *conn)
> @@ -535,25 +541,6 @@ static void iscsi_target_login_drop(struct iscsit_conn *conn, struct iscsi_login
>  	iscsi_target_login_sess_out(conn, zero_tsih, true);
>  }
>  
> -struct conn_timeout {
> -	struct timer_list timer;
> -	struct iscsit_conn *conn;
> -};
> -
> -static void iscsi_target_login_timeout(struct timer_list *t)
> -{
> -	struct conn_timeout *timeout = from_timer(timeout, t, timer);
> -	struct iscsit_conn *conn = timeout->conn;
> -
> -	pr_debug("Entering iscsi_target_login_timeout >>>>>>>>>>>>>>>>>>>\n");
> -
> -	if (conn->login_kworker) {
> -		pr_debug("Sending SIGINT to conn->login_kworker %s/%d\n",
> -			 conn->login_kworker->comm, conn->login_kworker->pid);
> -		send_sig(SIGINT, conn->login_kworker, 1);
> -	}
> -}
> -
>  static void iscsi_target_do_login_rx(struct work_struct *work)
>  {
>  	struct iscsit_conn *conn = container_of(work,
> @@ -562,7 +549,6 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
>  	struct iscsi_np *np = login->np;
>  	struct iscsi_portal_group *tpg = conn->tpg;
>  	struct iscsi_tpg_np *tpg_np = conn->tpg_np;
> -	struct conn_timeout timeout;
>  	int rc, zero_tsih = login->zero_tsih;
>  	bool state;
>  
> @@ -597,17 +583,13 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
>  		goto err;
>  	}
>  
> -	conn->login_kworker = current;
>  	allow_signal(SIGINT);
> -
> -	timeout.conn = conn;
> -	timer_setup_on_stack(&timeout.timer, iscsi_target_login_timeout, 0);
> -	mod_timer(&timeout.timer, jiffies + TA_LOGIN_TIMEOUT * HZ);
> -	pr_debug("Starting login timer for %s/%d\n", current->comm, current->pid);
> +	iscsit_start_login_timer(conn);
> +	conn->login_kworker = current;>  
>  	rc = conn->conn_transport->iscsit_get_login_rx(conn, login);
> -	del_timer_sync(&timeout.timer);
> -	destroy_timer_on_stack(&timeout.timer);
> +
> +	iscsit_stop_login_timer(conn);
>  	flush_signals(current);
>  	conn->login_kworker = NULL;
>  
> @@ -646,6 +628,13 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
>  		if (iscsi_target_sk_check_and_clear(conn,
>  						    LOGIN_FLAGS_WRITE_ACTIVE))
>  			goto err;
> +
> +		/*
> +		 * Restart the login timer to prevent the
> +		 * login process from getting stuck if the initiator

I would fix up the formatting so the first line is longer.

> +		 * stops sending data.
> +		 */
> +		iscsit_start_login_timer(conn);
>  	} else if (rc == 1) {
>  		cancel_delayed_work(&conn->login_work);
>  		iscsi_target_nego_release(conn);
> @@ -657,6 +646,7 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
>  err:
>  	iscsi_target_restore_sock_callbacks(conn);
>  	cancel_delayed_work(&conn->login_work);
> +	iscsit_stop_login_timer(conn);>  	iscsi_target_login_drop(conn, login);
>  	iscsit_deaccess_np(np, tpg, tpg_np);
>  }
> @@ -1358,6 +1348,9 @@ int iscsi_target_start_negotiation(
>  		set_bit(LOGIN_FLAGS_INITIAL_PDU, &conn->login_flags);
>  		write_unlock_bh(&sk->sk_callback_lock);
>  	}
> +
> +	iscsit_start_login_timer(conn);

At this time, we have the np->np_login_timer running right?

Don't we only need to start this new timer when we know there are
more PDUs and the connection is good (iscsi_target_do_login returns
0 and iscsi_target_sk_check_and_clear returns 0)?

I think you can just kill np timer and only use the login_timer for
both cases. So I mean set the thread to kill as the login one and start
this login_timer in __iscsi_target_login_thread where we used to call
iscsi_start_login_thread_timer. You would then mod the timer when we
transition from iscsi_target_start_negotiation to waiting for the next
PDU.

> +
>  	/*
>  	 * If iscsi_target_do_login returns zero to signal more PDU
>  	 * exchanges are required to complete the login, go ahead and
> @@ -1377,6 +1370,7 @@ int iscsi_target_start_negotiation(
>  	}
>  	if (ret != 0) {
>  		cancel_delayed_work_sync(&conn->login_work);
> +		iscsit_stop_login_timer(conn);
>  		iscsi_target_nego_release(conn);
>  	}
>  
> diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
> index 26dc8ed3045b..414e883c5a0d 100644
> --- a/drivers/target/iscsi/iscsi_target_util.c
> +++ b/drivers/target/iscsi/iscsi_target_util.c
> @@ -1040,6 +1040,32 @@ void iscsit_stop_nopin_timer(struct iscsit_conn *conn)
>  	spin_unlock_bh(&conn->nopin_timer_lock);
>  }
>  
> +void iscsit_login_timeout(struct timer_list *t)
> +{
> +	struct iscsit_conn *conn = from_timer(conn, t, login_timer);
> +
> +	pr_debug("Entering iscsi_target_login_timeout >>>>>>>>>>>>>>>>>>>\n");
> +
> +	if (conn->login_kworker) {
> +		pr_debug("Sending SIGINT to conn->login_kworker %s/%d\n",
> +			 conn->login_kworker->comm, conn->login_kworker->pid);
> +		send_sig(SIGINT, conn->login_kworker, 1);
> +	}
> +	kernel_sock_shutdown(conn->sock, SHUT_RDWR);

For isert and cxgbit we won't have conn->sock set so I think you need some
sort of callout for those drivers, or maybe set LOGIN_FLAGS_CLOSED and queue
the login_work. Maybe the latter will work for all drivers as well. You probably
need some extra locking and LOGIN_FLAGS checks to handle an issue similar to
below.

If we do need to do the kernel_sock_shutdown we might need to add some code
to not call it twice (I'm not sure it's fully supported). It looks like we
can race and do:

1. login_work has just been queued.
2. But the login timer fires. We run kernel_sock_shutdown and
iscsi_target_sk_state_change starts to run but has not yet taken
the sk_callback_lock because..
3. iscsit_get_login_rx already started and passed the
iscsi_target_sk_check_close check. It re-arms the timer and calls
iscsit_get_login_rx.
4. iscsi_target_sk_state_change takes the lock and sets LOGIN_FLAGS_CLOSED.
5. We timeout again from #3 since we called kernel_sock_shutdown before.
