From: "Ly, Bryant" <bly@catalogicsoftware.com>
Date: Thu, 29 Nov 2018 01:18:47 +0000
Subject: Re: [PATCH v4 4/7] target: consistently null-terminate t10_wwn.revision
Message-Id: <59A175F3-0D33-48BB-86B0-68DD1D90233B@catalogicsoftware.com>
List-Id: <target-devel.vger.kernel.org>
References: <20181129010157.12687-5-ddiss@suse.de>
In-Reply-To: <20181129010157.12687-5-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org



> On Nov 28, 2018, at 7:01 PM, David Disseldorp <ddiss@suse.de> wrote:
> 
> The pscsi_set_inquiry_info() codepath doesn't currently explicitly
> null-terminate t10_wwn.revision.
> Add an extra byte to the t10_wwn.model buffer and perform null string
> termination in all cases.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
> drivers/target/target_core_device.c | 6 ++++--
> drivers/target/target_core_pscsi.c  | 4 +++-
> drivers/target/target_core_spc.c    | 5 +++--
> drivers/target/target_core_stat.c   | 4 ++--
> include/target/target_core_base.h   | 3 ++-
> 5 files changed, 14 insertions(+), 8 deletions(-)
> 

Reviewed-by: Bryant G. Ly bly@catalogicsoftware.com
