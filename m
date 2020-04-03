From: Michael Christie <mchristi@redhat.com>
Date: Fri, 03 Apr 2020 17:19:15 +0000
Subject: Re: [PATCH 2/2] target: make pgr_support and alua_support attributes writable
Message-Id: <ca4ab505-22f7-c46c-cbdf-7e00c5f59d0c@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200403143214.18303-3-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200403143214.18303-3-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 04/03/2020 09:32 AM, Bodo Stroesser wrote:
>  /*
>   * dev_attrib attributes for devices using the target core SBC/SPC
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index 4e37fa9b409d..e7d92ef43ca4 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -1073,6 +1073,7 @@ static const struct target_backend_ops pscsi_ops = {
>  	.transport_flags_default = TRANSPORT_FLAG_PASSTHROUGH |
>  				   TRANSPORT_FLAG_PASSTHROUGH_ALUA |
>  				   TRANSPORT_FLAG_PASSTHROUGH_PGR,
> +	.transport_flags_changeable = TRANSPORT_FLAG_PASSTHROUGH_PGR,
>  	.attach_hba		= pscsi_attach_hba,
>  	.detach_hba		= pscsi_detach_hba,
>  	.pmode_enable_hba	= pscsi_pmode_enable_hba,

Do we need more code to support this?

For example, if LIO core is now handling PRs then it uses the I_T nexus
info from LIO core for registrations if its not provided in the PR
command. But port/target INQUIRY info would be from the struct
scsi_device that pscsi is using since we pass INQUIRY down to that
device. We will end up with mismatches where a PR-in READ_FULL_STATUS
would return different results than the INQUIRY.
