Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79B9DC433ED
	for <target-devel@archiver.kernel.org>; Mon, 17 May 2021 12:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44FB561285
	for <target-devel@archiver.kernel.org>; Mon, 17 May 2021 12:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237052AbhEQMkt (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 17 May 2021 08:40:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48760 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237044AbhEQMkt (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 17 May 2021 08:40:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621255172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=V76kcTFf9udTPBM2ceIThqBQ/8FBu/ddP0qiwDR+JUU=;
        b=W3R1HAwbBxn9fxjmu42cio/wclnJwl4FscMs+xKW0yMOtb5cWUSYWspUowdHD/0jZLrHRU
        TsmKA+1xWDhPjn8mczZ9Wnb4DxJWkiB5UswWC357C7/ldQdwg44giiVJvMiSjbOETagoGU
        elNcibGz0ziOPbMprbc7oo/Lm93sx2M=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-cr-V3HnCPoG0MfuJNmdHyw-1; Mon, 17 May 2021 08:39:30 -0400
X-MC-Unique: cr-V3HnCPoG0MfuJNmdHyw-1
Received: by mail-il1-f198.google.com with SMTP id h8-20020a92c2680000b02901646ecac1e5so6160877ild.20
        for <target-devel@vger.kernel.org>; Mon, 17 May 2021 05:39:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=V76kcTFf9udTPBM2ceIThqBQ/8FBu/ddP0qiwDR+JUU=;
        b=qYnlUnTSRFKnxR+bk9MjyHEQ3YYiVbMsAvJFIOIUKX6IKZ2LhT8nYmH0Ts/ZUm5kiq
         hXPk1DL25N16Zj0SeCYOg0RWHXufHXwL8ZfIdrGBZVm//zhDTQpVf6eegv2OokcrdD31
         XazT47vL24ykOEAU7U6+m6PF544WWGlLEwTjnE2E1VZdxTBuu1dA14b/BBmmXtcDrgl2
         FOj+Sod93e2IFrB+SIGf9BCNrsDNZjmw54MMz5d7/5GmtsnMbQ9xc58e49BltOGNJ31c
         a0Fye6nqxrvk9p0m/2gaOMenz4whiwDI0F3/6TL4XTfUjNAcNoe3EyD/t+Ii6jcD1tV6
         rN0A==
X-Gm-Message-State: AOAM530SVyHW1VxAo/tLgwErtJOHuEs+JtCuI5uT7KlL+KEieLoxndsv
        fXIDaqJuCvY3GnjbDf7rumodCBKpbb0U+aG+9oJ7P9GvMHps5/124Ra6QE7x0PxfjKzDjdeuMoz
        1MrdU6wPBa/kMIstRxtkEW8lT1Zlz1AmX8k6YTrTY
X-Received: by 2002:a5d:9e51:: with SMTP id i17mr45486591ioi.122.1621255169797;
        Mon, 17 May 2021 05:39:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7G24MIlunu5UkhIkA6oqf5a1RmmqvrmP7c+kpdYHiianEi8sXStve8qXeSsvsrAWXwitPUEJQIABUA2y4fiA=
X-Received: by 2002:a5d:9e51:: with SMTP id i17mr45486577ioi.122.1621255169591;
 Mon, 17 May 2021 05:39:29 -0700 (PDT)
MIME-Version: 1.0
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Mon, 17 May 2021 14:39:18 +0200
Message-ID: <CAFL455=vDW6oJPjN8N_TZY9fuMOcffmGeAw5NVRpmruKKdkVPQ@mail.gmail.com>
Subject: warning on PREEMPT_RT kernel
To:     target-devel@vger.kernel.org
Cc:     bostroesser@gmail.com, michael.christie@oracle.com,
        martin.petersen@oracle.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hello,

FYI, I hit this warning when target is used on a real-time kernel:

[ 7757.735755] WARNING: CPU: 1 PID: 829784 at
drivers/target/target_core_transport.c:3013
__transport_wait_for_tasks+0x122/0x150 [target_core_mod]
[ 7757.735757] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi
target_core_user uio target_core_pscsi target_core_file
target_core_iblock iscsi_target_mod target_core_mod xt_multiport
ip_gre ip_tunnel gre loop tun af_key crypto_user scsi_transport_iscsi
bluetooth ecdh_generic rfkill overlay xt_CONNSECMARK xt_SECMARK
nft_counter xt_state xt_conntrack nft_compat ah6 ah4 nft_objref nft_ct
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables_set nf_tables
nfnetlink vfat fat sctp nfsd nfs_acl dm_log_writes dm_flakey dm_mod
rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache
sunrpc intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal
intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul ipmi_ssif
ghash_clmulni_intel intel_cstate iTCO_wdt intel_uncore
iTCO_vendor_support ext4 intel_rapl_perf mbcache pcspkr jbd2 hpilo
hpwdt ipmi_si ipmi_devintf ipmi_msghandler acpi_tad ioatdma i2c_i801
lpc_ich wmi acpi_power_meter ip_tables xfs libcrc32c sd_mod sg mgag200
[ 7757.735797]  drm_kms_helper syscopyarea sysfillrect sysimgblt
fb_sys_fops drm_vram_helper drm_ttm_helper ttm igb crc32c_intel
serio_raw drm dca hpsa i2c_algo_bit scsi_transport_sas [last unloaded:
raid10]
[ 7757.735807] CPU: 1 PID: 829784 Comm: iscsi_ttx Kdump: loaded
Tainted: G           OE    --------- -  -
4.18.0-240.22.1.rt7.77.el8_3.mreq409.x86_64 #1
[ 7757.735809] Hardware name: HP ProLiant XL420 Gen9/ProLiant XL420
Gen9, BIOS U19 12/27/2015
[ 7757.735818] RIP: 0010:__transport_wait_for_tasks+0x122/0x150
[target_core_mod]
[ 7757.735820] Code: 04 01 00 00 dd b8 01 00 00 00 f6 05 81 57 03 00
04 75 1e 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e c3 c6 01 01 e9 39 ff ff
ff 0f 0b <0f> 0b e9 06 ff ff ff 48 8b 53 08 48 c7 c6 b0 db c4 c0 48 c7
c7 f8
[ 7757.735821] RSP: 0018:ffffa89f48e53d68 EFLAGS: 00010202
[ 7757.735823] RAX: 0000000000000286 RBX: ffff932daf8a58e8 RCX: ffffa89f48e53da7
[ 7757.735824] RDX: ffffa89f48e53da6 RSI: 0000000000000001 RDI: ffff932daf8a58e8
[ 7757.735825] RBP: ffff932daf8a59f0 R08: ffffa89f48e53da8 R09: ffffffffc0c9201f
[ 7757.735825] R10: 0000000000000200 R11: 0000000000000000 R12: 0000000000000001
[ 7757.735826] R13: 0000000000000001 R14: ffffa89f48e53e48 R15: ffffa89f48e53b70
[ 7757.735828] FS:  0000000000000000(0000) GS:ffff932a6f640000(0000)
knlGS:0000000000000000
[ 7757.735828] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 7757.735829] CR2: 0000555556555e88 CR3: 000000079240e003 CR4: 00000000001606e0
[ 7757.735830] Call Trace:
[ 7757.735839]  ? migrate_disable+0x38/0xc0
[ 7757.735850]  transport_generic_free_cmd+0xec/0x160 [target_core_mod]
[ 7757.735869]  iscsit_free_cmd+0x56/0xc0 [iscsi_target_mod]
[ 7757.735877]  iscsit_close_connection+0x70c/0xad0 [iscsi_target_mod]
[ 7757.735885]  ? iscsit_thread_get_cpumask+0x70/0x70 [iscsi_target_mod]
[ 7757.735891]  iscsit_take_action_for_connection_exit+0xb4/0x180
[iscsi_target_mod]
[ 7757.735897]  iscsi_target_tx_thread+0x16f/0x1f0 [iscsi_target_mod]
[ 7757.735903]  ? finish_wait+0x70/0x70
[ 7757.735910]  kthread+0x112/0x130
[ 7757.735912]  ? kthread_flush_work_fn+0x10/0x10
[ 7757.735917]  ret_from_fork+0x35/0x40
[ 7757.735920] ---[ end trace 0000000000000002 ]---

static bool
__transport_wait_for_tasks(struct se_cmd *cmd, bool fabric_stop,
                           bool *aborted, bool *tas, unsigned long *flags)
        __releases(&cmd->t_state_lock)
        __acquires(&cmd->t_state_lock)
{

        assert_spin_locked(&cmd->t_state_lock);
        WARN_ON_ONCE(!irqs_disabled());   <----------

I guess this is due to the fact that on realtime kernels spin_lock_irq*() do not
disable the interrupts, so the call to irqs_disabled() returns false.

Maurizio

