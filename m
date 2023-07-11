Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD343EB64DC
	for <target-devel@archiver.kernel.org>; Tue, 11 Jul 2023 17:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbjGKRa1 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 11 Jul 2023 13:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjGKRa0 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 11 Jul 2023 13:30:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75172A1
        for <target-devel@vger.kernel.org>; Tue, 11 Jul 2023 10:30:25 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36B9T43f006037;
        Tue, 11 Jul 2023 16:34:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=NEu66J8tH0EqYdCN3tR4oOZVrh6wvDI+opJStiv7oPU=;
 b=qJ2xiUnzk4y9ochpSWx11QM+obAXvVbd8lpszQxQ0ue2TTCGXIVDtHoHz8VA1sZQsfYg
 k+62RunKj04kFuzdfNKWnWIymP0S1cNLT7/gfN0uWZmrrj2iNz6q/oMS51WeBR35b3lh
 X5EH2+mQJMKTiP2wnBokPi69goalvhXpLseWMipY3H8BlkpbpBE/N1Cfsy8xa183hylT
 j8XKTf6aT6yuOvXPz0j4ZNtCzNgyOs85/8s79W74MVN4qkvNd/gb2oRtsq/TE6VKzIjz
 xSLwh2UF22y9dU2VIbdAf3sDFoQN2cZj6qgCdkw0iphI31k7CssdOQLOD4dHkbSn0LyO EQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrjmhaucb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 16:34:36 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BGV5Kv004189;
        Tue, 11 Jul 2023 16:34:35 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2049.outbound.protection.outlook.com [104.47.56.49])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx8bdf85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 16:34:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VCeJCwxOYM0atd715CiITRrc8iZOYaJ7S9x6MSDRtv6R3x31AbjtGBGeqQIjs8qUuGLnT1jOn0YxDQhBgi4zOu+uqYDMtSSEtXIuN8bmRtnkIhCAysg1yRAgQvZVx15to6P8srHxgm1ITFDva6wq/T4LlsfHmQZB8JEqgb0UJhfmTjS/3Y+zVrw58OD0+6HcmxR++5hBFvs6C1K8bF3BXAYiUgecoY3O8mGAbbtPZDkPruEXwFuBF9e5yrM6oN0F2QVgBnioARrDPKlJk5HOIo+8wP3VVkj8RZmEpEYVRc+ew1PJHb6TGzsbl5Rh9rpo8hCDw036vyZxz7v4rgRW3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NEu66J8tH0EqYdCN3tR4oOZVrh6wvDI+opJStiv7oPU=;
 b=Xx5s+5TEKC+s+4kyndLson6zEoI2+lfhWFYsGL6tgC5syzIalsdh9U1iAWve4eXoyunC05H5/hp/OEhvEiGITQOnS4CpYUHDOeN3gRxwpMt2iq+s2ULNo6/swvS3nno3a07jNHU7yWx6PgXN91FOQTQLP6O7gNzcrGClI+WoLA/Dkf7He8F03BtApSX3qV64BWpdUpMp4g8ivFYtbG4W4k5sce8rmfalxqhRH7Xmr8Jp2uEzBI4swiqBeo4DRsNGCqn1doSvbGFlTFcC7rvwbe/Rq+QwEN+uiHQe6VvYr/5xuGbJ9pwaD2kwG4QzhJxXxexZdSGZpt372DlVzn0nwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NEu66J8tH0EqYdCN3tR4oOZVrh6wvDI+opJStiv7oPU=;
 b=baZLSTJKGUpGv2cd9Wu2EsE9QLa5hkZHfk4wUXL3/z9VVn3G3oUPpNZJS3ffp1Kc2mYyrlczi53OI4EhDa8KXUuOHIUk6A5CubEEDQB6ZBzHckCxJOARrNgcPWkvexyOqm+AolE2hoaNED0UIMce+Q1NEsQHU6D2yQf3i14C48Q=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB5151.namprd10.prod.outlook.com (2603:10b6:5:3a4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.32; Tue, 11 Jul
 2023 16:34:33 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::101f:466f:718:4375]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::101f:466f:718:4375%6]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 16:34:33 +0000
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     martin.petersen@oracle.com, target-devel@vger.kernel.org,
        michael.christie@oracle.com
Subject: Re: [PATCH] target: iscsi: remove the unused netif_timeout attribute
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r0peflv5.fsf@ca-mkp.ca.oracle.com>
References: <20230630155309.46061-1-mlombard@redhat.com>
Date:   Tue, 11 Jul 2023 12:34:30 -0400
In-Reply-To: <20230630155309.46061-1-mlombard@redhat.com> (Maurizio Lombardi's
        message of "Fri, 30 Jun 2023 17:53:09 +0200")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS7PR10MB5151:EE_
