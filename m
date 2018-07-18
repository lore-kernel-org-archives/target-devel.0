From: Bart Van Assche <Bart.VanAssche@wdc.com>
Date: Wed, 18 Jul 2018 22:34:57 +0000
Subject: Re: [PATCH 09/15] target: add session dir in configfs
Message-Id: <4f73971a845bb295933d37e940de7ae60d18e202.camel@wdc.com>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-10-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-10-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sun, 2018-07-15 at 18:16 -0500, Mike Christie wrote:
+AD4- +-static void target+AF8-fabric+AF8-session+AF8-release(struct config+AF8-item +ACo-item)
+AD4- +-+AHs-
+AD4- +-	struct se+AF8-session +ACo-se+AF8-sess +AD0- container+AF8-of(to+AF8-config+AF8-group(item),
+AD4- +-						  struct se+AF8-session, group)+ADs-
+AD4- +-	target+AF8-release+AF8-session(se+AF8-sess)+ADs-
+AD4- +-+AH0-

Please consider changing the target+AF8-fabric+AF8- prefix into target+AF8- for all new
functions. Otherwise this patch looks fine to me.

Bart.