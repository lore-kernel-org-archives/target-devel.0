From: Matthew Wilcox <willy@infradead.org>
Date: Tue, 12 Jun 2018 18:08:43 +0000
Subject: Re: [PATCH 1/2] Convert target drivers to use sbitmap
Message-Id: <20180612180843.GF19433@bombadil.infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20180515160043.27044-1-willy@infradead.org>
	<20180515160043.27044-2-willy@infradead.org>
	<da5220a5ed4bed210c31a7517389e787a3b1a01f.camel@wdc.com>
	<20180612161526.GE19433@bombadil.infradead.org>
	<0c93c72a3a339f3479f82de04223315671e07863.camel@wdc.com>
In-Reply-To: <0c93c72a3a339f3479f82de04223315671e07863.camel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jgross@suse.com" <jgross@suse.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "qla2xxx-upstream@qlogic.com" <qla2xxx-upstream@qlogic.com>, "linux1394-devel@lists.sourceforge.net" <linux1394-devel@lists.sourceforge.net>, "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>

On Tue, Jun 12, 2018 at 04:32:03PM +0000, Bart Van Assche wrote:
> On Tue, 2018-06-12 at 09:15 -0700, Matthew Wilcox wrote:
> > On Tue, Jun 12, 2018 at 03:22:42PM +0000, Bart Van Assche wrote:
> > > Please introduce functions in the target core for allocating and freeing a tag
> > > instead of spreading the knowledge of how to allocate and free tags over all
> > > target drivers.
> > 
> > I can't without doing an unreasonably large amount of work on drivers that
> > I have no way to test.  Some of the drivers have the se_cmd already; some
> > of them don't.  I'd be happy to introduce a common function for freeing
> > a tag.
> 
> Which target drivers are you referring to? If you are referring to the sbp driver:
> I think that driver is dead and can be removed from the kernel tree. I even don't
> know whether that driver ever has had any users other than the developer of that
> driver.

For example tcm_fc:

        tag = sbitmap_queue_get(&se_sess->sess_tag_pool, &cpu);
        if (tag < 0)
                goto busy;

        cmd = &((struct ft_cmd *)se_sess->sess_cmd_map)[tag];

or qla2xxx:

        tag = sbitmap_queue_get(&se_sess->sess_tag_pool, &cpu);
        if (tag < 0)
                return NULL;

        cmd = &((struct qla_tgt_cmd *)se_sess->sess_cmd_map)[tag];

The core doesn't know at what offset from the pointer to store the tag
& cpu.  Only the individual drivers know their cmd layout.

