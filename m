From: David Disseldorp <ddiss@suse.de>
Date: Mon, 05 Nov 2018 19:09:10 +0000
Subject: Re: [PATCH] target/core: Make it safe to pass NULL as third argument to compare_and_write_callback()
Message-Id: <20181105200910.47b819b3@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181105172317.248955-1-bvanassche@acm.org>
In-Reply-To: <20181105172317.248955-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, 5 Nov 2018 18:55:23 +0100, David Disseldorp wrote:

> IIUC, this still leaves compare_and_write_post() with a potential NULL
> post_ret deref.

Actually, I missed that aa73237dcb2d also added the if(success) check
there. Either way, I find your latter fix easier to follow.

Cheers, David
