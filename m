Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C302C433FE
	for <target-devel@archiver.kernel.org>; Mon, 21 Nov 2022 20:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbiKUUCo (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 15:02:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKUUCm (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 15:02:42 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5962A65C0
        for <target-devel@vger.kernel.org>; Mon, 21 Nov 2022 12:02:39 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALJaOCC027078;
        Mon, 21 Nov 2022 20:02:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=CUzyh74X5k+eJe7OVlYVqn17x6ehRePNnDA8efYRihk=;
 b=nu8edAznwDFYTnsxajWpSzEDxidEp+yjPUhyN8gF62yoyYol9/3pZMD6A8Mu3u0kI1Sr
 dK5wR8XCSNAgFGkYTe1NknEgTsorp+x8BiERXxbYZHYdEZ5JkZwYzh6rcedhRxgf9QyD
 1k28gzzUTDmvuyCAZOXWTaT7TdBfX3EtAU8xq6mA2VREDN1bCjBy1ShKmevQXRiSgOCD
 9Yn3pzjYiiaDpoJ6mVLNbo/Ix8rlNx/VssNnLvTAcR4cM9U1C4hOW8QhqTGsFXOqQg01
 GOZaDc9vfvM+db25PizfqIk1ZnZWYFQ+MTHVRgGy6NU+D1bWwCCpkhFUXxwx6vK8KwHt Ow== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0afr1btu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 20:02:36 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ALJpgUx002203;
        Mon, 21 Nov 2022 20:02:35 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkb12bf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 20:02:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mhh2xjkiUjpHhwR9EW1J86S+295KJ52ZE1CRAdj1qKtyG6BhlhbsX2KmZrPhA+t+98U2gPLD4mvmznLeVREph/EztdwyjHcjpB0g7FiyPJOs2PM8L9BktRi3KGYcDlUIhnlLFE2pCeYqU1rvLPC4yLyAoVYjbeWFHb2dHYTBOceU9SFXLJK0oyTECRgzMWdUqbk7VWHOjHAodnfx3kVkzeB6Ucz09LiXCf74/Zl1NutumdJcCmeVyEviG+YwNK6JxJcmaviSWsWcJffCNuzQ7mVPaBH5rSXeUGdd0LqxjBYGnULDGvcwqDqewGOpPdBMG6YOdfY+Tf/m2qih2KgYog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CUzyh74X5k+eJe7OVlYVqn17x6ehRePNnDA8efYRihk=;
 b=XIjCHxoQn3PghLQlgytewX9RI1RFlT/7Opx7xt6QMiPmMfiji3iTPn54pp3z6sy9RtHIxonoX1W38bps85OVyZiti9FlkxJ9oHg/3MIG/DsBQAY9dZw4nwdhImZzMLTagi4cJanxzHTwvoHMYQyeeXdusbv/Jqeh7JR5R0tyJzlUtuEUc/uiTObRmjJtRxF37voPNtIR6G0P/n9LAY7Tjj1TpKX3OrbHJ05pm3NxR5sUzYm/8jJi/99O5daW/8tWe03jMvQE3yrB2BOC332RUrbT5SHbTLATlUhsHS0cEadwNGeyTwU80scy2so0HDQJ1E08pHX8dIoe9et43JAETA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CUzyh74X5k+eJe7OVlYVqn17x6ehRePNnDA8efYRihk=;
 b=Y+OiCtP4kI7dh53wg1vzkhVfkJx/Zr7lvec3bAjMQGWpLGlL9TLaEn2G3hScYaWyFJePyrZujbb/N2POkXMu6Mg0Ps6354RUotNXti2x4/yQzoCl2SFj+x+MeZof1m77mnzpTj+vSZmfio49gwA9wTbGWKauJApRF+CZrmRRaKA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5230.namprd10.prod.outlook.com (2603:10b6:5:38e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Mon, 21 Nov 2022 20:02:34 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 20:02:33 +0000
Message-ID: <7169fd19-dfd6-d8a6-be71-e92bb6086390@oracle.com>
Date:   Mon, 21 Nov 2022 14:02:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] target: iscsi: fix hard lockup when executing a
 compare-and-write command
Content-Language: en-US
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org, linux@yadro.com
References: <20221121092703.316489-1-mlombard@redhat.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221121092703.316489-1-mlombard@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0329.namprd03.prod.outlook.com
 (2603:10b6:610:118::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5230:EE_
X-MS-Office365-Filtering-Correlation-Id: 94042f27-177b-4fde-1abf-08dacbfb5445
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dvkwM1ATDXZM2ZjCCINVYOg57d5UZ7LmVM1v1AWmOX1pFZMHvW7Ll6iXE56mvYnK7x/dY3FENAjhurjfq2Gw2MYNWfdGAwJU8HsGZANty2p3J4BcSurD+tWKNtXSEHKg6KSYAt9+Cy0gTjLOn6m/6UVRye8IyoU3O0DUbSPGLQluX2bMmPelH6U7i+qnaWrOKkyQ3VchofSZ2aYI+7Mh6acN+7yrQ+ZC7aA+TFURkRI8moK09ST8wsenFWrikbRPMey3N5Fy6TyvND7nzuCYCTuwOF0IRpFNrF/SU3I5Iiwn6mcrcgHZYVthMBXkwfbYVO6bnaf5pgutJq1PlYoy7VQmi//LhiQcO35mB1uT9BXKF1XaF20MlXRZJCm3Qf6gLXdBDOR15KJhwq0F73GYiyA9LLFbzhYKkMLji/BErvtxbfoSAIDHjq3UxpyoXlLLLzbR3ba50TXTwXYwo39J3BC9hA8VYzi7N0U2hbPlMbzwaadPLqvXDCnTc4ocH8kfLyXpP+DKq7IzRM0HpfprqysLS4HywoAZuD/biFPaeTC1/cJZuOT7hX6RE7j3a0PkT+eqLfasgTV0R9LHllSaYWE3IiXpEibwfc7RVoh/99SynCgyarkAOeGaG7YzsFzTeOyxRH1v7F/1JwRbcvi/lBkEXKkrSJO/ZTvhF2GKgr89G8IxCATg0sfRd7hIjq38VihR//f5ghYkbmI6ek2BuZaJGvi9WRtZexOy2zi+Q2k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(39860400002)(346002)(396003)(366004)(451199015)(53546011)(26005)(478600001)(6486002)(66946007)(8676002)(6506007)(4326008)(6636002)(66556008)(41300700001)(66476007)(38100700002)(6512007)(316002)(2616005)(186003)(83380400001)(8936002)(2906002)(5660300002)(31696002)(86362001)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SmExMXRGSnBxTlFsU1JIVnNGUWtacTN6dEJidGZWZEtXbUxyRE9YRTgrUDkx?=
 =?utf-8?B?Y2VnSHNNcGYzdWROV1R4YVArSHVPdThOb0VDd0FmU0FYL0xwUGdQb3NyUGw5?=
 =?utf-8?B?bmY5bHR6ZkE1eGlYRGIvMHZHUnhxNkQ4NDNRcnNraTY0bUpnN0tXZkJDc1lH?=
 =?utf-8?B?d0pIMDhsaWdqR0hWeC9SUGNWQ3d4ODJsUkkvRmtPcVB1YXRlZTRYbUVtb3o3?=
 =?utf-8?B?aEdZTGs1QlliOHVLVmZ3eUI3ZXJZUFgwZ0Z3WU1maEpDU29LSzJGRXZOcnBK?=
 =?utf-8?B?ZkhRbkVGa29UK2FHenlLQlJLblQxZTRlNkhGN2dyQ0dWZmNzSTJtU21jM0hO?=
 =?utf-8?B?dWhWREp3dTdRaDQ3bjJ1bnNwRzhmSDFDRFZ1cVU0UmhhbGZQd0c3MWJTMW14?=
 =?utf-8?B?UlBQc3FXKzdnZjRuSlB5MU5jOXFYNENUVjk0aUVJUEdTejArOW50OUNXbTFj?=
 =?utf-8?B?alc1Uk1sOEpqMEhDK2xOT0dYaXIwUEFTU3lKTmI0cG5GbFpCc1lwQ0VQVzVT?=
 =?utf-8?B?SXJzTzUxTHhZUVMwRXArYVJQQ2prTUdUYm5LZGt5a29LY1JVdC9pWFVGL0hn?=
 =?utf-8?B?TjZUYkFEYnF2VU5zM2YwdWxDT1EvM0ViemNXU0h1K0s3ZWNKbDByeGFqMVdR?=
 =?utf-8?B?d212UldwZzBDakluNjl0QXcwSVFUTlArNFF4Y1RGeUZ4a2Jzc0xPRGE0K1F3?=
 =?utf-8?B?MkN1WDF3Wkx6V08yNVRJaVI4andrc3Z3eFg2TzFGK05PL3NuS0tabEFTazhm?=
 =?utf-8?B?dXFhUElVcXAwNlNNVjNKcy9pR0pNZENJU0JKRmJYMjBRTUdJQnM4LzFNcW1S?=
 =?utf-8?B?SzlINkUrTTQrQXErRHVQOXhjaEI3Z1VIcDZnNVFXRjdXOVhQVXh6ZzhpRGt6?=
 =?utf-8?B?c0twRlBwWVNGRTdkN0k4bWJjdWhVUWdOSHBOWmxxN0l5RXAwR1dzbFZWUmQz?=
 =?utf-8?B?SThvUHpQVTR1SkZDamY1ZFNWMy93NHE2MzcrRTF3cUNDVDZpblNJNmZ3UVdL?=
 =?utf-8?B?SGplOEQ5ZEZoYW0vZDlhdXBDVTl5RzRtRWtuRHVCallYbmUxaGlselV5dWQv?=
 =?utf-8?B?R29iZ1BHU3R0MG84NUliTlZuUy9ncGpXb0JVVXdhR3htRXdBeThTQ2QwSWVr?=
 =?utf-8?B?bWlhYkFkekVMeVNJUU9GSjlYRmowQjJrOUx6T1Q1K0J5RS8vczQzWWcralNq?=
 =?utf-8?B?QnBWQmJEMU9xWUlRRnhOSVkveVZ6Q0dxdk9oVkpuY3d0UFozTjBRUFk3MFYz?=
 =?utf-8?B?MjZaNmFLdnBCMVgyMGVRMmpmZjlVdFczS2JWRXlCS25TeFh5MnJ1L1FXNGdv?=
 =?utf-8?B?QTJ6QjZtNU02YVpKQlJDY2ZmYWZOcmdpYUtXekR4K0FhUzVJUXNsc29ESjZy?=
 =?utf-8?B?Y0hlWmFzcHNJOE9hUkFVZkRmR1A4bjFWVjY2anArOGgrUDFVK0R1YkdrWGd3?=
 =?utf-8?B?bjJaTXBQR1NJT3FOVFE1amRhSE82MUxScnNrS2VQcStUYzhaaWdNVW5vU1Bm?=
 =?utf-8?B?MWp5WG9LMjdGZFdyb2JRMEJ1MVdRUVl1TXZBTXlLeTZiY213SUsxeTVHN2g3?=
 =?utf-8?B?bzFCNGxqdmlaeTU4Q3NOcUkveWVPZmpDdDdZZGt1azNZQ1lmdmJxWEFPdGd2?=
 =?utf-8?B?dmhzWkJteGswZVFab0RYOFpTaHBiTTh6YlVUbmZ5KzJGamdGU3pQS3RNbWJv?=
 =?utf-8?B?SmgxQk5nZmtjL2F3L1JtZVFOSEkyL2VPUWdDT2x0clVVL0JrdFVMQ1RmQlcr?=
 =?utf-8?B?cXYvdmxqQTNXbkIzY0RyREtwdzlSSExnQmJJS1ZuVEE1a2ZGcGtxWURBQjdK?=
 =?utf-8?B?OW82akllcThiODdTNSt0SVZGT09ydHhsWVhkM2JaZlFhd0tIRkdrNFdhZWJ2?=
 =?utf-8?B?dzFLbEpWNnpDVlVlZ1IzTDZnek5MNjd6N1Z0UkpZQkpUaUVQSmxtS3B6K2FR?=
 =?utf-8?B?UVZmSkRHNXNJd1VsbGozdmkxTTJFcFEyY1h1VGRtN1NhSHcySFA0RnBod1NS?=
 =?utf-8?B?d1hjenNmREJRWkNjSU9lV0t1dHFPbkhhaGFTUmh1TVFvQldvQVg1dExhaXJZ?=
 =?utf-8?B?WGJpMmlNZEo4bEk3VnN4dWxWMDRHL1AwY2lGSkRoanRjVEh5NFB5OUJuTGdi?=
 =?utf-8?B?QWt4NC95SVhDUjVEb2Rxa3BCYUhYbDdtcVRTdXZQNnN0Nyt5eFQ3Ukx2c3RC?=
 =?utf-8?B?amc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: RtMqE1GRNuAy+40urMRdObAxsg8vXIygiMb0Db994pmYJvO1YXrjs47fZaT/57VJdY1I2FNeBXdgOv7IXZviELPZ0SgBv4gTm55yA6CLG706+2P068kkmQVX0OmpuRi745wtktpq68QKPdxdrKatUDspTDVT+UgakwaN44KjhMceimx5op7dubXBVuUt6oUT8Ebp4EqlXasupv5ZLW7zbCGmgl3EDaT5NgTzNZx1wykKQBjZG075EIxC5LFc6K11aUMcV1fkJ4EWQ4DcDofC0LFiYDR+uaa6gsVuyJJs7itKolXEOjlZLSLh65tzFkh3fprfCID3E0UaoSkgbCG+rPbFXnO/WDXjYiztsVsfUwk8gRjvBFGg10W8MQLPeDFTV5YrCdHulrxq2xru1lXQpKE+icCBOaW6sDqb9vcHDHBArxUJvrqFa11qVuyyqSWysH0Kw9vFqUVDh7qjnnAvne/F9+C6to7vZS/jiEKiWx/Ak0ckQcTUIGNtYbz8W6jbrMwB4SxKiEwonzJlBupU3yQunEdpCInY0t9/yM3gLPR9jD7PERMV+/Mt12/pnOhhzPGUJpik8afg1ZitefWZ6mhwa0jJCzMYNLOyeQrF4iDb0a2ZPEVDB/l/gWQVPa4k2gjA7TUxhGJSupBtkYnkOA8K3i5AC0QAGNSSkNCv99Wf+Ll41JycWKIarwZxtApiQ/nMXnH2lZfMoWIGv8/gzHwJ7LG3yCGl0HOA6OtwejnIULIm2ojqUoQYjDlmbt25+5gZyTbPq16LuiwVKYpGc7tUzNC3o/cvowwt4FwiUe7OrbRYQDSazH24i35eMoFm
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94042f27-177b-4fde-1abf-08dacbfb5445
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 20:02:33.9109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1yCSRIbfg47ZQE/X3Ok0q6116Xwf5iu3idgYZUVKDeOUJjVHSgg3Tq5QfJ057F+md+oclXIx4/p/C2QNy5izOscQxYPeYYsu4TtMielrxv0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5230
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_16,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210151
X-Proofpoint-GUID: vEFPmuj4ouLCJarlnNoqO3SbLBdDyT-A
X-Proofpoint-ORIG-GUID: vEFPmuj4ouLCJarlnNoqO3SbLBdDyT-A
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 11/21/22 3:27 AM, Maurizio Lombardi wrote:
> While handling an I/O completion for the compare portion of a
> COMPARE_AND_WRITE command, it may happen that the
> compare_and_write_callback function submits new bio structs
> while still in softirq context.
> 
> low level drivers like md raid5 do not expect their make_request
> call to be used in softirq context, they call into schedule() and
> create a deadlocked system.
> 
>  __schedule at ffffffff873a0807
>  schedule at ffffffff873a0cc5
>  raid5_get_active_stripe at ffffffffc0875744 [raid456]
>  raid5_make_request at ffffffffc0875a50 [raid456]
>  md_handle_request at ffffffff8713b9f9
>  md_make_request at ffffffff8713bacb
>  generic_make_request at ffffffff86e6f14b
>  submit_bio at ffffffff86e6f27c
>  iblock_submit_bios at ffffffffc0b4e4dc [target_core_iblock]
>  iblock_execute_rw at ffffffffc0b4f3ce [target_core_iblock]
>  __target_execute_cmd at ffffffffc1090079 [target_core_mod]
>  compare_and_write_callback at ffffffffc1093602 [target_core_mod]
>  target_cmd_interrupted at ffffffffc108d1ec [target_core_mod]
>  target_complete_cmd_with_sense at ffffffffc108d27c [target_core_mod]
>  iblock_complete_cmd at ffffffffc0b4e23a [target_core_iblock]
>  dm_io_dec_pending at ffffffffc00db29e [dm_mod]
>  clone_endio at ffffffffc00dbf07 [dm_mod]
>  raid5_align_endio at ffffffffc086d6c2 [raid456]
>  blk_update_request at ffffffff86e6d950
>  scsi_end_request at ffffffff87063d48
>  scsi_io_completion at ffffffff87063ee8
>  blk_complete_reqs at ffffffff86e77b05
>  __softirqentry_text_start at ffffffff876000d7
> 
> This problem appears to be an issue between target_cmd_interrupted()
> and compare_and_write_callback(). target_cmd_interrupted() calls the
> se_cmd's transport_complete_callback function pointer if the se_cmd
> is being stopped or aborted, and CMD_T_ABORTED was set on the se_cmd.
> 
> When calling compare_and_write_callback(), the success parameter
> was set to false. target_cmd_interrupted() seems to expect this
> means the callback will do cleanup that does not require a process
> context. But compare_and_write_callback() ignores the parameter if
> there was I/O done for the compare part of COMPARE_AND_WRITE.
> 
> Since there was data, the function continued on, passed the compare,
> and issued a write while ignoring the value of the success parameter.
> The submit of a bio for the write portion of the COMPARE_AND_WRITE
> then causes schedule to be unsafely called from the softirq context.
> 
> Fix the bug in compare_and_write_callback by jumping
> to the out label if success == "false",  after checking if
> we have been called by transport_generic_request_failure();
> The command is being aborted or stopped so there is no
> need to submit the write bio for the write part
> of the COMPARE_AND_WRITE command.
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/target/target_core_sbc.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index 1e3216de1e04..80d7a4419c4c 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -454,12 +454,22 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
>  	sense_reason_t ret = TCM_NO_SENSE;
>  	int i;
>  
> -	/*
> -	 * Handle early failure in transport_generic_request_failure(),
> -	 * which will not have taken ->caw_sem yet..
> -	 */
> -	if (!success && (!cmd->t_data_sg || !cmd->t_bidi_data_sg))
> -		return TCM_NO_SENSE;
> +	if (!success) {
> +		/*
> +		 * Handle early failure in transport_generic_request_failure(),
> +		 * which will not have taken ->caw_sem yet..
> +		 */
> +		if (!cmd->t_data_sg || !cmd->t_bidi_data_sg)
> +			return TCM_NO_SENSE;
> +
> +		/*
> +		 * The command has been stopped or aborted so
> +		 * we don't have to perform the write operation.
> +		 */
> +		WARN_ON(!(cmd->transport_state &
> +			(CMD_T_ABORTED | CMD_T_STOP)));
> +		goto out;
> +	}

Instead of having the "bool success" arg then the callback figuring out the
context/state it's being called from, would it be nicer to have the caller
tell us. Change the bool to a:

enum target_callback_state {
	TARGET_CALLBACK_STATE_SUCCESS,
	TARGET_CALLBACK_STATE_ABORTED,
	TARGET_CALLBACK_STATE_FAILED,
};

?
