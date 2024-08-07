Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2112.outbound.protection.outlook.com [40.107.243.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C19214EC55
	for <target-devel@vger.kernel.org>; Wed,  7 Aug 2024 23:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723072640; cv=fail; b=CdDaog/ZbcGvSX0jbAUa/CJ1AhoIhpWzzDXJzWUObEh9Y9cLmUrNW/rKMFLI+6I6Ivf+3ByXxuqeGfpvWwdDdsLFbZYbRI3svOGs62aMDcATCaIdwKgQ/NmWBaICczEn7OQIvd2XZqBU549S/ImwLELmI0e1OXcYc/CNkB8Gp0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723072640; c=relaxed/simple;
	bh=6QvAXRXpO9Fm91ComaNeC/EaEi1zGJ3YTn2pHB/ne4w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Jd4WEFKIVWMBuB3d0YUBk9eOQt1zf6xocPhEf3qSHh0K1Gallxhow9JpKDwZr0O3Y0M6AVfgB+ecgz1tQU9ruvUpEJcDhAsn0Cum79hu0kAZshqmbjpKbpdtBbVnDLWX0XiLRP/PPew7QLX4JgoIo2SAl3dzLD/3rSm/pXaZtX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=perforce.com; spf=pass smtp.mailfrom=perforce.com; dkim=pass (2048-bit key) header.d=perforce.com header.i=@perforce.com header.b=GnfVzrMB; arc=fail smtp.client-ip=40.107.243.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=perforce.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=perforce.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=perforce.com header.i=@perforce.com header.b="GnfVzrMB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zDXrpADxdyAzJO1bM/eJo2ZjJMQY9a6XaKv3kOGXaaQxtJ8w9WpW4Gi8Wkya3q5/x7Wv+QSRhhtF0zI1b6yJmbf5fzNF3gEzxXMzhEOzxxzr1b08qxHQYmNOHVqxBAcX4cZ1YSW69Hyo0i3MJP8RgC1zIM3l6HtKCTDYXPHj/NVDgJ1Qbj+F2Hax1UVpi5x+SMdcducRilNySiue/7D0EizYl30TTu9rKqVcbNGlqEfIOgfxGsExMkOQyVNzlWmK5JU/1/uX+l2T8+17VuUUqnVDAmS19JkacS54cxNuYt0qQ6wWllp5j8NfrHMHYdWUbiJcffwj/5CD+LUOuXuiUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hGLUf7IWfgvzO7x3e54iCEPgTIMh6n/rxnHe/X8bkSo=;
 b=glzA6NkSGcMs9s5Abw/+psVQMpP4ZbZlaxoHXodeIXr88/T7W1NqTHAgWLTQVcKIiFVEtPNRAcxSC80SKrziFHyIssNzABnRqIUcCJfooJUXpUapX/kTkctdN6gJ5CY0ZiiXpHIWT+l/FZ6MgLVaFZiYSWpbsVem1HNYLK6rbF4b+XDPki10FVn2o6PC8EE+ED7haRLbpxQKLw10OcM7Br0eurNIB8847xwB5EqQC3UdYSZvCE6WKaoAQkU/yTednB1n6SnB5dDIxGVZyn9n8KRLzw7JfefVJBVt7gMayva9n4icVZqOEHb0st0ZzDl4/0YZuc/QvKoLNV2yesCBUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=perforce.com; dmarc=pass action=none header.from=perforce.com;
 dkim=pass header.d=perforce.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=perforce.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hGLUf7IWfgvzO7x3e54iCEPgTIMh6n/rxnHe/X8bkSo=;
 b=GnfVzrMBXm9KsQCEwgMMrB70JrZ+tbNg0CtOgwEvV+yUGHn5wQ+eRiMZMoD5IuWhsSCYUnhP40uwTc2g0rXti1geW8VkMlwXjQk/ScD9DXt14kMO4CDT9l7kumwsOQN9MfnaQmU19w6mIuPaZuK7tEjTh3+hwUIxa7JJ5Sqgz4VLGuetqejfU6pXnUx8t/SPbdExzoeLO9cozG0vnaR/7sRO+MgVGPBbWsdI8YMsiHtbebhgXtvoj2FVxXMDaEkJlBjngcmVBiqU7y/vzP789nr/dCs8/LLK+cIvj/WyK1tRLbMiY7oxVkd/829za8N+TrlAzS95tOBKMljQDF5Qzg==
Received: from SJ0PR20MB5136.namprd20.prod.outlook.com (2603:10b6:a03:44f::11)
 by LV8PR20MB6930.namprd20.prod.outlook.com (2603:10b6:408:202::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Wed, 7 Aug
 2024 23:17:13 +0000
Received: from SJ0PR20MB5136.namprd20.prod.outlook.com
 ([fe80::f788:9323:b138:c410]) by SJ0PR20MB5136.namprd20.prod.outlook.com
 ([fe80::f788:9323:b138:c410%4]) with mapi id 15.20.7828.023; Wed, 7 Aug 2024
 23:17:13 +0000
From: Paul Dagnelie <paul.dagnelie@perforce.com>
To: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC: "mlombard@redhat.com" <mlombard@redhat.com>, David Mendez
	<david.mendez@perforce.com>
Subject: Re: Leak of tpg->np_login_sem, possibly due to connection
 interruptions
Thread-Topic: Leak of tpg->np_login_sem, possibly due to connection
 interruptions
Thread-Index: AQHa6KRbbFI4qD4X8EGlMr55N6qqtbIcZtmQ
Date: Wed, 7 Aug 2024 23:17:13 +0000
Message-ID:
 <SJ0PR20MB5136C6C85B1B82FF78ADECE680B82@SJ0PR20MB5136.namprd20.prod.outlook.com>
References:
 <SJ0PR20MB5136CD6B38D86FD141070F7E80B82@SJ0PR20MB5136.namprd20.prod.outlook.com>
In-Reply-To:
 <SJ0PR20MB5136CD6B38D86FD141070F7E80B82@SJ0PR20MB5136.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=perforce.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR20MB5136:EE_|LV8PR20MB6930:EE_
x-ms-office365-filtering-correlation-id: 6630bafe-bf6f-4240-1c50-08dcb7371254
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?TamFitAPQUi7KY2rjDVWSnL0JsANlo6d48+3SP6IxnZmZfUSLrptmUB3yl?=
 =?iso-8859-1?Q?aeBMWOND1Lxjkrso3Ce4WGTI4awzJlF4IoItE0SNPf86EOgwN/L30FWdSQ?=
 =?iso-8859-1?Q?QkNpLJ5adav7fER0yNQCd0UlS4TUMtaC5jAOrsRWDzyhJmvzQ8a0fuSrW6?=
 =?iso-8859-1?Q?vnMmsbxlCl4gATBkt+UljubOLrx1QMnU/W52+3FPI3UJIbz7qJByHB96Xs?=
 =?iso-8859-1?Q?okiiq4I/dToWYaU5y1jrzhk3w2YoziUfnycinXausbj06AWkwB0WOXLBCU?=
 =?iso-8859-1?Q?L/EQgpoj5Pv8q7+5Iu1GcuxBDymnQMgvnO0PrmCOaTyS/557usUIvgSt09?=
 =?iso-8859-1?Q?WdtasyiueWTW4Dt6cnaNFEHYlrDfSPTQJme9YzltHFPLHJFZYSogmgHHqd?=
 =?iso-8859-1?Q?IAp7cSsWz0yaKoFWYnav7aZirK/7yRLHt6zL9Wgv6KdMHAZzQVw/w30wu4?=
 =?iso-8859-1?Q?ZB1v1fjLN7NiHKkM/0ksvEZmcCRAxYgVKOgIdqtnhSTfqTWw8OH/xC/aGm?=
 =?iso-8859-1?Q?rUH7QLdUKvrJPsFHGkM16+kd1ZIM4tN5usTSz/9BSL5d8B7SWkjHkOvb12?=
 =?iso-8859-1?Q?NNINtZr9mqdXjCqqcl1LhB5BzYqLi7ZTd5QVhdvzyWAxl+dTuSXcWNEJly?=
 =?iso-8859-1?Q?vT4HLnsz02k/knJTErhucArZBi0YnnHw3Pv3mLZ85pZT6dWfrK77A1IiJd?=
 =?iso-8859-1?Q?0se+o4QGAeqD4gAI+RHsh0P/2GloDpbvCwYy7dd+Jud0FWZRuk/UkWajy4?=
 =?iso-8859-1?Q?UKgqCC+sKCGJmV8mygYD43xTZIp09WVjeCqx1UfkXYceBx9Lkugt+TjD/A?=
 =?iso-8859-1?Q?JoqiV4rieI4p3uoxg9/3QVGHyEfGvqqGW8AL9mu+ETowha5NEJ/cekKv/H?=
 =?iso-8859-1?Q?RZGC+w7vgf/LtpjQhTyqyfNG2B9iZdeLSb2+rpGJi3nTeJqogIYELIDrhm?=
 =?iso-8859-1?Q?4WPQcdtj9psv11ur8lhXbDGoWdBuC+TUdDQmfU6/InvCCeUZ86sn/QRa5h?=
 =?iso-8859-1?Q?xFnygbz2P+p9zm55ugJJViirisx99jgojXTynOmGnu8I2S3T1lcs2pzg9i?=
 =?iso-8859-1?Q?2QGtjQWabZnKMMGaABgZkSqeUCwHWG7LjPX/mefwdSodQjdxZSLdn4oNe0?=
 =?iso-8859-1?Q?2QrlRndIA4zeOiA6xozBRRMGoSIXjd5pWEsMqDDK1mUy3roeHQcZz8pZeD?=
 =?iso-8859-1?Q?btLlsPzQZxtZW/mDLd338XJu35oB/X2IG7Z/duC+HdCB/CcNCg21/JMjug?=
 =?iso-8859-1?Q?pgQDyf+RE3npbc8kYHt84pXwVi52uRKlbid56jHhxsQMd2yNia68HjJerf?=
 =?iso-8859-1?Q?HRTSaNlQ3ygHqIGwzOCDGuSelEDCQa81TcaF3lVYC2FIMlUKcWB2WXU8NE?=
 =?iso-8859-1?Q?T7oyYQn45yDuvyfffLVu38Vymwi3p8jAzgJY6U/AUITeUnYuCJ1ElNtKNN?=
 =?iso-8859-1?Q?oNdabOXRvuMF3gtmtA9gQhE8b/Q7S3tpP9BJuw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR20MB5136.namprd20.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?a9uitbEVld2hCpQM0hc/mLygoneiYeddLUNSTgOAJ5aIcG+wZ6jKH7UKk/?=
 =?iso-8859-1?Q?P1QJpU4AIpz2KzfZtz+Qhdwr+uZ/ppjQZcjb06YF9VQDbqaPGNKdQPHTpz?=
 =?iso-8859-1?Q?U2B9+M0+Cq0ez0MMfThmvSOyyybXtM4MvWRUlhCVFY659XS+namkBH9vjn?=
 =?iso-8859-1?Q?/ufwZo5LFbsz7I84hYlpowZGC09X/NTBDkwIir2RXONPwxzHJPNahhFQ6k?=
 =?iso-8859-1?Q?ndmN3qSJJgP4byAiwkeBADvcWwX/iWdfXGGzPO29eep/kb4EPeX+fIoguw?=
 =?iso-8859-1?Q?8C5TFI4VgZhralHk5Rm8CZheMTRwVHy5uuMlf4fUBIkQAyTLDTU1jQ+uhK?=
 =?iso-8859-1?Q?eM23nMPxxOayNWQisVAbawNeJ7Hvx0flZCvLHzIWcpO/FDevYx0ttBg0xO?=
 =?iso-8859-1?Q?6dUMvACgKAG5R+kdV5GP1euXeXIJSLaMRpFfFo3VDl38fXmqAHKB/FYNL2?=
 =?iso-8859-1?Q?bHxZDEpEQKlW7hAF5gjnoDNfx/mwZvEE1r5tuO6BoLbRQf2TerWskwjufa?=
 =?iso-8859-1?Q?/RWY5aFwBogZOAP5QHcOrI1uT/MpvOqudiR2QyQBcFlZ9LACuLtAd9/vfB?=
 =?iso-8859-1?Q?4LufcCk6IljLW+b6Fl56JbEa1GzHLv7+f94Ab22fkfqmaYILlS+j5Xl2KP?=
 =?iso-8859-1?Q?Rpr5/1c/zIP6IHXnfw/5BGUzHHo2XDvfHNlzJS1qdgfXL9hSg2x/NyLxmZ?=
 =?iso-8859-1?Q?rS1qQpW/XWEB8V8jaaOleKbh39KUbxeTbYiVbhxV6TDoL3BsFT7duwd6TA?=
 =?iso-8859-1?Q?aLCMu/rXG5NHrLDSdvgJAgCTc7WxJKt1dhITa4W1YxuvgK5X0uvdZgcOkA?=
 =?iso-8859-1?Q?jB/Wf593IKf+RgoL5FSX3W97qLYNnNUsUx4mJTV9c0E+o2aDp1cZYuHLXQ?=
 =?iso-8859-1?Q?nByZUW1TPtWXG8wpYTxnXZ2g8Hb0vfOYGGtWKUE3XplRYgTVa4Ua/7n5KS?=
 =?iso-8859-1?Q?lnigFZ1dHpsJ4e4347PGPwtLn4vYwb4tdsvmuvs3BykUxX046Gd105TSS6?=
 =?iso-8859-1?Q?AURC6nzJJT+ZtWUiQ6yIOjeMSJ30AcUQ3luQLinNs97FOL/KmwoRjP1ll7?=
 =?iso-8859-1?Q?5Uz2KFNCX9Y7dP6XjCZ8Rkiv8NyYfhomyPV8Y/dE+9pvN+UIu8zZJPdRxJ?=
 =?iso-8859-1?Q?Kaq+CsRrFMN2DuA96CckJKXqcTtPDiEf94IoQjHrovTSo/ZqwIa9z/M6rG?=
 =?iso-8859-1?Q?sryPWbSYf7R6rlfo0zuWB5OYI6rDCGTmNxnXbaNrkUPyJMLnTrwQCvN87K?=
 =?iso-8859-1?Q?xaGfiFAAQg8ybTR12A5BDaBLA+4HwOMi4tbyGkZDdVKJCjX0Jo38/+RSNL?=
 =?iso-8859-1?Q?XR23IXetZD8/zGsrAvEvarRsuXncVEkhxeJeK5yfGqqHROkyyoa6AE0fWg?=
 =?iso-8859-1?Q?iOx0Z2kdct2TA43Cf8MA50PVsG6VAd1CLHg0HXTm5Nx+gyu9wYEpUs9zog?=
 =?iso-8859-1?Q?2FmTpMZhkn6xJCMK5enUR3npvjw5OODI8CEsk5+C3FInBIDcYCt6ZdnB/o?=
 =?iso-8859-1?Q?dnxCAgN7Jzs/rsdgHQa2r8u6Lk0CtOA0H6piMrq/huRvOSSPOPuBQ4U+gw?=
 =?iso-8859-1?Q?7XETPMcmnYe2y+snazFPt7AN6nahiKunAIWxhA8PzFeDAVOw99ciguZ5Lw?=
 =?iso-8859-1?Q?6s9atTCy7kIBrRc1wcsyySpc5mKM0TwEqP?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: perforce.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR20MB5136.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6630bafe-bf6f-4240-1c50-08dcb7371254
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2024 23:17:13.7990
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 95b666d1-9a75-49ab-95a3-8969fbcdc08c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8aVTBfnTmKF9WCKjnfuz+hobQqW0quPqJn8AA0WpTmfVnoxqeR6NdN3vE4hC14lEsYfgcXav/PNW7RR9jQV15opIGrO7MGrKzrHugL+zi+I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR20MB6930

I think I've come to the conclusion that I initially misdiagnosed the preci=
se issue here. It looks like what's actually happening is that the  iscsit_=
close_connection call is hanging indefinitely.

One thing that confused me about my findings is the flow where connection r=
einstatement was triggered. The "iSCSI security negotiation completed succe=
ssfully" line indicates that we're in iscsi_target_do_authentication, which=
 means we're in iscsi_target_handle_csg_zero. However, after the call to ha=
ndle_csg_zero, we should call into iscsi_target_do_tx_login_io, which alway=
s prints a line about "Sending Login Response". I don't see that in my logs=
. Thus, maybe what's actually happening here is that the `iscsit_cause_conn=
ection_reinstatement` blocks forever. That is supported because we have a (=
somewhat mangled) stack trace of a thread doing that, sitting around for th=
e last several hours:

0xffff909731e2c100 UNINTERRUPTIBLE       1
                  __schedule+0x2bd
                  __schedule+0x2bd
                  schedule+0x69
                  schedule_timeout+0x208
                  wait_for_completion+0x8e
                  wait_for_completion+0x8e
                  wait_for_completion+0x8e
                  wait_for_completion+0x8e
                  iscsit_cause_connection_reinstatement+0x9e
                  iscsit_stop_session+0x101
                  iscsi_check_for_session_reinstatement+0x1e8
                  iscsi_target_check_for_existing_instances+0x21
                  iscsi_target_do_login+0x344
                  iscsi_target_do_login+0x344
                  iscsi_target_do_login+0x344
                  iscsi_target_do_login_rx+0x24b
                  process_one_work+0x222
                  worker_thread+0x4d
                  kthread+0x127
                  ret_from_fork+0x1f

That stack trace indicates that we're sitting in the conn_wait_comp complet=
ion, which is triggered from iscsit_close_connection. That thread appears t=
o be sitting in iscsit_free_cmd+0x58, and has been again for some time (I r=
emoved some doubled lines this time, number of dupes indicated in brackets)=
:

0xffff9098459d2080 UNINTERRUPTIBLE       1
                  __schedule+0x2bd [2]
                  schedule+0x69
                  schedule_timeout+0x18f
                  wait_for_completion_timeout+0x87 [4]
                  __transport_wait_for_tasks+0xd3 [2]
                  transport_generic_free_cmd+0x11c [2]
                  iscsit_free_cmd+0x58
                  iscsit_close_connection+0x48e [2]
                  iscsit_take_action_for_connection_exit+0x86 [2]
                  iscsi_target_tx_thread+0x1a5
                  kthread+0x127
                  ret_from_fork+0x1f

Doing some reconstruction, it looks like in iscsit_close_connection we call=
ed iscsit_release_commands_from_conn, which calls iscsit_free_cmd, which ca=
lls transport_generic_free_cmd, which calls target_wait_free_cmd, __transpo=
rt_wait_for_tasks, and that's where we're hanging waiting for t_transport_s=
top_comp. We're now well outside of my area of knowledge of how the target =
code works, but hopefully that can give someone some ideas of what could be=
 causing this issue.

________________________________________
From: Paul Dagnelie
Sent: Wednesday, August 7, 2024 1:34 AM
To: target-devel@vger.kernel.org <target-devel@vger.kernel.org>
Cc: mlombard@redhat.com <mlombard@redhat.com>; David Mendez <david.mendez@p=
erforce.com>
Subject: Leak of tpg->np_login_sem, possibly due to connection interruption=
s

Hey all,

I'm investigating an issue that we've been seeing on and off for about a ye=
ar and a half now. We're running on Linux 5.15 with a couple custom patches=
, but none that I think would be relevant to this issue. A customer (usuall=
y with a somewhat flaky network) will report that they're getting constant =
"iSCSI Login timeout on Network Portal 0.0.0.0:3260" messages because the i=
SCSI Target login thread will wait on the np_login_sem  semaphore until it =
gets interrupted by the timer timeout.

We can see a thread blocked on the semaphore if we look at the stack traces=
 on the system:

0xffff8bdf62f2ac80 INTERRUPTIBLE         1
                  __schedule+0x2c1
                  schedule+0x33
                  schedule_timeout+0x205
                  __down_interruptible+0xbb
                  down_interruptible+0x4b
                  iscsit_access_np+0x5a
                  iscsi_target_locate_portal+0x429
                  __iscsi_target_login_thread+0x332
                  iscsi_target_login_thread+0x6f3
                  kthread+0x120
                  ret_from_fork+0x1f

And using bpftrace, we can see that all calls to iscsit_access_np with one =
tpg return -1 when the timeout hits.

I've also managed to run some bpftrace when the problem first starts happen=
ing. The problem first starts when we get a LUN_RESET (XXX here are redacte=
d, but all the lines have the same iqn in the original logs):

Aug  6 23:24:19 HOSTNAME kernel: [24805.722904] LUN_RESET: TMR caller
fabric: iSCSI initiator port iqn.1991-05.com.XXX:XXX.XXX.XXX
Aug  6 23:24:19 HOSTNAME kernel: [24805.722907] LUN_RESET: TMR starting for=
 [iblock], tas: 1
Aug  6 23:24:19 HOSTNAME kernel: [24805.722919] LUN_RESET: ITT[0x96786300] =
-  pr_res_key: 0x0000000000000000

Twenty seconds later, we then start doing the iscsi login flow. The bpftrac=
e that shows that an access_np call comes in for that tpg, but no correspon=
ding deaccess_np call ever comes in. This system also has pr_debug printing=
 enabled for various files, which allows us to see that iscsit_take_action_=
for_connection_exit was called, it looks like because connection reinstatem=
ent was triggered:

Aug  6 23:24:39 HOSTNAME kernel: [24825.690817] iSCSI security negotiation =
completed successfully.
Aug  6 23:24:39 HOSTNAME kernel: [24825.690826] Normal iSCSI Session SID 20=
 is still active for iqn.1991-05.com.XXX:XXX.XXX.XXX, performing session re=
instatement.
Aug  6 23:24:39 HOSTNAME kernel: [24825.690844] Moving to TARG_CONN_STATE_C=
LEANUP_WAIT.
Aug  6 23:24:39 HOSTNAME kernel: [24825.690847] Performing cleanup for fail=
ed iSCSI Connection ID: 1 from iqn.1991-05.com.XXX:XXX.XXX.XXX

As a result, it seems like there is a way for the np_login_sem hold to leak=
.  It seems like what's happening is that after the LUN_RESET, the session =
somehow wasn't closed. As a result, the login process decides to try to rei=
nstate the old session, which tries to reinstate the old connection. This k=
ills the tx and rx thread, and one of them invokes iscsit_take_action_for_c=
onnection_exit, cancelling the login attempt and killing the delayed worker=
 (who would usually be responsible for calling deaccess_np). As a result, t=
he semaphore is never released.

My current best idea for how to fix this (if it is the issue I think it is)=
 is to somehow detect in the connection exit code that we're holding the se=
maphore, and forcibly release it in that case. However, I'm not familiar en=
ough with this code path to know if that idea is feasible, or if it would b=
reak another valid flow through this code. I would welcome any alternative =
explanation for the symptoms and logging I've been seeing, as well as any o=
ther proposals on a way to fix this. We have a customer system that reliabl=
y hits this state within a couple hours after booting, which is causing the=
m a lot of grief.

Thanks,
Paul Dagnelie

This e-mail may contain information that is privileged or confidential. If =
you are not the intended recipient, please delete the e-mail and any attach=
ments and notify us immediately.

