Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012044.outbound.protection.outlook.com [52.101.53.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45C62D2495;
	Thu,  6 Nov 2025 06:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762411358; cv=fail; b=FvzyGsAxD5Dx35PuTdO5/rHMBzOdLopfE6ubRtXxMB34+8vhzSfkTCgNAAZNkS5xZhA49Espbvm2LokHXpn0qqKsq2zG6lLAoJ7j5a1Ia8nNV/7oQc34ptOra5c3LZs/Nz5d6hdUM7JMtPTHGxEJJjojX+1l29g4hac1F/AXNsA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762411358; c=relaxed/simple;
	bh=vmmqoe2mw5Wm1ZdR6j0Ofsdigx/rpX/t7dWGQraHwKo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YtFVuE5+VznCFt7sXb9sV94cNyy8P+fJHDVIeUOZQ3Kkm0zT8NbF831WYctA0oaSsUxQuDmkA6o5kUIf4LGghZfphTLOgQnhL0sQAAS/dX8VB8E7mlLZqcocVDBEkEjZsipUtMM4a6mIu4fX4hmAx1RBmhUswez2zqy3X/Fzsi4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=X4JsPhNv; arc=fail smtp.client-ip=52.101.53.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="X4JsPhNv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lg0/t/8l1uV5DdMvatCzpovRHQES5CNc4YWMvL+lmOLomA+zGpsoiSLX+D75HRAn2bhaF0XqzSGngWujbcpqcxGVS0xrAOgZOOQB3CIzRE4bmrSuoCuMYZSVumL/adacPGMtrd3n12j0kZapA5ues55lai1VMW+pjbtdFkkn06B/nX6Gu0AW+dx50978Nj508YQ2Vz8ci4Hw9Na17Fc4wJh1FkAMrs/XLlw2h3uO04v+9+1gSd3/AesBFUQ8iviN8ohqDr5SpjOUqNNd0V4GFA6y8o6Q3ha+kLUJUkJleM1lfcPDJBxxrduJ8kGgjU388xe25WP5RhKTPh6lIdZVdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vmmqoe2mw5Wm1ZdR6j0Ofsdigx/rpX/t7dWGQraHwKo=;
 b=UaF1l3g8Olf7ntaeflsyBIRLOBFi16mRNBI9kauVD4bg8po3Dg46rR6mtEmuRhgT1WFDPtFnUvPFcgMoIOo9gU5AdYo5F0kh6RAAI464oL6fBK44XghHO0DBI/JQhFFrJ0qGk3/1x5FltdWC2WK32x/gn0wIp+AjQ5InOgfzdMDC+cWHc9iEQS0UHaq7C/VYV7sn3s/N+ZV/wRKv5gJZrjaPVMyl8UZCBGjiecJhjA5erLYo2wLHSj2v2Ip6x94Joo0yxvqmPgjlilliu4ExoU+8ueAqNqB8lgh1EM3uDzrXYlciF73tuJliHXd9EilElAN9n5RybCWezNDNUjExDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vmmqoe2mw5Wm1ZdR6j0Ofsdigx/rpX/t7dWGQraHwKo=;
 b=X4JsPhNvSyakOPdPdZFo/vbwLDh10l36BatUg2fb8Zs8QVFu7xyObs+ayV4UZja1SLoe7MwlUnAo97rO7voLKIYMK9t16XT5fpk93eqrk9nYCtp8Hv5iZt+PFQt8Bo4LWAZKqvOhiC0f731DHhRGn3F4H0ILLANzWH9fRm72pBYrJbKl2KBiDqvAOxQ4GurLuq2Eih1tcxEEEasACLUSfmm5P7bVzS9D7UOlj4LFF23XquhgsAQx1TF2ICSQro9IMDQccEFVFbpLaUK1COwAgDxidNTonVBALbZwmR+cGRgvevWIcFEjma576L2T8tqGeWMEgTejBOuCfXEU/J+TQA==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by CY8PR12MB7313.namprd12.prod.outlook.com (2603:10b6:930:53::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Thu, 6 Nov
 2025 06:42:33 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.9275.015; Thu, 6 Nov 2025
 06:42:32 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Shi Hao <i.shihao.999@gmail.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "inux-scsi@vger.kernel.org" <inux-scsi@vger.kernel.org>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] target: substitute kmap() with kmap_local_page()
Thread-Topic: [PATCH] target: substitute kmap() with kmap_local_page()
Thread-Index: AQHcSwMBQwNZZvAcM0+wgg6WAQCVgLTlOwgA
Date: Thu, 6 Nov 2025 06:42:32 +0000
Message-ID: <df283f3a-5463-4696-a067-3a4a30498d6e@nvidia.com>
References: <20251101074137.98988-1-i.shihao.999@gmail.com>
In-Reply-To: <20251101074137.98988-1-i.shihao.999@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|CY8PR12MB7313:EE_
x-ms-office365-filtering-correlation-id: 9baca1d0-4c0c-4775-14df-08de1cffaa06
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|10070799003|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?eG9NaDl0amlYSG83RHY3VGtKUnNZd2RvcG1tRU1JY2VkMXB0cTErTnFmbVpi?=
 =?utf-8?B?NDJpVTYzQk9jU29nYkhYYVRDdDl1REZiOUlCckR4MW40bG1waVdXNE9ORWIv?=
 =?utf-8?B?TVJKM3JZWkkwUFJUek5vaUU3S0ppUzNGSTY3QXFHcUc3ZXIvSzIzZDJvRnN4?=
 =?utf-8?B?b213U3U2M3ZrcnZhUGN3N0UwZitWYmsrQk9MZi9meEZ0MFJVODA0K2Vyc1VX?=
 =?utf-8?B?NHVyT1dBa1VEOXNqWXVJVXFNOUZyRXVnQ2hmT2gyMmV6bDlGdXlkNE9UQ0F6?=
 =?utf-8?B?dG9mK1A0M0d0cmFKTlRMS3dZSDhXNUg4eWEvaUlHbE10c3RDNTRrREJhZkxz?=
 =?utf-8?B?Y3ovdEpDemRyUjZkUlM4WFhGZ1p3Q3dibllWU05VVWFLa1RvWisyTk5JMmpx?=
 =?utf-8?B?MUJINnJRNDVqaW9MZGRYeW5FQWRKMnRhQ2JqU2NISWV3NVZib0ZCN0dWRm85?=
 =?utf-8?B?bFpwRVhVNXJ0YkZLZ1NrZ3gxYUs5S3crQllxdHZGYUdDQkJ1L0JkUDIvcEx1?=
 =?utf-8?B?MlU2cXA3cStNR2hYVzRJa3ZQQkFuS3MvOHRmK05vQ25GY21xV3M5dGJMcVNM?=
 =?utf-8?B?TU03WTNVQnZja0xwcjR1KzJlZlVoMmlabXlxUlczQVdHSjY5V3crTzNzL1R2?=
 =?utf-8?B?WW00MWFiTng1Qy9ZMFV3NGdpS0VVaVpwS0FMazhkeE50Wk9OaFlpV1FYZXph?=
 =?utf-8?B?YjZ5OUgvQVh2RjFJb3M5UXphdW5yQ0lmdVY1MjNDZ1VTc2hwL2YrTythY2Ju?=
 =?utf-8?B?a29LUldRaGM2MVZMSXV3VDJEazkzWUEzWmJZaXF6M0hsTnNKd3hDa3REakVx?=
 =?utf-8?B?aVRLUU1nQktmai8xaFVjRFJiNzdwRHJvRTJtdW53am1Uc0xia25idlI3SE9I?=
 =?utf-8?B?WXdUYVJ5VzJ3Y3pBdmFJdGppQmNBT3lXL3JXdVluUEN1RjJWbGVMS3lzZTVD?=
 =?utf-8?B?aG8zUUZUWlJicXFLUGlZUHFRdUhQbmE5SjFRMTBPTUxHNDB2LzlMakYzemht?=
 =?utf-8?B?ZDJic1U3UVdTL3RXd1FZaExlVWFwWi9SM0s3RnlwUU8wWWpiQU1FTHFTZTdi?=
 =?utf-8?B?KytnTmN3VVBCRkNDV3RnWHNlM2l1YWoweEVIY2tiazlQOXBWY3BEL1g1eTVi?=
 =?utf-8?B?cE55d3p5b284SjNZV25OT2o5KzUvZzM4NGR1OHB1dXd4Ui9zQlRHN2UwUE1s?=
 =?utf-8?B?akZOcjJmb2FrQkxGSWluUFFINlQyUnFWeUQweS9pOFRucjhCd3A4N0p3Y0FM?=
 =?utf-8?B?K05wNkM1YkJBMG9sR1czWmhHVFdmY3NzQ2hWSURkNkVxUXdMSmNZRTVnc3dS?=
 =?utf-8?B?cHhkeTBLL1pOQlQyeU03aCtOZlNtQVlMWXVYd1pwR2ZNc1ZQZC80UEhXbVpi?=
 =?utf-8?B?R0p5Q1M4UUhsdmtReFEyL0VLMEhWWFBFN2RZWTVDRGQ2TlVyK1dHdE11N0d5?=
 =?utf-8?B?U28yWWtxNWczeXZBQ2hYRjlkd0dEbUgyYitwUXlyNWRtYXFQOU5FVU9IUEVl?=
 =?utf-8?B?VlFOL3BZQ1liWFVIR3ZCT2NsQUxOTStFUWNPUkNhcUNudFJHRjNXQklCMzMz?=
 =?utf-8?B?TUl1VzJ2czFYUkZqa0JHM0dpTlBDMmV0ZE1hdkx4M0xCQzRVZ0NqSWRBU3BB?=
 =?utf-8?B?RjR0OXFKLy8zaTU4a0tqY00yb2RaNm4xSTNMZS9Sa3FPZUg4THQ1SStldkxq?=
 =?utf-8?B?YnkyZHAxY3daTjFlK2dZMUhCNHVqYjdmTDNmQTE1S0VsMTh0VWY4KzZNcDM5?=
 =?utf-8?B?MFNnektBZEV3aThRRkNkZG52S3R2NFYvRjFCWkV1N2pZbGp2VmMrOVhWai8z?=
 =?utf-8?B?L1hBeXNQUHdUN0xIVXJoVkEva04wenhXZWdYSjNmZDQ2NjB1L1llK1FRQ2VO?=
 =?utf-8?B?OXc4QjdBbTlGcWRadUw4aGRQNlllSlFPSWhuUE1adTlaNjJxYXZOakFFWTRY?=
 =?utf-8?B?aWNZdXVFOWhHWm9hdk5hRkpySGlvd0h5TG42LzJvTU9pRzdTMktKb0pjTmlk?=
 =?utf-8?B?Nm1ma3NucW5CTDZaakhEL0duT3BKMHRPMm9EUGpzSS8zRHYwS0d4bWZoaStX?=
 =?utf-8?Q?qQ4Mwt?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SDdWMXUvdzdkNDhOMDNleVlEdzdjZGZIcFVManZEZXZHaTNzMXgzdVM2UzNC?=
 =?utf-8?B?UVRmYlVadzJLNGNVUDVMYld3NHFZWWdhczBSOWZ5UmxMbTR2NHBXVWVzQVlH?=
 =?utf-8?B?SlYzckowRkhxaVhtMThoVmFmdTEzcEswUjY4T1RLTzBjL00yME1tN1dwK1Fj?=
 =?utf-8?B?ejJtRVd6b0lZSkdpMWxBZmU4Qnl0eWE5bmJGVXZBTEljOHpUTHhDdjFmNFlw?=
 =?utf-8?B?T2tHV3l2MUZ5ckE0NmNwQkhmUmNWNUFIVG5FTnJhTWNBMUhxNkhYSkQ4bEND?=
 =?utf-8?B?cHZnTjd1Y1VENHlSY1NsOXdEMm9icjRXVDlRbTJwYjhDN3FZRDFaaUlqUk5l?=
 =?utf-8?B?VmhQdmppSFJSN3pSclJiVnZ2S2hPejVMN1Y4QUdLL2I1a2xjamlNRUMyaTlx?=
 =?utf-8?B?bHE0VlI1ZGxTcnpjMjlEd1hSRlR6c0xuMEV3R3Nia0t1MXgzNUU0MS9hT1Jv?=
 =?utf-8?B?TytabFFyK2ZGdG9WRm81a0tBdU5HcEN5QkNoMnFIazdNKytUeHI1RDJDNUZG?=
 =?utf-8?B?RlZKSUtTaWs3dTJOWnk5SEJzSTNhM09rMW5YRVg4ZWZxNEFLTllKYlM2c1lI?=
 =?utf-8?B?ZlFsaE8rTTAvSEo5aGlOUmFoZkNZS2RrQU5Ud3JWdTFQVWdqM3h1UG95a1lN?=
 =?utf-8?B?azloSGoxelpEb3NTVWxKaVd0bnRQRU1Dc1ZmbEQrZ0R4WFg3djRzb0c3Tzha?=
 =?utf-8?B?eU5lMkRnTHZpYjk3bHgzUWNVUGJwUlczdVpqVmx4YkNQLzZPU2pjVUxRWjhM?=
 =?utf-8?B?dXpSOWoySnQ5YVBDamZZSFQ5aXJ3U3VrQXQxdTZISjJpM01MWTYySHFNMDE2?=
 =?utf-8?B?UkpIU0dKZGZpejZzU0xKV29UaUQxU2pNeHJZeXZna0M0M0xJdGtzc0ZzbEtG?=
 =?utf-8?B?YVlJZ2RyNWRLUkxRNlFiOVdZVHQ5WlZuYjlPenk3TzFPd3RxVnMwSkg0Q3FW?=
 =?utf-8?B?YVZrVHl1MXhKMkdoaGRINm02c2NpQTAwcXNtN0F4NTRhaUhhanpPSW1QaWJN?=
 =?utf-8?B?QWF6c3FzUTRzcUl5cnAxNHhaK3NWdTVTRlpvVDdyOEl4VllVclBVS2d2QXRS?=
 =?utf-8?B?c3VuODhuUzdSb093d3lUUGNocWNFdCtRTGFsOUpXclk3b09kdXA2YTJCZ1pQ?=
 =?utf-8?B?c3dlQnd0M1ExeXdvOVdhUzZNVEtjY2YyMHBhcm5TeHkyTjNrdWRWMytWb2lJ?=
 =?utf-8?B?Y0VXbG5zcWlndTdsOFFUYkJobHg1MlBUU055b3RUT0YxVFM4MVRWd0tRYkc2?=
 =?utf-8?B?SG5DaTlOZEJvd05KdUR2SDhPbk1FRWxtZkVqVWk4SUNTM0NKam1FREV0T2NG?=
 =?utf-8?B?dXdJbTVzWlFjbXVpemVVRXlLc011cmNtbFAxYlhlYlFGNjNXVk13UEJrbjVD?=
 =?utf-8?B?c0lReTlXb0JNaUQ0TTg2dnEyaCtjaklsZjJabk91eFE0Q3FtMUlUM3R2NVlm?=
 =?utf-8?B?TFVVK1A1UkhxNzZSYTVTdkFGRlNzQ2MwUDlLa21vckV4T0RFYW5FNVUxNmpN?=
 =?utf-8?B?ZVh0TGtrdlhlZEFZVXBtUXpSUUc1UUI2a3pCaWx2c01uS0hIRUtiWURKRUJa?=
 =?utf-8?B?dTRGM2FQdUUyR2Z2WUx4aU8zN2NFZi9RL3BMSGdDbUtWSmcvTFJaU0JUdlZy?=
 =?utf-8?B?WDBHSEpDMTllcmtVM0NaSnRYcVc0VHVtWjQvYlV0RXRnbGZ5Z3Z3UVBkeElQ?=
 =?utf-8?B?OFU5emNZMjR1NFRtOUcyVSs1alUyL1A4WDFDTGQvVTFRTytsaWRQbUZsaFVv?=
 =?utf-8?B?NjBoNkplWlppcDYwbHFaeXpqU3I3ZUdBTzRQMHhJbmpxT3BiRktNOStEdkZm?=
 =?utf-8?B?MC8wRmpuUnQ4cnpQckZkWDBsWDZLMWR0eGVML3ozVDlTQkFXdWZ5V1pzdS9R?=
 =?utf-8?B?VlJXRkh5QzVKNWtWdjRHTW8vd25rVmdGb3ZsSGFKZ0craGdmeXVMc2dlQVQ2?=
 =?utf-8?B?VUVDeXoxVVZuS3BJV2kzT2UyU0VOWnhpTlpNOGZCby9aMWltVUpKamt0UFdl?=
 =?utf-8?B?cVdENVd5MXk4TjhvaUprblZRdkhpSDgxREJleVVwR3FMdmhzVTdlZGg3YTlD?=
 =?utf-8?B?cUl5ekhRTmRneGpqOTRNd2RnL2lqWlQvR2VKTW1IN2d4RkNuWkNjZ1U4bU1n?=
 =?utf-8?B?SnhEeDFaYW52Sm9QOGpvSEdEOWhadGZCVVp1TmpPMURGZzcvbVVIUmF0dTlt?=
 =?utf-8?Q?It7mUeU1P4lOd17ASgZvkDVjehAdlw1rRt1/nazLiJXx?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D2E3DCA5CD42F4FB35965C04310F0C2@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9baca1d0-4c0c-4775-14df-08de1cffaa06
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2025 06:42:32.7771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jiiQHSt3Uh+PMjOUawXrowMIaYZpe1HY0eXBdcnGghw2mR+bdTBUS9OM8hPeB/P0cuHIRMqZTcz+B9jWxkW0kA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7313

T24gMTEvMS8yNSAwMDo0MSwgU2hpIEhhbyB3cm90ZToNCj4gVGhlcmUgd2FzIGEgc2luZ2xlIHVz
ZSBvZiBrbWFwKCkgd2hpY2ggY291bGQgYmUgcmVwbGFjZWQgd2l0aA0KPiBrbWFwX2xvY2FsX3Bh
Z2UoKSBmb3IgYmV0dGVyIENQVSBjb250ZW50aW9uIGFuZCBjYWNoZSBsb2NhbGl0eS4NCj4ga21h
cF9sb2NhbF9wYWdlKCkgZW5zdXJlcyBub24tc2xlZXBpbmcgb3BlcmF0aW9uIGFuZCBwcm92aWRl
cw0KPiBiZXR0ZXIgbXVsdGktY29yZSBDUFUgc2NhbGFiaWxpdHkgY29tcGFyZWQgdG8ga21hcCgp
Lg0KPiBDb252ZXJ0IGttYXAoKSB0byBrbWFwX2xvY2FsX3BhZ2UoKSBmb2xsb3dpbmcgbW9kZXJu
IGtlcm5lbA0KPiBjb2RpbmcgcHJhY3RpY2VzLg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBTaGkgSGFv
PGkuc2hpaGFvLjk5OUBnbWFpbC5jb20+DQo+IC0tLQ0KDQoNCkxvb2tzIGdvb2QuDQoNClJldmll
d2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0KDQo=
