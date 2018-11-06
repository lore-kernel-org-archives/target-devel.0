From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Tue, 06 Nov 2018 03:18:13 +0000
Subject: Re: [PATCH v3] target/core: Avoid that a kernel oops is triggered when COMPARE AND WRITE fails
Message-Id: <yq1lg667v2i.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20181106004459.5621-1-bvanassche@acm.org>
In-Reply-To: <20181106004459.5621-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Bart,

> Fixes: aa73237dcb2d ("scsi: target/core: Always call transport_complete_callback() upon failure")

Applied to 4.20/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
