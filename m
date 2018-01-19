From: Florian Westphal <fw@strlen.de>
Date: Fri, 19 Jan 2018 17:26:29 +0000
Subject: Re: [PATCH target-pending] iscsi-target: make sure to wake up sleeping login worker
Message-Id: <20180119172629.GD21673@breakpoint.cc>
List-Id: <target-devel.vger.kernel.org>
References: <20180119133629.14812-1-fw@strlen.de>
 <1516376785.3606.37.camel@gmail.com>
In-Reply-To: <1516376785.3606.37.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, target-devel@vger.kernel.org, mchristi@redhat.com, nab@linux-iscsi.org, netdev@vger.kernel.org, linux-scsi@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Fri, 2018-01-19 at 14:36 +0100, Florian Westphal wrote:
> > diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
> > index b686e2ce9c0e..3723f8f419aa 100644
> > --- a/drivers/target/iscsi/iscsi_target_nego.c
> > +++ b/drivers/target/iscsi/iscsi_target_nego.c
> > @@ -432,6 +432,9 @@ static void iscsi_target_sk_data_ready(struct sock *sk)
> >  	if (test_and_set_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags)) {
> >  		write_unlock_bh(&sk->sk_callback_lock);
> >  		pr_debug("Got LOGIN_FLAGS_READ_ACTIVE=1, conn: %p >>>>\n", conn);
> > +		if (WARN_ON(iscsi_target_sk_data_ready = conn->orig_data_ready))
> > +			return;
> 
> Is this WARN_ON() belonging to this fix ?
> At least make it WARN_ON_ONCE() or pr_err_once()

Nicholas, I don't know this code at all so it would be good if you could
give advice here (omit all together, WARN_ON_ONCE, ...).

Thanks!
