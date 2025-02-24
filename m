Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC5120A5D5
	for <target-devel@vger.kernel.org>; Mon, 24 Feb 2025 22:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740437631; cv=fail; b=gJclmAgeLYt2Z2KIXcMxp1HiPYj6V6NHyWf1nDBXC3zGh40PI3OW5AsDU1MfxYavC1giNwgkg+H12dEN4o36o6SmSW0lKWdJ4GIWaoF3P+7/VkZTRQJlKwMz3BIcA7WNOrHwG+FslhmlGv4AMP+78KuUFgaOhPKul7pXQQEW/2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740437631; c=relaxed/simple;
	bh=6uQGmS1etdPbJGyDFyYxYAlA9XSil8pOXKzZbsYDLEw=;
	h=Message-ID:Date:Subject:To:References:Cc:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZA2L5RoZtKSrE8jpZ44OaRSBrC7LykhBnOUvwdtxUx7rfhtRFZMiW12ySHG/2Sf4FlSLxsI4ZNnhxWuC/Iuq2dLc9EY8OapXxA7kiqNuqlkvKrsohbalazmias2GkhJm3fy53CGm/5DRtgOnbALCeEaSqIi14RKEgcYUcXIhQw4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QB+VcQjV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zCtf1YvX; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QB+VcQjV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zCtf1YvX"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OMKO0E031497;
	Mon, 24 Feb 2025 22:53:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=m1kTG87FtWjz32u/GUTfxRo5c8xm2F2Ks+zIayvJU38=; b=
	QB+VcQjV18802VBiHM96b7J8+wzpOn7avfVGPTUGBARCphUU7dKCXgU3CSQt3Zzg
	hu8XfoVGYQossmxy8JFxaq+TikkmXy6slxiKcfByy9r8fPMT6wO9xgaDKBDm1Uvg
	/KVtNaUcL7HaSD28rJDayKezwp6xfGVEnjqI5xyJTlNrPYzutSrGxaGwKKGcPPHT
	nZ4l0FLr07dBt6ob2Xcj84xtTgrg6Z17mWcwjs1WrHBUAawXwmjGpOxK4NLNUcVZ
	N/luLH5Bx2bYzN+c9A14zAwIiYh/ny1WPBAxMlncub4DMz+iNttNas2taW3EAHSL
	AkKBrqW0MH1t6TFEJELfJg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44y74t3rt9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Feb 2025 22:53:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51OLtARh010247;
	Mon, 24 Feb 2025 22:53:44 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44y5184gav-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Feb 2025 22:53:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PN/h7OetLQWUBaOSrFBE1BadnTk1ROnntzv1By8VGB6kF0w804Ad8b2+/wIDNklXX3Ieb+FNCVpUuidmUHtLmLdJgVo1DCPVR0q2OkbOxy3WTyHUhWovsv1lmiP8RCNI+OTOHo98XdIORvL5h1k4lTYVF4A98b34yJyBTzOSKV5wI4NL/qZjpOb3F+UfJqhqttPhboHVsC2wePzKwk3DTVVrY+cmjpg8SS2pVUbBYgIo8pengRq7+IJVlGLdhQsVoLHgnzLi4bEvNEC4XftJLhTr59X72b3vRnSUwBwGlzSiKZA0ETh/UdvyyNdCqR7lWd6cLGiaO0S9GJ+GLHqoUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m1kTG87FtWjz32u/GUTfxRo5c8xm2F2Ks+zIayvJU38=;
 b=hXSA2wj0BHZazI7IFIBYO0aFrVBjPCkxKTlTT8rEDCEA1cs433eMcA2fZokpBzHEnblWK1MAvBiaB3T3OtrW+NjG8PcTEmQ69Rl76eadInjIxWxa5ayoPwJTg0HpOcsgYqI5b5UKWYCY3XaYnn9CBSru4XxoMI+vYrcW3MuaRptjnS1MQpH+l74sw8B6k0vhouENPXNJ6dqTD4h48sZLkcXhLNHpE+tkwxXeJdVcsCFDDfpCe5NDcEuYviUUS7ukk3ccL39T8lBDCCUhsxdP+iBkIXRyxChFXs7xxMrjQlQ9WjZaEeUe4zGHZt81Ii3oWl/Xub7KpIoysgLosgdShw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m1kTG87FtWjz32u/GUTfxRo5c8xm2F2Ks+zIayvJU38=;
 b=zCtf1YvXpKymxC9Mo1fQnJe/zKPcAZSihX9wYYnDvgI/IPTG3KDboLpR+SJK3VDFXSX2Tv9jtewqtTnizf1b05PnaEdluzRsCiKp2EEyxNVQ+Yd9JBgQVzmZd002pYDPdXV31pmtJFoYa04Umyce54dgfEQ5Zlf5FipLMPShBNc=
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35) by PH0PR10MB4711.namprd10.prod.outlook.com
 (2603:10b6:510:3c::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.18; Mon, 24 Feb
 2025 22:53:38 +0000
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f]) by BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f%4]) with mapi id 15.20.8466.020; Mon, 24 Feb 2025
 22:53:37 +0000
Message-ID: <872478ad-8729-4bde-a172-dfb7c2f5407b@oracle.com>
Date: Mon, 24 Feb 2025 14:53:35 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/8] vhost-scsi: Add better resource allocation failure
 handling
To: target-devel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Mike Christie <michael.christie@oracle.com>
References: <20241203191705.19431-1-michael.christie@oracle.com>
 <20241203191705.19431-4-michael.christie@oracle.com>
Content-Language: en-US
Cc: stefanha@redhat.com, sgarzare@redhat.com, pbonzini@redhat.com,
        mst@redhat.com, jasowang@redhat.com
From: dongli.zhang@oracle.com
In-Reply-To: <20241203191705.19431-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0002.namprd21.prod.outlook.com
 (2603:10b6:a03:114::12) To BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2068:EE_|PH0PR10MB4711:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a8d1319-5705-4c81-f8f6-08dd55261312
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dDE1VElqWGlBOEdkVlkzVlQ5OCt5RVBQVTRKYnNGamVudEdLN0cxU3Y3MlRQ?=
 =?utf-8?B?TmNXY2pkUnM5R20xVTZiSksrRXhRWnlOVkYrS1dWSE1jaWxyQjB4VlNvUUMy?=
 =?utf-8?B?dFRUSmNYMVFlUTR5M3hObnRUMVhTNkxQRTBKSW1sbFk5Y0cwaDQwYm44VCtN?=
 =?utf-8?B?Ykt1VWJpSFkzdEVXREpHNXpacjRSL3BBYldwTmxqekZaZ0l3VzdadWIreGU5?=
 =?utf-8?B?amU4c1hBdTlsUHc4d1pXUXFyeUE1cFVlWS8rQkk2ejJtbWQzL2Izb2cxR09r?=
 =?utf-8?B?ejNaTGlsMzJKVyt2NEtUQi9hRzZnTjVSSFc3WEtxb0ViQndNTUtHcnNjbzJu?=
 =?utf-8?B?cUpYY2E0UStIVnhnRHlXYklwMFBRS2puMGtSSlVzN3BoM2I3WUdYOTBXQits?=
 =?utf-8?B?OXBwakFlRTFhaHl0VjdNWVFuZStSYzJlTlE3KzkwblZ3VEczem5mOE1pZU9v?=
 =?utf-8?B?dlVNcTVYRDNsN2tSN21IdXRnYlhBVE9DeTRkUkZlS3Q5T2VUN282Z21BTVVC?=
 =?utf-8?B?MHc4NzBnR0hNVFFiUFBIc3QvY2loRTRxUlpWOEVPT05TWUl1ajZzaXZWSlAw?=
 =?utf-8?B?cWJBOXRVNDNjVFdjMWp0bWx6cDBlUXp1aXNLZCtJdUJJVUpQeTZDTWFUVGlF?=
 =?utf-8?B?dUJRYVVHUkNLWmlJOXg1djFhWUhEeWY3TlVmTCt0cEVxemlCWUdIM0ZtZEp1?=
 =?utf-8?B?aG1xakJYVWNjeUd5N0xsdVQvd2JBK01GUEduYWtEQXZkeUp6S0lIcWlnbEhT?=
 =?utf-8?B?TlBUNUJ6OE5sMWdtdytoenNSMStpaEYvSmRlcmVsM2Jtb0hhdllsWW1aYkZa?=
 =?utf-8?B?TmY5V2tRQWJ1cTh1cncxUzdrSjhiTjVqZElGVzQ5ZVFuYWRrc2padVpGeWdy?=
 =?utf-8?B?aWlUeWZlbElqVnJtZlFiRHBjN0dVS3dPUlVRRW9Mc0xMdXRJMkFlbkUyOU85?=
 =?utf-8?B?a3BmdTVUVWhHdzVqY1Z5Zk9WZUVOVXNncHJFWUxpY1VYQmFaT2JmZ20yamN0?=
 =?utf-8?B?eDM0U2ZWa3NoYjd0WEp1MTJVU0VzRjB2QUZ2U2ZFZGZkNml3Szh5aXNtWFVH?=
 =?utf-8?B?NDJObzNnVlVmaGF0K0s0OE9ISDlwY244SXEyRUt1Y1pyNWp3ZXl1L0wxdHNB?=
 =?utf-8?B?UkZZVW1CRFlHL3FuZU83bkVGNGpBNGJ3bUFRT1hjRm5aYUQyNStlSnI2ZHBn?=
 =?utf-8?B?cGJ0UHNvOVhDamt1eldGOGVBUC9FUk1BSExIS3RmZDNRUXkzTDRWSWRtbWN6?=
 =?utf-8?B?TElQcERVZ3pPSDRuaEhLdlpsUUREeVlPZkhqNm1aT0lIOXNpQUcxRnpRaFZa?=
 =?utf-8?B?ZEVmclFDUmlRWWs0anBnbzJsMXhTc2hTYTY2UkNMcTMrU2QwYWYzSzBKOFh0?=
 =?utf-8?B?YTREb1BIZUR1V2YwbmxQTjR1RldTS3VlbTl6OVh6cE1JYnBWTTBFU2FXVEtC?=
 =?utf-8?B?amFoMnRrNFhNNWc3NmZxZS9OVFhVOWgzUmN5eVBiTkZMR1huVWpOUUhoZFBB?=
 =?utf-8?B?QkUvMnA4Rmp2UmpNb3o4cmIwRWdCSC8zcjVmUnhRUmNJRVFRVVlET041TjRJ?=
 =?utf-8?B?OVUrblNrUEJSeFlYb2ZtRGpBQzFscjYwUVpaUHcwVmRVb3FCejdYcG1OU1Zm?=
 =?utf-8?B?NytvKzdYUjJTZXFXUjlEUTYrdVQvZkc0dzlvTkxUR2ZkQ1p6NFNHeFRzb2ZO?=
 =?utf-8?B?bkxUL2dsblJJUlNpSWZlR2FCR3RGVmJwQUNvMDJzdE83V3ZKS2N3K1hBYXRr?=
 =?utf-8?B?blZqUHY3Sm1IdlVTakdUbHdoa0h1bjBmd0x3cXRONUErWWFUWWJxZytDYUs4?=
 =?utf-8?B?M1pkSDNubkxhd2NqWTgwUk9pOXpuVHArdkFHUndmbXhwZ2tRU01GazByeHdL?=
 =?utf-8?B?bWFPSVZKZ0dSaDAwUVM1NmRoYnVVMFpsaG9Pdklselc2TWc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1001MB2068.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bjJvSUpGUHlOc1BBWm0rMDJtMGtpZzZISytoWFRjNEQrZ2FPL05EckpteE1Z?=
 =?utf-8?B?RjBONW5HSjVBYUh6NWVtaXMrbjlvc3JMWWc4bEQ3ZVhGdVRBbWpTQy9RYWVY?=
 =?utf-8?B?NHR6d3BDZjN2TnZPYVR4Q1lUMnJZVnlhKzhHaGFtNVBiaEVRSG9kcEp5RHFa?=
 =?utf-8?B?QWQrMEcyUTR3YjhMUVh0L0FyRTNVQnN6Szh0VkpxbGNOby9QTEc0WkZZb0ZL?=
 =?utf-8?B?VE8wY2d1ZzdsQTBOR2tYQmVXZ21qcFZ1bVE3SVI0NGNJNll5QVBZNTMxUURC?=
 =?utf-8?B?SzVCeFluSGYxSlNzc0taUFJMZWJaSWxWSFU4cmxuM3JpTlZlTnVmOGU4YWtC?=
 =?utf-8?B?aGdjc3IrSlN0b2hRaHUrbk9xM1JYNE03dzRHWkliZjNYRWhjWklXSFNvdFZN?=
 =?utf-8?B?aE8vQVFSRDFrdlF0N3gxaFMyaHdad2tyUC9VSVhKaGU5ZnRsanZpa3dxMis3?=
 =?utf-8?B?YldIRm1ZMHVtMExOajNFY0h2NmxsQklEQ2ZpeVhwZGloUnhOTnc5K1A0emo5?=
 =?utf-8?B?dk80RGVYaTBzU29vU29GclREMmRPVGRRM0FQMkdXa2lVWHVKeDM4K1gyNXBv?=
 =?utf-8?B?Ull2cFdJckUvK1BCK1R2Nm9Uc2lvaDBVUFp3c0QwZTVLRXlQUnQzT0JOZ1FF?=
 =?utf-8?B?STFFUlJxbEV5dHBYeFQ1a0gyM21Na1UvVW1GaWpZTGNjdkluN20wcEw5YWVs?=
 =?utf-8?B?RHZuczRvT0gvc3JoZmwyNHBFVFJ6bk5SVkVtZ1dSTmhBb1JGNm1LdG9wSHQr?=
 =?utf-8?B?RW9WOVF1dm02RWt2UUZaMzR4VVlEWE8rNjM5VDVQdi9JNDFQWUhPNmxvOWdT?=
 =?utf-8?B?c3RwZjJtZEJxNDBzUzNlbmJTbzlrSkQ2cFNNWWZVSG85aWl0NzcySzg5Rlhm?=
 =?utf-8?B?ZG13TGlSWkZtNmdrWmdrT1dac1l2d0NnUWJaK0xPTXUxR3NKTkdKNklNS2Zy?=
 =?utf-8?B?SVc3WDJTZ3NQM0hDeDVtMHlaTUV5eGU5WjBQclozdVBveGd3bExwaEloVGVs?=
 =?utf-8?B?SzgzSmx0ZWNVcVA2Yi9qWkJ5RE5wVlRwT1U4YTZOK1N1R0hNTkFlTTRrU3cz?=
 =?utf-8?B?aEFxZkUyZXNuaUFIOWd0TGEyOTBGSys4REhvS1hrTjRiYWR6dzB2Uk14UHNP?=
 =?utf-8?B?MFIwVldkeStBVmNqS1VLY0pUbW8zNDVEczRwVXJRNlpudFhBYWlLZ0Q0bVBu?=
 =?utf-8?B?a1l2ekZUdXFkb1hRMEo4cjRERDk1eng3eHNITjd1bGRWQm0zZWZ5eURaQm9G?=
 =?utf-8?B?RzlMbnA2aG1ORHl5UHhWVlltNGtiUmVnS3lBTGV0MVJQeENhMEpZL3lCUjRK?=
 =?utf-8?B?RjgzRWZaM0xJMnNpMEY2eThPRDlWNHA4U2J6MjQvZVN2V2kzTjFTdXg0Q2xY?=
 =?utf-8?B?NlB6aDBucnNXMERRNlV4OGE1TG41eXFZV1lCNDBQMjNjMURBYml4Ulp4UGZH?=
 =?utf-8?B?UFduYTJFTTgvZ0VXUWh5N3NZK3hhMUs1aDEvNGVNdEpnWXZGYWFJUDRiZTFj?=
 =?utf-8?B?N3NiWjM3RFd1TzhnL01Nd3JkRlBSQ01YeHVrQ21jY0VGWGY0Y3hnN0RRM1Ni?=
 =?utf-8?B?Y2JCM09zQXhOcjVOSEpBYzFBMmpIck1lNXlMRkFydnlTWUQvZ0Z6VDNodzdt?=
 =?utf-8?B?NzdtOHllTXFSSWNBMGVLUmw3NUtGdEVLSWRuZ2xjMS9hcGdUV0trazhscnJK?=
 =?utf-8?B?NDRsbk9pcThTK08yOEFQNzZkeHVlckdhTEptbSt1SDRPaWg5NHR3NUNkK0t4?=
 =?utf-8?B?dWZ3M1NPb3RGck13QXp1bHc0ZnpmQUt2TkNWRU5YL0FISUVuYXh0RTNyZXVV?=
 =?utf-8?B?eHEyYlpUeXova2xTTVh0K0dEUy9TaTVzRFpqSTZjWUV5MEpXdXUwaEN6MUt6?=
 =?utf-8?B?Ym1yQ2xWWUV3amxjTlVpeHlTMlc4NHRPNG8wK1gvZzZkd2V5bC8zckRoZVJJ?=
 =?utf-8?B?VXV1RUtSL2FzRWo2RWtydHNOU1VLZWs2aWx4SG43c0Q4SEdvdkZ1bTU4RXNj?=
 =?utf-8?B?am9RNWNldnhRSmxkMzdxaTVSQ1p5amd4NjNtL2xlTzU2RVIvOHpzWllPSjg0?=
 =?utf-8?B?aGp3UkVPNFZXSngrb1hqYWxCQ1lGeElWNmZzL29MZFdVbjFzUWpkY2VTTkFu?=
 =?utf-8?B?YVZraE1xd0tVYWx3UDVQNW5QYS9SZjBudG5pbVBVWGdvclVLeWVSQmNldkxF?=
 =?utf-8?B?ZGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	d7K5cK//jasfmOfpdRZLYzPb7jJDe9Ow6vdFDL3Jw4blY0QVbfPe9OWSXkV7jT5KFsarAvP66wBiLh2O2pz4FsUWg9Wie238ZEvojUMGO+/LetPMTO41UNeSlBLAmNtf3DlRix/H+ZfMs5/4ticBBO89kYttjHJbvbXAGkz7paDuCNDhfAY+vpgLwRgaSJZhp3YQEsU9mYYJpIbN+3+A29shL+DEuH0HVaFKn2H/c8cKrVpR1+dG+nheUa8OGB9mxO8Go+00FbYNPTO9EOxT8JfRv7ppqgJuhwFT5zgA2GJ0t/hwV1UUi803TyLAh8JzkS6vmjuWI8Nq7d1LuqIwZXm0LDKVyu1gFwIrXQ4Ym4+H08hp7phJBvISMu+uKsvnvaf3zP5vRBBPb9NVOtwvMV06X97rFNQNmhi10xjFcHzRzdqlvMlMD8oX02YNKRd5Pwq8Z21wg9kYkwNizYr5hGzhDZbrtkvhZK+RMvwYOgH5rbGpDGCgqPxL6JOOL+XPwj4lGJpoRjGVJwNpbclQy2b1EzSphSzsaWTB617Hsg4WPs1BvMG89BbcaHPZPYKJiAOioMPNF74TnKMkFAsbdTyFXl5wpvJZBCHi93AvPRA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a8d1319-5705-4c81-f8f6-08dd55261312
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1001MB2068.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 22:53:37.8910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lDyp7qrmGkrH5ariY5vnynOdsF9B9hCJDt9IDUHcIbCTityyWZ75JysEZ0lv6MPnQsARIE5EUQL6dw/Es4RuFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4711
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_11,2025-02-24_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502240145
X-Proofpoint-GUID: g-W-jJAXr2LfGhe4_BQ4lLaOFYSfUeIw
X-Proofpoint-ORIG-GUID: g-W-jJAXr2LfGhe4_BQ4lLaOFYSfUeIw



