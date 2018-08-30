From: Greg Edwards <gedwards@ddn.com>
Date: Thu, 30 Aug 2018 14:46:59 +0000
Subject: Re: [PATCH v2] target/iblock: split T10 PI SGL across command bios
Message-Id: <20180830144659.GA8203@psuche>
List-Id: <target-devel.vger.kernel.org>
References: <20180829203631.11753-1-gedwards@ddn.com>
In-Reply-To: <20180829203631.11753-1-gedwards@ddn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, Aug 29, 2018 at 06:23:52PM -0500, Mike Christie wrote:
>
> Can you still hit the issue where t_prot_nents > BIO_MAX_PAGES so
> bio_integrity_alloc fails or is t_prot_nents always going to be smaller.
> Was wondering why you dropped that from the last patch.

There was a vhost bug that was artificially inflating the size of the
PI SGL by including both the protection and data in the PI SGL [1].  In
testing with that patch applied, I haven't seen the PI SGL get anywhere
close to BIO_MAX_PAGES.  That said, you're right, we should probably
retain that safety check.  I'll add it back for a v3.  Thanks for the
feedback.

Greg

  [1] https://lists.linuxfoundation.org/pipermail/virtualization/2018-August/039106.html
