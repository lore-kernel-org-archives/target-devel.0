From: Greg KH <gregkh@linuxfoundation.org>
Date: Tue, 17 Oct 2017 10:12:45 +0000
Subject: Re: [PATCH v2 00/15] make structure field, function arguments and structures const
Message-Id: <20171017101245.GA4646@kroah.com>
List-Id: <target-devel.vger.kernel.org>
References: <1508167134-6243-1-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1508167134-6243-1-git-send-email-bhumirks@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: julia.lawall@lip6.fr, rjw@rjwysocki.net, lenb@kernel.org, alexander.shishkin@linux.intel.com, jic23@kernel.org, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, hch@lst.de, sagi@grimberg.me, kishon@ti.com, bhelgaas@google.com, nab@linux-iscsi.org, balbi@kernel.org, laurent.pinchart@ideasonboard.com, jlbec@evilplan.org, ccaulfie@redhat.com, teigland@redhat.com, mfasheh@versity.com, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-usb@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.orac

On Mon, Oct 16, 2017 at 05:18:39PM +0200, Bhumika Goyal wrote:
> Make the ci_type field and some function arguments as const. After this
> change, make config_item_type structures as const.
> 
> * Changes in v2- Combine all the followup patches and the constification
> patches into a series.

Who do you want to take these patches?  If you want, I can take them
through my driver-core tree, which has done other configfs stuff like
this in the past.

thanks,

greg k-h
