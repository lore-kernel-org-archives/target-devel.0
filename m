From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Fri, 18 May 2018 16:26:05 +0000
Subject: Re: [PATCH v4] target: transport should handle st FM/EOM/ILI reads
Message-Id: <yq1d0xtexr6.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180516012524.5541-1-lduncan@suse.com>
In-Reply-To: <20180516012524.5541-1-lduncan@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Lee,

> When a tape drive is exported via LIO using the pscsi module, a read
> that requests more bytes per block than the tape can supply returns an
> empty buffer. This is because the pscsi pass-through target module
> sees the "ILI" illegal length bit set and thinks there is no reason to
> return the data.

Applied to 4.18/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
