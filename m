From: SF Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 23 Feb 2018 09:06:16 +0000
Subject: Re: [0/8] target-iSCSI: Adjustments for several function implementations
Message-Id: <145b88b1-bd1e-a417-8dce-ff19e35a00fc@users.sourceforge.net>
List-Id: <target-devel.vger.kernel.org>
References: <6163538d-a406-2f60-11a2-88b4694e9975@users.sourceforge.net>
 <c9a822a4-248e-c479-9118-4b8ffb1033b1@users.sourceforge.net>
 <20180222143624.7c7241a1@suse.de> <20180222135600.5vv7vzw7sa5metcb@mwanda>
In-Reply-To: <20180222135600.5vv7vzw7sa5metcb@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Carpenter <dan.carpenter@oracle.com>, target-devel@vger.kernel.org
Cc: David Disseldorp <ddiss@suse.de>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

> Calling crypto_free_shash(NULL) is actually fine.

Really?


> It doesn't dereference the parameter, it just does pointer math on it in
> crypto_shash_tfm() and returns if it's NULL in crypto_destroy_tfm().

Can a passed null pointer really work in this function?

https://elixir.bootlin.com/linux/v4.16-rc2/source/include/crypto/hash.h#L684
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/crypto/hash.h?id9da844d87796ac31b04e81ee95e155e9043132#n751

static inline struct crypto_tfm *crypto_shash_tfm(struct crypto_shash *tfm)
{
	return &tfm->base;
}


Regards,
Markus
