From: David Disseldorp <ddiss@suse.de>
Date: Fri, 30 Oct 2020 14:06:59 +0000
Subject: Re: [PATCH v2 0/5] scsi: target: COMPARE AND WRITE miscompare sense
Message-Id: <20201030150659.7262c619@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20201026190646.8727-1-ddiss@suse.de>
        <yq1blgk1nfx.fsf@ca-mkp.ca.oracle.com>
        <yq15z6s1n9n.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq15z6s1n9n.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 29 Oct 2020 22:06:00 -0400, Martin K. Petersen wrote:

> >> This patchset adds missing functionality to return the offset of
> >> non-matching read/compare data in the sense INFORMATION field on
> >> COMPARE AND WRITE miscompare.  
> >
> > Applied 2-5 to 5.11/scsi-staging, thanks!  
> 
> Dropped again, breaks IB.
> 

Hmm, I overlooked ib_isert in the bad_sector->sense_info rename, sorry.
I'll post a v3 when done with testing.

Cheers, David
