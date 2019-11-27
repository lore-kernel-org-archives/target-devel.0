From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 27 Nov 2019 17:34:31 +0000
Subject: Re: [PATCH v3 00/13] scsi: qla2xxx: Bug fixes
Message-Id: <d9366987-ab6a-9124-39e1-d70887c88757@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20191125165702.1013-1-r.bolshakov@yadro.com>
 <347fd571-89d7-2b7e-fd88-1711002c3fb9@acm.org>
 <20191127172427.jpqfopou7y6kyrev@SPB-NB-133.local>
In-Reply-To: <20191127172427.jpqfopou7y6kyrev@SPB-NB-133.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Bolshakov <r.bolshakov@yadro.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux@yadro.com

On 11/27/19 9:24 AM, Roman Bolshakov wrote:
> On Tue, Nov 26, 2019 at 12:56:51PM -0800, Bart Van Assche wrote:
>> On 11/25/19 8:56 AM, Roman Bolshakov wrote:
>>> The patch series contains fixes for qla2xxx and solves two visible
>>> issues: [ ... ]
>>
>> As explained in Documentation/process/2.Process.rst, please post patches
>> outside the merge window.
> 
> Thank you for the reference. Could you please assess if my understanding
> of the document is correct:
> 	The fixes might go into 5.5-rc2 after the release of rc1 which
> 	closes the merge window.
> 
> 	No patches except critical for -rc1 should be posted when the
> 	merge window is opened.

Hi Roman,

During the merge window many maintainers and core contributors are busy 
with identifying and addressing regressions introduced during the merge 
window. I think that is why the merge window is not the best time to 
post patches and why that text was added to the kernel documentation.

What happens with patches posted during the merge window depends on the 
maintainer (Martin Petersen). Sometimes patches posted during the merge 
window are ignored. Sometimes such patches are queued after the merge 
window has closed. Sometimes contributors are asked after the merge 
window has closed to rebase their patch series, to retest it and to 
repost it. The latter makes sense because the changes accepted during 
the merge window (e.g. core kernel API changes) may require matching 
changes in a patch series. You may want to ask Martin directly which 
approach he prefers after the merge window has closed.

Bart.
