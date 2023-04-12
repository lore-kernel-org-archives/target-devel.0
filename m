Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E3CC77B73
	for <target-devel@archiver.kernel.org>; Wed, 12 Apr 2023 00:52:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjDLAwK (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 11 Apr 2023 20:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjDLAwJ (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 11 Apr 2023 20:52:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECB935B5
        for <target-devel@vger.kernel.org>; Tue, 11 Apr 2023 17:52:07 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BLSChM018049;
        Wed, 12 Apr 2023 00:52:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=E/jfjUFaK0nNVjDCXm0OtkrCoh6eVxSqeHU/ZVJAlNw=;
 b=xyhXBhi8B3rAEkuVmrjHEhmdPiS9Dnvj3eu033fUkDExpyy//Zd45wcJuMZyPo0wfsTT
 beC/y806wCnNgF/cazX2SfclLoL9Xi8+uAKUic8JLYNomPckPeO9j3Tl5zztwSjLdfdc
 7s/PjBEuQ5Jcfa12KkP8g7r1mn0ohQZdMCpsyGda8JSvpZRjFJTSCZVHqz7qDLIhpuh8
 JsXtumewnDy75H+E1IVUgJPh1EoNS7cwHqtvCcN2AR8DpsRDBSM1/Z16vXtKAq1Vp+4o
 dKZXbQxTs+mhY2gxuFZyQwcccqBQbLUwilyA7CRvS2R5LWI0zs+h7oSDIOa9/QCrrXda /Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0bvxvgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 00:52:04 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33BNqDOn009895;
        Wed, 12 Apr 2023 00:52:04 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puw87sfwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 00:52:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZGcPe9A6iAFS8+L5PmtUwXatyIXab3tLZmLpe/0SS0pwAonTzkpAg7/tYsfLx8EnWHloTwDXtCVlv/k5Z4P5jnCBnZ/6z/IHmkzUXOS8hLmCh28kmbHyp1bHIbuDNmLQEi7SCMpEaEb/hvh5AtSQisyqyjT7RjwB2sh9VHErI3yuJanVUUxBCIvNwQwu97Uj/WlONNRq7LMr+qMFTOA1OFMAtXJmOjIC3Rtfb4tYM103vnbPYzR/qId2bkyvmeXq+tdmlloSbRgSW5/RfYX/DwPaB1kO9AM4Rni2asZ1UJl2+AKV20lclvq/2fFhEChfuL2K3GgaasVQ6FJXTsZsDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E/jfjUFaK0nNVjDCXm0OtkrCoh6eVxSqeHU/ZVJAlNw=;
 b=aLCxpPip7WRdy/k0XYWOGZTYxJAITWWZWvXXvrPi3bG5QZgo5dmmjxPKLQepYSnaV4073JXRikL0FOGpGUSUvB2to0RoK0O8YGPChnHbWTzBj7IOr56rtacWtWl27lVmzReEVwWyXqDU6jvL6rIrmSErS8qKUtqpZZswrDIsB+vfxNoWqzW/RHeul1xvWlAs6nd/N6ON4FOXdCeiXFd/GOHTPPicUrWouXqfcjQKNwtCgakkJqr4nRd9e9IZAdrsGkfmzsbUaXtZ3xSZH5mDAeoYFHNXcpG06j7A296QIKfn0Mgwwh4mRrWOGjVOWC14ku9cxwnABoXCUw9S/4h8Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E/jfjUFaK0nNVjDCXm0OtkrCoh6eVxSqeHU/ZVJAlNw=;
 b=S+1bSMEfEJi4F2kOswCRPQ/VRV/K8jEmSB//IvRjTPXjBUTOXr5PfsPhdYhYq2YM206aqKRssnWbQ3b82Vmtqc/gHewRQ40jPQfqExN9TYlZYy2HLWEDl/0N1f4dUJzjta1P0Sf8x0VEoVclUYvg0T45l51bhhZ3aExWQ2Wqf08=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BLAPR10MB5298.namprd10.prod.outlook.com (2603:10b6:208:320::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.28; Wed, 12 Apr
 2023 00:52:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6c5c:93c2:3d1:5e98]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6c5c:93c2:3d1:5e98%6]) with mapi id 15.20.6277.036; Wed, 12 Apr 2023
 00:52:00 +0000
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     martin.petersen@oracle.com, target-devel@vger.kernel.org,
        michael.christie@oracle.com, d.bogdanov@yadro.com
