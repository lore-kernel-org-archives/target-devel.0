From: Florian Westphal <fw@strlen.de>
Date: Mon, 15 Jan 2018 10:41:45 +0000
Subject: Re: iscsi target regression due to "tcp: remove prequeue support" patch
Message-Id: <20180115104145.GB27085@breakpoint.cc>
List-Id: <target-devel.vger.kernel.org>
References: <5A32128D.4050207@redhat.com>
In-Reply-To: <5A32128D.4050207@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Mike Christie <mchristi@redhat.com> wrote:
 
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
> Is the iscsi target doing something incorrect in its use of
> sk_data_ready and sock_recvmsg or is the tcp patch at fault?

I have not received any bug reports except this one.

I also have a hard time following iscsi code flow.

> Dec 13 17:55:01 rhel73n1 kernel: Starting login_timer for kworker/2:2/1829
> Dec 13 17:55:01 rhel73n1 kernel: rx_loop: 48, total_rx: 48, data: 48
> Dec 13 17:55:01 rhel73n1 kernel: Got Login Command, Flags 0x81, ITT: 0x00000000, CmdSN: 0x00000000, ExpStatSN: 0xf86dc69b, CID: 0, Length: 65
> Dec 13 17:55:01 rhel73n1 kernel: Entering iscsi_target_sk_data_ready: conn: ffff88b35cbb3000

Looks like things are fine up to this point.

> Dec 13 17:55:01 rhel73n1 kernel: Got LOGIN_FLAGS_READ_ACTIVE=1, conn: ffff88b35cbb3000 >>>>

This makes things return early from sk_data_ready callback.

> Dec 13 17:55:01 rhel73n1 systemd[1]: Created slice User Slice of pcp.
> Dec 13 17:55:01 rhel73n1 systemd[1]: Starting User Slice of pcp.
> Dec 13 17:55:01 rhel73n1 systemd[1]: Started Session 8 of user pcp.
> Dec 13 17:55:01 rhel73n1 systemd[1]: Starting Session 8 of user pcp.
> Dec 13 17:55:01 rhel73n1 CROND[1848]: (pcp) CMD ( /usr/libexec/pcp/bin/pmlogger_check -C)
> Dec 13 17:55:01 rhel73n1 systemd[1]: Removed slice User Slice of pcp.
> Dec 13 17:55:01 rhel73n1 systemd[1]: Stopping User Slice of pcp.

irrelevant.

> Dec 13 17:55:16 rhel73n1 kernel: Entering iscsi_target_sk_state_change
> Dec 13 17:55:16 rhel73n1 kernel: __iscsi_target_sk_check_close: TCP_CLOSE_WAIT|TCP_CLOSE,returning FALSE
> Dec 13 17:55:16 rhel73n1 kernel: __iscsi_target_sk_close_change: state: 1
> Dec 13 17:55:16 rhel73n1 kernel: Got LOGIN_FLAGS_READ_ACTIVE=1 sk_state_change conn: ffff88b35cbb3000
> Dec 13 17:55:16 rhel73n1 kernel: rx_loop: 68, total_rx: 68, data: 68

So it looks like all data is there, and probably has been there all the
past 15 seconds, but nothing noticed.

Why is LOGIN_FLAGS_READ_ACTIVE set?  Who sets this?  Who is supposed to clear that?
Why does it exist in first place?
