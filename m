From: Christoph Hellwig <hch@infradead.org>
Date: Sat, 16 Jun 2018 05:22:50 +0000
Subject: Re: [PATCH 01/33] TCMU PR: first commit to implement TCMU PR
Message-Id: <20180616052250.GA17494@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20180615182342.6239-1-lszhu@suse.com>
In-Reply-To: <20180615182342.6239-1-lszhu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sat, Jun 16, 2018 at 02:23:10AM +0800, Zhu Lingshan wrote:
> These commits and the following intend to implement Persistent
> Reservation operations for TCMU devices.

Err, hell no.

If you are that tightly integrated with the target code that you can
implement persistent reservation you need to use kernel code.
Everything else just creates a way too complex interface.
