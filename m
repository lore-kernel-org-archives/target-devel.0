From: David Disseldorp <ddiss@suse.de>
Date: Sat, 13 Oct 2018 13:34:30 +0000
Subject: Re: [PATCH v2 4/5] target: split out helper for cxn timeout error stashing
Message-Id: <20181013153430.4fcdc7bf@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181012100120.2365-5-ddiss@suse.de>
In-Reply-To: <20181012100120.2365-5-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Fri, 12 Oct 2018 09:11:27 -0700, Bart Van Assche wrote:

> There have been too many problems with strcpy() and buffer overflows in the
> past. If the source and destination strings both have the same size, please
> add a BUILD_BUG_ON() statement that verifies that at compile time. If that
> not's the case, how about using strlcpy() to make it easy for anyone who
> reads the source code that no output buffer overflow will occur?

Both arrays are the same size (ISCSI_IQN_LEN). I'll change this over to
use strlcpy(), as I agree that it helps readability.

Cheers, David
