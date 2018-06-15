From: Christoph Hellwig <hch@infradead.org>
Date: Fri, 15 Jun 2018 07:37:55 +0000
Subject: Re: [PATCH 0/3] Use sbitmap instead of percpu_ida
Message-Id: <20180615073755.GA22953@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20180612190545.10781-1-willy@infradead.org>
In-Reply-To: <20180612190545.10781-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Juergen Gross <jgross@suse.com>, Jens Axboe <axboe@kernel.dk>, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, target-devel@vger.kernel.org, qla2xxx-upstream@qlogic.com, linux1394-devel@lists.sourceforge.net, Kent Overstreet <kent.overstreet@gmail.com>

Btw, if you are on a spree to remove almost unused data structures
from target code, the lib/btree.c code is only used by the qla2xxx
target code, and doesn't really look like the best fit for it either.
