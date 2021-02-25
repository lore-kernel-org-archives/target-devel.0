Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 098B3C433DB
	for <target-devel@archiver.kernel.org>; Thu, 25 Feb 2021 22:23:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACD2764F47
	for <target-devel@archiver.kernel.org>; Thu, 25 Feb 2021 22:23:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbhBYWWc (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Thu, 25 Feb 2021 17:22:32 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:45003 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbhBYWVz (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 25 Feb 2021 17:21:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614291714; x=1645827714;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=b77wNL3SNVmx7/RUspx7jX5gWLKL7bkY8+IcR5wns/8=;
  b=OYY964dV5cXlI4Mq8onfNbcMIl86fwqh/JvKEaF0B9cQ8M+L0u4sTW3t
   Xf4cu4GO1E/7SvDue1LXzgJDf/7vjwBfuYW+AiUfK5MHMSZ1JFZBuP4Qh
   WmwbW7ArBPcD7ZCPPSkpbvlZlu1rdXZD5KM51busPEJffobCbI4pIF3fu
   nTCX34Ovo31gDxU/uVOP24LuE+YSearVGzprEiGssgeA1r18iFw2+FV7b
   Wt0TAD0Ls183Nn3sn8/hZvOzMhxEWTJx01rJVvJ/I0c3VUiCPLxIk3cNW
   sjqkv/B2sZdaaySr9tzD/Ubm6lbdTQkcDtZScrYRW5oULGK0fKbbNJxAL
   w==;
IronPort-SDR: fURg+9dykrkQBTCe8HDKYaELfWWi5le85r10lVP3UzIlGKAo274Gft+iOgVLL4uoPMoehspQgt
 8gIIKjwAeemGjjCDQu+jZ2iXF3/5k6tsOKINoc38jtejm/IzVUZyfW5pkoh/OB8ICBSQHENmt1
 lIgb8pwINHXOpAc+OLNife17hhcxv4G4undktD/FVFK7j2VP2mn2QwaqTZuhCLcXEHNCwwgCPl
 3PjdLjSDxKII4pk7142k3bcl0W0t2OtqPFFrfoWEdPwkm2d96hnoIKKC7NAB/bHTbf3Ue4F5V7
 bMg=
X-IronPort-AV: E=Sophos;i="5.81,207,1610380800"; 
   d="scan'208";a="160847520"
Received: from mail-mw2nam10lp2109.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.109])
  by ob1.hgst.iphmx.com with ESMTP; 26 Feb 2021 06:20:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bMzzWbngjQ2pVlU4/hFs9bkTxkwkpVfZFIg/4FAsrlDBmiW4V7CpzbkcmIphuQrhPEQZE5oZXq4995db4PHrG4vwVdv0RoTXr2ZLT2rsAI05TKCHM7zbMjJjlkaoYfaPsXfTL70ZScZmIP6sUAnm3CgDXiPkio43OZRQwjoBRWjGWhECJcPSGC8jtYw5wm6LBilJASBZ8wK/fCXdeTaa4qVcUXCHKZT6+Xiu+1s1i6DBG6RLqvz95NqCiRuuoFHnsC/ERKLqQvr2PrnEohvvrjl8LHEggfFZo8aeEMLghHeSxn/ly1LDJePgDZEvrKyxhuxHo0HUI23G3X5kD9rX/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3ZwCdOqZowRnEZkfsIs91O5AWIh5SYsVmEUsTJKCO4=;
 b=J6/xo5tVnRcVEpg2GhBZpEGEWCdm0sWWP/3YqiDUtBEJMoAuUkVc0lzE4ZvrhX0TlZJF4jJTO+PZLHckavmdYZeBJ+WddLGqKxu+EHUSTB730FVyUpW9VMxsm9N/uXM9CjSjPd3yMq3iDU6BSHXq0RTrtI7kS7FyuPZY4lD38zGXGmyevpcU+buxqmYD4vthBUR3rwq0gyGXIS7+D+Kvtm0uR2ZiAWGxsezw1DdLAZUVJLs6EP3kkNQ98RbhDw6BJ7I7VQMY+QBxg3aPFXCF5f0DnntCKVkXgXPZUXKG4DcYdFZnBIiUcVaUyVuwUl5pYtLVQZWzDNWdye351BS64w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3ZwCdOqZowRnEZkfsIs91O5AWIh5SYsVmEUsTJKCO4=;
 b=Jfe5WClOLdJhrF4fKcZhIxWER7CHeQmbiwj+RIwl/hML/DrArnJB7bolg1SV4vdvBIbFz7raoyBjdrrd3+4ohVPc8oq9rYpBvhlU49KIVz3YdDfdrs+02K9YVX9PWkdTt2pwO88C/Wpo8eX3+OLbRWFvU6ioho7QUKYfRvStWPI=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BY5PR04MB6642.namprd04.prod.outlook.com (2603:10b6:a03:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Thu, 25 Feb
 2021 22:20:42 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b%5]) with mapi id 15.20.3890.020; Thu, 25 Feb 2021
 22:20:42 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Forza <forza@tnonline.net>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Subject: Re: Stability of FILEIO as backing store?
