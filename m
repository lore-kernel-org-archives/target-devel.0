From: Christoph Hellwig <hch@infradead.org>
Date: Sat, 17 Mar 2018 08:25:48 +0000
Subject: Re: [PATCH] [RFC] target/file: add support of direct and async I/O
Message-Id: <20180317082548.GA26833@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20180309004259.16052-1-avagin@openvz.org>
In-Reply-To: <20180309004259.16052-1-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Fri, Mar 16, 2018 at 05:13:25PM -0700, Andrei Vagin wrote:
> > Please call the methods directly instead of through the wrappers.
> 
> Do you mean to call file->f_op->write_iter(kio, iter) instead of
> call_write_iter()? What is wrong with these wrappers?

Yes. They are completely pointless and just obsfucate the code.
I plan to remove them eventually.
