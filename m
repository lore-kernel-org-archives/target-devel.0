From: Bart Van Assche <bvanassche@acm.org>
Date: Sat, 24 Oct 2020 04:07:38 +0000
Subject: Re: [PATCH 3/3] scsi: target: core: Change ASCQ for residual write
Message-Id: <e2b215ca-0aa8-bdae-e5bd-292a09d8282e@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20201022172011.42367-1-a.kovaleva@yadro.com>
 <20201022172011.42367-4-a.kovaleva@yadro.com>
In-Reply-To: <20201022172011.42367-4-a.kovaleva@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Anastasia Kovaleva <a.kovaleva@yadro.com>, target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>

On 10/22/20 10:20 AM, Anastasia Kovaleva wrote:
> According to FCP-4 (9.4.2):
> 
>   If the command requested that data beyond the length specified by the
>   FCP_DL field be transferred, then the device server shall set the
>   FCP_RESID_OVER bit (see 9.5.8) to one in the FCP_RSP IU and:
> 
>   a) process the command normally except that data beyond the FCP_DL
>   count shall not be requested or transferred;
> 
>   b) transfer no data and return CHECK CONDITION status with the sense
>   key set to ILLEGAL REQUEST and the additional sense code set to INVALID
>   FIELD IN COMMAND INFORMATION UNIT; or
> 
>   c) may transfer data and return CHECK CONDITION status with the sense
>   key set to ABORTED COMMAND and the additional sense code set to
>   INVALID FIELD IN COMMAND INFORMATION UNIT.
> 
> TCM follows b) and transfers no data for residual writes but returns
> INVALID FIELD IN CDB instead of INVALID FIELD IN COMMAND INFORMATION
> UNIT.
> 
> Change the ASCQ to INVALID FIELD IN COMMAND INFORMATION UNIT to meet the
> standart.

Is FCP the only standard that requires to report INVALID FIELD IN COMMAND
INFORMATION UNIT for residual overflow? I haven't found any similar
requirement in the iSCSI RFC nor in the SRP standard.

Additionally, what benefits does it provide to report a CHECK CONDITION
upon residual overflow? The SCST QLogic FC target driver doesn't do this
as far as I know, is more than ten years old, is widely used and so far
nobody complained about this.

Bart.
