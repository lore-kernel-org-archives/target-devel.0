From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Tue, 08 Sep 2020 14:31:24 +0000
Subject: Re: [PATCH v2] scsi: target: tcmu: add compat mode for 32bit userspace on 64bit kernel
Message-Id: <79cd442a-2c7d-76e9-e82d-c40d2b57ecde@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200903174105.4571-1-bstroesser@ts.fujitsu.com>
 <8f276b52-f741-b00b-9b00-77fcd855c4fe@oracle.com>
In-Reply-To: <8f276b52-f741-b00b-9b00-77fcd855c4fe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <michael.christie@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 2020-09-08 01:14, Mike Christie wrote:
> On 9/3/20 12:41 PM, Bodo Stroesser wrote:
>> +#ifdef TCMU_COMPAT
>> +static inline void compat_new_iov(struct iovec **iov, int *iov_cnt)
>> +{
>> +	struct compat_iovec **c_iov = (struct compat_iovec **)iov;
>> +
>> +	if (*iov_cnt != 0)
>> +		(*c_iov)++;
>> +	(*iov_cnt)++;
>> +
>> +	memset(*c_iov, 0, sizeof(struct compat_iovec));
>> +}
>> +
>> +static inline size_t compat_iov_tail(struct iovec *iov)
>> +{
>> +	struct compat_iovec *c_iov = (struct compat_iovec *)iov;
>> +
>> +	return (size_t)c_iov->iov_base + c_iov->iov_len;
>> +}
>> +#endif
>> +
>>   static void scatter_data_area(struct tcmu_dev *udev,
>>   	struct tcmu_cmd *tcmu_cmd, struct scatterlist *data_sg,
>>   	unsigned int data_nents, struct iovec **iov,
>> @@ -705,13 +763,41 @@ static void scatter_data_area(struct tcmu_dev *udev,
>>   			to_offset = get_block_offset_user(udev, dbi,
>>   					block_remaining);
>>   
>> +			copy_bytes = min_t(size_t, sg_remaining,
>> +					block_remaining);
>> +			if (copy_data) {
>> +				offset = DATA_BLOCK_SIZE - block_remaining;
>> +				memcpy(to + offset,
>> +				       from + sg->length - sg_remaining,
>> +				       copy_bytes);
>> +			}
>> +			sg_remaining -= copy_bytes;
>> +			block_remaining -= copy_bytes;
>> +
>>   			/*
>>   			 * The following code will gather and map the blocks
>>   			 * to the same iovec when the blocks are all next to
>>   			 * each other.
>>   			 */
>> -			copy_bytes = min_t(size_t, sg_remaining,
>> -					block_remaining);
>> +#ifdef TCMU_COMPAT
>> +			if (udev->compat) {
>> +				struct compat_iovec *c_iov;
>> +
>> +				if (*iov_cnt != 0 &&
>> +				    to_offset = compat_iov_tail(*iov)) {
>> +					c_iov = (struct compat_iovec *)*iov;
>> +					c_iov->iov_len += copy_bytes;
>> +				} else {
>> +					compat_new_iov(iov, iov_cnt);
>> +					c_iov = (struct compat_iovec *)*iov;
>> +					c_iov->iov_base >> +						(compat_uptr_t)to_offset;
>> +					c_iov->iov_len = copy_bytes;
>> +				}
>> +				continue;
>> +			}
>> +#endif
> 
> I think a couple one or two liner ifdefs in the middle of a function is something people look the other way on. Maybe here we went a little too wild though. If we are not going the callout route, I think it would be nicer here to separate this part into functions. In the ifdef with compat_new_iov/compat_iov_tail above this function, add a tcmu_compat_iov_set and move the code above there. Move the code below it that does the non compat code to a new function tcmu_iov_set. We will still need a ifdef for the tcmu_compat_iov_set somewhere, but it feels more organized.
> 

Ok. I agree.

To be honest, I already prepared a new patch series allowing to
have buffer chunks bigger than one page in data area of tcmu's
uio device. While tcmu still uses single page allocation, the
change allows to have shorter iovec lists, less buffer bits to
maintain, and if necessary allows userspace to choose buffer chunks
as big as max. expected IO data size, which from userspace perspective
makes every IO up to that chosen data size appear in a single
consecutive buffer (1 iovec only)

The first patches of that series already do some re-work and
optimization of queue_cmd_ring and scatter_data_area such, that we
end up with something very similar to what you suggest :)

So instead of this patch I'll soon send a short series consisting
of those 3 patches and a new version of the current patch.
I hope, that series will look more organized.

Thank you,
Bodo
