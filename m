From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Sun, 24 Nov 2019 18:31:04 +0000
Subject: Re: [PATCH v2 00/15] scsi: qla2xxx: Bug fixes
Message-Id: <20191124183104.fg364dol5rol3xfh@SPB-NB-133.local>
List-Id: <target-devel.vger.kernel.org>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
 <b84e274f-c20e-9351-27de-4cf1b34916d9@suse.de>
 <139c4a1040a9077fff39486f47134960d543ca53.camel@suse.de>
In-Reply-To: <139c4a1040a9077fff39486f47134960d543ca53.camel@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Martin Wilck <mwilck@suse.de>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux@yadro.com

On Fri, Nov 22, 2019 at 10:36:06PM +0100, Martin Wilck wrote:
> On Fri, 2019-11-22 at 10:14 +0100, Hannes Reinecke wrote:
> > This patchset has the nice benefit that it has fixed the crashes on
> > rmmod we had been seeing.
> 
> Well, I investigated two distinct crash-at-rmmod cases, and one was
> already fixed by the earlier commit f45bca8c5052 ("scsi: qla2xxx: Fix
> double scsi_done for abort path"), whereas the other is still present,
> even after applying this series.
> 
> Not to say the series is bad - we just shouldn't raise expectations
> too high.
> 

Hi Martin,

This patch series only fixes a crash when there's active I/O and ACL of
the initiator is getting deleted. The issue can be reproduced quite
easily:

  1. Configure a target with 1 LUN and 1 ACL (and 1 Mapped LUN inside)
  2. Run I/O from initiator
  3. Delete ACL while running the I/O

The crash happens ~30s after the ACL is deleted when the initiator
starts sending ABORT TASK TMF to abort timed out I/O. It might happen at
rmmod time but that's just coincidence of ABORT TASK being processed. It
might not happen if a rig shuts off in less than 30 seconds.

Thanks,
Roman
