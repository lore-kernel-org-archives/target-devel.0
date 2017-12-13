From: "Steve Wise" <swise@opengridcomputing.com>
Date: Wed, 13 Dec 2017 22:35:57 +0000
Subject: RE: stuck iscsi/iser target with linux-4.15.0-rc1
Message-Id: <01c901d37462$be431240$3ac936c0$@opengridcomputing.com>
List-Id: <target-devel.vger.kernel.org>
References: <000801d36ac6$9e9f5f70$dbde1e50$@opengridcomputing.com> <0ba7e891-f020-26fb-9945-9e824332593c@grimberg.me> <018901d36d17$6a703410$3f509c30$@opengridcomputing.com> <1dee9f68-a81b-b7b8-9e70-e0ef5c63c520@grimberg.me> <01bd01d3745a$f4bc82f0$de3588d0$@opengridcomputing.com> <01c701d37462$87371f30$95a55d90$@opengridcomputing.com>
In-Reply-To: <01c701d37462$87371f30$95a55d90$@opengridcomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'target-devel' <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> 
> I tried with 4.14.0 and got the same results.  I then backed up to 4.9.44 and I can
> discovery/login again.  I'll see if I can bisect this out, unless somebody knows
> about current problems with iser?

Actually, 4.9.44 has the same issue.  It works with iscsi/tcp, not iser. I must be doing something wrong in my setup.  


---
This email has been checked for viruses by AVG.
http://www.avg.com

