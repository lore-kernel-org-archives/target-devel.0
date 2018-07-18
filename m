From: Bart Van Assche <Bart.VanAssche@wdc.com>
Date: Wed, 18 Jul 2018 22:46:03 +0000
Subject: Re: [PATCH 12/15] target: add callout to test a session
Message-Id: <213b42d2e36d3377297b338e463951605578ee5c.camel@wdc.com>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-13-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-13-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sun, 2018-07-15 at 18:16 -0500, Mike Christie wrote:
+AD4- +-       int (+ACo-test+AF8-session)(struct se+AF8-session +ACo-, u8 timeout)+ADs-

Does any of the patches in this series define a test+AF8-session callback
function?

What is the unit of the timeout parameter? 1/HZ, ms or s?

Thanks,

Bart.