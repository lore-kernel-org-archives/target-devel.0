From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 08 Jul 2020 06:06:53 +0000
Subject: Re: [PATCH 0/7] target: misc fixes for 5.9
Message-Id: <159418828148.5152.15776013269977713869.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1593654203-12442-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1593654203-12442-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: bstroesser@ts.fujitsu.com, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Mike Christie <michael.christie@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>

On Wed, 1 Jul 2020 20:43:16 -0500, Mike Christie wrote:

> The following patches were made over Martin's 5.9 queue branch. They fix
> some bugs that intersect with the sysfs/configfs patchset I've been
> posting
> 
> These patches are not critical so are best for 5.9 or later. They fix
> the SPEC_I_PT handling and how we report the iscsi inititor transport id
> which seems to have always been broken and I do not think anyone uses.
> There is also a fix for a leak during target_core_mod rmmod which is
> rare.

Applied to 5.9/scsi-queue, thanks!

[1/7] scsi: target: Check enforce_pr_isids during registration
      https://git.kernel.org/mkp/scsi/c/63c9ffe473d3
[2/7] scsi: target: Fix xcopy sess release leak
      https://git.kernel.org/mkp/scsi/c/3c006c7d23aa
[3/7] scsi: target: Fix crash during SPEC_I_PT handling
      https://git.kernel.org/mkp/scsi/c/f32ba612ef0f
[4/7] scsi: target: Fix iscsi transport id parsing
      https://git.kernel.org/mkp/scsi/c/169622eee437
[5/7] scsi: target: Fix iscsi transport id buffer setup
      https://git.kernel.org/mkp/scsi/c/a6f9b6cee3f2
[6/7] scsi: target: Fix iscsi transport id buf len calculation
      https://git.kernel.org/mkp/scsi/c/bd7f65d95200
[7/7] scsi: target: Handle short iSIDs
      https://git.kernel.org/mkp/scsi/c/639341bf8836

-- 
Martin K. Petersen	Oracle Linux Engineering
