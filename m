Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B2A7C433DB
	for <target-devel@archiver.kernel.org>; Thu, 25 Feb 2021 22:11:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2693B64E6B
	for <target-devel@archiver.kernel.org>; Thu, 25 Feb 2021 22:11:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbhBYWKr (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Thu, 25 Feb 2021 17:10:47 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:20142 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbhBYWKo (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 25 Feb 2021 17:10:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614291042; x=1645827042;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=YUIrruT6UaL1OW/zCPKM4pFkk3lX9FzmpiGU+8UKhLY=;
  b=HJKWWjI0A1M63UfTCT8MRiVT4+BsvWOzUC+EibQ7d9Tb/SzzP4U5Z/VM
   tto9ObHiVrkakwHvvsK5jz/vRb6N8rydZYXY51+EOZw0T3cTcC8jnhY3m
   sTYhruhFb/hS+Kj4pO+HcDT48zY+7ZCiNSaV9/q8m+OT6/98cr3y2GGk/
   0/jaYIw9IDk0ymT9pdvUUl9Y5T5CcSoKKVmcQT6ITzRi2dn+hYkSlNgGp
   q9AXfcby09voLLoysfJpXCtHqBIE+Yo3HGHbbWcQ/Z/UnWtAmZGd+bRxh
   lObvPApY/v8VVJ/xIowfTjP6l9uGXglTicxMldgBHGcA9qc3JtreeLRIo
   A==;
IronPort-SDR: T3l/7ohi2VPDc5ZJIJqyelZ3zRSYf0cSAiBamkKHFk1VSOca9CHaxQEobAqFqxVLRok6SGyxI5
 mw/V+lfij1RS+RUqYEiQfT5ArqaAnX3irB10X2DydVU4c/vmUW2ameqMDlhj4y/3omjbbtiOL2
 ma8YVlWxKZcDfJ7dMcX8PqORI/g0B8T6GXXzLrx4TAPb5ppuL2D9WMpa4k4mibBGpzC6ZEqarf
 pMxzDvXnhmdUH35VvDa82iMm7KhtMT09Wlml44iVz8JiEzAvaXefbzPadW0iYhPsvzYjAB0xjL
 0Pk=
X-IronPort-AV: E=Sophos;i="5.81,207,1610380800"; 
   d="scan'208";a="160818217"
Received: from mail-bn8nam11lp2177.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.177])
  by ob1.hgst.iphmx.com with ESMTP; 26 Feb 2021 06:09:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f06+ywAdMe0XNqjaKBI6tVfT8ZpXl3gptWSlHPm8hASMIRkYxLEvylPDuSIZC/BBgz1DKIMIPSnt7E/GIlAkQ2zpieH8fg9sseo1FzmtfFnxjqX4BFyI++xJqvzVMcXDJL+sBaw4a552xbw3fsa7Bxd0fQ+npLFnFeNbWqBmrsPYhXiaJpitG61+yHebt9ep3HF5aq5kVQmc0som8UyEVkpU3eV5frDgsyuca8JesSF5fhYi3YMSfnrShghnozs9osrGvsD9Fk5yuW7rhO6GkVYbd7gKRJRa7z8RrRZxPQmvXRWBXgMPdWzMMMYGbG0OyLJ6rxSrlDMifuAatSX82A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fDjW9zOJoJGN9soC5PAaTJCKl9QMY1wJ3pqQGTgEWO4=;
 b=DQjcVClPQarZFiHEF87f9dhGaCfNcxEh9HR8YNnlKIcjMkFsq6WeAnGJqfU5WXDc2xhCVMum5ednOHmqD4EcsFhwEzWJw7tB2PqeZkjn09O/Qu/SsJLPU+EhPIwzTdcRJrrqK+qBWJZApzHzP7gP8fucvETgJO9q/NUgHHSvSiEhhFKNb/90GxvnTpzHbHXPd0ukgWI1m8zsqEfArat04NCfk5/mhhoPHpWJ+WNMYS8w3154CYzyCmfkngbScrpa98kLxO61GiATFLKTd9qglSbGtuNwGUiJIEpSV/y463ZyvWkNMI5dspXI3WWrt+Ngd0Fy5oSJYEBg89tJDERj0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fDjW9zOJoJGN9soC5PAaTJCKl9QMY1wJ3pqQGTgEWO4=;
 b=qEGnhHEPfDcVQFolFaxIHd4SqP2My6ulFn18fA4SbgLKCquEAv1vLRPS/b+bF9po4pOp6DcJ8eocD/4+5kOMWB8P/N9YeA7IA8E7b99s6IOjFWk7K0u8VO7lfEGGvEfYV4VTv5/VfLwmjBAy0lVyDQ1XTZf3mXKIXjVygp8nmg8=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BY5PR04MB6867.namprd04.prod.outlook.com (2603:10b6:a03:22c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Thu, 25 Feb
 2021 22:09:35 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b%5]) with mapi id 15.20.3890.020; Thu, 25 Feb 2021
 22:09:35 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Forza <forza@tnonline.net>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Subject: Re: Stability of FILEIO as backing store?
