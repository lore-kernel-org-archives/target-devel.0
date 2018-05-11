From: Lee Duncan <lduncan@suse.com>
Date: Fri, 11 May 2018 19:25:27 +0000
Subject: Re: [PATCH RFC] TCMUser: add read length support
Message-Id: <bc6b3095-58db-6839-7279-0466c290ab28@suse.com>
List-Id: <target-devel.vger.kernel.org>
References: <5af1c5d7.GFiV296jLjRKRJI0%bstroesser@ts.fujitsu.com>
In-Reply-To: <5af1c5d7.GFiV296jLjRKRJI0%bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 05/08/2018 08:44 AM, Bodo Stroesser wrote:
> Hi,
> 
> We are going to use TCMUser for an emulation of tape devices and
> media chargers.
> 
> Generally target core and TCMUser seem to work fine for this purpose.
> But there is at least one situation, where TCMUser as well as the target core
> currently are not able to support sequential access device emulation
> correctly.
> 
> The situation is when an initiator sends a SCSI READ CDB with a length that is
> greater than the length of the tape block to read. We can distinguish two
> subcases:
> 
> A) The initiator sent the READ CDB without the SILI bit being set.
>    In this case the sequential access device has to transfer the data from the
>    tape block (only the length of the tape block) and transmit a good status.
>    The current interface between TCMUser and the userspace does not support
>    reduction of the read data size by the userspace program.
> 
>    The patch/RFC below fixes this subcase by allowing the userspace program to
>    specify a reduced data size in read direction.
> 
> B) The initiator sent the READ CDB with the SILI bit not being set.
>    In this case the sequential access device has to transfer the data from the
>    tape block as in A), but additionally has to transmit CHECK CONDITION with
>    the ILI bit set and NO SENSE in the sensebytes. The information field in
>    the sensebytes must contain the residual count.
>    With the below patch/RFC a user space program can specify the real read
>    data length and appropriate sensebytes.
>    But AFAICS, up to now the target core is not prepared to transfer datas
>     _and_ sensebytes for a single SCSI command. Therefore only the status
>    and sensebytes are transferred, but no data.
> 
>    I fear, fixing this would result in more invasive patches. Suggestions
>    how to fix would be welcome.
> 
> 
> This patch was created for kernel 4.15.9.
> 
> Best regards,
> Bodo
> 
> ---
> ...


Have you tried this with my target core patch? Just curious if short
reads would work with my patch and this code.
-- 
Lee Duncan