Thread-Topic: Stability of FILEIO as backing store?
Thread-Index: AQHXC8Apl6gx6GB5ikC4fy+f6e6DKQ==
Date:   Thu, 25 Feb 2021 22:20:42 +0000
Message-ID: <BYAPR04MB49653ED025E1DFF859FA5879869E9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <af031d3.b2327dec.177db1f2641@tnonline.net>
 <BYAPR04MB496533F6262231DB6CF6C6DC869E9@BYAPR04MB4965.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: tnonline.net; dkim=none (message not signed)
 header.d=none;tnonline.net; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2904b183-0d4f-4cad-f269-08d8d9db96f4
x-ms-traffictypediagnostic: BY5PR04MB6642:
x-microsoft-antispam-prvs: <BY5PR04MB66425EB333F015DA8B284459869E9@BY5PR04MB6642.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n0tE1wtZZK35PyRodP2bS5x2Lmhrko57x2qqWb1F6z6JNnVqcEeBaS0VpZZ2jKF9I3yyv5T6GDSTVJMm+yCpaGNckOfTBWmgP6ukKUu2VtPKZ0O+8G+S4dGEFhe7mkmwona7G6yLROGe1ar6TpTWqIVEHJ2J9aoZrxxgSF7j4FiXMapsP6Rjow6/LxislhCUlQ3oqO8kUFS8q0F1IYidit1GG+XjRC9Ut13CQjvxabmVZjQBjQy+1hVhVyEhkRUqgIV7IkXcmPjdXv86OAVzeNGSUvfuhXyUHVnLJIfWD4LyyBQt9+abnqXf1kkJrF2cz6XrZVeWgxopKeDLG/Gn6/AwGNbldfxe1GAx50wftaAT/j+BIuUWwzjMhGejycP0TZQIih1fgXPAkbgNe6CNhikd+LX/zs6k/+7h79mlX1TPqQFIfPIWsyBBarpg3VF44QvKl61hQjixLgsfORQDRL6eOefB7ucdWwD3qmhH/a8Iks6M8x348u7PJfu5ZZ2JW/87+mDA0e/fiDQ4M9voKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(186003)(478600001)(91956017)(26005)(5660300002)(66446008)(71200400001)(66476007)(86362001)(33656002)(66556008)(8936002)(316002)(110136005)(83380400001)(64756008)(53546011)(52536014)(76116006)(55016002)(8676002)(66946007)(7696005)(2906002)(6506007)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?IOdkLv+ZWN/DwReocjhas3eMeyvUsmkvAOS6/aC7sbuUHtGsDbxcCDkVkPWu?=
 =?us-ascii?Q?99vcgDmREET0Q7vjf84htgJd7EEmNYTMI+J0N/8ozUlN7eAlwkoOKYxpGHz/?=
 =?us-ascii?Q?j/a93H79SO23dG46ySoY3zgPhncx6FGUCKNmOxbSz+FELppsc4vyGYoTDito?=
 =?us-ascii?Q?N4TVHeCAdtqd6eMHP/d9ce06DBLMdliY5SLhJKzkh9Doqq8gv/VC66tUJ485?=
 =?us-ascii?Q?gR54GasG1YRO2GTlo3cpT0nfyhB8WFmlHc8jRTNB5V7tPc6JziItdgpCJjn6?=
 =?us-ascii?Q?8a4wn6jkCYFINmNgpU8Ig1uOszg89hem3L9S4kQHwmQrVNmTgepLUKK/MQ+1?=
 =?us-ascii?Q?SoN12XOnnjPFVrjS7QMl1jCPEPOqrT4DAyRzzLUCvBB4A9/ddnF/eeifOuuh?=
 =?us-ascii?Q?T2pdfXzxxN+BptYnQ0dTjNEvR/NMzg1sSOyutVUfSF4uaKUc0V611/NFBKRs?=
 =?us-ascii?Q?vp0o6+UxgwDlzonMQnENMs8ewxHci2BOZ7E0MAVK97lTbN+mAWFivQG40D4t?=
 =?us-ascii?Q?VClRAJ3xqtKmI7s6h0X/Ga6T/bqfc2dljsFVNxnDMwwOYLznph2sct8eedux?=
 =?us-ascii?Q?nfhCwMPwdVdYp/n7VLAEmPXxdCGXojBKQSDugV/V09K0jZPSnoz/d/e3mAm2?=
 =?us-ascii?Q?JhqxnWk/a2EvMeEf+G0iYgD1yHHGzV1uWT3ZEVdmhVNjgqxArpA6ikcPYYgs?=
 =?us-ascii?Q?8dUe4Tw5u7ij6LZoO4klP0CXuU3IYGOvu1C34OMEOaXLAIweuMRzdDohHehb?=
 =?us-ascii?Q?y4wsEFTSIHcoZwWEta/guJDvyIOP0n9MSdj4Kxuj9OIfEwIpjg3/+oNFbNHg?=
 =?us-ascii?Q?XAxjnwm7FWu5RnLcbspZlMmyl4rkiK5gHoToTSA6zob7C+0nPYwDqa/x8dpw?=
 =?us-ascii?Q?EUZnLDkCvZ5zUu+x/phH+UFltI9jG4AKBPLawsm8o5bX+9/He3U11p/Zt/OC?=
 =?us-ascii?Q?Vlojbr9vYMTSTY/YVowiVKddyYKvGRgyaGfR0UXjr4uYuS2dWkQegarVa16k?=
 =?us-ascii?Q?hcKsy+E3DgWt2Xw8LRA5iXKfFcgMcjFVfPJ6aFeVf3UK5ILL6kZT/LXbz8sV?=
 =?us-ascii?Q?opnSwuWPJD36o8JYNng/OUXDsOZPHf9R5Qnqe0hfuZ2Ql1fJb89g8BGF2Ocz?=
 =?us-ascii?Q?Qjl9gYGjSZtyOt6yWg0MrykeGeOofb2SoKaucLuvL5a9ep3L0Jj0Sl3/WId0?=
 =?us-ascii?Q?H/1Brca/z0awbyUYOT4OaUcqVjzFzSnShIpHxAYuapqqT+xjaFRK5tTWBEYF?=
 =?us-ascii?Q?kuqLe9ItF9hUgpTZo+pSklrolSbBHIw89zwytC/zhrk3ArNb9dgwvhURU0ai?=
 =?us-ascii?Q?gg/Gmj2t2fSBEyxm/8COiLRR?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2904b183-0d4f-4cad-f269-08d8d9db96f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2021 22:20:42.5586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R+rqQrJ+tK1T1yhNFkff0TlW5T9BbU3w3hPP1J7cbk1/6AfFRblx/ADMfYWHirp8UuJ8H2kbYV8m7P6+aEV+/Z1Nr4hw+sRHsubEyX/pTnE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6642
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 2/25/21 14:12, Chaitanya Kulkarni wrote:=0A=
> On 2/25/21 13:49, Forza wrote:=0A=
>=0A=
>> The LIO target is running Fedora 33 Server with two Seagate Exos 10TB in=
 Btrfs RAID-1 mode.=0A=
