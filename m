From: Mike Christie <michael.christie@oracle.com>
Date: Sat, 27 Jun 2020 04:45:54 +0000
Subject: Re: [RFC PATCH 09/10] target: add helper to close session synchronously
Message-Id: <89747f03-3bbf-a210-bf7d-4c487d80f285@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
 <1593232509-13720-10-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1593232509-13720-10-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hare@suse.de, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 6/26/20 11:35 PM, Mike Christie wrote:
> +	if (!se_sess->tfo->close_session) {
> +		pr_err("Session %d does not support configfs session removal.",
> +		       se_sess->sid);
> +		return -EINVAL;
> +	}

I just realized I posted a slightly older version of the patch I meant 
to post. The locking issue above will be fixed in the final version.
