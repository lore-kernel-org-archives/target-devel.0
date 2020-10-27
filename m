From: David Disseldorp <ddiss@suse.de>
Date: Tue, 27 Oct 2020 09:57:37 +0000
Subject: Re: [PATCH v2 0/5] scsi: target: COMPARE AND WRITE miscompare sense
Message-Id: <20201027105737.5a52b17e@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20201026190646.8727-1-ddiss@suse.de>
        <ec78c756-6abd-32a8-a7d3-1c7788fa57d3@oracle.com>
In-Reply-To: <ec78c756-6abd-32a8-a7d3-1c7788fa57d3@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <michael.christie@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 27 Oct 2020 00:49:23 -0500, Mike Christie wrote:

> On 10/26/20 2:06 PM, David Disseldorp wrote:
> > This patchset adds missing functionality to return the offset of
> > non-matching read/compare data in the sense INFORMATION field on
> > COMPARE AND WRITE miscompare.
...
> > Changes since v1:
> > - drop unnecessary WARN_ON()
> > - fix two checkpatch warnings
> > - drop single-use nlbas variable
> > - avoid compare_len recalculation
> > 
> > Cheers, David
> > 
> >   drivers/target/target_core_sbc.c       | 137 +++++++++++++++----------
> >   drivers/target/target_core_transport.c |  33 +++---
> >   include/target/target_core_base.h      |   2 +-
> >   lib/scatterlist.c                      |   2 +-
> >   4 files changed, 102 insertions(+), 72 deletions(-)  
> 
> 
> Reviewed-by: Mike Christie <michael.christie@oracle.com>

Thanks Mike.
@Martin: please pull patches 2/5 through to 5/5 only; the independent
scatterlist patch 1/5 has been submitted via linux-block.

Cheers, David
