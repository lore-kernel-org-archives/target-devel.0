From: Mike Christie <mchristi@redhat.com>
Date: Mon, 18 May 2020 19:40:22 +0000
Subject: Re: [PATCH v1 target] target: Add initiatorname to NON_EXISTENT_LUN error
Message-Id: <cc4c1a62-ec8d-e0f4-f0ac-8584ec1d1885@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <9b13bb2e1f52f1792cd81850ee95bf3781bb5363.1589759816.git.lance.digby@gmail.com>
In-Reply-To: <9b13bb2e1f52f1792cd81850ee95bf3781bb5363.1589759816.git.lance.digby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lance Digby <lance.digby@gmail.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

On 5/17/20 8:02 PM, Lance Digby wrote:
> The NON_EXISTENT_LUN error can be written without an error condition
> on the initiator responsible. Adding the initiatorname to this message
> will reduce the effort required to fix this when many initiators are
> supported by a target.
> 
> This version ensures the initiator name is also printed on the same
> message in transport_lookup_tmr_lun for consistency.
> 

Reviewed-by: Mike Christie <mchristi@redhat.com>
