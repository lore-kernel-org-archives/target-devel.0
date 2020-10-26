From: David Disseldorp <ddiss@suse.de>
Date: Mon, 26 Oct 2020 09:13:40 +0000
Subject: Re: [PATCH 5/5] scsi: target: return COMPARE AND WRITE miscompare offsets
Message-Id: <20201026101340.7c45b604@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20201023205723.17880-1-ddiss@suse.de>
        <20201023205723.17880-6-ddiss@suse.de>
        <311cb7dd-2cdb-e653-ab97-41d644c0d293@oracle.com>
In-Reply-To: <311cb7dd-2cdb-e653-ab97-41d644c0d293@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <michael.christie@oracle.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

Thanks for the feedback Mike...

On Sun, 25 Oct 2020 20:14:42 -0500, Mike Christie wrote:

> On 10/23/20 3:57 PM, David Disseldorp wrote:
> > SBC-4 r15 5.3 COMPARE AND WRITE command states:
> >    if the compare operation does not indicate a match, then terminate the
> >    command with CHECK CONDITION status with the sense key set to
> >    MISCOMPARE and the additional sense code set to MISCOMPARE DURING
> >    VERIFY OPERATION. In the sense data (see 4.18 and SPC-5) the offset
> >    from the start of the Data-Out Buffer to the first byte of data that
> >    was not equal shall be reported in the INFORMATION field.
> > 
> > This change implements the missing logic to report the miscompare offset
> > in the sense data INFORMATION field.
> > 
> > Signed-off-by: David Disseldorp <ddiss@suse.de>
> > ---
> >   drivers/target/target_core_sbc.c       | 35 ++++++++++++++++++--------
> >   drivers/target/target_core_transport.c |  1 +
> >   2 files changed, 26 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> > index 79216d0355e7..e40359e45726 100644
> > --- a/drivers/target/target_core_sbc.c
> > +++ b/drivers/target/target_core_sbc.c
> > @@ -435,13 +435,13 @@ static sense_reason_t compare_and_write_post(struct se_cmd *cmd, bool success,
> >   }
> >   
> >   /*
> > - * compare @cmp_len bytes of @read_sgl with @cmp_sgl. On miscompare return
> > - * TCM_MISCOMPARE_VERIFY.
> > + * compare @cmp_len bytes of @read_sgl with @cmp_sgl. On miscompare, fill
> > + * @miscmp_off and return TCM_MISCOMPARE_VERIFY.
> >    */
> >   static sense_reason_t
> >   compare_and_write_do_cmp(struct scatterlist *read_sgl, unsigned int read_nents,
> >   			 struct scatterlist *cmp_sgl, unsigned int cmp_nents,
> > -			 unsigned int cmp_len)
> > +			 unsigned int cmp_len, unsigned int *miscmp_off)
> >   {
> >   	unsigned char *buf = NULL;
> >   	struct scatterlist *sg;
> > @@ -468,17 +468,20 @@ compare_and_write_do_cmp(struct scatterlist *read_sgl, unsigned int read_nents,
> >   	 */
> >   	offset = 0;
> >   	for_each_sg(read_sgl, sg, read_nents, i) {
> > +		unsigned int i;
> >   		unsigned int len = min(sg->length, cmp_len);
> >   		unsigned char *addr = kmap_atomic(sg_page(sg));
> >   
> > -		if (memcmp(addr, buf + offset, len)) {
> > -			pr_warn("Detected MISCOMPARE for addr: %p buf: %p\n",
> > -				addr, buf + offset);
> > -			kunmap_atomic(addr);
> > +		for (i = 0; i < len && addr[i] = buf[offset + i]; i++);  
> 
> I think it's a little nicer to put the ";" on the next line. It's just 
> not a common line of code so your eyes miss it. It should also make the 
> checkpatch script happy.

Sure, will change this.

> > +
> > +		kunmap_atomic(addr);
> > +		if (i < len) {
> > +			*miscmp_off = offset + i;
> > +			pr_warn("Detected MISCOMPARE at offset %u\n",
> > +				*miscmp_off);
> >   			ret = TCM_MISCOMPARE_VERIFY;
> >   			goto out;
> >   		}
> > -		kunmap_atomic(addr);
> >   
> >   		offset += len;
> >   		cmp_len -= len;
> > @@ -503,6 +506,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
> >   	unsigned int nlbas = cmd->t_task_nolb;
> >   	unsigned int block_size = dev->dev_attrib.block_size;
> >   	unsigned int compare_len = (nlbas * block_size);
> > +	unsigned int miscmp_off = 0;
> >   	sense_reason_t ret = TCM_NO_SENSE;
> >   	int i;
> >   
> > @@ -534,8 +538,19 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
> >   				       cmd->t_bidi_data_nents,
> >   				       cmd->t_data_sg,
> >   				       cmd->t_data_nents,
> > -				       compare_len);
> > -	if (ret)
> > +				       compare_len,
> > +				       &miscmp_off);
> > +	if (ret = TCM_MISCOMPARE_VERIFY) {
> > +		/*
> > +		 * SBC-4 r15: 5.3 COMPARE AND WRITE command
> > +		 * In the sense data (see 4.18 and SPC-5) the offset from the
> > +		 * start of the Data-Out Buffer to the first byte of data that
> > +		 * was not equal shall be reported in the INFORMATION field.
> > +		 */
> > +		WARN_ON(miscmp_off >= compare_len);  
> 
> I'm not sure how useful this is. If we hit this then we went wild in 
> compare_and_write_do_cmp since we only allocate the cmp buffer to be 
> compare_len bytes. If we think it's possible to hit this due to a 
> incorrectly setup cmd or buffer/sgl or something, I would be more 
> defensive in compare_and_write_do_cmp.

I don't think it's possible to hit, but figured it didn't harm
readability. I'll drop it in the next round.

Cheers, David
