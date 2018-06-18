From: Christoph Hellwig <hch@infradead.org>
Date: Mon, 18 Jun 2018 11:09:45 +0000
Subject: Re: [PATCH 01/33] TCMU PR: first commit to implement TCMU PR
Message-Id: <20180618110945.GA6507@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20180615182342.6239-1-lszhu@suse.com>
In-Reply-To: <20180615182342.6239-1-lszhu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sat, Jun 16, 2018 at 02:20:12PM -0500, Mike Christie wrote:
> Just wanted to make sure I understood this comment. In Lingshan's
> patches I think he was going to end up calling out to
> userspace/tcmu-runner and there he was going to make ceph calls which
> basically translate PGR operations to ceph requests. Are you saying we
> should just add some kernel module that makes the ceph calls? This would
> then avoid the mess of having the split PGR processing design in this
> patchset?

Yes.
