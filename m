From: Vincent Pelletier <plr.vincent@gmail.com>
Date: Sun, 12 Aug 2018 02:55:31 +0000
Subject: Re: BUG in slab_free after iSCSI login timeout
Message-Id: <20180812025531.7785b419@gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180811093655.42922d8e@gmail.com>
In-Reply-To: <20180811093655.42922d8e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sat, 11 Aug 2018 22:50:12 +0000, Bart Van Assche
<Bart.VanAssche@wdc.com> wrote:
> On Sat, 2018-08-11 at 09:36 +0000, Vincent Pelletier wrote:
> > What can I try to help debug this further ?  
> 
> Can you try to reproduce this with KASAN enabled in the kernel config?

Here is the syslog with KASAN enabled:

Aug 12 04:44:53 boke kernel: [   64.736033] iSCSI Login timeout on Network Portal [::]:3260
Aug 12 04:44:53 boke kernel: [   64.736449] iSCSI Login negotiation failed.
Aug 12 04:44:53 boke kernel: [   64.736653] =================================
Aug 12 04:44:53 boke kernel: [   64.737069] BUG: KASAN: use-after-free in iscsi_target_login_sess_out.cold.11+0x58/0x123 [iscsi_target_mod]
Aug 12 04:44:53 boke kernel: [   64.737515] Read of size 8 at addr ffff880113ca6bc8 by task iscsi_np/992
Aug 12 04:44:53 boke kernel: [   64.737814]
Aug 12 04:44:53 boke kernel: [   64.737914] CPU: 0 PID: 992 Comm: iscsi_np Tainted: G           O      4.17.8kasan #1
Aug 12 04:44:53 boke kernel: [   64.737920] Hardware name: To be filled by O.E.M. To be filled by O.E.M./Aptio CRB, BIOS 5.6.5 05/19/2014
Aug 12 04:44:53 boke kernel: [   64.737924] Call Trace:
Aug 12 04:44:53 boke kernel: [   64.737945]  dump_stack+0x71/0xac
Aug 12 04:44:53 boke kernel: [   64.737961]  print_address_description+0x65/0x22e
Aug 12 04:44:53 boke kernel: [   64.738054]  ? iscsi_target_login_sess_out.cold.11+0x58/0x123 [iscsi_target_mod]
Aug 12 04:44:53 boke kernel: [   64.738066]  kasan_report.cold.6+0x241/0x2fd
Aug 12 04:44:53 boke kernel: [   64.738157]  iscsi_target_login_sess_out.cold.11+0x58/0x123 [iscsi_target_mod]
Aug 12 04:44:53 boke kernel: [   64.738246]  iscsi_target_login_thread+0x10c4/0x1720 [iscsi_target_mod]
Aug 12 04:44:53 boke kernel: [   64.738264]  ? __sched_text_start+0x8/0x8
Aug 12 04:44:53 boke kernel: [   64.738349]  ? iscsi_target_login_sess_out+0x280/0x280 [iscsi_target_mod]
Aug 12 04:44:53 boke kernel: [   64.738361]  ? __kthread_parkme+0xcc/0x100
Aug 12 04:44:53 boke kernel: [   64.738374]  ? parse_args.cold.14+0xd3/0xd3
Aug 12 04:44:53 boke kernel: [   64.738460]  ? iscsi_target_login_sess_out+0x280/0x280 [iscsi_target_mod]
Aug 12 04:44:53 boke kernel: [   64.738478]  kthread+0x1a0/0x1c0
Aug 12 04:44:53 boke kernel: [   64.738491]  ? kthread_bind+0x30/0x30
Aug 12 04:44:53 boke kernel: [   64.738502]  ret_from_fork+0x35/0x40
Aug 12 04:44:53 boke kernel: [   64.738510]
Aug 12 04:44:53 boke kernel: [   64.738600] Allocated by task 992:
Aug 12 04:44:53 boke kernel: [   64.738772]  kasan_kmalloc+0xbf/0xe0
Aug 12 04:44:53 boke kernel: [   64.738782]  kmem_cache_alloc_trace+0x112/0x210
Aug 12 04:44:53 boke kernel: [   64.738865]  iscsi_target_login_thread+0x844/0x1720 [iscsi_target_mod]
Aug 12 04:44:53 boke kernel: [   64.738875]  kthread+0x1a0/0x1c0
Aug 12 04:44:53 boke kernel: [   64.738884]  ret_from_fork+0x35/0x40
Aug 12 04:44:53 boke kernel: [   64.738887]
Aug 12 04:44:53 boke kernel: [   64.738973] Freed by task 992:
Aug 12 04:44:53 boke kernel: [   64.739129]  __kasan_slab_free+0x125/0x170
Aug 12 04:44:53 boke kernel: [   64.739137]  kfree+0x90/0x1d0
Aug 12 04:44:53 boke kernel: [   64.739220]  iscsi_target_login_thread+0x15c7/0x1720 [iscsi_target_mod]
Aug 12 04:44:53 boke kernel: [   64.739230]  kthread+0x1a0/0x1c0
Aug 12 04:44:53 boke kernel: [   64.739239]  ret_from_fork+0x35/0x40
Aug 12 04:44:53 boke kernel: [   64.739241]
Aug 12 04:44:53 boke kernel: [   64.739330] The buggy address belongs to the object at ffff880113ca6a00
Aug 12 04:44:53 boke kernel: [   64.739330]  which belongs to the cache kmalloc-512 of size 512
Aug 12 04:44:53 boke kernel: [   64.739877] The buggy address is located 456 bytes inside of
Aug 12 04:44:53 boke kernel: [   64.739877]  512-byte region [ffff880113ca6a00, ffff880113ca6c00)
Aug 12 04:44:53 boke kernel: [   64.740385] The buggy address belongs to the page:
Aug 12 04:44:53 boke kernel: [   64.740611] page:ffffea00044f2980 count:1 mapcount:0 mapping:0000000000000000 index:0x0 compound_mapcount: 0
Aug 12 04:44:53 boke kernel: [   64.741053] flags: 0x17fffc000008100(slab|head)
Aug 12 04:44:53 boke kernel: [   64.741273] raw: 017fffc000008100 0000000000000000 0000000000000000 00000001000c000c
Aug 12 04:44:53 boke kernel: [   64.741626] raw: dead000000000100 dead000000000200 ffff88011b002e00 0000000000000000
Aug 12 04:44:53 boke kernel: [   64.741971] page dumped because: kasan: bad access detected
Aug 12 04:44:53 boke kernel: [   64.742222]
Aug 12 04:44:53 boke kernel: [   64.742304] Memory state around the buggy address:
Aug 12 04:44:53 boke kernel: [   64.742531]  ffff880113ca6a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
Aug 12 04:44:53 boke kernel: [   64.742858]  ffff880113ca6b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
Aug 12 04:44:53 boke kernel: [   64.747255] >ffff880113ca6b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
Aug 12 04:44:53 boke kernel: [   64.751156]                                               ^
Aug 12 04:44:53 boke kernel: [   64.755081]  ffff880113ca6c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
Aug 12 04:44:53 boke kernel: [   64.758397]  ffff880113ca6c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
Aug 12 04:44:53 boke kernel: [   64.762372] =================================
Aug 12 04:44:53 boke kernel: [   64.768126] Disabling lock debugging due to kernel taint
Aug 12 04:44:53 boke kernel: [   64.768226] =================================
Aug 12 04:44:53 boke kernel: [   64.771148] BUG: KASAN: double-free or invalid-free in iscsi_target_login_sess_out.cold.11+0x103/0x123 [iscsi_target_mod]
Aug 12 04:44:53 boke kernel: [   64.776782]
Aug 12 04:44:53 boke kernel: [   64.779480] CPU: 0 PID: 992 Comm: iscsi_np Tainted: G    B      O      4.17.8kasan #1
Aug 12 04:44:53 boke kernel: [   64.779483] Hardware name: To be filled by O.E.M. To be filled by O.E.M./Aptio CRB, BIOS 5.6.5 05/19/2014
Aug 12 04:44:53 boke kernel: [   64.779486] Call Trace:
Aug 12 04:44:53 boke kernel: [   64.779499]  dump_stack+0x71/0xac
Aug 12 04:44:53 boke kernel: [   64.779508]  print_address_description+0x65/0x22e
Aug 12 04:44:53 boke kernel: [   64.779555]  ? iscsi_target_login_sess_out.cold.11+0x103/0x123 [iscsi_target_mod]
Aug 12 04:44:53 boke kernel: [   64.779562]  kasan_report_invalid_free+0x65/0xa0
Aug 12 04:44:53 boke kernel: [   64.779609]  ? iscsi_target_login_sess_out.cold.11+0x103/0x123 [iscsi_target_mod]
Aug 12 04:44:53 boke kernel: [   64.779614]  __kasan_slab_free+0x157/0x170
Aug 12 04:44:53 boke kernel: [   64.779661]  ? iscsi_target_login_sess_out.cold.11+0x103/0x123 [iscsi_target_mod]
Aug 12 04:44:53 boke kernel: [   64.779666]  kfree+0x90/0x1d0
Aug 12 04:44:53 boke kernel: [   64.779712]  iscsi_target_login_sess_out.cold.11+0x103/0x123 [iscsi_target_mod]
Aug 12 04:44:53 boke kernel: [   64.779758]  iscsi_target_login_thread+0x10c4/0x1720 [iscsi_target_mod]
Aug 12 04:44:53 boke kernel: [   64.779769]  ? __sched_text_start+0x8/0x8
Aug 12 04:44:53 boke kernel: [   64.779812]  ? iscsi_target_login_sess_out+0x280/0x280 [iscsi_target_mod]
Aug 12 04:44:53 boke kernel: [   64.779819]  ? __kthread_parkme+0xcc/0x100
Aug 12 04:44:53 boke kernel: [   64.779826]  ? parse_args.cold.14+0xd3/0xd3
Aug 12 04:44:53 boke kernel: [   64.779870]  ? iscsi_target_login_sess_out+0x280/0x280 [iscsi_target_mod]
Aug 12 04:44:53 boke kernel: [   64.779875]  kthread+0x1a0/0x1c0
Aug 12 04:44:53 boke kernel: [   64.779882]  ? kthread_bind+0x30/0x30
Aug 12 04:44:53 boke kernel: [   64.779888]  ret_from_fork+0x35/0x40
Aug 12 04:44:53 boke kernel: [   64.779892]
Aug 12 04:44:53 boke kernel: [   64.782589] Allocated by task 992:
Aug 12 04:44:53 boke kernel: [   64.785331]  kasan_kmalloc+0xbf/0xe0
Aug 12 04:44:53 boke kernel: [   64.785336]  kmem_cache_alloc_trace+0x112/0x210
Aug 12 04:44:53 boke kernel: [   64.785378]  iscsi_target_login_thread+0x844/0x1720 [iscsi_target_mod]
Aug 12 04:44:53 boke kernel: [   64.785384]  kthread+0x1a0/0x1c0
Aug 12 04:44:53 boke kernel: [   64.785388]  ret_from_fork+0x35/0x40
Aug 12 04:44:53 boke kernel: [   64.785390]
Aug 12 04:44:53 boke kernel: [   64.788089] Freed by task 992:
Aug 12 04:44:53 boke kernel: [   64.790828]  __kasan_slab_free+0x125/0x170
Aug 12 04:44:53 boke kernel: [   64.790833]  kfree+0x90/0x1d0
Aug 12 04:44:53 boke kernel: [   64.790876]  iscsi_target_login_thread+0x15c7/0x1720 [iscsi_target_mod]
Aug 12 04:44:53 boke kernel: [   64.790881]  kthread+0x1a0/0x1c0
Aug 12 04:44:53 boke kernel: [   64.790885]  ret_from_fork+0x35/0x40
Aug 12 04:44:53 boke kernel: [   64.790887]
Aug 12 04:44:53 boke kernel: [   64.793592] The buggy address belongs to the object at ffff880113ca6a00
Aug 12 04:44:53 boke kernel: [   64.793592]  which belongs to the cache kmalloc-512 of size 512
Aug 12 04:44:53 boke kernel: [   64.799193] The buggy address is located 0 bytes inside of
Aug 12 04:44:53 boke kernel: [   64.799193]  512-byte region [ffff880113ca6a00, ffff880113ca6c00)
Aug 12 04:44:53 boke kernel: [   64.804771] The buggy address belongs to the page:
Aug 12 04:44:53 boke kernel: [   64.807550] page:ffffea00044f2980 count:1 mapcount:0 mapping:0000000000000000 index:0x0 compound_mapcount: 0
Aug 12 04:44:53 boke kernel: [   64.813107] flags: 0x17fffc000008100(slab|head)
Aug 12 04:44:53 boke kernel: [   64.815886] raw: 017fffc000008100 0000000000000000 0000000000000000 00000001000c000c
Aug 12 04:44:53 boke kernel: [   64.818736] raw: dead000000000100 dead000000000200 ffff88011b002e00 0000000000000000
Aug 12 04:44:53 boke kernel: [   64.821581] page dumped because: kasan: bad access detected
Aug 12 04:44:53 boke kernel: [   64.824383]
Aug 12 04:44:53 boke kernel: [   64.827097] Memory state around the buggy address:
Aug 12 04:44:53 boke kernel: [   64.829886]  ffff880113ca6900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
Aug 12 04:44:53 boke kernel: [   64.832729]  ffff880113ca6980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
Aug 12 04:44:53 boke kernel: [   64.835621] >ffff880113ca6a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
Aug 12 04:44:53 boke kernel: [   64.838559]                    ^
Aug 12 04:44:53 boke kernel: [   64.841412]  ffff880113ca6a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
Aug 12 04:44:53 boke kernel: [   64.844354]  ffff880113ca6b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
Aug 12 04:44:53 boke kernel: [   64.847247] =================================
Aug 12 04:45:28 boke kernel: [   99.808033] iSCSI Login timeout on Network Portal [::]:3260
Aug 12 04:45:28 boke kernel: [   99.813911] iSCSI Login negotiation failed.
Aug 12 04:45:28 boke kernel: [   99.819178] =================================
Aug 12 04:45:28 boke kernel: [   99.824242] BUG: KASAN: double-free or invalid-free in iscsi_target_login_sess_out.cold.11+0x103/0x123 [iscsi_target_mod]
Aug 12 04:45:28 boke kernel: [   99.834681]
Aug 12 04:45:28 boke kernel: [   99.839909] CPU: 1 PID: 992 Comm: iscsi_np Tainted: G    B      O      4.17.8kasan #1
Aug 12 04:45:28 boke kernel: [   99.839914] Hardware name: To be filled by O.E.M. To be filled by O.E.M./Aptio CRB, BIOS 5.6.5 05/19/2014
Aug 12 04:45:28 boke kernel: [   99.839918] Call Trace:
Aug 12 04:45:28 boke kernel: [   99.839937]  dump_stack+0x71/0xac
Aug 12 04:45:28 boke kernel: [   99.839952]  print_address_description+0x65/0x22e
Aug 12 04:45:28 boke kernel: [   99.840033]  ? iscsi_target_login_sess_out.cold.11+0x103/0x123 [iscsi_target_mod]
Aug 12 04:45:28 boke kernel: [   99.840045]  kasan_report_invalid_free+0x65/0xa0
Aug 12 04:45:28 boke kernel: [   99.840125]  ? iscsi_target_login_sess_out.cold.11+0x103/0x123 [iscsi_target_mod]
Aug 12 04:45:28 boke kernel: [   99.840135]  __kasan_slab_free+0x157/0x170
Aug 12 04:45:28 boke kernel: [   99.840215]  ? iscsi_target_login_sess_out.cold.11+0x103/0x123 [iscsi_target_mod]
Aug 12 04:45:28 boke kernel: [   99.840223]  kfree+0x90/0x1d0
Aug 12 04:45:28 boke kernel: [   99.840303]  iscsi_target_login_sess_out.cold.11+0x103/0x123 [iscsi_target_mod]
Aug 12 04:45:28 boke kernel: [   99.840382]  iscsi_target_login_thread+0x10c4/0x1720 [iscsi_target_mod]
Aug 12 04:45:28 boke kernel: [   99.840398]  ? __sched_text_start+0x8/0x8
Aug 12 04:45:28 boke kernel: [   99.840474]  ? iscsi_target_login_sess_out+0x280/0x280 [iscsi_target_mod]
Aug 12 04:45:28 boke kernel: [   99.840485]  ? __kthread_parkme+0xcc/0x100
Aug 12 04:45:28 boke kernel: [   99.840496]  ? parse_args.cold.14+0xd3/0xd3
Aug 12 04:45:28 boke kernel: [   99.840572]  ? iscsi_target_login_sess_out+0x280/0x280 [iscsi_target_mod]
Aug 12 04:45:28 boke kernel: [   99.840581]  kthread+0x1a0/0x1c0
Aug 12 04:45:28 boke kernel: [   99.840593]  ? kthread_bind+0x30/0x30
Aug 12 04:45:28 boke kernel: [   99.840603]  ret_from_fork+0x35/0x40
Aug 12 04:45:28 boke kernel: [   99.840610]
Aug 12 04:45:28 boke kernel: [   99.845766] Allocated by task 992:
Aug 12 04:45:28 boke kernel: [   99.851007]  kasan_kmalloc+0xbf/0xe0
Aug 12 04:45:28 boke kernel: [   99.851016]  kmem_cache_alloc_trace+0x112/0x210
Aug 12 04:45:28 boke kernel: [   99.851090]  iscsi_target_login_thread+0x844/0x1720 [iscsi_target_mod]
Aug 12 04:45:28 boke kernel: [   99.851099]  kthread+0x1a0/0x1c0
Aug 12 04:45:28 boke kernel: [   99.851107]  ret_from_fork+0x35/0x40
Aug 12 04:45:28 boke kernel: [   99.851109]
Aug 12 04:45:28 boke kernel: [   99.856286] Freed by task 992:
Aug 12 04:45:28 boke kernel: [   99.861405]  __kasan_slab_free+0x125/0x170
Aug 12 04:45:28 boke kernel: [   99.861412]  kfree+0x90/0x1d0
Aug 12 04:45:28 boke kernel: [   99.861486]  iscsi_target_login_thread+0x15c7/0x1720 [iscsi_target_mod]
Aug 12 04:45:28 boke kernel: [   99.861495]  kthread+0x1a0/0x1c0
Aug 12 04:45:28 boke kernel: [   99.861503]  ret_from_fork+0x35/0x40
Aug 12 04:45:28 boke kernel: [   99.861505]
Aug 12 04:45:28 boke kernel: [   99.866456] The buggy address belongs to the object at ffff880119ce4c80
Aug 12 04:45:28 boke kernel: [   99.866456]  which belongs to the cache kmalloc-512 of size 512
Aug 12 04:45:28 boke kernel: [   99.876739] The buggy address is located 0 bytes inside of
Aug 12 04:45:28 boke kernel: [   99.876739]  512-byte region [ffff880119ce4c80, ffff880119ce4e80)
Aug 12 04:45:28 boke kernel: [   99.886859] The buggy address belongs to the page:
Aug 12 04:45:28 boke kernel: [   99.891718] page:ffffea0004673900 count:1 mapcount:0 mapping:0000000000000000 index:0x0 compound_mapcount: 0
Aug 12 04:45:28 boke kernel: [   99.901751] flags: 0x17fffc000008100(slab|head)
Aug 12 04:45:28 boke kernel: [   99.906847] raw: 017fffc000008100 0000000000000000 0000000000000000 00000001800c000c
Aug 12 04:45:28 boke kernel: [   99.912053] raw: dead000000000100 dead000000000200 ffff88011b002e00 0000000000000000
Aug 12 04:45:28 boke kernel: [   99.917221] page dumped because: kasan: bad access detected
Aug 12 04:45:28 boke kernel: [   99.922409]
Aug 12 04:45:28 boke kernel: [   99.927394] Memory state around the buggy address:
Aug 12 04:45:28 boke kernel: [   99.932535]  ffff880119ce4b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
Aug 12 04:45:28 boke kernel: [   99.937874]  ffff880119ce4c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
Aug 12 04:45:28 boke kernel: [   99.943113] >ffff880119ce4c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
Aug 12 04:45:28 boke kernel: [   99.948253]                    ^
Aug 12 04:45:28 boke kernel: [   99.953425]  ffff880119ce4d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
Aug 12 04:45:28 boke kernel: [   99.958724]  ffff880119ce4d80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
Aug 12 04:45:28 boke kernel: [   99.963801] =================================

