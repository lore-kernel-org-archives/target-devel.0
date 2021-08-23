Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03C57C4338F
	for <target-devel@archiver.kernel.org>; Mon, 23 Aug 2021 15:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE6DA60FBF
	for <target-devel@archiver.kernel.org>; Mon, 23 Aug 2021 15:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhHWPim (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 23 Aug 2021 11:38:42 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2958 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229667AbhHWPil (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 11:38:41 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17NEdaLZ008497;
        Mon, 23 Aug 2021 15:37:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=ylYjX/7+rgNl/OmiGyFesugNd/Yln8KGJ+Nj59KbYWE=;
 b=PnPmjtlNdd/KWA6rmPiPlpNgh9/0ENgfPv25xV6x8hCCDFBDemp3MJoP7Y7QW8eeIBkI
 Q6D2orsMMbsrBKa+YcKWSOHUwHPDimLhibHdhu9BMTWec/8v+tzoyoStM2V8QvjogqZG
 rmnxbJp/+Mmqhjfx8boNxSR6lIBWger0m5Q4cCkm+Mf1pqL+MPIgxvSdw1xDCELQ7AHh
 0wuiLfePSgv9Wq4Lu7lWfQ+827FzkQlUybFwF/W0P/f400VmmXb2oAdhMaMm0f48kYLC
 l3L4qsvN7JCq5wjsUgpoN6HoJOjLRhZkv2+OLk9RlufkASO4ZTH0OhbN7i3K2XVHImHU NQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=ylYjX/7+rgNl/OmiGyFesugNd/Yln8KGJ+Nj59KbYWE=;
 b=XlMYdubleuK45qQRnaqWNYf6uQ4eg03pTxPHdqbPzQvPznCSSbAo4KzxibmfFqhfuxzy
 lK+TJKWKVrsjsXOuKItWYcurYDo7QpyKeLqFZWkf3BXjgcsj+N6MqaWgnGWGMdNsjsc+
 hhS+rVn5qEXNufchDxmaVkILyzPHhcQ1+fo4dgUKM1Jv4j0+vlhYZanvcWiDffjrCjS/
 qqNU26dNC1yKex/bvbBAkR6flPN353GNpilltVyXy6p/sHL9ge0wzyI3WIDg/lXmz7XH
 XeLFMeg48IQ9vhId6kAP7COsoG6Pv5hOrt6q9ALg+8CHiG8/NfPG4v19kYVsD3YVbIwO Iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3akwcf9uw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Aug 2021 15:37:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17NFZVNE104512;
        Mon, 23 Aug 2021 15:37:54 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3030.oracle.com with ESMTP id 3ajpkveq85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Aug 2021 15:37:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UhS/4Mq134qc3GxdVGseYNJuUGwEJWbMdr3zIs552IrCdJ4XyA5LPwj/ahvok/madrINEDxuULmKFmrFN00/59pxolaKC6sIvtFZh/dNfEHT9WC+E1eTk0fUVD3myPGIAtGUNjVjBXu1fUHgcSkzGzb5p5BllbsZT1JNvOXctCF5x/Fn2ME1Bmf0Tzap50/9mxyQ5hjXGycBGbW95iNSCXA+WloxJkSPIuEWfIN25JZuq8/MZSS3WqERp+J5Q30nbfLHs7HDkIm7PQa9/vKwQecrZqU6+vqDmdxfJE5Sqlnv8Yfy8yrvwqUMazbHwenYFcHFoWZUyOOk/rzAFaTIRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ylYjX/7+rgNl/OmiGyFesugNd/Yln8KGJ+Nj59KbYWE=;
 b=LHMurXZS+flJZDA5eC0caNWJKx2IfGb8UjY3+IZkmWdhlJFBRLa0SuPSwUW20o+2J5uSKlvRSGKimmzjQK78juvdWOxpzoNvwvnlTa63zAi/Hzv9xeUbRrQa72XcpXJUXHrGBGtySMmpLUsufGklhv/bhGYaS/7mUbOyu8GHbHrqdQKfAiN6vlfTebCaENR9r50RTSrlPyVryRQZornY9tTQBn6iGpWBOQEnVhUhKuiGJJ0pI89aJTj5+atxa+cN8Fu2Im5P1+y6Mo29Ep/VRLgzS562FlBXvtT700quhYDXm7x1TVMIr/bdI+KaTzNjMOcFS30IC3j3TAUt3/kkXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ylYjX/7+rgNl/OmiGyFesugNd/Yln8KGJ+Nj59KbYWE=;
 b=t7vdz5MIm55y/DaPKqtm6xZB7pIBNYEKmKl9vs/pcPEDjfLoQB3QGIxKQMeuZ7zGOSha+D2Jvkcf1zAg10q0lwgOgZh2XBfuK7/0R4wiH8szi7pN6K8S+c46tZWRQQWUe3DzQDr0SrNKojWXvyf9ux2Eorut6eBkun0Mf+Upsyc=
Authentication-Results: glanzmann.de; dkim=none (message not signed)
 header.d=none;glanzmann.de; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4483.namprd10.prod.outlook.com
 (2603:10b6:303:98::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.24; Mon, 23 Aug
 2021 15:37:52 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 15:37:52 +0000
Date:   Mon, 23 Aug 2021 18:37:36 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     thomas@glanzmann.de
Cc:     target-devel@vger.kernel.org
Subject: [bug report] iscsi-target: Implement demo_mode_discovery logic
Message-ID: <20210823153736.GA23510@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0107.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::22) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kili (62.8.83.99) by ZR0P278CA0107.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Mon, 23 Aug 2021 15:37:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6a99184-8546-4464-5677-08d9664bf7e4
X-MS-TrafficTypeDiagnostic: CO1PR10MB4483:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB44835A7BC49CDCA27178CF918EC49@CO1PR10MB4483.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oO8Vdk7d8Lx07UociTeb46eXAfCxBXVvQ1xXC1Az8p8iyhz4wJsj8cgkPcgy+I9GBdIwlLDUCRpRDASFEipA+rxZ+tSnw/IvQAyLEsvH1JvK7X7wk1A6ZkvqmXrmqa+8iokf35XFggUNFMS4enCH7jufme8xIwZrWZv5RYgBhLL57+KPBmG/ewawBPyIIuzCOvTTVAgN7p+yPVLvNLlyQANwKGtMHIg4neJ83Io4frbHWvRCfGrhktfsujOrppx8Ye5S8Qr2wgDakzMWiqoDrv+8jXUQvcxY+gl5zrF7ZrkRztpwilAEQK68oqOfvWfcu1gE4/Wdpn4JKvx6AsePhG5a1sOAa6RtoZTVUWIgnluY6dZj5/6fpqfCFn51KOZw1OacslKOrbyqkgbiC8jLstwhQ4kHisi/Mmz7Cv2tEzKk3dGQEl0gDIlccQ7iI/yfjdoCiqWfjCw4SMXratZe6DuCD/P1GWV8nVjFDNtjOsqOBqM6Aw7zD2LebxyEUiKA9TVrNhHQ7POSPavlGUIpA0Et/cG+POcx1M0DI5jluWGhsq8imc3d79+Cuixu4jN50rxxONn2tKBr8yMUFzlenwd4gRyaj5f6+dB9ynb45mbmUYuMq3RKgPV0r5XstK0anxmxzkVa6KrqbccKnrGE3T5+bxICIX6uoN2ymsRtTR4ctgX/jElb76miQF46jf9ow8i4tngXgVcP3t7AQF3HDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(376002)(346002)(39860400002)(66946007)(1076003)(66476007)(33656002)(26005)(2906002)(44832011)(9686003)(5660300002)(33716001)(8936002)(9576002)(6496006)(478600001)(6916009)(52116002)(66556008)(956004)(86362001)(83380400001)(4326008)(38350700002)(38100700002)(8676002)(6666004)(316002)(186003)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BmfEeacYagU93R0fHnsHP21RUxqrXx6D2KHwQKf46mMzzzK1951zzz8l1KkJ?=
 =?us-ascii?Q?rsfl9glxW1ly9CQnQdERxQUt35ToTNSFc7YoUHhCmfQ8nkaQ+FYpKW2bhEqt?=
 =?us-ascii?Q?swo5Bu1/FvhOOrDIF1ftKMo3KH+5/O+/1usQ76NLNe1IAomA6M9Q3TXdg5+X?=
 =?us-ascii?Q?ST6jajFAdtKoanEuFBF/6kM6znv6F00LJBtAJu2tm5P2PtohPTa8LjcbtUyj?=
 =?us-ascii?Q?dvieHk0DBEKx9zSYQXjOBL+3HWpDythGXHXBKeVZogmtH/w6mohxxrXNYY+3?=
 =?us-ascii?Q?MOMqoiyS0JevLH8ayoYIritbUdTxrw51qz382M4VIwb62GgGDlqqy9E7PEfj?=
 =?us-ascii?Q?BZUpVdaszvHbk+ma9L0S3/tLc1P9JOfD5UrnzLAgDAsAMi53dYKAD8jjpIcn?=
 =?us-ascii?Q?ztH7KC4JBo/MHiFNdUqM4ULMaTMdcpv8nCOibqNwv4seQ9v5BdlcgnBXxBls?=
 =?us-ascii?Q?c/GA7g6tlQGVVSmkZL1vxolONsy7XC10Gl41FP6gYMGoPt4L3hvGFVc4a9vN?=
 =?us-ascii?Q?uOOj0c0ZDnNc9FoSBCzc0ZhPOvVZenYbOh+eTvyNAaw7k1R4Tqf3e7/PpPvv?=
 =?us-ascii?Q?T5dzWSxfIJwftgioq3Kno6zRdQGRQpXtnuJlIhIZ90eM19NSbivacIaLQTzo?=
 =?us-ascii?Q?YcR8IUdjirncPDTLE+B7XFRMz3ulwT2SEPSqS6Z+ru+pV4zIPrWdWXqROAOs?=
 =?us-ascii?Q?RAG71oYQEr21D6a4uratRGhR7oJ1E3QHBdgE18iD/KmVHBsuxm2JcGISTeuX?=
 =?us-ascii?Q?MPM3LpNxcDu/Ft5KBogau4QHnXx2YxwsmUyuT5Owsef++WEcU6VfNqYLUdXp?=
 =?us-ascii?Q?gzw5Z42WIjfI4O6GDyfo568PJXzaFRCIKe41x7Cs2MEbotxwlPxm5aojgomq?=
 =?us-ascii?Q?k+Yu385S2RnAVfNsQQoCylKs4SRIyQb/gAuPKyPFT1fnl7LrChrlb+iqSmgx?=
 =?us-ascii?Q?sh2IKznFuZhaa7nOuxP61lG/PftHiFTuFaa9JuFz2ynqyJM7ihV5EFc+TWpR?=
 =?us-ascii?Q?VTFXEi8qEPERbDU+pSzH4sM3xrHFr00hOPRjUEIPQAnrx+P1POyLI20f2+/b?=
 =?us-ascii?Q?aG8MpTGf/QPYcKEWmY1uv9XPQVK7lTERH7H0kdpC/ZOE18NyJ9qqzLH+1lPE?=
 =?us-ascii?Q?fqEQ0pgU4Dcuarzyk1W/9qiXAdMDqX7SKxBu4gTl7gsoTTr84u5s2cwpMy96?=
 =?us-ascii?Q?ISUjs0XbXLCO8fBiycCJFbQP62Qxbs6DVQqawmtGWJIgMW6wFsb5affZ0SSe?=
 =?us-ascii?Q?ZJkErEDAWDQivHFrrn5No/XUJglfYNnygFrGtPm5AMrsQrMIvTQJOUacgY0o?=
 =?us-ascii?Q?o3/Limev2xi7bT7GnS+2x+rG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6a99184-8546-4464-5677-08d9664bf7e4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 15:37:52.0391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qd+PTAPoPRnbSWAt6oFX/0uEY5L+ZgvQkS9fXKFQW00hs/1vQz1HFN7wmu9MdfZ1pzJYhcZzm/rUupXYxWg1jtx0PLYupr0oCQ9UKI+4ybw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4483
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108230107
X-Proofpoint-GUID: uTCftXPV_e7B8MeOpn9ZpS-NU_djJ8u4
X-Proofpoint-ORIG-GUID: uTCftXPV_e7B8MeOpn9ZpS-NU_djJ8u4
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hello SCSI heros!

The patch 2dd1d53fe004: "iscsi-target: Implement demo_mode_discovery
logic" from Oct 7, 2013, leads to the following
Smatch static checker warning:

	drivers/target/iscsi/iscsi_target.c:3397 iscsit_build_sendtargets_response()
	warn: sleeping in atomic context

drivers/target/iscsi/iscsi_target.c
    3378 	spin_lock(&tiqn_lock);
                ^^^^^^^^^^^^^^^^^^^^

    3379 	list_for_each_entry(tiqn, &g_tiqn_list, tiqn_list) {
    3380 		if ((cmd->cmd_flags & ICF_SENDTARGETS_SINGLE) &&
    3381 		     strcmp(tiqn->tiqn, text_ptr)) {
    3382 			continue;
    3383 		}
    3384 
    3385 		target_name_printed = 0;
    3386 
    3387 		spin_lock(&tiqn->tiqn_tpg_lock);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
We're holding a couple spinlocks.

    3388 		list_for_each_entry(tpg, &tiqn->tiqn_tpg_list, tpg_list) {
    3389 
    3390 			/* If demo_mode_discovery=0 and generate_node_acls=0
    3391 			 * (demo mode dislabed) do not return
    3392 			 * TargetName+TargetAddress unless a NodeACL exists.
    3393 			 */
    3394 
    3395 			if ((tpg->tpg_attrib.generate_node_acls == 0) &&
    3396 			    (tpg->tpg_attrib.demo_mode_discovery == 0) &&
--> 3397 			    (!target_tpg_has_node_acl(&tpg->tpg_se_tpg,
                                      ^^^^^^^^^^^^^^^^^^^^^^^
The target_tpg_has_node_acl() calls mutex_lock() which can sleep so this
is a sleeping in atomic bug.

    3398 				cmd->conn->sess->sess_ops->InitiatorName))) {
    3399 				continue;
    3400 			}
    3401 
    3402 			spin_lock(&tpg->tpg_state_lock);
    3403 			active = (tpg->tpg_state == TPG_STATE_ACTIVE);
    3404 			spin_unlock(&tpg->tpg_state_lock);
    3405 
    3406 			if (!active && tpg->tpg_attrib.tpg_enabled_sendtargets)
    3407 				continue;
    3408 
    3409 			spin_lock(&tpg->tpg_np_lock);
    3410 			list_for_each_entry(tpg_np, &tpg->tpg_gnp_list,
    3411 						tpg_np_list) {
    3412 				struct iscsi_np *np = tpg_np->tpg_np;
    3413 				struct sockaddr_storage *sockaddr;
    3414 
    3415 				if (np->np_network_transport != network_transport)
    3416 					continue;
    3417 
    3418 				if (!target_name_printed) {
    3419 					len = sprintf(buf, "TargetName=%s",
    3420 						      tiqn->tiqn);
    3421 					len += 1;
    3422 
    3423 					if ((len + payload_len) > buffer_len) {
    3424 						spin_unlock(&tpg->tpg_np_lock);
    3425 						spin_unlock(&tiqn->tiqn_tpg_lock);
    3426 						end_of_buf = 1;
    3427 						goto eob;
    3428 					}
    3429 
    3430 					if (skip_bytes && len <= skip_bytes) {
    3431 						skip_bytes -= len;
    3432 					} else {
    3433 						memcpy(payload + payload_len, buf, len);
    3434 						payload_len += len;
    3435 						target_name_printed = 1;
    3436 						if (len > skip_bytes)
    3437 							skip_bytes = 0;
    3438 					}
    3439 				}
    3440 
    3441 				if (inet_addr_is_any((struct sockaddr *)&np->np_sockaddr))
    3442 					sockaddr = &conn->local_sockaddr;
    3443 				else
    3444 					sockaddr = &np->np_sockaddr;
    3445 
    3446 				len = sprintf(buf, "TargetAddress="
    3447 					      "%pISpc,%hu",
    3448 					      sockaddr,
    3449 					      tpg->tpgt);
    3450 				len += 1;
    3451 
    3452 				if ((len + payload_len) > buffer_len) {
    3453 					spin_unlock(&tpg->tpg_np_lock);
    3454 					spin_unlock(&tiqn->tiqn_tpg_lock);
    3455 					end_of_buf = 1;
    3456 					goto eob;
    3457 				}
    3458 
    3459 				if (skip_bytes && len <= skip_bytes) {
    3460 					skip_bytes -= len;
    3461 				} else {
    3462 					memcpy(payload + payload_len, buf, len);
    3463 					payload_len += len;
    3464 					if (len > skip_bytes)
    3465 						skip_bytes = 0;
    3466 				}
    3467 			}
    3468 			spin_unlock(&tpg->tpg_np_lock);
    3469 		}
    3470 		spin_unlock(&tiqn->tiqn_tpg_lock);
    3471 eob:
    3472 		if (end_of_buf) {
    3473 			*completed = false;
    3474 			break;
    3475 		}
    3476 
    3477 		if (cmd->cmd_flags & ICF_SENDTARGETS_SINGLE)
    3478 			break;
    3479 	}
    3480 	spin_unlock(&tiqn_lock);
    3481 
    3482 	cmd->buf_ptr = payload;
    3483 
    3484 	return payload_len;
    3485 }

regards,
dan carpenter
