From: Vincent Pelletier <plr.vincent@gmail.com>
Date: Sun, 12 Aug 2018 03:51:40 +0000
Subject: Re: BUG in slab_free after iSCSI login timeout
Message-Id: <20180812035140.4f4a1527@gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180811093655.42922d8e@gmail.com>
In-Reply-To: <20180811093655.42922d8e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sun, 12 Aug 2018 02:55:31 +0000, Vincent Pelletier
<plr.vincent@gmail.com> wrote:
> Aug 12 04:44:53 boke kernel: [   64.737069] BUG: KASAN: use-after-free in iscsi_target_login_sess_out.cold.11+0x58/0x123 [iscsi_target_mod]
> Aug 12 04:44:53 boke kernel: [   64.771148] BUG: KASAN: double-free or invalid-free in iscsi_target_login_sess_out.cold.11+0x103/0x123 [iscsi_target_mod]

If I'm reading the code correctly, the double-free would be
iscsi_login_init_conn and iscsi_target_login_sess_out both calling
kfree(conn->conn_ops), with the latter called by
__iscsi_target_login_thread precisely when the former fails (returns
NULL after freeing).

I'm not spotting the use-after-free so far, and do not yet understand
why iscsi_login_init_conn would fail:
- allocation-related failures allocate a fixed amount of ram, the
  target machine has 4GB and very few userland processes
  This said, I was surprised by "free" output listing only a bit
  above 3GB of ram total:
  $ free -m
                total        used        free      shared  buff/cache   available
  Mem:           3310         250        2867           5         192        2847
  Swap:          5015           0        5015
  Would it be an effect of KASAN ?
  I also found the following line in dmesg:
  [    0.000000] Memory: 3099784K/4088348K available (14348K kernel code, 4532K rwdata, 5400K rodata, 1840K init, 9112K bss, 988564K reserved, 0K cma-reserved)
  Checking pre-KASAN boots it was:
  [    0.000000] Memory: 3657884K/4088348K available (10252K kernel code, 1210K rwdata, 3216K rodata, 1548K init, 656K bss, 430464K reserved, 0K cma-reserved)
- $ grep CONFIG_CPUMASK_OFFSTACK .config
  $
  so zalloc_cpumask_var should have no way to fail.

Regards,
-- 
Vincent Pelletier
