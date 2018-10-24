From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 24 Oct 2018 01:19:55 +0000
Subject: Re: [PATCH 2/2] target: Don't request modules that aren't even built
Message-Id: <yq1a7n4gmys.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20181020164516.8719-1-roland@kernel.org>
In-Reply-To: <20181020164516.8719-1-roland@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Roland,

> If, for example, I don't enable CONFIG_TCM_PSCSI, then every time I
> load the target subsystem, I get an annoying
>
>     Unable to load target_core_pscsi
>
> kernel log message.  Instead let's only request_module() on things if
> that code is enabled.

Applied to 4.20/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
