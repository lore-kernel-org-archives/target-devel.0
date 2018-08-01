From: Bart Van Assche <Bart.VanAssche@wdc.com>
Date: Wed, 01 Aug 2018 17:38:17 +0000
Subject: Re: [PATCH 11/15] target: export initiator port values for all sessions
Message-Id: <08148199d6c88e6709d2c7e57c9f7b0a9090e330.camel@wdc.com>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-12-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-12-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, 2018-08-01 at 11:44 -0500, Mike Christie wrote:
+AD4- I agree knowing the acl info is useful, so how about the following:
+AD4- 
+AD4- 1. Create a file named +ACI-acl+ACI- in the session's dir.
+AD4- 2. For dynamic+AF8-node+AF8-acl+AD0-0 the acl file will return a empty string or
+AD4- +ACI-generate+AF8-node+AF8-acls+AD0-1+ACI- or +ACI-demo mode enabled+ACI-.
+AD4- 3. For dynamic+AF8-node+AF8-acl+AD0-1 the acl file will return
+AD4- se+AF8-node+AF8-acl-+AD4-initiatorname which is the name of the acl in
+AD4- ..../tpgt+AF8AJA-N/acls/.

Hello Mike,

That sounds fine to me. My personal preference is that the +ACI-acl+ACI- file is
empty if demo mode is enabled.

Thanks,

Bart.

