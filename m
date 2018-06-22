From: Mike Christie <mchristi@redhat.com>
Date: Fri, 22 Jun 2018 04:06:24 +0000
Subject: Re: [PATCH 3/3] tcmu: add module wide block/reset_netlink support
Message-Id: <5B2C75C0.5000100@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1529639560-9429-4-git-send-email-mchristi@redhat.com>
In-Reply-To: <1529639560-9429-4-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 06/21/2018 10:52 PM, Mike Christie wrote:
> +static int tcmu_set_block_netlink(const char *str,
> +				  const struct kernel_param *kp)
> +{
> +	int ret;
> +	u8 val;
> +
> +	ret = kstrtou8(str, 0, &val);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (val > 1 || val < 0) {

Darn. I meant to send a different version of the patch where it did

if (val != 1) {

since its a unsigned value.

I will resend this patch after you guys review it.
