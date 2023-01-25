Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16727C54E94
	for <target-devel@archiver.kernel.org>; Wed, 25 Jan 2023 08:29:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjAYI3y (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 25 Jan 2023 03:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235100AbjAYI3w (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 25 Jan 2023 03:29:52 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D49272E
        for <target-devel@vger.kernel.org>; Wed, 25 Jan 2023 00:29:50 -0800 (PST)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id 44989341A4A;
        Wed, 25 Jan 2023 11:29:48 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-transfer-encoding:content-type:content-type:date
        :from:from:in-reply-to:message-id:mime-version:references
        :reply-to:subject:subject:to:to; s=mta-01; bh=CvsNYhOMZXC7TvfrEY
        jJfGGRi50HuEl/W+oDuQ19cKw=; b=H2rwiRAnP8KFLjnl8nrrHj+k1SCFJU6xI2
        95GhMDD7yFBW4aFM5Kh+PuOd6/2bzNXxnRCgxzpSnCyXXpg5HHe/9kjH5p4ceM0S
        j34gSUHmsUeAImAZ3WWDEEPKQzKeemOhvHMASa7H2+KfHHiAjXFH8zt9rdt0gjfI
        ykB4LrkgQ=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 38606341472;
        Wed, 25 Jan 2023 11:29:48 +0300 (MSK)
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Wed, 25 Jan
 2023 11:29:47 +0300
Date:   Wed, 25 Jan 2023 11:29:48 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Forza <forza@tnonline.net>
CC:     <target-devel@vger.kernel.org>
Subject: Re: iSCSI target: kernel: NULL pointer dereference
Message-ID: <20230125082948.GG31614@yadro.com>
References: <cd1ab2c.ace55083.185e577f69d@tnonline.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <cd1ab2c.ace55083.185e577f69d@tnonline.net>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Tue, Jan 24, 2023 at 09:28:42PM +0100, Forza wrote:
>=20
> For the past year I have been experiencing spontaneous reboots with days =
or weeks between each time. So eventually I got a tip to enable pstore and =
was able to capture several traces, and all are the same. See below.
>=20
> I am using Alpine Linux with kernels 5.15.x all the way up to 6.1.6, but =
the issue is the same. The issue seems to be mostly triggered when Windows =
2016 servers that have some attached storage are rebooting during maintenan=
ce. They do not boot over iscsi, it's just extra storage for some apps on t=
hose servers.
>=20
> The target backingstore is using FILEIO ontop of a Btrfs filesystem (i.e.=
 no pass-through to sas controller, etc). There is write caching enabled, b=
ut it happens even without it. I opened a report on bugzilla, earlier. Ther=
e is a saveconfig.json from targetcli attached there:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216959
>=20
> The issue seems pretty reproducible, but I am not sure how to debug furth=
er. Please advice.
>=20
>=20
> Stack trace:
>=20
>=20
> <6>[ 8364.650898] ice 0000:01:00.0 ice0: NIC Link is up 25 Gbps Full Dupl=
ex, Requested FEC: RS-FEC, Negotiated FEC: RS-FEC, Autoneg Advertised: Off,=
 Autoneg Negotiated: False, Flow Control: None
> <6>[ 8364.651003] IPv6: ADDRCONF(NETDEV_CHANGE): ice0: link becomes ready
> <6>[11218.918482] wireguard: WireGuard 1.0.0 loaded. See www.wireguard.co=
m for information.
> <6>[11218.918484] wireguard: Copyright (C) 2015-2019 Jason A. Donenfeld <=
Jason@zx2c4.com>. All Rights Reserved.
> <3>[154888.236235] Did not receive response to NOPIN on CID: 1, failing c=
onnection for I_T Nexus iqn.1991-05.com.microsoft:srv,i,0x400001370001,iqn.=
2022-02.com.example.srv04:srv,t,0x01
> <3>[154908.716136] Time2Retain timer expired for SID: 1, cleaning up iSCS=
I session.
> <1>[154908.716177] BUG: kernel NULL pointer dereference, address: 0000000=
000000140
> <1>[154908.717023] #PF: supervisor write access in kernel mode
> <1>[154908.717842] #PF: error_code(0x0002) - not-present page
> <6>[154908.718667] PGD 0 P4D 0
> <4>[154908.719486] Oops: 0002 [#1] PREEMPT SMP PTI
> <4>[154908.720289] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.1.3-0-lts =
#1-Alpine
> <4>[154908.721089] Hardware name: Supermicro Super Server/X11SCL-F, BIOS =
1.9 09/21/2022
> <4>[154908.721888] RIP: 0010:sbitmap_queue_clear+0x3a/0xa0
> <4>[154908.722667] Code: 65 48 8b 04 25 28 00 00 00 48 89 44 24 08 31 c0 =
8b 4f 04 ba ff ff ff ff 89 f0 d3 e2 d3 e8 f7 d2 48 c1 e0 07 48 03 47 10 21 =
f2 <f0> 48 0f ab 50 40 c7 44 24 04 01 00 00 00 48 8d 74 24 04 48 89 df
> <4>[154908.724376] RSP: 0018:ffffa6e400003d48 EFLAGS: 00010202
> <4>[154908.725249] RAX: 0000000000000100 RBX: ffff8ddc43039428 RCX: 00000=
00000000005
> <4>[154908.726137] RDX: 000000000000000b RSI: 000000000000004b RDI: ffff8=
ddc43039428
> <4>[154908.727030] RBP: 000000000000004b R08: 0000000000000000 R09: 00000=
00000000000
> <4>[154908.727921] R10: 0000000000000000 R11: 0000000000000000 R12: 00000=
00000000000
> <4>[154908.728812] R13: ffff8ddc43039380 R14: ffff8ddc49015370 R15: ffff8=
ddc490157e0
> <4>[154908.729715] FS:  0000000000000000(0000) GS:ffff8df9aec00000(0000) =
knlGS:0000000000000000
> <4>[154908.730638] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> <4>[154908.731569] CR2: 0000000000000140 CR3: 00000002dc20a005 CR4: 00000=
000003706f0
> <4>[154908.732526] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> <4>[154908.733487] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000=
00000000400
> <4>[154908.734453] Call Trace:
> <4>[154908.735411]  <IRQ>
> <4>[154908.736371]  target_release_cmd_kref+0xd1/0x1f0 [target_core_mod]
> <4>[154908.737425]  transport_generic_free_cmd+0xd1/0x180 [target_core_mo=
d]
> <4>[154908.738485]  iscsit_free_cmd+0x53/0xd0 [iscsi_target_mod]
> <4>[154908.739536]  iscsit_free_connection_recovery_entries+0x29d/0x320 [=
iscsi_target_mod]
That is a command handling from a dead(freed) session. I have a not yet
shared patchset for it, will post it now.

> <4>[154908.740595]  ? iscsit_check_post_dataout+0x440/0x440 [iscsi_target=
_mod]
> <4>[154908.741662]  iscsit_close_session+0x13a/0x140 [iscsi_target_mod]
> <4>[154908.742749]  ? iscsit_check_post_dataout+0x440/0x440 [iscsi_target=
_mod]
> <4>[154908.743848]  call_timer_fn+0x24/0x140
> <4>[154908.744923]  __run_timers+0x231/0x2c0
> <4>[154908.746007]  run_timer_softirq+0x3b/0x80
> <4>[154908.746891]  __do_softirq+0xfa/0x32e
> <4>[154908.747607]  __irq_exit_rcu+0xf0/0x150
> <4>[154908.748320]  sysvec_apic_timer_interrupt+0x9e/0xc0
> <4>[154908.749037]  </IRQ>
> <4>[154908.749747]  <TASK>
> <4>[154908.750457]  asm_sysvec_apic_timer_interrupt+0x16/0x20
> <4>[154908.751189] RIP: 0010:cpuidle_enter_state+0xde/0x430
> <4>[154908.751811] Code: 00 00 31 ff e8 f3 8e 9b ff 45 84 ff 74 16 9c 58 =
0f 1f 40 00 f6 c4 02 0f 85 33 03 00 00 31 ff e8 98 6a a2 ff fb 0f 1f 44 00 =
00 <45> 85 f6 0f 88 93 01 00 00 49 63 d6 48 8d 04 52 48 8d 04 82 49 8d
> <4>[154908.752966] RSP: 0018:ffffffff94203e38 EFLAGS: 00000246
> <4>[154908.753560] RAX: 0000000000000000 RBX: ffff8df9aec36738 RCX: 00000=
00000000000
> <4>[154908.754162] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000=
00000000000
> <4>[154908.754765] RBP: 0000000000000002 R08: 0000000000000000 R09: 00000=
00000000000
> <4>[154908.755365] R10: 0000000000000000 R11: 0000000000000000 R12: fffff=
fff942e1660
> <4>[154908.755962] R13: 00008ce37eff2c4e R14: 0000000000000002 R15: 00000=
00000000000
> <4>[154908.756545]  ? cpuidle_enter_state+0xbd/0x430
> <4>[154908.757011]  cpuidle_enter+0x29/0x40
> <4>[154908.757474]  do_idle+0x216/0x2c0
> <4>[154908.757935]  cpu_startup_entry+0x19/0x20
> <4>[154908.758393]  rest_init+0xcb/0xd0
> <4>[154908.758848]  arch_call_rest_init+0xa/0x47
> <4>[154908.759299]  start_kernel+0xacd/0xb25
> <4>[154908.759744]  secondary_startup_64_no_verify+0xce/0xdb
> <4>[154908.760181]  </TASK>
> <4>[154908.760591] Modules linked in: wireguard curve25519_x86_64 libchac=
ha20poly1305 chacha_x86_64 poly1305_x86_64 ip6_udp_tunnel udp_tunnel libcur=
ve25519_generic libchacha nf_conntrack_netlink nf_conntrack nf_defrag_ipv6 =
nf_defrag_ipv4 nfnetlink_acct nfnetlink rpcsec_gss_krb5 sch_fq_codel target=
_core_user uio target_core_pscsi target_core_file target_core_iblock iscsi_=
target_mod target_core_mod configfs nfsd auth_rpcgss lockd grace sunrpc xxh=
ash_generic nls_utf8 nls_cp437 vfat fat bonding irdma coretemp intel_rapl_m=
sr intel_rapl_common i40e ib_uverbs ib_core ipv6 intel_tcc_cooling x86_pkg_=
temp_thermal iTCO_wdt intel_powerclamp intel_pmc_bxt i2c_designware_platfor=
m iTCO_vendor_support i2c_designware_core kvm_intel kvm irqbypass crct10dif=
_pclmul ghash_clmulni_intel sha512_ssse3 aesni_intel crypto_simd cryptd rap=
l ast drm_vram_helper intel_cstate nvme pcspkr efi_pstore wmi_bmof drm_ttm_=
helper nvme_core i2c_i801 igb ttm i2c_smbus nvme_common hwmon i2c_algo_bit =
dca mei_me intel_lpss_pci
> <4>[154908.760674]  intel_lpss idma64 mei virt_dma joydev mousedev input_=
leds intel_pch_thermal mfd_core ipmi_ssif ice ie31200_edac thermal fan hed =
evdev acpi_ipmi ipmi_si ipmi_devintf ipmi_msghandler pinctrl_cannonlake acp=
i_tad button efivarfs hid_generic usbhid hid ses enclosure video crc32_pclm=
ul xhci_pci xhci_pci_renesas xhci_hcd mpt3sas raid_class scsi_transport_sas=
 ahci libahci libata wmi simpledrm drm_shmem_helper drm_kms_helper cfbfillr=
ect syscopyarea cfbimgblt sysfillrect sysimgblt fb_sys_fops cfbcopyarea drm=
 i2c_core drm_panel_orientation_quirks agpgart loop btrfs libcrc32c crc32c_=
generic crc32c_intel xor raid6_pq usb_storage usbcore usb_common sd_mod t10=
_pi crc64_rocksoft crc64 scsi_mod scsi_common
> <4>[154908.766444] CR2: 0000000000000140
> <4>[154908.766821] ---[ end trace 0000000000000000 ]---
>=20
>=20
>=20

