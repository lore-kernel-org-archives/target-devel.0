From: SF Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 21 Feb 2018 16:45:35 +0000
Subject: Re: [PATCH 0/8] target-iSCSI: Adjustments for several function implementations
Message-Id: <c9a822a4-248e-c479-9118-4b8ffb1033b1@users.sourceforge.net>
List-Id: <target-devel.vger.kernel.org>
References: <6163538d-a406-2f60-11a2-88b4694e9975@users.sourceforge.net>
In-Reply-To: <6163538d-a406-2f60-11a2-88b4694e9975@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Arun Easi <arun.easi@cavium.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Dan Carpenter <dan.carpenter@oracle.com>, David Disseldorp <ddiss@suse.de>, Hannes Reinecke <hare@suse.com>, Ingo Molnar <mingo@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Jiang Yi <jiangyilism@gmail.com>, Kees Cook <keescook@chromium.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Russell King <rmk+kernel@armlinux.org.uk>, Tang Wenji <tang.wenji@zte.com.cn>, Theodore Ts'o <tytso@mit.edu>, Varun Prakash <varun@chelsio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org

> Date: Tue, 12 Dec 2017 22:22:11 +0100
> 
> Some update suggestions were taken into account
> from static source code analysis.
> 
> Markus Elfring (8):
>   Less function calls in chap_server_compute_md5() after error detection
>   Move resetting of seven variables in chap_server_compute_md5()
>   Delete 36 error messages for a failed memory allocation
>   Delete an unnecessary variable initialisation in iscsit_allocate_ooo_cmdsn()
>   Delete an unnecessary variable initialisation in iscsi_copy_param_list()
>   Delete an unnecessary variable initialisation in iscsi_create_default_params()
>   Delete an unnecessary variable initialisation in iscsi_set_default_param()
>   Improve 16 size determinations
> 
>  drivers/target/iscsi/iscsi_target.c               |   2 -
>  drivers/target/iscsi/iscsi_target_auth.c          | 110 +++++++++++-----------
>  drivers/target/iscsi/iscsi_target_datain_values.c |   6 +-
>  drivers/target/iscsi/iscsi_target_erl1.c          |  14 +--
>  drivers/target/iscsi/iscsi_target_erl2.c          |   8 +-
>  drivers/target/iscsi/iscsi_target_login.c         |  29 ++----
>  drivers/target/iscsi/iscsi_target_nego.c          |   4 +-
>  drivers/target/iscsi/iscsi_target_parameters.c    |  58 +++++-------
>  drivers/target/iscsi/iscsi_target_seq_pdu_list.c  |  34 +++----
>  drivers/target/iscsi/iscsi_target_tpg.c           |  13 +--
>  drivers/target/iscsi/iscsi_target_util.c          |  11 +--
>  11 files changed, 118 insertions(+), 171 deletions(-)

One of these update suggestions resulted in the commit “target: avoid NULL
dereference in CHAP auth error path” which is considered for integration
into Linux stable versions now.
https://patchwork.kernel.org/patch/10110459/
https://lkml.kernel.org/r/<20171213172230.12767-1-ddiss@suse.de>
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/target/iscsi/iscsi_target_auth.c?id�512d79d0466a604793addb6b769d12ee326822


Now I am curious if more remaining change possibilities can be picked up
from this patch series.

* Would you like to improve any more implementation details?

* Do you need additional explanations for further benefits?

Regards,
Markus
