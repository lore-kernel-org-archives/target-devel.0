From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Thu, 21 Mar 2019 00:37:29 +0000
Subject: Re: [PATCH] target:iscsi:fix np_ip_proto and np_sock_type in iscsit_setup_np
Message-Id: <yq1k1gt5agm.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1552488998-3604-1-git-send-email-hndksztwj@163.com>
In-Reply-To: <1552488998-3604-1-git-send-email-hndksztwj@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


tangwenji,

> In the switch, np_ip_proto and np_sock_type set different values
> according to np_network_transport, and then uniformly assign values,
> so the previous values are overwritten.

Applied to 5.2/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
