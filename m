From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 13 Nov 2019 01:15:39 +0000
Subject: Re: [PATCH 0/3] Three reliability improvements
Message-Id: <yq1sgmsshj8.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20191112035752.8338-1-bvanassche@acm.org>
In-Reply-To: <20191112035752.8338-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Bart,

> - The patch that declares target_release_reservation() static has been
> left out because a patch in this series introduces a call to that
> function outside the file in which that function has been defined.

OK, I'll drop it again. Thought this series replaced patch two of the
first.

-- 
Martin K. Petersen	Oracle Linux Engineering
