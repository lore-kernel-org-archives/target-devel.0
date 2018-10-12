From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 12 Oct 2018 16:11:27 +0000
Subject: Re: [PATCH v2 4/5] target: split out helper for cxn timeout error stashing
Message-Id: <1539360687.249485.9.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181012100120.2365-5-ddiss@suse.de>
In-Reply-To: <20181012100120.2365-5-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Fri, 2018-10-12 at 12:01 +-0200, David Disseldorp wrote:
+AD4 +-void iscsit+AF8-fill+AF8-cxn+AF8-timeout+AF8-err+AF8-stats(struct iscsi+AF8-session +ACo-sess)
+AD4 +-+AHs
+AD4 +-	struct iscsi+AF8-portal+AF8-group +ACo-tpg +AD0 sess-+AD4-tpg+ADs
+AD4 +-	struct iscsi+AF8-tiqn +ACo-tiqn +AD0 tpg-+AD4-tpg+AF8-tiqn+ADs
+AD4 +-
+AD4 +-	if (+ACE-tiqn)
+AD4 +-		return+ADs
+AD4 +-
+AD4 +-	spin+AF8-lock+AF8-bh(+ACY-tiqn-+AD4-sess+AF8-err+AF8-stats.lock)+ADs
+AD4 +-	strcpy(tiqn-+AD4-sess+AF8-err+AF8-stats.last+AF8-sess+AF8-fail+AF8-rem+AF8-name,
+AD4 +-			sess-+AD4-sess+AF8-ops-+AD4-InitiatorName)+ADs

There have been too many problems with strcpy() and buffer overflows in the
past. If the source and destination strings both have the same size, please
add a BUILD+AF8-BUG+AF8-ON() statement that verifies that at compile time. If that
not's the case, how about using strlcpy() to make it easy for anyone who
reads the source code that no output buffer overflow will occur?

Thanks,

Bart.
