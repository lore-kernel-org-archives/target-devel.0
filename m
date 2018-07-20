From: Christoph Hellwig <hch@infradead.org>
Date: Fri, 20 Jul 2018 15:10:00 +0000
Subject: Re: [PATCH 11/15] target: export initiator port values for all sessions
Message-Id: <20180720151000.GA8173@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-12-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-12-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Thu, Jul 19, 2018 at 04:30:36PM -0500, Mike Christie wrote:
> Just to clarify. We can create a dir from the kernel already. It is no
> problem. I am doing that in this patchset with configfs_register_group.
> 
> What Bart was requesting originally and what is missing is being able to
> add a symlink from the kernel.
> 
> I have not fully looked into it, but I think it would be something like
> taking part of configfs_symlink and making it so we can call it with
> config_items for the 2 items to be symlinked.

Yes, it shouldn't be too hard.
