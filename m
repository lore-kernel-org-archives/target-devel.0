From: Greg Edwards <gedwards@ddn.com>
Date: Tue, 04 Sep 2018 16:27:01 +0000
Subject: Re: [PATCH v3] target/iblock: split T10 PI SGL across command bios
Message-Id: <20180904162701.GA30643@psuche>
List-Id: <target-devel.vger.kernel.org>
References: <20180830172504.12348-1-gedwards@ddn.com>
In-Reply-To: <20180830172504.12348-1-gedwards@ddn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sat, Sep 01, 2018 at 08:42:16AM +0800, kbuild test robot wrote:
> Hi Greg,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on target/for-next]
> [also build test WARNING on v4.19-rc1 next-20180831]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Greg-Edwards/target-iblock-split-T10-PI-SGL-across-command-bios/20180831-204618
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next
> config: i386-randconfig-h1-09010405 (attached as .config)
> compiler: gcc-4.9 (Debian 4.9.4-2) 4.9.4
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386
>
> All warnings (new ones prefixed by >>):
>
>    drivers//target/target_core_iblock.c: In function 'iblock_alloc_bip':
>    drivers//target/target_core_iblock.c:663:2: error: implicit declaration of function 'bio_integrity_bytes' [-Werror=implicit-function-declaration]
>      bip->bip_iter.bi_size = bio_integrity_bytes(bi, bio_sectors(bio));
>      ^
>    In file included from include/linux/printk.h:329:0,
>                     from include/linux/kernel.h:14,
>                     from include/linux/list.h:9,
>                     from include/linux/timer.h:5,
>                     from drivers//target/target_core_iblock.c:29:

Should the 0-day being using a different target tree/branch?  The
for-next branch above hasn't been updated since January.

Greg
