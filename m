Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E574C07E9B
	for <target-devel@archiver.kernel.org>; Wed, 21 Jul 2021 03:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEB4761106
	for <target-devel@archiver.kernel.org>; Wed, 21 Jul 2021 03:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbhGUCm3 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 20 Jul 2021 22:42:29 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:25968 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231499AbhGUCmX (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 20 Jul 2021 22:42:23 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16L3Gudk016288;
        Wed, 21 Jul 2021 03:22:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=f4Y+icFyCiSlyewM7K5vBgQnCiHjvvVAC/LB9S9Bkgk=;
 b=YLK2AQWtQzdmyu2dDoeOM8oObl2/UDulGrB0dstynPUk/bNBERSkoGeHR7R/vN5AYUhp
 dyMbfFUU3YhMQY2Gl2ybKds6YWAklFq7eamZ7vwZl57uABlLpEjd9RYRZ5uFvgtTLjNf
 eG4xCKw4YVXnXSBvK/THS85zjb21Q3Nf6RPvmem5RVN6vR4JNqXXJZ4ww6LkocA1gDD3
 MMmrHi5c6fKO3NYj2w4ajQWdl+yDudPBYMYcGRyaiEqTZ2MhbDYW4bUBnuO/IdJQ5MWC
 sjDsMRNQy57LulWc2ogyVoI2lEqIXISKmCkyXrdhE/JTusjpybx4fiDUEAsW+fPIYaMs 8Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=f4Y+icFyCiSlyewM7K5vBgQnCiHjvvVAC/LB9S9Bkgk=;
 b=qQRNP6ebKiAsANkqI0EFc2D65BkHEUPwM2clp5rlJYT4lbqnHN4zodFlr97EFtJLQrD5
 sw3CzSnd5DXlnom9o1BPfWXcRF3R48sPq2kYpb3oYXdIKrDNDlJLMtwwYd8Vq0RWy05t
 DIqWSYUY0iZNQxnqd7gxtchU6J0l2GGU0rDylVAgFdimDj78loblcXi0Y5IBONy9kHFc
 lmWlRW2MJbJ4OeSYLT8SSejqxYV1Zj9wmnShL2Hj1OzfWYNada319px/WEsmCJ6UiMuo
 DHk0O3FDM8FhOiJhJxadER94zztxvRCFChhlGx7m/LtB0Fwz9hdfJysH77HjzocRY6eX VA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39wwmtsp44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jul 2021 03:22:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16L3GWU4041333;
        Wed, 21 Jul 2021 03:22:53 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by userp3030.oracle.com with ESMTP id 39umb1rdnt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jul 2021 03:22:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EHnkCO2W7jVWtwMdcBJvXr9X2DJiFk1+gP633lZVfo162hDpjoDpyywwkVnpc/yOCeiQbnh2VPjOgWUZVTEF+9z9EqSNVmk+17EBle80aZHSF5obxRws3didxihEckwW67oVdTq+Qm9PTWWzo9Q+3ESsm+a07NAxUUU24iDoJ46YhPD5qy1k9XHCSC1Fes7Qq5h1rUVzGkbCWLQqmirvsdN1Jaqp6mWqKGm24hIU87n7zxrCVn0FIdV69JIOOxrU4xVRlfKkioVpDQ9ORv4d039ixE6ogyM/HgS6GNDzTf7Bm15rcBHWjugC4xrr1mqtFqrfMgdzgGT/IOr3suyiyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f4Y+icFyCiSlyewM7K5vBgQnCiHjvvVAC/LB9S9Bkgk=;
 b=MAwvu2OZ8DhYvBQUhU7C9DjCje3Oa8VnXGJiw1XzxdXauyxoBVHrCKqoHWn8tl1yVRlL63ddjm+fTlhwRNIPWmsQwzSYAlUdYG3ljSNqWfAVUlFt1FPs1AfDeW8+3dbl4fZWnRAgvMZxEy9Dl1hxlvqzj1Jjw9+0yhgsM810KyisK83B3GWgkxeDvkpNJxLktIQLBBaPP27A/ULR6HMzVSv5q4l0609xT9IV+bG0GgcaaMKj+uoTBJC3XPcMX9UUdLLkAvVHJvGduZSbqIWkz/CPPyC00+DWDFTGF2+4tb+SiDZNtSq/u68J0KyR+V2+n4amMr6bGjefLjyurWUR8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f4Y+icFyCiSlyewM7K5vBgQnCiHjvvVAC/LB9S9Bkgk=;
 b=lgUXAJCOsa7guQWLLmu6aDeZFp83U87xxuH0bE14vz5aebC5JgpMkHBOE9hLngDlTtQH+ekTx2sjRIw/jmgiIFeVvtyYsqs9vkZ6FwipdtLc76nPSS1QD8SYbzzbKMI6omm6h7uaB1BDNyxPO7oEqHiGkVG3B9YJWf/vlFAQTM0=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4680.namprd10.prod.outlook.com (2603:10b6:510:3e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Wed, 21 Jul
 2021 03:22:52 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 03:22:51 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     David Disseldorp <ddiss@suse.de>, target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH] scsi: target: fix NULL dereference on XCOPY completion
Date:   Tue, 20 Jul 2021 23:22:46 -0400
Message-Id: <162683773927.29160.6924179509253006982.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210720225522.26291-1-ddiss@suse.de>
References: <20210720225522.26291-1-ddiss@suse.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:806:130::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR13CA0008.namprd13.prod.outlook.com (2603:10b6:806:130::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.13 via Frontend Transport; Wed, 21 Jul 2021 03:22:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e90ea7c-b293-4e58-0be9-08d94bf6d297
X-MS-TrafficTypeDiagnostic: PH0PR10MB4680:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46800330A34EE9FDD976068C8EE39@PH0PR10MB4680.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KaC/0ECPdidVNxjrqfFhSz/6kqG36+yMcwnv6uj6phTO700zLRzeYxNjRaesyZN/MnbuJ/KSmIAiXa62kIVMKZTGA+e9lY6wTzj9r1ygNiNLFxEDoK0Erxl7ruh8fGZi5JjnC7vnX+M3Ut+CbZQ6vTJhGQUh7W20nflrE7gMBaBQsy/ZFRmmKkpzXAO1e6LqO0wUnKvSLw9OY/FnKxWo9ItBMj5eNP1nSUnfG4NUBntnOnPKF+vfiRi9n/t3Q1038ZHPo+KWCwQZY7t42DYdwu3ndQCBRVTYAJzAYoC7Jphz4/B+QPLGPME2v9uN0eN2CxEwrJSN/eDBzK57yaHhJrICqbmA+KhFF9k5NgGF2oxPrXh5K2xvByKNdxw+U8zWBKwU8PCl7iWlc0PuutWM4bF5iDe3Bx/i9h3A05ARHIids9q13eYnURgf+SlOv6RDPOmcEtA5Y+TYHww05KTrMTRG7FV+chRRV/6VBJEo34MZCLc5PTul/Vz7X8aPV5QYYetlhir9Ov8R1OdjT+k+3Tv4V9Z2N0dZcbtZY8C7iWbkok/3FXdDvfeQaNL918lp6j/2d2eR6D1zebPntwfjgbmOK0O7tRicH+Y0bBVKkBVEiF+8ook3Gwl/yXrkBOpEln8aCRYK6Klr5HlY6Dct2jZ+qhWd6B15DvmpUnuaSLjfmVxZ7clDk11hor9cr8yTG6a55dCKbV2bGwiKo6gw8gNlqiXp7F6xUYWWz1bKVg/md8l5s+JC1Gv7VtOPHpaWxBaqNFxiqu8Dj0+5BMeVNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(376002)(366004)(136003)(66556008)(2616005)(66946007)(956004)(7696005)(38100700002)(103116003)(966005)(478600001)(66476007)(4326008)(6666004)(5660300002)(52116002)(86362001)(8936002)(316002)(186003)(26005)(2906002)(4744005)(8676002)(54906003)(36756003)(38350700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUV2dWoxcE91a0VpYVNGNTNlV0hOOHVIcEhvSFV1emVjKzFZZUNKTTRMUks2?=
 =?utf-8?B?UUpLV2xZRnBFQVp3eFI2WHZaNkdnRWs3RmI4NGpTalMzZFJrdHdWMExIZ210?=
 =?utf-8?B?aWtPYVFGbjJPMm5oWktoRGdsMGF4cWhITnZnSUZ2a3NPdTdqVTlNeGxhZ0xK?=
 =?utf-8?B?QkNEUnhFcC9STG1ScTcrREsyUDZIVkNuaUNaWGlHV2pJejduc1NpUGJVd3JY?=
 =?utf-8?B?WkVUeitXOXJzMmdxb3Iybk9MMEh2TTM3MFpsMUNYM3hFTGxhdysxYWVNeUFr?=
 =?utf-8?B?Tmd1ZU1XNjhCYkxWYzIxVVpyOWJiSW5YR0dsSExURDYwbUJqRjJhN0JlQzFo?=
 =?utf-8?B?VUJ2NlY2WjhiSzRIdllRZmhSODVKOUM0b1RzblNPOGcwTDkzZExndnJ3bUpW?=
 =?utf-8?B?SzQvVXA1a1ltMUtaT0twVGIwNkZYMWwrOFo4QnFpU2g1SnhuMXpFbUMrbEJV?=
 =?utf-8?B?SlgwQzFLcFRVT2FpSXg5OWlPbjhzTk44VHNTTVZnYmdsRjNhMitzQVkrOGhI?=
 =?utf-8?B?TE9DV1VjZ2RYR3BHUDFGa3pOTStabzlVcXFEUXd5RFNPMm9tTEZ5cCsvK25s?=
 =?utf-8?B?WEx5Qm4vNmxHZ3NCTFVJYXNIQi9tZDNSd3djT0V1UnJKU0JjL1R1MW9oTk9w?=
 =?utf-8?B?bUwzMko1dlJyZFJFYlZGdWpUNDdSQnVPZDJCM0JVSWtVZWtsSE9KbklrdUU0?=
 =?utf-8?B?b09VYVpVUEwzUnNMOFpDZm9oQ0lacEoxOVh1YytXVU1OeEZsTExIdGNTSVVq?=
 =?utf-8?B?REppUy9wOVBWZy9lVHRYd1YxWjJWdlNQaWcvZytmV2tESmF0SUcvR21Jemtx?=
 =?utf-8?B?dllSRDAzQS9KMFVqbDZMM0VQK3B0UlFIdDNQS2NySzBRTzRsa0pPcHNmRHlJ?=
 =?utf-8?B?VFZaanlxRTl6bEp6K1Npamc1SUtVRFcyVlVzNzdTbDJUK2wvSWNwaVBzckwy?=
 =?utf-8?B?dVdnZGUyREt1Y1VTc0FLWUxGc0hkakFielJtZEtURUtPei91WldvODRRT3ZW?=
 =?utf-8?B?ek9Mak9KVjgyckJDenkreUtyZEhJaVFVOXp3NjgrWGZsM1Fwcm5JNTVqUU95?=
 =?utf-8?B?aG5sNTdJakNrdGVBMXVPcFI5TjJoQnlZcVpla3JLMjhtalVkU2pPcS9NRlFZ?=
 =?utf-8?B?Nkoxd2E3OVBEZWxCN244R25aY3MvS0xIOS9GTG92VndXejBUZVBIRGlUU0N0?=
 =?utf-8?B?d0J2Unk2TlpMbUs2aHNVdi9EVkZ2b3RTcnBzZEhtSXNOclNRNlptTm9WQ3FT?=
 =?utf-8?B?eHZuK1RWaHUzVCtCbnBoZG1Rb0VxazdVNUJJZ3FyRnVYVERPV3gwVm5peWJC?=
 =?utf-8?B?a0IxM2ZyaFFJallZT29qZjdtSllUZXBZMWllMVlsU3BSbVFtMGZCRXJyME1l?=
 =?utf-8?B?aEtKeWtZbm9BMFB6a0ZhcEhzRmw2QWcwSlNXa1hGdzU3anpWMmtNb3dFNFNh?=
 =?utf-8?B?Rm81Nkt0TTVYRlllUWNFbkhRaitkaEJIaVBlMXJCRHVHQ1JnZElOUDdUaXkz?=
 =?utf-8?B?Snc3MnJaTmZVM1ZxMWtQUjZvYlJUTzhHemlEZUsvRVpFM1NHdEhnRFVyVjBa?=
 =?utf-8?B?Q3MwZExSYzdlOWQrZkQrZUV5Y1hYUG9OS1plVVQ2L1lCTTFUbEhadnZOVnZt?=
 =?utf-8?B?MitWbHhUSFlJUE4wV0dmbElsOUxIMXBtNTZNTnpzcHZ4NEJFeTJyTkJIUVJP?=
 =?utf-8?B?N3I0SGN2L05ISE5qK3Ixb1lkK1g5MWdZcWNkRzJHQktzcXhhLzhnb2xzTnZx?=
 =?utf-8?Q?S2zqV3Ytst/K/c6ncow5iXEc2FnD4yqE5+j8ilZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e90ea7c-b293-4e58-0be9-08d94bf6d297
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 03:22:51.8470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PUkBAa+ucjMfMtNKtXw2VK+/PhMNQBq2J7q6+ks4rbrIFN7Oy5ZV98fkaOTKz8Qo2bQPynquLmvjUgQNVg0kE0BoHPY2s96omY6/DpPkdMU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4680
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10051 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107210017
X-Proofpoint-ORIG-GUID: Vv6fX3FtzTlyAp5lnKQxQszF45ytu6TJ
X-Proofpoint-GUID: Vv6fX3FtzTlyAp5lnKQxQszF45ytu6TJ
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Wed, 21 Jul 2021 00:55:22 +0200, David Disseldorp wrote:

> CPU affinity control added with 39ae3edda325 makes target_complete_cmd()
> queue work on a CPU based on se_tpg->se_tpg_wwn->cmd_compl_affinity
> state.
> 
> LIO's EXTENDED COPY worker is a special case in that read/write cmds
> are dispatched using the global xcopy_pt_tpg, which carries a NULL
> se_tpg_wwn pointer following initialization in target_xcopy_setup_pt().
> 
> [...]

Applied to 5.14/scsi-fixes, thanks!

[1/1] scsi: target: fix NULL dereference on XCOPY completion
      https://git.kernel.org/mkp/scsi/c/a47fa41381a0

-- 
Martin K. Petersen	Oracle Linux Engineering
