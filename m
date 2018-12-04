From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Tue, 04 Dec 2018 12:23:04 +0000
Subject: Re: [PATCH v6 4/5] target: remove hardcoded T10 Vendor ID in INQUIRY response
Message-Id: <20181204122304.6vw6ifhmx5wmx6re@SPB-NB-133.local>
List-Id: <target-devel.vger.kernel.org>
References: <20181204101238.20587-5-ddiss@suse.de>
In-Reply-To: <20181204101238.20587-5-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Tue, Dec 04, 2018 at 11:12:37AM +0100, David Disseldorp wrote:
> Use the value stored in t10_wwn.vendor, which defaults to "LIO-ORG", but
> can be reconfigured via the vendor_id ConfigFS attribute.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> Reviewed-by: Bryant G. Ly <bly@catalogicsoftware.com>
> Reviewed-by: Lee Duncan <lduncan@suse.com>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/target/target_core_spc.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

Thank you,
Roman
