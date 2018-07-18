From: Bart Van Assche <Bart.VanAssche@wdc.com>
Date: Wed, 18 Jul 2018 22:19:18 +0000
Subject: Re: [PATCH 04/15] target/iscsi: move session_index to common se_session
Message-Id: <95993fbafca018ff5a2d98cd026caf18a300e501.camel@wdc.com>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-5-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-5-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sun, 2018-07-15 at 18:16 -0500, Mike Christie wrote:
+AD4- diff --git a/drivers/target/target+AF8-core+AF8-transport.c b/drivers/target/target+AF8-core+AF8-transport.c
+AD4- index 75ddbbb..97a1ee5 100644
+AD4- --- a/drivers/target/target+AF8-core+AF8-transport.c
+AD4- +-+-+- b/drivers/target/target+AF8-core+AF8-transport.c
+AD4- +AEAAQA- -55,6 +-55,8 +AEAAQA-
+AD4-  
+AD4-  static struct workqueue+AF8-struct +ACo-target+AF8-completion+AF8-wq+ADs-
+AD4-  static struct kmem+AF8-cache +ACo-se+AF8-sess+AF8-cache+ADs-
+AD4- +-static DEFINE+AF8-SPINLOCK(se+AF8-sess+AF8-idr+AF8-lock)+ADs-
+AD4- +-static DEFINE+AF8-IDR(se+AF8-sess+AF8-idr)+ADs-

Is it necessary that se+AF8-sess+AF8-idr+AF8-lock and se+AF8-sess+AF8-idr are global? Could these
two data structures be members of the data structure associated with
/sys/kernel/config/target/iscsi/+ACQ-port/+ACQ-tpg (struct se+AF8-portal+AF8-group?)?

Thanks,

Bart.