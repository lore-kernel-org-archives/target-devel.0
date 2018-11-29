From: David Disseldorp <ddiss@suse.de>
Date: Thu, 29 Nov 2018 13:57:29 +0000
Subject: Re: SPC-3 persistent reservations race condition
Message-Id: <20181129145729.356ce23e@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <3ee76029-a49c-e5ce-39c8-62af5f4ce711@zoner.cz>
In-Reply-To: <3ee76029-a49c-e5ce-39c8-62af5f4ce711@zoner.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Thu, 29 Nov 2018 14:40:34 +0100, Martin Svec wrote:

> Unfortunately I'm not able to reproduce the bug with the libiscsi test too. I tried multiple
> concurrent tests ran in an infinite loop with no luck.

Thanks for trying.

> However, the description of the deadlock
> should be clear enaugh to understand the root cause.

Indeed, it'll just take a bit longer.

Cheers, David
