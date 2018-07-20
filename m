From: Bart Van Assche <Bart.VanAssche@wdc.com>
Date: Fri, 20 Jul 2018 22:24:32 +0000
Subject: Re: [PATCH 02/15] target: fix isid copying and comparision
Message-Id: <bf5b05b172f8a74d967ce699b1ccea3c47ac8f8c.camel@wdc.com>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-3-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-3-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Fri, 2018-07-20 at 16:08 -0500, Mike Christie wrote:
+AD4- Hey Bart and Christoph,
+AD4- 
+AD4- Bart, I noticed we basically had what you are requesting but Christoph
+AD4- had moved the id code from the fabric drivers to lio core in this commit:
+AD4- 
+AD4- commit 2650d71e244fb3637b5f58a0080682a8bf9c7091
+AD4- Author: Christoph Hellwig +ADw-hch+AEA-lst.de+AD4-
+AD4- Date: Fri May 1 17:47:58 2015 +-0200
+AD4- 
+AD4- target: move transport ID handling to the core

Hello Mike,

I'm not in favor of reverting Christoph's patch because that patch simplified
the target code significantly. On the other hand, it's inconvenient that with
the current approach there is some code and knowledge in the target core that
should be in target drivers. I think that the code for parsing the initiator
name in srp+AF8-get+AF8-pr+AF8-transport+AF8-id() should be in the SRP target driver instead
of the core. When I added support for a new initiator name format in the SRP
target driver I overlooked that I had to update srp+AF8-get+AF8-pr+AF8-transport+AF8-id()
because that function is in the core instead of ib+AF8-srpt.c. See also commit
2dc98f09f9e6 (+ACI-IB/srpt: Use the source GUID as session name+ACI-). Christoph, do
you want me to add support for the new ib+AF8-srpt initiator name format in 
drivers/target/target+AF8-core+AF8-fabric+AF8-lib.c or should I find a way to move the
code for parsing the initiator name into ib+AF8-srpt.c?

Thanks,

Bart.