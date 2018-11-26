From: Christoph Hellwig <hch@infradead.org>
Date: Mon, 26 Nov 2018 07:40:05 +0000
Subject: Re: [PATCH 3/3] target: replace fabric_ops.name with fabric_alias
Message-Id: <20181126074005.GC9033@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181123173613.4547-4-ddiss@suse.de>
In-Reply-To: <20181123173613.4547-4-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Fri, Nov 23, 2018 at 06:36:13PM +0100, David Disseldorp wrote:
> iscsi_target_mod is the only LIO fabric where fabric_ops.name differs
> from the fabric_ops.fabric_name string.
> fabric_ops.name is used when matching target/$fabric ConfigFS create
> paths, so rename it .fabric_alias and fallback to target/$fabric vs
> .fabric_name comparison if .fabric_alias isn't initialised.
> iscsi_target_mod is the only fabric module to set .fabric_alias . All
> other fabric modules rely on .fabric_name matching and can drop the
> duplicate string.

Looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
