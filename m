From: Mark Brown <broonie@kernel.org>
Date: Mon, 21 Sep 2020 16:58:21 +0000
Subject: Re: [PATCH 00/14] drop double zeroing
Message-Id: <160070750168.56292.17961674601916397869.b4-ty@kernel.org>
List-Id: <target-devel.vger.kernel.org>
References: <1600601186-7420-1-git-send-email-Julia.Lawall@inria.fr>
In-Reply-To: <1600601186-7420-1-git-send-email-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-spi@vger.kernel.org, Julia Lawall <Julia.Lawall@inria.fr>
Cc: linux-serial@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org, linux-block@vger.kernel.org, Yossi Leybovich <sleybo@amazon.com>, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, dmaengine@vger.kernel.org, linux-pci@vger.kernel.org, netdev@vger.kernel.org, linux-wireless@vger.kernel.org, linux-rdma@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, rds-devel@oss.oracle.com

On Sun, 20 Sep 2020 13:26:12 +0200, Julia Lawall wrote:
> sg_init_table zeroes its first argument, so the allocation of that argument
> doesn't have to.

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-next

Thanks!

[1/1] spi/topcliff-pch: drop double zeroing
      commit: ca03dba30f2b8ff45a2972c6691e4c96d8c52b3b

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark
