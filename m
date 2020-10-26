From: David Disseldorp <ddiss@suse.de>
Date: Mon, 26 Oct 2020 17:57:57 +0000
Subject: Re: [PATCH 4/5] scsi: target: split out COMPARE AND WRITE memcmp into helper
Message-Id: <20201026185757.7f4b2c12@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20201023205723.17880-1-ddiss@suse.de>
        <20201023205723.17880-5-ddiss@suse.de>
        <34b6d335-7f72-4ebc-f3b3-873d6d82e4bc@gmail.com>
In-Reply-To: <34b6d335-7f72-4ebc-f3b3-873d6d82e4bc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bodo Stroesser <bostroesser@gmail.com>
Cc: target-devel@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

Hi Bodo,

On Mon, 26 Oct 2020 17:44:50 +0100, Bodo Stroesser wrote:

> Am 23.10.20 um 22:57 schrieb David Disseldorp:
> > In preparation for finding and returning the miscompare offset.
> > 
> > Signed-off-by: David Disseldorp <ddiss@suse.de>
> > ---
> >   drivers/target/target_core_sbc.c | 117 ++++++++++++++++++-------------
> >   1 file changed, 67 insertions(+), 50 deletions(-)
> > 
> > diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> > index 5f77dd95f1b9..79216d0355e7 100644
> > --- a/drivers/target/target_core_sbc.c
> > +++ b/drivers/target/target_core_sbc.c
> > @@ -434,20 +434,77 @@ static sense_reason_t compare_and_write_post(struct se_cmd *cmd, bool success,
> >   	return ret;
> >   }
> >   
> > +/*
> > + * compare @cmp_len bytes of @read_sgl with @cmp_sgl. On miscompare return
> > + * TCM_MISCOMPARE_VERIFY.
> > + */
> > +static sense_reason_t
> > +compare_and_write_do_cmp(struct scatterlist *read_sgl, unsigned int read_nents,
> > +			 struct scatterlist *cmp_sgl, unsigned int cmp_nents,
> > +			 unsigned int cmp_len)
> > +{
> > +	unsigned char *buf = NULL;
> > +	struct scatterlist *sg;
> > +	sense_reason_t ret;
> > +	unsigned int offset;
> > +	size_t rc;
> > +	int i;
> > +
> > +	buf = kzalloc(cmp_len, GFP_KERNEL);
> > +	if (!buf) {
> > +		pr_err("Unable to allocate compare_and_write buf\n");
> > +		ret = TCM_OUT_OF_RESOURCES;
> > +		goto out;
> > +	}
> > +
> > +	rc = sg_copy_to_buffer(cmp_sgl, cmp_nents, buf, cmp_len);
> > +	if (!rc) {
> > +		pr_err("sg_copy_to_buffer() failed for compare_and_write\n");
> > +		ret = TCM_OUT_OF_RESOURCES;
> > +		goto out;
> > +	}
> > +	/*
> > +	 * Compare SCSI READ payload against verify payload
> > +	 */
> > +	offset = 0;
> > +	for_each_sg(read_sgl, sg, read_nents, i) {
> > +		unsigned int len = min(sg->length, cmp_len);
> > +		unsigned char *addr = kmap_atomic(sg_page(sg));
> > +
> > +		if (memcmp(addr, buf + offset, len)) {
> > +			pr_warn("Detected MISCOMPARE for addr: %p buf: %p\n",
> > +				addr, buf + offset);
> > +			kunmap_atomic(addr);
> > +			ret = TCM_MISCOMPARE_VERIFY;
> > +			goto out;
> > +		}
> > +		kunmap_atomic(addr);
> > +
> > +		offset += len;
> > +		cmp_len -= len;
> > +		if (!cmp_len)
> > +			break;
> > +	}
> > +	pr_debug("COMPARE AND WRITE read data matches compare data\n");
> > +	ret = TCM_NO_SENSE;
> > +out:
> > +	kfree(buf);
> > +	return ret;
> > +}
> > +  
> 
> Since you are going to split out a new helper, did you consider to re-write helper's code to avoid the intermediate buffer?
> 
> Douglas Gilbert currently tries to add new functions to lib/scatterlist.c
> One of them is sgl_compare_sgl, which directly compares content of two sg lists:
>    https://patchwork.kernel.org/project/linux-block/patch/20201019191928.77845-4-dgilbert@interlog.com/
> 
> This code - based on the sg_miter_* calls - works without intermediate buffer.
> Maybe your helper could use similar code or you could even call Douglas' helper, if he can enhance it to
> (optionally) return the miscompare offset.

Interesting, thanks for the heads-up. Dropping the intermediate compare
buffer would be good, but I think this optimization should be left for a
separate patchset, at least until sgl_compare_sgl() lands in mainline.
LIO currently only supports 1-block compare-and-write requests, so the
performance benefits would likely only be modest.
@Douglas: would you be open to returning the miscompare offset from
sgl_compare_sgl()?

Cheers, David
