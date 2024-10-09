Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEF33F8F7
	for <target-devel@vger.kernel.org>; Wed,  9 Oct 2024 01:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728438291; cv=fail; b=rHGpvhig6u+xhbK8iEUjuFdaunCOs7RZ+1Br4N4CXn9s0jVDMC2gRYL2M6G1rtY/UIynEYjgS40buln6MKIUNRqK0ngxRErdntyb2uUSMg2U5UKnr1aSfUOvoxx9n9P04mID1IWkpj3/X+6XZSdd8RyjKWtccJ9cdFLBK2tZaM0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728438291; c=relaxed/simple;
	bh=rmKRvZ11LRwUhgWP4SEc9HBWQKlgrSDrm7ARdHtPS8k=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UqFh+H2Xz4d+4kpQbnhENmON4vGzillINU0NDJxaFa9lEuvgespUZPM/ApWhxgFZ0iVvbV8DDRqM2O8kErJfIyUIKnAGBEV/vi23cjrE+pyK8qFbh75yvs8BE0IqkKfOxS+5zbQ0NUvHu4c0CYUC1VCmC0+KJYdgWTBNsa/8Z4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GKtDX03m; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=erOliIDK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GKtDX03m";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="erOliIDK"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 498JteGQ015086;
	Wed, 9 Oct 2024 01:44:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=rmKRvZ11LRwUhgWP4SEc9HBWQKlgrSDrm7ARdHtPS8k=; b=
	GKtDX03mNxhbM0OoYTbIBSKz0H2L9sRldpKzW3Vz+iBu5K/hvDmyvBcnHV0FYXdU
	xZefWu8a3YYj90qXn6V9Qz2ETfMwCiCTFp4ygRIMHw4+svJHEDg/aZSdcwLR0bpz
	K72OFkyjihXo1ru6YpNoWmw7hNzpu/JfcadC+cBe/++9HiLYT3uLlCBNxey5LoQb
	ELLnVhSsPqFkQK04vhHYK/d9h5fT7Rq72ZNrBVDL/TFYfuyqpX527/4cdT0KaTli
	JXTtEFpKkJpwEhoC0weCwS01mzuzzPDvxup4kK6UBlqxH1lOe3Y4/7OK8kBcxwfB
	k62s0AtD2oV7kHjlQLVLRA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42308dq562-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Oct 2024 01:44:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 498NIodG022971;
	Wed, 9 Oct 2024 01:44:43 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 422uw7xc08-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Oct 2024 01:44:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cA360Mqq7z4EZ2i5z+lWo/fXKMTj+s6eWK7yMuEVqt3tbqh3gH+A70M34X8ou7WBRGlYWWB7pkxP/ukJAPMESfpNIyiuhhqeFarHX/BbzBBcWfCSa+0l/L3W8dHXtU42XhWWE9m1yBUfFgMJ8LIn7gvNB1imVaG1/WEtsbnPndfmucm8BceVpEI+x8w7tmdQoob6eoQJuKrg0kYLeOrseubN7J2WLHNNsqNzoUy+AkouxjdSSBVubgQZyNK9FHrsa7ngz0f4Zzx1OJM6BeDOosVpn8UdBkhbQB7eLkEL2Rs9ZOBJUGuMcnENleUJvQRw+x5vYn5GxPPce9t4yaI/VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rmKRvZ11LRwUhgWP4SEc9HBWQKlgrSDrm7ARdHtPS8k=;
 b=t8Z7Uw9tvVHC8U6NR7o/1kXK6WrzMh7w3nDoRIc8ZvllsvwzJTHnxGVKn37kbT4AbwAZT3xmI5vsGlK2lJjWDVf7PdG3ATq43Mkhflxlp2Y8CsIfWv0HtfZJ2jOsVvM+jufB3IYgMnOeJ0yaRJbw8Cn68cIH++S0tP8jD4QJ9WcIPdJnJ8lKvlFfd8CN52Ye8Q0DNx1X6b5GaYS1pW3NRZof6D4itG6ncSFoy4TddMSOwqb9QdV8OczgL4BjCebH3dxAXKhFe6lQ3MSR+HTEwJXUVXA7NOf5gnEzxL1xzvC5nYM3j0rmujbPV3atDZ5EFq2XM7s2J5Bvv3onpXRiCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rmKRvZ11LRwUhgWP4SEc9HBWQKlgrSDrm7ARdHtPS8k=;
 b=erOliIDKZauAJtSOqM3yTincoADnRZFjyE3bldPQn9DRP/RJGgYq5lxA/WHtawsmp4ewbLSVHtezmqpq4CaTobanMkLIoyhJJ7cNYzsBPOlU5cl70jxa9PVwOofySwkT30/gvapThYWDsMghiY8FOkOoQe+CK/jWfkKPvF5JZ1w=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by MN2PR10MB4288.namprd10.prod.outlook.com (2603:10b6:208:1dc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.23; Wed, 9 Oct
 2024 01:44:35 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%6]) with mapi id 15.20.8048.013; Wed, 9 Oct 2024
 01:44:34 +0000
