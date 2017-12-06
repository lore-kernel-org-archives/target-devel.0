From: Johannes Thumshirn <jthumshirn@suse.de>
Date: Wed, 06 Dec 2017 07:40:02 +0000
Subject: Re: [RFC PATCH] target: detect read-only from underlying iblock device
Message-Id: <mqdmv2we23x.fsf@linux-x5ow.site>
List-Id: <target-devel.vger.kernel.org>
References: <20171205205442.25414-1-ddiss@suse.de>
In-Reply-To: <20171205205442.25414-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

Hi Bart and David,

Bart Van Assche <Bart.VanAssche@wdc.com> writes:
> Although the patch itself looks fine to me: do we really need this kind of
> functionality in the kernel? Is it possible to implement the same functionality
> in user space?

We're having exactly the same discussion in NVMe currently, please see
the following thread:
http://lists.infradead.org/pipermail/linux-nvme/2017-December/014341.html

I tend to agree with David (and Sagi for the NVMe case) in that we
should handle this in the kernel.

Byte,
        Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
