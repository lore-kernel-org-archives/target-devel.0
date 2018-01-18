From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Thu, 18 Jan 2018 08:38:18 +0000
Subject: Re: iscsi target regression due to "tcp: remove prequeue support" patch
Message-Id: <1516264698.24576.240.camel@haakon3.daterainc.com>
List-Id: <target-devel.vger.kernel.org>
References: <5A32128D.4050207@redhat.com>
         <20180115104145.GB27085@breakpoint.cc>
In-Reply-To: <20180115104145.GB27085@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Florian Westphal <fw@strlen.de>
Cc: Mike Christie <mchristi@redhat.com>, target-devel <target-devel@vger.kernel.org>, Linux-netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>

Hi Florian,

(Adding netdev + DaveM CC')

Thanks for the response.  Comments below.

On Mon, 2018-01-15 at 11:41 +0100, Florian Westphal wrote:
> Mike Christie <mchristi@redhat.com> wrote:
>  
> > Dec 13 17:55:01 rhel73n1 kernel: Got Login Command, Flags 0x81, ITT:
> > 0x00000000, CmdSN: 0x00000000, ExpStatSN: 0xf86dc69b, CID: 0, Length: 65
> > 
> > we have got a login command and we seem to then go into
> > iscsit_do_rx_data -> sock_recvmsg
> > 
> > We seem to get stuck in there though, because we stay blocked until:
> > 
> > Dec 13 17:55:01 rhel73n1 kernel: Entering iscsi_target_sk_data_ready:
> > conn: ffff88b35cbb3000
> > Dec 13 17:55:01 rhel73n1 kernel: Got LOGIN_FLAGS_READ_ACTIVE=1, conn:
> > ffff88b35cbb3000 >>>>
> > 
> > where initiator side timeout fires 15 seconds later and it disconnects
> > the tcp connection, and we eventually break out of the recvmsg call:
> > 
> > Dec 13 17:55:16 rhel73n1 kernel: Entering iscsi_target_sk_state_change
> > Dec 13 17:55:16 rhel73n1 kernel: __iscsi_target_sk_check_close:
> > TCP_CLOSE_WAIT|TCP_CLOSE,returning FALSE
> > 
> > ....
> > 
> > Dec 13 17:55:16 rhel73n1 kernel: rx_loop: 68, total_rx: 68, data: 68
> > Dec 13 17:55:16 rhel73n1 kernel: iscsi_target_do_login_rx after
> > rx_login_io, ffff88b35cbb3000, kworker/2:2:1829
> > 
> > Is the iscsi target doing something incorrect in its use of
> > sk_data_ready and sock_recvmsg or is the tcp patch at fault?
> 
> I have not received any bug reports except this one.
> 
> I also have a hard time following iscsi code flow.
> 
> > Dec 13 17:55:01 rhel73n1 kernel: Starting login_timer for kworker/2:2/1829
> > Dec 13 17:55:01 rhel73n1 kernel: rx_loop: 48, total_rx: 48, data: 48
> > Dec 13 17:55:01 rhel73n1 kernel: Got Login Command, Flags 0x81, ITT: 0x00000000, CmdSN: 0x00000000, ExpStatSN: 0xf86dc69b, CID: 0, Length: 65
> > Dec 13 17:55:01 rhel73n1 kernel: Entering iscsi_target_sk_data_ready: conn: ffff88b35cbb3000
> 
> Looks like things are fine up to this point.
> 
> > Dec 13 17:55:01 rhel73n1 kernel: Got LOGIN_FLAGS_READ_ACTIVE=1, conn: ffff88b35cbb3000 >>>>
> 
> This makes things return early from sk_data_ready callback.

Correct.

This is existing behavior for individual iscsi_conn login delayed_work
contexts (conn->login_work) which have not yet returned from a previous
sock_recvmsg(..., MSG_WAITALL) blocking call.

This causes the next iscsi_target_sk_data_ready() callback to hit
LOGIN_FLAGS_READ_ACTIVE=1, and return immediately without kicking
conn->login_work to process iscsi_target_do_login_rx() ->
sock_recvmsg(..., MSG_WAITALL).

> > Dec 13 17:55:16 rhel73n1 kernel: Entering iscsi_target_sk_state_change
> > Dec 13 17:55:16 rhel73n1 kernel: __iscsi_target_sk_check_close: TCP_CLOSE_WAIT|TCP_CLOSE,returning FALSE
> > Dec 13 17:55:16 rhel73n1 kernel: __iscsi_target_sk_close_change: state: 1
> > Dec 13 17:55:16 rhel73n1 kernel: Got LOGIN_FLAGS_READ_ACTIVE=1 sk_state_change conn: ffff88b35cbb3000
> > Dec 13 17:55:16 rhel73n1 kernel: rx_loop: 68, total_rx: 68, data: 68
> 
> So it looks like all data is there, and probably has been there all the
> past 15 seconds, but nothing noticed.
> 
> Why is LOGIN_FLAGS_READ_ACTIVE set?  Who sets this?  Who is supposed to clear that?
> Why does it exist in first place?

The bit is set in iscsi_target_sk_data_ready() when conn->login_work is
not already blocked by sock_recvmsg(..., MSG_WAITALL).  Once it's set,
conn->login_work is kicked to run iscsi_target_do_login_rx() ->
sock_recvmsg(..., MSG_WAITALL) which blocks waiting for the next 48 byte
login request PDU + payload.

Once the active conn->login_work context in iscsi_target_do_login_rx()
returns from sock_recvmsg(..., MSG_WAITALL) with full login request PDU
+ payload bytes, the bit is cleared.

AFAICT, there was a wake_up removed by commit e7942d063 that results in
multi iscsi login PDU authentication exchanges blocking on a incoming
login request payload.

So I don't know if this is a pre-existing bug hidden in iscsi-target by
tcp prequeue login, or not...?

It would indicate users providing their own ->sk_data_ready() callback
must be responsible for waking up a kthread context blocked on
sock_recvmsg(..., MSG_WAITALL), when a second ->sk_data_ready() is
received before the first sock_recvmsg(..., MSG_WAITALL) completes.

I don't know if this is a pre-existing bug in iscsi-target hidden by tcp
prequeue logic, or not...?

Any ideas..?

