From: Mike Christie <mchristi@redhat.com>
Date: Thu, 19 Jul 2018 00:22:00 +0000
Subject: Re: [PATCH 12/15] target: add callout to test a session
Message-Id: <5B4FD9A8.7000807@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-13-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-13-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 07/18/2018 05:46 PM, Bart Van Assche wrote:
> On Sun, 2018-07-15 at 18:16 -0500, Mike Christie wrote:
>> +       int (*test_session)(struct se_session *, u8 timeout);
> 
> Does any of the patches in this series define a test_session callback
> function?

Patch 14 does.

> 
> What is the unit of the timeout parameter? 1/HZ, ms or s?
> 

It is seconds.

I will add comments to document the callout requirements and arguments.

> Thanks,
> 
> Bart.
> 

