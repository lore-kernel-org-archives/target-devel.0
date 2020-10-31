From: David Disseldorp <ddiss@suse.de>
Date: Sat, 31 Oct 2020 10:38:52 +0000
Subject: Re: [PATCH v3 4/4] scsi: target: return COMPARE AND WRITE miscompare offsets
Message-Id: <20201031113852.39110f4c@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20201030213931.10720-1-ddiss@suse.de>
        <20201030213931.10720-5-ddiss@suse.de>
        <e475cbf3-6dc8-901f-b5e3-30228e9a03a4@interlog.com>
In-Reply-To: <e475cbf3-6dc8-901f-b5e3-30228e9a03a4@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Mike Christie <michael.christie@oracle.com>, "Dirk Hohndel (VMware)" <dirk@hohndel.org>

On Fri, 30 Oct 2020 20:06:31 -0400, Douglas Gilbert wrote:

> I believe the logic is correct (and scsi_debug doesn't set the INFO field
> in its CAW, but should), but I wonder about performance.
> 
> If the probability of equality is high (e.g. like it is usually with
> VERIFY(BytChk=1) ) and memcmp() is faster than that for-loop (which
> could be optimized), then a better strategy might be to always do memcmp()
> first and only if it fails go into the byte by byte for-loop to find the
> offset of the first miscompare.

While adding the INFO return to tgt I noticed that it had the same
memcmp-with-miscompare-for-loop logic that you describe. I'm only aware
of ESXi as a COMPARE AND WRITE consumer and I think probability of
equality is quite high (@Dirk: perhaps you can confirm?).

> IMO this should only be considered, if there is going to be a "v4" of
> this patchset.

I think this optimization wouldn't make the code much more complex, so
I'll do a re-spin with this change. Thanks for the feedback.

Cheers, David
