From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 28 Apr 2020 16:29:59 +0000
Subject: Re: [PATCH 07/11] target: add sysfs support
Message-Id: <a79c2243-f4ee-4138-abd5-d9df70761bf0@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200428061109.3042-1-mchristi@redhat.com>
 <20200428061109.3042-8-mchristi@redhat.com>
In-Reply-To: <20200428061109.3042-8-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <mchristi@redhat.com>, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 2020-04-27 23:11, Mike Christie wrote:
> @@ -3536,6 +3551,15 @@ static int __init target_core_init_configfs(void)
>  
>  	target_init_dbroot();
>  
> +	tcm_core_kobj = kobject_create_and_add("scsi_target", NULL);
> +	if (!tcm_core_kobj)
> +		goto out;

Is an ack from Greg KH required when adding a new directory under
/sys/kernel?

Should a file be added under Documentation/ABI/stable that documents the
new sysfs attributes?

Otherwise this patch looks fine to me.

Thanks,

Bart.
