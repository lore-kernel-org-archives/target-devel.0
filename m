From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 27 Oct 2020 02:42:55 +0000
Subject: Re: [PATCH 3/3] scsi: target: core: Change ASCQ for residual write
Message-Id: <270e2edf-49c9-942f-ac3d-b6dfa0aca8f7@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20201022172011.42367-1-a.kovaleva@yadro.com>
 <20201022172011.42367-4-a.kovaleva@yadro.com>
 <e2b215ca-0aa8-bdae-e5bd-292a09d8282e@acm.org>
 <20201024121315.GA35317@SPB-NB-133.local>
 <b831a7db-1da2-c293-a8f6-d9c62f68c224@acm.org>
 <20201026131226.GA88490@SPB-NB-133.local>
In-Reply-To: <20201026131226.GA88490@SPB-NB-133.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Bolshakov <r.bolshakov@yadro.com>
Cc: Anastasia Kovaleva <a.kovaleva@yadro.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux@yadro.com

On 10/26/20 6:12 AM, Roman Bolshakov wrote:
> Could you please elaborate on how tape software will be broken?
> I have no experience with tapes but I've looked into SSC-5 draft.
> 
> I haven't found anything concerning the writes but there are tape
> variants of overflow/underflow for reads (G.3 General read rules) called
> overlength and underlegth, respectively:
> 
>   If the read command requests fewer bytes than are available for
>   transfer, then the read is an overlength read. If the read requests
>   more bytes than are available, then the read is an underlength read.
> 
>   The amount of data returned is the smaller of the bytes available and
>   the allocation length.
> 
> And the next paragraph defines cases where CHECK CONDITION should be
> reported for such reads. However, GOOD status is also possible, the next
> chapter of the annex (G.4 Examples from figure G.1 using variable-block
> transfers and various SILI and BLOCK LENGTH settings) refines many cases
> depending on SILI bit, whether block protection is enabled, if the
> transfer is FIXED or variable-length and if BLOCK LENGTH is
> zero/non-zero.
> 
> As far as I understand underlength and overlength are always suppressed
> (status is GOOD) for devices where no "default" block size is defined
> per SPC (7.5.7.1 General block descriptor format):
> 
>   For sequential access devices, a block length of zero indicates that the
>   logical block size written to the medium is specified by the TRANSFER
>   LENGTH field in the CDB (see SSC-4).
> 
> The cases are also summarized in annex D (D.3 Summary of length error
> conditions on read type commands).
> 
> Note, that if we talk about SSC over FCP, then "9.4.2 FCP_DATA IUs for
> read and write operations" does additionally apply. Perhaps a) from
> "9.4.2 FCP_DATA IUs for read and write operations" works well for SSC:
> 
>   a) process the command normally except that data beyond the FCP_DL count
>   shall not be requested or transferred;
> 
> The clause allows to accomodate variable-block tranfers from SSC.
> 
> So, what if we return CHECK CONDITION only for SBC WRITEs with
> residuals?  Then it has no impact on SSC and other device types. In
> future, we might also add a patch that would fail SBC READs with
> residuals for sake of consistency. That behaviour would be beneficial
> for SBC devices as no host could corrupt data or itself by forming,
> requesting invalid data buffer.

Hi Roman,

Maybe I'm overly concerned. I do not know for sure which applications
rely on the current behavior of residual handling. All I know about
these applications is based on what others wrote about these
applications. An example from
https://www.t10.org/pipermail/t10/2003-November/009317.html: "We have
customers who also use overlength and underlength transfers as a normal
mode of operation."

An additional question is what behavior other operating systems than
Linux expect? There are probably setups in which another operating
system than Linux communicates with a LIO SCSI target?

Thanks,

Bart.
