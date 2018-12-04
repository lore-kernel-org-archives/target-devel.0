From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Tue, 04 Dec 2018 13:05:48 +0000
Subject: Re: [PATCH v6 5/5] target: perform t10_wwn ID initialisation in target_alloc_device()
Message-Id: <20181204130548.ejbc6cb2tinu2vdi@SPB-NB-133.local>
List-Id: <target-devel.vger.kernel.org>
References: <20181204101238.20587-6-ddiss@suse.de>
In-Reply-To: <20181204101238.20587-6-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Tue, Dec 04, 2018 at 11:12:38AM +0100, David Disseldorp wrote:
> Initialise the t10_wwn vendor, model and revision defaults when a
> device is allocated instead of when it's enabled. This ensures that
> custom vendor or model strings set prior to enablement are not later
> overwritten with default values.
> 
> The TRANSPORT_FLAG_PASSTHROUGH conditional can be dropped for the
> following reasons:
> - target_core_pscsi overwrites the defaults in the
>   pscsi_configure_device() callback.
>   + the contents is then only used for ConfigFS via
>     $pscsi_dev/info, $pscsi_dev/statistics/scsi_lu/vend, etc.
> - target_core_user doesn't touch the defaults, nor are they used for
>   anything outside of ConfigFS.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  drivers/target/target_core_device.c | 27 ++++++++++-----------------
>  1 file changed, 10 insertions(+), 17 deletions(-)
> 

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

Thanks,
Roman
