From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Sat, 13 Jan 2018 05:13:07 +0000
Subject: Re: [RFC PATCH] target: enable discard if supported by underlying block device
Message-Id: <1515820387.24576.88.camel@haakon3.daterainc.com>
List-Id: <target-devel.vger.kernel.org>
References: <20171219134517.17296-1-ddiss@suse.de>
In-Reply-To: <20171219134517.17296-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi David & MNC,

On Wed, 2018-01-03 at 23:27 +0100, David Disseldorp wrote:
> Thanks for the feedback, Mike.
> 
> On Wed, 3 Jan 2018 12:33:32 -0600, Mike Christie wrote:
> 
> > > Block layer backed logical units are capable of deferring to the block
> > > layer when determining UNMAP attributes, but this logic currently leaves
> > > the emulate_tpu (UNMAP) and emulate_tpws (WRITE_SAME with UNMAP=1) flags
> > > disabled.  
> > 
> > Is there any cases where the user set tpu/tpws to off on purpose to
> > work around a backing device or initiator side issue? If so, I think the
> > only concern would be for non-rtslib based apps. If they did the attrib
> > setting stage after device creation but before the config stage, then
> > this patch would overwrite those settings.
> 
> I'm not aware of any such cases, but yes, good point. If this is a
> concern, then another option would be to change the DA_EMULATE_TPU/TPWS
> defaults unconditionally (for all backstores), but I that'd lead to
> other consequences (e.g. on FSes that don't support PUNCH_HOLE).
> 

I'm reluctant to enable tpu/tpws by default, even when underlying
device claims to support it.  Primarily because of two issues:

First for IBLOCK, blkdev_issue_discard() does synchronous bio
completion.  As-is, this causes iscsi-target RX kthreads to block for
extended periods of time resulting in NOPs triggering connection
reinstatement, et al.

In practice though, out-of-tree bio based backend drivers which actually
enable UNMAP + WRITE_SAME w/ UNMAP=1 always end up adding some
submit_bio() + async completion mechanism for production usage.

Second, even in my experience with async REQ_OP_DISCARD completion using
fast struct block_devices, it's still not very hard for a host (like
ESX/VMFS for example) to run into SCSI timeouts with heavy small block
I/O + UNMAP workloads.

So enabling this by default for all cases still makes me nervous,
without any async REQ_OP_DISCARD completion in place for upstream.