Message-ID: <9e67ab6c-f23d-469c-ac36-8b540fb62e00@oracle.com>
Date: Tue, 8 Oct 2024 20:44:29 -0500
User-Agent: Mozilla Thunderbird
Subject: [PATCH 0/8] vhost-scsi: Memory reduction patches
To: stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, pbonzini@redhat.com, target-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <20241009013839.88593-1-michael.christie@oracle.com>
Content-Language: en-US
From: michael.christie@oracle.com
In-Reply-To: <20241009013839.88593-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0230.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::6) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|MN2PR10MB4288:EE_
X-MS-Office365-Filtering-Correlation-Id: 549b7e5c-7635-44b6-1725-08dce803ed3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eUpKbU1jWFJTbVM0eVdobWFZRnV5MG9Hc1NOYTViNTh5QUhMTUN0S0dzc2Jn?=
 =?utf-8?B?YXVNa2tUL2tqeVU1RDFpQmo5UUtObWxYK1VVZVM2cDFOUkp6MnRoUDhoTHpt?=
 =?utf-8?B?OTUya0FRL1JiYmViR3VLbWoxdUNYcWJqV1EvYU1aQURrdGVFK3ZTeFRPTVFs?=
 =?utf-8?B?UjhETXVKZnN4ZUZuSGZPall2eVpDVDFsQmxHT3VvZ0s5NHlPV252VWYyanZj?=
 =?utf-8?B?QWs4R2plMytsV2Yrb2lVMTU2WlJFTWorY1dFZWRSREZvM092UmYwREN2UUdP?=
 =?utf-8?B?V0J2OWh4b3FxRStGRjVva2ZUa2pFbTFwUDVkeUhzYk9wMTR4UTdMSnJjbG5w?=
 =?utf-8?B?ZFBpNmMzYzVmbjNFeHZjeVlVRXgxRlphZFN0WlB3cXNmaUdSQmZta0xWdWxl?=
 =?utf-8?B?QW9UNTVxSHkrdXNYZk9XaHduUURqRlRGYnluTlVDeE51dEd3Z1JqVTdscTBl?=
 =?utf-8?B?RFV5R1ljTXI5T1czTzdyK2xEM2luZHUyM1lyQlZJSWxsb25RNDdvby92UEc2?=
 =?utf-8?B?ME1RNDRjcUo0dU92cERWMENvTTlDT3RlSDBXc2lPQzJ3UWtFSW84MlZtM2hr?=
 =?utf-8?B?MU40R1c3ZzFqYUh2MkhrWllWdENRUjd1Um44cVZTWnJrbDFyd0tXd1Byd0Qr?=
 =?utf-8?B?cklmeHltck02aFgwS0Z4RUFRUzFyM0JSVzJHbFk0aEVpdUNOeXpDSWdBSUE5?=
 =?utf-8?B?K2RCUTYvTEhiRmtYZE9DZitqVTZUcXFxbjNDeVlCY0ZIQTVMVS9lNmVnOEZU?=
 =?utf-8?B?cWNpMURHNWZGWmtPNmh0RkdSYWNPMFJac2JyaHo4TTdQWVo2V0NudytOZlZm?=
 =?utf-8?B?Nkw1b1h5Qm5BL3NHaHg3bjZDUE5EWjVtNXV4a3hhOU1jL1BETzVhdXB2NjFy?=
 =?utf-8?B?VzBKZGlIdW5qYUZxaFFvZWVQWURSWnd1OExBZldBQTh1WEl5QUFUOVlLVEFr?=
 =?utf-8?B?aHRhZldzenV4c0NZWFNjdk1FRW5LSkErdjBrSE1ES2gxYjE4N1F1WVNnNUFR?=
 =?utf-8?B?UW5DUDNQd0NDdVBmdFJoa0ZxWEJtUEtWSmxLcDRRb3dCY2JSeUo2ZlBOekRt?=
 =?utf-8?B?UWp1WjdxUEliU3hIZzZDNm9ISzk1SS96NGRkV2xvckN3Z1J1N01qb0hIL2pm?=
 =?utf-8?B?ZHNhMlNybG5LZ3lPck1SYVVnenVYQ1NmQzU4SFdXVkRWSkNLc295S3pIeWxi?=
 =?utf-8?B?QS9TUGZBUENwSXpBMTZLZk5jaFZ0VHVVcklObWRGemxQdXdYcmpFN1VVNFZG?=
 =?utf-8?B?THBDNFZwdjJPT0VyV2NhSXdiVEY2V2t5Ym1BN3JrSmZFWXNLUHlDU2M0UGNx?=
 =?utf-8?B?eVBmOCtoQjZ1ckd6WUIvczNwSnpSbGVSUWM4ZU9RNGZDVEhubWxPTUpIQ2hG?=
 =?utf-8?B?ZW42UCsvT09nZFo5VFl4dkxaWmtvZFRoM3FzdE9jMm9YK1dnTWhOOGp6U1p1?=
 =?utf-8?B?NFoyYVZxSGxxM2xucFRuc3NnTGJNMytIaXFuWTBTTm5hZzR6bWVYN095UGxI?=
 =?utf-8?B?WndmUDJ6a1NTVldqcDFRazFGSkdHYlNtQTNuWEVoa0ZMcDFrR0M1Y083R3NM?=
 =?utf-8?B?Mm9DNTlpbGY3MS83Mmt3aEd3bFlSbXVqYXFTZnduQTN1R0dvcllLazlmdHF1?=
 =?utf-8?B?Q1NSejZVWU8wTnZJNHJ4aDA5a2tJUExCVHR3QXVUcHhRL3g2N0RFQUFQM3ZO?=
 =?utf-8?B?WU5tZmIrUVNHazIwL2xJMGczeVM3c29ESDdTcUVhVEhXU09KOENSR0xRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVFGRjVybEZhM2w4NW9Va3MxWVp5V3JXck9qWGRQMTRFQi9kTFA4OTFoc0xs?=
 =?utf-8?B?eGROTUE5WmRBYzYzSEw2U3JXbGRRaXg3K1VlY0d4NUh3VTJVYXpjVGFXYmxj?=
 =?utf-8?B?SWxUYUhBbkxFM1BMS1UrVWY5S0FnYVR0TUZKMDdOMUxSQWFBVFRxS3FxZHh6?=
 =?utf-8?B?cS9UWVltWUIrSnM0OVZTK1NEdFJla1ZFYk1UdWRzUlcyMjBNKy90ZHZSclJJ?=
 =?utf-8?B?ak9KQzNTc2xQR09mS3NkbWFhL2taRHR0aThKa2tnWER4QjNkVkVydXo4S3pM?=
 =?utf-8?B?WVIrYjZ2WHpsaVZ4Yno1RlZDQi9Lekl5MnUya3UxTDhUZFVWVXZhbUthSXNC?=
 =?utf-8?B?Z250Ny90S2NsSE9Cb2hNbTA2d2k2dzlWMGFRRWVwQVk4aGsveVVLb3BDckl3?=
 =?utf-8?B?UFkyVkJpUnNSd1pkTkpqelRHSmxPeGc2UVJ2L1ZxTVNoUXJLYmJJaEhwTnFT?=
 =?utf-8?B?SjZ1eG1vWmh3OHdPWmM5RGhNaVZ6bzZWYkYzbEZCY0IycHZzdk91Y3BENGxz?=
 =?utf-8?B?L1JzOTZEdzBleGZFUFU1UTlTRTNOSUppYVB6V2lmNTZRY2s5bExRVXViWnBh?=
 =?utf-8?B?Wm5NUTFKenVqVDhobXhOY0F0SnltM2xnOXRmakVDUi9pcUp5REtmMFhCbytM?=
 =?utf-8?B?Z1hFRXZaZk5taTRFeVZ2VjdySE9IaWUzZis0YUdoOE5sSzlidWN4ODNmbFlo?=
 =?utf-8?B?YlhSVEdXTm8vYW5FbUgwdDNsZGJWTFE5K05uRXRZbDRiQzdIb3BBLzZzbGZ4?=
 =?utf-8?B?S2RhUUFOS1VLL1VNOGZmRFlrWSt2R2pld0RrZEo1VFVldkRmcjhzWkVnVHJF?=
 =?utf-8?B?dVBkSFlvdWgxMkFzOFZTS0duUFcwSmQrZU9XaXB2dXhoZmxhZlphdmhqRk1B?=
 =?utf-8?B?VE5jVnRsbzcxZk9aZUR3UkdVSGxWNVp4T0F6YUo1QjY2OFdNQmczbHNrczMv?=
 =?utf-8?B?Z1lQdVRYMjJDNU5XejdRMmVrdml3OTc0TEMraVRxV2l5TzJIYWFuV0dIL3Fu?=
 =?utf-8?B?T2dlSmxHVVVDTjI1TEZqN29waWdRSkE1ZzZsOEhIZGZuVHRwSTNJMG5vSnpD?=
 =?utf-8?B?cXFjZDg2VkdtVTR2WTUwT2lCaGhTaFVSREZGZmFneEI1d0NiOUlQYi9GRHJq?=
 =?utf-8?B?WGppdzRjd0JGa1hLbldQSDFqblpLaTc3eElpK05QY3B0c3RmL3V4YjJ1YUdh?=
 =?utf-8?B?Qkk1dHFVajQ1eVFaRHlod0cxRUVLeEt4NmNmekpXL0FySGlkUUVFQ3VyYmg0?=
 =?utf-8?B?MWtFZ2o4RFlqMGw3NTJ3cGg2bCtvUEFoaDJBSDkwWXFMd3FQT0crRlpYV2JC?=
 =?utf-8?B?OG56TVg2Um9mc1ZoRDVyMi9PVmpyM0c2MEVKOElIa0tXelVvQXZNN1VQU3VO?=
 =?utf-8?B?eHJtQ3ljZldBMDh3d2hUWklZQ3Rvb1lnMHM1NXN6YVRqanJ0YzFqVG1SYVhS?=
 =?utf-8?B?b0ZqeVJJbXRYQ1cxSGFGUnFOVE9ubFRTcjR4aXdDSUI0YWUrUWlwSXZYcytp?=
 =?utf-8?B?ODRML25sV2o1NHVJcXA2UWtTcWpqY2ZwYW5jNlVBMmVJbE5XeEJpMWlMNk03?=
 =?utf-8?B?RWdqbDJvYWFEc1JKalQ0RHJ1NnB0QllXZW44OGN5R05zb0xEd0diNEc0NkNh?=
 =?utf-8?B?VWp2VGF2QjZSdU5IQWZtUHBjOVFIZ1JhTk1ZT2NEa3Rrdk9HbWRIeUdSWk04?=
 =?utf-8?B?Z3lodGZic0EwRVRqQWJYM2lGRGhBdHd2SHBkQlg3VkFIR2hOYllCc29TeVNS?=
 =?utf-8?B?VXBST1gvMkJyMkVWWEtiOWFZTVg4N2gzUjVrSmprbXhrOEswbk5IbjhrNXZP?=
 =?utf-8?B?emk3UUF5SEV0cnNLRkt5VXlZUjR0Q1FmT2NoS1FoOUR4Sy84SitQSXJqSEp4?=
 =?utf-8?B?SkdCbE92V09tK1lFbG50NWsrVThuYTh0T0o0K3NRMnhabjl0OW1GTXU0dHM2?=
 =?utf-8?B?V0srZUdLc0tGZUl2a1JvOGNzYUlyV0dUcWtsdHBwYVdOZDBuVjZ6RHpVNEdp?=
 =?utf-8?B?ZFFFMFkrRjNoUFBraVBDS3BxeHBNN0NUYXU4T1NYR2c1VFlXcVFmUFRId0l2?=
 =?utf-8?B?U1l3Yi80UmJFN1ZQejFzZEhLZ2FVTkdiZy9uSFBzUjQwOTVsMDRRdVQ3TWRw?=
 =?utf-8?B?MmdKOGdKM2ZqRGcwWXpCbEU4Rk9IaHRTcTE5d3JBdVlmSDJNSTZxR3NGZDVm?=
 =?utf-8?B?UlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eCxlyb8+UdC3PlP8lj5gZhLNcrQFEFnCs7ebPbjtRgM6PPvZtFiQzG0ubPY8FG2/Eq7UOm8NYuxbrzBATnhnd9gfk/sA3dStoYCI5FNIkUILbuN43m86f1YU02+6DqRTkk5cRjAmLrfjapMMKWzZDmpwUVE3oqYu6XuL9VC1yCB0pMk3iVuF8Qw7+5tf0n5ffWGJD0zY7Rv4nZYvzkfKMZQ+8aKAvOrDSqsGnWk6j9A9KJBD1+dAD7fRue1KXCQAxxakcTgOBooZwSRHQaSSoBMmyO3DLytRnT5KI0VWfCwTsGMi2im0gxukAZy7nyEYsDXMYXPLcSNN69oppvp+EnMr2vpqD9fuSXzadzgYo5uB7zxLAepIZ9tgueP1IVym7KxBdM2P8+G7KsvNfzcUkNVnEuwPVHsOYij7MbwnCCwgdQnOZKJgcBLyFYE367CQ59S9bOLdBhXm/jbN/llJ5jpzDyp5TD93tn4v99DAYCuJPYLHH4ymzlIHhs+NfiteOWPH6x+96217NkwW/f2i/oYIF8OOXB2oKQk5OpcF7+kw3m3lfaZD+4quUZ46X/EzT4p3MKJWkjiYwmCoU1CKarookh/yiq/YydiT+MqOb10=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 549b7e5c-7635-44b6-1725-08dce803ed3b
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 01:44:34.5640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WR6SGbbpWUxDgRQ821TjJOs88XEHK7Wb+t2jRkPo+raVOydNeB+jlZSz+oV9zFun6KmsXyn5P5OAbrXy2poiJnRyefwdU8jAlotdccpiHzk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4288
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-09_01,2024-10-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410090010
X-Proofpoint-ORIG-GUID: bhLT7ntAELZmQwLkL0BBdef3tmgaGvpB
X-Proofpoint-GUID: bhLT7ntAELZmQwLkL0BBdef3tmgaGvpB

Sorry for the bad email threading. Forgot to pass git send-email
--compose so responding on the first email.

The following patches were made over Linus's tree. They reduce the
memory use for vhost-scsi.

For a simple device with 1 queue and 128 cmds we use around 25 MB. These
patches allow us to reduce that to 8.2 MB when supporting up to 8 MB IOs
(the current passthrough max).

For a more complex device with 16 queues we use around 2.5 GB. These
patches allow us to reduce that to 77.1 MB when supporting 8 MB IOs.
