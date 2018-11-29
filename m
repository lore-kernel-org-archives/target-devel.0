From: "Ly, Bryant" <bly@catalogicsoftware.com>
Date: Thu, 29 Nov 2018 01:19:22 +0000
Subject: Re: [PATCH v4 3/7] target: consistently null-terminate t10_wwn.model
Message-Id: <756F1029-DEF9-49DB-B73B-65F8C6E0D9A0@catalogicsoftware.com>
List-Id: <target-devel.vger.kernel.org>
References: <20181129010157.12687-4-ddiss@suse.de>
In-Reply-To: <20181129010157.12687-4-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org



> On Nov 28, 2018, at 7:01 PM, David Disseldorp <ddiss@suse.de> wrote:
> 
> The pscsi_set_inquiry_info() and emulate_model_alias_store() codepaths
> don't currently explicitly null-terminate t10_wwn.model.
> Add an extra byte to the t10_wwn.model buffer and perform null string
> termination in all cases.
> 
> dev_set_t10_wwn_model_alias() continues to truncate at the same length
> to avoid changing the model string for existing deployments.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
> drivers/target/target_core_configfs.c | 8 +++++---
> drivers/target/target_core_device.c   | 8 +++++---
> drivers/target/target_core_pscsi.c    | 6 ++++--
> drivers/target/target_core_spc.c      | 2 +-
> drivers/target/target_core_stat.c     | 4 ++--
> include/target/target_core_base.h     | 3 ++-
> 6 files changed, 19 insertions(+), 12 deletions(-)
> 
> 

Reviewed-by: Bryant G. Ly bly@catalogicsoftware.com
