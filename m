Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C2113FE7
	for <target-devel@vger.kernel.org>; Tue,  5 Mar 2024 16:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709657782; cv=fail; b=P4VlcksBCOrQaBi48RmWGPRGufutXE1sQgBh2HGFhYYHr8Y5VPoaz+OoPINx0QuNlUR0BloTcf+jd70j8qXL/b865BcLsvCDL3S/k4saPn2VD8gNs8kHgMob1ilLq6TaGSfE00ykwjxamh6BWYdnCxNO/5/E1XmtHpBdkUQq3Ck=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709657782; c=relaxed/simple;
	bh=BsVcT/BZr0MxIEpj1d2gQJMcVuQ9ZaVzMLfA4CeRa6Y=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jnwt983s3XvWRvgFrAGMotaBY3drR5I2UOtQUaVTBHJcUKeTCx1Y+6gqaxIvyaz77liawl+J5//5mZGqBEbdhcLvEEIGvUNm5D56VN6nXrRxeonI1fQxo8slQom5HNdYLlfJPS8dSkCX+nxVdeblRwOkWAM78HvBp28OQ1SbfvU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eG2Gt+1r; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AZ5OjAzP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eG2Gt+1r";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AZ5OjAzP"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 425Fx2kg029801;
	Tue, 5 Mar 2024 16:56:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=bYZHWrNw9YN7kHBtZCr5IheSbu0x+O9MoA097Vo26fg=;
 b=eG2Gt+1rGEDJzJkPRxLtnggjy9PhpBtI+4ohD+eEhqZ+enDRyWId82b92w4JIuUOv/eW
 JHAB6UmZu+ZZi6GTZ4ctrxIK+A6zhoSwbHfRiJfmTvrGnFUFU+3+7H92Oy9wAAr85dXC
 X3wi3Q5kBIf0zEdw28X4jWK4EpFjQqhCqOC84n+PZ+RX6krkAuHUcKAaqwLDY+6aMt5v
 MXpb57nqzsYEko7CBgaVWXkb4fO2AYEJYqC3XdYWNGVjVRauQOQeBc6VbqEqstMIcjO6
 fLPjgeVyWUHVR4dmMSYivH6w9/u9c9OgXWHKU1CiiZaERWUB5TDxzRAS8MiEdsAqeRZv Vw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wktw46pdr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Mar 2024 16:56:04 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 425FrisO015937;
	Tue, 5 Mar 2024 16:56:03 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wktj85cqj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Mar 2024 16:56:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YUuhbI/kxqmDGFSWLgiapACEMca3MQ/g9R32/WJNrHHd0hVw29CnF4oO4TrLLEuDvg3rMKwbGSC+VkV17kE9kneuiQAyiiVmIREHlluxw8YFOzDZvhyC+GnFCVoZNmkHlsDBbPVQQNsuoIzkqye0hwZ4OQEUpbYTBom2eyN0qR782657/iqlUL7HK3atMaCG0xRruMlEncHVY44BP6OzknLRCvXY+vc6CH2E6+sYS/FW3Udp3W7SN3DDI+8bXpdPeyfiE462QdMioT0vMIaJiuXgxlYatLJdd0lykrCEDsIJc2QJav7jEbWOG2f5chHSND9gul+T5rkjo1/CfaDo4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bYZHWrNw9YN7kHBtZCr5IheSbu0x+O9MoA097Vo26fg=;
 b=XfevtVpfBd/sHSbMhdSQgtzpNI8TSrx92NHOeolEsY85DVtjI05/exSjZ+xf1OrrAOTQrSv1WGTDCZi3djtKMa0zs4cABwqcxdAWo1cAyVZk8PVci0WCPVk7GMz2e78XNZZ1e38FDgan/NWdkZjeqtDXbDV/c4F0dv5KDmdEVt3OBjtFiKWRf5920ya6bbvq/7xWWmvqsSjahS2K001lhHBGjZG8tNOqnQOEZWwJYlCuLqbkDfJzoa6eC2vyjYb3rvCmJhL7AQqNf6GDQMUvsT/8e93up12rJyqDL66BIQKJegaKY4lIlMSkHsgl902MssFT8pGdnpT2ao7p4Vm+sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bYZHWrNw9YN7kHBtZCr5IheSbu0x+O9MoA097Vo26fg=;
 b=AZ5OjAzP6YLPy+BLycMWUsXZY51rFW5u78JhkCEmd+5FAsD7TwE4ak/p+VFg+Y3qQCE4QkL5taJ3MTeLM/itBjmVwaHW0+hGJYw8StbpAIXcLredAX2wvHRr+o5AvUQ7E+rUR/6iBnCQR62WGj0L+WA/X/WQdp/kSIL/gAaqVIk=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA1PR10MB6518.namprd10.prod.outlook.com (2603:10b6:806:2b4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.40; Tue, 5 Mar
 2024 16:56:01 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::24d4:b0ab:24a4:d5a3]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::24d4:b0ab:24a4:d5a3%4]) with mapi id 15.20.7339.035; Tue, 5 Mar 2024
 16:56:01 +0000
