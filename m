Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DA4145FEF
	for <target-devel@vger.kernel.org>; Tue, 30 Jul 2024 21:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722375667; cv=fail; b=MkZctx1ivwi5cC8Fz5a8H79GxY1nkDN7PSoQtelNYs4p8sp1Q8sHJMBcmibfcc+tQQg6iriHrbZA2NqpZvEs7dfNKuJU9dGEh2G9KlpkyWKJeThD7OuB1Whfb1LsQ2YGV2J9Zwkgg0+wkiMtwhQKJi/qMIObpMHYeBl9qKWni+g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722375667; c=relaxed/simple;
	bh=h4qeCbfbm81/qxPDn4TmwJQJHmLuZvkCyGvPg0rKzDA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U+AloT6dx3ahp9DE5zAz931xNjEeFAUVUXriysepbPe6T+3LDUND8WxVMFX5FGzBXCV8C7qtkmXEPYPAHpO0yWoqB+i8WK7e/chHKT5DzMR6OsWV8fK39SwTxQqvTXBhd9o7vib6tX7qE8d2msnCBToQhn2kNaODdJrRZzajy5Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hqA1s0cw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hGwMJZoJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hqA1s0cw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hGwMJZoJ"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46UFtX5G012444;
	Tue, 30 Jul 2024 21:40:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=fBPDqEhCCiADzh8pkYQHBEPARzDHin4RIQwdaCmq64A=; b=
	hqA1s0cwqIN8ORqIvshRuFNzNPSBEG9BVzqski5ERYQGwaxZ0/VIF0t5lOq7U2u4
	LtYxznt/VPI/lUKpM9YHchuWmwtVNLIl9AKasxUqg6J9qQbMztRdXMUPpGB5y1K+
	PmuFC2fzCfcX1ogMfFXKVS7HlNeVt0Ar9NoltjkfVboZJZKsKy4jdQOPisyUHs7T
	0sXc9wrt3Au6KN8hRAE1cAJaaflvcvSENt6o0y/F33imDSGLB9px46Z0qdSekH/I
	Y4Hfh0Y0AKUaw1xk6la2ni/855Wrb23f93OVMPBOlYSl2cNMbQtiInbBEe9zeoIs
	I1o+5eKFRSrFwb2409QRwg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40mqacp2xu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Jul 2024 21:40:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46UKc9Sr030992;
	Tue, 30 Jul 2024 21:40:49 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2045.outbound.protection.outlook.com [104.47.70.45])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40nehtmd2k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Jul 2024 21:40:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WGrF194Fon7X/NjERkLqEsjrq59gpy04MzJmVshtTNVHGoJ6eR99t46j0L9pN1Rthyh/Zpxetc32WflvzQkdW23WaILW8BVGeyb23Z2EeubfkRd/abACDyO7axn3+LOJ47ZRmn6GwsSKe9QCL7v03bDoj0TP1s5+sBr2ow+WrBbMVpx3brv2eYTYv3/fKVHVA6t943Z13wFL216ly+0fCMg9QZ8ZHRYmLhKe6UDC33+RLKTVP9u9Mnysi9A4aLzo7YQC0MfTk7mZzsJTpJFgcEEK994WCiaBG0ZZR47VreoJspYXpo5YKBHPSiTstyjLC5HI5S37S//DWxCg3FUEGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fBPDqEhCCiADzh8pkYQHBEPARzDHin4RIQwdaCmq64A=;
 b=JyHT4Ll5fhLKtEy9XC0jixhluZJcfnUol39rm1IDZR4+IpoqkmaHIQ0zEsbbGx3GuoXUJG+lOceVCXyIYAmzIPjhSyLdbSxlijYqvx3fNQG304aN21wUfiXp3D2Hm7y6UqqTuexZvNrjw1uUwlCJWbFBH8yxvgyk9g9UtlnFhbrpTLtZ5edhecnWE5lEhzAJuZILhGUCa98tLEWTdr73xNOxnD5rUoWecoKofEvg012GHdxrUjW7Hwrng1q4atHIwYT/MacXTmw9KjCzoSuhJluVuOZgOc5L3lrru/8xQpzlJrUC0D9Yc387Chy9QitpY4vy6mdFySUF6NzBv7DNPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fBPDqEhCCiADzh8pkYQHBEPARzDHin4RIQwdaCmq64A=;
 b=hGwMJZoJxVODTZETz3PfC6SeubWoTVcu3GOmfqt403NPyxuR4i9VYpkfuilapcx2BCiOx/QWBcHq1Qkb1bEUx+YptzgnIpJ6vYCHg20PhBaVctxzIU3VykqNPmVnUUrPX5jL3iSFeAJr1RyaR8XmfUy8OJDe5YrEgY7rM6QfqmU=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DS7PR10MB4976.namprd10.prod.outlook.com (2603:10b6:5:3a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.27; Tue, 30 Jul
 2024 21:40:47 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%6]) with mapi id 15.20.7828.016; Tue, 30 Jul 2024
 21:40:44 +0000
