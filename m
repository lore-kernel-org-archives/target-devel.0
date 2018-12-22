From: Ram Kishore Vegesna <ram.vegesna@broadcom.com>
Date: Sat, 22 Dec 2018 19:38:58 +0000
Subject: Re: [ANNOUNCE v2]: Broadcom (Emulex) FC Target driver - efct
Message-Id: <CAF7aS0oQwoST-MnbpYqfGDQiPe6Q-J_QSp9HSQbY7hjmkE-F2A@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <9b8c7647-f9ab-9147-1378-b047929d5e11@broadcom.com>
In-Reply-To: <9b8c7647-f9ab-9147-1378-b047929d5e11@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi Sebastian,

Thanks a lot for testing and adding 4.19 kernel support to our driver.
I pulled your changes and merged to gitlab repository.

Fixed the issues which you encountered, pushed the changes to our repository.

Thanks,
Ram
https://gitlab.com/jsmart/efct-Emulex_FC_Target


On Thu, Dec 20, 2018 at 4:55 PM Sebastian Herbszt <herbszt@gmx.net> wrote:
>
> Hello James,
>
> > I noticed this version does only build here on kernel 4.18. I pushed the
> > required changes for kernel 4.19 to my repository [1].
>
> this patch [1] is required on 32 bit to fix
>
> WARNING: "__udivdi3" [efct.ko] undefined!
>
> It seems v2 contains some regressions:
>
> My simple setup triggered this
>
> [  167.858868] efct:efct_hw_cb_link:8556:[fc0] :Link Up, NPORT, speed is 16000
> [  167.862576] efct:efct_els_req_send:96:[fc0] :send efct_send_flogi
> [  167.862796] BUG: unable to handle kernel NULL pointer dereference at 0000035c
> [  167.862805] *pde = 00000000
> [  167.862813] Oops: 0000 [#1] SMP PTI
> [  167.862822] CPU: 1 PID: 2707 Comm: efct:0:0 Tainted: G           O      4.19.0-rc2-2.g0d9481c-default #1 openSUSE Tumbleweed (unreleased)
> [  167.862829] Hardware name: FUJITSU SIEMENS ESPRIMO E           /D2164-A1, BIOS 5.00 R1.10.2164.A1               05/08/2006
> [  167.862856] EIP: efct_send_flogi_p2p_acc+0x25/0x1d0 [efct]
> [  167.862863] Code: 97 f8 eb da 90 3e 8d 74 26 00 55 89 e5 57 56 53 8b 42 08 89 d3 89 ce 8b 00 85 c0 74 0d f6 80 18 03 00 00 02 0f 85 2b 01 00 00 <ff> 35 5c 03 00 00 68 3c d7 97 f8 e8 cb 63 18 e0 c7 05 5c 03 00 00
> [  167.862873] EAX: f2ec0000 EBX: ec3c8000 ECX: 00001802 EDX: ec3c8000
> [  167.862878] ESI: 00001802 EDI: ec3c8400 EBP: eb61fd4c ESP: eb61fd40
> [  167.862891] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010246
> [  167.862902] CR0: 80050033 CR2: 0000035c CR3: 36700000 CR4: 000006d0
> [  167.862914] Call Trace:
> [  167.862947]  __efc_d_init+0x11f/0x630 [efct]
> [  167.862976]  ? efc_send_ls_acc_after_attach+0x90/0x90 [efct]
> [  167.863004]  efc_sm_post_event+0x11/0x30 [efct]
> [  167.863033]  efc_node_post_event+0x3e/0xd0 [efct]
> [  167.863062]  efc_node_recv_els_frame+0x91/0xb0 [efct]
> [  167.863094]  efc_node_dispatch_frame+0x127/0x1f0 [efct]
> [  167.863124]  efc_domain_dispatch_frame+0x1a1/0x2b0 [efct]
> [  167.863154]  efct_unsolicited_cb+0x189/0x1a0 [efct]
> [  167.863183]  ? efct_unsolicited_cb+0x189/0x1a0 [efct]
> [  167.863210]  efct_hw_rqpair_process_rq+0x17b/0x2f0 [efct]
> [  167.863237]  efct_hw_cq_process+0x1fd/0x310 [efct]
> [  167.863263]  ? sli_eq_read+0x2e/0xd0 [efct]
> [  167.863288]  ? sli_eq_read+0xab/0xd0 [efct]
> [  167.863316]  efct_hw_eq_process+0x93/0x180 [efct]
> [  167.863344]  efct_hw_process+0x2c/0x40 [efct]
> [  167.863364]  efct_intr_thread+0xa1/0xd0 [efct]
> [  167.863379]  kthread+0xf0/0x110
> [  167.863398]  ? efct_teardown_msix+0x50/0x50 [efct]
> [  167.863410]  ? kthread_create_worker_on_cpu+0x20/0x20
> [  167.863422]  ret_from_fork+0x2e/0x40
> [  167.863433] Modules linked in: nvme_fc nvme_fabrics nvmet_fc nvmet efct(O) scsi_transport_fc target_core_user uio brd target_core_pscsi target_core_file target_core_iblock target_core_mod configfs edd nfsd snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device lockd grace nfs_acl auth_rpcgss sunrpc dm_mod gpio_ich snd_hda_codec_realtek snd_hda_codec_generic iTCO_wdt iTCO_vendor_support snd_hda_intel snd_hda_codec tg3 libphy lpc_ich snd_hda_core ptp ppdev pps_core snd_hwdep hwmon snd_pcm parport_pc pcspkr floppy button snd_timer snd soundcore i2c_i801 parport sg ehci_pci i915 drm_kms_helper drm uhci_hcd ehci_hcd fb_sys_fops sysimgblt sysfillrect syscopyarea i2c_algo_bit video usbcore scsi_dh_alua scsi_dh_hp_sw scsi_dh_rdac scsi_dh_emc fan ata_generic ata_piix ahci libahci libata thermal [last unloaded: speedstep_lib]
> [  167.863576] CR2: 000000000000035c
> [  167.863587] ---[ end trace a869d8ef0400f630 ]---
> [  167.863608] EIP: efct_send_flogi_p2p_acc+0x25/0x1d0 [efct]
> [  167.863619] Code: 97 f8 eb da 90 3e 8d 74 26 00 55 89 e5 57 56 53 8b 42 08 89 d3 89 ce 8b 00 85 c0 74 0d f6 80 18 03 00 00 02 0f 85 2b 01 00 00 <ff> 35 5c 03 00 00 68 3c d7 97 f8 e8 cb 63 18 e0 c7 05 5c 03 00 00
> [  167.863638] EAX: f2ec0000 EBX: ec3c8000 ECX: 00001802 EDX: ec3c8000
> [  167.863648] ESI: 00001802 EDI: ec3c8400 EBP: eb61fd4c ESP: d966347c
> [  167.863659] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010246
> [  167.863669] CR0: 80050033 CR2: 0000035c CR3: 36700000 CR4: 000006d0
>
> As you can see [2] "io" is NULL when it's used. This patch seems to fix it:
>
> diff --git a/efct/efct_els.c b/efct/efct_els.c
> index 524fda7..45a7198 100644
> --- a/efct/efct_els.c
> +++ b/efct/efct_els.c
> @@ -1537,6 +1537,13 @@ efct_send_flogi_p2p_acc(struct efc_lport *efc, struct efc_node_s *node,
>
>         node_els_trace();
>
> +       io = efct_els_io_alloc(node, sizeof(struct fc_plogi_payload_s),
> +                              EFCT_ELS_ROLE_RESPONDER);
> +
> +       if (!io) {
> +               efct_log_err(efct, "els IO alloc failed\n");
> +               return io;
> +       }
>         io->els_callback = NULL;
>         io->els_callback_arg = NULL;
>         io->display_name = "flogi_p2p_acc";
>
>
> With this change I am able to use the exported volume but a read test results in
>
> [  359.747276] WARNING: CPU: 0 PID: 3338 at /devel/efct/efct/efct_scsi.c:1341 efct_scsi_send_rd_data+0x438/0x480 [efct]
> [  359.747278] Modules linked in: efct(O) nvme_fc nvme_fabrics nvmet_fc nvmet scsi_transport_fc target_core_user uio brd target_core_pscsi target_core_file target_core_iblock target_core_mod configfs nfsd lockd grace nfs_acl auth_rpcgss sunrpc edd snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device dm_mod snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel gpio_ich iTCO_wdt iTCO_vendor_support snd_hda_codec snd_hda_core tg3 snd_hwdep snd_pcm lpc_ich snd_timer snd libphy soundcore ptp i2c_i801 ppdev pps_core hwmon parport_pc ehci_pci sg parport pcspkr floppy button i915 drm_kms_helper drm fb_sys_fops sysimgblt sysfillrect syscopyarea uhci_hcd ehci_hcd usbcore i2c_algo_bit video scsi_dh_alua scsi_dh_hp_sw scsi_dh_rdac scsi_dh_emc fan ata_generic ata_piix ahci libahci libata thermal [last unloaded: efct]
> [  359.747374] CPU: 0 PID: 3338 Comm: efct:0:0 Tainted: G           O      4.19.0-rc2-2.g0d9481c-default #1 openSUSE Tumbleweed (unreleased)
> [  359.747376] Hardware name: FUJITSU SIEMENS ESPRIMO E           /D2164-A1, BIOS 5.00 R1.10.2164.A1               05/08/2006
> [  359.747391] EIP: efct_scsi_send_rd_data+0x438/0x480 [efct]
> [  359.747394] Code: b8 fc ff ff 0f 0b 8b 43 24 85 c0 0f 85 99 fc ff ff 90 0f 0b 85 f6 0f 84 8e fc ff ff 31 d2 e9 7a fc ff ff 8d b4 26 00 00 00 00 <0f> 0b e9 d3 fc ff ff 90 0f 0b e9 3d fc ff ff f6 45 ec 02 0f 85 6d
> [  359.747397] EAX: 00080000 EBX: efe307b0 ECX: f50dacac EDX: 00000007
> [  359.747399] ESI: f2ec8000 EDI: 00000000 EBP: eb88bda0 ESP: eb88bd74
> [  359.747402] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010246
> [  359.747404] CR0: 80050033 CR2: b7f26000 CR3: 3417e000 CR4: 000006d0
> [  359.747407] Call Trace:
> [  359.747421]  ? dma_direct_map_sg+0x55/0xa0
> [  359.747424]  ? dma_direct_map_sg+0x6a/0xa0
> [  359.747446]  efct_lio_queue_data_in+0x20a/0x350 [efct]
> [  359.747467]  ? efct_lio_write_pending+0x280/0x280 [efct]
> [  359.747472]  ? dequeue_entity+0x1ef/0xba0
> [  359.747493]  efct_lio_datamove_done+0x9d/0x5b0 [efct]
> [  359.747498]  ? __switch_to_asm+0x33/0x50
> [  359.747501]  ? __switch_to_asm+0x27/0x50
> [  359.747503]  ? __switch_to_asm+0x33/0x50
> [  359.747505]  ? __switch_to_asm+0x27/0x50
> [  359.747507]  ? __switch_to_asm+0x33/0x50
> [  359.747510]  ? __switch_to_asm+0x27/0x50
> [  359.747530]  ? efct_lio_write_pending+0x280/0x280 [efct]
> [  359.747544]  efct_target_io_cb+0xc8/0x230 [efct]
> [  359.747547]  ? __switch_to_asm+0x33/0x50
> [  359.747549]  ? __switch_to_asm+0x27/0x50
> [  359.747551]  ? __switch_to_asm+0x33/0x50
> [  359.747553]  ? __switch_to_asm+0x27/0x50
> [  359.747555]  ? __switch_to_asm+0x33/0x50
> [  359.747569]  ? efct_scsi_check_pending+0x2b0/0x2b0 [efct]
> [  359.747588]  efct_hw_wq_process_io+0x138/0x880 [efct]
> [  359.747607]  ? target_wqe_timer_nop_cb+0x200/0x200 [efct]
> [  359.747626]  efct_hw_wq_process+0x3b/0x130 [efct]
> [  359.747645]  efct_hw_cq_process+0x1e3/0x310 [efct]
> [  359.747663]  ? sli_eq_read+0x2e/0xd0 [efct]
> [  359.747682]  ? sli_eq_read+0xab/0xd0 [efct]
> [  359.747702]  efct_hw_eq_process+0x93/0x180 [efct]
> [  359.747721]  efct_hw_process+0x2c/0x40 [efct]
> [  359.747734]  efct_intr_thread+0xa1/0xd0 [efct]
> [  359.747739]  kthread+0xf0/0x110
> [  359.747751]  ? efct_teardown_msix+0x50/0x50 [efct]
> [  359.747754]  ? kthread_create_worker_on_cpu+0x20/0x20
> [  359.747757]  ret_from_fork+0x2e/0x40
> [  359.747761] ---[ end trace 6a1c45757778ea22 ]---
>
> and this is the following assertion [3]
>
> efct_assert(io->exp_xfer_len > io->transferred, -1);
>
> The relevant values are
>
> xwire_len: 262144
> io->exp_xfer_len: 524288
> io->transferred: 524288
>
> I was not yet able to figure out what the problem is.
>
> [1] https://repo.or.cz/efct-Emulex_FC_Target/sherbszt.git/commitdiff/bd2b72aeb034f19be99566b3897efde4e9e24c46
> [2] https://gitlab.com/jsmart/efct-Emulex_FC_Target/blob/master/efct/efct_els.c#L1512
> [3] https://gitlab.com/jsmart/efct-Emulex_FC_Target/blob/master/efct/efct_scsi.c#L1341
>
> Sebastian
