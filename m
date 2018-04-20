From: Pascal de Bruijn <p.debruijn@unilogic.nl>
Date: Fri, 20 Apr 2018 14:56:32 +0000
Subject: target_qf_do_work trace
Message-Id: <bb242c4e-952c-a273-e8a3-ec7cf07859af@unilogic.nl>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hey,

On one of our storage servers we are seeing the following in dmesg:

[60660.103031] Detected MISCOMPARE for addr: ffff8bbe94e97000 buf: 
ffff8bb634e7f000
[60660.103032] Target/iblock: Send MISCOMPARE check condition and sense
[60672.974043] Bit_5 already set for cmd = ffff8bb637390500.
[60672.974101] CPU: 5 PID: 9350 Comm: kworker/5:33 Not tainted 4.9.74-ul6 #3
[60672.974102] Hardware name: Supermicro SYS-1028U-E1CR4+/X10DRU-i+, 
BIOS 2.0b 08/09/2016
[60672.974131] Workqueue: events target_qf_do_work [target_core_mod]
[60672.974133]  ffff919f27927db8 ffffffffb545e2c8 ffff8bb637390500 
ffff8bb638c52058
[60672.974134]  ffff919f27927dd0 ffffffffc023fd33 ffff8bb637390500 
ffff919f27927e18
[60672.974136]  ffffffffc01edd71 ffff8bb637581c60 ffff8bb637581c60 
447928903e4045d9
[60672.974137] Call Trace:
[60672.974141]  [<ffffffffb545e2c8>] dump_stack+0x4d/0x65
[60672.974144]  [<ffffffffc023fd33>] tcm_qla2xxx_queue_status+0xc3/0xd0 
[tcm_qla2xxx]
[60672.974147]  [<ffffffffc01edd71>] target_qf_do_work+0x141/0x1a0 
[target_core_mod]
[60672.974151]  [<ffffffffb5294371>] process_one_work+0x121/0x3c0
[60672.974152]  [<ffffffffb5294653>] worker_thread+0x43/0x4e0
[60672.974153]  [<ffffffffb5294610>] ? process_one_work+0x3c0/0x3c0
[60672.974155]  [<ffffffffb5294610>] ? process_one_work+0x3c0/0x3c0
[60672.974156]  [<ffffffffb529a0f4>] kthread+0xd4/0xf0
[60672.974157]  [<ffffffffb529a020>] ? kthread_worker_fn+0x100/0x100
[60672.974160]  [<ffffffffb569e9e2>] ret_from_fork+0x22/0x30

It's currently running a 4.9.74 kernel from kernel.org, with the 
following patches that might be relevant (all cherrypicked from 4.9.y tree):

linux-4.9.77-target-core-60c7a9cd5050378a7bfe385dc5feef9d406f22e1.patch
linux-4.9.77-target-iscsi-748e1b6281f5128c5ef8f9296761a232558c20d8.patch
linux-4.9.88-qla2xxx-05d42c517250653f53e296e3d59d0b0db1a87296.patch
linux-4.9.88-qla2xxx-8f16e7d01b5f4f149d3cd7d5bf38a3e53792acf6.patch
linux-4.9.89-qla2xxx-9f4a71db144905a41c795e5a67236e36cb20bb16.patch
linux-4.9.83-target-iscsi-fffc0fcaebebefd06b07838e4aad5ef5f30803fd.patch
linux-4.9.90-target-f29bc9dc0bef0cb6f3ca069d96fbd535439d1680.patch

Currently the machine in question doesn't seem to be obviously 
negatively affected by that trace.

Still we'd love to get your insight on what might be causing that trace 
to happen. And if there's anything can be done to resolve it.

If you need more information from our end, please do ask.

Regards,
Pascal de Bruijn
Unilogic B.V.