Message-ID: <043c42de-be25-40b6-8f10-3ce02099b00d@oracle.com>
Date: Tue, 30 Jul 2024 16:40:34 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: tcm_loop and aborted TMRs
To: Gao Xiang <hsiangkao@linux.alibaba.com>,
        Bodo Stroesser <bostroesser@gmail.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc: Maurizio Lombardi <mlombard@redhat.com>, target-devel@vger.kernel.org
References: <CAFL455kjQeqvPqd1CUqs7f6xUjrrDqR1h7edizusAtj130HCPg@mail.gmail.com>
 <caad6a7a-c30c-a3ac-7932-f5a19c877ffc@oracle.com>
 <e07f0fa5-d59d-36f2-d99b-73e32af3282e@gmail.com>
 <20221121133550.GB5248@yadro.com>
 <addec585-4271-cd9c-fcf0-fd780f269aa8@oracle.com>
 <20221125084920.GC5248@yadro.com>
 <0a6eb2d4-1158-5268-27d5-454edbf9f566@oracle.com>
 <87d2d228-a4ac-9103-0f1c-57c691f91f0f@gmail.com>
 <457f3c8b-87ac-dcf4-6e6e-a41321d2151f@oracle.com>
 <0d7112bb-f6f1-455f-9351-26b09fdebf7c@linux.alibaba.com>
