From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 13 Nov 2019 01:11:16 +0000
Subject: Re: [PATCH 1/2] target/core: Declare target_release_reservation() 'static'
Message-Id: <yq1woc4shqj.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20191111182944.191123-2-bvanassche@acm.org>
In-Reply-To: <20191111182944.191123-2-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Bart,

> Since this function is only used inside the source file in which it has
> been defined, declare it 'static'. See also commit fae43461f8f2 ("scsi:
> target/core: Rework the SPC-2 reservation handling code").

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
