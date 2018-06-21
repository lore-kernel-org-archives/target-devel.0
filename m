From: David Disseldorp <ddiss@suse.de>
Date: Thu, 21 Jun 2018 15:03:01 +0000
Subject: Re: [RFC PATCH] target: add emulate_pr backstore attr to toggle PR support
Message-Id: <20180621170301.143488b0@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20180601000532.11058-1-ddiss@suse.de>
In-Reply-To: <20180601000532.11058-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi Mike,

On Mon, 4 Jun 2018 12:13:22 -0500, Mike Christie wrote:

> On 06/03/2018 07:57 AM, David Disseldorp wrote:
...
> > I considered more granular toggles, but decided against it due to the
> > added configuration/implementation complexity. Happy to revisit this if
> > others would prefer it though.  
> 
> I might not understand your original "enforce" part of the patch
> description, because it seems like you must do this.

I've changed "enforce" to "ensure".

> I think ATS only is the default for the newer versions of ESX when the
> device reports it supports ATS, and it seems like running windows
> clustering in VMs on ESX is common. So, you will have that combo of ATS
> only with PRs a lot.

I don't think a combination of SCSI2 and persistent reservations is
common, as VMware recommends Raw Device Mapping (via a separate LUN) for
most Windows Failover Cluster use use cases[1]. See:
https://docs.vmware.com/en/VMware-vSphere/6.5/vsphere-esxi-vcenter-server-651-setup-mscs.pdf

IMO a single toggle to disable both RESERVE / RELEASE and Persistent
Reservation handling for a given backstore is still the simplest and
most user friendly option here.

> When you wrote "enforce" earlier I thought you meant the patch is
> supposed to make sure that ATS only is really on and if ESX messes up
> (or maybe the user messed up the settings) and it sends a
> RESERVE/RELEASE then it is failed. I do not see how that is possible
> with your patch with something like windows clustering VMs.
> 
> If the patch was more for protecting against the case where the backend
> does not support reservations, and ATS only was used to make sure they
> are never used due to that, and we assume backends always implement
> older reservations if they implement newer PRs then I think the patch is
> fine.
> 
> So I do not really care :) I think it depends on what you were trying to
> support.

Some older versions of ESX/VMFS can fall back to using SCSI2
reservations instead of ATS[2]. Disabling LIO SCSI2+PR support restricts
this fallback behaviour. That's what I was trying to get across in the
commit message :)

New version to follow...

Cheers, David

1) Windows Failover Cluster on VMware
https://docs.vmware.com/en/VMware-vSphere/6.5/vsphere-esxi-vcenter-server-651-setup-mscs.pdf
2) vSphere 5 SCSI reservations vs ATS locking
https://pubs.vmware.com/vsphere-50/topic/com.vmware.vsphere.storage.doc_50/GUID-DE30AAE3-72ED-43BF-95B3-A2B885A713DB.html
