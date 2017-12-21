From: Sagi Grimberg <sagi@grimberg.me>
Date: Thu, 21 Dec 2017 08:08:29 +0000
Subject: Re: stuck iscsi/iser target with linux-4.15.0-rc1
Message-Id: <dc2589ef-b585-09be-c5d1-dce408b99d24@grimberg.me>
List-Id: <target-devel.vger.kernel.org>
References: <000801d36ac6$9e9f5f70$dbde1e50$@opengridcomputing.com>
 <0ba7e891-f020-26fb-9945-9e824332593c@grimberg.me>
 <018901d36d17$6a703410$3f509c30$@opengridcomputing.com>
 <1dee9f68-a81b-b7b8-9e70-e0ef5c63c520@grimberg.me>
 <018001d37917$a7d85e20$f7891a60$@opengridcomputing.com>
In-Reply-To: <018001d37917$a7d85e20$f7891a60$@opengridcomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'target-devel' <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


> Hey Sagi,
> 
> I found my bug: If a wr chain is posted to iw_cxgb4  and needs to be flushed, only the first wr in the chain was being flushed.  The rest never completed.  This completion leak was causing the failure to deref IO commands...

Good to know,

Do does any of the other discussions in the thread still apply? Anything
that I still need to look at?
