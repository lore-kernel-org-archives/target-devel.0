From: Hou Pu <houpu@bytedance.com>
Date: Thu, 23 Apr 2020 04:24:28 +0000
Subject: Re: [External] Re: [PATCH 1/2] iscsi-target: fix login error when receiving is too fast
Message-Id: <CAO9YExv2kWp=x+mMaWeOrYmu4c6gTu0PeBSkOwHgr7ZW9MywSg@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200415080819.27327-1-houpu@bytedance.com> <20200415080819.27327-2-houpu@bytedance.com>
 <54e574b1-10b4-4385-11fb-773ef152fc2c@redhat.com>
In-Reply-To: <54e574b1-10b4-4385-11fb-773ef152fc2c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <mchristi@redhat.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

> > +     /*
> > +      * LOGIN_FLAGS_READ_ACTIVE is cleared so that sk_data_ready
> > +      * could be trigger again after this.
> > +      *
> > +      * LOGIN_FLAGS_WRITE_ACTIVE is cleared after we successfully
> > +      * processing a login pdu. So that sk_state_chage could do login
>
> I think we need to drop "ing" from processing and do:
>
> process a login pdu, so that sk_state_chage could do login
>
Sure. Thanks for helping me with my language. ^-^
Will change this in v2.
>

> > diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
> > index 591cd9e4692c..0c2dfc81bf8b 100644
> > --- a/include/target/iscsi/iscsi_target_core.h
> > +++ b/include/target/iscsi/iscsi_target_core.h
> > @@ -570,6 +570,7 @@ struct iscsi_conn {
> >  #define LOGIN_FLAGS_CLOSED           2
> >  #define LOGIN_FLAGS_READY            4
> >  #define LOGIN_FLAGS_INITIAL_PDU              8
> > +#define LOGIN_FLAGS_WRITE_ACTIVE     12
>
> 12 works but seems odd. The current code uses test/set/clear_bit, so we
> want these to be:
>
> #define LOGIN_FLAGS_CLOSED 0
> #define LOGIN_FLAGS_READY 1
> #define LOGIN_FLAGS_INITIAL_PDU 2
> #define LOGIN_FLAGS_WRITE_ACTIVE 3
>
> right?
>
Yes, it is a little odd. What about this? I also changed the order of them
to be in sequence that happened.

--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -566,10 +566,11 @@ struct iscsi_conn {
        struct socket           *sock;
        void                    (*orig_data_ready)(struct sock *);
        void                    (*orig_state_change)(struct sock *);
-#define LOGIN_FLAGS_READ_ACTIVE                1
-#define LOGIN_FLAGS_CLOSED             2
-#define LOGIN_FLAGS_READY              4
-#define LOGIN_FLAGS_INITIAL_PDU                8
+#define LOGIN_FLAGS_READY              0
+#define LOGIN_FLAGS_INITIAL_PDU                1
+#define LOGIN_FLAGS_READ_ACTIVE                2
+#define LOGIN_FLAGS_WRITE_ACTIVE       3
+#define LOGIN_FLAGS_CLOSED             4

Thanks,
Hou

> 2, 4, 8 was probably from a time we set the bits our self like:
>
> login_flags |= LOGIN_FLAGS_CLOSED;
>
>
> >       unsigned long           login_flags;
> >       struct delayed_work     login_work;
> >       struct iscsi_login      *login;
> >
>
