From: Ming Lei <ming.lei@redhat.com>
Date: Thu, 28 Nov 2019 01:57:48 +0000
Subject: Re: Data corruption in kernel 5.1+ with iSER attached ramdisk
Message-Id: <20191128015748.GA3277@ming.t460p>
List-Id: <target-devel.vger.kernel.org>
References: <CAAFE1bd9wuuobpe4VK7Ty175j7mWT+kRmHCNhVD+6R8MWEAqmw@mail.gmail.com>
In-Reply-To: <CAAFE1bd9wuuobpe4VK7Ty175j7mWT+kRmHCNhVD+6R8MWEAqmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Stephen Rust <srust@blockbridge.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com

Hello,

On Wed, Nov 27, 2019 at 02:38:42PM -0500, Stephen Rust wrote:
> Hi,
> 
> We recently began testing 5.4 in preparation for migration from 4.14. One
> of our tests found reproducible data corruption in 5.x kernels. The test
> consists of a few basic single-issue writes to an iSER attached ramdisk.
> The writes are subsequently verified with single-issue reads. We tracked
> the corruption down using git bisect. The issue appears to have started in
> 5.1 with the following commit:
> 
> 3d75ca0adef4280650c6690a0c4702a74a6f3c95 block: introduce multi-page bvec
> helpers
> 
> We wanted to bring this to your attention. A reproducer and the git bisect
> data follows below.
> 
> Our setup consists of two systems: A ramdisk exported in a LIO target from
> host A, iSCSI attached with iSER / RDMA from host B. Specific writes to the

Could you explain a bit what is iSCSI attached with iSER / RDMA? Is the
actual transport TCP over RDMA? What is related target driver involved?

> very end of the attached disk on B result in incorrect data being written
> to the remote disk. The writes appear to complete successfully on the
> client. We’ve also verified that the correct data is being sent over the
> network by tracing the RDMA flow. For reference, the tests were conducted
> on x86_64 Intel Skylake systems with Mellanox ConnectX5 NICs.

If I understand correctly, LIO ramdisk doesn't generate any IO to block
stack, see rd_execute_rw(), and the ramdisk should be one big/long
pre-allocated sgl, see rd_build_device_space().

Seems very strange, given no bvec/bio is involved in this code
path from iscsi_target_rx_thread to rd_execute_rw. So far I have no idea
how commit 3d75ca0adef428065 causes this issue, because that patch
only changes bvec/bio related code.

> 
> The issue appears to lie on the target host side. The initiator kernel
> version does not appear to play a role. The target host exhibits the issue
> when running kernel version 5.1+.
> 
> To reproduce, given attached sda on client host B, write data at the end of
> the device:
> 
> 
> SIZE=$(blockdev --getsize64 /dev/sda)
> 
> SEEK=$((( $SIZE - 512 )))
> 
> # initialize device and seed data
> 
> dd if=/dev/zero of=/dev/sda bs=512 count=1 seek=$SEEK oflag=seek_bytes
> oflag=direct
> 
> dd if=/dev/urandom of=/tmp/random bs=512 count=1 oflag=direct
> 
> 
> # write the random data (note: not direct)
> 
> dd if=/tmp/random of=/dev/sda bs=512 count=1 seek=$SEEK oflag=seek_bytes
> 
> 
> # verify the data was written
> 
> dd if=/dev/sda of=/tmp/verify bs=512 count=1 skip=$SEEK iflag=skip_bytes
> iflag=direct
> 
> hexdump -xv /tmp/random > /tmp/random.hex
> 
> hexdump -xv /tmp/verify > /tmp/verify.hex
> 
> diff -u /tmp/random.hex /tmp/verify.hex

I just setup one LIO for exporting ramdisk(2G) via iscsi, and run the
above test via iscsi HBA, still can't reproduce the issue.

> # first bad commit: [3d75ca0adef4280650c6690a0c4702a74a6f3c95] block:
> introduce multi-page bvec helpers
> 
> 
> Please advise. We have cycles and systems to help track down the issue. Let
> me know how best to assist.

Could you install bcc and start to collect the following trace on target side
before you run the above test in host side?

/usr/share/bcc/tools/stackcount -K rd_execute_rw


Thanks,
Ming