Content-Language: en-US
From: michael.christie@oracle.com
In-Reply-To: <0d7112bb-f6f1-455f-9351-26b09fdebf7c@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0177.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::32) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DS7PR10MB4976:EE_
X-MS-Office365-Filtering-Correlation-Id: 306964cd-9dbe-4272-5a80-08dcb0e04411
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q2tHSHBIWmtBUnpTYkV6ZUFEb3dIYWxVcHBBZ1AzYURRWExrakVtSktyR3Z1?=
 =?utf-8?B?dzlIM1l6LzJDam0vTVpUVWlBcVovOW0yK2N0SWI2WVFKVlhQRFprRDY4Um15?=
 =?utf-8?B?TG0zUGU0Y1lrZnFFT2FZQ01NMkZvL0ljRjRnTjZtTkdJVWFPRzkwcXE5b0Y2?=
 =?utf-8?B?a1BWb1JqSlhLaEVISFJKSkI5SmFsS2lFRlJRM0FMRHVGTzZhN1oxdWlTcDNK?=
 =?utf-8?B?c2toSUtvZGZvRXAzcitVYUgxaitIYkdwaExWSk1LcERMcHduZjVMS0VpdUN6?=
 =?utf-8?B?MytHNmdDb3BWOFlVaHR5UERSRFJJK0FhUXRXaWNqT1JJZUlQRVdmTUJDZ05I?=
 =?utf-8?B?REE0RHl4OVMxY1g3eTJ3Q2ZBYjNQb2VPMWphMXp4NXNzMStWYi9KL01QZGZF?=
 =?utf-8?B?V2U4NEtBWFU2cVBTRVFBRVo5ZTBWUEF5RzMrU1lSR1NJd29rN1ZnamVBRktO?=
 =?utf-8?B?ZkZPbUdLaklwUU93QkhyRVp5cDlmT0hKN1BWSHR5QkdGTWJJSVFsWXo3aU5y?=
 =?utf-8?B?R0VjVTBFY2pTUFJSVllMUEpLTEM3RmRUb2sxbGtLMk91TTBqMEJSb21CQXVa?=
 =?utf-8?B?TFVCcWxPbFdDNlhlRGR1aWJlNWlGM1dxUUhLcXZ2cVRkajQ4eWtYUFF3WGFO?=
 =?utf-8?B?ZVk5eGxzbjF4dDhDeVRsVjBpUE9VSnVQcEc0ejJPbmx2TkhYaU1hTzNLZnNu?=
 =?utf-8?B?UTEzK1k5Nlp1OTRTRC8zdklneXg4bGJ3cmZDNm9YT0NWby9mbmRyYzFnSWZV?=
 =?utf-8?B?cmFla0g1bTJhblpRSm42Tlp5TGJsOW4yQWJMNzlaVEpaRmVzelNXS1Y1UHV5?=
 =?utf-8?B?R1p0ZWZYYnlldnJqRUJ1MCtUV2RjQUh4d1VUZUhzVys0cE5FUUpRT2FKRGhY?=
 =?utf-8?B?NWV5ditEVzlHMUhaZGxqTGZwSFBXdE5QcTVlQWIvQmNXY3VmQjRraFdVNDlr?=
 =?utf-8?B?Y0k1YjhsNjZrTUc4M3l5S3lOVGI3WENNR2UyblRiTHFWUWR1eDlPYUY5RWFW?=
 =?utf-8?B?UDRia2RmUW45Y29hcFRrTmhZdVIrYnhEN2FzdEM3V1plTUVBczFyVWEvM0pq?=
 =?utf-8?B?K0FRK3hYVC9tMmRxcUhjSTh3REd0alJIbkdKc0xGeXBXK3gwajVBNlp5MHBv?=
 =?utf-8?B?dGl0R0V6UU9kTzBpYitCVzlHZkZHNlBQRnhFU2Vnd29ua0VMV29TaUZoV1B4?=
 =?utf-8?B?QnFGZTZDNmYwNTIxSXh4RDNmai9nbUo1OUtjY3diTDdhNjFUdVJxdUJVcE03?=
 =?utf-8?B?Q2FCdnVUdmdrNnd3MEFuZWVad1pmUmN6UVl0eU5oRzFtL2FQUUlxRjgyNXVM?=
 =?utf-8?B?RFZMUlNJekpyVVBNOFd5cExzcTVndU5GT0hkdGowTVBZY0NPNmZHVFVoMzNI?=
 =?utf-8?B?c3NGeWlvQk5PcTJNSXFqVUJrb3BTdjBaNi9sTytnSmdTOUZNNGJMOVpxTXNU?=
 =?utf-8?B?eW1Vdis5NGRNeml2b1VJbm5UMEJhcXd6SVEwSVZvT3hQR0xVTFM0N3hZNUNr?=
 =?utf-8?B?N0ZtejFtUzZwQ3c4dksvQ1UvK3pzdi9iR3djc1E4d3JIK0tEcS83aFJoWFY0?=
 =?utf-8?B?M0xlQWlBRktVQjNFTkVZcjY0N0N4V1p6QUQrWDF6K01jU3JGajBZN1A4VGhX?=
 =?utf-8?B?T1NqWlIyNnpEYjMzUGd6TEZ0Yit1TDlOTVI4VkhHL1NYOElGNXhTS2RaMnlz?=
 =?utf-8?B?cGlJVFkvRXR0dzMwc2E5Q081ZnBjQTA5VEpjZVYyKzhFdDZWei9aSVJHeENm?=
 =?utf-8?B?NzA5Y0luNkxkQm9rTlNaZzhVQ0V6V2R3TDNNSlhrV0ZuZkRSQ0FkMVlwalcx?=
 =?utf-8?B?V0VGTlhPakFPeUFCK3Jjdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OGprUFYxUENUNVc3YTJxRVJmYnRwQ0VIODhBd21uY3dYS0hiVXp3QkZobVlK?=
 =?utf-8?B?dlBnTGNJNDlqdEhpcDBnRjh1bUovdFc1VnZFU0NoYUxUWDZCbTZXZGp3Y0M2?=
 =?utf-8?B?QVVVMHhaNC80WTJEWGpEOTdHZ01ZUGdXY0lJQU9BaEpEaWxxL095SDZrVGdE?=
 =?utf-8?B?UWtJb080KzlkOUgzalVSRjVHK3BJaWNnazRaVDc0bGdnZTVXM01ZOTg1Z0JU?=
 =?utf-8?B?TmxQbVdzYWFqQkRZaGVoM2JFR1lHYkFOQjNDLzE0ZEM1WkFLKy9yVnpNY0N0?=
 =?utf-8?B?dE11d0ZUOGI4ZDR0T09pdEpsQndoQy9MUFhPREdEMjdmbVVNWkwwWGprNThl?=
 =?utf-8?B?Sk8rak1DdGVEWXQ2WGltUTlXTU9mVmpXL3M3MVlocTEzQXVEcUZza2t5MTVH?=
 =?utf-8?B?a1MzT0IyNUIzd2JWYnFscjB2YjJQODkybUdZTm9LaHpoSWNlQVo3d25EemIw?=
 =?utf-8?B?K2htdk1henF6T2FZNTZQeHhTOXZlS3Naa2k1K1A0VHpFdjVIUTBVU2xqdE4w?=
 =?utf-8?B?YjM2cnAxZGlJWEpLRmg1VDFRaGtvZ2FveXNIREtvUEhUTngyVmtNVmlIWmpa?=
 =?utf-8?B?cmtmNDRRUzc1Vm5WaEhpdkFlQ3gzajdQU0IvR3pOY0hKY3BwOFMycVV6WWJJ?=
 =?utf-8?B?RjgramdoVUQ4Q2VkZU9lYVdFRThJZFdJaHN0NWtwS3B5d1hHUXpRYngxekg3?=
 =?utf-8?B?QVlmVUErUWNlVGU0R0R2ZE5vZVMxcjZoM3NKTWRUeUtsTFlKb2hkQm8wUzE2?=
 =?utf-8?B?cUoyNWZFeVlwUk9zbThza1FGcHphcEFMUC9IY2o4Sy9WQ2FUQ0lGYlFCNzNO?=
 =?utf-8?B?Tmt6Wjg3ZDV0Wm00VlI1TmVKalFmZVJCSkFZUzN0aE8xSEVoeTJucmlGTlBr?=
 =?utf-8?B?TWRSY0hVeG0yVjZUS1pzY1AvWGZtWU4zc3VjeVpleUJaVmlRUHRrWC80cXVu?=
 =?utf-8?B?ZTZJUlRLNGVVUkd2ZXpjUUxza0puTW5IYUVqNUx2cmMrd1dVNHpxNnMyV1dO?=
 =?utf-8?B?T2wrbDI3TjE3dUdyemV4Z095MmhsNDdZZUp6R0dXOHZwVHliSURFVXNqempp?=
 =?utf-8?B?bUlxbkhGRmp4S1RhSmw5ckRMV3NwQ1pKUG1zcmxpUW9MaTVWQ0hJLzg2bXlZ?=
 =?utf-8?B?Zm5MM2RvbFlmTElGN3NSSkZaV09WalgybFJaNFYxWThXT05rWndwRTZWRC9I?=
 =?utf-8?B?OXNDWlVxSTFiWXRHUHlGNm1URXU5eEJrbjBVbHZwK201VTFIZXl4NXJPSnNo?=
 =?utf-8?B?dzk1UmxxeUp1OHA1bmtBU2Nlb1FRZkh0cEhFYVR5bVo2Ync4ak9XaW1YODQz?=
 =?utf-8?B?OFRnaEZ6ekU1cG5NRnJoeTk2MmdJeEY3dUI0dk0yalJvNmdmU2RneTFIdVFU?=
 =?utf-8?B?Wkx2VXo0YUN4WU1nZDd4T0tYTkVwUXV6dWN5SXMxQUZGOUZxd0czQ3duUXAz?=
 =?utf-8?B?ckg4WElKOHpUUHd1UHVvRzVVcDNsRDhBSlM0U2tJclAvblFzNjArM0dGNFdi?=
 =?utf-8?B?WVVaaVMwU3VVVk1PaGlwN1BVYmk3cU15SC9TSStKT3FIbTBhN1Q5VU9uRjN3?=
 =?utf-8?B?TUdLRDVURkVRNnNZenhPYzlWa29vRkdQSWlvMDMybVN6a0VkUHFzL25MNEg5?=
 =?utf-8?B?OVBiWXdoSXZmLzVPdjEzN1Y0ajQwQVdZYzJFbE5CeUs0NDlBaUhBbGp4TjdR?=
 =?utf-8?B?Zm95dS9lTzBiaVlmaFZkT2FHZjlrV0xiSmFwR2J0c3hWV2pIOEV1Qm1HVGpK?=
 =?utf-8?B?ci9NZ3BLWGJNbzRaUWNLZzJ2WVNJcE5HOGF6Ry9uUDRjdlQxU2VyMDBmRkJm?=
 =?utf-8?B?SUhIdDEvbDVXcThBcmp3S3VCdzVDWnRySU9aQzRSa1RKS2FBS3dGTHcxOVFD?=
 =?utf-8?B?R0ZYd3ZCbmpYNW5td0NQLzh1eTdQRjJmV1VGdCt3OGwzUnlqVFhMYmZ5S0M4?=
 =?utf-8?B?d0dCYzNGem9INy82dy9tTkpLNHJaRngvUlEzYU9Mc0g1dUQ3N2dtR3lpVVlZ?=
 =?utf-8?B?WGtsYTVaQjZCZ25CWVZ2RXU5amVVcCtUK3RzMWxqSCtvOFY0dGU0VHpQTTNr?=
 =?utf-8?B?T01qaHdhNmExbzBFN2lZQ1IxbXhuS3k1ank0cTF0OVpwK041T1E3RXhaVUpk?=
 =?utf-8?B?SHZtbHNiSFluUkFmQmZZdzYzZ0ozaHd1cjVONnRjVG40aXA0aUN4bzZRQUhk?=
 =?utf-8?B?L0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Im0kiOq1OcQ0/2lursTQpi+3AC8GUcacHxvvuYhTDsMxGHcYhReQJcGf5eTCde+mibfD5a+rXnyQ6vhN6b2ZHEYycGXgUbCYv2AwpcPpTxMMDwFrn2ggsVd/t3vxEATe1zU8gx3z0Ilcq8PdMVzrcyilW9jA6nllvvvwz75k76dRRx1CQq9Hm3kpQkgbCKiZrM+t+KNzahDamgWG6kxlzPeXxv5utzVm6K8++OTIdhcENGpvAip7vIKbuIcp0JcxIbb3kE/O/nPoOeYWf24oqc/OmPcy3qNDc/aVMTyjqHvrUkxqT9E8j6wy7r+Y4ZiOx+LriIhbFwXL7/c3CnuRPHSf/j1v4JceiEDcYc2mLZUsaz0kDu/8shnBb9+TVyS8FeoQSfd2XDSHaxp5fQQAgDZr6R9ozEq/V4u0m2WfETXRfgIwTz5nbhVAVXh8yHEOiL8bVGHrtjTO9Elc4Pa8bypZGzHGNmIgk70nwfyzkqaZ7u/gYQr5k8wT5K/ofE5sQTsOAO3p/wSUyAmu1mRxYlgaeOFwfi9QnFYQICobTfI0GE/8Ov5jwqPaNqETgPt3fqNKpuexxAZth7cNk9t4mDc79BaCc0Dk6XD/qyTYbjc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 306964cd-9dbe-4272-5a80-08dcb0e04411
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2024 21:40:44.2328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +WQtr/lsiNTbtfuZj57Ghv0wgb3WNEzDxpTOciJHk7KBPjEi3n2ZSrgMSqAlFH43rIy8K6O2dz9KsrVjmHs9MRBEMOXrsVyNkVpHCNZ7zI0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4976
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-30_17,2024-07-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407300149
X-Proofpoint-ORIG-GUID: g77FE8yfGdBOA0W91UBdRLs-EVJVQURb
X-Proofpoint-GUID: g77FE8yfGdBOA0W91UBdRLs-EVJVQURb

