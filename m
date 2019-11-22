From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Fri, 22 Nov 2019 01:48:29 +0000
Subject: Re: [PATCH] scsi: ibmvscsi_tgt: Remove unneeded variable rc
Message-Id: <yq1blt4d6ky.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20191101120407.GA9369@saurav>
        <25de88a9-b013-f5cc-06c2-3efb1f3f0001@gmail.com>
In-Reply-To: <25de88a9-b013-f5cc-06c2-3efb1f3f0001@gmail.com> (Tyrel
        Datwyler's message of "Wed, 20 Nov 2019 17:11:12 -0800")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Saurav Girepunje <saurav.girepunje@gmail.com>
Cc: Tyrel Datwyler <turtle.in.the.kernel@gmail.com>, mikecyr@linux.ibm.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, saurav.girepunje@hotmail.com


>> Variable rc is not modified in ibmvscsis_srp_i_logout function.  So
>> remove unneeded variable rc.
>> 
>> Issue found using coccicheck tool.
>> 
>> Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
>
> Reviewed-by: Tyrel Datwyler <tyreld@linux.ibm.com>

Applied to 5.5/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
