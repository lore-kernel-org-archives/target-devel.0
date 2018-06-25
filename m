From: Xiubo Li <xiubli@redhat.com>
Date: Mon, 25 Jun 2018 02:16:41 +0000
Subject: Re: tcmu: fix hung netlink requests and nl related cleanup V2
Message-Id: <a295a7b7-b4e8-e860-a297-1c7966bff9d9@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1529703623-9606-1-git-send-email-mchristi@redhat.com>
In-Reply-To: <1529703623-9606-1-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 2018/6/23 5:40, Mike Christie wrote:
> The following patches fix the issues where the userspace daemon
> has crashed and left netlink requests dangling. The daemon
> can now block the interface, kill outstanding requests, reopen
> the netlink socket and then unblock and execute new requests.
>
> The patches were made over Martin's for-next branch.
>
> v2:
> - Return BUSY error immediately when there is a running command.
> - Fix nl skb leak when device is blocked.
> - Fix check for valid block_netlink input.
> - Break out nl code cleanup into separate patch.

Tested it with the corner cases, which are mainly for adding and 
removing cases.

Tested-by: Xiubo Li <xiubli@redhat.com>

BRs
Xiubo


> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


