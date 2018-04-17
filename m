From: Christoph Hellwig <hch@lst.de>
Date: Tue, 17 Apr 2018 15:19:28 +0000
Subject: Re: [PATCH] target: Fix Fortify_panic kernel exception
Message-Id: <20180417151928.GA25787@lst.de>
List-Id: <target-devel.vger.kernel.org>
References: <1523566722-24667-1-git-send-email-bryantly@linux.vnet.ibm.com> <20180413164452.GA22904@lst.de> <7b51a970-942e-2ac5-4762-07d6aec82d09@linux.vnet.ibm.com>
In-Reply-To: <7b51a970-942e-2ac5-4762-07d6aec82d09@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, nab@linux-iscsi.org, martin.petersen@oracle.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-block@vger.kernel.org, stable@vger.kernel.org

On Tue, Apr 17, 2018 at 10:18:17AM -0500, Bryant G. Ly wrote:
> 
> On 4/13/18 11:44 AM, Christoph Hellwig wrote:
> 
> > The patch looks fine, but in general I think descriptions of what
> > you fixed in the code or more important than starting out with
> > a backtrace.
> >
> > E.g. please explain what was wrong, how you fixed it and only after
> > that mention how it was caught.  (preferably without the whole trace)
> >
> I will put the trace at the end next time. Do you want me to re-submit
> with it moved?

Please do.
