Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11023078.outbound.protection.outlook.com [40.93.196.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37AAB3E1688
	for <target-devel@vger.kernel.org>; Thu,  9 Jul 2026 22:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783636001; cv=fail; b=OGKNfjI5EgZN8loEsefLo/hizI5BQ90tIbwXRxfe8xj7x2BQt0aOiK3twVmijaZiEmLNVSJC096Wlw61eIM2GYBGgBz/XlYu6YwvNMrZRbYIdAvA4erNsHxQwZRQUBw4nLs/u1WHBboFMSBmCK+CsFXWX34tXJgpkb0Wl6wI9QQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783636001; c=relaxed/simple;
	bh=WY68Mf98WVKu8rzP4U7+zxnasQd4R4Wo6m8poXloHH0=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=FYL8P4tXYv2PAj0Iot833w7OY5ohKe1i7rreVi3XcN9kA1VxP2HooePayjSx84UtakARnC1tV9oLdIlB2AwthSEd2b98WOuLDvxev0ELZN3tkgPYCJM5teDaRDGmIsZIKjEX8uWM9pNnV7bfVVHt0YEh22xYlAXFv3KbNycgoqU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dunaway.com; spf=pass smtp.mailfrom=dunaway.com; dkim=pass (2048-bit key) header.d=dunaway.com header.i=@dunaway.com header.b=BgvU9Rfs; arc=fail smtp.client-ip=40.93.196.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dunaway.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dunaway.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dunaway.com header.i=@dunaway.com header.b="BgvU9Rfs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TQB9XzSiLbFDtjiak+GxnAotQcxO4lpnRzBepKS9i7269haxFRkmHz1dVYTSJmh/NaxgW5O/6KjRqrnbj74qK+yMMIJJm0rHSeLw5AUiaXAfszB3nHEHHhAHJHxILxns/5hX7+OPAtPE4gCUyUXNKZJmZT9UeY2yRfAroljvWzhCFJyHADfjyxlHHMSgd9YZAdEhy/zneghAZq3SNnwj6XCbja2OvceiuSa8ZxAEt7YqugbkfWDXMjReoZcN63zJec8LhQyLcN5HjKfXNRxI/+NIvynsWaGyD6RR3E96CRFNd9QvxVFz2Ztbmy1whp81Lbb282nCkNy7dGFUz60PvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WY68Mf98WVKu8rzP4U7+zxnasQd4R4Wo6m8poXloHH0=;
 b=C2I+ddanppOqoMyt0//KCBug8ZV0ixws2Bjnr6+HbMBfVifSZFjsxNZBfmSTi1cv4hP6AF4EvtmFECKawL64racM2mFFpMwczNJbDzdCd5janqF1Qo37SLnM9mg1/0p1/5AlXZiQyilROouJ26feiaJ4VtRymbNVu0y3fT8uttLfzJ4VM4wy9OQyNcoFEoB5lwf8Me05TiwqSLAWPDpLqe2KRSolICr0DmY3wrrCnymqE54JIiSKdRb1QGSvb57/HUMkMxyL4F3lhBK/TakzS4QmS1CGtwL0dmzL4WzhYAVTSRbvHghzhnce1CKsjCauEoHM5eLv98Cby7wMfdoVTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dunaway.com; dmarc=pass action=none header.from=dunaway.com;
 dkim=pass header.d=dunaway.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dunaway.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WY68Mf98WVKu8rzP4U7+zxnasQd4R4Wo6m8poXloHH0=;
 b=BgvU9RfssRIfHenEemhtD69QgxeXK6NTJV7lPBbkUy7mBKx7pIbPOsYSb2I2pRn4vgxJDzoD/k7VUu9oN8XH0us4PmjAU6NUIN1dImC/glHO6WMqMk+25lIQMRA4CtnULtmWpF8rbknnKBcBKbS2QUeiW4hqG7gQ3ymv+OzMz+iAzGed3GQSYd3tcCt/PVs//wz+HRApPqTQzy4UbvLI+aED4FGuVtfK+gXSOzzmrlgUaGdcG1rcrHay/SJaUes6S14wbwZq6MqYekH1DmBxnggzFOEla8vf7q7PuAs0FVcL4dYXyQsrOitGEQTTKsTcSfcVyFNC+sWSGIJjQZ5zgw==
Received: from DM6PR13MB3907.namprd13.prod.outlook.com (2603:10b6:5:2a8::8) by
 SA6PR13MB7182.namprd13.prod.outlook.com (2603:10b6:806:409::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Thu, 9 Jul
 2026 22:26:36 +0000
Received: from DM6PR13MB3907.namprd13.prod.outlook.com
 ([fe80::1dda:ff4d:cd0e:f25b]) by DM6PR13MB3907.namprd13.prod.outlook.com
 ([fe80::1dda:ff4d:cd0e:f25b%6]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 22:26:36 +0000
From: Russel Moos <rmoos@dunaway.com>
To: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Subject: TargetCli issue / bug
Thread-Topic: TargetCli issue / bug
Thread-Index: AQHdD/HhZjvWtP/hMkmvQcafBMp4JA==
Date: Thu, 9 Jul 2026 22:26:36 +0000
Message-ID:
 <DM6PR13MB3907DA980830B2383DAB09EDA8FE2@DM6PR13MB3907.namprd13.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dunaway.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3907:EE_|SA6PR13MB7182:EE_
x-ms-office365-filtering-correlation-id: 9719588b-c19c-4c27-b36d-08dede0923b4
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|18002099003|38070700021|55112099003|56012099006|11063799006;
x-microsoft-antispam-message-info:
 nsSBbIJq7yjP0UIADItYhdfv9hkpRtH2civsoSDeQrdQyQ33TzDCZF0J9EsJPMOka1yG3805QEXslKnYKi4atuL7hEhOADql0DDG1VApb0/c9CX2A0jJwsv3+jhOSxwADPBDiAkXMb60frMXRnakJ7j0UuA4G+MDISTp3tESNaJoTLU63UQxHK7C5aott7Vf0iZiX8VQ3uZWjGy9Zlww1UoFoQWqJ8ZPoZrCy4UXLa/eBpUmYgQQx75L42+pAuWzvl8zcsSkKhbGwvbl/PlMeFIW68gDHgOD9VnqWwUDrh+dh/p3Q+P/QDawh2cT0NPJLwZJXh49qMIxSbaQ2fFh74I/5gnB7oTR1zRL8GSMG5gIMIeYjwbdGbtyibMoPpPnOVUsllByHiKCB/RkR562XFRAThgIHzHsM0fTNZjO82mJacIyyOxAYXqkw3e5CMZYErDVCssbpSvI2t5vDQQVPmu4Oy2IXdEMJUC3jCjLa8kXUjUAa7eLBAWORMmDa/zFDRFQOZ2+PJ1+/lUpn+yAJgyoMQu7jlxlgb/Gv1RsVpDFQe9Xp+OeFX0A5Bcr8p/3auUCv3duhve9GJj+xJaVvC680EMKJhDtEZeL77pw/GHa+QFuiiSbIm2fJVZKFN9PVXnJbcjLTSaNBsHM8QD997E4tejyDwBlIzqnMEo1Ol2Zg3zEdEjbNwW9owtfV3L4EM2LXw8oULrNf4HTQrWUAmBCFwo41haK/5z3eMIDRs4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3907.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(18002099003)(38070700021)(55112099003)(56012099006)(11063799006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?kwlb56MhEzZ2bmyWra3jqb7wDrcbGF6mjJZvVLB/7XUu6vsS67kfkfscFg?=
 =?iso-8859-1?Q?Po1MMV0vYh9SDw4v5cMotIXRtTYTFHgN0+rXh7asNhTyzuJU7Rl27yQA5o?=
 =?iso-8859-1?Q?IWUVn89HRx9scoAH4RGUjj42HDe4842FHajMs3r5QjUwcX2KeHHs2hEasQ?=
 =?iso-8859-1?Q?tGMo1P5+pX019rleUkGGOCWRmRYW915esrBd0HEoWfextmpsRtvUrlhevz?=
 =?iso-8859-1?Q?fVxwi7tzSf6drOyo0Oa0kcZi90SNDiImho2xHkhIHAl36zwTjTs42qx120?=
 =?iso-8859-1?Q?OX8gaY3JtnexygMJmLQ42osA9IoFpKtWn4ITWJpVrC+kwAixSCK4hPIW7r?=
 =?iso-8859-1?Q?25l0oc3MA6CNExsbcoIDCN/Bn1yavjPBbVQ95+hF13MzLZEZI7TLOU9NxC?=
 =?iso-8859-1?Q?I9n6J16g+oXePwwAVhuQwb0XcS3Je2IIT9b1XFdmG2qgdXjHlJhXF6cWDH?=
 =?iso-8859-1?Q?zyOgTcnjKfDnbbC786fmOqeKAWGALwCaktlBuygmdGcMvrdJZdlocvtOP6?=
 =?iso-8859-1?Q?v27l4J4AQUrfiQvxgTSStkoF8ez4ltN8Fzik28M5exlM/FaC3IVlcDe6lF?=
 =?iso-8859-1?Q?ZQLC2ZpyYss8KRczZEbRvrG9o5dXYj3SXlcY+FXvxzV+Uw39sGn8w+XVez?=
 =?iso-8859-1?Q?Z2+BnFhGFA6oYBypPneZ5KAddpH1s1MqmULlHWVwsqlYHvhYugFwJxkD+c?=
 =?iso-8859-1?Q?JKUzkT8UaL8OaFl7GK9ooTfHkQ91BDDktohBdSJh8vyiKTClYBKoJsMIsO?=
 =?iso-8859-1?Q?XWLiJ4beRdo+ZU3yVfCiECZ7TFLT0v5nsjKpKDbl/myS9xqJNCJBeIlRgF?=
 =?iso-8859-1?Q?APNUsJO+/V3nrXigB/itWq/KKf7L6XmA6x4U7kfpVuAnjCrqatpnz6MYo9?=
 =?iso-8859-1?Q?GILC2eTTOTT0wnqvFfTddFY8VJKZsks6pq1cH/mGssHpabbrfwUa8UwS1/?=
 =?iso-8859-1?Q?VNemGytbsq6+wzPLMmdXMRMln4UG2kJiftxCqTb5uwqH43oLaeCOTs3qeW?=
 =?iso-8859-1?Q?IBVGrv//ioP4Shus90o8OM9p1BupoVXVbyElN4tiSTgDYsSsl4Z/OTxnAU?=
 =?iso-8859-1?Q?OPBY8Kkkjd5dM7EanAgI1+uZFzY01B5sQBqjWayj3mRQJR/qCYl6UYI+q2?=
 =?iso-8859-1?Q?9N3X2wse95XbvPt3+WS4zJm/lIc2Oi8iNV0PoSCXO4W13qJf9xcIKqNND/?=
 =?iso-8859-1?Q?CzRN4h0f2OeYIN7n1p6FJdfk6NEmeQPUQIEqURt8EypXQVO/amePGkdFM6?=
 =?iso-8859-1?Q?6JuaXwHxeR7Piqz87KhBiaWsxEYYmMtn2KInmWab1WeWREKDZ0M1F4wpZE?=
 =?iso-8859-1?Q?M9UsdTLqmdH8CyZ2ON6XGsnCdAmTz+zyHdDeuPHVoTJ0Sd7c+FqD3lsFxM?=
 =?iso-8859-1?Q?aKu6suHgRoWPNWCgVppJ/J1JH3VbVe65AuOz9rVnozHchR+G4S8OhxKgR7?=
 =?iso-8859-1?Q?nZ6yZR8xMgsinS0qJLICJUSqHeDmRmvcG80srgBJGY2mTahHJ6o7ISl9V6?=
 =?iso-8859-1?Q?0fpBecPnsrZYYlwnooQMdpR/ThdSAxIyKls+C12LIJEe1L0OImybYuu3TD?=
 =?iso-8859-1?Q?yGDQTKe81xXYrINPS5wHtGQWbKCLDfWHiA3XAv2T+08QfVNb5QMu9+8/WX?=
 =?iso-8859-1?Q?lpXgDBK4K6830DO3KFPrVz6+wpJxNjOl2TUkEwt9wxaNZyaw0eRQjGMEVW?=
 =?iso-8859-1?Q?L8Y0n7B3Ed7S/p/bGPjZH3rSyCoyQuNb0FXslUSbe8o0qpj6qAfm3zQdLw?=
 =?iso-8859-1?Q?At3zKVLrYn+/D43pa142DVjYrAgY8Jh04qoc1xG/yKzCND?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: dunaway.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3907.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9719588b-c19c-4c27-b36d-08dede0923b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2026 22:26:36.7747
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 52eb09f1-ae62-4d93-91c7-9dad929b9fa1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lj8+n8Ygs5YGvYSK1qQs0Cy+mYm2r/A5AYvAeWwQe/zvyHiD7EiwpfgWdSu9kvu54hyBJD3GYFXkgUfx+qCVDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR13MB7182

Hello,=0A=
=0A=
I was using your guide and discovered that when I try to create a portal fo=
r iscsi, I can create any portal I want except one with port 3260.=0A=
=0A=
For instance, I can create 10.2.70.250 3261 just fine, but if I try to use =
3260, I get errors like "Could not create NetworkPortal in configFS"=0A=
=0A=
I am having the hardest time understanding why port 3260 ( the standard one=
 ) can't be used to create a Portal entry, but any other IP / Port combo wo=
rks.=0A=
=0A=
I'm using 26.04 LTS=0A=
=0A=
Any ideas?=0A=
=0A=
Thank you=0A=
=0A=
Russel Moos=0A=
Director of IT=0A=
 =0A=
T 817.335.1121 D 817.608.7045 C 817.793.8936=0A=
dunaway.com=0A=
=A0=0A=
