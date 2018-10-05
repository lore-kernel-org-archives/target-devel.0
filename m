From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 05 Oct 2018 13:52:12 +0000
Subject: Re: [PATCH 06/17] target/core: Use sg_alloc_table() instead of open-coding it
Message-Id: <23d5022f-563f-f1ca-e2e9-a335710f918d@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20180917213554.987-7-bvanassche@acm.org>
In-Reply-To: <20180917213554.987-7-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 10/5/18 12:46 AM, Christoph Hellwig wrote:
> On Mon, Sep 17, 2018 at 02:35:43PM -0700, Bart Van Assche wrote:
>> The purpose of sg_alloc_table() is to allocate and initialize an
>> sg-list. Use that function instead of open-coding it.
> 
> Hmm.  This looks correct, but what is the point if we don't plan
> on using chained sg-lists?

This patch makes it easier to replace the SCSI target sg-list allocation 
code by (library) code that caches sg-list allocations. I still hope to 
find some time to work on this.

Since the rest of this series does not depend on this patch, I can leave 
it out if you want.

Bart.
