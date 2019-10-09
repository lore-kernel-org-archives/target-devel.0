From: Christoph Hellwig <hch@infradead.org>
Date: Wed, 09 Oct 2019 07:00:07 +0000
Subject: Re: Wrong resetting of Logical Unit Number field in CDB
Message-Id: <20191009070007.GA19629@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <ac680e032540400a8cd7b1bf03361df3@R01UKEXCASM125.r01.fujitsu.local>
In-Reply-To: <ac680e032540400a8cd7b1bf03361df3@R01UKEXCASM125.r01.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Tue, Oct 08, 2019 at 08:20:12PM +0000, bodo.stroesser@ts.fujitsu.com wrote:
> 1) Scan the SCSI specs and add all other missing command codes to the list of
>    Codes to skip
> 
> 2) Create a list of commands that definitely have the LUN field in byte 1 and
>    reset the bits only in those. (Might be better than 1), because I expect new
>    commands to not have the LUN field.)
> 
> 3) Remove the code entirely, because it is no longer needed / useful (?)
> 
> For 1) and 2) an additionally question is, based on what SCSI version the lists would
> have to be created?

(4) limit the clearing of the LUN field to devices that claim
a compliance to SCSI-2 or earlier, as those use the LUN field.
