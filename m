From: Xiubo Li <lixiubo@cmss.chinamobile.com>
Date: Mon, 11 Dec 2017 02:58:57 +0000
Subject: Re: [RFC PATCH 0/3] Fix target_core_user userspace restarts
Message-Id: <ee521311-fcae-c383-2641-468d09fd6ddf@cmss.chinamobile.com>
List-Id: <target-devel.vger.kernel.org>
References: <1512544099-7520-1-git-send-email-mchristi@redhat.com>
In-Reply-To: <1512544099-7520-1-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

Hey Mike,

We have test this patch series together with your userspace
PR: https://github.com/open-iscsi/tcmu-runner/pull/339
And till now both the crash and restart cases work well.

Thanks,
BRs
Xiubo



On 2017年12月06日 15:08, Mike Christie wrote:
> The following patches were made over this patchset:
>
> https://www.spinics.net/lists/target-devel/msg16283.html
>
> The patches allow userspace to recover from unclean shutdowns
> by adding 2 device attrs which can be used to stop new IO and
> reset the tcmu ring buffer (memory used to pass commands/responses
> between user and kernel space).
>



