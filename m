From: SF Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 23 Feb 2018 08:19:28 +0000
Subject: Re: [0/8] target-iSCSI: Adjustments for several function implementations
Message-Id: <da62858f-37f5-1396-c561-ab68ba20c811@users.sourceforge.net>
List-Id: <target-devel.vger.kernel.org>
References: <6163538d-a406-2f60-11a2-88b4694e9975@users.sourceforge.net>
 <c9a822a4-248e-c479-9118-4b8ffb1033b1@users.sourceforge.net>
 <20180222143624.7c7241a1@suse.de>
In-Reply-To: <20180222143624.7c7241a1@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: David Disseldorp <ddiss@suse.de>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Arun Easi <arun.easi@cavium.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Dan Carpenter <dan.carpenter@oracle.com>, Hannes Reinecke <hare@suse.com>, Ingo Molnar <mingo@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Jiang Yi <jiangyilism@gmail.com>, Kees Cook <keescook@chromium.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Russell King <rmk+kernel@armlinux.org.uk>, Tang Wenji <tang.wenji@zte.com.cn>, Theodore Ts'o <tytso@mit.edu>, Varun Prakash <varun@chelsio.com>

> You're 1/8 patch had an actual bug fix hidden amongst the style churn.

It showed the general possibility to adjust the source code structure
for the function “chap_server_compute_md5” also because of the usage
of the single jump label “out” before.


> I don't see any such fixes in the other patches.

This view is appropriate.

Further update steps show different transformation possibilities.


> My opinion from https://www.spinics.net/lists/target-devel/msg16342.html
> hasn't changed. FWIW, I'd prefer to see LIO adopt a policy similar to:
> https://btrfs.wiki.kernel.org/index.php/Developer%27s_FAQ#How_not_to_start

It seems that you express a few aspects for general change resistance.
Will the circumstances evolve for similar software improvements?

Regards,
Markus
