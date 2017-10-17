From: Christoph Hellwig <hch@infradead.org>
Date: Tue, 17 Oct 2017 06:57:18 +0000
Subject: Re: [PATCH 2/2] target: add ALUA state file path truncation detection
Message-Id: <20171017065718.GA17190@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20171014210352.8713-2-ddiss@suse.de>
In-Reply-To: <20171014210352.8713-2-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sat, Oct 14, 2017 at 11:03:52PM +0200, David Disseldorp wrote:
> A sufficiently long Unit Serial string, dbroot path, and/or ALUA target
> portal group name may result in truncation of the ALUA state file path
> prior to usage. Add checks for snprintf() truncation.

How about simply switching to kasprintf?
