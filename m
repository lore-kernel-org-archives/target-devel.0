From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Fri, 08 May 2020 02:54:23 +0000
Subject: Re: [PATCH 1/4] target: add missing emulate_pr attribute to passthrough backends
Message-Id: <158890633246.6466.3989954217345857639.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200427150823.15350-1-bstroesser@ts.fujitsu.com> <20200427150823.15350-2-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200427150823.15350-2-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, mchristi@redhat.com, ddiss@suse.de, hch@lst.de

On Mon, 27 Apr 2020 17:08:20 +0200, Bodo Stroesser wrote:

> In commit b49d6f7885306ee636d5c1af52170f3069ccf5f7 the new attribute
> emulate_pr was added.
> passthrough_parse_cdb() uses the attribute's value to distinguish,
> whether reservation commands should be rejected or not.
> But the new attribute was not added to passthrough_attrib_attrs, so in
> pscsi and tcmu - the users of passthrough_parse_cdb() - the attribute
> is not available to change parser's behavior.

Applied to 5.8/scsi-queue, thanks!

[1/4] scsi: target: Add missing emulate_pr attribute to passthrough backends
      https://git.kernel.org/mkp/scsi/c/9299941716a3
[2/4] scsi: target: tcmu: Add attributes enforce_pr_isids and force_pr_aptpl
      https://git.kernel.org/mkp/scsi/c/4703b6252b33
[3/4] scsi: target: Make transport_flags per device
      https://git.kernel.org/mkp/scsi/c/69088a049488
[4/4] scsi: target: tcmu: Make pgr_support and alua_support attributes writable
      https://git.kernel.org/mkp/scsi/c/356ba2a8bc8d

-- 
Martin K. Petersen	Oracle Linux Engineering
