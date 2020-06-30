From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Tue, 30 Jun 2020 16:52:44 +0000
Subject: Re: [RFC] scsi: target: tcmu: running 32bit userspace on 64bit kernel
Message-Id: <1593535964.4124.2.camel@HansenPartnership.com>
List-Id: <target-devel.vger.kernel.org>
References: <364c13da-6d4f-c28b-36b3-082db8c3de58@ts.fujitsu.com>
In-Reply-To: <364c13da-6d4f-c28b-36b3-082db8c3de58@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <michael.christie@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Tue, 2020-06-30 at 18:49 +0200, Bodo Stroesser wrote:
> Hi,
> 
> When using tcmu it might happen, that userspace application cannot be
> built as 64 bit program even on a 64 bit host due to existing 32 bit
> libraries that must be used, e.g. for compression, encryption,
> deduplication, ...
> 
> Currently this only works with manual changes in userspace include
> file target_core_user.h due to a missing padding field in
> struct tcmu_cmd_entry.
> 
> Here are field offsets printed by a small program on a 64 bit host,
> compiled as 64 bit program and as 32 bit:
> 
> Devel:~ # gcc -o print_offsets print_offsets.c
> Devel:~ # ./print_offsets
> Offset of tcmu_cmd_entry.hdr.len_op          = 0000
> Offset of tcmu_cmd_entry.hdr.cmd_id          = 0004
> Offset of tcmu_cmd_entry.hdr.kflags          = 0006
> Offset of tcmu_cmd_entry.hdr.uflags          = 0007
> 
> Offset of tcmu_cmd_entry.req.iov_cnt         = 0008
> Offset of tcmu_cmd_entry.req.iov_bidi_cnt    = 000c
> Offset of tcmu_cmd_entry.req.iov_dif_cnt     = 0010
> Offset of tcmu_cmd_entry.req.cdb_off         = 0018
> Offset of tcmu_cmd_entry.req.iov[0]          = 0030
> 
> Offset of tcmu_cmd_entry.rsp.scsi_status     = 0008
> Offset of tcmu_cmd_entry.rsp.read_len        = 000c
> Offset of tcmu_cmd_entry.rsp.sense_buffer[0] = 0010
> 
> Size of struct tcmu_cmd_entry = 0070
> 
> 
> Devel:~ # gcc -m32 -o print_offsets print_offsets.c
> Devel:~ # ./print_offsets
> Offset of tcmu_cmd_entry.hdr.len_op          = 0000
> Offset of tcmu_cmd_entry.hdr.cmd_id          = 0004
> Offset of tcmu_cmd_entry.hdr.kflags          = 0006
> Offset of tcmu_cmd_entry.hdr.uflags          = 0007
> 
> Offset of tcmu_cmd_entry.req.iov_cnt         = 0008
> Offset of tcmu_cmd_entry.req.iov_bidi_cnt    = 000c
> Offset of tcmu_cmd_entry.req.iov_dif_cnt     = 0010
> Offset of tcmu_cmd_entry.req.cdb_off         = 0014
> Offset of tcmu_cmd_entry.req.iov[0]          = 002c
> 
> Offset of tcmu_cmd_entry.rsp.scsi_status     = 0008
> Offset of tcmu_cmd_entry.rsp.read_len        = 000c
> Offset of tcmu_cmd_entry.rsp.sense_buffer[0] = 0010
> 
> Size of struct tcmu_cmd_entry = 0070
> 
> 
> The offset of the fields req.cdb_off and req.iov differ for 64-bit
> and 32-bit compilation.
> 
> That means:
>  - 64-bit application on 64-bit host works well
>  - 32-bit application on 32-bit host works well
>  - 32-bit application on 64-bit host fails.
> 
> Unfortunately I don't see a way to fix this problem such, that
> 32-bit application runs fine on 32-bit and 64-bit host without
> breaking compatibility.
> 
> So I'm wondering whether the following change would be a viable
> solution:
> 
> diff --git a/include/uapi/linux/target_core_user.h
> b/include/uapi/linux/target_core_user.h
> --- a/include/uapi/linux/target_core_user.h
> +++ b/include/uapi/linux/target_core_user.h
> @@ -114,6 +114,9 @@ struct tcmu_cmd_entry {
>  			__u32 iov_cnt;
>  			__u32 iov_bidi_cnt;
>  			__u32 iov_dif_cnt;
> +#ifdef APPL32BIT_ON_KERNEL64BIT
> +			__u32 __pad9;
> +#endif
>  			__u64 cdb_off;
>  			__u64 __pad1;
>  			__u64 __pad2;
> 
> 
> Using this change we can do:
> 
> Devel:~ # gcc -m32 -DAPPL32BIT_ON_KERNEL64BIT -o print_offsets
> print_offsets.c
> Devel:~ # ./print_offsets
> Offset of tcmu_cmd_entry.hdr.len_op          = 0000
> Offset of tcmu_cmd_entry.hdr.cmd_id          = 0004
> Offset of tcmu_cmd_entry.hdr.kflags          = 0006
> Offset of tcmu_cmd_entry.hdr.uflags          = 0007
> 
> Offset of tcmu_cmd_entry.req.iov_cnt         = 0008
> Offset of tcmu_cmd_entry.req.iov_bidi_cnt    = 000c
> Offset of tcmu_cmd_entry.req.iov_dif_cnt     = 0010
> Offset of tcmu_cmd_entry.req.cdb_off         = 0018
> Offset of tcmu_cmd_entry.req.iov[0]          = 0030
> 
> Offset of tcmu_cmd_entry.rsp.scsi_status     = 0008
> Offset of tcmu_cmd_entry.rsp.read_len        = 000c
> Offset of tcmu_cmd_entry.rsp.sense_buffer[0] = 0010
> 
> Size of struct tcmu_cmd_entry = 0070
> 
> 
> So we can compile a 32-bit application that works on 64-bit kernel
> without need to manipulate the include file prepared by the kernel.
> 
> What do you think? Do you know a better solution?

Can you not use something similar to the compat_ioctl mechanism?  the
job of the compat layer is to re-layout the input and output structures
to impedance match between 32 and 64 bit.

James
