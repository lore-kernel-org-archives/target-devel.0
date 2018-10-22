From: Christoph Hellwig <hch@lst.de>
Date: Mon, 22 Oct 2018 08:57:15 +0000
Subject: Re: [PATCH 2/2] target: Don't request modules that aren't even built
Message-Id: <20181022085715.GC18755@lst.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181020164516.8719-1-roland@kernel.org>
In-Reply-To: <20181020164516.8719-1-roland@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sat, Oct 20, 2018 at 09:45:16AM -0700, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> If, for example, I don't enable CONFIG_TCM_PSCSI, then every time I load
> the target subsystem, I get an annoying
> 
>     Unable to load target_core_pscsi
> 
> kernel log message.  Instead let's only request_module() on things if that
> code is enabled.
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>

I guess this ok.  I aways thought these request_module calls were a
horrible idea to start with, but just removing them now migh break
existing setups..

Reviewed-by: Christoph Hellwig <hch@lst.de>
