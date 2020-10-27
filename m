From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Tue, 27 Oct 2020 23:46:39 +0000
Subject: Re: [PATCH 3/3] scsi: target: core: Change ASCQ for residual write
Message-Id: <20201027234639.GB88490@SPB-NB-133.local>
List-Id: <target-devel.vger.kernel.org>
References: <20201022172011.42367-1-a.kovaleva@yadro.com>
 <20201022172011.42367-4-a.kovaleva@yadro.com>
 <e2b215ca-0aa8-bdae-e5bd-292a09d8282e@acm.org>
 <20201024121315.GA35317@SPB-NB-133.local>
 <b831a7db-1da2-c293-a8f6-d9c62f68c224@acm.org>
 <20201026131226.GA88490@SPB-NB-133.local>
 <270e2edf-49c9-942f-ac3d-b6dfa0aca8f7@acm.org>
In-Reply-To: <270e2edf-49c9-942f-ac3d-b6dfa0aca8f7@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>
Cc: Anastasia Kovaleva <a.kovaleva@yadro.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux@yadro.com

On Mon, Oct 26, 2020 at 07:42:55PM -0700, Bart Van Assche wrote:
> On 10/26/20 6:12 AM, Roman Bolshakov wrote:
> > Note, that if we talk about SSC over FCP, then "9.4.2 FCP_DATA IUs for
> > read and write operations" does additionally apply. Perhaps a) from
> > "9.4.2 FCP_DATA IUs for read and write operations" works well for SSC:
> > 
> >   a) process the command normally except that data beyond the FCP_DL count
> >   shall not be requested or transferred;
> > 
> > The clause allows to accomodate variable-block tranfers from SSC.
> > 
> > So, what if we return CHECK CONDITION only for SBC WRITEs with
> > residuals?  Then it has no impact on SSC and other device types. In
> > future, we might also add a patch that would fail SBC READs with
> > residuals for sake of consistency. That behaviour would be beneficial
> > for SBC devices as no host could corrupt data or itself by forming,
> > requesting invalid data buffer.
> 
> Maybe I'm overly concerned. I do not know for sure which applications
> rely on the current behavior of residual handling. All I know about
> these applications is based on what others wrote about these
> applications. An example from
> https://www.t10.org/pipermail/t10/2003-November/009317.html: "We have
> customers who also use overlength and underlength transfers as a normal
> mode of operation."
> 

Hi Bart,

Thanks for raising the point about overlength/underlength. If you wish
we can add an extra check that fails DMA_TO_DEVICE && DATA with
residuals only for SBC devices but note that before the series,
underflow/overflow for WRITE didn't return GOOD status. The particular
patch only changes sense code to more meaningful from the former INVALID
FIELD IN CDB.

Theoretically, it could be good to have a configurable switch how LIO
handles overflows/underflows for a LUN. Then it'd be possible to
configure desired behaviour on a per-LUN basis. But there should be a
clear need & demand for the feature to avoid maintenance of dead code.

> An additional question is what behavior other operating systems than
> Linux expect? There are probably setups in which another operating
> system than Linux communicates with a LIO SCSI target?
> 

TBH I don't know any hosts that do SBC WRITE with residuals as normal
course of operation. They wouldn't be able to work with LIO because it
never returns GOOD status on WRITE with residuals. I can send an update
later if the series works fine with modern hosts (~1 month, after a few
cycles of system testing).

Fun fact, ~60 years ago WRITE overflows were used to achieve behaviour
similar to disk zeroing/WRITE SAME [1].

1. https://mailarchive.ietf.org/arch/msg/ips/135ycRlgwUg1sb3gRrUQ3-lSXg0/

Thanks,
Roman
