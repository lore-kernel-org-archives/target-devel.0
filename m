Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D50FC4332F
	for <target-devel@archiver.kernel.org>; Sat, 12 Nov 2022 21:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234946AbiKLV4O (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Sat, 12 Nov 2022 16:56:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234867AbiKLV4H (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Sat, 12 Nov 2022 16:56:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BB01FE
        for <target-devel@vger.kernel.org>; Sat, 12 Nov 2022 13:56:04 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ACLqEKu013555;
        Sat, 12 Nov 2022 21:56:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=sVX+Ja34LWZcbP41lgddGjBj0SzDWz7FBaD3v8NM+bI=;
 b=xskoZyl7nFAZhcgJkg6zkG9MKexgVgCtsqRzNCNk2wdDBYCZoTAcyj9zZiY8YeVFBKiI
 3agWsONDGSmYPLwxQGRelJ5Qkq5hAXx8BJyW2Ee65RX1LG10m2sH9sitjWpbmSULE/PN
 236YaiYIbkEdbN0+/IoO/+pv6DKHORnBt/B6rSkjkJdofbOd+lOhRfhHPqD1HZpujdeq
 w4wDfKF69ApuxKfO/vNhkxs3hVsthEzTogrXRVkZ43oHvo0hDySpYvXKxD6ipXa0TMg5
 3zkC2FPyH6hVSEurssjMOmpaobUUOXVIlppArTJDfrHynypzLofbHLmPyTEIuwOr1KgX 2Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ktjxdr12h-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Nov 2022 21:56:00 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ACI6hC1020847;
        Sat, 12 Nov 2022 21:47:01 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kt1x8vqms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Nov 2022 21:47:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=boJMZGIxCjMpYU20K9sOiP2yDhTEfjPKlXhIg6LdOJpsGsFoWPF+eQd3CpBjSBIcmzRV19E0CMMt9Ctb72cy2lNre/+bPf80ordzHBrktEnPO/+hGTHrbMuEIl5VJ+I+V7/hFNjMS6F4YzP2ymcZ2ntwvObgBm4RqcHmjHFkWQeMim/jYLbLmUB0zu/opFT00HNnQMwXGnzIbcR536SCUbTMoKTU4gF109ZpnhW/FmbXtZwyWi0zgmIoScfTHgj8X/uEJ2vnmC4vpP+i4pN3ZwJbQNKAwCrpso/7s0/WOon5spTntixvdHAODE3Uud6895MsZiB0KAsx6VNte7IaEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sVX+Ja34LWZcbP41lgddGjBj0SzDWz7FBaD3v8NM+bI=;
 b=UUNykvgR/b99B5UIhA+sxtHbbGV0NLywFKoHohz2QfYNZpIok9RYqgTskNE/gZrVqboNzs7IxkvetInYOkwChkPJznI2tfiYNfW97uVkbTy1dfkzCzsjLI8CHf9OxMCq+rXI2wIaHtWSAqVoonfPj6uGj6cc1u9qwIDbpivvPspI6arPuZQ951yuc/iFDFH5qSJKE3dkgedNUo8ZVRdjLdJOmnqvBpm7f/I4nfBGawIOG2gWyV9OmgnWNh1myCRaum7665sAWzvDlFJAhGq0K6x3d9ytIz7ANbPDwWa891idZhxWkfftwyu4xQ2tJpM1N4nSBJLZlIbGMHryDyrrNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sVX+Ja34LWZcbP41lgddGjBj0SzDWz7FBaD3v8NM+bI=;
 b=PUHAdF5fCj3kuRv2q4aIDwxGYNhqf1JtxRYdqa4ND/GOhPQv/2pL/e/Q65s8D+UEukPzANcWXdcAN6eg+sUqNgP+ZEI9ai2X4W4sdisqvk6Ch09NtLqYDQRnKIWMrkw7OGET4WVg8HfbM88OW61Q1hLErz2K0Tv/zcHC3Ioei34=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5216.namprd10.prod.outlook.com (2603:10b6:5:38e::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.16; Sat, 12 Nov 2022 21:47:00 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5813.016; Sat, 12 Nov 2022
 21:46:59 +0000
Message-ID: <2cf05339-bd4d-016a-0f94-d1f292cca97c@oracle.com>
Date:   Sat, 12 Nov 2022 15:46:56 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: tcm_loop and aborted TMRs
Content-Language: en-US
To:     Bodo Stroesser <bostroesser@gmail.com>,
        Maurizio Lombardi <mlombard@redhat.com>
Cc:     target-devel@vger.kernel.org
References: <CAFL455kjQeqvPqd1CUqs7f6xUjrrDqR1h7edizusAtj130HCPg@mail.gmail.com>
 <caad6a7a-c30c-a3ac-7932-f5a19c877ffc@oracle.com>
 <e07f0fa5-d59d-36f2-d99b-73e32af3282e@gmail.com>
From:   michael.christie@oracle.com
In-Reply-To: <e07f0fa5-d59d-36f2-d99b-73e32af3282e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0428.namprd03.prod.outlook.com
 (2603:10b6:610:10e::23) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5216:EE_
X-MS-Office365-Filtering-Correlation-Id: 976e0875-b10f-47c8-524b-08dac4f76c80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pFP2W+3EHG7Aa1lpXr+aj/WYKyaQFGJvWSTA9s7MTeWUSg9ojmSC2wjS2uriJAEbiJDQvkzeJTL9jFJIcVzX01YzOE+9PmdWl2lUrKdlM2lGN+mMBJ3ep+aoc+IOuv+eKQQ0XOIfDRZfhnGbNgeHDqaY4lOJdThQL5mNWCIJleYl/whLqYFxrjB+GNFnlo+kImxjcjOlEXfmnIGwJ++JMZzrAz0UiGCWfkJ8o9xI961cfF37pTgHYZ05SGWdNUBaEszh4ePJp4iPFn785iz8+A5ADWEmlnUPTzgzgShr+7uXH/rJVyFm6r8LWS4ouFfT1npgUFpPPkecdzrHTdlIxEw7SkK4cY8aRkzykRDBUZziCbsOcyHi/E2oTVHqLw8gVAvpHk+0jywMEZgXeOHlgO4I3qFODq5rptc4JVD2FgcDH3BpP6y27hw6p3GKy5BMhCwhm9xzHmxSWY7qZAcQYrBF7J1LeiKAPnZ+I+rr/n/ht4uq9VbrRrlbsGwU2Dky6ChGE9Wc4SQROVsdzI2mR8w7b8pP8le1fTxs5ZWfQJ0hqo9BY2w0v5nC1GFpl7bbYoCtNq71303sAAYN2kVl5F7fz6k/2rQfJPcMSV6sVbRdhHvS7yQFzACX6dZY7SePyhy+U06VtP17uqWeeFdUdmlIrlIsd0KdWqIWnEmHjY7vH42YafJW793DKfN80f6Pa8XiqOS48XDnd52jIxYHUnFLUWxOeGDOXDhZBj4d5D8LxOtB93+Kw49afz//GvlY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(346002)(39860400002)(396003)(136003)(451199015)(66899015)(31686004)(36756003)(86362001)(31696002)(38100700002)(2906002)(41300700001)(5660300002)(66556008)(66946007)(4326008)(8676002)(66476007)(6506007)(53546011)(316002)(8936002)(186003)(2616005)(110136005)(83380400001)(6486002)(26005)(9686003)(478600001)(6666004)(6512007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXJkeGRBTWorMU9OK1J5Mkc4SGdIQ0VyRnpQalF1NVcvUFhkSjVDT1RUNDJH?=
 =?utf-8?B?alFvSVZpaFBISVpubEFNMTN0SHZWRDd6MFdSN1QzajhOeUc5WDBlQUJKRllX?=
 =?utf-8?B?b1VKVVZPeTBuY1pXajhNY252aVVaWXFic1hCTm5pUnh3c3BtVWFpQUx3cEZT?=
 =?utf-8?B?d1FrV1hJUmdiYWY0SFdjaXp4R1cvT3VPSHlUWTV0cHhid2xDVE5MNjhhYnV2?=
 =?utf-8?B?WGxxU2JoREIwcEZUSUhQdFlaUHYvelBXWlYrVjJ5UDlMclp3SGFWWVZkMjdm?=
 =?utf-8?B?L05nbEZSZ2ppWWlDby9kTFQyTk12aHphTHFaS3E0a3dyMGtGcGRkWHNRd3FC?=
 =?utf-8?B?Qy9wTFMxS3NRNTVWUmVySEl1Q1FkMWZlVFJZeWRMaGRPMklDaHpybW5jVDBt?=
 =?utf-8?B?bGt6bGw0K0Nxb3F2TFY0ek1KMUZnektUMUtwMmFGKzlNeDlDd2xFSWxqK3hT?=
 =?utf-8?B?RXVTeVpNckRDT0h6NmFML25DUEM4MFZHc2J1QXJmZ2c3ZlZYUXlDRW5UVHJR?=
 =?utf-8?B?WStWWitaWjdSdGVKK1NPSmlpcVU5WW9aM2VyVTVNWEJaUXFIR3JSOWFoSXpZ?=
 =?utf-8?B?bW9HdXZndXRyalMyREdBTmlBNXM3TXVLbkFFaWJnLzZTeW8wK1V5ZDdCMVJS?=
 =?utf-8?B?cDhWcldxeEc3ak9MUUxVUG85NEFsbldHVkxoTEY1U3RsUG83QzhYSkJMeTlT?=
 =?utf-8?B?cmJVVzdFY05LeFB6eVVQRWlMNFdoNmY3dmNTSjc0azZCSXM2UStZOWpFNlJ0?=
 =?utf-8?B?bUhxSW5IQnVQWm56Q1JLTEc5NjNaN0VoOG4zR25GM0Y5L2p0TzVVbHRscXh2?=
 =?utf-8?B?MU1NeDZVQ0FVeTltNHRnT1o1RVV4UGMzNUZpeTUrT1gvZjloNWRtckJNTzBu?=
 =?utf-8?B?cGtNdGpGbkFSMkVjWnhVQjNLeFUwVU1WU0xGRXhjUUZ5bGViYmpweXJ6ejRL?=
 =?utf-8?B?UFExcDVDN3J5bnYyWXZVKyt5TFRaajIvQ2J3bVVZdHBBL2MrWmo5cW1rYlRw?=
 =?utf-8?B?OG53K2xpbGc1YTVDVlk4b0xLcW1qb2dBZG1yT1drQkxrdjdJWmtoVGxCb1dh?=
 =?utf-8?B?YU0rSURqV29Xd2M2UEZjb0hoQlZFUlFHSVU3TXFGV0VMRm5YOFNPV09hZTBB?=
 =?utf-8?B?bCtUeTNUMnUvQWxweTlMTi9UQndhSUEvckYyUUN4RW1DbE1FQzJ2R2ZDSXVK?=
 =?utf-8?B?MDNaTjNZaDFmOXduQWZpU2pmZVlEOXlJc0oyRkxRN3F0NndXYlhZanRreGJE?=
 =?utf-8?B?YXpYQkJiVm9jblhOYWczQkc1VWR5Q1FLNXlXUFdvWlErMU9PcldtYzEzbnoz?=
 =?utf-8?B?UTYrMHY2ekVHS25xWjY2V01adnByamdmV0ZzU0ZReXAzVG53eTVJWGg2VHRi?=
 =?utf-8?B?YlRjMllQUkVjZ3h0Sjk4NFFwaDNNVVBIVVU2OFcycWFRS3hlaFRMcHNPMXBI?=
 =?utf-8?B?RWRqUzJZR2NZVm04UjE3S3dGV1FpMk5od0E1VU94TXJYRS8vN3VKTC9abEFu?=
 =?utf-8?B?MWZyWFhIS2FLOVFpMy81S2g0d0MyNFNMVit0VVlOZHdycXJMc0ViMXRHdi9a?=
 =?utf-8?B?VHZzNUJwcStpYStQL3R6a2szUjJkTXBNNUgzNUtENHFXMitOM3dMNXJYaGZ2?=
 =?utf-8?B?ZHgveXBnd29IUWVCTkJQN01XNkFHdXluS1BRVUNvOHgySXk1Y213OHpxc0wv?=
 =?utf-8?B?ZjIwbXZwWlh1M005SGdPU0E0VVB4NldIYWZSWVplTWE0eHVPdTFya2hYWlB1?=
 =?utf-8?B?SGhtRFRvY2pYdjJjZGVEbE13S0Nxbks1OXgzYWd4cVNzOHYwSDNScG41Vndk?=
 =?utf-8?B?M2M1OEZna2ppM2ZITFVBdElNait4NUtnZExudWtQRlpBdTBUaDVjTXQ5SWEy?=
 =?utf-8?B?Z3dvYURmb3BBWFpob00xM3BvVGpqL1JIOGhtZGovWVluMUVpM0lRQVlLU0NY?=
 =?utf-8?B?T004b2JHNGQyZHUyYzJnMjlTYXkzUW0xSE9ObGErbDlnSXBiNVFCdVdhbXdy?=
 =?utf-8?B?cHo2dDFTSTRlQm1kZWRlVEVJWksvVGRjWkI5OFhIaFZzOFlrck5qUUxWWU1S?=
 =?utf-8?B?SlplZnVhSHFrcG8vUHc1NTNLTXE5bGY1WFFiYmE2ZUVVUnMrSnYwNms5cUJL?=
 =?utf-8?B?Y0VCcDVIZ0M4R20vb0o1K1NNNDZucCsvQkdPYWxqN1VMWEdYa3lCZHVONGdp?=
 =?utf-8?B?RlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: nvBmQ/o9clJpU1mQAP45bz5XtPLzVTEljWc1ud5FfJZV68A4r5mVvjXUUN6uM3vkTvvoQpcNY9dWXhtVQBu3t8W5P5Mx0gFU/POeQnOB5uACG0xvo4DOGKcGbsRtnuKeNd5U/JFtb405fqunxor/6NcubkQnKzHfAAU0f/ex2NYNXXlCTAmGti72uJou8AP69hdBsTpLOQviGi9mYrd2rM/HfAwdLOyt4T+F4XujQ8MTObcIoxJwsGhFwItHCbLI7J7eJJJJXotKt0LzmZ0Cws0g61lrQb9NVQbvL5YAle8mAIt3UXxOJj+ME9W/+WKSlM9ve8FjPfNOFFyw/O4DwPkXHCpM/34PbscJAt9dO+iiUX9K4l9qv6qWDFLdHuCbBuLsDHSQYyaH4U24wiu/WZmSAfga50ewm1rfp/pDSJIUeevPuK5xnwebNuzg+WUZkjaEr8wGpMvZVIkJR4KpDy7jH0D0IPlXMZMJs7Wa+Y/xJz4hhG+hrCP5uwIgJFjEpf09QJ5jK5jUkP3FmlNe+AVusnw1mMzBk3NQmIpbB2r60bpJfkThXp8M4ByQpfGeI3+r61BXI/TjhVff+UHoU2gF1/6k9jNEIKlyR4DGSBy9JcZm/MnZu5gAgIvBXNjAhoX0I8gHVroxSsEfBppfKegknQL5BOTF/Hb901qRzxzrQLLlMVqF+rf4/ZxR/379M84skygqgp+kLF6WUBEzXBzN6qkbwWkHkMcApksWnqXj2InsT7IRJNFWz/08SenxM9Y+MPkIz5JFZNyy2i6Y/ZMLsPGzkdWY8VgoFnu033s+AVEcrwjBSPCi+TcVUSHb
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 976e0875-b10f-47c8-524b-08dac4f76c80
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2022 21:46:59.5941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xVzbuZ6A59GAbSSYkwOmz+sZhocnitt2+Eh4GAX0j8c9LERIrMRiJgX4STqkzMlYTSdOE/N+mDyFiGsNSoCSUS0H5DwccQ6Sng++iW1+uu4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5216
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-12_15,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211120158
X-Proofpoint-GUID: J3gAOb7TODZ0zifmseZ6m114vFhT7_EU
X-Proofpoint-ORIG-GUID: J3gAOb7TODZ0zifmseZ6m114vFhT7_EU
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 11/12/22 7:59 AM, Bodo Stroesser wrote:
> Hello Mike, Maurizio,
> 
> Even if we couldn't yet find a method to fix handling of aborted
> TMRs in the core or in all fabric drivers, I still think that keeping
> the parallel handling of TMRs would be fine.
> 
> Tcmu offers a TMR notification mechanism to make userspace aware
> of ABORT or RESET_LUN. So userspace can try to break cmd handling
> and thus speed up TMR response. If we serialize TMR handling, then
> the notifications are also serialized and thus lose some of their
> power.
> 
> But maybe I have a new (?) idea of how to fix handling of aborted
> TMRs in fabric drivers:
> 1) Modify core to not call target_put_sess_cmd, no matter whether
>    SCF_ACK_REF is set.
> 2) Modify fabric drivers to handle an aborted TMR just like a
>    normal TMR response. This means, e.g. qla2xxx would send a
>    normal response for the Abort. This exactly is what happens
>    when serializing TMRs, because in that case despite of the
>    RESET_LUN the core always calls queue_tm_rsp callback instead
>    of aborted_task callback.
> 
> So to initiators we would show the 'old' behavior, while internally
> keeping the parallel processing of TMRs.
> 
> If fabric driver maintainers don't like that approach, they can
> change their drivers to correctly kill aborted TMRs.
> 
> What do you think?
> 

I'm fine with doing it in parallel. However, the issue is we have real
users hitting it now and we have to fix all the drivers because it's a
regression. So if your idea is going take a while then we should revert 
now and then do your idea whenever it's ready.
