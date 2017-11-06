From: Varun Prakash <varun@chelsio.com>
Date: Mon, 06 Nov 2017 15:38:21 +0000
Subject: Re: [PATCH 2/6] target/iscsi: Call .iscsit_release_cmd() once
Message-Id: <20171106152620.GA1646@chelsio.com>
List-Id: <target-devel.vger.kernel.org>
References: <1509494870.12927.11.camel@wdc.com>
In-Reply-To: <1509494870.12927.11.camel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, Nov 01, 2017 at 12:07:52AM +0000, Bart Van Assche wrote:
> On Tue, 2017-04-04 at 10:36 +0530, Varun Prakash wrote:
> > On Sun, Apr 02, 2017 at 03:59:05PM -0700, Nicholas A. Bellinger wrote:
> > > On Thu, 2017-03-30 at 10:12 -0700, Bart Van Assche wrote:
> > > > While releasing a command __iscsit_free_cmd() can be called multiple
> > > > times but .iscsit_release_cmd() must be called only once. Hence move
> > > > the .iscsit_release_cmd() call into iscsit_release_cmd(). The latter
> > > > function is only called once per command. The only driver that defines
> > > > the .iscsit_release_cmd() callback is the cxgbit driver so this change
> > > > only affects the cxgbit driver.
> > > > 
> > > > Fixes: 7ec811a8e9c3 ("iscsi-target: add void (*iscsit_release_cmd)()")
> > > > Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> > > > Cc: Varun Prakash <varun@chelsio.com>
> > > > Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> > > > Cc: <stable@vger.kernel.org>
> > > > ---
> > > >  drivers/target/iscsi/iscsi_target_util.c | 15 +++++++++------
> > > >  1 file changed, 9 insertions(+), 6 deletions(-)
> > > > 
> > >
 
> 
> (replying to an e-mail of six months ago)
> 
> Hello Varun,
> 
> Have you noticed that commit febe562c20df (target: Fix LUN_RESET active I/O
> handling for ACK_KREF; January 2016) moved the transport_free_pages() call
> from transport_put_cmd() to target_release_cmd_kref()? I think that means
> that it is now safe to call .iscsit_release_cmd() after
> transport_generic_free_cmd().
> 

Hello Bart,

The requirement here is to call .iscsit_release_cmd() before target free the
pages so that cxgbit driver can call dma_unmap_sg() and free the pages in case
of PASSTHROUGH_SG_TO_MEM_NOALLOC.

Currently .iscsit_release_cmd() is called from two functions -

iscsit_free_cmd() -> __iscsit_free_cmd() -> .iscsit_release_cmd()
iscsit_aborted_task() -> __iscsit_free_cmd() -> .iscsit_release_cmd()

If we move .iscsit_release_cmd() after transport_generic_free_cmd(), will it
handle all the error cases(abort etc)?

In case of abort currently it is called from iscsit_aborted_task(), if we
move then in case of abort .iscsit_release_cmd() will not be called.

If we can confirm that moving .iscsit_release_cmd() will not cause any
memory leak then we can move it.

Thanks
Varun
