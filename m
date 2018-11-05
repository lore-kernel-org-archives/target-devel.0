From: David Disseldorp <ddiss@suse.de>
Date: Mon, 05 Nov 2018 23:19:30 +0000
Subject: Re: [PATCH] target/core: Avoid that a kernel oops can be triggered when an XCOPY command fails
Message-Id: <20181106001930.39cba3bd@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181105184011.94041-1-bvanassche@acm.org>
In-Reply-To: <20181105184011.94041-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon,  5 Nov 2018 10:40:11 -0800, Bart Van Assche wrote:

> Avoid that a kernel oops can be triggered when an XCOPY command fails

FWIW, that should be COMPARE_AND_WRITE instead of XCOPY.

Cheers, David
