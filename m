From: "Sebastian Herbszt" <herbszt@gmx.de>
Date: Wed, 19 Dec 2018 18:04:18 +0000
Subject: Aw: [ANNOUNCE v2]: Broadcom (Emulex) FC Target driver - efct
Message-Id: <trinity-2ce77c02-5a69-4144-bb7f-d6c4881217ce-1545242658738@3c-app-gmx-bs08>
List-Id: <target-devel.vger.kernel.org>
References: <9b8c7647-f9ab-9147-1378-b047929d5e11@broadcom.com>
In-Reply-To: <9b8c7647-f9ab-9147-1378-b047929d5e11@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

Hello James,

> I'd like to announce the availability of the Broadcom (Emulex) FC target
> driver - efct.
> 
> This is the 2nd round of announcement.   In the first round, after
> discussion with community members, it was decided that the driver would
> consist of the following:
>   - A SLI4-library that can be used by both an initiator driver and a
> target driver
>   - A FC Discovery library that could be used by both an initiator
> driver and a target driver.
>   - A SLI3-library that would be used by an initiator driver only
>   - Delivery of a target driver that would support SCSI and NVME
>   - Delivery of an initiator driver that would support SCSI and NVME 
> (NVME on SLI-4 only).
> 
> As of this announcement the repository on gitlab
> (git@gitlab.com:jsmart/efct-Emulex_FC_Target.git)
> contains:
>  - the SLI-4 library
>  - the FC Discovery library
>  - the efct target driver that supports SCSI (lio)

a lot has changed since v1:

71 files changed, 39869 insertions(+), 25695 deletions(-)

Can you maybe provide the full git history which should have tracked all
the file renaming?
Beside the split it seems there are other changes. More leftovers of the
FCoE support are gone, ddump support is no longer present and the initiator
support is not settable. Any further changes I missed?

I noticed this version does only build here on kernel 4.18. I pushed the
required changes for kernel 4.19 to my repository [1].

> Effort is underway on adding nvme target support to the efct driver, and
> after that, the initiator driver will be refactored.  The intent will be
> to move all elements into the upstream tree although it is expected the
> libraries and target components will be merged in a stage separate from
> the initiator components.

What are the plans for the "lpfc" driver? Will it use "libefc" and "libefc_sli"
or will a new (SLI4+) driver ("efci" ?) emerge?

> While those efforts are underway, we would like receive review comments
> on the code that is present. Comments can be sent to:
> ecd-efct.pdl@broadcom.com or myself
> 
> -- james

[1] https://repo.or.cz/efct-Emulex_FC_Target/sherbszt.git/shortlog/refs/heads/v2-update

Sebastian
