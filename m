From: Bart Van Assche <Bart.VanAssche@wdc.com>
Date: Sat, 11 Aug 2018 22:50:12 +0000
Subject: Re: BUG in slab_free after iSCSI login timeout
Message-Id: <7bc6b412fd108a77ddf4a4cd7252ddc0eaa4b2d4.camel@wdc.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180811093655.42922d8e@gmail.com>
In-Reply-To: <20180811093655.42922d8e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sat, 2018-08-11 at 09:36 +-0000, Vincent Pelletier wrote:
+AD4- What can I try to help debug this further ?

Can you try to reproduce this with KASAN enabled in the kernel config?

Thanks,

Bart.
