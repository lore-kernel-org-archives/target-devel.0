From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Thu, 18 Jan 2018 08:41:33 +0000
Subject: Re: iscsi target regression due to "tcp: remove prequeue support" patch
Message-Id: <1516264893.24576.243.camel@haakon3.daterainc.com>
List-Id: <target-devel.vger.kernel.org>
References: <5A32128D.4050207@redhat.com>
         <1515479541.5327.70.camel@haakon3.daterainc.com>
         <1515998504.24576.187.camel@haakon3.daterainc.com>
         <5A5D1012.9000303@redhat.com>
In-Reply-To: <5A5D1012.9000303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <mchristi@redhat.com>
Cc: target-devel <target-devel@vger.kernel.org>, fw@strlen.de, Linux-netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>

On Mon, 2018-01-15 at 14:33 -0600, Mike Christie wrote:
> On 01/15/2018 12:41 AM, Nicholas A. Bellinger wrote:
> > Hey MNC & Co,
> > 
> > Ping on the earlier iscsi-target authentication login failures atop
> > 4.14 + commit e7942d063 removing tcp prequeue support.
> > 
> > For reference, what is your pre 4.14 environment using for
> > sysctl_tcp_low_latency..?
> 
> tcp_low_latency=1.
> 
> I have tested the current kernel with 1 and 0, and it does not make a
> difference.
> 

Likewise, I've always used tcp_low_latency=1 on pre 4.14.y kernels and
never triggered this bug with multi login PDU exchanges.

What's strange from groking commit e7942d0 though, it appear the removal
of tcp prequeue logic should only effect tcp_low_latency=0 users,
right..?

But here, that doesn't seem to be the case..

