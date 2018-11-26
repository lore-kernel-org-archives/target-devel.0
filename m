From: Christoph Hellwig <hch@infradead.org>
Date: Mon, 26 Nov 2018 07:35:21 +0000
Subject: Re: [PATCH 1/3] target: drop unused pi_prot_format attribute storage
Message-Id: <20181126073521.GA9033@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181123173613.4547-2-ddiss@suse.de>
In-Reply-To: <20181123173613.4547-2-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Fri, Nov 23, 2018 at 06:36:11PM +0100, David Disseldorp wrote:
> On write, the pi_prot_format configfs attribute invokes the device
> format_prot() callback if present. Read dumps the contents of
> se_dev_attrib.pi_prot_format , which is always zero.
> Make the configfs attribute write-only, and drop the always zero
> se_dev_attrib.pi_prot_format storage.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
