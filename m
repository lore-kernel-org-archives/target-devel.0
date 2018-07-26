From: Xiubo Li <xiubli@redhat.com>
Date: Thu, 26 Jul 2018 05:07:54 +0000
Subject: Re: [PATCH 0/9] tcmu: configuration fixes and cleanups
Message-Id: <2898c0c9-46f9-b7dc-4617-637b6b807ba5@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1532372871-7128-1-git-send-email-mchristi@redhat.com>
In-Reply-To: <1532372871-7128-1-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 2018/7/24 3:07, Mike Christie wrote:
> The following patches were made over Martin's for-next branch.
>
> The first patch fixes a locking bug in the command setup path. The rest
> of the patches fix several bugs and cleanup the setup and configuration
> code paths.
It looks good to me.

This is also fixing the following TCMU crash:
"[PATCH] tcmu: fix crash for dereferencing the released udev->mb_addr 
memory"

Thanks.

>
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