Message-ID: <c395b6d7-afc0-4260-bce6-f25d2b7171b9@oracle.com>
Date: Tue, 5 Mar 2024 10:55:59 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: Unable to recover from DataOut timeout while in ERL=0
To: Holger Amberg <ha@ltx.cc>, target-devel@vger.kernel.org
References: <EA1BF689-4BEB-487B-AB99-D4D2275D0F0E@ltx.cc>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <EA1BF689-4BEB-487B-AB99-D4D2275D0F0E@ltx.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR16CA0021.namprd16.prod.outlook.com
 (2603:10b6:610:50::31) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA1PR10MB6518:EE_
X-MS-Office365-Filtering-Correlation-Id: 6353f861-b9e1-465d-9ff6-08dc3d352321
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	hZVDr6d+mmEjv4pifqov3zkOFelDG/Tl4X5jNhwqmB9onnRGGSlsccQ5dCvrIZ+Pea5YcTO8nyFtBHjKKkW5BPpKiqbxvQS/cga/WjRilw+UhiJuiir6Y1jHJjfm9SAhOZHYg8bpElkuZXOqqYk/OhOI4QktxhlS7AFvCrJb2k7NNIJrB3OaKLt833qeQlQOBq/uCaS1wGpoenA796dVbbZLvkzvBtk2xyyDHLueSEfSKmP8mCbm3x1RVpir4EEbR8zerpcTV1Fqy7qJKX2+j29Gwq41dnXMQnEa/QQvRGJ15z+uWgHwbA6LpWA/50ObsYIFQEUru/B43XHzfYdkRn4CmJbHIHJQkYXNwNljPidUjR2FJT4kZwX2/5fB3wy6dbqGJMWMJnC400CLdhpWZCVIYl060NFsOmRhVn3RkxV4S78tLSfydFjEqOtGfoyWPL+Jxh3FEyirntM5hEz95YBLZd1uvi2rF/erRI5G59ELPlKxojuOq+YhrsMTzqP4IeeSGL/bzOjd0dqCrQTAHIZxn/C3Q1H+Z83c6dXlVFxKplmbL5/UEPf/lAv47LAUH9JfZNX48L9kjYG/D2/b4V5NPjSuswS7NQ63EVSxlxWKYu5EwV5zs468PdvtKqdJwQSNxSI0uRKr0edIVdthNh6dBxmBSuSrKd2YrKC3IpQ=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TklOUjdLYWltdWZsWHhQWGNKU2NYZXZET1h2U3NUU2s5VDY5SXl5VC9EaVlk?=
 =?utf-8?B?YjFaNjRzeStRMkVrdmNSSWJOUG5UOXl5Y254dU5XdzNWTnVUZlZWby9mOVB4?=
 =?utf-8?B?YjNBM1dmVTFiaEdOTk5rRjJCZ2VLc1BIRTZXNHk5RllnYlhxOFBKcGNRSTZB?=
 =?utf-8?B?ZXlIZEJJY09adzB4cVBKazJlSkNvNmIvMlExMy8wSnBWZ0J5bHhVakdMTmJp?=
 =?utf-8?B?T1dDcU1tbkJyYk91K3RyY0pYcVQrb3NGaWlmSTI1M3Q5NXRuTzdBZGthVU1H?=
 =?utf-8?B?NE1wVEhXRGhVamVjVi9xVXVIN3FpeThDZmZzYUN0NWIrVTQ0ZkRYKzZDbDBQ?=
 =?utf-8?B?bFE0OXZ3amRWQlp1OU9qVk93RUZiTGNObXZUN090SS8zSDkrZkJnM2MvRkRK?=
 =?utf-8?B?bzFYR2p2cE5OaElRZ0dDZGpvUGVGL2t4aExkM3h3b0RFc0tPUFBYdEVaL0Jk?=
 =?utf-8?B?MmZ1ZEhrUFZqbzRkby8xNHMwNm1iL3lOLzhCYWg2d1Q0RnJDZG4yM3V1ZHJB?=
 =?utf-8?B?cnUyVXRWNkk1Z0h5aDBaL0ZlOWhIMUo0SzJaa1BKUFIyVXhYakY2azdHZmdI?=
 =?utf-8?B?eHZKekhZUGpDSmRGb3FpZnFCd3RIRC83a1ZlT2VBcW1KVUttUkhnS0VFb1V4?=
 =?utf-8?B?TlFndFErL0xjczlTOWcrek84VEt1VDZMQVNlOXZ1Rk1ITjQzSEVha1A5Z0hx?=
 =?utf-8?B?NGRhY0RDYXRsZGRtZm1TRmxodlJCSG1BWDZpKzZBQzVQSWlQYXdCOW9QRmt4?=
 =?utf-8?B?N250YVZVUnd2Tk52YzlhK1ZzN3dFRGVGOHBHQnBucWxNUnB4eTZTRWtlcFQw?=
 =?utf-8?B?WWVBRC9kSHkzSllUV1dwUWVwMmFKalFXRW5CUWNkdWVmYmd3ZEVjT3ljeXBX?=
 =?utf-8?B?ck53TkRtZHE0eS84RnpSM2ZkUUJ2bUg5TjlXSndwTzhULzFEaU12UmFEeUE5?=
 =?utf-8?B?aEdsV0RxcE53TEYyYTdzemVWdjFoMnhsMG5HMzRRODRiM3dYR2VteVd0Ulpl?=
 =?utf-8?B?QVlESmxRby8xOEVNMXZmYUhvNTRTeXNieGNrL3l0UGd2aVdPaTNLS0Zia1Q5?=
 =?utf-8?B?WWl2eCtyMnNFSXJXT2c4bUEreUdoUjA0QVRtNzNNcWc1N2creHVmeUtrdUJt?=
 =?utf-8?B?ZFBpMG0vQWRteEtDYTMreURLUWdoQUR6aUZkdzl5b1JHMWs3TzdWWlZUL0ln?=
 =?utf-8?B?RS9BVzgzV2xhQ1djYjBiU2hYUmoxNE0wNVhYVFVtUFVUR1BDZ3lKanhOeEN2?=
 =?utf-8?B?OVU2aENiS09WUXUyRWswWmpVY2FLaDExRmZHYm9wcVJtTUxmTGk0cTZ3M2li?=
 =?utf-8?B?L2FSaFErOXUrMTlnR3d2OXhGaHEyUTVTdHpybkJiQnNta2pkZUVkZmo5UXh1?=
 =?utf-8?B?dEJ5Tjh6eVZNeENlcVBoTFVrekw3UnpvaUVYZXVqRlJIOHhpT293SGY4S2JX?=
 =?utf-8?B?dWViTjlSc2RBdENXR0w0WnpWc0xXNUFGMzIza0szT0pOV3dSaXVaQ0hkU05l?=
 =?utf-8?B?OU9abzR6UnVNN0RrZVZwajlINGtldnIrc2xqMmk2dlZFZ3lxVWlodUFsMms0?=
 =?utf-8?B?dklpbnZSbHV1VENEaFRJdXN5czJsell6UFpDOUFUVmhxUGloZEd2RFlrWk56?=
 =?utf-8?B?T05hS2xRaVVTNENUTkNydDVYSzdSeDlhNG8zYUdHOS81OVJZL1RBT0FieVFE?=
 =?utf-8?B?T2Y2MFg1Ylh2S0dQTDlHa3F0WDg1VGZFU1JiL2tLY1FEb3phdXNhN1RqeGNS?=
 =?utf-8?B?QXg2TElScjJBUWZMa3BsNWFoOXZNcGg0RWZZeFl5aUViNTc3WW5kenJ5MTVP?=
 =?utf-8?B?bEp2MkJZcmdJaEZwdjlESG02L0dQcmVybU9RV0RpSFZ5ZXJzcU5zMkU4QWhw?=
 =?utf-8?B?UXg3eGZ6V3poS2dJM1g5NitJODVMeFk5UEZmM1JNTFMyT256blZzUmpjMXll?=
 =?utf-8?B?SUZibU91eUZvM2dMdmRzYk9TR1JHRVBMNVd4VlZwRGNnNC9sN3JoeFE3VVFI?=
 =?utf-8?B?TUxsSGRwY0tmU1ZEU2VkN2hHNUs1dGZaeVNIN3JDZHU5ZkVvS1FwQ3M2NW9v?=
 =?utf-8?B?QjZjUExYeXNXd3k3Qm10cWtTYlRGMzF2QWZKcEpUZ0VUMVoxTm4wSTNrTGFl?=
 =?utf-8?B?KzBkbGREcS8xeW9YWG9iT0JhV1VnTFRpSEZhUDVNSHV0ZjBqMGpnczBRTWJL?=
 =?utf-8?B?T0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	3evQhEwR4JQqXVTx6PXpcq1WNeHL3/8xvvXzNJzgOs0sd1a+dOZWGwrT+cHPPTSE4vvweTclgCioYkeN25VMCckqBDTKr2SZUk7ZM3LrKr8pkftWBNDLcTXVYsZ9t4g0Hyy6aPeLCePHZ6anKgK6Rnp49p50TZ81BMfatsfTZF9loY7cbmDEomHGNqSv0uNfu6z960WKZ4wGnJmnsKKatyTZTtuFMbp9kp98Q2NSy2F4xf+eZtmRgYMckRbGUz3RlnhYvAK1P176s5zPX4NkT5510/s9hNsVGU5eZf8Hm/cKByaNHL0RoMhVDLXdgl/h7BQUc9DUfvpveR308xjUARpyN80X1kevOaKVIGJUnMpAJms2qjfLk4ihR49lHk2+UdbcF79VbqjmuzM1G7CDXT/zNMbUMjirDQAPBmeoLw04WFSIiyFQfs8PVB51XkykRV8o2aXp+l8JfhwnUqQbT/psHb4F4vmz65LB4dJG9CzFO+GpWYFA1ZE7TKJJHlnOrZISsuA59/4sXBAK6hZ4mrYbCZyVN1c+dEolC/VRb3yAYrD1HpqjYTDslgZxsVEGBNQ1xWNpFehZI8eSOWfKmCeoZhZ2q3zo4N6a3T+Y3hc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6353f861-b9e1-465d-9ff6-08dc3d352321
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2024 16:56:01.3591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2A9/PwbHazBPGqqb3KoEeQkTYcHNk0JdeB80kLP6vszliYKlCDI85/F0262hnoz/L57eK6bRUaW1X8/db+UgpLI5VO8fDTwibZTIoGA3wes=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6518
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-05_14,2024-03-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=967 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403050136
X-Proofpoint-ORIG-GUID: 16nxJFqU3chfUfUmRgMZPbuXR55N6Jm0
X-Proofpoint-GUID: 16nxJFqU3chfUfUmRgMZPbuXR55N6Jm0

On 3/5/24 4:36 AM, Holger Amberg wrote:
> * Kernel: 5.15.0-94-generic x86_64


> Mar  4 18:28:02 km38033 kernel: [33147.476180] Unable to recover from DataOut timeout while in ERL=0, closing iSCSI connection for I_T Nexus iqn.1998-01.com.vmware:km38116-369efe55,i,0x00023d000001,iqn.2001-09.com.customer:target1,t,0x01

This should be fixed in the current kernels with this patch:

Author: Dmitry Bogdanov <d.bogdanov@yadro.com>
Date:   Sat Mar 18 20:56:20 2023 -0500

    scsi: target: iscsi: Handle abort for WRITE_PENDING cmds

For upstream kernels I think it was merged around 6.3.

