From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Tue, 30 Jun 2020 17:27:51 +0000
Subject: Re: [RFC] scsi: target: tcmu: running 32bit userspace on 64bit kernel
Message-Id: <1593538071.4124.7.camel@HansenPartnership.com>
List-Id: <target-devel.vger.kernel.org>
References: <364c13da-6d4f-c28b-36b3-082db8c3de58@ts.fujitsu.com>
         <1593535964.4124.2.camel@HansenPartnership.com>
         <2cc4fd9e-e96d-725b-c047-4bd26af604a6@ts.fujitsu.com>
In-Reply-To: <2cc4fd9e-e96d-725b-c047-4bd26af604a6@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <michael.christie@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Tue, 2020-06-30 at 19:17 +0200, Bodo Stroesser wrote:
> On 2020-06-30 18:52, James Bottomley wrote:
> > On Tue, 2020-06-30 at 18:49 +0200, Bodo Stroesser wrote:
[...]
> > > So we can compile a 32-bit application that works on 64-bit
> > > kernel without need to manipulate the include file prepared by
> > > the kernel.
> > > 
> > > What do you think? Do you know a better solution?
> > 
> > Can you not use something similar to the compat_ioctl
> > mechanism?  the job of the compat layer is to re-layout the input
> > and output structures to impedance match between 32 and 64 bit.
> > 
> > James
> > 
> 
> struct tcmu_cmd_entry is prepared by kernel and exposed to userspace
> via an mmap()ed uio device. From tcmu module point of view it is
> vmalloc area.
> 
> So there is no 'glue' code that could do conversion.

OK, so can't you do it like a vdso then?  For them we detect on mmap
what the architectural model is and map different areas depending on
that, so effectively you have a 64 and a 32 bit layout area and which
one you map depends on the architecture type you see coming into the
setup call.  You expect only one to be mapped and you only do extra
conversions on the impedance mismatch case.

> I'm not sure whether there is a way for tcmu to find out, what kind
> of userspace application is running. If it would know, it probably
> could prepare the entries accordingly.

I forget if the vdso switch is exposed outside the architecture, but an
inspection of the code should tell you.

> But worst case it could happen that entries prepared for 32-bit,
> after application stop and start, then are read by a new application
> version that is 64-bit ...

The userspace application absolutely knows its binary model.  The
kernel sort of knows (its known in the ELF32 execution model and the
like).

> Maybe we could add an configFS attribute allowing userspace to
> configure tcmu accordingly. A change of this attribute could also
> flush existing tcmu_cmd_entries. But that would mean that userspace
> application has to take care.
> 
> Isn't the compiler definition easier to use?

Well, yes, but that's an ABI change which I thought you were trying to
avoid?

James
