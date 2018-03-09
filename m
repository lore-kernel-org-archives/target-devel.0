From: Chris Friesen <chris.friesen@windriver.com>
Date: Fri, 09 Mar 2018 21:08:01 +0000
Subject: Bug?  CPU affinity of iSCSI target doesn't abide by kernel boot args
Message-Id: <5AA2F7B1.5050900@windriver.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


I think I've found some suboptimal behaviour in the iSCSI target code, but I'd 
like another opinion.

Just as a caveat, this behaviour was first seen on a CentOS 7 kernel, but 
looking at the code I think it'll behave the same in master.

Basically, the issue is that the iSCSI target code creates a pair of kernel 
threads (one for tx, one for rx) for each connection.  Each pair gets affined to 
the same logical CPU.

The problem is that this affinity does not reflect kernel boot args such as 
"isolcpus", "rcu_nocbs", or "irqaffinity".  Instead, it seems to start at cpu0 
and increment by one for each pair of kernel threads.

This seems less than ideal.  If the sysadmin has tried to ensure certain CPUs 
are available for high-performance/low-latency work, it seems odd for the kernel 
to arbitrarily stick a pair of I/O threads on them.

Am I missing something?  Is there a way to set limits on where these threads are 
placed?

Thanks,
Chris
