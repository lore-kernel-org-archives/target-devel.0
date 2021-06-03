Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D346C47082
	for <target-devel@archiver.kernel.org>; Thu,  3 Jun 2021 18:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF01261168
	for <target-devel@archiver.kernel.org>; Thu,  3 Jun 2021 18:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhFCSHa (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Thu, 3 Jun 2021 14:07:30 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:64633 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbhFCSH0 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 3 Jun 2021 14:07:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1622743541; x=1654279541;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=hSftNPjJ2bkNZyFLIk6ASDa8aHPexb0mupW2Ya4Cxk8=;
  b=okkLniD46kkHD2U9XfZJaVoJF4jMyXuLg/Evf0TjewAsMx3U9ha8bUaq
   Jss/BAwfn6zs5xRoyjvrHUM1zGOmEM0rcGa9ZAz6YzXChJpmZuCS2s3Om
   Twu+lRUSMpnkmAuxppHf0F/LIz/IQG/ukXpLhs+QTdGotgzQldrh3P5NO
   4++PA1atMBpqkTZjJQY+cxcBhw7ND3UmeLZoG1IZNt2fqr4Q+PuaskjaK
   wEwvLV1tnTdb39xCfxUmqlcXyPAneqLN+FjsBGnaSweuCF/7nwQxBgeV4
   vqKMh6ImiCCxFALdnPR5vjLO5A8D1OFkDRhZELfFIN7qohjBiG4kKvww4
   Q==;
IronPort-SDR: YdCBBpb2kfBTm/HOsxcvMaz8bAFhvxOWnRqyIzrPfQdqq4d8nH8lct84de8DjcUa8tfva73TKU
 YsHNoq+6qAUI6OrnCq0uQCmRMYQx9x/yyIRdZGWdPS1caa00TMS3Nez92qJX7b8NriCprrypba
 xdvtKS8gUvGXPO0jEaFAtlkKXZMd5DZhFLCIGfy7IMRqMpnCOeICY9W8+JGjzGtPFO/xCtJM5U
 X6di2c5Yr9zMM9ctk8JgAQ25iz7/Sj2IAVJSHNVZ/tTiVtLiVuXRu+AJlB7O3wrZXDwYNsrBHw
 Ws4=
X-IronPort-AV: E=Sophos;i="5.83,246,1616428800"; 
   d="scan'208";a="282010303"
Received: from mail-mw2nam12lp2043.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.43])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jun 2021 02:05:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GyDk2W6b9AfUNJyWpV8/gU4H7cnNHKKnOc5g5Uc/HLTNBXhAlMSNJ+LxDyw6uh3kCf1gRpPGgv3dyO5puMD+hutqSwxEfbLwmK0X+xI5oiumezpN5RM+gfS6J+4jIljfFWDLgooVjke16UPTjmHWb6mt8ECF4bd9GfNVKxFVp9/jwLH1oz7aLPkhhb7tAWCeQ6lNuM7vPQbTN1ZffvKTvUiTqzdoA5Pz0rV1jNSYK26FKJnHErXAN34iqdWOAPuXiE6GZDKkJ+oSYNJV6nzuqr8nqC8LAMIXlVuoh7uQb1AARo+3LyvN7vXgoL0RkSYnrsy2cXHvOaOUacotXe3hqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hSftNPjJ2bkNZyFLIk6ASDa8aHPexb0mupW2Ya4Cxk8=;
 b=P/ieernhDpJaakamITZRAmeLuUQ1iy5QMVMA82baQgG9AnbhRlNCD2Noc7ny3IFrocIQ7umqQpl8ZYnHwRCV4ohpz82ShF3mlQVpufVSSoMaqRauYFBNWbaBGkfXUVzsl9vNtKdk2iYF8wSTg70pI8I9braegVeJYvsNf6VFHW24nAtfjU6KcZiS+w8zZoJWPc012Gws5uWMKQeu5AaehUbTwsJ/B6yKR57K84kFEsItHnuVN/iRQSyzVgekZOzRq6sFjAkToSFxBhp8AR0JEKw9aM4Ad50SQ9yHw7ncDhEVs7l7xuYOkEIHaYsi621/VNv6DIyV8+3883pznbmwqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hSftNPjJ2bkNZyFLIk6ASDa8aHPexb0mupW2Ya4Cxk8=;
 b=n7LG8jEFb55EvZwX75BJ8SjSZQbCni/JVKWNI/sBwgl5jNLHlL/5CGqsrHExDaT0VTC3VzMP36+Bh/ayx++W1TG/0VdP2ucyKUlExS0zXCBbbW8JbzWxiMK/Uei0jkffdpB62fYMNQuhhvn59sJmysOpRtyTmbJVsD5ze2KgsbQ=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB5254.namprd04.prod.outlook.com (2603:10b6:a03:c2::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.26; Thu, 3 Jun
 2021 18:05:38 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::6873:3d64:8f9f:faf0]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::6873:3d64:8f9f:faf0%7]) with mapi id 15.20.4173.034; Thu, 3 Jun 2021
 18:05:38 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Maurizio Lombardi <mlombard@redhat.com>
