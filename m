From: David Disseldorp <ddiss@suse.de>
Date: Thu, 25 Oct 2018 22:04:20 +0000
Subject: Re: BUG in use-after-free iSCSI dataout timeout
Message-Id: <20181026000420.7bf4f496@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <13ab4e80-8435-ca17-5a1c-b06ef2c8fd25@huawei.com>
In-Reply-To: <13ab4e80-8435-ca17-5a1c-b06ef2c8fd25@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi,

On Thu, 25 Oct 2018 10:03:00 +0800, zhengliang wrote:

> Thank you very much for your help.
> I need a few days to test this patch.
> I will feedback the test results to you later.

With which kernel version are you able to trigger the use-after-free?
I've been trying to reproduce it from a hack r2t-dropping-initiator[1]
which drops the connection at around the same time as the dataout timeout
but am yet to hit this with mainline.

Cheers, David

1. https://github.com/ddiss/libiscsi/tree/hack-lio-trigger-dataout-timeout-v2
