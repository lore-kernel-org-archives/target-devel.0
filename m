From: Bart Van Assche <Bart.VanAssche@wdc.com>
Date: Wed, 18 Jul 2018 22:41:05 +0000
Subject: Re: [PATCH 11/15] target: export initiator port values for all sessions
Message-Id: <c0e8e228ad561185a6d7ecea02650011617e2b6f.camel@wdc.com>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-12-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-12-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sun, 2018-07-15 at 18:16 -0500, Mike Christie wrote:
+AD4- Export the initiator port info in configfs

Does configfs support soft links? Can this information be exported as a
soft link from the session directory to the struct se+AF8-portal+AF8-group configfs
object?

Thanks,

Bart.
