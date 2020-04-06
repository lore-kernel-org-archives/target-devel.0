From: Andreas Kinzler <hfp@posteo.de>
Date: Mon, 06 Apr 2020 18:21:55 +0000
Subject: strange dm-crypt problem with qemu / LIO / vhost
Message-Id: <5e29cc94-a21d-2506-9bac-48d8d29ab85b@posteo.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

I am trying to use a /dev/mapper/luks (via cryptsetup/LUKS) on a 
backstorage/iblock from the target/SCSI framework and pass that through 
vhost (tcm_vhost) to qemu guests. It works with Linux guests but with 
Windows guests (using the virtio-scsi pv-driver) I get tons of errors in 
dmesg:

[ 3683.403467] bio error: 00000000f33a8dcd,  err: 10
[ 3683.403612] bio error: 00000000a508ea6b,  err: 10
[ 3683.414686] bio error: 00000000f06baf1d,  err: 10
[ 3683.414767] bio error: 0000000035714712,  err: 10
[ 3683.414829] bio error: 0000000062dd8892,  err: 10
[ 3683.414883] bio error: 000000005c303a2d,  err: 10
[ 3683.414936] bio error: 0000000024d02dea,  err: 10

This is from target_core_iblock.c function "iblock_bio_done".

Any ideas? Hints?

Regards Andreas
