From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 05 Nov 2018 19:15:31 +0000
Subject: Re: [PATCH] target/core: Make it safe to pass NULL as third argument to compare_and_write_callback()
Message-Id: <1541445331.196084.150.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181105172317.248955-1-bvanassche@acm.org>
In-Reply-To: <20181105172317.248955-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, 2018-11-05 at 18:55 +-0100, David Disseldorp wrote:
+AD4 Hi Bart,
+AD4 
+AD4 On Mon,  5 Nov 2018 09:23:17 -0800, Bart Van Assche wrote:
+AD4 
+AD4 +AD4 Fixes: aa73237dcb2d (+ACI-scsi: target/core: Always call transport+AF8-complete+AF8-callback() upon failure+ACI)
+AD4 
+AD4 ...
+AD4 +AD4 This patch fixes a bug that was introduced during the merge window. Please consider
+AD4 +AD4 this patch for a v4.20-rc+ADw-n+AD4 kernel.
+AD4 +AD4 
+AD4 +AD4  drivers/target/target+AF8-core+AF8-sbc.c +AHw 3 +-+--
+AD4 +AD4  1 file changed, 2 insertions(+-), 1 deletion(-)
+AD4 +AD4 
+AD4 +AD4 diff --git a/drivers/target/target+AF8-core+AF8-sbc.c b/drivers/target/target+AF8-core+AF8-sbc.c
+AD4 +AD4 index 1ac1f7d2e6c9..7c8433e32906 100644
+AD4 +AD4 --- a/drivers/target/target+AF8-core+AF8-sbc.c
+AD4 +AD4 +-+-+- b/drivers/target/target+AF8-core+AF8-sbc.c
+AD4 +AD4 +AEAAQA -480,7 +-480,8 +AEAAQA static sense+AF8-reason+AF8-t compare+AF8-and+AF8-write+AF8-callback(struct se+AF8-cmd +ACo-cmd, bool succes
+AD4 +AD4  	if (cmd-+AD4-scsi+AF8-status) +AHs
+AD4 +AD4  		pr+AF8-debug(+ACI-compare+AF8-and+AF8-write+AF8-callback: non zero scsi+AF8-status:+ACI
+AD4 +AD4  			+ACI 0x+ACU-02x+AFw-n+ACI, cmd-+AD4-scsi+AF8-status)+ADs
+AD4 +AD4 -		+ACo-post+AF8-ret +AD0 1+ADs
+AD4 +AD4 +-		if (post+AF8-ret)
+AD4 +AD4 +-			+ACo-post+AF8-ret +AD0 1+ADs
+AD4 +AD4  		if (cmd-+AD4-scsi+AF8-status +AD0APQ SAM+AF8-STAT+AF8-CHECK+AF8-CONDITION)
+AD4 +AD4  			ret +AD0 TCM+AF8-LOGICAL+AF8-UNIT+AF8-COMMUNICATION+AF8-FAILURE+ADs
+AD4 +AD4  		goto out+ADs
+AD4 
+AD4 IIUC, this still leaves compare+AF8-and+AF8-write+AF8-post() with a potential NULL
+AD4 post+AF8-ret deref. My preference would be to just go back to having the
+AD4 unused variable provided by the transport+AF8-generic+AF8-request+AF8-failure()
+AD4 caller.

Hi David,

A second version that follows your proposal but that does not reintroduce the
+ACI-unused variable+ACI warning has been posted. Further feedback is welcome.

Bart.
