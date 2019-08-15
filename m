From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Thu, 15 Aug 2019 02:00:49 +0000
Subject: Re: [PATCH v2] tcmu: avoid use-after-free after command timeout
Message-Id: <yq1h86j2nn2.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190811182510.1706-1-dmitry.fomichev@wdc.com>
In-Reply-To: <20190811182510.1706-1-dmitry.fomichev@wdc.com> (Dmitry
        Fomichev's message of "Sun, 11 Aug 2019 11:25:10 -0700")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, target-devel@vger.kernel.org, Mike Christie <mchristi@redhat.com>, Bart Van Assche <bvanassche@acm.org>, Damien Le Moal <damien.lemoal@wdc.com>


Dmitry,

> In tcmu_handle_completion() function, the variable called read_len is
> always initialized with a value taken from se_cmd structure. If this
> function is called to complete an expired (timed out) out command, the
> session command pointed by se_cmd is likely to be already deallocated
> by the target core at that moment. As the result, this access triggers
> a use-after-free warning from KASAN.

Applied to 5.3/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
