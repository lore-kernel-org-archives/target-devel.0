From: Bart Van Assche <Bart.VanAssche@wdc.com>
Date: Wed, 18 Jul 2018 22:23:13 +0000
Subject: Re: [PATCH 07/15] target: rename target_alloc_session
Message-Id: <ea9523dda3937c20fb55bd2dbe873f60efe286f1.camel@wdc.com>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-8-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-8-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sun, 2018-07-15 at 18:16 -0500, Mike Christie wrote:
+AD4- Rename target+AF8-alloc+AF8-session to target+AF8-setup+AF8-session to avoid
+AD4- confusion with the other transport session allocation
+AD4- function that only allocates the session and because
+AD4- the target+AF8-alloc+AF8-session does so more. It allocates the
                                  +AF4-
                                  much?
+AD4- session, sets up the nacl and egisters the session.
+AD4- 
+AD4- The next patch will then add a remove function to match the
+AD4- setup in this one, so it should make sense for all drivers,
+AD4- except iscsi, to just call those 2 functions to setup and remove
+AD4- a session.

Anyway:

Reviewed-by: Bart Van Assche +ADw-bart.vanassche+AEA-wdc.com+AD4-
