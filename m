From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 08 Jun 2020 12:18:38 +0000
Subject: Re: [PATCH 11/17] target: add session sysfs class support
Message-Id: <20200608121838.GC306451@kroah.com>
List-Id: <target-devel.vger.kernel.org>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-12-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1591562164-9766-12-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <michael.christie@oracle.com>
Cc: bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Sun, Jun 07, 2020 at 03:35:58PM -0500, Mike Christie wrote:
> +#define target_attr_str(field)		\
> +	target_attr_show(field)		\
> +static DEVICE_ATTR(field, S_IRUGO, show_target_##field, NULL)

DEVICE_ATTR_RO()

> +#define tpt_id_attr(name, fmt_str)		\
> +	tpt_id_attr_show(name, fmt_str)		\
> +static DEVICE_ATTR(name, S_IRUGO, show_tpid_##name, NULL)

DEVICE_ATTR_RO()
