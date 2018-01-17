From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Date: Wed, 17 Jan 2018 18:26:22 +0000
Subject: Re: A qla2xxx commit cause Linux no response, has not fixed in lastest version 4.15-rc6
Message-Id: <1FB9D106-FC6C-4F93-9DF1-FFDD1F64D961@cavium.com>
List-Id: <target-devel.vger.kernel.org>
References: <BC29A004BA570342A4CC0044A3845572010DCF3E30@H3CMLB12-EX.srv.huawei-3com.com>
 <1515821296.24576.94.camel@haakon3.daterainc.com>
 <74BFA730-FDBB-4912-B4E3-734A84C6A63A@cavium.com>
 <BC29A004BA570342A4CC0044A3845572010DCF828D@H3CMLB12-EX.srv.huawei-3com.com>
 <8E5E47EC-8184-4D07-96D5-9D41E3D4520D@cavium.com>
 <BC29A004BA570342A4CC0044A3845572010DCF8560@H3CMLB12-EX.srv.huawei-3com.com>
In-Reply-To: <BC29A004BA570342A4CC0044A3845572010DCF8560@H3CMLB12-EX.srv.huawei-3com.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Changlimin <changlimin@h3c.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Tran, Quinn" <Quinn.Tran@cavium.com>, Jifuliang <fuliang_ji@h3c.com>, Zhangguanghui <zhang.guanghui@h3c.com>, Zhangzijian <zhang.zijian@h3c.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Hi Chang, 

> On Jan 15, 2018, at 10:49 PM, Changlimin <changlimin@h3c.com> wrote:
> 
> Hi Himanshu,
>   This is my progress.
>   First, I compiled 4.15-rc6, I found linux hang when booting, the stack showed something wrong in qla2xxx driver.

Can you provide me detail steps of how you compiled 4.15-rc6. Also provide me details of how you are loading driver and also provide complete 
log file.

I do not see how you will be able to load driver which is from 4.9.x when you compile fresh 4.15.0-rc6. 

Just FYI, I build test system with 8G/16G/32G adapter with 4.15.0-rc6 kernel and I am not able to see hang that you are describing. 

# uname -r
4.15.0-rc6+

# modprobe qla2xxx

# fcc.sh
FC HBAs:
HBA       Port Name                Port ID   State     Device
host3     21:00:00:24:ff:7e:f5:80  01:0d:00  Online    QLE2742 FW:v8.05.63 DVR:v10.00.00.04-k
host4     21:00:00:24:ff:7e:f5:81  01:0e:00  Online    QLE2742 FW:v8.05.63 DVR:v10.00.00.04-k
host5     21:00:00:0e:1e:12:e9:a0  01:06:00  Online    QLE8362 FW:v8.03.06 DVR:v10.00.00.04-k
host6     21:00:00:0e:1e:12:e9:a1  01:14:00  Online    QLE8362 FW:v8.03.06 DVR:v10.00.00.04-k
host7     21:00:00:24:ff:46:0a:5c  01:0d:00  Online    QLE2562 FW:v8.03.00 DVR:v10.00.00.04-k
host8     21:00:00:24:ff:46:0a:5d  01:15:00  Online    QLE2562 FW:v8.03.00 DVR:v10.00.00.04-k

# modinfo qla2xxx | more

filename:       /lib/modules/4.15.0-rc6+/kernel/drivers/scsi/qla2xxx/qla2xxx.ko
firmware:       ql2500_fw.bin
firmware:       ql2400_fw.bin
firmware:       ql2322_fw.bin
firmware:       ql2300_fw.bin
firmware:       ql2200_fw.bin
firmware:       ql2100_fw.bin
version:        10.00.00.04-k
license:        GPL
description:    QLogic Fibre Channel HBA Driver
author:         QLogic Corporation
srcversion:     6CBCF1372A7756690E83CC3


