From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Thu, 06 Dec 2018 12:25:42 +0000
Subject: Re: [PATCH v7 3/5] target: add device vendor_id configfs attribute
Message-Id: <20181206122542.lnphvm2quthxwdhv@SPB-NB-133.local>
List-Id: <target-devel.vger.kernel.org>
References: <20181205121838.23982-4-ddiss@suse.de>
In-Reply-To: <20181205121838.23982-4-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, Dec 05, 2018 at 01:18:36PM +0100, David Disseldorp wrote:
> The vendor_id attribute will allow for the modification of the T10
> Vendor Identification string returned in inquiry responses. Its value
> can be viewed and modified via the ConfigFS path at:
> target/core/$backstore/$name/wwn/vendor_id
> 
> "LIO-ORG" remains the default value, which is set when the backstore
> device is enabled.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  drivers/target/target_core_configfs.c | 70 +++++++++++++++++++++++++++++++++++
>  1 file changed, 70 insertions(+)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index 8277bcf81d6e..f099c2ae451f 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -1217,6 +1217,74 @@ static struct t10_wwn *to_t10_wwn(struct config_item *item)
>  }
>  
>  /*
> + * STANDARD and VPD page 0x80 T10 Vendor Identification

Perhaps you meant 0x83 (Device Identification VPD page, T10 vendor ID
based designator). INQUIRY page 0x80 is Unit Serial Number.

Besides that,
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

Thank you,
Roman
