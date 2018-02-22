From: David Disseldorp <ddiss@suse.de>
Date: Thu, 22 Feb 2018 14:19:14 +0000
Subject: Re: [PATCH 0/8] target-iSCSI: Adjustments for several function implementations
Message-Id: <20180222151914.029b8b6c@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <6163538d-a406-2f60-11a2-88b4694e9975@users.sourceforge.net>
In-Reply-To: <6163538d-a406-2f60-11a2-88b4694e9975@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Thu, 22 Feb 2018 16:56:00 +0300, Dan Carpenter wrote:

...
> Calling crypto_free_shash(NULL) is actually fine.  It doesn't
> dereference the parameter, it just does pointer math on it in
> crypto_shash_tfm() and returns if it's NULL in crypto_destroy_tfm().

Bleh, you're right. I read the crypto_shash_tfm() code path
incorrectly.
