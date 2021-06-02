Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72634C47092
	for <target-devel@archiver.kernel.org>; Wed,  2 Jun 2021 05:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51C9461361
	for <target-devel@archiver.kernel.org>; Wed,  2 Jun 2021 05:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhFBFrT (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 2 Jun 2021 01:47:19 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39140 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbhFBFrQ (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 2 Jun 2021 01:47:16 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1525f2Cm176877;
        Wed, 2 Jun 2021 05:45:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=wdVFQ1YOQeHAVle0VQglMGB53mdw5DKrSb/Eh4/9Nxo=;
 b=TGjV4hCvgflxHCA1tI9D05OnZf5x2riNvJsRzGSfvCQMznfmUSSlEE4PtEvk5bI0VlxP
 Xdte5FJSIwGL8mEodZhAWgr1LCzDm5tbTNNkXDBFRtpe7vx/b7T2BtcYjY2O3PT4rmo4
 ki4hIhOu48Nex9ESDLXpHnf+Sk9oWTb3aKp7gYkgQXrLnKGamy3fwQUPjgWj+kHu3utk
 PIMv7PZjdH5KYQc/E6S5xdW7RXNTsgyFPAJ22gQEldBCte9Oz5ACJbQxdkhG5zNueCAf
 B5aks85lok0AYEobAO6CNsbBiJPfoagijnusWWU3zMkezny74x5Au/JGerfbhVik+G5P /A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38ub4cqf6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 05:45:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1525eb3D069828;
        Wed, 2 Jun 2021 05:45:31 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by userp3020.oracle.com with ESMTP id 38x1bck5bk-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 05:45:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iEi5TLAxe2eEbHknCm2w3cCRG5nAWNZ3i5lb3ohckTX2SLG7Qy52C383oHaj90/ApXhurUDsGuhq7ynHY8bV5wMnlcYNxW+NS/bJQKfzy+tZIP9rP/TdviZLKTiD7nLCLBgsVsjkfGmfJ9Ng+MTaJLzOoNe+7WzbNAEP5WW1rjHNReUr8TkH3utW/Ujkvq4un8qUuGF5NBot1lOiNuf88TasTW4j27RaYvqIfIfS5q3bBcwW2sKj6kfNVBxfFSEng1PlPKc6AHOLGv1SY9JbiPlx/ZMK5N7uKmuvUnomXlMWDkkzzJivOLFxe5F5o6tnEw9lo0HlJXlPXD0o7mhh3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdVFQ1YOQeHAVle0VQglMGB53mdw5DKrSb/Eh4/9Nxo=;
 b=eTT4A1zKjJ8YGdMRQjeTE2qsKzZo1CGlCMxhtYSUDzxqtuQAfZhf6ny8mS2qDP21OvpXGKGvJsfUbf9/RpsHYgDMkLKq4SnqaanTRK9wbqUje+AlI07GEpHtOmpXddfFXVaOunc8U7K5jlVw0GwShIC5pKbV9ceWzsn2izBBPoIx12GNLUYZLwPgNxLoWi/If7QaUMkmCD45QDRRkYb/1a8Wuh1eRq2xdBD9dUTnH+Pq5SSDVK/eNISoyEbbuLFp3Jryq+2UnoNgJCj4iUN4G1ouAefOQNUPI5gcUyIMrXkw9r1kqETiKrQXx8nZoaKzJnIRaex5NabgwsuriO5zBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdVFQ1YOQeHAVle0VQglMGB53mdw5DKrSb/Eh4/9Nxo=;
 b=roZC3PHqrHvLhbGrdtg++6uzGfrMdBrA+7aVPjfZI8EHCnevFqCRBuOZcd+CIyh6CphVXZTIHtyh/OI8bvWuIiGZE6HDjjxcApxRS70//PNIQNNpde1ujkJgPnEElt+XG3fxqVQlH6O/3i/rn4W+mxtEgagN4AuoC7AlPRhr3Ug=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5418.namprd10.prod.outlook.com (2603:10b6:510:e5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 05:45:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 05:45:28 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     bvanassche@acm.org, Maurizio Lombardi <mlombard@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        michael.christie@oracle.com, target-devel@vger.kernel.org
Subject: Re: [PATCH] target: fix warning on realtime kernels
Date:   Wed,  2 Jun 2021 01:45:20 -0400
Message-Id: <162261189569.29465.6337489678925172455.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531121326.3649-1-mlombard@redhat.com>
References: <20210531121326.3649-1-mlombard@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR13CA0033.namprd13.prod.outlook.com
 (2603:10b6:806:22::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR13CA0033.namprd13.prod.outlook.com (2603:10b6:806:22::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.11 via Frontend Transport; Wed, 2 Jun 2021 05:45:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef8e4c07-373f-4e60-b354-08d92589a04b
X-MS-TrafficTypeDiagnostic: PH0PR10MB5418:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB541841CF74C6934A99041E768E3D9@PH0PR10MB5418.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:147;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: caxNN0ijU/i8lrr9cUmMTi/MGQOsLfHyXTnAoRtJkoViq5Dg59aVQOz2MYg7ZzfUSjA4hOqKGxBOXE3WzwdHiILpa573wMo+j394ce30VU5U3GD3p1MJhSR3HfXm9z3cmF0o8ZC2I0a6ShmB43LQyHp21RV0YOzHhAdUk8y5XtbHDlGFaTMyLrqoPh/8h6HlrSH7CJ+bTsBcoY9r6yiqAy7JqTe6tcRVbuylBk/UMY///hO2/UmClIaAjnTyRr1J4ZzXyjYZ+NR7/sJw41hL7NxZNpBRSqt/rI5uBOTNZx+LWhR1b1m6e6GXHLbFvIQIZcU+6c6kfb+WwzCBsRgHvIdeBtA3OsidNlVfXrEQUeDywLPK+khaGAIPA3YWOAzjIaK1akaDCRVkUiFlZf7hZWOL1c5CDcPieg8tojUHcSWK4zeFNGE6Wf+/tQdx5x+idcolM1xttj9XZWKgR9rYSqRhi5h9d1jfVp3XEXNbMdhV98DejXZodVC3i+F3eVDHtW2h7sygCz2h64mv/M5GTmfNRSuJ5jd6b5yCOSPiE2MIaaavDq/qzQN8ajGYXZfDbV85nXEWAl3bwpRts7G4+je4B8Mo/5n4lEAgIDS1EBZ2jYAZp/aUq8m3ML9sqri28adxoE/CAh1EFNcoGIRBKBpD745WSxbkWtj2rU+MjP/wHQy+8eUhi9wVjoSAbEn64OSBrxeRsHsgE8vaRHEee30JTnre4n0KuJgkoc5UGprul9kumkgiGCOQ9gJeSui9jZeAC8C12lPhhjiCW2rHvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(366004)(346002)(39860400002)(956004)(2616005)(6916009)(8676002)(966005)(478600001)(316002)(6486002)(86362001)(6666004)(4326008)(38100700002)(38350700002)(7696005)(52116002)(186003)(103116003)(16526019)(26005)(5660300002)(2906002)(4744005)(36756003)(66476007)(66556008)(66946007)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dTVYZ1JSVklibjhoNmRsUGt1dExVdlY4QW01elFmTFFGR2JKTi9iekZlZ1N3?=
 =?utf-8?B?OGtTcVJORkxYWlVXYnBBYjVxV0FlcDhOMmdaU25sUDloU1JtWW5nc0RGcEVZ?=
 =?utf-8?B?T2lLUHJkRGR3dUg5SElneTVsREVGbVpyK1lYT1NoODluMTFKTzVrdEVYSlh1?=
 =?utf-8?B?MUYzNkZpODZ3R281U1pNeUtROGQ2d2RoOGlFdDE2S2cvOGR6RnpYbjRXUm5B?=
 =?utf-8?B?eTdlUy9wN2JwMkxFemlvYldKUWl6Ulo3MzZlamxGL05qK3JtcU01SFpTMWFG?=
 =?utf-8?B?cjJYNEhQTXVHV2Z6bXFpS3RacGJzNGlEZ0ZrazBobVA0NkIvNlBWOVp6eGwv?=
 =?utf-8?B?TnhLYlhKRTRvZWF1ZFVtSUJHbFYvQ2FGYUZWOG5VWi9YUU4reTZodS84OXR2?=
 =?utf-8?B?NW80UnJlUWNtbUlHK0dEU1ZTMTBtM1JTaWg3eXMzR01aSDFsZDE0enZudUlm?=
 =?utf-8?B?OXlKbXBqL2xMOVp3RE1NTGlSVjVub0FHQzZueDVPR1FQaEc1cVdMbDVpb1hs?=
 =?utf-8?B?U2hhWUVRUE1JL04xU3hiakVOMUxOd1Z3cldzbDlZN2lVSzZIZmdSK0s1VXFs?=
 =?utf-8?B?YWx5YmdNVmFUQTNEVWdPOEZlMzNIaGlkTnFUTmtEV043M21JZDA2UmVTajVY?=
 =?utf-8?B?QmtKL1N5MDVwRXQ0WEVKc1llMjFTU0JnNHdSSUptSHBGVEtlWko5OG5wQmph?=
 =?utf-8?B?TDB5amFjV3dMalpQQ3k0YkpBVnBKRFZtRjhTWUtub3VUOXNGWERpd1lGakwz?=
 =?utf-8?B?MkpXUnNKQUVZeXFqYWtyd3RxU1ZzK0ZUbkR1OFlpVFNyUHA4ZXNmTDE5enFJ?=
 =?utf-8?B?SCtkd1VCVC9GaTQvN0hoVGFlV1k3UFRtUDZ4TnRpU3BEam9rNmthNENSZmVz?=
 =?utf-8?B?MzBUUU9IY0o5eVhHUlo0bW5mZk9tY2Qwc3dYcUl0dkxqZ0RKMWtibEdueTBN?=
 =?utf-8?B?VWhVaWc4N3lRYlRacXJHSDAzaXBTb09veURLanRKWEJtbGhMVTdjTVVwZ3Jn?=
 =?utf-8?B?S0RnNkFNR2lSOUI4dHpTNC85YXczbm1ONTVwdzZGZTdHVUh3WnVJTDVCb1Zz?=
 =?utf-8?B?S0tYeWtVMEE3TkxoWWFQMHE5a0o2ZHNET3FUaHpyWC8vZzJxTkdlaGtJbTF4?=
 =?utf-8?B?bWJRZDJ1QUxSeENuUStURFhYL3FUbVVIWCtoYXNBWnJDcjdPNXZVNGNGZmtQ?=
 =?utf-8?B?clNMTUxCd2VJRStEZDlpSzh6bjg0dDBnSWtUanJMR1dNRDZUaThlTHNuTExB?=
 =?utf-8?B?SDlXb1Y2c01ta0dvZGkxM0JWVW9VSnVCSDRPRERCekZ1Nnd1d1UzT2RnUXB2?=
 =?utf-8?B?eVBHRHFkODJKLzhublFaeS9MZ0VYdXFZYjhldkRUTk9NUUsyWFV1bXVNWXk2?=
 =?utf-8?B?aEhoMVBvcEFKU3Q5NExPSTl6bmd2d3lwU1dyUko0K1pkaHNnTXNDT3d6dmdY?=
 =?utf-8?B?dURTRUZ2NUNHOUd5RWswd3lmdXY3cDl2Ykc2YXNKQUhBT3JYZUxuK1IwU21O?=
 =?utf-8?B?Z1FoOFhZVHlPcEVSRVBRY1QveG96QnY4YngzZDFQem9tanVjMzgrSUd1c3VP?=
 =?utf-8?B?TG1jZkw1UHYrOEZZOWJjT2s4b2JYdTQvY0dyWUtKQytqcDRjMlhqcVhCYUcz?=
 =?utf-8?B?VEM3QWZxTDZoaDdGcloyZEdEb2Zxb0JxMmdZSG1WTkZkZnRnLytSbFZ2MEMr?=
 =?utf-8?B?TXhTaHJwV0VPemJRalYxaVhuZDEzRTRWNCtxaHBJZFpvOTlSZ3ozcDUrTVF1?=
 =?utf-8?Q?IK5sRA7Z3QdYgMm+dtSBLVZZSDocCd92eSSJqb/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef8e4c07-373f-4e60-b354-08d92589a04b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 05:45:28.1689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PCzXl4jvPjgF6eEfv7yYCROT9MU+QfqjyghdcrRpvCDqnXVDcc3/Yz0OU7OvqRwVd0BySXapeglaqzSWF5kuxV65TQmqF5o+0BpXr+O95Nc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5418
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=677 adultscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106020036
X-Proofpoint-GUID: LeQW1k5cPojqsv3PQYrqn2u7ctUp9GFN
X-Proofpoint-ORIG-GUID: LeQW1k5cPojqsv3PQYrqn2u7ctUp9GFN
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=865 malwarescore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1011 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020036
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Mon, 31 May 2021 14:13:26 +0200, Maurizio Lombardi wrote:

> On realtime kernels, spin_lock_irq*(spinlock_t) do not
> disable the interrupts, a call to irqs_disabled()
> will return false thus firing a warning in __transport_wait_for_tasks()
> 
> This patch removes the warning and also replaces assert_spin_locked
> with lockdep_assert_held()

Applied to 5.13/scsi-fixes, thanks!

[1/1] target: fix warning on realtime kernels
      https://git.kernel.org/mkp/scsi/c/515da6f4295c

-- 
Martin K. Petersen	Oracle Linux Engineering
