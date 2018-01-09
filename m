From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Tue, 09 Jan 2018 06:32:21 +0000
Subject: Re: iscsi target regression due to "tcp: remove prequeue support" patch
Message-Id: <1515479541.5327.70.camel@haakon3.daterainc.com>
List-Id: <target-devel.vger.kernel.org>
References: <5A32128D.4050207@redhat.com>
In-Reply-To: <5A32128D.4050207@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <mchristi@redhat.com>
Cc: target-devel <target-devel@vger.kernel.org>, fw@strlen.de, Linux-netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>

Hi MNC & Florian,

(Adding net-dev + DaveM CC')

Catching up on pre-holiday threads, thanks for the heads up.

Comments below.

On Wed, 2017-12-13 at 23:56 -0600, Mike Christie wrote:
> Hey Nick and Florian,
> 
> Starting in 4.14 iscsi logins will fail around 50% of the time.
> 
> I git bisected the issue down to this commit:
> 
> commit e7942d0633c47c791ece6afa038be9cf977226de
> Author: Florian Westphal <fw@strlen.de>
> Date:   Sun Jul 30 03:57:18 2017 +0200
> 
>     tcp: remove prequeue support
> 
> Nick, attached is the iscsi target log info when the login fails.
> 
> You can see at:
> 
> Dec 13 17:55:01 rhel73n1 kernel: Got Login Command, Flags 0x81, ITT:
> 0x00000000, CmdSN: 0x00000000, ExpStatSN: 0xf86dc69b, CID: 0, Length: 65
> 
> we have got a login command and we seem to then go into
> iscsit_do_rx_data -> sock_recvmsg
> 
> We seem to get stuck in there though, because we stay blocked until:
> 
> Dec 13 17:55:01 rhel73n1 kernel: Entering iscsi_target_sk_data_ready:
> conn: ffff88b35cbb3000
> Dec 13 17:55:01 rhel73n1 kernel: Got LOGIN_FLAGS_READ_ACTIVE=1, conn:
> ffff88b35cbb3000 >>>>
> 
> where initiator side timeout fires 15 seconds later and it disconnects
> the tcp connection, and we eventually break out of the recvmsg call:
> 
> Dec 13 17:55:16 rhel73n1 kernel: Entering iscsi_target_sk_state_change
> Dec 13 17:55:16 rhel73n1 kernel: __iscsi_target_sk_check_close:
> TCP_CLOSE_WAIT|TCP_CLOSE,returning FALSE
> 
> ....
> 
> Dec 13 17:55:16 rhel73n1 kernel: rx_loop: 68, total_rx: 68, data: 68
> Dec 13 17:55:16 rhel73n1 kernel: iscsi_target_do_login_rx after
> rx_login_io, ffff88b35cbb3000, kworker/2:2:1829
> 

Ok, the 3rd third login request payload (65 + 3 padded to 68 bytes)
containing CHAP_N + CHAP_R keys remains blocked on sock_recvmsg(), until
TPG login_timeout subsequently fires after 15 seconds of inactivity to
terminate this login attempt.

> Is the iscsi target doing something incorrect in its use of
> sk_data_ready and sock_recvmsg or is the tcp patch at fault?

From the logs, sk_data_ready() -> iscsi_target_sk_data_ready() callbacks
appear firing as expected.

iscsi-target login does iscsit_rx_do_data() -> rx_data() ->
sock_recvmsg(..., MSG_WAITALL) from a system_wq kworker process context
after iscsi_target_sk_data_ready() callback queues up
iscsi_conn->login_work for execution, and sock_recvmsg() uses a single
struct kvec iovec for struct msg_hdr.

AFAICT, iscsi-target uses blocking kernel socket reads from process
context, similar to kernel_recvmsg(..., MSG_WAITALL) with DRBD.

Florian + DaveM, any idea why the removal of prequeue support is having
an effect here..?

