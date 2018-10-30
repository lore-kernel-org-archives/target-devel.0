From: David Disseldorp <ddiss@suse.de>
Date: Tue, 30 Oct 2018 17:58:46 +0000
Subject: Re: Memory leak in pSCSI backend?
Message-Id: <20181030185846.2b5ea2ef@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <CAJboL95nkVbNDTCPTGJBzusaFA8ZLZT87oCU1otFO=TT=REbCQ@mail.gmail.com>
In-Reply-To: <CAJboL95nkVbNDTCPTGJBzusaFA8ZLZT87oCU1otFO=TT=REbCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi Ben,

Thanks for the report.

On Tue, 30 Oct 2018 09:03:38 +1100, Ben Klein wrote:

> Please let me know if there's any other information I can provide.

Any chance you'd be able to rerun your reproducer with kmemleak logging
enabled? Details can be found at:
https://www.kernel.org/doc/Documentation/dev-tools/kmemleak.rst

Cheers, David
