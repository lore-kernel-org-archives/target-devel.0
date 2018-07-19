From: Bart Van Assche <Bart.VanAssche@wdc.com>
Date: Thu, 19 Jul 2018 15:37:39 +0000
Subject: Re: [PATCH 11/15] target: export initiator port values for all sessions
Message-Id: <846935c203adf73183b63f9ae649b24074bcfdb2.camel@wdc.com>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-12-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-12-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sun, 2018-07-15 at 18:16 -0500, Mike Christie wrote:
+AD4- +-	if (se+AF8-sess-+AD4-se+AF8-tpg-+AD4-se+AF8-tpg+AF8-tfo-+AD4-sess+AF8-get+AF8-initiator+AF8-sid) +AHs-
+AD4- +-		len +AD0- snprintf(page, PAGE+AF8-SIZE, +ACIAJQ-s 0x+ACU-6phN+AFw-n+ACI-,
+AD4- +-			       se+AF8-sess-+AD4-se+AF8-node+AF8-acl-+AD4-initiatorname,
+AD4- +-			       +ACY-se+AF8-sess-+AD4-sess+AF8-bin+AF8-isid)+ADs-
+AD4- +-	+AH0- else +AHs-
+AD4- +-		len +AD0- snprintf(page, PAGE+AF8-SIZE, +ACIAJQ-s+AFw-n+ACI-,
+AD4- +-			       se+AF8-sess-+AD4-se+AF8-node+AF8-acl-+AD4-initiatorname)+ADs-
+AD4- +-	+AH0-

Hello Mike,

The general recommendation for configfs is that each attribute contains a
single value, just like for sysfs. Patch 11/15 exports two values through
a single attribute. Have you considered to split the above into two
attributes, namely the initiator name and the ISID? Can the initiator name
be changed into a soft link to the se+AF8-node+AF8-acl configfs directory to make
it easy for shell scripts to retrieve additional initiator configuration
information?

Thanks,

Bart.