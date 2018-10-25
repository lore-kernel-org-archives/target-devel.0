From: zhengliang <zhengliang6@huawei.com>
Date: Thu, 25 Oct 2018 02:03:00 +0000
Subject: Re: BUG in use-after-free iSCSI dataout timeout
Message-Id: <d6c0c256-42cb-55c7-f199-3f0614e9361f@huawei.com>
List-Id: <target-devel.vger.kernel.org>
References: <13ab4e80-8435-ca17-5a1c-b06ef2c8fd25@huawei.com>
In-Reply-To: <13ab4e80-8435-ca17-5a1c-b06ef2c8fd25@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: target-devel@vger.kernel.org

Thank you very much for your help.
I need a few days to test this patch.
I will feedback the test results to you later.

=D4=DA 2018/10/25 4:21, Mike Christie =D0=B4=B5=C0:
> On 10/23/2018 08:04 AM, zhengliang wrote:
>> Hi,
>> I am getting the following bug in LIO iscsi target.I had this issue
>> three times. It seems it fails especially in the bad network environment.
>> The iscsi_target_tx_thread free the iscsi_conn,but the dataout timer is
>> triggered and will use the iscsi_conn.
>> I am not sure how to solve this issue at present and look forward to you=
r suggestions.
>> Thanks.
>>
>=20
> It looks like the timers might rearm themselves, so we need a check in
> them to make sure if iscsit_close_connection is calling del_timer_sync
> on them they do not restart or start another timer. For the latter, it
> looks like you also hit this bug with the nop timers.
> iscsit_close_connection could do iscsit_stop_nopin_response_timer, but
> we could be calling iscsit_handle_nopin_timeout->iscsit_add_nopin which
> would rearm that timer.
>=20
> I am going on vacation and will not be checking mail, but if you are
> desperate, attached is a compile tested patch.
>=20
>=20
>> the first log:
>> [134850.281466] Unable to handle kernel paging request at virtual addres=
s 100002cb9
>> [134850.291043] Mem abort info:
>> [134850.294440]   Exception class =3D DABT (current EL), IL =3D 32 bits
>> [134850.300845]   SET =3D 0, FnV =3D 0
>> [134850.304359]   EA =3D 0, S1PTW =3D 0
>> [134850.307930] Data abort info:
>> [134850.311208]   ISV =3D 0, ISS =3D 0x00000004
>> [134850.315420]   CM =3D 0, WnR =3D 0
>> [134850.319133] user pgtable: 4k pages, 48-bit VAs, pgd =3D ffff8021d5ae=
f000
>> [134850.326225] [0000000100002cb9] *pgd=0000000000000000
>> [134850.331837] Internal error: Oops: 96000004 [#1] SMP
>> [134850.337104] Modules linked in: tcm_qla2xxx(OE) qla2xxx(OE) iscsi_boo=
t_sysfs(OE) iscsi_target_mod(OE) tcm_loop(OE) tcm_fc(OE) libfc(OE) target_c=
ore_file(OE) target_core_iblock(OE) target_core_user(OE) target_core_pscsi(=
OE) target_core_mod(OE) scsi_transport_srp(OE) scsi_transport_spi(OE) scsi_=
transport_fc(OE) scsi_debug(OE) ch(OE) st(OE) sg(OE) test_platform_core(OE)=
 debug_nic_mii(OE) nic_test(OE) hns3_enet_ut(OE) hclge(OE) hnae3(OE)
>> [134850.377999] CPU: 1 PID: 16 Comm: ksoftirqd/1 Tainted: G        W  OE=
L  4.14.10 #1
>> [134850.385789] Hardware name:  09/01/2018
>> [134850.396153] task: ffff8021f77fa100 task.stack: ffff00000b3b0000
>> [134850.412479] PC is at iscsit_handle_dataout_timeout+0x70/0x318 [iscsi=
_target_mod]
>> [134850.424736] LR is at iscsit_handle_dataout_timeout+0x6c/0x318 [iscsi=
_target_mod]
>> [134850.432450] pc : [<ffff000000ffc4b0>] lr : [<ffff000000ffc4ac>] psta=
te: 00c00149
>> [134850.440073] sp : ffff00000b3b3bf0
>> [134850.443642] x29: ffff00000b3b3bf0 x28: ffff000009521000
>> [134850.449331] x27: ffff0000094faaa0 x26: fffffffffffffff8
>> [134850.454994] x25: ffff000009515000 x24: ffff000009521d20
>> [134850.460634] x23: ffff8021d09d1a00 x22: ffff8021cdfa6064
>> [134850.466273] x21: ffff000009519c88 x20: ffff8021ca29a800
>> [134850.471913] x19: ffff8021cdfa5f80 x18: 0000000000000040
>> [134850.477575] x17: 000000008122f454 x16: 000000009a1d2b3b
>> [134850.483222] x15: 0000000000000004 x14: ffff8021c9633e80
>> [134850.488864] x13: ffff8021d3d160f0 x12: 00000000000000ba
>> [134850.494509] x11: 0000000000000001 x10: ffff00000b3b3d18
>> [134850.500151] x9 : 120480a00a420410 x8 : ffff8021fffd1878
>> [134850.505786] x7 : 0000000000000007 x6 : 120480a00a428410
>> [134850.511420] x5 : 0000000000000002 x4 : 00000000000000c0
>> [134850.517057] x3 : dead000000000200 x2 : 0000000000000000
>> [134850.522698] x1 : 00000001000027e1 x0 : 46b707f5317c33e7
>> [134850.528402] Process ksoftirqd/1 (pid: 16, stack limit =3D 0xffff0000=
0b3b0000)
>> [134850.535616] Call trace:
>> [134850.538380] Exception stack(0xffff00000b3b3ab0 to 0xffff00000b3b3bf0)
>> [134850.545112] 3aa0:                                   46b707f5317c33e7=
 00000001000027e1
>> [134850.553245] 3ac0: 0000000000000000 dead000000000200 00000000000000c0=
 0000000000000002
>> [134850.561366] 3ae0: 120480a00a428410 0000000000000007 ffff8021fffd1878=
 120480a00a420410
>> [134850.569477] 3b00: ffff00000b3b3d18 0000000000000001 00000000000000ba=
 ffff8021d3d160f0
>> [134850.577584] 3b20: ffff8021c9633e80 0000000000000004 000000009a1d2b3b=
 000000008122f454
>> [134850.585694] 3b40: 0000000000000040 ffff8021cdfa5f80 ffff8021ca29a800=
 ffff000009519c88
>> [134850.593806] 3b60: ffff8021cdfa6064 ffff8021d09d1a00 ffff000009521d20=
 ffff000009515000
>> [134850.601913] 3b80: fffffffffffffff8 ffff0000094faaa0 ffff000009521000=
 ffff00000b3b3bf0
>> [134850.610027] 3ba0: ffff000000ffc4ac ffff00000b3b3bf0 ffff000000ffc4b0=
 0000000000c00149
>> [134850.618142] 3bc0: ffff8021ca29a800 ffff8021ca29ab74 ffffffffffffffff=
 ffff000000ffc4ac
>> [134850.626219] 3be0: ffff00000b3b3bf0 ffff000000ffc4b0
>> [134850.634664] [<ffff000000ffc4b0>] iscsit_handle_dataout_timeout+0x70/=
0x318 [iscsi_target_mod]
>> [134850.643817] [<ffff0000081494c0>] call_timer_fn+0x3c/0x160
>> [134850.649535] [<ffff0000081496dc>] expire_timers+0xcc/0x128
>> [134850.655232] [<ffff0000081497e0>] run_timer_softirq+0xa8/0x1a8
>> [134850.661325] [<ffff0000080818d0>] __do_softirq+0x140/0x2ec
>> [134850.667284] [<ffff0000080d6f10>] run_ksoftirqd+0x48/0x5c
>> [134850.673213] [<ffff0000080f9064>] smpboot_thread_fn+0x190/0x1d4
>> [134850.679353] [<ffff0000080f441c>] kthread+0x10c/0x138
>> [134850.684754] [<ffff0000080855dc>] ret_from_fork+0x10/0x18
>> [134850.690440] Code: f9430e97 aa1703e0 94001c92 f940e6e1 (39536021)
>> [134850.697242] ---[ end trace c637e768609fc3aa ]---
>> [134850.702187] Kernel panic - not syncing: Fatal exception in interrupt
>> [134850.708964] SMP: stopping secondary CPUs
>> [134850.713453] Kernel Offset: disabled
>> [134850.717270] CPU features: 0x000a18
>> [134850.720934] Memory Limit: none
>> [134850.724368] ---[ end Kernel panic - not syncing: Fatal exception in =
interrupt
>>
>> the second log:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> [2018-10-06 19:29:39]  [166384.049428] BUG: KASAN: use-after-free in col=
lect_expired_timers+0x108/0x16c
>> [2018-10-06 19:29:39]  [166384.057071] Write of size 8 at addr ffff80219=
f04f190 by task swapper/1/0
>> [2018-10-06 19:29:39]  [166384.064097]
>> [2018-10-06 19:29:39]  [166384.066333] CPU: 1 PID: 0 Comm: swapper/1 Tai=
nted: G           OE   4.14.10 #1
>> [2018-10-06 19:29:39]  [166384.074022] Hardware name:  09/17/2018
>> [2018-10-06 19:29:39]  [166384.084498] Call trace:
>> [2018-10-06 19:29:39]  [166384.087758] [<ffff20000808c120>] dump_backtra=
ce+0x0/0x2b8
>> [2018-10-06 19:29:39]  [166384.093723] [<ffff20000808c3fc>] show_stack+0=
x24/0x30
>> [2018-10-06 19:29:39]  [166384.099657] [<ffff20000929afe4>] dump_stack+0=
xa4/0xc8
>> [2018-10-06 19:29:39]  [166384.105338] [<ffff200008333980>] print_addres=
s_description+0x118/0x278
>> [2018-10-06 19:29:39]  [166384.112345] [<ffff200008333db4>] kasan_report=
+0x1f8/0x328
>> [2018-10-06 19:29:39]  [166384.118462] [<ffff200008332610>] __asan_store=
8+0x84/0xa4
>> [2018-10-06 19:29:39]  [166384.124322] [<ffff20000818a084>] collect_expi=
red_timers+0x108/0x16c
>> [2018-10-06 19:29:39]  [166384.131117] [<ffff20000818a588>] run_timer_so=
ftirq+0xb8/0x260
>> [2018-10-06 19:29:39]  [166384.137393] [<ffff200008081a90>] __do_softirq=
+0x1b8/0x488
>> [2018-10-06 19:29:39]  [166384.143543] [<ffff2000080ef96c>] irq_exit+0x1=
34/0x168
>> [2018-10-06 19:29:39]  [166384.149194] [<ffff2000081665f8>] __handle_dom=
ain_irq+0x84/0xe8
>> [2018-10-06 19:29:39]  [166384.155522] [<ffff200008081818>] gic_handle_i=
rq+0xd0/0x18c
>> [2018-10-06 19:29:39]  [166384.161484] Exception stack(0xffff8021bee37da=
0 to 0xffff8021bee37ee0)
>> [2018-10-06 19:29:39]  [166384.168496] 7da0: 0000000000000000 0000000000=
000003 dfff200000000000 0000000000000000
>> [2018-10-06 19:29:39]  [166384.176925] 7dc0: ffff8021fffbf000 0000000000=
000018 001dcd6500000000 ffff8021fffc6eef
>> [2018-10-06 19:29:39]  [166384.185336] 7de0: 1ffff0043fff8ddd dfff200000=
000000 ffff10043fff8ddd 1ffff0043fff8ddd
>> [2018-10-06 19:29:39]  [166384.193706] 7e00: ffff10043fff8dde 0000000000=
000000 0000000000000000 ffffffffffffffff
>> [2018-10-06 19:29:39]  [166384.202090] 7e20: 0000000000000000 00000000f0=
13c082 000000009aa30e07 ffff200009a2b000
>> [2018-10-06 19:29:39]  [166384.210465] 7e40: ffff200009a2b000 00006021f6=
594000 0000000000000001 ffff200009a66000
>> [2018-10-06 19:29:39]  [166384.218823] 7e60: ffff200009a376c8 0000000000=
000000 0000000000000000 0000000000000000
>> [2018-10-06 19:29:39]  [166384.227199] 7e80: 0000000000000000 ffff8021be=
e37ee0 ffff200008085d3c ffff8021bee37ee0
>> [2018-10-06 19:29:39]  [166384.235577] 7ea0: ffff200008085d40 0000000020=
c00149 ffff8021bee37f00 ffff200008181170
>> [2018-10-06 19:29:39]  [166384.243957] 7ec0: ffffffffffffffff 0140000000=
000000 ffff8021bee37ee0 ffff200008085d40
>> [2018-10-06 19:29:39]  [166384.252288] [<ffff200008083030>] el1_irq+0xb0=
/0x140
>> [2018-10-06 19:29:39]  [166384.257705] [<ffff200008085d40>] arch_cpu_idl=
e+0x40/0x1e4
>> [2018-10-06 19:29:39]  [166384.263822] [<ffff2000092bf478>] default_idle=
_call+0x2c/0x48
>> [2018-10-06 19:29:39]  [166384.269985] [<ffff20000814ecd0>] do_idle+0x19=
0/0x1f8
>> [2018-10-06 19:29:39]  [166384.275418] [<ffff20000814ef54>] cpu_startup_=
entry+0x2c/0x30
>> [2018-10-06 19:29:39]  [166384.281708] [<ffff200008093c84>] secondary_st=
art_kernel+0x19c/0x1d4
>> [2018-10-06 19:29:39]  [166384.288284]
>> [2018-10-06 19:29:39]  [166384.290245] Allocated by task 2352:
>> [2018-10-06 19:29:39]  [166384.294363]  kasan_kmalloc.part.4+0x48/0x110
>> [2018-10-06 19:29:39]  [166384.299134]  kasan_kmalloc+0x84/0xa0
>> [2018-10-06 19:29:39]  [166384.303197]  kmem_cache_alloc_trace+0x104/0x2=
1c
>> [2018-10-06 19:29:39]  [166384.320228]  __iscsi_target_login_thread+0x13=
0/0x1568 [iscsi_target_mod]
>> [2018-10-06 19:29:39]  [166384.334889]  iscsi_target_login_thread+0x2c/0=
x68 [iscsi_target_mod]
>> [2018-10-06 19:29:39]  [166384.341894]  kthread+0x17c/0x1bc
>> [2018-10-06 19:29:39]  [166384.345710]  ret_from_fork+0x10/0x18
>> [2018-10-06 19:29:39]  [166384.349599]
>> [2018-10-06 19:29:39]  [166384.351456] Freed by task 14506:
>> [2018-10-06 19:29:39]  [166384.355373]  kasan_slab_free+0x98/0x194
>> [2018-10-06 19:29:39]  [166384.359681]  kfree+0x84/0x1e8
>> [2018-10-06 19:29:39]  [166384.369839]  iscsit_close_connection+0x3f0/0x=
b28 [iscsi_target_mod]
>> [2018-10-06 19:29:39]  [166384.383057]  iscsit_take_action_for_connectio=
n_exit+0xd4/0x1b0 [iscsi_target_mod]
>> [2018-10-06 19:29:39]  [166384.397291]  iscsi_target_tx_thread+0x1bc/0x2=
98 [iscsi_target_mod]
>> [2018-10-06 19:29:39]  [166384.404081]  kthread+0x17c/0x1bc
>> [2018-10-06 19:29:39]  [166384.407799]  ret_from_fork+0x10/0x18
>> [2018-10-06 19:29:39]  [166384.411682]
>> [2018-10-06 19:29:39]  [166384.413629] The buggy address belongs to the =
object at ffff80219f04ee80
>> [2018-10-06 19:29:39]  [166384.413629]  which belongs to the cache kmall=
oc-2048 of size 2048
>> [2018-10-06 19:29:39]  [166384.427030] The buggy address is located 784 =
bytes inside of
>> [2018-10-06 19:29:39]  [166384.427030]  2048-byte region [ffff80219f04ee=
80, ffff80219f04f680)
>> [2018-10-06 19:29:39]  [166384.439397] The buggy address belongs to the =
page:
>> [2018-10-06 19:29:39]  [166384.444869] page:ffff7e00867c1200 count:1 map=
count:0 mapping:          (null) index:0xffff80219f048080 compound_mapcount=
: 0
>> [2018-10-06 19:29:39]  [166384.456778] flags: 0xfffff8000008100(slab|hea=
d)
>> [2018-10-06 19:29:39]  [166384.462064] raw: 0fffff8000006384.561681]   E=
xception class =3D DABT (current EL), IL =3D 32 bits
>> [2018-10-06 19:29:40]  [166384.567957]   SET =3D 0, FnV =3D 0
>> [2018-10-06 19:29:40]  [166384.571367]   EA =3D 0, S1PTW =3D 0
>> [2018-10-06 19:29:40]  [166384.574816] Data abort info:
>> [2018-10-06 19:29:40]  [166384.578056]   ISV =3D 0, ISS =3D 0x00000006
>> [2018-10-06 19:29:40]  [166384.582230]   CM =3D 0, WnR =3D 0
>> [2018-10-06 19:29:40]  [166384.585746] user pgtable: 4k pages, 48-bit VA=
s, pgd =3D ffff802190e79000
>> [2018-10-06 19:29:40]  [166384.592671] [0000000000000000] *pgd=000000219=
0dcb003, *pud=00000021911a2003, *pmd=0000000000000000
>> [2018-10-06 19:29:40]  [166384.602468] Internal error: Oops: 96000006 [#=
1] SMP
>> [2018-10-06 19:29:40]  [166384.607803] Modules linked in: tcm_qla2xxx(OE=
) qla2xxx(OE) iscsi_boot_sysfs(OE) iscsi_target_mod(OE) tcm_loop(OE) tcm_fc=
(OE) libfc(OE) target_core_file(OE) target_core_iblock(OE) target_core_user=
(OE) target_core_pscsi(OE) target_core_mod(OE) scsi_transport_srp(OE) scsi_=
transport_spi(OE) scsi_transport_fc(OE) scsi_debug(OE) ch(OE) st(OE) sg(OE)=
 test_platform_core(OE) debug_nic_mii(OE) nic_test(OE) hns3_enet_ut(OE) hcl=
ge(OE) hnae3(OE)
>> [2018-10-06 19:29:40]  [166384.650108] CPU: 1 PID: 0 Comm: swapper/1 Tai=
nted: G    B      OE   4.14.10 #1
>> [2018-10-06 19:29:40]  [166384.657753] Hardware name:  09/17/2018
>> [2018-10-06 19:29:40]  [166384.668270] task: ffff8021bedd3800 task.stack=
: ffff8021bee30000
>> [2018-10-06 19:29:40]  [166384.675186] PC is at strcpy+0x24/0x50
>> [2018-10-06 19:29:40]  [166384.679344] LR is at strcpy+0x24/0x50
>> [2018-10-06 19:29:40]  [166384.683479] pc : [<ffff2000092ae4e8>] lr : [<=
ffff2000092ae4e8>] pstate: 00400149
>> [2018-10-06 19:29:40]  [166384.691220] sp : ffff8021fffd3fd0
>> [2018-10-06 19:29:40]  [166384.694908] x29: ffff8021fffd3fd0 x28: 000060=
21f6594000
>> [2018-10-06 19:29:40]  [166384.700788] x27: 0000000000000002 x26: ffff80=
21fffd4148
>> [2018-10-06 19:29:40]  [166384.706658] x25: ffff200009a65d20 x24: ffff80=
219f04ee80
>> [2018-10-06 19:29:40]  [166384.712505] x23: ffff80219f04f498 x22: ffff80=
21be751814
>> [2018-10-06 19:29:40]  [166384.718358] x21: ffff8021be751800 x20: 000000=
0000000000
>> [2018-10-06 19:29:40]  [166384.724192] x19: ffff8021be751814 x18: 000000=
009aa30e07
>> [2018-10-06 19:29:40]  [166384.730029] x17: 00000000f013c082 x16: 000000=
0000000000
>> [2018-10-06 19:29:40]  [166384.735861] x15: ffffffffffffffff x14: 3d3d3d=
3d3d3d3d3d
>> [2018-10-06 19:29:40]  [166384.741708] x13: 3d3d3d3d3d3d3d3d x12: ffff04=
000155c2f7
>> [2018-10-06 19:29:40]  [166384.747555] x11: 1fffe4000155c2f6 x10: ffff04=
000155c2f6
>> [2018-10-06 19:29:40]  [166384.753400] x9 : dfff200000000000 x8 : 74206c=
656e72656b
>> [2018-10-06 19:29:40]  [166384.759244] x7 : 206f742065756420 x6 : ffff20=
000aae17b4
>> [2018-10-06 19:29:40]  [166384.765074] x5 : 0000000000000000 x4 : 000000=
0000000001
>> [2018-10-06 19:29:40]  [166384.770888] x3 : 0000000000000000 x2 : 000000=
0000000001
>> [2018-10-06 19:29:40]  [166384.776713] x1 : 904a39605117a800 x0 : 000000=
0000000000
>> [2018-10-06 19:29:40]  [166384.782648] Process swapper/1 (pid: 0, stack =
limit =3D 0xffff8021bee30000)
>> [2018-10-06 19:29:40]  [166384.789690] Call trace:
>> [2018-10-06 19:29:40]  [166384.792644] Exception stack(0xffff8021fffd3e9=
0 to 0xffff8021fffd3fd0)
>> [2018-10-06 19:29:40]  [166384.799582] 3e80:                            =
       0000000000000000 904a39605117a800
>> [2018-10-06 19:29:40]  [166384.807946] 3ea0: 0000000000000001 0000000000=
000000 0000000000000001 0000000000000000
>> [2018-10-06 19:29:40]  [166384.816353] 3ec0: ffff20000aae17b4 206f742065=
756420 74206c656e72656b dfff200000000000
>> [2018-10-06 19:29:40]  [166384.824753] 3ee0: ffff04000155c2f6 1fffe40001=
55c2f6 ffff04000155c2f7 3d3d3d3d3d3d3d3d
>> [2018-10-06 19:29:40]  [166384.833146] 3f00: 3d3d3d3d3d3d3d3d ffffffffff=
ffffff 0000000000000000 00000000f013c082
>> [2018-10-06 19:29:40]  [166384.841524] 3f20: 000000009aa30e07 ffff8021be=
751814 0000000000000000 ffff8021be751800
>> [2018-10-06 19:29:40]  [166384.849931] 3f40: ffff8021be751814 ffff80219f=
04f498 ffff80219f04ee80 ffff200009a65d20
>> [2018-10-06 19:29:40]  [166384.858302] 3f60: ffff8021fffd4148 0000000000=
000002 00006021f6594000 ffff8021fffd3fd0
>> [2018-10-06 19:29:40]  [166384.866687] 3f80: ffff2000092ae4e8 ffff8021ff=
fd3fd0 ffff2000092ae4e8 0000000000400149
>> [2018-10-06 19:29:40]  [166384.875071] 3fa0: ffff80219f04f498 ffff80219f=
04ee80 0001000000000000 904a39605117a800
>> [2018-10-06 19:29:40]  [166384.883359] 3fc0: ffff8021fffd3fd0 ffff200009=
2ae4e8
>> [2018-10-06 19:29:40]  [166384.888849] [<ffff2000092ae4e8>] strcpy+0x24/=
0x50
>> [2018-10-06 19:29:40]  [166384.904561] [<ffff2000015ebb24>] iscsit_handl=
e_nopin_response_timeout+0xbc/0x1b0 [iscsi_target_mod]
>> [2018-10-06 19:29:40]  [166384.914502] [<ffff20000818a130>] call_timer_f=
n+0x48/0x1e4
>> [2018-10-06 19:29:40]  [166384.920437] [<ffff20000818a448>] expire_timer=
s+0x150/0x1d8
>> [2018-10-06 19:29:40]  [166384.926430] [<ffff20000818a5bc>] run_timer_so=
ftirq+0xec/0x260
>> [2018-10-06 19:29:40]  [166384.932738] [<ffff200008081a90>] __do_softirq=
+0x1b8/0x488
>> [2018-10-06 19:29:40]  [166384.938951] [<ffff2000080ef96c>] irq_exit+0x1=
34/0x168
>> [2018-10-06 19:29:40]  [166384.944632] [<ffff2000081665f8>] __handle_dom=
ain_irq+0x84/0xe8
>> [2018-10-06 19:29:40]  [166384.950938] [<ffff200008081818>] gic_handle_i=
rq+0xd0/0x18c
>> [2018-10-06 19:29:40]  [166384.956877] Exception stack(0xffff8021bee37da=
0 to 0xffff8021bee37ee0)
>> [2018-10-06 19:29:40]  [166384.963864] 7da0: 0000000000000000 0000000000=
000003 dfff200000000000 0000000000000000
>> [2018-10-06 19:29:40]  [166384.972249] 7dc0: ffff8021fffbf000 0000000000=
000018 001dcd6500000000 ffff8021fffc6eef
>> [2018-10-06 19:29:40]  [166384.980644] 7de0: 1ffff0043fff8ddd dfff200000=
000000 ffff10043fff8ddd 1ffff0043fff8ddd
>> [2018-10-06 19:29:40]  [166384.989024] 7e00: ffff10043fff8dde 0000000000=
000000 0000000000000000 ffffffffffffffff
>> [2018-10-06 19:29:40]  [166384.997396] 7e20: 0000000000000000 00000000f0=
13c082 000000009aa30e07 ffff200009a2b000
>> [2018-10-06 19:29:40]  [166385.005763] 7e40: ffff200009a2b000 00006021f6=
594000 0000000000000001 ffff200009a66000
>> [2018-10-06 19:29:40]  [166385.014116] 7e60: ffff200009a376c8 0000000000=
000000 0000000000000000 0000000000000000
>> [2018-10-06 19:29:40]  [166385.022497] 7e80: 0000000000000000 ffff8021be=
e37ee0 ffff200008085d3c ffff8021bee37ee0
>> [2018-10-06 19:29:40]  [166385.030880] 7ea0: ffff200008085d40 0000000020=
c00149 ffff8021bee37f00 ffff200008181170
>> [2018-10-06 19:29:40]  [166385.039268] 7ec0: ffffffffffffffff 0140000000=
000000 ffff8021bee37ee0 ffff200008085d40
>> [2018-10-06 19:29:40]  [166385.047622] [<ffff200008083030>] el1_irq+0xb0=
/0x140
>> [2018-10-06 19:29:40]  [166385.053058] [<ffff200008085d40>] arch_cpu_idl=
e+0x40/0x1e4
>> [2018-10-06 19:29:40]  [166385.059134] [<ffff2000092bf478>] default_idle=
_call+0x2c/0x48
>> [2018-10-06 19:29:40]  [166385.065279] [<ffff20000814ecd0>] do_idle+0x19=
0/0x1f8
>> [2018-10-06 19:29:40]  [166385.070710] [<ffff20000814ef54>] cpu_startup_=
entry+0x2c/0x30
>> [2018-10-06 19:29:40]  [166385.076980] [<ffff200008093c84>] secondary_st=
art_kernel+0x19c/0x1d4
>> [2018-10-06 19:29:40]  [166385.083878] Code: aa0003f6 aa0103f4 aa0103e0 =
97c20f35 (38401695)
>> [2018-10-06 19:29:40]  [166385.090863] ---[ end trace 8844ac3a19d17b32 ]=
---
>> [2018-10-06 19:29:40]  [166385.095920] Kernel panic - not syncing: Fatal=
 exception in interrupt
>> [2018-10-06 19:29:40]  [166385.102855] SMP: stopping secondary CPUs
>> [2018-10-06 19:29:40]  [166385.107502] Kernel Offset: disabled
>> [2018-10-06 19:29:40]  [166385.111460] CPU features: 0x000a18
>> [2018-10-06 19:29:40]  [166385.115199] Memory Limit: none
>> [2018-10-06 19:29:40]  [166385.118780] ---[ end Kernel panic - not synci=
ng: Fatal exception in interrupt
>>
>>
>=20
