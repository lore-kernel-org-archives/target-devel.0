From: Mike Christie <michael.christie@oracle.com>
Date: Wed, 08 Jul 2020 19:30:48 +0000
Subject: Re: [PATCH] scsi: target: cxgbit: check connection state before issuing hardware command
Message-Id: <af826cef-c6be-7e4e-1f49-cecef501d499@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1593621970-3026-1-git-send-email-varun@chelsio.com>
In-Reply-To: <1593621970-3026-1-git-send-email-varun@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 7/1/20 11:46 AM, Varun Prakash wrote:
> Current code does not check connection state before issuing
> header/data digest offload and DDP page size setup hardware
> command.
> 
> Add a connection state check to issue hardware command only
> if connection is in established state.
> 
> Signed-off-by: Varun Prakash <varun@chelsio.com>

Looks ok.

Reviewed-by: Mike Christie <michael.christie@oracle.com>
