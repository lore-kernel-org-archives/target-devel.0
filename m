From: Christoph Hellwig <hch@infradead.org>
Date: Thu, 19 Jul 2018 20:43:39 +0000
Subject: Re: [PATCH 08/15] target: add session removal function
Message-Id: <20180719204339.GE14654@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-9-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-9-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sun, Jul 15, 2018 at 06:16:24PM -0500, Mike Christie wrote:
> For tcm_fc, it should be ok to call
> transport_deregister_session_configfs later like in the new
> remove function because the transport_deregister_session_configfs call
> was not affecting the target_sess_cmd_list_set_waiting/
> target_wait_for_sess_cmds calls and nothing else was being
> torn down between that time.
> 
> For drivers that only called transport_deregister_session
> the new remove function that calls transport_deregister_session_configfs
> should be ok, because those drivers did not access se_nacl->nacl_sess
> or sess_acl_list so they will see no difference.

It might be worth to split the conversion of the drivers that didn't
exactly call transport_deregister_session_configfs +
transport_deregister_session into a separate per-driver patch to
better document this.

Except for that this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