>>=0A=
>> Are there any debugging options that would help?=0A=
You can try following patch to get the more information about command=0A=
completion error :-=0A=
=0A=
diff --git a/drivers/target/target_core_transport.c=0A=
b/drivers/target/target_core_transport.c=0A=
index 93ea17cbad79..f4e6e1c18867 100644=0A=
--- a/drivers/target/target_core_transport.c=0A=
+++ b/drivers/target/target_core_transport.c=0A=
@@ -873,6 +873,11 @@ void target_complete_cmd(struct se_cmd *cmd, u8=0A=
scsi_status)=0A=
        cmd->transport_state |=3D (CMD_T_COMPLETE | CMD_T_ACTIVE);=0A=
        spin_unlock_irqrestore(&cmd->t_state_lock, flags);=0A=
 =0A=
+       if (!success)=0A=
+               pr_err("%s %d  cmd->scsi_status 0x%x"=0A=
+                       "cmd->se_cmd_flags 0x%x\n", __func__, __LINE__,=0A=
+                       cmd->scsi_status, cmd->se_cmd_flags);=0A=
+=0A=
        INIT_WORK(&cmd->work, success ? target_complete_ok_work :=0A=
                  target_complete_failure_work);=0A=
        queue_work_on(cmd->cpuid, target_completion_wq, &cmd->work);=0A=
=0A=
> One way to go about it is to turn on the target tracing and examine the=
=0A=
> commands to=0A=
> see which command is failing if target has command level tracing=0A=
> implemented.=0A=
> This will allow other developers to help you more.=0A=
>=0A=
> Also if there a problem with the file system then you might want to run=
=0A=
> fsck before you=0A=
> establish the connection to make sure you have not encountered file=0A=
> system level errors.=0A=
>> Thanks for any advice.=0A=
> Also please mentioned that which kernel version you are using so that oth=
er=0A=
> developers can help you more.=0A=
>> ~Forza=0A=
>>=0A=
>=0A=
=0A=
