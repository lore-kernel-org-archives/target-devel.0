From: Christoph Hellwig <hch@lst.de>
Date: Tue, 02 Jul 2019 16:26:19 +0000
Subject: Re: [PATCH 0/2] Use REQ_OP_WRITE_SAME to implement WRITE SAME
Message-Id: <20190702162619.GA19142@lst.de>
List-Id: <target-devel.vger.kernel.org>
References: <20190702153031.3832-1-bvanassche@acm.org>
In-Reply-To: <20190702153031.3832-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

I actually rather wanted to get rid of REQ_OP_WRITE_SAME entirely.
Do you have a use case for this?

Note that it isn't going to help with nvme either, as there is no
write same command in nvme.
