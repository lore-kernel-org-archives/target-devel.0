From: David Disseldorp <ddiss@suse.de>
Date: Mon, 06 Apr 2020 21:33:47 +0000
Subject: Re: strange dm-crypt problem with qemu / LIO / vhost
Message-Id: <20200406233347.5c764427@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <5e29cc94-a21d-2506-9bac-48d8d29ab85b@posteo.de>
In-Reply-To: <5e29cc94-a21d-2506-9bac-48d8d29ab85b@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi Andreas,

It's normally a good idea to provide your kernel version with any
bug reports...

On Mon, 6 Apr 2020 20:21:55 +0200, Andreas Kinzler wrote:

> [ 3683.414936] bio error: 0000000024d02dea,  err: 10
> 
> This is from target_core_iblock.c function "iblock_bio_done".
> 
> Any ideas? Hints?

This looks like an I/O error from the block layer / underlying dm-crypt
block device. It's not much to go on, but I'd suggest tracing the I/O
further down the stack.

Cheers, David