On 7/24/24 8:42 AM, Gao Xiang wrote:
> Hi all,
> 
> On 2022/12/8 11:45, Mike Christie wrote:
>> On 12/1/22 8:15 AM, Bodo Stroesser wrote:
>>> Are we sure qla, loop and xen are the only drivers that handle aborted
>>> TMRs incorrectly?
>>
>> I'm not sure now. When we looked at this before I was only checking
>> for crashes, but didn't check if there could be issues like where
>> the driver needed to do some cleanup in their aborted_task callout
>> but hasn't been doing it.
>>
>> For example ibmvscsi's aborted_task callout won't crash because the
>> fields it references are ok for a IO or tmr se_cmds. It doesn't do
>> vio_iu(iue)->srp.tsk_mgmt or vio_iu(iue)->srp.cmd in the aborted_task
>> callout and just accesses the se_cmd and ibmvscsis_cmd. So we are ok
>> there. However, I didn't look at the driver to see if maybe it did need
>> to do some cleanup in the aborted_task callout and we just haven't
>> been doing it.
>>
>> Same for the other drivers. I only checked if aborted_task would crash.
>> Also we have a new driver efct, so we need to review that as well.
> 
> 
> Sorry I have very little knowledge of TCMU, but currently we have
> some call traces stuck as below:
> 
> [811824.868078] task:kworker/u256:1  state:D stack:    0 pid:213661
> ppid:     2 flags:0x00004000
> [811824.868084] Workqueue: scsi_tmf_24 scmd_eh_abort_handler
> [811824.868085] Call Trace:
> [811824.868091]  __schedule+0x1ac/0x480
> [811824.868092]  schedule+0x46/0xb0
> [811824.868095]  schedule_timeout+0xe5/0x130
> [811824.868110]  ? transport_generic_handle_tmr+0xb9/0xd0 [target_core_mod]
> [811824.868112]  ? __prepare_to_swait+0x4f/0x70
> [811824.868114]  wait_for_completion+0x71/0xc0
> [811824.868118]  tcm_loop_issue_tmr+0xbb/0x100 [tcm_loop]
> [811824.868120]  tcm_loop_abort_task+0x3d/0x50 [tcm_loop]
> [811824.868121]  scmd_eh_abort_handler+0x7b/0x210
> [811824.868124]  process_one_work+0x1a8/0x340
> [811824.868125]  worker_thread+0x49/0x2f0
> [811824.868126]  ? rescuer_thread+0x350/0x350
> [811824.868127]  kthread+0x118/0x140
> [811824.868129]  ? __kthread_bind_mask+0x60/0x60
> [811824.868131]  ret_from_fork+0x1f/0x30
> [811824.868166] task:kworker/121:2   state:D stack:    0 pid:242954
> ppid:     2 flags:0x00004000
> [811824.868172] Workqueue: events target_tmr_work [target_core_mod]
> [811824.868172] Call Trace:
> [811824.868174]  __schedule+0x1ac/0x480
> [811824.868175]  schedule+0x46/0xb0
> [811824.868176]  schedule_timeout+0xe5/0x130
> [811824.868177]  ? asm_sysvec_apic_timer_interrupt+0x12/0x20
> [811824.868178]  ? __prepare_to_swait+0x4f/0x70
> [811824.868179]  wait_for_completion+0x71/0xc0
> [811824.868184]  target_put_cmd_and_wait+0x5d/0xb0 [target_core_mod]
> [811824.868192]  core_tmr_abort_task.cold+0x187/0x21a [target_core_mod]
> [811824.868198]  target_tmr_work+0xa3/0xf0 [target_core_mod]
> [811824.868200]  process_one_work+0x1a8/0x340
> [811824.868201]  worker_thread+0x49/0x2f0
> [811824.868202]  ? rescuer_thread+0x350/0x350
> [811824.868202]  kthread+0x118/0x140
> [811824.868203]  ? __kthread_bind_mask+0x60/0x60
> [811824.868204]  ret_from_fork+0x1f/0x30
> 
> I'm not sure how to recover from this state.  Is it resolved upstream?
> 

It's not.

I think the safest thing is to just revert the patch which caused this

commit db5b21a24e01d354  "scsi: target/core: Use system workqueues for TMF".

because we don't currently have the resources to fix qla.

Do you want to send the patch? If not, I can send it.

