From: Anastasia Kovaleva <a.kovaleva@yadro.com>
Date: Tue, 10 Nov 2020 16:57:15 +0000
Subject: Re: [PATCH 3/3] scsi: target: core: Change ASCQ for residual write
Message-Id: <45E2175E-EE3A-473C-93DD-8ED3168198CA@yadro.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201022172011.42367-1-a.kovaleva@yadro.com>
 <20201022172011.42367-4-a.kovaleva@yadro.com>
 <e2b215ca-0aa8-bdae-e5bd-292a09d8282e@acm.org>
 <20201024121315.GA35317@SPB-NB-133.local>
 <b831a7db-1da2-c293-a8f6-d9c62f68c224@acm.org>
 <20201026131226.GA88490@SPB-NB-133.local>
 <270e2edf-49c9-942f-ac3d-b6dfa0aca8f7@acm.org>
 <20201027234639.GB88490@SPB-NB-133.local>
 <c3dac124-301e-df94-9d64-b3c46d4eafb9@acm.org>
In-Reply-To: <c3dac124-301e-df94-9d64-b3c46d4eafb9@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux@yadro.com" <linux@yadro.com>, Bodo Stroesser <bostroesser@gmail.com>

On 28 Oct 2020, at 06:41, Bart Van Assche <bvanassche@acm.org> wrote:
> On 10/27/20 4:46 PM, Roman Bolshakov wrote:
>> Thanks for raising the point about overlength/underlength. If you wish
>> we can add an extra check that fails DMA_TO_DEVICE && DATA with
>> residuals only for SBC devices but note that before the series,
>> underflow/overflow for WRITE didn't return GOOD status. The particular
>> patch only changes sense code to more meaningful from the former INVALID
>> FIELD IN CDB.
>> 
>> Theoretically, it could be good to have a configurable switch how LIO
>> handles overflows/underflows for a LUN. Then it'd be possible to
>> configure desired behaviour on a per-LUN basis. But there should be a
>> clear need & demand for the feature to avoid maintenance of dead code.
>>>> An additional question is what behavior other operating systems than
>>> Linux expect? There are probably setups in which another operating
>>> system than Linux communicates with a LIO SCSI target?
>> 
>> TBH I don't know any hosts that do SBC WRITE with residuals as normal
>> course of operation. They wouldn't be able to work with LIO because it
>> never returns GOOD status on WRITE with residuals. I can send an update
>> later if the series works fine with modern hosts (~1 month, after a few
>> cycles of system testing).
> 
> Hi Roman,
> 
> I'm not sure adding a new kernel switch is the best choice. That would
> be an additional parameter users have to know about and have to learn
> how to use.
> 
> Bodo seems to be in favor of this patch series. Are there other people
> who want to share their opinion about this patch series?

Hi Bart,

Is this patch series good enough to be accepted in this form, without
the kernel switch? As far as i can see, no one has shared their opinion
about this changes. 

Thanks,

Anastasia
