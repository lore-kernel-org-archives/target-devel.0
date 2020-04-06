From: Andreas Kinzler <hfp@posteo.de>
Date: Mon, 06 Apr 2020 22:01:49 +0000
Subject: Re: strange dm-crypt problem with qemu / LIO / vhost
Message-Id: <b05a9703-673b-8a14-c274-69258f28879b@posteo.de>
List-Id: <target-devel.vger.kernel.org>
References: <5e29cc94-a21d-2506-9bac-48d8d29ab85b@posteo.de>
In-Reply-To: <5e29cc94-a21d-2506-9bac-48d8d29ab85b@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hello David,

> It's normally a good idea to provide your kernel version with any
> bug reports...

Sorry. Kernel is 5.3.18 vanilla from kernel.org

>> [ 3683.414936] bio error: 0000000024d02dea,  err: 10
>> This is from target_core_iblock.c function "iblock_bio_done".
>> Any ideas? Hints?
> This looks like an I/O error from the block layer / underlying dm-crypt
> block device. It's not much to go on, but I'd suggest tracing the I/O
> further down the stack.

In the meantime, I was able to debug further. Actually in Windows only 
the "format disk" operation fails. If you do that otherwise and later 
use the formatted disk, it seems to work. So I assume it is a special 
SCSI opcode that is only used during "format disk" that fails.

What would be a simple debug statement in iblock_bio_done to print the 
SCSI opcode to find out which operation failed?

> Cheers, David

Regards Andreas