On 12/3/24 11:15 AM, Mike Christie wrote:
> If we can't allocate mem to map in data for a request or can't find
> a tag for a command, we currently drop the command. This leads to the
> error handler running to clean it up. Instead of dropping the command
> this has us return an error telling the initiator that it queued more
> commands than we can handle. The initiator will then reduce how many
> commands it will send us and retry later.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/vhost/scsi.c | 28 +++++++++++++++++++++++++---
>  1 file changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 99e008219e6c..ad7c778632f9 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -629,7 +629,7 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
>  
>  	tag = sbitmap_get(&svq->scsi_tags);
>  	if (tag < 0) {
> -		pr_err("Unable to obtain tag for vhost_scsi_cmd\n");
> +		pr_warn_once("Guest sent too many cmds. Returning TASK_SET_FULL.\n");
>  		return ERR_PTR(-ENOMEM);
>  	}
>  
> @@ -928,6 +928,24 @@ static void vhost_scsi_target_queue_cmd(struct vhost_scsi_cmd *cmd)
>  	target_submit(se_cmd);
>  }
>  
> +static void
> +vhost_scsi_send_status(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
> +		       int head, unsigned int out, u8 status)
> +{
> +	struct virtio_scsi_cmd_resp __user *resp;
> +	struct virtio_scsi_cmd_resp rsp;
> +	int ret;
> +
> +	memset(&rsp, 0, sizeof(rsp));
> +	rsp.status = status;
> +	resp = vq->iov[out].iov_base;
> +	ret = __copy_to_user(resp, &rsp, sizeof(rsp));
> +	if (!ret)
> +		vhost_add_used_and_signal(&vs->dev, vq, head, 0);
> +	else
> +		pr_err("Faulted on virtio_scsi_cmd_resp\n");
> +}
> +

