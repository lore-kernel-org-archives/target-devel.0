From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Tue, 26 Jun 2018 16:27:39 +0000
Subject: Re: tcmu: fix hung netlink requests and nl related cleanup V2
Message-Id: <yq1h8lp4io4.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1529703623-9606-1-git-send-email-mchristi@redhat.com>
In-Reply-To: <1529703623-9606-1-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Mike,

> The following patches fix the issues where the userspace daemon has
> crashed and left netlink requests dangling. The daemon can now block
> the interface, kill outstanding requests, reopen the netlink socket
> and then unblock and execute new requests.

Applied to 4.19/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
