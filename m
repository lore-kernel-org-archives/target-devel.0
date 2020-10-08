From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Thu, 08 Oct 2020 20:26:51 +0000
Subject: Re: [PATCH 12/16] vhost: support multiple worker threads
Message-Id: <20201008162523-mutt-send-email-mst@kernel.org>
List-Id: <target-devel.vger.kernel.org>
References: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
 <1602104101-5592-13-git-send-email-michael.christie@oracle.com>
 <da6f25b4-7a98-9294-a987-43d100625499@oracle.com>
In-Reply-To: <da6f25b4-7a98-9294-a987-43d100625499@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <michael.christie@oracle.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

On Thu, Oct 08, 2020 at 12:56:53PM -0500, Mike Christie wrote:
> On 10/7/20 3:54 PM, Mike Christie wrote:
> > This is a prep patch to support multiple vhost worker threads per vhost
> > dev. This patch converts the code that had assumed a single worker
> > thread by:
> > 
> > 1. Moving worker related fields to a new struct vhost_worker.
> > 2. Converting vhost.c code to use the new struct and assume we will
> > have an array of workers.
> > 3. It also exports a helper function that will be used in the last
> > patch when vhost-scsi is converted to use this new functionality.
> > 
> 
> Oh yeah I also wanted to bring up this patch:
> 
> https://www.spinics.net/lists/netdev/msg192548.html
> 
> The problem with my multi-threading patches is that I was focused on
> the cgroup support parts and that lead to some gross decisions.
> 
> 1. I kept the cgroup support, but as a result I do not have control
> over the threading affinity and making sure cmds are executed on a
> optimal CPU like the above patches do.
> 
> When I drop the cgroup support and make sure threads are bound to
> specific CPUs and then make sure IO is run on the CPU it came in on
> then IOPs jumps from 600K to 800K for vhost-scsi.
> 
> 2. I can possible create a lot of threads.
> 
> So a couple open issues are:
> 
> 1. Can we do a thread per cpu that is shared across all vhost devices?
> That would lead to dropping the cgroup vhost worker support.
> 
> 2. Can we just use the kernel's workqueues then?


Problem is, we are talking about *lots* of CPU, IO etc and ATM cgroups
is how people expect to account for that overhead.
