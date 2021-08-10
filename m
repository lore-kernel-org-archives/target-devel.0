Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E819FC4338F
	for <target-devel@archiver.kernel.org>; Tue, 10 Aug 2021 05:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C861160EC0
	for <target-devel@archiver.kernel.org>; Tue, 10 Aug 2021 05:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236140AbhHJFVS (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 10 Aug 2021 01:21:18 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:14976 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237049AbhHJFVR (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 10 Aug 2021 01:21:17 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A5Af4E011970;
        Tue, 10 Aug 2021 05:20:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=6MEkfqBB5T3G6FD7qGw4RUHAmqpVQV9j/EdMLhVoOHY=;
 b=MLMW46Da7ezLdHJRykNtdN28DMLu78hf+hbqB4IW8kBXcQxx3HTl/GHxJpvfNYadHs4F
 NoZoz10yyNhqjVh0Ir3KxMb7d5vB5Ynjbt2QXI98+5DjbAhXLVZhr8cieFCPFfVZY152
 QsovFKoMWb4LjUDWwek/uvGX9Pneba6gVuqHnLYL1OX4g97G3BNFTSN9qzIDr2MdVe+o
 RssqQefOfgGuLSDDpBgCPBxSUJwHvfGUZdOc65EWdvq/qohbuozOvbSwZskywp1lOSaR
 rjTryLjTHGVVAy6VHYolp1LpzKX4RB6hn3UNwb0C/BQr4IgmJvCYjJhVXyyFsywja2nR 2w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=6MEkfqBB5T3G6FD7qGw4RUHAmqpVQV9j/EdMLhVoOHY=;
 b=rXnboFt9KZEjaJiULNKUeUEE9AiwXuvcHyPgpNRB/cYVDMJzgyqk5aoGjW05bYsximFe
 2mBuqeL3U5LT9Z/lCGKW9v45nIOHg7mOvTDQ4KvkKBc2597rNN/qE+oQ276NnZuIcgwO
 GMi5HZ2zhinh9XrOUyXyw+pHjNFR7gJBPEzXS0mJrz7kef1BLRiOq6sz61o5qvoLVD04
 uH84SaHwaQoOMB9WKaL5cacBr6E8b3W71zKKjOvYR0tgpT58y1yXheBc5yqfxFP1oWHv
 qqdVu+Nlwq4+ldZW1j/Z0UKBmYRstzPttStQtQiACrUrzx5+uKN+gU7MBDbpQVjQJspb nQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ab17dt9s3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 05:20:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A5AS6v192278;
        Tue, 10 Aug 2021 05:20:52 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by aserp3030.oracle.com with ESMTP id 3aa8qsfewt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 05:20:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bJUpsCOlAD6uGKJXkR89JgL1+kem/U9wqtI/Rp6F9kg/EJCX08Km5hzCU+X0uI8pBpq5doIzD1s/WuT4MH2wMSIDOGrsPtSSS/gP5PxbWubGqaFX3Db8EjqEaKNr5AKUZguE6KXkTGEjD9ZqAZui9VnIeLp39cgvZpoCwSCAb0St/v5fRYd5QcItIjRaQrDZJQRF+NZW+1chDTkWTNYezB45R6rHKOx19dWQYZHCcKJz1quoQu7nf/N2LSkRYNTrIhgw+JASbUBigDqOe5rhca0O9IjzzeaiFC503UedmvvL1Gw25nA05jTId+zOLc9vuIVMhHzZIpb1DTCwpYVUAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6MEkfqBB5T3G6FD7qGw4RUHAmqpVQV9j/EdMLhVoOHY=;
 b=O/KhK7Tlvi7SDxnPPiJKLFO91zpz1ncYiAOQ/VNNgPx9s1+YEovKknBF96A3TjguKNjhs+VCeIhQ5F6RqXHNvU1i+WBFvQHUWlv9Iwt8LHH+eYbCZhNtCEZafogeCj92AtKmVkgJmoy9GNEPJfRrrX102TuG7R2Ds6iILz8hKycjiNXOxXJIu/iQiU/aG1A4igRhD4C/bJkk4Mx7JmfiP38deOI/XMcMSDJsWy+P7UASKPSL7YG0yHzrRD2hI7SC2hN8XgRRa4xQn8pGzWJw2Mnmjk2BIs5v4XFCBfvFxhjO8wBNsw0iaGp/kbpj1MQYky7lruD4rG5gEQf2bWIrdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6MEkfqBB5T3G6FD7qGw4RUHAmqpVQV9j/EdMLhVoOHY=;
 b=w7qWi3TYmxpMpJuZsxxnAn32ShKjlAoyhQElc4UuE/NxAEQpFOmOPUKJnyr8GP5E4edz1npqPiWIUrNNr/hSjXhZd1AotuVBEi7bk1iM5aIXhJBD2bkmtusQRFmgX60OB0nYt0QbVMiEMy8VAYL4aUqytdsqHXpzRkHb22adDtg=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4597.namprd10.prod.outlook.com (2603:10b6:510:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 10 Aug
 2021 05:20:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 05:20:51 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     David Disseldorp <ddiss@suse.de>, target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        michael.christie@oracle.com
Subject: Re: [PATCH 0/3] scsi: target: se_cmd cleanups and race fix
Date:   Tue, 10 Aug 2021 01:20:43 -0400
Message-Id: <162857263914.15955.13769529744088744487.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210728115353.2396-1-ddiss@suse.de>
References: <20210728115353.2396-1-ddiss@suse.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0601CA0001.namprd06.prod.outlook.com
 (2603:10b6:803:2f::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0601CA0001.namprd06.prod.outlook.com (2603:10b6:803:2f::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 10 Aug 2021 05:20:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5c88a0a-30bb-42f3-4069-08d95bbe9eb5
X-MS-TrafficTypeDiagnostic: PH0PR10MB4597:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45971721960DBA2B357D2C108EF79@PH0PR10MB4597.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DuOqy7Ld+MZGDiXksA81B3Nvx76E5rvw46JKWXnw1jxZ+iciz28lLj+02W/otOArlexSpI4B4mAvJwCsViy+VLKA8kSf63jDKoMpbFnw9VgKY6cVB5dQdJl2XwqrJNVeuACEOulZA7g30KuRo2yu0AHHFT7+7HETLvr3hP82R7dkSXqMqcFDZRcKp15BBpiKndKdNZk/ecF+zU28SnMTY90ALDs3F9pfHqeGWiPDvEC5VFGNvuV2ToEyNgletYrqmYqULrb5+HMBDbzwdIdI5UN0d8MroO3629hvySpyCox63ftRVHx2e3qvfrL2vcfR8PpNy/c7v1wjUIUItYSCXtfiZYmMSG/VhxhmzgHpnFUrfSQ1AScWOO1Yf+fZMGu+a46yg6HqEJNe2qOQURjaE9YctFI0SsJxYelbjFM+JFMaL58LFjiac7m0E5+QS+78pgMlnsYZDBULzfq1L2rNW5iCmqcsGFtyaRhGFyUdyLmejD6iGzCQTk95RuiHZysErdk3qcTkkNSbtIntHXIv3zZvBU0wiGrZjkEjHYyF7TiOWcrlf0xTwVjVwyl14rSVhUAtW51y3wRW8ChSWq3G4lxn+njE4q1zsa/A5ep4QHzZ+KNbWWDc1wN9BH0drawd74Uyu+B2SyePYZLhLpfZWc3ZOR+OtdsfZTgaBFbheSN0DBBR96D+CNVgP4fOkH+8E0z/0xuVteSyl/jYRBbhsmhMiWH7uo2Ui9vR5aOseXDH7Yx7dH/HVlTCcWAG36Kyb/DBGV+W1jw6vFlAel3b+yKjoO7gwlNKjG5TQ8OghIuaJSZhP6pD43iYHNmeUypW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(107886003)(2616005)(38350700002)(38100700002)(103116003)(316002)(966005)(508600001)(52116002)(7696005)(8936002)(6666004)(6486002)(8676002)(5660300002)(956004)(66556008)(26005)(66476007)(186003)(2906002)(86362001)(36756003)(4326008)(66946007)(4744005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3cvY2hyZmQxbCtGbEFuRkhTKzVKMnFmWTlTVWdhTWdXWXZ4SXpNYTRKWUV5?=
 =?utf-8?B?ckhKSzU5SHFYenA2UStjdDB5S3pjc3MvZzdaM0Y2cC9Ebm0vYVNBUXNQdHFZ?=
 =?utf-8?B?OVA1eEJaMHo5WS9wZlFmZ3FFZU8xVlV3TU1VbHRXZUZ2cnJrS1NhOUNOLzJl?=
 =?utf-8?B?a1lNb2JQY1hwb3JqeTBrck40cUJTNFQ3aWd1c3dHWDgvUWZZclcwdW1VdFNX?=
 =?utf-8?B?cyt5M0JlY0FEV1V3czFYaTMwSzdlTDVhZ3dMRHRyS0VZa1R5NWhtV080c1hP?=
 =?utf-8?B?K3lyTkovOVVFT2ZwS0RxTkpoZzhCSDB2QWVidHJCNC80bjBoN0VYZDduRUd4?=
 =?utf-8?B?NG9CMGRPanZZMVlLb0piNVJkVzFVVFkrVC9UY0R2eVhSZCtxMU42N1FnRnhi?=
 =?utf-8?B?V0RFbUVzcWlzazhUN0xtR3ZpUFhOa255MmlFUkNGbEt4b3JsZkQ3QU1mdnVK?=
 =?utf-8?B?TjJ4MFNtNWpUc0lHa2t5b21iQmZHTjEyVXcwR0RVUjVwN0FzRkp4UXVsMzBG?=
 =?utf-8?B?OVNwcmdJWnRYMmR3ZDVxdE42VzloNHZZUCsxUmtjak5ZRmdqQ0hyVEVrNStG?=
 =?utf-8?B?YVhDRmFpMk9PYUtNNXFSajJ5b3RjTkw3cmpvSjZxRHAyemJnN05HQ0xiK1NL?=
 =?utf-8?B?QnF1U2lHL0E4VG1ZS2ZQSFVsNU9PUzF4VTNYMG56KzE5MWRKbEpXVXZBTkVp?=
 =?utf-8?B?NXJHYzJLRFJiMFVpNm12czNxb1U4eHlZQ3pxa1pHUkxQWWQ5YTAvemcvNFhm?=
 =?utf-8?B?c3czcm5yNEp6aHlKWnYwOEdQb2VHN3dMS0E2dmpyUEZOeVc3d0t6aGtWSCtm?=
 =?utf-8?B?NnBFNzN1emk4aHVQR2ZjS3NtaEZEeTI0N0hjdkFWRDNMS3luMThJL1Z3Q0tl?=
 =?utf-8?B?N1FkbWVnRnZTZ2MzZ2E0VStlZ0tBVG01N2U4WnBPQ1V3TEtNKzM4QmlHRWls?=
 =?utf-8?B?Y3BNZDk5K050YTQwRkoxSDJyUlovSnhUck9TdEF1SXV2b1ZEUFJKZmV2ZlQx?=
 =?utf-8?B?c0tZRFMxNjdYb1M5SHJHSjJyY0taeEF2aHJZMXYrWFh4QkQ2R2FEY1B4TXo1?=
 =?utf-8?B?dm14cmQ5b1lpbGZrZlJDQ21ESlZuU2NlbXZDNXNqcTUzcUI3VCsrWGJlcGVq?=
 =?utf-8?B?N1d1aUxtNG44MnRvMzNTWnkxTG1pbGFyVHZxeDFNZ0NpWFRxb2tteEpmekdD?=
 =?utf-8?B?M3U1MnJGaEoyMFE1b3hmNE02amY1QTJKNFAzczBXSldQTTlubjBzbC9FQXRz?=
 =?utf-8?B?enpXRk9SQXRBQVc1UU56dDFMOVV5a21yanVtSUNpN3RaOU9aN2R6TFo3OFUv?=
 =?utf-8?B?TnJLVWM5cnlKUkFPZStDU1JqNHJUZVB4UDZRUG1BQnlPM3ZKMVhSVkY2NmZF?=
 =?utf-8?B?UVhKZFNmNFpicVFxckgzNGM0NURmRDRDTzI5andqSDhoTFFKV1JSM0o3QkY0?=
 =?utf-8?B?empKb3BoZmZDZUQ1MEhSMXJWSnZFQng2MU9sdWlRTk1LMERyUjFuVVUwT3pH?=
 =?utf-8?B?QnNJbTlQSGdZK1gyOXZVMThhZnNlV2grNWRFSXFSR2tjRDM2NzJJWWJYSHRY?=
 =?utf-8?B?UEJ6YitibGVPR3I4UUtvUC9VWGJZM2tqT1NjNTBMN2sxSFhlY1cranJIS0pB?=
 =?utf-8?B?RUhLd1RuT25ub1llb3NmUHNjNDJLY2tNSVFqUGY4ZWFCeWxSTHphU3hhcy9B?=
 =?utf-8?B?STlPTzY1eWNpTU9pcWlISTdZYURxeVFweFc5OFZKOUovQmlsdDkvZ2RUOGdr?=
 =?utf-8?Q?svTkx/pk3STHCTsJKYYhtlwD55LQrQ+Xd8GvfEK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5c88a0a-30bb-42f3-4069-08d95bbe9eb5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 05:20:51.6388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m+lt4ImQmWhX5hg7QiLY0ijli0RjUlqsbsYe84LtH2bXVlUsTR4cbeSxC5FQ8VglCrKWW7EU8mQH6Bgjq+XgXdoiplqZ+iX+she0/pCvfL4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4597
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108100033
X-Proofpoint-GUID: gX4QiO1Ya3z6Hs2_5-JQWhNDIQ3Aa_ul
X-Proofpoint-ORIG-GUID: gX4QiO1Ya3z6Hs2_5-JQWhNDIQ3Aa_ul
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Wed, 28 Jul 2021 13:53:51 +0200, David Disseldorp wrote:

> While looking into XCOPY sense propagation issues (see Sergey's
> patchset), I came across some se_cmd members which are unneeded. This
> series also carries a fix for a theoretical lun_tg_pt_gp race condition.
> 
> Cheers, David
> 
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/3] scsi: target: avoid using lun_tg_pt_gp after unlock
      https://git.kernel.org/mkp/scsi/c/7e457e5efc28
[2/3] scsi: target: sbp: drop incorrect asc/ascq usage
      https://git.kernel.org/mkp/scsi/c/35410f862426
[3/3] scsi: target: drop unnecessary se_cmd asc/ascq members
      https://git.kernel.org/mkp/scsi/c/40fd8845c025

-- 
Martin K. Petersen	Oracle Linux Engineering
