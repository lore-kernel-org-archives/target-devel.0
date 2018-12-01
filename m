From: Hannes Reinecke <hare@suse.com>
Date: Sat, 01 Dec 2018 14:56:19 +0000
Subject: Re: [PATCH v5 3/5] target: add device vendor_id configfs attribute
Message-Id: <52ec073a-5992-0c02-6a59-f3334aa33602@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 12/1/18 12:34 AM, David Disseldorp wrote:
> The vendor_id attribute will allow for the modification of the T10
> Vendor Identification string returned in inquiry responses. Its value
> can be viewed and modified via the ConfigFS path at:
> target/core/$backstore/$name/wwn/vendor_id
> 
> "LIO-ORG" remains the default value, which is set when the backstore
> device is enabled.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> Reviewed-by: Bryant G. Ly <bly@catalogicsoftware.com>
> Reviewed-by: Lee Duncan <lduncan@suse.com>
> ---
>   drivers/target/target_core_configfs.c | 48 +++++++++++++++++++++++++++++++++++
>   1 file changed, 48 insertions(+)
> 
I have been wanting to do this for a long time now ...

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
