From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Thu, 19 Apr 2018 04:47:53 +0000
Subject: Re: [PATCHv2] target: prefer dbroot of /etc/target over /var/target
Message-Id: <yq14lk7ls3q.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180406183141.20089-1-lduncan@suse.com>
In-Reply-To: <20180406183141.20089-1-lduncan@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Lee,

> The target database root directory, dbroot, has defaulted to
> /var/target for a while, but its main client, targetcli-fb, has been
> moving it to /etc/target for quite some time. With the plethora of
> target drivers now appearing, it has become more difficult to
> initialize this attribute before use by any child drivers.
>
> If the directory /etc/target exists, use that as the DB
> root. Otherwise, fall back to using /var/target.
>
> The ability to override this dbroot attribute still exists via sysfs.

Applied to 4.18/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
