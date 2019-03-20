From: Mike Christie <mchristi@redhat.com>
Date: Wed, 20 Mar 2019 17:15:47 +0000
Subject: Re: [PATCH][next] scsi: target: fix unsigned comparision with less than zero
Message-Id: <5C927543.2020907@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190320163709.28767-1-colin.king@canonical.com>
 <5C9274D9.30706@redhat.com>
In-Reply-To: <5C9274D9.30706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Colin King <colin.king@canonical.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

On 03/20/2019 12:14 PM, Mike Christie wrote:
> On 03/20/2019 11:37 AM, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Currently an error return is being assigned to an unsigned
>> size_t varianle and then checked if the result is less than
>> zero which will always be false.  Fix this by making ret
> 
> What kernel version was this made against?
> 
> For Martin's 5.2 queue branch, with these scsi changes it looks like
> strlcpy returns a size_t. And then below it looks like we compare the
> return value from that function to the buffer size and the max len of
> the string we support. We do not seem to check for less than zero.
> 
> 

My mistake. I was looking at len and not ret.

Patch looks ok to me.

Reviewed-by: Mike Christie <mchristi@redhat.com>
