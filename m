From: Vincent Pelletier <plr.vincent@gmail.com>
Date: Sun, 12 Aug 2018 04:01:26 +0000
Subject: Re: BUG in slab_free after iSCSI login timeout
Message-Id: <20180812040126.6f54f705@gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180811093655.42922d8e@gmail.com>
In-Reply-To: <20180811093655.42922d8e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sun, 12 Aug 2018 03:51:40 +0000, Vincent Pelletier
<plr.vincent@gmail.com> wrote:
>   This said, I was surprised by "free" output listing only a bit
>   above 3GB of ram total:
>   $ free -m
>                 total        used        free      shared  buff/cache   available
>   Mem:           3310         250        2867           5         192        2847
>   Swap:          5015           0        5015
>   Would it be an effect of KASAN ?
>   I also found the following line in dmesg:
>   [    0.000000] Memory: 3099784K/4088348K available (14348K kernel code, 4532K rwdata, 5400K rodata, 1840K init, 9112K bss, 988564K reserved, 0K cma-reserved)
>   Checking pre-KASAN boots it was:
>   [    0.000000] Memory: 3657884K/4088348K available (10252K kernel code, 1210K rwdata, 3216K rodata, 1548K init, 656K bss, 430464K reserved, 0K cma-reserved)

Answering my own question after a bit of RTFM: KASAN uses 1 byte to
track 8 bytes, so monitoring 4GB takes 512MB, so it indeed explains the
vast majority of the difference in reserved memory.
-- 
Vincent Pelletier