Thread-Topic: Stability of FILEIO as backing store?
Thread-Index: AQHXC8Apl6gx6GB5ikC4fy+f6e6DKQ==
Date:   Thu, 25 Feb 2021 22:09:35 +0000
Message-ID: <BYAPR04MB496533F6262231DB6CF6C6DC869E9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <af031d3.b2327dec.177db1f2641@tnonline.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: tnonline.net; dkim=none (message not signed)
 header.d=none;tnonline.net; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1e9ba972-518b-4b88-63e6-08d8d9da096f
x-ms-traffictypediagnostic: BY5PR04MB6867:
x-microsoft-antispam-prvs: <BY5PR04MB6867F90230085F6818F35D94869E9@BY5PR04MB6867.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C0uhdZY+rzHlY6g1SDdJB4iv0+LnwYjeDGwfvdxeye4MlW4TGpsLb97gaU51B/kv7pXqb4+UI5euaNze3DEgk3bEzfUguftjlG98IjJ6qOs5yXogsxicqWxgPZ4y+EtVUuwxnpQuzRsIAgKsBo0n9YqV61di6cae73KdLG9BaEYoGT2OFYrDVOHocLwVX6vGpifEA1U6Kpgmfqbpquhkv1tOAZJcdDvtaD6ZQhMfwJcQidtWuPdZHKtruCv5cwkjz69YGnJrsf88vkI5d7WDgdzbcabiUE2VrPF5x8tBeVo8mZ5lSV/D/cZ75cezRQjssf/d8hfVo/UbAYbB183YrAg/ZoLLRpxtNSVaiv3URMn8eyGZKFRRkg3b5KgWon7VEJUh8CuuFzEV7VfSTtZxeK1GZ//Ci0wOSPPFxfC4n7TqRYz245RRGweG63QrO+qR8Yq7ROyTIrKXJj8rzSZZeuxFS6U8M852Y9cOX60AI/p9IFTo7VgFbMZxbc5GSfCFQ0JUcUwrCWTsMCuXGB7QkA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(346002)(136003)(366004)(53546011)(316002)(8936002)(6506007)(7696005)(83380400001)(2906002)(86362001)(110136005)(33656002)(66556008)(52536014)(478600001)(5660300002)(91956017)(26005)(66446008)(66476007)(66946007)(76116006)(9686003)(8676002)(71200400001)(55016002)(186003)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?EEBWjvgoWmMntihFVMPI5RHXwufaz/UJj0rp0c5TibndH8YC3ek7QRB43/9p?=
 =?us-ascii?Q?iuNEe6WyKqUjxmWcY5qoHNNdPMBphLoTkPL9D+wyN+S3JA8Mpg2WyK19LAUu?=
 =?us-ascii?Q?HnqazxFFNLSC2zozpjD78g0QMXWdsA22Rc02Egh0ggr4CjWHdJrRw/0bZByb?=
 =?us-ascii?Q?mqzfja06mSroy49LhY0PNPcx58TigGjPYz+IfE6RyAQnEp1SiF2MclGbvNFH?=
 =?us-ascii?Q?cPaoWmqNWTlXpwc3zhAvE1HCxRbQ3/CtDGYc7ZL3CPAui+UL2ktV6CB3Spsm?=
 =?us-ascii?Q?aaJOgjur1jXBCx7Ql/u4CuIL9/Eg97n6pU/0A2fBEOdlxQK/tUl8e2SdLM3z?=
 =?us-ascii?Q?jRpkcwnt179oFXn77ueHAog18lM5lTgQAzSbwJGOUQF1ncG0amj6DDavxQfE?=
 =?us-ascii?Q?k4VuSoW1pkupjRPc6HUg5h2P3ozqCCtd2rN33teV9bdQ5c4W8OcZZdSAIaKj?=
 =?us-ascii?Q?DFuOOg9WKa8wfPPIeh3CV7Wgscopj6s9gXppV126ylXxG6SXX9qN2IsLD4B4?=
 =?us-ascii?Q?w3YfbIN63n5Uqqr+57yxNy4QSIUjt6892j9aj2dffPpdnvqspsDbnTXjglDt?=
 =?us-ascii?Q?RwyWya3ai3sivIWJV5wO8ZTdU6NqsUCREZa8TpnG2Ux+N/6ntZmRuPH1pEoJ?=
 =?us-ascii?Q?Wwz5cpquovCkBVx8wDh3F8HlrdZxVROyatk1jWPMEIQekCUbR6l26we7ZUEe?=
 =?us-ascii?Q?n7xjtHZBXa+I8QMzS/r+o/VW4QFOj6aKAXxil3HsS55lpU/dbFFksNo5VOxj?=
 =?us-ascii?Q?4gZlf0quYJkNWI7Qv/lv4ARoeWl7ApEGXoTpQhAdeDp/rjFcKJWY/LyO0jj7?=
 =?us-ascii?Q?jH3Ib6/aNUyMVnjLoGG3ByMhnXYvDO7VaeCDtQdAqJZee9K4VAuNWpKH5qtz?=
 =?us-ascii?Q?JcS1EPIuvnAMAF9/nUjR1ruyKEWNT4qlkixbQN7bpmvUyVYvKIc/x3uIWh+q?=
 =?us-ascii?Q?Q1AtFYObFX8WN2/NcwUMGAgl8n7X9B4HkzakrI8lNJFnqKagQotvRQpRjcpb?=
 =?us-ascii?Q?rtzLd53tQ2LrVV3pP+84od3QkvTNZxb5h0KhXsruA8L0VxBPN5nKMoYb3KWF?=
 =?us-ascii?Q?CpmRJW2Ro0C2qAA5vakd4i6Zlna4Pzih5VZyEgvE9t9a9U0lM1zXLOA3pST0?=
 =?us-ascii?Q?dHwa7vJGkR44YWg84ig9Sism5jDWKNuU1KiT1WZXjbNckmWueS+QFIeZPnBW?=
 =?us-ascii?Q?CxCvfj2ih15N8FDh4/yz2PzXw+wqVrJy7U0knWOPrU0R6xP56eOfB3MpQ1VZ?=
 =?us-ascii?Q?a9Oan8h6kn2Mm1n4UUbtPq66W7UuLBsnmnAq9gNZu48hEOJRjrYUJ/QwP8Ss?=
 =?us-ascii?Q?5gCI39ZiRYZKy2kLzcO+zRx6?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e9ba972-518b-4b88-63e6-08d8d9da096f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2021 22:09:35.5948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YsEahAZ+9GAARUYwqZDsvOvc90YQWlc9Pl/l2DBgvDk455lK5BAtNmNA0NV3jXXyDWZYjpvwmZb7MEcdEdjJNC2RsRGCBsSe6AhjRWTbX7w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6867
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 2/25/21 13:49, Forza wrote:=0A=
> Hi,=0A=
>=0A=
> I have a weird issue with using a file as backing store with a Win2016 se=
rver as initiator. =0A=
>=0A=
> Very often if I reboot the Linux server the disk image becomes corrupt so=
 that Windows cannot even detect the gpt partition table on it. It can happ=
