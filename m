From: Mike Christie <mchristi@redhat.com>
Date: Wed, 03 Jan 2018 18:33:32 +0000
Subject: Re: [RFC PATCH] target: enable discard if supported by underlying block device
Message-Id: <5A4D21FC.2060101@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20171219134517.17296-1-ddiss@suse.de>
In-Reply-To: <20171219134517.17296-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 12/19/2017 07:45 AM, David Disseldorp wrote:
> The initial commit of LIO (v4.0.0-rc6) came with support for SCSI UNMAP
> disabled. This was justified in the LIO wiki with:
>   Many SATA SSDs have issues handling UNMAP properly, so it is disabled
>   per default in LIO.
> Since this time, some critical discard bugs have been fixed, e.g.
> f3f5da624e0a ("block: Do a full clone when splitting discard bios").
> 
> Block layer backed logical units are capable of deferring to the block
> layer when determining UNMAP attributes, but this logic currently leaves
> the emulate_tpu (UNMAP) and emulate_tpws (WRITE_SAME with UNMAP=1) flags
> disabled.

Is there any cases where the user set tpu/tpws to off on purpose to
work around a backing device or initiator side issue? If so, I think the
only concern would be for non-rtslib based apps. If they did the attrib
setting stage after device creation but before the config stage, then
this patch would overwrite those settings.

For rtslib based apps, if the user had set tpu/tpws values to off on
purpose, it looks like the user requested values will still be used
since the attrib setting stage is done after the configure.

If we do not support non rtslib based apps then the patch is nice for
users and looks ok.

Reviewed-by: Mike Christie <mchristi@redhat.com>
