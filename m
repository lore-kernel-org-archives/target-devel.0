From: Andrew Lunn <andrew@lunn.ch>
Date: Wed, 13 Sep 2017 12:09:09 +0000
Subject: Re: [PATCH 05/10] drivers:net: return -ENOMEM on allocation failure.
Message-Id: <20170913120909.GA11820@lunn.ch>
List-Id: <target-devel.vger.kernel.org>
References: <1505287939-14106-1-git-send-email-allen.lkml@gmail.com>
 <1505287939-14106-5-git-send-email-allen.lkml@gmail.com>
In-Reply-To: <1505287939-14106-5-git-send-email-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Allen Pais <allen.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, nouveau@lists.freedesktop.org, linux-crypto@vger.kernel.org, dri-devel@lists.freedesktop.org, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, netdev@vger.kernel.org, megaraidlinux.pdl@broadcom.com, target-devel@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-btrfs@vger.kernel.org

On Wed, Sep 13, 2017 at 01:02:14PM +0530, Allen Pais wrote:
> Signed-off-by: Allen Pais <allen.lkml@gmail.com>

Hi Allen

Although correct, if you look higher up the call chain, this appears
to be not so useful.

rlb_initialize() is only called by bond_alb_initialize(), and it
propagates the -1. That is only called by bond_open() with:

	if (bond_alb_initialize(bond, (BOND_MODE(bond) = BOND_MODE_ALB)))
		return -ENOMEM;

So you might want to also modify this code, to return the return
value, rather than use the hard coded ENOMEM.

Since you code is OK as far as it goes:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
