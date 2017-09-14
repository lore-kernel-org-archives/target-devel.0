From: Allen <allen.lkml@gmail.com>
Date: Thu, 14 Sep 2017 04:55:38 +0000
Subject: Re: [PATCH 01/10] arch:powerpc: return -ENOMEM on failed allocation
Message-Id: <CAOMdWSJvQMNJSnfekmM=N-CCaaJF_3HkP8ypZG+vWgWf0gWgfw@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <1505287939-14106-1-git-send-email-allen.lkml@gmail.com> <1505314401.8969.11.camel@perches.com>
In-Reply-To: <1505314401.8969.11.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, nouveau@lists.freedesktop.org, linux-crypto@vger.kernel.org, dri-devel@lists.freedesktop.org, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, netdev@vger.kernel.org, megaraidlinux.pdl@broadcom.com, target-devel@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-btrfs@vger.kernel.org

> I think the changelog for this series of conversions
> should show that you've validated the change by
> inspecting the return call chain at each modified line.
>
> Also, it seems you've cc'd the same mailing lists for
> all of the patches modified by this series.
>
> It would be better to individually address each patch
> in the series only cc'ing the appropriate maintainers
> and mailing lists.
>
> A cover letter would be good too.

 Point noted. Thanks.

- Allen
