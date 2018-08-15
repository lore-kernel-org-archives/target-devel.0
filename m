From: Vincent Pelletier <plr.vincent@gmail.com>
Date: Wed, 15 Aug 2018 15:57:06 +0000
Subject: Re: iscsi target: Set conn->sess to NULL when iscsi_login_set_conn_values fails
Message-Id: <20180815155706.25a8cab5@gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <009ea1a88311492e651c38ae946f785961a7e1a7.1534328354.git.plr.vincent@gmail.com>
In-Reply-To: <009ea1a88311492e651c38ae946f785961a7e1a7.1534328354.git.plr.vincent@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, 15 Aug 2018 10:44:34 -0500, Mike Christie <mchristi@redhat.com>
wrote:
> This is the issue I said was fixed in:
> 
> https://www.spinics.net/lists/target-devel/msg17018.html

I did apply this patch, yes.
It misses the "if(...){kfree(sess); return ret;}" right after the
iscsi_login_set_conn_values call, which is what my patch addresses.

> Your patch still has issues where the sess_ops can be double freed,
> and there is a issue with the idr.

I believe you mean the other issues fixed by the patch at above URL.
And as I applied that patch, I indeed did not touch these.

Regards,
-- 
Vincent Pelletier
