From: Bart Van Assche <Bart.VanAssche@wdc.com>
Date: Wed, 18 Jul 2018 22:24:00 +0000
Subject: Re: [PATCH 08/15] target: add session removal function
Message-Id: <55db85a49666f94c56b8d80002d7ae0cfb98e5d4.camel@wdc.com>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-9-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-9-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sun, 2018-07-15 at 18:16 -0500, Mike Christie wrote:
+AD4- This adds a function to remove a session which should be used by
+AD4- drivers that use target+AF8-setup+AF8-session.
+AD4- 
+AD4- All the drivers but iscsi and tcm+AF8-fc were doing calling
+AD4- transport+AF8-deregister+AF8-session+AF8-configfs and then immediately calling
+AD4- transport+AF8-deregister+AF8-session or just calling
+AD4- transport+AF8-deregisteir+AF8-session.
  +AF4AXgBeAF4AXgBeAF4AXgBeAF4AXgBeAF4AXgBeAF4AXgBeAF4AXgBeAF4AXgBeAF4AXgBeAF4AXg-
  transport+AF8-deregister+AF8-session?

Anyway:

Reviewed-by: Bart Van Assche +ADw-bart.vanassche+AEA-wdc.com+AD4-
