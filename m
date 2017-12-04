From: Sagi Grimberg <sagi@grimberg.me>
Date: Mon, 04 Dec 2017 18:40:31 +0000
Subject: Re: stuck iscsi/iser target with linux-4.15.0-rc1
Message-Id: <1dee9f68-a81b-b7b8-9e70-e0ef5c63c520@grimberg.me>
List-Id: <target-devel.vger.kernel.org>
References: <000801d36ac6$9e9f5f70$dbde1e50$@opengridcomputing.com>
 <0ba7e891-f020-26fb-9945-9e824332593c@grimberg.me>
 <018901d36d17$6a703410$3f509c30$@opengridcomputing.com>
In-Reply-To: <018901d36d17$6a703410$3f509c30$@opengridcomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Steve Wise <swise@opengridcomputing.com>, 'target-devel' <target-devel@vger.kernel.org>
Cc: linux-rdma@vger.kernel.org


>> Not for a while, can you turn the debug prints in
>> target_wait_for_sess_cmds so we can understand which commands are
>> hanging?
> 
> Here ya go:
> 
> [239800.115739] target_wait_for_sess_cmds: Waiting for se_cmd: ffff88034082c998 t_state: 6, fabric state: 12

Hmm, this means that the command was delegated to isert to send
data+response... Which means we lose a reference put somewhere here.

I'm assuming that this happens before your changes to ib_drain_qp
correct? If this does not happen without your changes it might indicate
that drain_qp is missing an error (or successful?) completion which
would prevent a final reference drop (isert_completion_put).
