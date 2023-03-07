Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C8D7C678DB
	for <target-devel@archiver.kernel.org>; Tue,  7 Mar 2023 10:54:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbjCGKyT (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 05:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbjCGKyM (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 05:54:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9E6EC76
        for <target-devel@vger.kernel.org>; Tue,  7 Mar 2023 02:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678186403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5TdUrxeEf6Uel5vyr/iSFTtgn6V0/F2rF4kmMh4g2jo=;
        b=gz2MNzJSAwKDj92wADZ8m1zW+6V7SmHc6IzewjnXb1dtSvOa3B4jwsfkPRBZDxT96cnbzY
        4qQ2lIQnrsEI1Fq8FrMcMJNYAKr0ibVY8CyDLaaFzUMUPkfXGmxob+krFLS0N6bcBj79eV
        d2tvgi3a7M/zJBA7JWkFraMOSx7p1Jc=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-534-mTExJeAfMm2kgY13fSjWFw-1; Tue, 07 Mar 2023 05:53:20 -0500
X-MC-Unique: mTExJeAfMm2kgY13fSjWFw-1
Received: by mail-ua1-f69.google.com with SMTP id g27-20020ab05fdb000000b0068ffe2ec956so6222051uaj.18
        for <target-devel@vger.kernel.org>; Tue, 07 Mar 2023 02:53:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678186399;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5TdUrxeEf6Uel5vyr/iSFTtgn6V0/F2rF4kmMh4g2jo=;
        b=Rrcmo7niTEfX881d93wCSm3mmdkf0g7D727AYlLc3qUZ4H38z5LrtENIoAgyHfPfRq
         nPpWY5RliqbFweXT6r1KOZn7oUlSyNyvd/66iUsKc8xB8HFfySXnMfZoDOdeX2Lshqo4
         9p9Q35Ai7aBudpZP16nOYXdy8xVLbPiVRuZwOpwNAdVIoAVPBZokVdvvrgA1HHZfygu1
         cGbQLWIw4WjvxoehHN0bvk6E+n19+NLviixHMIouSDXflMG89nNg4lJRB5Ts9NpCXFD6
         WvN06Nn9JRHNCfiKOueGqyMnbcZHSXFlps6Y28nN9B3fgb+DvoNmwH2Fatjyzy996MxF
         teQw==
X-Gm-Message-State: AO0yUKUpYZbULWdRJUuIhiCnmixYx1pTzHVBF/BIDL7y3WwxihV6CiK6
        O0CATWXG/fyigEYLt6HvRFDxtw4pyZU9MVgMG4RRd4Qa2rpc9M3k6juvXWy1vr/2M6yKyTcM/Lr
        A0KwpAnFQOxHwG/qZcTOdBShUq3RawlbtfLI87zIr
X-Received: by 2002:a1f:4b01:0:b0:401:8898:ea44 with SMTP id y1-20020a1f4b01000000b004018898ea44mr8183339vka.3.1678186399386;
        Tue, 07 Mar 2023 02:53:19 -0800 (PST)
X-Google-Smtp-Source: AK7set8mue/AMf20USnH0awRjij8rWXkUCSmASgju7ls+ODa1QiPh94JZ2t4JIaikzbo/OWasRwuLUP8ADtsPcZrP6A=
X-Received: by 2002:a1f:4b01:0:b0:401:8898:ea44 with SMTP id
 y1-20020a1f4b01000000b004018898ea44mr8183329vka.3.1678186399009; Tue, 07 Mar
 2023 02:53:19 -0800 (PST)
MIME-Version: 1.0
References: <20230129234441.116310-1-michael.christie@oracle.com> <20230129234441.116310-2-michael.christie@oracle.com>
In-Reply-To: <20230129234441.116310-2-michael.christie@oracle.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Tue, 7 Mar 2023 11:53:07 +0100
Message-ID: <CAFL455mhWGo2TCRjkcSGM=_X=jOKCcc1a=q7kSg0bvhJuiC1ng@mail.gmail.com>
Subject: Re: [PATCH v3 01/14] scsi: target: Move sess cmd counter to new struct
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, mgurtovoy@nvidia.com, sagi@grimberg.me,
        d.bogdanov@yadro.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

po 30. 1. 2023 v 0:45 odes=C3=ADlatel Mike Christie
<michael.christie@oracle.com> napsal:
>
> iSCSI needs to wait on outstanding commands like how srp and the FC/fcoe
> drivers do. It can't use target_stop_session because for MCS support we
> can't stop the entire session during recovery because if other connection=
s
> are ok then we want to be able to continue to execute IO on them.
>
> This patch moves the per session cmd counters to a new struct, so iSCSI
> can allocate it per connection. The xcopy code can also just not allocate
> it in the future since it doesn't need to track commands.
>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/target/target_core_tpg.c         |   2 +-
>  drivers/target/target_core_transport.c   | 135 ++++++++++++++++-------
>  include/target/iscsi/iscsi_target_core.h |   1 +
>  include/target/target_core_base.h        |  13 ++-
>  4 files changed, 107 insertions(+), 44 deletions(-)
>
> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_cor=
e_tpg.c
> index 736847c933e5..8ebccdbd94f0 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -328,7 +328,7 @@ static void target_shutdown_sessions(struct se_node_a=
cl *acl)
>  restart:
>         spin_lock_irqsave(&acl->nacl_sess_lock, flags);
>         list_for_each_entry(sess, &acl->acl_sess_list, sess_acl_list) {
> -               if (atomic_read(&sess->stopped))
> +               if (sess->cmd_cnt && atomic_read(&sess->cmd_cnt->stopped)=
)
>                         continue;
>
>                 list_del_init(&sess->sess_acl_list);
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/targ=
et_core_transport.c
> index 5926316252eb..3d6034f00dcd 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -220,11 +220,49 @@ void transport_subsystem_check_init(void)
>         sub_api_initialized =3D 1;
>  }
>
> -static void target_release_sess_cmd_refcnt(struct percpu_ref *ref)
> +static void target_release_cmd_refcnt(struct percpu_ref *ref)
>  {
> -       struct se_session *sess =3D container_of(ref, typeof(*sess), cmd_=
count);
> +       struct target_cmd_counter *cmd_cnt  =3D container_of(ref,
> +                                                          typeof(*cmd_cn=
t),
> +                                                          refcnt);
> +       wake_up(&cmd_cnt->refcnt_wq);
> +}
> +
> +static struct target_cmd_counter *target_alloc_cmd_counter(void)
> +{
> +       struct target_cmd_counter *cmd_cnt;
> +       int rc;
> +
> +       cmd_cnt =3D kzalloc(sizeof(*cmd_cnt), GFP_KERNEL);
> +       if (!cmd_cnt)
> +               return NULL;
>
> -       wake_up(&sess->cmd_count_wq);
> +       init_completion(&cmd_cnt->stop_done);
> +       init_waitqueue_head(&cmd_cnt->refcnt_wq);
> +       atomic_set(&cmd_cnt->stopped, 0);
> +
> +       rc =3D percpu_ref_init(&cmd_cnt->refcnt, target_release_cmd_refcn=
t, 0,
> +                            GFP_KERNEL);
> +       if (rc)
> +               goto free_cmd_cnt;
> +
> +       return cmd_cnt;
> +
> +free_cmd_cnt:
> +       kfree(cmd_cnt);
> +       return NULL;
> +}
> +
> +static void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
> +{
> +       /*
> +        * Drivers like loop do not call target_stop_session during sessi=
on
> +        * shutdown so we have to drop the ref taken at init time here.
> +        */
> +       if (!atomic_read(&cmd_cnt->stopped))
> +               percpu_ref_put(&cmd_cnt->refcnt);
> +
> +       percpu_ref_exit(&cmd_cnt->refcnt);
>  }
>
>  /**
> @@ -238,25 +276,17 @@ int transport_init_session(struct se_session *se_se=
ss)
>         INIT_LIST_HEAD(&se_sess->sess_list);
>         INIT_LIST_HEAD(&se_sess->sess_acl_list);
>         spin_lock_init(&se_sess->sess_cmd_lock);
> -       init_waitqueue_head(&se_sess->cmd_count_wq);
> -       init_completion(&se_sess->stop_done);
> -       atomic_set(&se_sess->stopped, 0);
> -       return percpu_ref_init(&se_sess->cmd_count,
> -                              target_release_sess_cmd_refcnt, 0, GFP_KER=
NEL);
> +       se_sess->cmd_cnt =3D target_alloc_cmd_counter();
> +       if (!se_sess->cmd_cnt)
> +               return -ENOMEM;
> +
> +       return  0;
>  }
>  EXPORT_SYMBOL(transport_init_session);
>
>  void transport_uninit_session(struct se_session *se_sess)
>  {
> -       /*
> -        * Drivers like iscsi and loop do not call target_stop_session
> -        * during session shutdown so we have to drop the ref taken at in=
it
> -        * time here.
> -        */
> -       if (!atomic_read(&se_sess->stopped))
> -               percpu_ref_put(&se_sess->cmd_count);
> -
> -       percpu_ref_exit(&se_sess->cmd_count);
> +       target_free_cmd_counter(se_sess->cmd_cnt);
>  }
>
>  /**
> @@ -2970,9 +3000,16 @@ int target_get_sess_cmd(struct se_cmd *se_cmd, boo=
l ack_kref)
>                 se_cmd->se_cmd_flags |=3D SCF_ACK_KREF;
>         }
>
> -       if (!percpu_ref_tryget_live(&se_sess->cmd_count))
> -               ret =3D -ESHUTDOWN;
> -
> +       /*
> +        * Users like xcopy do not use counters since they never do a sto=
p
> +        * and wait.
> +        */
> +       if (se_sess->cmd_cnt) {
> +               if (!percpu_ref_tryget_live(&se_sess->cmd_cnt->refcnt))
> +                       ret =3D -ESHUTDOWN;
> +               else
> +                       se_cmd->cmd_cnt =3D se_sess->cmd_cnt;
> +       }
>         if (ret && ack_kref)
>                 target_put_sess_cmd(se_cmd);
>
> @@ -2993,7 +3030,7 @@ static void target_free_cmd_mem(struct se_cmd *cmd)
>  static void target_release_cmd_kref(struct kref *kref)
>  {
>         struct se_cmd *se_cmd =3D container_of(kref, struct se_cmd, cmd_k=
ref);
> -       struct se_session *se_sess =3D se_cmd->se_sess;
> +       struct target_cmd_counter *cmd_cnt =3D se_cmd->cmd_cnt;
>         struct completion *free_compl =3D se_cmd->free_compl;
>         struct completion *abrt_compl =3D se_cmd->abrt_compl;
>
> @@ -3004,7 +3041,8 @@ static void target_release_cmd_kref(struct kref *kr=
ef)
>         if (abrt_compl)
>                 complete(abrt_compl);
>
> -       percpu_ref_put(&se_sess->cmd_count);
> +       if (cmd_cnt)
> +               percpu_ref_put(&cmd_cnt->refcnt);
>  }
>
>  /**
> @@ -3123,46 +3161,65 @@ void target_show_cmd(const char *pfx, struct se_c=
md *cmd)
>  }
>  EXPORT_SYMBOL(target_show_cmd);
>
> -static void target_stop_session_confirm(struct percpu_ref *ref)
> +static void target_stop_cmd_counter_confirm(struct percpu_ref *ref)
> +{
> +       struct target_cmd_counter *cmd_cnt =3D container_of(ref,
> +                                               struct target_cmd_counter=
,
> +                                               refcnt);
> +       complete_all(&cmd_cnt->stop_done);
> +}
> +
> +/**
> + * target_stop_cmd_counter - Stop new IO from being added to the counter=
.
> + * @cmd_cnt: counter to stop
> + */
> +static void target_stop_cmd_counter(struct target_cmd_counter *cmd_cnt)
>  {
> -       struct se_session *se_sess =3D container_of(ref, struct se_sessio=
n,
> -                                                 cmd_count);
> -       complete_all(&se_sess->stop_done);
> +       pr_debug("Stopping command counter.\n");
> +       if (!atomic_cmpxchg(&cmd_cnt->stopped, 0, 1))
> +               percpu_ref_kill_and_confirm(&cmd_cnt->refcnt,
> +                                           target_stop_cmd_counter_confi=
rm);
>  }
>
>  /**
>   * target_stop_session - Stop new IO from being queued on the session.
> - * @se_sess:    session to stop
> + * @se_sess: session to stop
>   */
>  void target_stop_session(struct se_session *se_sess)
>  {
> -       pr_debug("Stopping session queue.\n");
> -       if (atomic_cmpxchg(&se_sess->stopped, 0, 1) =3D=3D 0)
> -               percpu_ref_kill_and_confirm(&se_sess->cmd_count,
> -                                           target_stop_session_confirm);
> +       target_stop_cmd_counter(se_sess->cmd_cnt);
>  }
>  EXPORT_SYMBOL(target_stop_session);
>
>  /**
> - * target_wait_for_sess_cmds - Wait for outstanding commands
> - * @se_sess:    session to wait for active I/O
> + * target_wait_for_cmds - Wait for outstanding cmds.
> + * @cmd_cnt: counter to wait for active I/O for.
>   */
> -void target_wait_for_sess_cmds(struct se_session *se_sess)
> +static void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt)
>  {
>         int ret;
>
> -       WARN_ON_ONCE(!atomic_read(&se_sess->stopped));
> +       WARN_ON_ONCE(!atomic_read(&cmd_cnt->stopped));
>
>         do {
>                 pr_debug("Waiting for running cmds to complete.\n");
> -               ret =3D wait_event_timeout(se_sess->cmd_count_wq,
> -                               percpu_ref_is_zero(&se_sess->cmd_count),
> -                               180 * HZ);
> +               ret =3D wait_event_timeout(cmd_cnt->refcnt_wq,
> +                                        percpu_ref_is_zero(&cmd_cnt->ref=
cnt),
> +                                        180 * HZ);
>         } while (ret <=3D 0);
>
> -       wait_for_completion(&se_sess->stop_done);
> +       wait_for_completion(&cmd_cnt->stop_done);
>         pr_debug("Waiting for cmds done.\n");
>  }
> +
> +/**
> + * target_wait_for_sess_cmds - Wait for outstanding commands
> + * @se_sess: session to wait for active I/O
> + */
> +void target_wait_for_sess_cmds(struct se_session *se_sess)
> +{
> +       target_wait_for_cmds(se_sess->cmd_cnt);
> +}
>  EXPORT_SYMBOL(target_wait_for_sess_cmds);
>
>  /*
> diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/is=
csi/iscsi_target_core.h
> index 94d06ddfd80a..229118156a1f 100644
> --- a/include/target/iscsi/iscsi_target_core.h
> +++ b/include/target/iscsi/iscsi_target_core.h
> @@ -600,6 +600,7 @@ struct iscsit_conn {
>         struct iscsi_tpg_np     *tpg_np;
>         /* Pointer to parent session */
>         struct iscsit_session   *sess;
> +       struct target_cmd_counter *cmd_cnt;
>         int                     bitmap_id;
>         int                     rx_thread_active;
>         struct task_struct      *rx_thread;
> diff --git a/include/target/target_core_base.h b/include/target/target_co=
re_base.h
> index 12c9ba16217e..bd299790e99c 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -494,6 +494,7 @@ struct se_cmd {
>         struct se_lun           *se_lun;
>         /* Only used for internal passthrough and legacy TCM fabric modul=
es */
>         struct se_session       *se_sess;
> +       struct target_cmd_counter *cmd_cnt;
>         struct se_tmr_req       *se_tmr_req;
>         struct llist_node       se_cmd_list;
>         struct completion       *free_compl;
> @@ -619,22 +620,26 @@ static inline struct se_node_acl *fabric_stat_to_na=
cl(struct config_item *item)
>                         acl_fabric_stat_group);
>  }
>
> -struct se_session {
> +struct target_cmd_counter {
> +       struct percpu_ref       refcnt;
> +       wait_queue_head_t       refcnt_wq;
> +       struct completion       stop_done;
>         atomic_t                stopped;
> +};
> +
> +struct se_session {
>         u64                     sess_bin_isid;
>         enum target_prot_op     sup_prot_ops;
>         enum target_prot_type   sess_prot_type;
>         struct se_node_acl      *se_node_acl;
>         struct se_portal_group *se_tpg;
>         void                    *fabric_sess_ptr;
> -       struct percpu_ref       cmd_count;
>         struct list_head        sess_list;
>         struct list_head        sess_acl_list;
>         spinlock_t              sess_cmd_lock;
> -       wait_queue_head_t       cmd_count_wq;
> -       struct completion       stop_done;
>         void                    *sess_cmd_map;
>         struct sbitmap_queue    sess_tag_pool;
> +       struct target_cmd_counter *cmd_cnt;
>  };
>
>  struct se_device;
> --
> 2.25.1
>

Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>

