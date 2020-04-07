From: Andreas Kinzler <hfp@posteo.de>
Date: Tue, 07 Apr 2020 10:29:36 +0000
Subject: Re: strange dm-crypt problem with qemu / LIO / vhost
Message-Id: <3660ac9e-92d4-3752-2c7d-d984f3e681a8@posteo.de>
List-Id: <target-devel.vger.kernel.org>
References: <5e29cc94-a21d-2506-9bac-48d8d29ab85b@posteo.de>
In-Reply-To: <5e29cc94-a21d-2506-9bac-48d8d29ab85b@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hello David,

>> In the meantime, I was able to debug further. Actually in Windows only
>> the "format disk" operation fails. If you do that otherwise and later
>> use the formatted disk, it seems to work. So I assume it is a special
>> SCSI opcode that is only used during "format disk" that fails.
> You could print the SCSI opcode value with something like:

Thanks for the help. I was able to find the root cause. To avoid 
duplication with the issue tracker of the kvm-guest drivers, here is the 
link to my findings:

https://github.com/virtio-win/kvm-guest-drivers-windows/issues/446

Please feel free to add more comments to remaining open questions there.
Especially about the question of alignment in BIOs.

Regards Andreas
