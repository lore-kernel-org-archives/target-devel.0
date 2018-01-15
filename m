From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Date: Mon, 15 Jan 2018 16:57:47 +0000
Subject: Re: A qla2xxx commit cause Linux no response, has not fixed in lastest version 4.15-rc6
Message-Id: <74BFA730-FDBB-4912-B4E3-734A84C6A63A@cavium.com>
List-Id: <target-devel.vger.kernel.org>
References: <BC29A004BA570342A4CC0044A3845572010DCF3E30@H3CMLB12-EX.srv.huawei-3com.com>
 <1515821296.24576.94.camel@haakon3.daterainc.com>
In-Reply-To: <1515821296.24576.94.camel@haakon3.daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Changlimin <changlimin@h3c.com>, "Tran, Quinn" <Quinn.Tran@cavium.com>, Jifuliang <fuliang_ji@h3c.com>, Zhangguanghui <zhang.guanghui@h3c.com>, Zhangzijian <zhang.zijian@h3c.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Hi Nic, Chang,

> On Jan 12, 2018, at 9:28 PM, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> 
> Hi Chang & Co,
> 
> (Adding list + Himanshu CC')
> 
> On Sun, 2018-01-07 at 10:21 +0000, Changlimin wrote:
>> Hi,
>> It seems the qla2xxx commit cause Linux no response, has not fixed in lastest version 4.15-rc6.
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/commit/?id=726b85487067d7f5b23495bc33c484b8517c4074 
>> 
> 
> Thanks for reporting + including debug log.  :)
> 
>> lspci:
>> 0a:00.0 Fibre Channel: QLogic Corp. ISP2532-based 8Gb Fibre Channel to PCI Express HBA (rev 02)
>> 0a:00.1 Fibre Channel: QLogic Corp. ISP2532-based 8Gb Fibre Channel to PCI Express HBA (rev 02)
>> 
>> syslog:
>> qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.07.00.38-k.
>> qla2xxx [0000:0a:00.0]-001a: : MSI-X vector count: 32.
>> qla2xxx [0000:0a:00.0]-001d: : Found an ISP2532 irq 16 iobase 0xffffb0d5cc501000.
>> qla2xxx [0000:0a:00.0]-00c6:1: MSI-X: Failed to enable support with 32 vectors, using 26 vectors.
>> scsi host1: qla2xxx
>> qla2xxx [0000:0a:00.0]-00fb:1: QLogic HPAJ764A - HP 8Gb Dual Channel PCI-e 2.0 FC HBA.
>> qla2xxx [0000:0a:00.0]-00fc:1: ISP2532: PCIe (5.0GT/s x8) @ 0000:0a:00.0 hdma+ host#=1 fw=8.03.00 (90d5).
>> qla2xxx [0000:0a:00.1]-001a: : MSI-X vector count: 32.
>> qla2xxx [0000:0a:00.1]-001d: : Found an ISP2532 irq 17 iobase 0xffffb0d5cc5d9000.
>> qla2xxx [0000:0a:00.1]-00c6:2: MSI-X: Failed to enable support with 32 vectors, using 26 vectors.
>> scsi host2: qla2xxx
>> qla2xxx [0000:0a:00.1]-00fb:2: QLogic HPAJ764A - HP 8Gb Dual Channel PCI-e 2.0 FC HBA.
>> qla2xxx [0000:0a:00.1]-00fc:2: ISP2532: PCIe (5.0GT/s x8) @ 0000:0a:00.1 hdma+ host#=2 fw=8.03.00 (90d5).
>> qla2xxx [0000:0a:00.0]-500a:1: LOOP UP detected (8 Gbps).
>> qla2xxx [0000:0a:00.1]-500a:2: LOOP UP detected (8 Gbps).
>> 
>> The attached file is the module log.
>> 
>> Do you have any advice?
> 
> Quinn & Himanshu folks, any comments..?
> 

What is the issue here? I am not clear form the snippet above.

One thing I noticed that, if you are using 4.15-rc6 driver version should be 10.00.00.02-k but the snippet shows 
8.07.00.38-k which tells me you might 

Thanks,
- Himanshu