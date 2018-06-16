From: Mike Christie <mchristi@redhat.com>
Date: Sat, 16 Jun 2018 19:20:12 +0000
Subject: Re: [PATCH 01/33] TCMU PR: first commit to implement TCMU PR
Message-Id: <5B2562EC.9070107@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180615182342.6239-1-lszhu@suse.com>
In-Reply-To: <20180615182342.6239-1-lszhu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Adding Bodo who is working on a alternative approach.

On 06/16/2018 12:22 AM, Christoph Hellwig wrote:
> On Sat, Jun 16, 2018 at 02:23:10AM +0800, Zhu Lingshan wrote:
>> These commits and the following intend to implement Persistent
>> Reservation operations for TCMU devices.
> 
> Err, hell no.
> 
> If you are that tightly integrated with the target code that you can
> implement persistent reservation you need to use kernel code.
> Everything else just creates a way too complex interface.

Hey Christoph,

Just wanted to make sure I understood this comment. In Lingshan's
patches I think he was going to end up calling out to
userspace/tcmu-runner and there he was going to make ceph calls which
basically translate PGR operations to ceph requests. Are you saying we
should just add some kernel module that makes the ceph calls? This would
then avoid the mess of having the split PGR processing design in this
patchset?


Also just to make it a little more fun :) There is another person
working on a completely different design.

Bodo's design is for tcmu only and allows userspace to just handle
everything. PGR commands and related checks for conflicts are all
handled in the userspace daemon that is receiving commands from the
target_core_user kernel module.

The one hiccup is this design requires a change where the I_T Nexus info
is passed to userspace so it can handle certain PGR registration
commands correction and also for each command check if a nexus has been
registered and what reservation there is for it. We could:

	1. Just pass that info to userspace in each tcmu request.

	2. Do something like the old kernel tgt code did where when a I_T nexus
was established in the kernel it sent an event to userspace. Each SCSI
command passed to userspace had some tag that allowed userspace to match
the tag with the I_T Nexus.