>   Second, I want to find which commit introduced the issue. So I tried many times via git bisect to linux kernel.
>   Finally, I found the commit 726b85487067d7f5b23495bc33c484b8517c4074 introduced the issue. The attached log is related to this commit.
>   Also ubuntu kernel has this issue: 
>   https://launchpad.net/ubuntu/+archive/primary/+files/linux-image-4.13.0-25-generic_4.13.0-25.29_amd64.deb
>   https://launchpad.net/ubuntu/+archive/primary/+files/linux-image-extra-4.13.0-25-generic_4.13.0-25.29_amd64.deb
> 
> Regards
> Chang Limin
> 
> -----Original Message-----
> From: Madhani, Himanshu [mailto:Himanshu.Madhani@cavium.com] 
> Sent: Tuesday, January 16, 2018 12:59 PM
> To: changlimin (Cloud)
> Cc: Nicholas A. Bellinger; Tran, Quinn; jifuliang (Cloud); zhangguanghui (Cloud); zhangzijian (Cloud); target-devel; linux-scsi
> Subject: Re: A qla2xxx commit cause Linux no response, has not fixed in lastest version 4.15-rc6
> 
> Hi Chang, 
> 
>> On Jan 15, 2018, at 4:27 PM, Changlimin <changlimin@h3c.com> wrote:
>> 
>> Hi Himanshu,
>> The issue is: When insmod the qla2xxx.ko from 4.15-rc6, linux hang.
> 
> From the log file attached. I see that you are trying to load driver from 4.9.x in 4.15.0-rc6. 
> 
> [  279.898704] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.07.00.38-k-debug.
> 
> 4.15.0-rc6 had driver version 10.00.00.02-k. Would you check if you have all the driver changes pulled in with kernel 4.15.0-rc6.
> 
>> I have git bisect the commits. 
>> The issue was introduced in commit: 726b85487067d7f5b23495bc33c484b8517c4074 qla2xxx: Add framework for async fabric discovery.
>> The previous commit is good: 5d964837c6a743193c63c8912f98834c7457ba5c qla2xxx: Track I-T nexus as single fc_port struct .
>> 
>> Regards
>> Chang Limin
>> 
>> -----Original Message-----
>> From: Madhani, Himanshu [mailto:Himanshu.Madhani@cavium.com]
>> Sent: Tuesday, January 16, 2018 12:58 AM
>> To: Nicholas A. Bellinger
>> Cc: changlimin (Cloud); Tran, Quinn; jifuliang (Cloud); zhangguanghui 
>> (Cloud); zhangzijian (Cloud); target-devel; linux-scsi
>> Subject: Re: A qla2xxx commit cause Linux no response, has not fixed 
>> in lastest version 4.15-rc6
>> 
>> Hi Nic, Chang,
>> 
>>> On Jan 12, 2018, at 9:28 PM, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
>>> 
>>> Hi Chang & Co,
>>> 
>>> (Adding list + Himanshu CC')
>>> 
>>> On Sun, 2018-01-07 at 10:21 +0000, Changlimin wrote:
>>>> Hi,
>>>> It seems the qla2xxx commit cause Linux no response, has not fixed in lastest version 4.15-rc6.
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.
>>>> g
>>>> it/commit/?id=726b85487067d7f5b23495bc33c484b8517c4074
>>>> 
>>> 
>>> Thanks for reporting + including debug log.  :)
>>> 
>>>> lspci:
>>>> 0a:00.0 Fibre Channel: QLogic Corp. ISP2532-based 8Gb Fibre Channel 
>>>> to PCI Express HBA (rev 02)
>>>> 0a:00.1 Fibre Channel: QLogic Corp. ISP2532-based 8Gb Fibre Channel 
>>>> to PCI Express HBA (rev 02)
>>>> 
>>>> syslog:
>>>> qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.07.00.38-k.
>>>> qla2xxx [0000:0a:00.0]-001a: : MSI-X vector count: 32.
>>>> qla2xxx [0000:0a:00.0]-001d: : Found an ISP2532 irq 16 iobase 0xffffb0d5cc501000.
>>>> qla2xxx [0000:0a:00.0]-00c6:1: MSI-X: Failed to enable support with 32 vectors, using 26 vectors.
>>>> scsi host1: qla2xxx
>>>> qla2xxx [0000:0a:00.0]-00fb:1: QLogic HPAJ764A - HP 8Gb Dual Channel PCI-e 2.0 FC HBA.
>>>> qla2xxx [0000:0a:00.0]-00fc:1: ISP2532: PCIe (5.0GT/s x8) @ 0000:0a:00.0 hdma+ host#=1 fw=8.03.00 (90d5).
>>>> qla2xxx [0000:0a:00.1]-001a: : MSI-X vector count: 32.
>>>> qla2xxx [0000:0a:00.1]-001d: : Found an ISP2532 irq 17 iobase 0xffffb0d5cc5d9000.
>>>> qla2xxx [0000:0a:00.1]-00c6:2: MSI-X: Failed to enable support with 32 vectors, using 26 vectors.
>>>> scsi host2: qla2xxx
>>>> qla2xxx [0000:0a:00.1]-00fb:2: QLogic HPAJ764A - HP 8Gb Dual Channel PCI-e 2.0 FC HBA.
>>>> qla2xxx [0000:0a:00.1]-00fc:2: ISP2532: PCIe (5.0GT/s x8) @ 0000:0a:00.1 hdma+ host#=2 fw=8.03.00 (90d5).
>>>> qla2xxx [0000:0a:00.0]-500a:1: LOOP UP detected (8 Gbps).
>>>> qla2xxx [0000:0a:00.1]-500a:2: LOOP UP detected (8 Gbps).
>>>> 
>>>> The attached file is the module log.
>>>> 
>>>> Do you have any advice?
>>> 
>>> Quinn & Himanshu folks, any comments..?
>>> 
>> 
>> What is the issue here? I am not clear form the snippet above.
>> 
>> One thing I noticed that, if you are using 4.15-rc6 driver version 
>> should be 10.00.00.02-k but the snippet shows 8.07.00.38-k which tells 
>> me you might
>> 
>> Thanks,
>> - Himanshu
>> <qla2xxx-full.log.gz>
> 
> Thanks,
> - Himanshu
> 

Thanks,
- Himanshu

