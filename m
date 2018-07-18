From: Bart Van Assche <Bart.VanAssche@wdc.com>
Date: Wed, 18 Jul 2018 22:21:25 +0000
Subject: Re: [PATCH 06/15] target: make transport_init_session_tags static
Message-Id: <025591eeef7a297a4d9379b3a50fd5b721f5b194.camel@wdc.com>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-7-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-7-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sun, 2018-07-15 at 18:16 -0500, Mike Christie wrote:
+AD4- transport+AF8-init+AF8-session+AF8-tags is only called from target+AF8-core+AF8-transport.c
+AD4- so make it static.

Reviewed-by: Bart Van Assche +ADw-bart.vanassche+AEA-wdc.com+AD4-
