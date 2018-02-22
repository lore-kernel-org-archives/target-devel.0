From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 22 Feb 2018 13:56:00 +0000
Subject: Re: [PATCH 0/8] target-iSCSI: Adjustments for several function implementations
Message-Id: <20180222135600.5vv7vzw7sa5metcb@mwanda>
List-Id: <target-devel.vger.kernel.org>
References: <6163538d-a406-2f60-11a2-88b4694e9975@users.sourceforge.net>
In-Reply-To: <6163538d-a406-2f60-11a2-88b4694e9975@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

On Thu, Feb 22, 2018 at 02:36:24PM +0100, David Disseldorp wrote:
> [cc list trimmed]
> 
> On Wed, 21 Feb 2018 17:45:35 +0100, SF Markus Elfring wrote:
> 
> ...
> > One of these update suggestions resulted in the commit “target: avoid NULL
> > dereference in CHAP auth error path” which is considered for integration
> > into Linux stable versions now.
> > https://patchwork.kernel.org/patch/10110459/
> > https://lkml.kernel.org/r/<20171213172230.12767-1-ddiss@suse.de>
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/target/iscsi/iscsi_target_auth.c?id�512d79d0466a604793addb6b769d12ee326822
> 
> You're 1/8 patch had an actual bug fix hidden amongst the style churn.
> I don't see any such fixes in the other patches.
> 

Calling crypto_free_shash(NULL) is actually fine.  It doesn't
dereference the parameter, it just does pointer math on it in
crypto_shash_tfm() and returns if it's NULL in crypto_destroy_tfm().

regards,
dan carpenter

