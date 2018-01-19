From: Mike Christie <mchristi@redhat.com>
Date: Fri, 19 Jan 2018 04:28:39 +0000
Subject: Re: iscsi target regression due to "tcp: remove prequeue support" patch
Message-Id: <5A6173F7.2050905@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <5A32128D.4050207@redhat.com>
 <20180115104145.GB27085@breakpoint.cc>
 <1516264698.24576.240.camel@haakon3.daterainc.com>
 <20180118151043.GA21673@breakpoint.cc>
In-Reply-To: <20180118151043.GA21673@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Florian Westphal <fw@strlen.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, Linux-netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>

On 01/18/2018 09:10 AM, Florian Westphal wrote:
>> It would indicate users providing their own ->sk_data_ready() callback
>> must be responsible for waking up a kthread context blocked on
>> sock_recvmsg(..., MSG_WAITALL), when a second ->sk_data_ready() is
>> received before the first sock_recvmsg(..., MSG_WAITALL) completes.
> 
> I agree, it looks like we need something like this?
> (not even build tested):
> 
> diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
> index b686e2ce9c0e..3723f8f419aa 100644
> --- a/drivers/target/iscsi/iscsi_target_nego.c
> +++ b/drivers/target/iscsi/iscsi_target_nego.c
> @@ -432,6 +432,9 @@ static void iscsi_target_sk_data_ready(struct sock *sk)
>         if (test_and_set_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags)) {
>                 write_unlock_bh(&sk->sk_callback_lock);
>                 pr_debug("Got LOGIN_FLAGS_READ_ACTIVE=1, conn: %p >>>>\n", conn);
> +               if (WARN_ON(iscsi_target_sk_data_ready = conn->orig_data_ready))
> +                       return;
> +               conn->orig_data_ready(sk);
>                 return;

This allows iscsi login to work for me.

I ran it against the target-pending for-next branch.
