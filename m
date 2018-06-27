From: David Disseldorp <ddiss@suse.de>
Date: Wed, 27 Jun 2018 22:05:11 +0000
Subject: Re: [PATCH v3] target: add emulate_pr backstore attr to toggle PR support
Message-Id: <20180628000511.79c88f59@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20180625185658.31141-1-ddiss@suse.de>
In-Reply-To: <20180625185658.31141-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi Bodo,

On Tue, 26 Jun 2018 14:35:47 +0200, Bodo Stroesser wrote:

> On 06/25/18 20:56, David Disseldorp wrote:
> > The new emulate_pr backstore attribute allows for Persistent Reservation
> > and SCSI2 RESERVE/RELEASE support to be completely disabled. This can be
> > useful for scenarios such as:
> > - Ensuring ATS (Compare & Write) usage on recent VMware ESXi initiators.
> > - Allowing clustered (e.g. tcm-user) backends to block such requests,
> >    avoiding the multi-node reservation state propagation.
> >
> > When explicitly disabled, PR and RESERVE/RELEASE requests receive
> > Invalid Command Operation Code response sense data.  
> 
> Currently I'm working on changes in the same area. But in my case we
> would need an attribute to optionally allow pr and alua CDBs to be
> passed to user space via tcm-user transparently.

So with TRANSPORT_FLAG_PASSTHROUGH_[ALUA/PGR] already there, you'd like
an attribute that could be modified at runtime, rather than the per
backend transport_flags?

> I already have the
> patches prepared but didn't send them yet as an important detail
> still is missing. (See details below)
> In general my patches change the existing 'pr/alua_support'
> attributes to be writable.

Ah okay. Given that WRT command processing, it's acting similar to
emulate_tpu, emulate_tpws, emulate_caw, etc. I decided to use emulate_pr
in this patchset.

> If this patch and the mine would be accepted, we would have three
> different modes for pr handling: the normal in stack handling, the
> reject of pr CDBs and transparent pass through. The former two being
> available for all backstore devices but the latter for devices using
> passthrough_parse_cdb() only.
>
> Obviously it would be great to have only one attribute to control
> emulation mode. That would be easier if we had two different modes
> only for any dev.

Hmm, okay, so you'd like to turn emulate_[pr/alua] or [pr/alua]_support
into writable tristate configfs parameters?

> Now I'm wondering whether the "reject pr CDBs" mode does make sense
> for e.g. tcm-user. Wouldn't it be enough to have the emulation
> in stack and the transparent mode only? In that case userspace process
> simply could use transparent mode and send a reject for these CDBs.

I think the problem is that the user configuration implies that handling
is disable for devices configured as such.

> So I'd like to propose the following:
> 1) Have an attribute to switch between normal mode (pr_support active)
>     and new mode (pr_support inactive).
> Whether this is done via the existing pr_support attribute or via
>     a new attribute is a question of flavor.
> 2) If pr_support is inactive, spc_parse_cdb() would reject PR CDBs
>     while passthrough_parse_cdb() would pass through those CDBs to
>     userspace.
> 3) In the "pr_support inactive" mode for devices using
> passthrough_parse_cdb() the transport_flag
> TRANSPORT_FLAG_PASSTHROUGH_PGR would be set. For devices using
>     spc_parse_cdb() a new flag like TRANSPORT_FLAG_REJECT_PGR should be
>     used. (See details below regarding dev specific transport_flags.)
> 4) The same could be done for ALUA also.

Would tcmu and pscsi become capable of selectively passing through
reservation and ALUA operations, regardless of the user configured
state? As mentioned, I think this may become a little too user
unfriendly, but there's a good chance I'm not fully understanding your
intention.

Cheers, David
