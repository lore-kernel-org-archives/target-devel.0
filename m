From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Sat, 06 Oct 2018 21:48:04 +0000
Subject: Re: [PATCH 00/17] Make ABORT and LUN RESET handling synchronous
Message-Id: <1538862484.6343.40.camel@haakon3.daterainc.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180917213554.987-1-bvanassche@acm.org>
In-Reply-To: <20180917213554.987-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi Bart & Co,

Well, it's certainly been a while.  This is the type of patch series
that will draw me out of self-imposed retirement, every single time..

Of course, I'm referring to:

https://marc.info/?l=target-devel&m3722310800840&w=2

So the time has come once again to go over this series with a fine
toothed comb.

As per usual, the main areas of focus for review are:

1) Is there a concrete use-case..?

Improvements that significantly alter how multiple fabric drivers and/or
multiple backend drivers interact with target-core require a concrete
use-case.  

Many improvements are obvious because they effect customers and users in
the field, but making significant changes that effect the entire LIO
ecosystem do require a real-world use-case.  Making large functional
changes under of guise of 'style' or 'making it easier to read' is not a
good enough reason on it's own.

2) Does it negativity effect scale, performance, or latency..?

As-is, there are a number vendors (including my own startup) that ship
platforms utilizing upstream LIO with hard requirements for ~1K unique
backends (/sys/kernel/config/target/core/$HBA/$DEV/) plus ~1k unique
target endpoints (/sys/kernel/config/target/$FABRIC/$WWN/) plus ~1k
unique tenants on a single physical machine.

Because of this long standing requirement for scale + performance going
back to the earliest days of LIO + configfs, changes that introduce
global locking, global variables, global work-queues, and/or unnecessary
blocking + synchronization are a complete non-starter.

3) Have comments from previous patches been addressed..?

Looking at the history, I'm commented on this series in detail at least
*seven* times over the last three years.

Every time this series ending up not getting merged because my questions
and concerns where either dismissed, or outright ignored.  So at some
point, I got tired of putting in effort that was not reciprocated at the
other end.

That all said, you still get the benefit of doubt on this series.
However, for those specific patches that have already been reviewed and
commented on in detail numerous times, you will need to answer to those
questions.  I'll add them as references inline as necessary.

Thank you.
