From: "Steve Wise" <swise@opengridcomputing.com>
Date: Tue, 19 Dec 2017 22:21:03 +0000
Subject: RE: stuck iscsi/iser target with linux-4.15.0-rc1
Message-Id: <018001d37917$a7d85e20$f7891a60$@opengridcomputing.com>
List-Id: <target-devel.vger.kernel.org>
References: <000801d36ac6$9e9f5f70$dbde1e50$@opengridcomputing.com> <0ba7e891-f020-26fb-9945-9e824332593c@grimberg.me> <018901d36d17$6a703410$3f509c30$@opengridcomputing.com> <1dee9f68-a81b-b7b8-9e70-e0ef5c63c520@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'target-devel' <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> 
> >
> > Do you have any thoughts on debugging this?  Turning on isert debug is bad
> > because the IO load is very high.  I sort of need something that I can do after it
> > gets stuck.  So I can change the wait_for_completion() to a
> > wait_for_completion_timeout() and if it times out, go figure out what it is
> stuck
> > on.
> 
> This snipit from isert_put_cmd() looks interesting:
> 
> ...
>                         /*
>                          * Check for special case during comp_err where
>                          * WRITE_PENDING has been handed off from core,
>                          * but requires an extra target_put_sess_cmd()
>                          * before transport_generic_free_cmd() below.
>                          */
>                         if (comp_err &&
>                             cmd->se_cmd.t_state = TRANSPORT_WRITE_PENDING) {
>                                 struct se_cmd *se_cmd = &cmd->se_cmd;
> 
>                                 target_put_sess_cmd(se_cmd);
>                         }
> ...

Hey Sagi, 

I found my bug: If a wr chain is posted to iw_cxgb4  and needs to be flushed, only the first wr in the chain was being flushed.  The rest never completed.  This completion leak was causing the failure to deref IO commands...

Steve.





---
This email has been checked for viruses by AVG.
http://www.avg.com