X-MS-Office365-Filtering-Correlation-Id: b14cf17d-f51a-458c-7119-08db822cb4e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UMZnIJcgA0uuRfoS/Iy9ePWg26OxiNvF5ZEm5hg/jstQXzFu8GTq/3HT3wfV+ud0V+Q2/hGDGveoZUXlST48PBmijMaNuhQ+MYUTYtNCMq0OsPcDcvbMG1V09gTSxgHl9wo8jQeaZQSpPnr3LKNkMDkhokALc4CCPiIv9ka/dyI2IuToXRjjh4DAFreQbPY58gBc/ZkAwxh5QtNATzR6lCPVmEnkW5fuU6r5LCX7dFxYR+MAvu9DpDRisAQnOVjQ/7ZDBfBh8265KAk+Pl1V7mwF4BlrItK5Kp5N8cjZWjxDWaaKOf+qwvLxrSzA5VxxPTELg+L8ffo1GlG6LaoykjbWA7ZHu9APMoVhBE5ISPwOLr+DVJTJd2/vsImH6Uf/fAyhg+j/Z4/pazbUC1rFM0NIAJpShvPtxE7aOTJr8Y6sSf0ZowL2Ev6No9zqSnm0lDOm3LQRaqzqzzC67KO0DUoCDaCyiLbab04/C9u6yE1TMUR0lOnt8DSOq8MDv1Kjwrq7QTp4m4g2liWJzrqyKFs8fh6UKD6W0etUyVjiUv9pklFTXQcGP4iT6eegALgv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(396003)(366004)(39860400002)(136003)(451199021)(8936002)(8676002)(107886003)(5660300002)(478600001)(41300700001)(6512007)(6486002)(316002)(4326008)(36916002)(6916009)(186003)(6506007)(26005)(66946007)(66556008)(66476007)(2906002)(38100700002)(558084003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K9yNLiPVracplEVc5NRZbq6iXfd8c3oykSpz8Ea8ZTGJJwW8ayoHUE+Rbhy8?=
 =?us-ascii?Q?/oGmlO01+5/Uw/Yl9QxPWDo7abIdkbEgjC7Bd8Zn0jWqiZS37UD7JlrHpkJ2?=
 =?us-ascii?Q?GEoP5H9VymMCuG0Dr8WbJ6iQ3EMFqM8MuxbXo93tdsDt7DdXOe6VTGljv76c?=
 =?us-ascii?Q?ULL3S8JV3JiRrTxiO55CWiWiOPwWAH3IJKGCg3a7/dP6Vsu01oqGbdMirA95?=
 =?us-ascii?Q?SMG1C96haT8rKjg+OTPQWtdcU9z1vBbYZPeJNVFXeZy4R/J5Yn9FLnUssVe6?=
 =?us-ascii?Q?rHS7I8spCIBw7DsGQ7t4RgSHN6uVn2lNygAG80mryWoXqVsbk4As3iQzPtMl?=
 =?us-ascii?Q?PtB2KbSw6jFtHT2Z8JpAu+mdM2GSBGUzeV/6HlZ3rvUy0QphA9wk1hZTvXb1?=
 =?us-ascii?Q?FG0m1O/IWqZYqJzpv8iUvCpzI9ZZuyXPnufIKhs4FvjZjRqw4EmucuTKDSI3?=
 =?us-ascii?Q?ciw/T4iKguW/Xk3ZTK0SYDIn5IlnlnHZdC12Y2n1I1JfVe24KkvUGOdJgwrx?=
 =?us-ascii?Q?5jI/938oHP5Jy5rs/aUGKfh12vpiMYTGnPG2g4anlgwzZoxi2QQz/OsFmA/w?=
 =?us-ascii?Q?Jv+WyKQM/f6d5NSL6qrz1QLEOVvcOrsIex7+wRwx4RDtknLwXkGzYkk7YKbj?=
 =?us-ascii?Q?1wyqzD9S894x60f01JPWmJ79I1qCvtNw0VXIP2eOTFRHSVYkUNHnh1VqZiqN?=
 =?us-ascii?Q?RbeJXfE5HT4NrXAhDv91dBbe16PzvUXxbrvT22fLN3VEFQqfEV6OY/IWSDB0?=
 =?us-ascii?Q?7g0+giTdS784vmJ2LqCSSYie3tqJoVCpg5UgmOt/Rq/VSAvP20j4w6iMbxeo?=
 =?us-ascii?Q?wovQJC8RQZq4TscTwKEBh1qm42FEdeZI2z4U3YBWSjCfTIX9M3Yaout4CZza?=
 =?us-ascii?Q?72BD3O125QtyGQf/hOYPyseBffTyfiPRHkPvGDlmrruWxQO+ix97uZZObcvI?=
 =?us-ascii?Q?7eL1WZR/D5blmQjB/3Et/fA1Di/NXZxTpVBlerokjMgMocRj54UMDzcMrrco?=
 =?us-ascii?Q?Huoe5oi5fzy937wbHuoXbA3pkggX/+UPxxojU/H+53C/ApEiRVbO2bloW/cW?=
 =?us-ascii?Q?Oe3yHlXxCYO1BKIMDS7K0d3yqR2sbdwmuw8Gkvo7a7XVLsnFMHWpjOdNRHjb?=
 =?us-ascii?Q?y/ZFX+6lr6mlsKOoy5Ka6LTdiSso0sESB7Py6tAWcCUIcHEoLRseAzo+2jou?=
 =?us-ascii?Q?I6rIXOhoqSj14nHiTLI0aIFeTvRzTYFKllX4Bn3dSoxFBXQwh3bSGACDRNO3?=
 =?us-ascii?Q?VlNv+MNrcl6M8ZaxMmXHBF6R5zV/VoOcHMszTKAtgBMwz3u0Ks0A0TRmKPhU?=
 =?us-ascii?Q?o8F1+sJIy90tuSUsTnmO6DR2G+ioAtihNldQkNZkY+GgA8K0r6D6L+NiFcIi?=
 =?us-ascii?Q?puIw7LjVEvi17U6TBhDHq42v6KFWCqNnEG4/Y2w3rk6Qm3HUPWUIgxf+AX1i?=
 =?us-ascii?Q?PWS0Vel8FxECGZ8HiciL3+jc6mwEzE4CIzclq5okl4yNhHl02IyRaHV9KbxR?=
 =?us-ascii?Q?fdPtA47RAnqnFtBg5BM/VuqrsUeB2fWmBNR71V+hHimRLVWsgMesY9+03HlG?=
 =?us-ascii?Q?DzJsBXeXKu1og5RgHAMFsVSyTy3I4AEeKv7i344EB2mm5vA3NQIyuxEoRuRo?=
 =?us-ascii?Q?yg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: FC6nPGHLxhGmUWdjOO/NzWwDgUWmv3PD2eQ0dJR1BOy3wfa5Z4Q34T6DTlXkPrh64xeDCqr2/Cc0Y55MtxWlGTQkVk7MnH/79GIsIordQcLlMVvVgRbFF2gRGdEXgLw0dTIjHRU+v9Xw02cGpE73gqf8XAipnQYrafDngstMO7KyJxSIgoRWk0d6fvQc5U0Vx2c2uN36i4HC/tKCMknRIe38rl0cfmMjsVNvABkdXf4i7GVp7j+62bnwmhDA4VZVVJkF8YrMjpfODgOhlejhRrkRrhVP2NcRE+xVcqypCNLdLGKsXjaMah64NIo3xSidmXP47bdVVqL09nr03geDbVFRp04bCPVrRXLcli2CvCdmX5t2DHPLbIgiVBHGut9B+fe/ajGAlFkMCSVjD9E12eqetQGVN+Vfa0a1+ebFLT8jBLL3f9aBWMYvqqc9epZIhik8i1VulTZm97ySu7ZVAwwDDt7E4DmgLxfFfRtCDLaWJx+ZahkKFpNgSDjhxXEuUZQZcmCBojVD8DiEfCyRPWNK+BAPL3P2bJirIQIrlqqFORD1RSMzALJAvqJ4DXfS95WR1zS1ws1Fyqg0Us8acO5MLa2BBr4cwp6pOrO1IZPJ0TVaXmRNvjc+peU0iE/eBdjxp1Z7F2hEYr50EIfuc0qzCzyus1eZL2QYghJrYeP2yjDv/GS3TPLR/psCeiMiogtc9jH7IBVxEsrXHS3g3yZmX07CuQIXG76GGu7ksWBHKM1WlQKkw/xG3Lmi3ciwrgBRoTWMH3Z1hGxg/VWNPd8+Bc3/8g2z/EIlXfBgNlU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b14cf17d-f51a-458c-7119-08db822cb4e5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 16:34:32.9950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F/qIiqNeWQ/lVVqa2c3cASsnOOqfA6AFcnJ6MtED4T6ZsC+qT5m83Zt54doQAvwxYMTJ5bFGvqbGHW7SzMvAHPWA9Cqs/1eMdRxVujSNePo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5151
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_09,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxlogscore=694 suspectscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307110149
X-Proofpoint-ORIG-GUID: p0Sb7cFaYemyKXNKpl05_7LhrpiUAgJm
X-Proofpoint-GUID: p0Sb7cFaYemyKXNKpl05_7LhrpiUAgJm
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org


Maurizio,

> This attribute has never been used, remove it.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
