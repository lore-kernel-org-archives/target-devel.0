From: Doug Ledford <dledford@redhat.com>
Date: Wed, 18 Oct 2017 14:33:31 +0000
Subject: Re: [PATCH v2 12/15] RDMA/cma: make config_item_type const
Message-Id: <1508337211.46071.67.camel@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1508167134-6243-1-git-send-email-bhumirks@gmail.com>
         <1508167134-6243-13-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1508167134-6243-13-git-send-email-bhumirks@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bhumika Goyal <bhumirks@gmail.com>, julia.lawall@lip6.fr, rjw@rjwysocki.net, lenb@kernel.org, alexander.shishkin@linux.intel.com, jic23@kernel.org, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net, sean.hefty@intel.com, hal.rosenstock@gmail.com, hch@lst.de, sagi@grimberg.me, kishon@ti.com, bhelgaas@google.com, nab@linux-iscsi.org, balbi@kernel.org, gregkh@linuxfoundation.org, laurent.pinchart@ideasonboard.com, jlbec@evilplan.org, ccaulfie@redhat.com, teigland@redhat.com, mfasheh@versity.com, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-usb@vger.kernel.org, clu

On Mon, 2017-10-16 at 17:18 +0200, Bhumika Goyal wrote:
> Make these structures const as they are either passed to the
> functions
> having the argument as const or stored as a reference in the
> "ci_type"
> const field of a config_item structure.
> 
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>

Acked-by: Doug Ledford <dledford@redhat.com>

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

