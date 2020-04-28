From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 28 Apr 2020 16:43:38 +0000
Subject: Re: [PATCH 08/11] target: add sysfs session helper functions
Message-Id: <1c97ee38-7a0e-5aac-6065-41267baea648@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200428061109.3042-1-mchristi@redhat.com>
 <20200428061109.3042-9-mchristi@redhat.com>
In-Reply-To: <20200428061109.3042-9-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <mchristi@redhat.com>, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 2020-04-27 23:11, Mike Christie wrote:
> +	ret = kobject_add(&se_sess->kobj, se_tpg->sessions_kobj, "session-%d",
> +			  se_sess->sid);
> +	if (ret) {
> +		pr_err("Could not add session%d to sysfs. Error %d.\n",
> +		       se_sess->sid, ret);
> +		goto free_acl_name;
> +	}

Has it been considered to derive the directory name for a session from
the initiator name (se_node_acl.initiatorname-%d)? Would that be more
convenient for users than the session-%d naming scheme?

Thanks,

Bart.
