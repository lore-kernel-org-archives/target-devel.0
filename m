From: Mike Christie <michael.christie@oracle.com>
Date: Tue, 27 Oct 2020 05:49:23 +0000
Subject: Re: [PATCH v2 0/5] scsi: target: COMPARE AND WRITE miscompare sense
Message-Id: <ec78c756-6abd-32a8-a7d3-1c7788fa57d3@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201026190646.8727-1-ddiss@suse.de>
In-Reply-To: <20201026190646.8727-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Disseldorp <ddiss@suse.de>, target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

On 10/26/20 2:06 PM, David Disseldorp wrote:
> This patchset adds missing functionality to return the offset of
> non-matching read/compare data in the sense INFORMATION field on
> COMPARE AND WRITE miscompare.
> 
> The functionality can be tested using the libiscsi
> CompareAndWrite.MiscompareSense test proposed via:
>    https://urldefense.com/v3/__https://github.com/sahlberg/libiscsi/pull/344__;!!GqivPVa7Brio!LJ-un7MDdHXhZgIK1qgvDgza2El16FK-T_4oDi6VqM0CzetAV9pGHDvLDrZUkITTHxhO$
> 
> Changes since v1:
> - drop unnecessary WARN_ON()
> - fix two checkpatch warnings
> - drop single-use nlbas variable
> - avoid compare_len recalculation
> 
> Cheers, David
> 
>   drivers/target/target_core_sbc.c       | 137 +++++++++++++++----------
>   drivers/target/target_core_transport.c |  33 +++---
>   include/target/target_core_base.h      |   2 +-
>   lib/scatterlist.c                      |   2 +-
>   4 files changed, 102 insertions(+), 72 deletions(-)


Reviewed-by: Mike Christie <michael.christie@oracle.com>
