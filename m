From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 16 Nov 2018 15:58:41 +0000
Subject: Re: [PATCH 02/10] target/core: Use kvcalloc() instead of open-coding it
Message-Id: <1542383921.100259.48.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181106171718.89594-3-bvanassche@acm.org>
In-Reply-To: <20181106171718.89594-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Fri, 2018-11-16 at 14:10 +-0100, David Disseldorp wrote:
+AD4 On Thu, 08 Nov 2018 15:17:45 -0800, Bart Van Assche wrote:
+AD4 +AD4 What makes you think that I dropped any of the +AF8AXw-GFP flags? The only purpose
+AD4 +AD4 of the +AF8AXw-GFP+AF8-NOWARN and +AF8AXw-GFP+AF8-RETRY+AF8-MAYFAIL flags is to make kcalloc() fail
+AD4 +AD4 quickly and silently.
+AD4 
+AD4 Are you confusing +AF8AXw-GFP+AF8-RETRY+AF8-MAYFAIL with +AF8AXw-GFP+AF8-NORETRY here?

No. Passing +AF8AXw-GFP+AF8-RETRY+AF8-MAYFAIL to a memory allocation function makes the memory
allocator try less hard than without that flag. From should+AF8-continue+AF8-reclaim():

	/+ACo
	 +ACo For +AF8AXw-GFP+AF8-RETRY+AF8-MAYFAIL allocations, stop reclaiming if the
	 +ACo full LRU list has been scanned and we are still failing
	 +ACo to reclaim pages. This full LRU scan is potentially
	 +ACo expensive but a +AF8AXw-GFP+AF8-RETRY+AF8-MAYFAIL caller really wants to succeed
	 +ACo-/

+AD4 +AD4 I'm not dropping these flags: as one can see in the
+AD4 +AD4 kvmalloc+AF8-node() implementation that function passes these flags to
+AD4 +AD4 kmalloc+AF8-node(). The source code I'm referring to is available in mm/util.c.
+AD4 
+AD4 I see that (given tag+AF8-num +ACo tag+AF8-size +AD4 PAGE+AF8-SIZE) +AF8AXw-GFP+AF8-NOWARN is added
+AD4 by kvmalloc+AF8-node(), but +AF8AXw-GFP+AF8-RETRY+AF8-MAYFAIL is dropped with your change,
+AD4 which sees +AF8AXw-GFP+AF8-NORETRY added in the +AD4-PAGE+AF8-SIZE path.

That's right. If you want I can mention this in the patch description.

Bart.
