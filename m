From: "Ly, Bryant" <bly@catalogicsoftware.com>
Date: Thu, 29 Nov 2018 01:14:51 +0000
Subject: Re: [PATCH v4 5/7] target: add device vendor_id configfs attribute
Message-Id: <2AC2A699-A0FF-4174-AADD-FE1094678278@catalogicsoftware.com>
List-Id: <target-devel.vger.kernel.org>
References: <20181129010157.12687-6-ddiss@suse.de>
In-Reply-To: <20181129010157.12687-6-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org



> On Nov 28, 2018, at 7:01 PM, David Disseldorp <ddiss@suse.de> wrote:
> 
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
> drivers/target/target_core_configfs.c | 48 +++++++++++++++++++++++++++++++++++
> 1 file changed, 48 insertions(+)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index 9f49b1afd685..fc60c4db718d 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -1213,6 +1213,52 @@ static struct t10_wwn *to_t10_wwn(struct config_item *item)
> }
> 

Thanks for making it configurable. I know back when I was at IBM we made changes internally
to support LIO-ORG.

Reviewed-by: Bryant G. Ly bly@catalogicsoftware.com
