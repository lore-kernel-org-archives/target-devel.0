From: Bart Van Assche <Bart.VanAssche@wdc.com>
Date: Wed, 18 Jul 2018 22:20:50 +0000
Subject: Re: [PATCH 05/15] target: remove sess_get_index
Message-Id: <39ad23bae6077fe99ffd051fb7275b1333e0254a.camel@wdc.com>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-6-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-6-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sun, 2018-07-15 at 18:16 -0500, Mike Christie wrote:
+AD4- sess+AF8-get+AF8-index is meaninless for most drivers. For iscsi, it
                    +AF4AXgBeAF4AXgBeAF4AXgBeAF4-
                    meaningless?
+AD4- is the same as the se+AF8-session-+AD4-sid now and for fcoe it was just
+AD4- the port id which would not work if multiple initiators
+AD4- connected to the same target port. So just use the se+AF8-session sid
+AD4- for all drivers and remove sess+AF8-get+AF8-index callout.

Anyway:

Reviewed-by: Bart Van Assche +ADw-bart.vanassche+AEA-wdc.com+AD4-
