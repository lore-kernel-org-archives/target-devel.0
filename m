Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE0E1C433EF
	for <target-devel@archiver.kernel.org>; Tue, 14 Jun 2022 12:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356373AbiFNMJx (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Tue, 14 Jun 2022 08:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240427AbiFNMJw (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 14 Jun 2022 08:09:52 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E412547AEE
        for <target-devel@vger.kernel.org>; Tue, 14 Jun 2022 05:09:51 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25EBYHoI014673;
        Tue, 14 Jun 2022 12:09:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=SSssC2SvId+jaVAVyXLd6k9IgtseDc5OjOdiznKCMfk=;
 b=iQ1IpDu3vS0UH7OzlhULjQMJmn5GYePEwLtquuPu4w9rrL55/KZj0i0D1PIjkIIqS/M9
 f6YkelnYLJkljXCJ9VzuykYcC8x3xRZMM6EtD9df2hlvyzZW8gthHiBrfwx6YZjtoq1X
 Ki6tv07392a1JkgVCGe0BmHqvwg70FouOEvnlbvuednOdB7wO/H+1Nax1cyDf53xY77n
 TOvoY+mutwwWZX+hXKZHg/6Kyyv3Kb3EbhraT1ALBO5+2EWz/+pklsfVToeP5EXRmDf/
 TVrQBQEC2eos9X29yYfd3uopx6RvB6V7sxha+TQE9ujN9J5+eUOD7AECVbPripcjzQTi 6Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhu2nqt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jun 2022 12:09:51 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25EC6KnE032561;
        Tue, 14 Jun 2022 12:09:50 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gprbqjmv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jun 2022 12:09:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G69PKMZKAmowPOTDu4jrA6e+FRpiOArzsCQSwBUnzcD5l/rTCmHad1hwmuxEOHWx+ws94eoxRcgAb3bTIvidQ2oC51IfcbBVEH83RpGQEu4FuLlBnW5u4zgvkEgF4bdFJIwcK4ao3+ABSj2lakCa+kRXSf/jF5bblLlP7kKke5a/CU8luu/GKy0I5Zu40A8rr0xfXTsbqZLJy0VGqv7fYWOWJRIK+G27Fa4/9dFFW1Qp6Tpsj+H7sEMGq5ma8U3ont5dEAQwpnujYZcwo1FB3U9MrZkNUrAmJvYx81c2mhEVFAaCuQUeRyH6Yd5LCpnzKLDDfWL+7bDdISxRafzQEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SSssC2SvId+jaVAVyXLd6k9IgtseDc5OjOdiznKCMfk=;
 b=MvQLN0v+BIdvRWQHgrKXoIHNA1x5LkJrIgvGjXoaeB8ehULKeLtxxKWBIi3lH2UV4/oKXauV+zWSAlm1MINpgUlNIdGrP7RjgKKpIFpZ4Ii0Y6iJM3EH8m0r63QaLF9JLDWm1gPkEiMEkGNUNjwWHJmo7WiUmGaxbERq5thHtQfqUzKXu1JkZFh7fc3xZdRSU5uVFRAOxL6J9ZSJ9Ts3FgWJ87XUe9rBJ3CqxkZfHCDvfZYZ+K3mvUolHHwwZSe25yykmCFe33R3Doql0EQcbu1K59ozbU/8QzFGz8YN3sXkHVRZJOtBevzdu828t8DqntYCuLV1m4usWAOy53+Cbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SSssC2SvId+jaVAVyXLd6k9IgtseDc5OjOdiznKCMfk=;
 b=FEMfvKxicwAyJfJzUKjTkkZLYVqoryEqw1UBX1hlGeJr2mplxXre5w7Y8zjbEAbHgvaNmetiWY5J6UGNAye5l2SMgY8awZ02ZCQ136Zf9GrqZJ8D9k2ccfk0DzP9Hp0Nl7WFpWKdS6T/1Gc2xf1s2B9XT4pRXOjr4cO62cZKi7Y=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM5PR10MB1482.namprd10.prod.outlook.com
 (2603:10b6:3:c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Tue, 14 Jun
 2022 12:09:48 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5332.020; Tue, 14 Jun 2022
 12:09:48 +0000
Date:   Tue, 14 Jun 2022 15:09:38 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     d.bogdanov@yadro.com
Cc:     target-devel@vger.kernel.org
Subject: [bug report] scsi: target: iscsi: Extract auth functions
Message-ID: <Yqh6goRour4dtqkD@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: ZRAP278CA0008.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::18) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97542e35-dae6-4320-c494-08da4dfec6e1
X-MS-TrafficTypeDiagnostic: DM5PR10MB1482:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB148262E075E79A66309F80CD8EAA9@DM5PR10MB1482.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qG1qMm65augKjr8miptbDsA7GOAWK/RkKow6fGi1Zf8CSJypuNRB7Ai9AhOoq2SvWFJN3ZbF1O19nvvdTsTzXYXuEBedL9MRTj5rk27erji+9J0dlp6TFB0I+W7GujOJ8hbWeuHVwFP3GQFq2iLYWppEdZmw/DmEQTRGKXZtW3njGYA5BxJx+B6DQHAw7FOmWIUYXfUPNq5AYtoFfCx69vMf7TJ0Vscs7E+rye4/uwgYoNazB+ln58f3l6Xi9Oj1PAxzSMZytnulQvxkWDUCxKr/L5Wd2zW7qqJi/MPkwzUKnq9lVw5sRAsoFH0cb7d3vgJNvzzRIjg8mFea+iL827oUljAaIQjltDdM/gySgKur2dJ3lLGwF9/qG6OWsovbXpRH5xOFMKfSy1i7TtOOBqLcnuajk9aTm96k0tnLUwhuaGtBTWAzLQ3BhDmCE7MPUA/NFgA1gxxYWYs1I8InZ5wZ9fOC9uUIZea7+Qv1HRE0a7Ae+G432lLeuiqWRPKwrQTbCWXFU0/fGgc2S4pjO8KsAcR5gzpsrzx8fJRfRVsCyF8pOB4Uc/oYTwKrrVW+bKlIulixZo7A4mAT6cGnDyjSjn0q+Tr7krZcMPA1iqAbGhDul0DCczXhGxRHasigsVLJTzWAw+4FCrvg+xsc83UxxwkWVxuLsWqwhQCx84R/y+GstknUrkqn9bWJvbGMRNx7h3Jt5LxOdQB3BuCHhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(9686003)(6512007)(52116002)(6486002)(26005)(6506007)(6666004)(508600001)(33716001)(38350700002)(38100700002)(186003)(86362001)(83380400001)(5660300002)(4744005)(2906002)(66946007)(66556008)(8936002)(66476007)(316002)(8676002)(44832011)(6916009)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+dreyIJbRRHds2muXp9Nt4wXcteh8p9UzOLHaIX8LDYksXnmsTtKhB7DXuC9?=
 =?us-ascii?Q?wu+N34HqhP4S7bcaFHTqMtjtzp+O2L7b2tR2F2DtPEtYin/8SZLXzxlXEG3A?=
 =?us-ascii?Q?QG33E2atBatN8UAN3r6Hhx1LELcvwy9MTTpLIZzYjjozbLoDMZO8eSY9HM+g?=
 =?us-ascii?Q?pl83gpHqOOaCmFdLwhs5Q7mnQbM7j+ri+KMewhAdl84IVPJp7Cq0rNV+/T4f?=
 =?us-ascii?Q?aqTYG8LboKBlXGMC4pqJUAa3N5d/UcgJar5WGrYeyKHd2+IBOQfj09iqKOB4?=
 =?us-ascii?Q?pOLFXe1iQDAExBi4iVPQ5HZ+brBwHVoTiPKyrCxo6qLh0OHkqwG9M/Ff6qWf?=
 =?us-ascii?Q?BZEGns006aiOXnlpNd4f5y5IL4VgDG3dZKcC2l6Qo4YyOANjNdgt8EyKNOiV?=
 =?us-ascii?Q?jVvV9eKIJf+XbTqP0ryz3liGDisCgvhebxIDApa63d23OL1AfLgzdkLE6LMr?=
 =?us-ascii?Q?/ND4INrWbwYCxbhejkejY5k3V0YMctpxrrFtY5F0FyFf3I8eyYwEbVkGwrZ9?=
 =?us-ascii?Q?bidqROuwV/ZYM6yQdlosQLsKh5MdN6ocbDvEBO0sunRr5qYPTX43r2zoPYGN?=
 =?us-ascii?Q?ZMQK/6d8XMpSDg1zy4ONuVVZHzJ7Dmw+eGzt7DTO74BlC00pAhdeLQ+clftt?=
 =?us-ascii?Q?M8JQesiTqGQsTdl2ipUo0zHWNdvrkpWKAJ2MSbhqxfI5sAuPfeoepwORpIDh?=
 =?us-ascii?Q?IbxJWfPgm8Q9Xjge/s52tyBAHvY0M8E+vcvwPyPRsPfJIPdXKBiWQ9BGxzBB?=
 =?us-ascii?Q?fHlxt0BTai4VMrEZOHuGmVbdKUAOHrOdkKvIaytE/lR5QKQtNh4Mg1OOq9g8?=
 =?us-ascii?Q?FM/UUAJxNlhc0abLacdhem30ZxE72x1U/2jzWKUJja2ONncRErsvqlWjlT7T?=
 =?us-ascii?Q?sCEJr2u0Gm497caoeQv4PWJvavvUyh/1s5dfCrDMCMZRGRG2kAIpTZZwfxlb?=
 =?us-ascii?Q?4MQPPFAZ8jHyneFcsDIUG+wn3kyGjax3nhmgqusOrxuZhm8m0tMBGeTdbRfn?=
 =?us-ascii?Q?d/QFmy+3nty/o67if6ScvGa4w+NoJq1Wfv1GWBOc6bz0mGi7zM1mE2m5KPXP?=
 =?us-ascii?Q?TY1/gZJm1kR0IsHlUyQrvrGr+nngEv9w46sMHyRnZ3cXKFMSyAyX/ch/ZKfm?=
 =?us-ascii?Q?lwRW7A5uzF3RIG2Ww/cy0dsuD+ENwDpn/ipe2qRFikt979fTTncu0SimoWeg?=
 =?us-ascii?Q?PrqtlMpuUfaaAvlxsZ4J3KjOmurVtaYnWBWD8VcQX6nFvw3iJPQJdZhv8KZ7?=
 =?us-ascii?Q?MPq2KqATef9JkSy8iCcDfGwsQ9fOila+ZOsrZTEicjVDBigrjla/oDCGdiBF?=
 =?us-ascii?Q?a4lu1SdcxrjUX5TBF0EUj+rqMRd8JOT8gRtULdDTJms58T067gOrgKObmqpU?=
 =?us-ascii?Q?+iuZnV/xETRpnsM0dFxtwXMWUkklVpWM+IEn1NuLTnmlAa4t0GF9jv166GA6?=
 =?us-ascii?Q?GOW0mkTfSlq9vBfzrydl/lP7HW92z9S4NW6tEDGorCtB8Pte/sP9nQp3PK0y?=
 =?us-ascii?Q?zQh9hFaibz5JbileNUUBFAVmag99XpH0TPmE1wUay2enJ1V/B/YFkgBd+p30?=
 =?us-ascii?Q?oq5+OWq0t0fDzMI1vjPlojU4JdsoNA6HXXLJA4Qa5/Ta6/vH6heOFv9tHv3H?=
 =?us-ascii?Q?HLAtv/Ta0P/sKpFmsh3GrcB+hNIhkVWAK9QnFZ3SZun5jAJA4AQz6HY4kEpH?=
 =?us-ascii?Q?RvG7WE0J6fD2x3ftIzpzcrH8j3wvnX1yCxYSl2h3Sb+9693gAaWkdtw86zuJ?=
 =?us-ascii?Q?V8rJAPddG9DgcQBCAah3gupGGxK7pR0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97542e35-dae6-4320-c494-08da4dfec6e1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2022 12:09:48.1156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +aU++CgWwHEveKtqA9IyKG9Wlr7peAGs/Clac9s3U5faenT6qg6LAh1s2zu9N1wAz5puOTSXo4/CR5M7nAOq6OMwdPlo8FJHw8Rc6GQrr1I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1482
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-14_03:2022-06-13,2022-06-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=611 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206140049
X-Proofpoint-GUID: nhs8LIZ5gsrLcHBlabi5b0mJu8VGDuwg
X-Proofpoint-ORIG-GUID: nhs8LIZ5gsrLcHBlabi5b0mJu8VGDuwg
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hello Dmitry Bogdanov,

This is a semi-automatic email about new static checker warnings.

The patch a75fcb0912a5: "scsi: target: iscsi: Extract auth functions" 
from May 23, 2022, leads to the following Smatch complaint:

    drivers/target/iscsi/iscsi_target_nego.c:830 iscsi_conn_auth_required()
    error: we previously assumed 'se_nacl' could be null (see line 829)

drivers/target/iscsi/iscsi_target_nego.c
   828		se_nacl = conn->sess->se_sess->se_node_acl;
   829		if (!se_nacl) {
                     ^^^^^^^
NULL

   830			pr_debug("Unknown ACL %s is trying to connect\n",
   831				 se_nacl->initiatorname);
                                 ^^^^^^^^^^^^^^^^^^^^^^
Dereferenced

   832			return true;

regards,
dan carpenter
