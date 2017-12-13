From: David Disseldorp <ddiss@suse.de>
Date: Wed, 13 Dec 2017 01:16:52 +0000
Subject: Re: [PATCH 0/8] target-iSCSI: Adjustments for several function implementations
Message-Id: <20171213021652.7fd3e156@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <6163538d-a406-2f60-11a2-88b4694e9975@users.sourceforge.net>
In-Reply-To: <6163538d-a406-2f60-11a2-88b4694e9975@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Aside from the crypto_free_shash(NULL) error path fix in 1/8, I don't
see a need for any of the style-based churn here.

Cheers, David
