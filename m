From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Thu, 18 Jan 2018 09:22:45 +0000
Subject: Re: [PATCH 1/1] tcmu: fix cmd user after free
Message-Id: <1516267365.24576.245.camel@haakon3.daterainc.com>
List-Id: <target-devel.vger.kernel.org>
References: <1516048679-8704-1-git-send-email-mchristi@redhat.com>
In-Reply-To: <1516048679-8704-1-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, 2018-01-15 at 14:37 -0600, Mike Christie wrote:
> If we are failing the command due to a qfull timeout we are
> also freeing the tcmu command, so we cannot access it later
> to get the se_cmd.
> 
> Note: The clearing of cmd->se_cmd is not needed. We do not check
> it later for something like determining if the command was failed
> due to a timeout. As a result I am dropping it.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/target/target_core_user.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 

Applied.

