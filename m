From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Mon, 26 Oct 2020 13:12:26 +0000
Subject: Re: [PATCH 3/3] scsi: target: core: Change ASCQ for residual write
Message-Id: <20201026131226.GA88490@SPB-NB-133.local>
List-Id: <target-devel.vger.kernel.org>
References: <20201022172011.42367-1-a.kovaleva@yadro.com>
 <20201022172011.42367-4-a.kovaleva@yadro.com>
 <e2b215ca-0aa8-bdae-e5bd-292a09d8282e@acm.org>
 <20201024121315.GA35317@SPB-NB-133.local>
 <b831a7db-1da2-c293-a8f6-d9c62f68c224@acm.org>
In-Reply-To: <b831a7db-1da2-c293-a8f6-d9c62f68c224@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>
Cc: Anastasia Kovaleva <a.kovaleva@yadro.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux@yadro.com

On Sat, Oct 24, 2020 at 05:25:17PM -0700, Bart Van Assche wrote:
> On 10/24/20 5:13 AM, Roman Bolshakov wrote:
> >> Additionally, what benefits does it provide to report a CHECK CONDITION
> >> upon residual overflow?
> > 
> > Typical use case for CHECK CONDITION in case of Underflow/Overflow is
> > extra robustness against buggy initiators [1][2]. Failing both READ and
> > WRITE is the most solid approach in that sense [3][4][5] as it prevents
> > data corruption at all costs.
> > 
> > Suppose an initiator wants to WRITE 8 LBA. For 512-byte formatted LUN,
> > 8 LBAs need a buffer of 4K bytes. For 4096-byte formatted LUN the
> > command would need 32K data buffer.
> > 
> > An Overflow happens if initiator treats 4Kn device like 512n one but
> > provides a buffer of 4K. i.e. to complete the WRITE target needs to
> > consume 28K more data, otherwise only 1 LBA would be written and the
> > rest 7 LBAs would have indeterminate content.
> > 
> > An Underflow happens if initiator confuses 512n device with 4Kn one and
> > provides a buffer of 32K, i.e. target doesn't utilize all buffer for the
> > command.
> 
> Thanks for the additional background information, this really helps. How
> about only rejecting SCSI commands for which the data buffer size is not
> a multiple of the block size? I'm concerned that flagging all SCSI
> commands that have a residue as invalid will break SCSI tape software.
> 

Hi Bart,

Could you please elaborate on how tape software will be broken?
I have no experience with tapes but I've looked into SSC-5 draft.

I haven't found anything concerning the writes but there are tape
variants of overflow/underflow for reads (G.3 General read rules) called
overlength and underlegth, respectively:

  If the read command requests fewer bytes than are available for
  transfer, then the read is an overlength read. If the read requests
  more bytes than are available, then the read is an underlength read.

  The amount of data returned is the smaller of the bytes available and
  the allocation length.

And the next paragraph defines cases where CHECK CONDITION should be
reported for such reads. However, GOOD status is also possible, the next
chapter of the annex (G.4 Examples from figure G.1 using variable-block
transfers and various SILI and BLOCK LENGTH settings) refines many cases
depending on SILI bit, whether block protection is enabled, if the
transfer is FIXED or variable-length and if BLOCK LENGTH is
zero/non-zero.

As far as I understand underlength and overlength are always suppressed
(status is GOOD) for devices where no "default" block size is defined
per SPC (7.5.7.1 General block descriptor format):

  For sequential access devices, a block length of zero indicates that the
  logical block size written to the medium is specified by the TRANSFER
  LENGTH field in the CDB (see SSC-4).

The cases are also summarized in annex D (D.3 Summary of length error
conditions on read type commands).

Note, that if we talk about SSC over FCP, then "9.4.2 FCP_DATA IUs for
read and write operations" does additionally apply. Perhaps a) from
"9.4.2 FCP_DATA IUs for read and write operations" works well for SSC:

  a) process the command normally except that data beyond the FCP_DL count
  shall not be requested or transferred;

The clause allows to accomodate variable-block tranfers from SSC.

So, what if we return CHECK CONDITION only for SBC WRITEs with
residuals?  Then it has no impact on SSC and other device types. In
future, we might also add a patch that would fail SBC READs with
residuals for sake of consistency. That behaviour would be beneficial
for SBC devices as no host could corrupt data or itself by forming,
requesting invalid data buffer.

Thanks,
Roman
