From: David Disseldorp <ddiss@suse.de>
Date: Wed, 13 Jun 2018 09:43:44 +0000
Subject: Re: [PATCH] lib/percpu_ida.c: don't do alloc from per-CPU list if there is none
Message-Id: <20180613114344.7900693c@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20180613075830.c3zeva52fuj6fxxv@linutronix.de>
In-Reply-To: <20180613075830.c3zeva52fuj6fxxv@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, 13 Jun 2018 09:58:30 +0200, Sebastian Andrzej Siewior wrote:

> In commit 804209d8a009 ("lib/percpu_ida.c: use _irqsave() instead of
> local_irq_save() + spin_lock") I inlined alloc_local_tag() and mixed up
> the >= check from percpu_ida_alloc() with the one in alloc_local_tag().
> 
> Don't alloc from per-CPU freelist if ->nr_free is zero.
> 
> Fixes: 804209d8a009 ("lib/percpu_ida.c: use _irqsave() instead of local_irq_save() + spin_lock")
> Reported-by: David Disseldorp <ddiss@suse.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> 
> David, could please check if this works for you?

Works for me. Thanks for the quick fix, Sebastian.

Cheers, David
