From: Hannes Reinecke <hare@suse.com>
Date: Sat, 01 Dec 2018 14:57:01 +0000
Subject: Re: [PATCH v5 4/5] target: remove hardcoded T10 Vendor ID in INQUIRY response
Message-Id: <440a09f4-9b2d-61f2-3dd1-91d06b98840a@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 12/1/18 12:34 AM, David Disseldorp wrote:
> Use the value stored in t10_wwn.vendor, which defaults to "LIO-ORG", but
> can be reconfigured via the vendor_id ConfigFS attribute.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> Reviewed-by: Bryant G. Ly <bly@catalogicsoftware.com>
> Reviewed-by: Lee Duncan <lduncan@suse.com>
> ---
>   drivers/target/target_core_spc.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
I would have merged it with the previous patch, but anyway:

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
