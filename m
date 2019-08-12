From: Mike Christie <mchristi@redhat.com>
Date: Mon, 12 Aug 2019 15:30:19 +0000
Subject: Re: [PATCH v2] tcmu: avoid use-after-free after command timeout
Message-Id: <5D51860B.1060902@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190811182510.1706-1-dmitry.fomichev@wdc.com>
In-Reply-To: <20190811182510.1706-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dmitry Fomichev <dmitry.fomichev@wdc.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, target-devel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Cc: Damien Le Moal <damien.lemoal@wdc.com>

On 08/11/2019 01:25 PM, Dmitry Fomichev wrote:
> In tcmu_handle_completion() function, the variable called read_len is
> always initialized with a value taken from se_cmd structure. If this
> function is called to complete an expired (timed out) out command, the
> session command pointed by se_cmd is likely to be already deallocated by
> the target core at that moment. As the result, this access triggers a
> use-after-free warning from KASAN.
> 
> This patch fixes the code not to touch se_cmd when completing timed out
> TCMU commands. It also resets the pointer to se_cmd at the time when the
> TCMU_CMD_BIT_EXPIRED flag is set because it is going to become invalid
> after calling target_complete_cmd() later in the same function,
> tcmu_check_expired_cmd().
> 
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> ---

Acked-by: Mike Christie <mchristi@redhat.com>
