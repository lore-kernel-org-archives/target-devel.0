Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2121.outbound.protection.outlook.com [40.107.220.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3881118D640
	for <target-devel@vger.kernel.org>; Wed,  7 Aug 2024 08:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.121
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723019700; cv=fail; b=Er+/hpLrvqweeIbjUTQPVGmB6mTkNVIr71BGmlCZpc5SMYivq53gG968+yBI7NAya5mejaQN25oLMHkmTcW7Maka71d8hTWhkXl4gZU1YvDLhCo0KVMiIsp36gjUZCHeKtKr8qgYpcoFZLPspvear2B1hx7TUWOd4ndkEKQp9BQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723019700; c=relaxed/simple;
	bh=FkodjaBBqTdSooNOxOM+jaaqxuTM2aq3bLRtnAQ3fWM=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=DJ2i7DCdHrVDdBq9smA34HCP56jcZeq+sI9/3iDyhm9pY8+JiQTvjIa/Tpg2lyRBZEDrqey6Q6WgTfyjHBa3s1d0YxoUFc/sChmDqKj8wKjswW8unLPRMpqAwsnzEAMMB5GKmeOUk/Jpb7bmrt0w/MTQiGbnqizbaHwjesR9n9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=perforce.com; spf=pass smtp.mailfrom=perforce.com; dkim=pass (2048-bit key) header.d=perforce.com header.i=@perforce.com header.b=f3BQdT48; arc=fail smtp.client-ip=40.107.220.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=perforce.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=perforce.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=perforce.com header.i=@perforce.com header.b="f3BQdT48"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uz+NV6zq9zgNExc0VbCLZNsks0vb8Tmd5uW8jsRj5a6IAdToDbRNiCcSU1Bzr64oSK4mYsbPkQ/yvRCArbWOoxts0mNStKajTOG1q6HRLD/sfwIriXkXeiW3c7djbyf0bdDi/wr1enOnDYawOYNd9NOmV+wlgPlcMYvX1CJPZQCxi8AwPv3BxOUH02v6Z90a82jOfHJGEOA0HC78tHq8ex/A9OVvfBc83lb/xOfjDxGjZC0jb1ovFz+MaIZEYreFh+mhB/+bqnXUOvBMQf7R6dmMgubGto22NCky/EDUQ/zwOQQXl/bFp1ZgmsAyssxyPqwa+ANOZLzngC+aThOJjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J5fOQTn0fleCC3/zaKetC8h/baTDe3EhrZ6fKtVZq1k=;
 b=OMlt0o3JE/SAPAMa6L8pnz8K9NwqVGl20/oaqYGDM9yp/dN8/OfGcR+43v1rmIqcT7Tqv6kchtmTyPFESCUk30Vm9yV75P3xuIf7IpOmN4QKlW4Jv2UjlbBYFf2X6S+7U/CCNF42AKt6Zl410t/mK5/YxyENjP3YdmTXK1qsWCEzCO/VBFFvlIgyHEz4w58cXDHp5+7+DeZFriHHq+EjLYqnFgXizJiLsQyCniiVtwNbvbeSqRYZ25QpOYnEzSWFUfpOFEAp27sS4EZCG1+qE2huKyfCWZddNC1vFzRI/ytgrgHE0d3CSsGw6OHf03DOSRHOZ1kkY0ccauzavoyJPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=perforce.com; dmarc=pass action=none header.from=perforce.com;
 dkim=pass header.d=perforce.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=perforce.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5fOQTn0fleCC3/zaKetC8h/baTDe3EhrZ6fKtVZq1k=;
 b=f3BQdT48QkcItpu1DXQZOFcWLANKZr9j+Utpih5ZKW3g8AL5I5hrro+EX2Ld+hjSMLWgFi1QJkmX8PzH2PnAEFInyO1DoczY56Ykx0rVgb2O5fVW3Es4YMRtsfA7dvPIToMCesajJFwtr+Nj67LJ/wXJU0Unr5ntMbM1Ct26xp1A/CVYiK/C41NM2RknQp6Re4y7CKEkIvH7VpZyLo8WvwhyOIPuaA8AX0Ik4NOaj3fiSr7Xm6rFiHhB03eeYdXbl7A+8LSSPU/sZGcpHs7aRHMYNESrV6LJMGUb4UDis8rDIsxpDGSo5Oo6uSsUPtCL85M50MLBvxbpXRGwDWQ7sA==
Received: from SJ0PR20MB5136.namprd20.prod.outlook.com (2603:10b6:a03:44f::11)
 by PH7PR20MB5829.namprd20.prod.outlook.com (2603:10b6:510:270::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.24; Wed, 7 Aug
 2024 08:34:55 +0000
Received: from SJ0PR20MB5136.namprd20.prod.outlook.com
 ([fe80::f788:9323:b138:c410]) by SJ0PR20MB5136.namprd20.prod.outlook.com
 ([fe80::f788:9323:b138:c410%4]) with mapi id 15.20.7828.023; Wed, 7 Aug 2024
 08:34:55 +0000
From: Paul Dagnelie <paul.dagnelie@perforce.com>
To: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC: "mlombard@redhat.com" <mlombard@redhat.com>, David Mendez
	<david.mendez@perforce.com>
Subject: Leak of tpg->np_login_sem, possibly due to connection interruptions
Thread-Topic: Leak of tpg->np_login_sem, possibly due to connection
 interruptions
Thread-Index: AQHa6KRbbFI4qD4X8EGlMr55N6qqtQ==
Date: Wed, 7 Aug 2024 08:34:55 +0000
Message-ID:
 <SJ0PR20MB5136CD6B38D86FD141070F7E80B82@SJ0PR20MB5136.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=perforce.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR20MB5136:EE_|PH7PR20MB5829:EE_
x-ms-office365-filtering-correlation-id: b547ed8e-20fc-4565-23e5-08dcb6bbd080
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?onTcP4TUAlwYERj0I8bNiMP+0YMmVNqaA+iK2HxkymMZD7zhQOGK6vZe/W?=
 =?iso-8859-1?Q?njx4WS3kBfJ3zvUX7cW7XIDjPAPTQOh9yfVxKsVk0caj4XAsLSM2N6z5Q7?=
 =?iso-8859-1?Q?KRixBaiEVM0cC+Rz6DiI6uIqDmNVbPaovupiTymT8xVDMYam9sBEm80bZ0?=
 =?iso-8859-1?Q?a+RzY5Adf/jjgSa3eYP+AWQmEkLvWaPj9MU/4c37VrFO1Uqm2shso9fj2h?=
 =?iso-8859-1?Q?f2PqF1rafu0eSbkquqCStaTRTgXx9H1vmf+FH3X3CEuWUJa/j3CuXLLCiS?=
 =?iso-8859-1?Q?56CqTi+PSXnzq10Ye9ZcoDQnKCnLNq8/jOK+cURlVBWD3nfa3Z7tl8Iqpy?=
 =?iso-8859-1?Q?iNd77U6epOAIl2SwYsKUImLojyRXfh+PkIDE4+KYE2/lOvTuqWSFaICslR?=
 =?iso-8859-1?Q?6I+wPeqy4mO538Ja3FSjiscuuR/NRbaZHBK/xjCFdTlj5zFcJPoXiAceWS?=
 =?iso-8859-1?Q?NRIZsitgAHPLqF6oOJY+wuT2jcEWP4DGwe3givuAdRYdsolsytnTFFNa5F?=
 =?iso-8859-1?Q?a/UGVebuZxhJyg5wq7UWZf/+WkFkOR8AFoJwmrwGIvUjBe6WaG7zlwNXCy?=
 =?iso-8859-1?Q?dTTEZGN3hqst/ssSBJJ/Nyr3uGRgenI8OBmJqSOpUzDZ1MfNi0tvZJneV9?=
 =?iso-8859-1?Q?uZDksdyB0y+15vc7IzOVvDwwXMl3DFUOnOb+pJEVn8qUgSseXSbL9pWvHu?=
 =?iso-8859-1?Q?kWZ5iuwHuoyq4D95Rimi4Qv0jcCGG6t+DP0UWV7vhZZwVdXqBI0IZ0K1UI?=
 =?iso-8859-1?Q?esa+3rGkQKGWNc3f6MO7b7PrbG49LElOhUd6GodWpFT+LiNHI4ZmJ/T35L?=
 =?iso-8859-1?Q?6Z/11NToxgTNDAFcrkRyPwCnKlJQfMsG0zOkGmcWTLa4fYnjOe/d2peI81?=
 =?iso-8859-1?Q?xvIqJ2kw2ub+86DLnTnRdNeqCLA4yQPgLgneCBOmblDTzGNeigNvLVpKrW?=
 =?iso-8859-1?Q?hTHnmSCK2pZWTlAOYUtaHkZJrBOmJEOYrT37mBadfEQMx2OT24s3PkFlvJ?=
 =?iso-8859-1?Q?uufhBTXHW/fWCq0loOhHpnKtAPlGVXCliOU4g0ejEm6wkrm5i6koZCLSMI?=
 =?iso-8859-1?Q?U9oWCRxRZH2azkbwq/cfdS1sVMrdeIv+Vvfhpxs+TD1lLssICIX00K85MQ?=
 =?iso-8859-1?Q?79cYvjH0z9SVk5U+ImEMT4ivJPHufoCZryj6n4O2HJ8mteskTx/59iepRk?=
 =?iso-8859-1?Q?IVv3eRWibkopWrjRu6/b7RSj3GoL4FU7APjINnabi0UmsM1xHVZIRWMACl?=
 =?iso-8859-1?Q?DtNaXy2UQqs3CB/PDSewIgU5MDHrzw/UiWgvfdDTwCV/vY0zqnQZccG2wy?=
 =?iso-8859-1?Q?MqnbDMKosc5+KtSj0bi/54xtGhc0e9w76B8PqfWESOhWDC25NOsoPmGbWI?=
 =?iso-8859-1?Q?aS7kvIpIj8/Gn1sY54jKZaAPQXTw/EeF974h7EdQZggESnOi8ldpZaYd2U?=
 =?iso-8859-1?Q?zoEBRMJy+ydbLVInuVp2bUsjoErfX0Vvpm7gtA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR20MB5136.namprd20.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?RIE+8K0nVQ1Ew54M5NhNEkeC8huUawbQXum278UmAheDGiKt3bint4NVom?=
 =?iso-8859-1?Q?W9R+J3KKAHq+01ZTiyQ1QFFyEnbK2NDEPsPMPtvtt35ys7n8hYsIvbWgIk?=
 =?iso-8859-1?Q?Jyfg4cjFhAiy6fO+hZIHy7f4owemaGCZhHzzB94m88PDAoR5LmvSmE6Z0r?=
 =?iso-8859-1?Q?seueD0nDxoTcghfjIoXGqNKji/Kd2Oe8/kfWE1gOaBR77qWYSmMrCP9ah0?=
 =?iso-8859-1?Q?5WOQv2CC0SFnlQSM5nB+dSGgiiBwNbgwA+TWGRAwejZkLojHgWTXPoTc33?=
 =?iso-8859-1?Q?MU35FH8mLtm6ZbCGov++nxkt2LeHTA7Xz6jsE1Y5rdEFMLbnmo/rC8Satu?=
 =?iso-8859-1?Q?lqzOtMzr1IztURQwI4GZdam6EhpDyPFjQaB4bUQadzZAVihUb/2goqtEkN?=
 =?iso-8859-1?Q?kWMKSQmPhMFf2dIdLpO2jxL3vKtE/wJvak+zf38o2F03gpCJ8QCtK2b0CP?=
 =?iso-8859-1?Q?ks9J0h41nhEbJ0/wha5O969147AlRfgdt2Z0iY8WCeA8NFbWDpf0ROb6Xr?=
 =?iso-8859-1?Q?AlD/6WmvU2zP2d2RIjEnWyjlcBkQ1nZ8LR4dP5zPWBYatqzJov3uR4OQxG?=
 =?iso-8859-1?Q?Tz3KPqrf8BPjNlWTUP43fnlg7biLaFkjYh/gDIPh05PTwsxIOyTNuX3Z46?=
 =?iso-8859-1?Q?iMi36ZtORoRntIWTXbJaxV5l9g7pR8KOQsskS40CUO7XGiKbvOCLeBWplu?=
 =?iso-8859-1?Q?9sTqrxu8yzqed6NMihxConSkYBgasI7URLtfRufNyF37HG0Q5jAdjQg/ZN?=
 =?iso-8859-1?Q?7V6MXHqS4gQVKb0ZvmwDFM2jG9u6kp5lYzE7pKmhzDdgOUV2mKpApUmqw9?=
 =?iso-8859-1?Q?cQYAP9LMV8JIMVOIhMyyKpAoiHcHdjFaXPiEeuXH61EbhBl21Zz1mf97bs?=
 =?iso-8859-1?Q?AzDVnODPOdkxAFuYIh8NxstfdlTDGPiy4FXa7jGNFgUlGLJ86n/jhiQvXo?=
 =?iso-8859-1?Q?2762O4TW5e9gtMQgnFsPGxwcfqtqClnbvcnRoqTuf+QyZ5/6qqjKAUg4xu?=
 =?iso-8859-1?Q?0zXHGhbsKMiWg5L+4hyljK2M5qoK48RPc8bxCppU4A71od4Bo3Fn7S0lJp?=
 =?iso-8859-1?Q?qgz6tWZASu51l3DJroFQrbWtWaUT8C75fqZNXT3cxRKmIBNJKYy4IIMses?=
 =?iso-8859-1?Q?sRYDxBhT2yVSXf77My1oKWuhg13KBSS52bbYSrXZmlbGqK9qPLFh0+LGYR?=
 =?iso-8859-1?Q?KxFDJfUML90G9gTLVU3mvYOLZoHh0hMNl22kdBQWZbsdGKZI1QrlM/YoKq?=
 =?iso-8859-1?Q?TXLwcLuz3L+jBOLh3kzjRHTrwt+/xbqkP6fd5dRVY/oi383dyVM3YXhFP9?=
 =?iso-8859-1?Q?0hdb1Fr0hDCty5aE1RGsW2Bwm78riRH+YHI8tAeNJ+Re5/Wanp8pBU6Mkj?=
 =?iso-8859-1?Q?cGLFom6UJNknlTkYxL3JUll3k/Y6C9quTJaROA/jssEPo9raKQmwmgs/Hq?=
 =?iso-8859-1?Q?CmZXZVwtj0D3YIYLsFPzBdCQtJMbHjjg1aEo5AVZ+IZZzF/Co9hIxudyzr?=
 =?iso-8859-1?Q?wKp3xvgy9W7DPRgkUDeS0huyHC1DgfybNt+oB15Ud2FoWzS+XbxG/NRNuF?=
 =?iso-8859-1?Q?FfuyXYuZ7X8m0gQc4ACkgl+47liG/tCvj9nTBfcOv4ogq6Jw5FORjp7oOR?=
 =?iso-8859-1?Q?lZHAiGbIISb4/BS/cwhX5fHJBFOuADEiuM?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b547ed8e-20fc-4565-23e5-08dcb6bbd080
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2024 08:34:55.2919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 95b666d1-9a75-49ab-95a3-8969fbcdc08c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WZU762S3mzoRz/g6Hv9ag/jv/08RY4e57qf1y6DmM8uqqUe2XXn2Uerm27kvn8z6T32v62lI/faX2BcyYLDnlWS1wUpkwaYewc3cAbZlK0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR20MB5829

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

