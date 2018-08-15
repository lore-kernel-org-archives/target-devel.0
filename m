From: Vincent Pelletier <plr.vincent@gmail.com>
Date: Wed, 15 Aug 2018 10:23:46 +0000
Subject: Re: iscsi target: Set conn->sess to NULL when iscsi_login_set_conn_values fails
Message-Id: <20180815102346.3ad09f89@gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <009ea1a88311492e651c38ae946f785961a7e1a7.1534328354.git.plr.vincent@gmail.com>
In-Reply-To: <009ea1a88311492e651c38ae946f785961a7e1a7.1534328354.git.plr.vincent@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, 15 Aug 2018 10:19:14 +0000, Vincent Pelletier
<plr.vincent@gmail.com> wrote:
> Fixes a use-after-free reported by KASAN when later
> iscsi_target_login_sess_out gets called and it tries to access
> conn->sess->se_sess:

I could still hit this issue by causing a timeout, and located the
guilty kfree:

>  	ret = iscsi_login_set_conn_values(sess, conn, pdu->cid);

Here, conn->sess is set.

> -	if (unlikely(ret)) {
> -		kfree(sess);

This is the guilty kfree.

> +		ret = -ENOMEM;

This is just to be strictly compliant with the hardcoded return value
which I'm replacing with "ret". I tend to think this is wrong (hiding
a possibly more relevant error code ?), but I do not know the
surrounding code nearly enough to make a decision - so status-quo it is.

Regards,
-- 
Vincent Pelletier
