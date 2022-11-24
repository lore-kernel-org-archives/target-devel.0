Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 845F0C4332F
	for <target-devel@archiver.kernel.org>; Thu, 24 Nov 2022 03:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiKXD2R (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 23 Nov 2022 22:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiKXD2P (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 23 Nov 2022 22:28:15 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4B032BB0
        for <target-devel@vger.kernel.org>; Wed, 23 Nov 2022 19:28:14 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AO2iLtN028257;
        Thu, 24 Nov 2022 03:28:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=DDdmOXI9GmAm6E6W1I0ly8Vzy8/0F87cfwZyuw5G7A8=;
 b=mkroeIphVYcwrFLczoDMIJaKYysQ4h8UDL3zrpntRQL4eA+EcYuUND7CRsL26oF3a2qI
 iSXqS4sWwz5gaabCPRPejGTeXnwWnKVGKML/l9gBy9+q9pp1S37PdS9XNMtVHiz16IgR
 7thOI0F6PKwD5N7rfK0LvZPho47zvCjI2vzKtD/2celJcTkdFP6NJewPqrDbsZizm8ge
 8PAGoOmCp3iL9gen5XLI4gzEbaA83+m/i72IucFsOAb+IBJjWCIiXQsjulu1tT9UOgiD
 M4ieeTA3SqarcsSIl+oTYgOOrbkZIRZs+mMezf+iX+KMdkWDSUUJh+sU9tYxghLRyTpr xA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m1p5fhguy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Nov 2022 03:28:11 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AO0Ji0v009303;
        Thu, 24 Nov 2022 03:28:11 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkeeu0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Nov 2022 03:28:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZvXmyxAQfd3g1AearO2j/mlFUytkVDQD67u6SwWxXcBUit9RnUx8ez1FCR+mU2TXNeAZmt4Hj/h9OMFIdo0Yp8rub8BXi7Y1YjznW/vuzvtBF5IfIaOX1PaciXzZogazdVo8U4KC9aw90dNHKoUJ4fWnVGI56rhZUuIaZpwMpbBdS3CWFsUzkpiu4jL3tiCrpRAJTSTp/G3TxPXQVY62CIcH6aCRRULqEtM2zoXmN0lpK2FyGHPwt//rqOU3fLa/+Ddo5C3WlwLV7Er04A6lmAaFZGQb9eb6FDNpXJoVGtI8vsH2OwD04mlEIXkiYOet66EY+FvGwH1XhvatPyGTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DDdmOXI9GmAm6E6W1I0ly8Vzy8/0F87cfwZyuw5G7A8=;
 b=VA4DQG+476DWGaM2fgVFJUij0eTjo7jX/jV+RJsGcmOY8wc2qp+/C5tLvsTbYsWL1RqRU44c1SWx3S7nJIG8Zu/TrDh26SJg4ftSjrnVPiM/jBG6FR81B3O5KUhStZH4yDHrEZ8xhzBWL2NV9nNnfJMS+1wYLaf+M5dTXWQdR3QJ7SeOiUj5iI6yU03gf1S+HjThLan4hq92SRCButEbZIb6plT3MQidK/WnV4bWGhFBxAm19gh7oZf6h4u+odfUTQG7EB9QLFpT4/EP3mwYommhSGuivb9dQOthEkxpHfh+E9qEv0yN57OLqC2xe+50N5p2nD3XQuqRcu0PTfhTpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DDdmOXI9GmAm6E6W1I0ly8Vzy8/0F87cfwZyuw5G7A8=;
 b=PeXlOHJFV9/5o1rNA8+rUZ1BfVtLmc+u9F1GDax1hHephYmta5ZYFGEqF0P9BaYpZEx0KUdsic9+eO5PRhXi74JwnkHUKtXQQ4BpY93DbVlUzxi6hXLRKRr3MqzsRRfW69dWSQ57OnbDOx9L68oFYja9oOb9Vi/5Inm1DJKVSX0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB5181.namprd10.prod.outlook.com (2603:10b6:5:3a1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.18; Thu, 24 Nov
 2022 03:28:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a%8]) with mapi id 15.20.5857.019; Thu, 24 Nov 2022
 03:28:09 +0000
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     martin.petersen@oracle.com, michael.christie@oracle.com,
        target-devel@vger.kernel.org
Subject: Re: [PATCH V3] target: fix a race condition between login_work and
 the login thread
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15yf5t4jm.fsf@ca-mkp.ca.oracle.com>
References: <20221115125638.102517-1-mlombard@redhat.com>
Date:   Wed, 23 Nov 2022 22:28:07 -0500
In-Reply-To: <20221115125638.102517-1-mlombard@redhat.com> (Maurizio
        Lombardi's message of "Tue, 15 Nov 2022 13:56:38 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:805:de::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS7PR10MB5181:EE_
X-MS-Office365-Filtering-Correlation-Id: e90b855e-810e-42e5-7cea-08dacdcbe8c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NkCciD6YHtnXGDYW/qfC05oVWQy+m5Ei3iFnqxf6sWC+9UTlbSgp7LR4XvDZQ45w5V6bJ6mFus0D3bbUpguuOSdoEbkyfKTAVfIgdKQhQtCOF5PSLncESC67XzRq4EG9GKiVNSEUpIUN0xcQYdUXX520LO8kLQNR5cLTriUe5d3gldCtwmkW+i3rZYQO+OwhXVckFo/LdfsNDiA1p/+vQkTj3h89hTsiqpsC4Qc/7TU4NM+9Ni32Uz3/vCfqGvZy5g0ZMXaRR3a/dPSfltYMO6R+RXRuoZRskPFxmBVD5G/V5msMLxb1jxQBeHk4swHcLJC1Xa43l85L4pNyGtKxlnAfQpv25zx/qxrHMYMZA7V2cB8lceqGlC9YK7rdwE65jSPgYGy+L0xs+weGnEldV7jmdQNW/4JbbR4xnUvrqE85wNg3TWk6TXqTJH4cVxi+CSZp2Bgy8Eyhmx3wlc+OjVScccE9WJhHPSDAZzzYuf6YgBL020vwQmQM7uQIspNMo/lbIX8aClQ0vm3xCoEiBB6nNEvokbpQ72ByJisE6ptpeTLU2Peayp/o4Wl5KmD/kwxDUFwQdVygrFMwLgjwI4+A5FNPxt5q1vBSdFmd+xYFhsgimqfQyxZQvdq/hr6e2VYKc4atbWJQfHLWLzC7Ag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(396003)(366004)(136003)(376002)(451199015)(478600001)(6506007)(36916002)(6486002)(8676002)(4326008)(26005)(316002)(6916009)(66946007)(6512007)(66476007)(66556008)(41300700001)(8936002)(5660300002)(186003)(83380400001)(2906002)(4744005)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?riIzM4bF6QUnv05es0Gaa16Ztnd+tEWcxoG3JyOz4Jdfne3U1MkgJ7unVWcJ?=
 =?us-ascii?Q?9undcGNcZ65BjdxJBTZG+TMG5i36K71WT6ebsiDd/s+d0pGSlOWtzS9eJX7V?=
 =?us-ascii?Q?N7BtkE5qg2EJcAtbb8B+FULiEDWHqdpGArhJEW+45qWlZYjsxlyzvRTuyiHS?=
 =?us-ascii?Q?i+tkpFzwPftqNpt2ea8fuch5axPdTpewwaGZ0F7xooPi3N/i6uoMTaIWD+Qv?=
 =?us-ascii?Q?xRaiuusHXFufaPE6CO1hByRBGfkPle/6YBlQqPffkdh++oxCY9Lrcfp4Fud2?=
 =?us-ascii?Q?uIOoZJAwpL5rnLVxzUUmq2wfCzbE/PEu9ZaSPabUWMg1qmgClQdluNQ+HvyK?=
 =?us-ascii?Q?Vt/yJV94LkOZMp4a8LmvgSf9ViDO6ItMgtiVkjkoUL05IadbHsxl0j1cl+J5?=
 =?us-ascii?Q?nddk9n6DsSNiewhzWy+CLj5xTPLNrFoUOD2eKWhtMqRP1fM2czs+0UXfTIaG?=
 =?us-ascii?Q?9ESR++AJSqXgDjOAtchgXzFT8ydNhK8Ik+NlteQ5cjUAYGURptCgDQBC/qXe?=
 =?us-ascii?Q?Jup2J6cYLQ3YynA2IQZ3/vgtPMd2w2ebOkdstEEqu9AsbY1yzQPdZLT+dSYv?=
 =?us-ascii?Q?a3fdigpfSriUkgCtqlOORfWln37LTB5EFe6STrf6FWgkcVueloKOdX+so6MR?=
 =?us-ascii?Q?9A2w2bv/T8GmBGIFsCwowwVj3NJ6wInosTUGEKLEtbMl13oSkPgMAFp3eBI4?=
 =?us-ascii?Q?X0aHyi/rP2kVdU6FM02PMIDUJ+bWeeGQxSUMal0wy2eoVPtUcg56g75NUqDc?=
 =?us-ascii?Q?Ab8qT6QR7NwWK3SfEhnkUMip6CDDj6yqEd9oSOILD3vxsbB7mNEiZ5VP8+t2?=
 =?us-ascii?Q?Fj9oDGg7lGGFZp9bez7SQb0Qeld0jZRD7np+w5fgMDI9/rJc9YIT3sr81KAf?=
 =?us-ascii?Q?BJ1K5FKQrYllF6U/3/ZM5eyDQqNuSZ9SKruPt7pu1WRusp9/izvi6lHz6cEr?=
 =?us-ascii?Q?fHyR0P70xi8ZuZxhcBFl0eC8eMtVa2qbweRqdUnKDYps1OvGwbJAyR3LMU1q?=
 =?us-ascii?Q?CFzpzZl+6kQ2CagpxoyHQ7v2vdZ+qwI5HOSYp9HP1m9S/nK4aWMtrpHkixgp?=
 =?us-ascii?Q?QTF1DL4fFDCc9paPMCRG6XbpuWPIfst9nKctPjfebZxoeaEWoAqs42oNrgtc?=
 =?us-ascii?Q?zZ1oazEfo5pSCvz9ZydinG9H7mepdnviQaLsaAXDC8xQeynmOEECBLwSdJap?=
 =?us-ascii?Q?1ttfevxOxqTSNX0cJ37UnwVQN0okBMLa0M/Pe4KzJ1O8YZmA/jgl0MK3iXac?=
 =?us-ascii?Q?348aFifISGaOJJn+jji3zjZKXLmb+92DNDenSDYRC3v8w8hCQuPeXibTAY2F?=
 =?us-ascii?Q?lBsTDNCDB6lQPC9Rwdrm6xtDsfKLz6+2CSwZPsaCQXzPQIqmuIayZjbjjCE6?=
 =?us-ascii?Q?4nbHywwOUMgO8+CGGCnf4uThi5KoXSYGia8yz9oezCnUT1ONIlUyct/hik+I?=
 =?us-ascii?Q?FJm9wFGIsHPWnjZiFvzHC35nVVhAW/vwwT0bJDK6dGHx3pAAcIB17m0CbyxN?=
 =?us-ascii?Q?sBpLLTeZhaS8aEFXn8Y+X3YRJt1FAymdPcyXGB1gFJyA1cE8zBZDKN0t1Thq?=
 =?us-ascii?Q?+BEYR7XtIk/Yw4VSXzKoJZB8iJb6C/1dE3YPztw8zn+42Py0xh343G6LAd7N?=
 =?us-ascii?Q?MA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: VJcAQb/+ysgKNx+xESgdvqBy9LBfI7mYe87SuDFe/22Y5IE4hWPRFwUlbd3/48FxMojwnsZ5QRCcHoC8bzQadMAiogF3LSH9oPeN1s2yL0qiEZx1Gu1Z4paN4N5a/582EGcqau3BqiKvvAsYsb1wiAlo07kP6OlibrSEJEntrOE73wvDwUrZycEc7jFjjjCRg4TncD/PTSF4eD/8/3+4byz5oZiCWo34eMbeprPB7hyCpSi3hNDjrNYPA1NrrRcU8Ctv8qM+63vMdlY1zfzkLOhTyEcfUCM4Da76I3/QLnmf9RTnZ9dvgh65aD04xknt1l20vfVPSgyVXfZxopHBEFwnfzakMYXS6CGfTxXopWkEa8enJybyjiHAoz4gROswjCijV9WmX8XiJKuqPWoOHwsB79rgjQoZh5Ma3hYneyxVqCVt5b7Fk6+KTMLKXFd8brXsrJbPjHBKP2cyhC94SwrKZkulCeZpKjLgBXq+z5N+nT35Ik9poTncXipUGp2RegZNxc52tOh0AkEGFyN0Xmr/pN6+EkTT5OfcDhAIJyKcZZ2lepzZuLIz0YncQE4Axq6OpBi+ZZ0pc/X5DJXuVahP9GSvDhTJlpul7GyzBqaQsH7VOsP6I6LZFlewKnuIt6LhFAE5GdQ3dVfV4PkHtGP6cco9O/5PUoHdQMZ/XFclnD6VV0AI23XzAhFhC3xWRRWOlo3TJBiXjgX7jXsoBymHVB8XdeF9Mwzxd8nnqu4e3YPf5XtpEcDpjrsADy5Sd+GkaofbxSyHZVidL2w0lUH5JQRfeX9pzBbfFhDrVdc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e90b855e-810e-42e5-7cea-08dacdcbe8c0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 03:28:09.9110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dH573t9ZBU3E/5DcJd+6/QcSuSGe7g+ZAyKH6A/Q3HX00ChGSWDS0euUFMMkHQ80TSVFSMZzW76rd/3jLmqHTJ4w+3/fCOBXofre6hwC4xg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5181
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_02,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=896 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211240025
X-Proofpoint-ORIG-GUID: QF0ryswTMrVYisPit1Gg_L52ud3NzZ_6
X-Proofpoint-GUID: QF0ryswTMrVYisPit1Gg_L52ud3NzZ_6
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org


Maurizio,

> In case a malicious initiator sends some random data immediately after
> a login PDU; the iscsi_target_sk_data_ready() callback will schedule
> the login_work and, at the same time, the negotiation may end without
> clearing the LOGIN_FLAGS_INITIAL_PDU flag (because no additional PDU
> exchanges are required to complete the login).

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
