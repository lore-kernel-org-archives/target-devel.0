From: Chris Leech <cleech@redhat.com>
Date: Mon, 10 Dec 2018 18:28:35 +0000
Subject: Re: BUG in copy_page_to_iter() when iscsi sets ENABLE_CLUSTERING
Message-Id: <20181210182835.GA779288@straylight.hirudinean.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181205200940.81D81BD4D4@localhost>
In-Reply-To: <20181205200940.81D81BD4D4@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, Dec 05, 2018 at 12:09:40PM -0800, Lee Duncan wrote:
> I recently found what I believe is a bug, and I'd appreciate feedback
> on if that is correct, and if so how to proceed.

... 

> I used the same system for both the iSCSI initiator (using open-iscsi)
> and the iscsi target (using targetcli-fb). [I believe you _could_ use
> a different system for the initiator, but I did not test this.]

Thanks for sharing detailed reproduction steps Lee.  I was able to
recreate this pretty easily, but I also tried between different
initiator and target VMs and was not able to reproduce in that setup.
So this might be specific to loopback operation, but it seems like we'll
have to dig in to see the exact structure of what's causing the problem
to know for sure.

- Chris
