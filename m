From: "Bryant G. Ly" <bryantly@linux.ibm.com>
Date: Wed, 30 May 2018 13:57:36 +0000
Subject: Re: [PATCH V3] TCMUser: add read length support
Message-Id: <4a006b58-51bd-3165-42d8-77ab49ce7b99@linux.ibm.com>
List-Id: <target-devel.vger.kernel.org>
References: <5b047066.t8v3fAM4bKz+MM/y%bstroesser@ts.fujitsu.com>
In-Reply-To: <5b047066.t8v3fAM4bKz+MM/y%bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org



On 5/22/18 2:45 PM, Bodo Stroesser wrote:

> Patch V3. This time without 'Re: ' in Subject.
>
> Generally target core and TCMUser seem to work fine for tape devices and
> media changers.
> But there is at least one situation, where TCMUser is not able to support
> sequential access device emulation correctly.
>
> The situation is when an initiator sends a SCSI READ CDB with a length that is
> greater than the length of the tape block to read. We can distinguish two
> subcases:
>
> A) The initiator sent the READ CDB with the SILI bit being set.
>    In this case the sequential access device has to transfer the data from the
>    tape block (only the length of the tape block) and transmit a good status.
>    The current interface between TCMUser and the userspace does not support
>    reduction of the read data size by the userspace program.
>
>    The patch below fixes this subcase by allowing the userspace program to
>    specify a reduced data size in read direction.
>
> B) The initiator sent the READ CDB with the SILI bit not being set.
>    In this case the sequential access device has to transfer the data from the
>    tape block as in A), but additionally has to transmit CHECK CONDITION with
>    the ILI bit set and NO SENSE in the sensebytes. The information field in
>    the sensebytes must contain the residual count.
>
>    With the below patch a user space program can specify the real read data
>    length and appropriate sensebytes.
>    TCMUser then uses the se_cmd flag SCF_TREAT_READ_AS_NORMAL, to force target
>    core to transmit the real data size and the sensebytes.
>    Note: the flag SCF_TREAT_READ_AS_NORMAL is introduced by Lee Duncan's
>    patch "[PATCH v4] target: transport should handle st FM/EOM/ILI reads" from
>    Tue, 15 May 2018 18:25:24 -0700.
>
> This patch was created for kernel 4.15.9.
>
>
> Changes from RFC:
> - patch now uses SCF_TREAT_READ_AS_NORMAL to fix B) also.
> - comment changed accordingly
>
> Changes from V2:
> - Cleaned up code according to review
> - Userspace can set read_len for data in only, not for bidi.
> - read_len from userspace no longer is checked implicitly by
>   gather_data_area(), but the check is done explicitly
>   in tcmu_handle_completion(). Now code is easier to understand.
>   
>
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
>
> ---
>  include/uapi/linux/target_core_user.h |    4 ++-
>  drivers/target/target_core_user.c     |   44 +++++++++++++++++++++++++++-------
>  2 files changed, 39 insertions(+), 9 deletions(-)
>
>
Acked-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>

