From: Mike Christie <mchristi@redhat.com>
Date: Sat, 16 Jun 2018 19:25:47 +0000
Subject: Re: [PATCH 01/33] TCMU PR: first commit to implement TCMU PR
Message-Id: <5B25643B.8050109@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180615182342.6239-1-lszhu@suse.com>
In-Reply-To: <20180615182342.6239-1-lszhu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 06/16/2018 02:20 PM, Mike Christie wrote:
> Adding Bodo who is working on a alternative approach.
> 
> On 06/16/2018 12:22 AM, Christoph Hellwig wrote:
>> > On Sat, Jun 16, 2018 at 02:23:10AM +0800, Zhu Lingshan wrote:
>>> >> These commits and the following intend to implement Persistent
>>> >> Reservation operations for TCMU devices.
>> > 
>> > Err, hell no.
>> > 
>> > If you are that tightly integrated with the target code that you can
>> > implement persistent reservation you need to use kernel code.
>> > Everything else just creates a way too complex interface.
> Hey Christoph,
> 
> Just wanted to make sure I understood this comment. In Lingshan's
> patches I think he was going to end up calling out to
> userspace/tcmu-runner and there he was going to make ceph calls which
> basically translate PGR operations to ceph requests. Are you saying we
> should just add some kernel module that makes the ceph calls? This would
> then avoid the mess of having the split PGR processing design in this
> patchset?

Oh yeah, I meant to also ask if I understood you correctly above, then
did you also just want us to add the target_core_rbd module that did
READ/WRITE/VAAI commands too?
