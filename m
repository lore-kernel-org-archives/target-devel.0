From: Christoph Hellwig <hch@infradead.org>
Date: Wed, 21 Mar 2018 18:50:01 +0000
Subject: Re: [PATCH] target: Use WARNON_NON_RT(!irqs_disabled())
Message-Id: <20180321185001.GB11249@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20180321153854.GB24312@kernel.org>
In-Reply-To: <20180321153854.GB24312@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, linux-rt-users <linux-rt-users@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, linux-scsi@vger.kernel.org, Daniel Bristot de Oliveira <daniel@bristot.me>, Luis Claudio =?iso-8859-1?Q?R=2E_Gon=E7alves?= <lclaudio@redhat.com>, Clark Williams <williams@redhat.com>, target-devel@vger.kernel.org

On Wed, Mar 21, 2018 at 12:38:54PM -0300, Arnaldo Carvalho de Melo wrote:
>  	assert_spin_locked(&cmd->t_state_lock);
> -	WARN_ON_ONCE(!irqs_disabled());
> +	WARN_ON_ONCE_NONRT(!irqs_disabled());

I can't find where WARN_ON_ONCE_NONRT is defined.

That being said I think we can just kill these asserts.  If we have irqs
disabled spin_unlock_irq a few lines below should already warn.