en even if I shut down the Windows machine before I reboot the Linux server=
.=0A=
You need to first isolate the problem by running the data verification=0A=
test with loop transport=0A=
on the linux and make sure everything is working fine before you move on=0A=
to the windows initiator.=0A=
=0A=
> Initially I thought I would be write cache. But I've disabled that with n=
o benefit to this problem. =0A=
What were the steps taken to conclude that it was not the write cache ?=0A=
> There are no errors in dmesg except initially when loading the target. Pe=
rhaps I'm doing wrong when rebooting? =0A=
>=0A=
>=0A=
> [   71.583665] dev[0000000064b6f5d8]: Unable to change SE Device alua_sup=
port: alua_support has fixed value=0A=
> [   71.583676] dev[0000000064b6f5d8]: Unable to change SE Device alua_sup=
port: alua_support has fixed value=0A=
> [   71.583837] ignoring deprecated emulate_dpo attribute=0A=
> [   71.583874] ignoring deprecated emulate_fua_read attribute=0A=
> [   71.584553] dev[0000000064b6f5d8]: Unable to change SE Device pgr_supp=
ort: pgr_support has fixed value=0A=
> [   71.584561] dev[0000000064b6f5d8]: Unable to change SE Device pgr_supp=
ort: pgr_support has fixed value=0A=
>=0A=
>=0A=
> The LIO target is running Fedora 33 Server with two Seagate Exos 10TB in =
Btrfs RAID-1 mode.=0A=
>=0A=
> Are there any debugging options that would help?=0A=
One way to go about it is to turn on the target tracing and examine the=0A=
commands to=0A=
see which command is failing if target has command level tracing=0A=
implemented.=0A=
This will allow other developers to help you more.=0A=
=0A=
Also if there a problem with the file system then you might want to run=0A=
fsck before you=0A=
establish the connection to make sure you have not encountered file=0A=
system level errors.=0A=
> Thanks for any advice.=0A=
Also please mentioned that which kernel version you are using so that other=
=0A=
developers can help you more.=0A=
>=0A=
> ~Forza=0A=
>=0A=
=0A=
