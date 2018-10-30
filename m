From: Mike Christie <mchristi@redhat.com>
Date: Tue, 30 Oct 2018 15:54:07 +0000
Subject: Re: [RFC PATCH 0/3] target: remove some unused stats
Message-Id: <5BD87E9F.5080208@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20181017154820.9722-1-ddiss@suse.de>
In-Reply-To: <20181017154820.9722-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 10/29/2018 06:00 PM, David Disseldorp wrote:
> On Wed, 17 Oct 2018 17:48:17 +0200, David Disseldorp wrote:
> 
>> This patchset removes a couple of unused error stat counters and a
>> redundant cumulative counter.
>> I've tagged this patchset RFC, as it may be considered a kernel<->user
>> (configfs) API change.
> 
> Ping, any thoughts on this patchset?
> 

I think these stats were supposed to match the iSCSI MIB definitions. It
was not clear why we didn't just fix them so they report the correct values?
