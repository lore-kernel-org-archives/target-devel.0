From: Greg Edwards <gedwards@ddn.com>
Date: Tue, 21 Aug 2018 22:13:57 +0000
Subject: Re: [PATCH] target/iblock: split T10 PI SGL across command bios
Message-Id: <20180821221357.GA32452@psuche>
List-Id: <target-devel.vger.kernel.org>
References: <20180808193140.1463-1-gedwards@ddn.com>
In-Reply-To: <20180808193140.1463-1-gedwards@ddn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Tue, Aug 21, 2018 at 04:07:08PM -0500, Mike Christie wrote:
> On 08/08/2018 02:31 PM, Greg Edwards wrote:
>> When T10 PI is enabled on a backing device for the iblock backstore, the
>> PI SGL for the entire command is attached to the first bio only.  This
>> works fine if the command is covered by a single bio, but results in
>> integrity verification errors for the other bios in a multi-bio command.
>>
>
> Did you hit this with a older distro kernel?
>
> It looks like iblock_get_bio will alloc a bio that has enough vecs for
> the entire cmd (bi_max_vecs will equal sgl_nents). So it is not clear to
> me how does the bio_add_page call ever return a value other than
> sg->length, and we end up doing another iblock_get_bio call?

I hit it with the tip of Linus' tree, but it depended on some other
in-flight changes.  Those other changes are now in Linus' tree for 4.19,
with the exception of [1].

Without [1], when doing a large read I/O through vhost + iblock to a T10
PI enabled device (I used scsi_debug), you first hit the vhost
VHOST_SCSI_PREALLOC_PROT_SGLS limitation noted in [1].

Once the limitation on I/O size is no longer gated by
VHOST_SCSI_PREALLOC_PROT_SGLS, the next issue I hit is the one this
patch addresses.  I should have been more precise in my commit message.
The failure is actually a bio_integrity_alloc() failure to allocate the
bip_vec when cmd->t_prot_nents exceeds 256 (BIO_MAX_PAGES), which
results in the following failure on the host:

[   53.780723] Unable to allocate bio_integrity_payload

and the following failure on the client:

[   28.724432] sd 0:0:1:0: [sda] tag#40 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[   28.736127] sd 0:0:1:0: [sda] tag#40 Sense Key : Not Ready [current]
[   28.744567] sd 0:0:1:0: [sda] tag#40 Add. Sense: Logical unit communication failure
[   28.754724] sd 0:0:1:0: [sda] tag#40 CDB: Read(10) 28 20 00 00 00 00 00 38 00 00
[   28.766190] print_req_error: I/O error, dev sda, sector 0

By splitting up the PI SGL across the bios, you avoid ever trying to
allocate a too-large bip_vec (I was testing with 32 MiB I/Os).

Here is how I am testing:

L1 VM:

# modprobe scsi_debug dif=1 dix=1 guard=0 dev_size_mba44
# targetcli <<EOF
/backstores/block create dev=/dev/sda name=scsi_debug
/vhost create wwn=naa.50014055d17a5a87
/vhost/naa.50014055d17a5a87/tpg1/luns/ create /backstores/block/scsi_debug
EOF

L2 VM is booted with QEMU vhost option 't10_pi=on', which depends on
QEMU patches [2]:

	-device vhost-scsi-pci,wwpn=naa.50014055d17a5a87,t10_pi=on \

then in L2 VM:

# cat /sys/block/sda/queue/max_hw_sectors_kb > /sys/block/sda/queue/max_sectors_kb
# dd if=/dev/sda of=/dev/null bs2M iflag=direct count=1

The end goal being to have a vehicle to test large I/Os through
virtio_scsi to a PI enabled device.

Greg

  [1] https://lists.linuxfoundation.org/pipermail/virtualization/2018-August/039040.html
  [2] https://lists.nongnu.org/archive/html/qemu-devel/2018-08/msg01298.html