Subject: Re: [PATCH] target: core: fix invalid memory access
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wn2horc7.fsf@ca-mkp.ca.oracle.com>
References: <20230407130033.556644-1-mlombard@redhat.com>
Date:   Tue, 11 Apr 2023 20:51:47 -0400
In-Reply-To: <20230407130033.556644-1-mlombard@redhat.com> (Maurizio
        Lombardi's message of "Fri, 7 Apr 2023 15:00:33 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0105.namprd05.prod.outlook.com
 (2603:10b6:a03:334::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BLAPR10MB5298:EE_
X-MS-Office365-Filtering-Correlation-Id: 934b4ab2-786d-44d2-88c9-08db3af01fe2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VAn/HeRcxT3O3MU4LUywAXORQrpYZSy06JenDNz5We2cpnqLFwsK6+jZaDN/r68M0YxorC7UfiAITD6IezVNxXHi52qjwdkBnuXOjnO53dFMHqene5LOarokESCPGuZDilkD0hdJUbr+ZGNC4FodywSXLUVDeUJWYdG3yR40u18Ux7jFgIuqs+dDaJQYbt2BvD+jzIXBCGhpXUTetdKv8+6698N54q1G8yMFS7kGnCK0Qdsq7DaEwi5B7AzbJvUD6dt8arG9SZS5PQmMTpqihFERKWvuh2SxmVn/zjW2X8qYCNfMJHebDAaVzIohvycbuoqN4/2cRdfK1pdxBYXAl5QePyclKvUtKhoSkPWoe9l5Vhx8Nkec3SdvupAK+44RD3xtmcdhvlszLIm2SbCFacnmXjrUq1hs34BBlbqRul0GqhZNn1Y8O1EMBaIHgyyCwp78XYkeioOAJ38OTArDyVd3WRVgqDQwoKzP1iUhGBe12dF75KWz9mfa4IXwYY4ejrBT3v1A4xKbK2W7yg1pihPYrBI1rqsyipDitzgYeDjn+XMGBzSN6yDv/KdpLVc2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(136003)(366004)(396003)(39860400002)(451199021)(4326008)(6916009)(6486002)(316002)(66476007)(66556008)(66946007)(6506007)(186003)(6512007)(26005)(38100700002)(5660300002)(41300700001)(8676002)(8936002)(478600001)(6666004)(36916002)(86362001)(558084003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v/KbcTEhHZIC+Ve72iP/iWCfM/rhC508LmUDLjZDls8WN6e9KExDnUr7AXSp?=
 =?us-ascii?Q?1Fs/FN+DWiNnb8Zgg+pqgvi7svv0g1WK9gJLiit5ewW4P1xm8a3w26DPRQbl?=
 =?us-ascii?Q?42SJyfcjp1lrubC1tip5rN5rzEUFFLq9w4hRjIfBgdSpM7zUL1yMOm0BxmJ5?=
 =?us-ascii?Q?3GPC1ECI14ZucB/iLZ61DV9ye/55R9x7dZqEEKA72moa4nfcNHzXKzInw36B?=
 =?us-ascii?Q?ajnX5lP3kWJkl76hcqZqTfqL5cQyyhhoyiG/vQkIsa023tVk2be7PNleNdFK?=
 =?us-ascii?Q?jZK7HrjSPaEnZ6V92JlT0/G8hukR8ZsdOsBnOHw4VUjKtApCoz6kKuR2gow+?=
 =?us-ascii?Q?wgQqhfYiMd5jlcrjvm0CHB8U+swaXiRkO6q8/yzhsxU17bswJrw9zpjzJgJe?=
 =?us-ascii?Q?cXYqryKQEJUpXRgiBT+xkv8defQR0hhrhO/eb8J61WVWlyhXkpP1KvjlIjeU?=
 =?us-ascii?Q?cLGewqnitfcYd3eAVhmwM6Cds04T8u+j7eWhPBr/86QtjPBAXfdxOFRDZdJy?=
 =?us-ascii?Q?PhQ0/OVGFtKC3AoBJeSWLgCYjtzhJ3abz5ae9XO2YPeyjJp2S1pw2hE7+dRP?=
 =?us-ascii?Q?Qlrtj+c9ARmuiqFvnoQq7rS2YnTcvK2KtFUfLw8j0bTmBTladFD+AUxmneIn?=
 =?us-ascii?Q?UPNuUCvAZfec/FCYJtQGC7YjF48KO/oWwxpoXF2XHquSPehsTbpxN+tzHoB6?=
 =?us-ascii?Q?7AjosbxIeE4xRgl/CaYQnhFaDAf1+1KvVX2jAcmUhGTcRUqKzkqXZyySTG6s?=
 =?us-ascii?Q?8z9aWPwA5PLVfYijmWNccAUtvR0Of8U+ohlb7oXUPy3G6pY22iquKJVO6li5?=
 =?us-ascii?Q?kmO83a4KxiuvwbXNOziYeq43cep24jwGSMpMtkwlr4BximeH6ZSGDLm+aQnV?=
 =?us-ascii?Q?EwCevFbxarUI3q1c4JKFb1zbw/kM5pnCjtBflihpKHbJfuM7KZ+rvHausegm?=
 =?us-ascii?Q?xZrs9JC7nH2WlJoNznxZHBKQDh+dgCBa0psse6ETBGGZP/aVyAVNateoRKvI?=
 =?us-ascii?Q?swwy6fRaCrRLtntmF7DCQaVFoXe/Zw1Xs9GbKdNV7xI8UnK9KPs6tURIZlnV?=
 =?us-ascii?Q?CiFgDLL8cxKp64lq7wLK0x4x5fmhhRmxAQoVQtrVg8OtJytlrYCSJx1VTJo4?=
 =?us-ascii?Q?iYhV+EVX/RwzymFmZ8HItgLkDtv5nh001mAbhHmmhiFH9BGYSFHOM25lomn1?=
 =?us-ascii?Q?kI8du53LwmrYLFZ9HoLyVyokvu0bRbdVEHPgPKPZ/8gca9aK7PhVKSPJL1Wc?=
 =?us-ascii?Q?1t+icee6qDlLFkVxslWjG7apper/ga9TA+jgDwjLoOuHbc7uRYjkmqW7I65L?=
 =?us-ascii?Q?uQNX094sBfnXuLmtpx3tPff1pYJFPhkBr7Z4lDBxgppzUIWshAF8FqL+II7R?=
 =?us-ascii?Q?P4c8N6cXhWgoH6Rgn1NcFB8HnD9GXpZIC6Mlgd6fvU7wzwSvn2jmN4WZiALb?=
 =?us-ascii?Q?MkAZ0gfdkUgXNLRocpQaRn9VbPsUPbSm6lP0viOe2bVqOqvmbu9E6tbEnDO+?=
 =?us-ascii?Q?aJIrKCTzsacvN4WAreQjpsOw4107kNX2tha6ExRl3o5ihB75uEqlqkB/3fuc?=
 =?us-ascii?Q?ZMaOHn47qIiY9Kt06bujTK/OHa0xdReK9fl1KQDUp3pAGL2OPDBeuli12Xxd?=
 =?us-ascii?Q?2A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: lGuoY4j4Y9uE1yA6XheVOPNYUsgPUEJkTfreNncKya7B/vHcB0zw8IoO1PPXq+idgczix4BgIkz/W9d1aMRdaxzfrcEQTE4qF4YFhj2+0wfX+p2Bpc3zxjTKgr8pKy06Pnx+2G4Oo/tiC5UIcCuvboLvC4Bjx4GKJbkj4MnXn55tTQqzas5K4Gp9jcOryWqxXagYKwJsvzZU/Tki/y8rKsIF3AkTwaOPudDx+rKvvAlgNqs59vw5BJDoIg6kVTC7kEh/Idv38V+cAzmq5VnG31gWLZeFbtnhz5/oSX+18TJBibXEqA0/FFHmh+kL7/YqFF5OUThPVTfiB6oMk6uBiqEyg7Hn6iV7K9IpeRmV4M+EKA4QpLZjTtQYswNGco6c1G0WDIBVx5yI37Yisia4c1BbrGI7+roLPFoNCytzJud6t0FP4/LcTEmPibfw5eC5s1WlOG5jokzV9l80f9n6x5P/v/tnE4up6dqm0i27vmrXmbxb2Ou6S8KfAyKzhY26x8uG4+ISvqwBJPPCNjSHmCdhBz7UZ+QtGR/y07pTm285pVT6LMVyN4nkQvUANE/QwhudeYmYp4FiVNSvVma5zxZddPvGRR/JVJ1vITKiRIfl7pMTkOv8E3uTdQprx537aGEPwFqBar0YDInPCLu76WVzcO4dXTIW+IksCcJwtKRO7W0R74xxoTPOoU82b7ZX8R63SijW6ORAPLQrsGsY5zRIaFRKYS7dXi0pM5eMz1KxA+MPf42kNU85SUypcLGCJWNt5tSnAELDvY2QHZHd1EQDNq0LRfeIsIh16+WucAsQTsWg2JrbnuCjVQc9yZ1a
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 934b4ab2-786d-44d2-88c9-08db3af01fe2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 00:52:00.7154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vh+GOphE3gXcQVOKj8KtgfCrBN7E2oSvy/SuZNVjcnBURcbWUE0sT9ycRcaPDNDVrRwn3n5z/aF6kl8Q1mXwQdTOF8bry0pTp3HUWlUglnQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5298
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=759
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120005
X-Proofpoint-GUID: WOyeL2WRKN2vSsXYMNHuJtUYLNxJAlEp
X-Proofpoint-ORIG-GUID: WOyeL2WRKN2vSsXYMNHuJtUYLNxJAlEp
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org


Maurizio,

> nr_attrs should start counting from zero, otherwise we will end up
> dereferencing an invalid memory address.

Applied to 6.4/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
