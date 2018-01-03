From: David Disseldorp <ddiss@suse.de>
Date: Wed, 03 Jan 2018 22:27:31 +0000
Subject: Re: [RFC PATCH] target: enable discard if supported by underlying block device
Message-Id: <20180103232731.254acc4e@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20171219134517.17296-1-ddiss@suse.de>
In-Reply-To: <20171219134517.17296-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Thanks for the feedback, Mike.

On Wed, 3 Jan 2018 12:33:32 -0600, Mike Christie wrote:

> > Block layer backed logical units are capable of deferring to the block
> > layer when determining UNMAP attributes, but this logic currently leaves
> > the emulate_tpu (UNMAP) and emulate_tpws (WRITE_SAME with UNMAP=1) flags
> > disabled.  
> 
> Is there any cases where the user set tpu/tpws to off on purpose to
> work around a backing device or initiator side issue? If so, I think the
> only concern would be for non-rtslib based apps. If they did the attrib
> setting stage after device creation but before the config stage, then
> this patch would overwrite those settings.

I'm not aware of any such cases, but yes, good point. If this is a
concern, then another option would be to change the DA_EMULATE_TPU/TPWS
defaults unconditionally (for all backstores), but I that'd lead to
other consequences (e.g. on FSes that don't support PUNCH_HOLE).

> For rtslib based apps, if the user had set tpu/tpws values to off on
> purpose, it looks like the user requested values will still be used
> since the attrib setting stage is done after the configure.
> 
> If we do not support non rtslib based apps then the patch is nice for
> users and looks ok.

FWIW, I frequently use LIO via configfs directly (without rtslib), so
would like to ensure continued compatibility.

> Reviewed-by: Mike Christie <mchristi@redhat.com>

Cheers, David
