From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 12 Oct 2018 17:14:44 +0000
Subject: Re: [PATCH 08/17] target/core: Make compare_and_write_callback() accept NULL as third argument
Message-Id: <1539364484.249485.10.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20180917213554.987-9-bvanassche@acm.org>
In-Reply-To: <20180917213554.987-9-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sat, 2018-10-06 at 14:07 +-0200, Christoph Hellwig wrote:
+AD4 On Mon, Sep 17, 2018 at 02:35:45PM -0700, Bart Van Assche wrote:
+AD4 +AD4 This patch does not change any functionality. A later patch in this series,
+AD4 +AD4 namely +ACI-Make ABORT and LUN RESET handling synchronous+ACI, depends on this
+AD4 +AD4 patch.
+AD4 
+AD4 I'd be tempted to just merge it into that patch to make that fact more
+AD4 obvious.

OK, I will do that.

Thanks,

Bart.
