From: David Miller <davem@davemloft.net>
Date: Tue, 31 Jul 2018 21:30:15 +0000
Subject: Re: [PATCH v2 6/9] ide-cd: Remove redundant sense buffer
Message-Id: <20180731.143015.1326547191404152411.davem@davemloft.net>
List-Id: <target-devel.vger.kernel.org>
References: <20180731195155.46664-1-keescook@chromium.org>
        <20180731195155.46664-7-keescook@chromium.org>
In-Reply-To: <20180731195155.46664-7-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: keescook@chromium.org
Cc: axboe@kernel.dk, hch@infradead.org, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, tj@kernel.org, bp@alien8.de, manoj@linux.vnet.ibm.com, mrochs@linux.vnet.ibm.com, ukrishn@linux.vnet.ibm.com, nab@linux-iscsi.org, tglx@linutronix.de, pombredanne@nexb.com, sboyd@codeaurora.org, cyrille.pitchen@free-electrons.com, jgross@suse.com, viresh.kumar@linaro.org, u.kleine-koenig@pengutronix.de, sdharia@codeaurora.org, rdunlap@infradead.org, vinod.koul@intel.com, david.kershner@unisys.com, linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Date: Tue, 31 Jul 2018 12:51:51 -0700

> This is already able to process the sense buffer, so remove the redundant
> parsing during the failure path. This also fixes any possible stale values
> since the prior code did not check the sense length.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: David S. Miller <davem@davemloft.net>
