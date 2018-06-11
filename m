From: Mike Christie <mchristi@redhat.com>
Date: Mon, 11 Jun 2018 19:02:42 +0000
Subject: Re: [PATCH 10/14] target: Simplify the code for waiting for command completion
Message-Id: <5B1EC752.5060304@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180301222632.31507-11-bart.vanassche@wdc.com>
In-Reply-To: <20180301222632.31507-11-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
To: target-devel@vger.kernel.org

On 03/01/2018 04:26 PM, Bart Van Assche wrote:
> Instead of embedding the completion that is used for waiting for
> command completion in struct se_cmd, let the context that waits for
> command completion allocate it. This makes it possible to have a
> single code path for non-aborted and aborted commands in
> target_release_cmd_kref() and avoids that transport_generic_free_cmd()
> has to call cmd->se_tfo->release_cmd() directly. This patch does not
> change any functionality. Note: transport_generic_free_cmd() only
> waits until the se_cmd reference count has reached zero after it has
> set both CMD_T_FABRIC_STOP and CMD_T_ABORTED.
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/target/target_core_transport.c | 24 ++++++++----------------
>  include/target/target_core_base.h      |  2 +-
>  2 files changed, 9 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/targ=
et_core_transport.c
> index c8f19a143f5c..d7b0b2f4261e 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1276,7 +1276,7 @@ void transport_init_se_cmd(
>  	INIT_LIST_HEAD(&cmd->se_cmd_list);
>  	INIT_LIST_HEAD(&cmd->state_list);
>  	init_completion(&cmd->t_transport_stop_comp);
> -	init_completion(&cmd->cmd_wait_comp);
> +	cmd->compl =3D NULL;
>  	spin_lock_init(&cmd->t_state_lock);
>  	INIT_WORK(&cmd->work, NULL);
>  	kref_init(&cmd->cmd_kref);
> @@ -2596,6 +2596,7 @@ static void target_wait_free_cmd(struct se_cmd *cmd=
, bool *aborted, bool *tas)
>   */
>  int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
>  {
> +	DECLARE_COMPLETION_ONSTACK(compl);
>  	int ret =3D 0;
>  	bool aborted =3D false, tas =3D false;
> =20
> @@ -2614,12 +2615,13 @@ int transport_generic_free_cmd(struct se_cmd *cmd=
, int wait_for_tasks)
>  		if (cmd->se_lun)
>  			transport_lun_remove_cmd(cmd);
>  	}
> +	if (aborted)

I see that in the current code we always do a wait if the CMD_T_ABORTED
bit was set, so your patch matches that. However, is the original code
correct? In target_release_cmd_kref below we only do a wake up if both
CMD_T_FABRIC_STOP and CMD_T_ABORTED is set. If wait_for_tasks=FAlse and
CMD_T_ABORTED was set, we would end up waiting forever. Is that right or
can it never happen?


........

>  		}
> -
> -		spin_lock(&se_cmd->t_state_lock);
> -		fabric_stop =3D (se_cmd->transport_state & CMD_T_FABRIC_STOP) &&
> -			      (se_cmd->transport_state & CMD_T_ABORTED);
> -		spin_unlock(&se_cmd->t_state_lock);
> -
> -		if (fabric_stop) {
> -			spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
> -			target_free_cmd_mem(se_cmd);
> -			complete(&se_cmd->cmd_wait_comp);
> -			return;
> -		}