When I re-base my patchset on top of the most recent change ...

https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=linux-next

... I notice this is the same issue as what the patch is going to fix:

[PATCH 9/9] vhost-scsi: Fix vhost_scsi_send_bad_target()

https://lore.kernel.org/all/20250207184212.20831-10-dongli.zhang@oracle.com/

We cannot assume the response takes only one iovec.

We may need something like (not tested):

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 9a4cbdc607fa..dd9614464732 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -994,18 +994,25 @@ static void vhost_scsi_target_queue_cmd(struct
vhost_scsi_nexus *nexus,

 static void
 vhost_scsi_send_status(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
-                      int head, unsigned int out, u8 status)
+                      struct vhost_scsi_ctx *vc, u8 status)
 {
-       struct virtio_scsi_cmd_resp __user *resp;
-       struct virtio_scsi_cmd_resp rsp;
+       struct virtio_scsi_cmd_resp resp;
+       struct iov_iter iov_iter;
+       size_t resp_size;
        int ret;

-       memset(&rsp, 0, sizeof(rsp));
-       rsp.status = status;
-       resp = vq->iov[out].iov_base;
-       ret = __copy_to_user(resp, &rsp, sizeof(rsp));
-       if (!ret)
-               vhost_add_used_and_signal(&vs->dev, vq, head, 0);
+       resp_size = sizeof(struct virtio_scsi_cmd_resp);
+
+       memset(&resp, 0, sizeof(resp));
+       resp.status = status;
+
+       iov_iter_init(&iov_iter, ITER_DEST, &vq->iov[vc->out], vc->in,
+                     resp_size);
+
+       ret = copy_to_iter(&resp, resp_size, &iov_iter);
+
+       if (likely(ret == resp_size))
+               vhost_add_used_and_signal(&vs->dev, vq, vc->head, 0);
        else
                pr_err("Faulted on virtio_scsi_cmd_resp\n");
 }
@@ -1392,7 +1399,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct
vhost_virtqueue *vq)
                else if (ret == -EIO)
                        vhost_scsi_send_bad_target(vs, vq, vc.head, vc.out);
                else if (ret == -ENOMEM)
-                       vhost_scsi_send_status(vs, vq, vc.head, vc.out,
+                       vhost_scsi_send_status(vs, vq, &vc,
                                               SAM_STAT_TASK_SET_FULL);
        } while (likely(!vhost_exceeds_weight(vq, ++c, 0)));
 out:


I will add it when to re-base my patchset.

Thank you very much!

Dongli Zhang
