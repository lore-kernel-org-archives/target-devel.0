From: Mike Christie <mchristi@redhat.com>
Date: Wed, 01 Aug 2018 17:11:31 +0000
Subject: Re: [PATCH 11/15] target: export initiator port values for all sessions
Message-Id: <5B61E9C3.9090004@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-12-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-12-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 08/01/2018 11:44 AM, Mike Christie wrote:
> 1. Create a file named "acl" in the session's dir.
> 2. For dynamic_node_acl=0 the acl file will return a empty string or

Miswrote this.

Above should be dynamic_node_acl=1

> "generate_node_acls=1" or "demo mode enabled".
> 3. For dynamic_node_acl=1 the acl file will return

This should be dynamic_node_acl=0

> se_node_acl->initiatorname which is the name of the acl in
> ..../tpgt_$N/acls/.
> 

