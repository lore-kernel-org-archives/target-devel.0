From: Mike Christie <michael.christie@oracle.com>
Date: Thu, 22 Oct 2020 00:36:51 +0000
Subject: Re: [PATCH v2] scsi: target: tcmu: scatter_/gather_data_area rework
Message-Id: <417c848e-ee17-e600-2c99-c1e4896f5709@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201019115118.11949-1-bostroesser@gmail.com>
In-Reply-To: <20201019115118.11949-1-bostroesser@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bodo Stroesser <bostroesser@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 10/19/20 6:51 AM, Bodo Stroesser wrote:
> This is made on top of the scsi-staging tree plus my previous
> patch:
> "scsi: target: tcmu: add compat mode for 32bit userspace on 64bit kernel"
> 
> ---
> 
> scatter_data_area and gather_data_area are not easy to understand,
> since data is copied in nested loops over sg_list and tcmu dbi
> list. Since sg list can contain only partly filled pages, the loop
> has to be prepared to handle sg pages not matching dbi pages
> 1 by 1.
> 
> Existing implementation uses kmap_atomic()/kunmap_atomic() due to
> performance reasons. But instead of using these calls strictly
> nested for sg and dpi pages, the code holds the mappings in an
> overlapping way, which indeed is a bug that would trigger on archs
> using highmem.
> 
> The scatterlist lib contains the sg_miter_start/_next/_stop
> functions which can be used to simplify such complicated loops.
> 
> The new code now processes the dbi list in the outer loop, while
> sg list is handled by the inner one. That way the code can take
> advantage of the sg_miter_* family calls.
> 
> Calling sg_miter_stop() after the end of the inner loop enforces
> strict nesting of atomic kmaps.
> 
> Since the nested loops in scatter_/gather_data_area were very
> similar, I replaced them by the new helper function
> tcmu_copy_data().
> 
> Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
> 

Acked-by: Mike Christie <michael.christie@oracle.com>
