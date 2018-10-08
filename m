From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 08 Oct 2018 16:46:19 +0000
Subject: Re: [PATCH 07/17] target/core: Use system workqueues for TMF
Message-Id: <1539017179.64374.34.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20180917213554.987-8-bvanassche@acm.org>
In-Reply-To: <20180917213554.987-8-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sun, 2018-10-07 at 21:31 -0700, Nicholas A. Bellinger wrote:
+AD4 There has never been a host environment that requires execution of N
+AD4 TMRs in parallel.

That's wrong. Some time ago Hannes modified the SCSI initiator such that
it can have multiple SCSI abort requests outstanding. That change was made
to speed up SCSI error handling. See also commit e494f6a72839 (+ACIAWw-SCSI+AF0
improved eh timeout handler+ACI) and more in particular the
SCSI+AF8-EH+AF8-ABORT+AF8-SCHEDULED flag that was introduced by that patch.

+AD4 That said, allowing N TMRs to be executed for every device, with NO way
+AD4 to control it's usage dynamically in the field for users is not
+AD4 acceptable.

I think that's also wrong. All target drivers I'm familiar with allocate a
fixed-size pool for SCSI commands and task management functions when a
session is created. In other words, the maximum number of TMFs that are
being processed at any time is limited to the size of that pool. See also
the +ACI-tag+AF8-num+ACI argument of target+AF8-setup+AF8-session().

Bart.