For completeness, I should mention this is with a vanilla kernel build
as of:
  commit 5606f577a707aa4ccc391714dca815933aeba508 (HEAD, tag: v4.17.8)
  Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
  Date:   Wed Jul 18 07:56:38 2018 +0200

      Linux 4.17.8
which hence lacks any debian patch which would have been present in
the previous kernel.
I did build it with the debian-provided .config, enabling CONFIG_KASAN
and emptying CONFIG_SYSTEM_TRUSTED_KEYS. Post-menuconfig .config diff
against /boot/config-4.17.0-1-amd64:
40a41
> CONFIG_KASAN_SHADOW_OFFSET=0xdffffc0000000000
45a47
> CONFIG_CONSTRUCTORS=y
56c58
< CONFIG_LOCALVERSION=""
---
> CONFIG_LOCALVERSION="kasan"
58d59
< CONFIG_BUILD_SALT="4.17.0-1-amd64"
342d342
< CONFIG_VMAP_STACK=y
927d926
< CONFIG_X86_X32_DISABLED=y
5241a5241,5242
> # CONFIG_FB_NVIDIA is not set
> # CONFIG_FB_RIVA is not set
5854c5855
< CONFIG_USB_COMMON=m
---
> CONFIG_USB_COMMON=y
6767c6768
< CONFIG_ASHMEM=m
---
> # CONFIG_ASHMEM is not set
7370,7372c7371
< CONFIG_ANDROID_BINDER_IPC=m
< CONFIG_ANDROID_BINDER_DEVICES="binder"
< # CONFIG_ANDROID_BINDER_IPC_SELFTEST is not set
---
> # CONFIG_ANDROID_BINDER_IPC is not set
7860c7859,7863
< # CONFIG_KASAN is not set
---
> CONFIG_KASAN=y
> # CONFIG_KASAN_EXTRA is not set
> CONFIG_KASAN_OUTLINE=y
> # CONFIG_KASAN_INLINE is not set
> # CONFIG_TEST_KASAN is not set
8057d8059
< # CONFIG_UNWINDER_GUESS is not set
8070d8071
< CONFIG_SECURITY_PERF_EVENTS_RESTRICT=y
8086,8088d8086
< CONFIG_LOCK_DOWN_KERNEL=y
< # CONFIG_ALLOW_LOCKDOWN_LIFT_BY_SYSRQ is not set
< CONFIG_LOCK_DOWN_IN_EFI_SECURE_BOOT=y
8330c8328
< CONFIG_SYSTEM_TRUSTED_KEYS="debian/certs/test-signing-certs.pem"
---
> CONFIG_SYSTEM_TRUSTED_KEYS=""
8456a8455
> CONFIG_STACKDEPOT=y
-- 
Vincent Pelletier