CC:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: [PATCH] target: fix warning on realtime kernels
Thread-Topic: [PATCH] target: fix warning on realtime kernels
Thread-Index: AQHXVhZmqrkbcBG4p0m5lRTm5qLH5w==
Date:   Thu, 3 Jun 2021 18:05:38 +0000
Message-ID: <BYAPR04MB4965FDD1E6061B8EBEA7C53D863C9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210531121326.3649-1-mlombard@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c78bb11-6906-445c-c9a4-08d926ba3171
x-ms-traffictypediagnostic: BYAPR04MB5254:
x-microsoft-antispam-prvs: <BYAPR04MB52547366E1F5622488E5B5F7863C9@BYAPR04MB5254.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9eE8EiV9aCrtPJ4vSIikOq70DlkFztjYoOBVf7D0FB8NQI2h/jBtY672PNCJbcWZvdvMcOD0kmpbJlWAC8SQkYtIZEj3SYaU6xz8QvGqFS7alWXTow2vtSuNSG8vWYWk9ylBmM/BK7GLalM2PDmCryJ5JVQv07hrL2VuPaky3W4PZ7FAvGPGLRXjUUFyC0Vtlc9V9sr52cIF8jTFVs8x7oZn0hgGGRNmKcSXzOmGEYdPzdb2AVJqXcZ88hxWGE9HAddnbB/rMiEeqQX76PtoiMYMRC36qv7arRb6AiRSYsHLgMDmu2nAR/O071Qjtjmuf15pO2aUTHBO5yL6CYg+wNY9zNmhcW0/5WPm8vLHqD5mdhBysyTwfVS8nHXvKKu6JyhICCV/azWTy9M4b/zHUIHWGhiGS9hL3KDzGSk4UqrdKilqfQLKjaCbOq+DRBXLo9ihpMoyt3g1KlB36BYtgZbTUbRfNOviQU0Hpr0F0ZTFSMNoMeBO4rnE/hjuFoeKMSA493l48B5QwyHUM5YIxKu5Et/O98BSnQrqsiHt9HaegHebdTnsOA6wuVMbNwrSB2ZOOG9A+/e0ZMXxVsQq8SpGU0CszuFV3GPfjbDj6uk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(396003)(376002)(136003)(346002)(7696005)(26005)(6506007)(66476007)(53546011)(186003)(316002)(478600001)(54906003)(71200400001)(122000001)(38100700002)(86362001)(66556008)(66446008)(6916009)(2906002)(76116006)(8936002)(9686003)(4326008)(33656002)(5660300002)(8676002)(4744005)(55016002)(83380400001)(66946007)(64756008)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?dkd3Oad9dPjif4+vnXMD0UutVagB2p0lPj8iPq6ZrQZMDy16tn0I7ajCD8Dc?=
 =?us-ascii?Q?U8gI3utrSb/3WNaNUMNt4ZqvU6b7pjQbew1DMRgwpjValsJ0cOdZJgvkCJMU?=
 =?us-ascii?Q?JVt/LGsJsCiJBoe/iUvUXVQ1ki35ZK5lX1rBKy+RXxBpF5pEs7qOguW0zXpw?=
 =?us-ascii?Q?EslfH6oAiOX9+hqSFk5RhcGc6BzEJ1pSSGLe59j1fUWOpB2ZsrU5Mc2mgTHO?=
 =?us-ascii?Q?3gnJwqKzRx4ukRfbomxpvmqNgERROeeB/Z1n7Og6dixV/vIcllREaeUY8Z7E?=
 =?us-ascii?Q?pvkCIUo/DqSG7lK6YXAGQ6e8RSy0ERhy6/vuysFor5EG++yuY29shlj2ZIUn?=
 =?us-ascii?Q?UGiF2y3W7pP5bxzRrLlDSWRVy/PVI+qgG70H7MD7rNhDyQznWwwzc1lmblM0?=
 =?us-ascii?Q?NNeRnYt3+Tc46YQVSs1BKSR1o5+7gcojvqKQxLxLfWWbnH5REQsprDBNPOKK?=
 =?us-ascii?Q?9yzadpd6+X7EglA6uJ4uxCldG3vVhbH19zOSO29omYNYrQVLm6h6A+49J8Fl?=
 =?us-ascii?Q?JuxHFz32nuYcXbL1ahQYu2sh9pUocw4DADVzYBzZ5lFjribMDUA/VDLCU3QN?=
 =?us-ascii?Q?pBUe83HEQlQNZ3MUAEQ+nZpMgMOHgPLEWzWBzoL+ZG+2cKsXaDsIBAIteuDq?=
 =?us-ascii?Q?wfVY0zqvwrFoqQVIWbbVxcJRHgNC1uM85MOj/1mT05L1TnuoSKgp81784N1/?=
 =?us-ascii?Q?+AayI0pY/7hXliM4uhlMzM+AHwOgMIV25c2/bkc9UCwkUxvkCtT0ebXaQS0V?=
 =?us-ascii?Q?PRz3l3nVcFGl9jPSMhSlO7z0V7EhXGTaOvxYjgNbXXDEx+MPdht7nDgVn/3a?=
 =?us-ascii?Q?FLfwWUFoqIkGBG0Xo0B2im9gGLmuW0/CvvNnZ8qMr+OSOvBAo2cZ//bXjrQl?=
 =?us-ascii?Q?RAY1jSaO75Ox4PjrGGyP7AKWAC4jFCCQR0wgoXHgrZ/NkS1BAb65IfLIO7Nv?=
 =?us-ascii?Q?M0xUJqXTE0LrkMhQZxgSaqcSDKux0cIipSlFyzrARpNtcCsbG2STuMuwob9N?=
 =?us-ascii?Q?CS3Dvchf0Y6GiuMTbk9NzxkuBG0CG+Pz/6ehk/m568QOsZ4psu93h/nOK7a7?=
 =?us-ascii?Q?Sy31HsO35w7hsMs0kpjSYV9NmnkYfcK4sIz9CGm5dFxDzknYAqDrpBD2aMY2?=
 =?us-ascii?Q?DoyqMTUoKp4ETh2m1G4JsUoirmtjoqqveQFtWxOoJx+EpOkyCXmFzkZCGLD2?=
 =?us-ascii?Q?++Ew3CsTA1IzypPTCB9ExBPhkVvAO0mmPWIJgFeKxmUhEOp3bXbp/IOQGfPU?=
 =?us-ascii?Q?1wIUNxSrhbFwOZeWr1nCKkZfWxZxSaqGG4hHrrkjafHMfnyt7hx6Xp3mamnc?=
 =?us-ascii?Q?Z56GtfjkuvvlYdvj01khlgzs?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c78bb11-6906-445c-c9a4-08d926ba3171
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 18:05:38.3519
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H/9iOtiOhYU7C7ur190Hg9ZwGN6pOklOpLtpN/px/jUwm5QxQzFtmN1awQQgCAMPK0y3WuB8BMhrHo152oQTt13VptancJcrXTQ9yJW9E7M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5254
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 5/31/21 05:13, Maurizio Lombardi wrote:=0A=
> On realtime kernels, spin_lock_irq*(spinlock_t) do not=0A=
> disable the interrupts, a call to irqs_disabled()=0A=
> will return false thus firing a warning in __transport_wait_for_tasks()=
=0A=
>=0A=
> This patch removes the warning and also replaces assert_spin_locked=0A=
> with lockdep_assert_held()=0A=
>=0A=
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>=0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
=0A=
