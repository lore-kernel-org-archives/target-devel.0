From: Tyrel Datwyler <turtle.in.the.kernel@gmail.com>
Date: Thu, 21 Nov 2019 01:11:12 +0000
Subject: Re: [PATCH] scsi: ibmvscsi_tgt: Remove unneeded variable rc
Message-Id: <25de88a9-b013-f5cc-06c2-3efb1f3f0001@gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <20191101120407.GA9369@saurav>
In-Reply-To: <20191101120407.GA9369@saurav>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Saurav Girepunje <saurav.girepunje@gmail.com>, mikecyr@linux.ibm.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: saurav.girepunje@hotmail.com

On 11/1/19 5:35 AM, Saurav Girepunje wrote:
> Variable rc is not modified in ibmvscsis_srp_i_logout function.
> So remove unneeded variable rc.
> 
> Issue found using coccicheck tool.
> 
> Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>

Reviewed-by: Tyrel Datwyler <tyreld@linux.ibm.com>
