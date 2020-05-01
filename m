From: Mike Christie <mchristi@redhat.com>
Date: Fri, 01 May 2020 20:56:28 +0000
Subject: Re: [PATCH 0/4] target: tcmu: allow flexible pr and alua handling
Message-Id: <a82906f3-c671-22fd-7722-1df5eb02b1f8@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200427150823.15350-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200427150823.15350-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: ddiss@suse.de, hch@lst.de, martin.petersen@oracle.com

On 4/27/20 10:08 AM, Bodo Stroesser wrote:
> These patches already were sent to target-devel only. So I'm resending
> them now, slightly modified according to review comments from
> target-devel.
> 
> The goal of the patches is to add more flexibility to tcmu regarding
> PGR handling.
> 
> Since the attribute emulate_pr is missing for pscsi in the same way as
> for tcmu, I'm adding it to pscsi also. 
>

It looks ok to me.

Reviewed-by: Mike Christie <mchristi@redhat.com>
