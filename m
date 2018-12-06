From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Thu, 06 Dec 2018 12:54:13 +0000
Subject: Re: [PATCH v7 2/5] target: consistently null-terminate t10_wwn strings
Message-Id: <20181206125413.xf4mqspubiwuttk4@SPB-NB-133.local>
List-Id: <target-devel.vger.kernel.org>
References: <20181205121838.23982-3-ddiss@suse.de>
In-Reply-To: <20181205121838.23982-3-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, Dec 05, 2018 at 01:18:35PM +0100, David Disseldorp wrote:
> In preparation for supporting user provided vendor strings, add an extra
> byte to the vendor, model and revision arrays in struct t10_wwn. This
> ensures that the full INQUIRY data can be carried in the arrays along
> with a null-terminator.
> 
> Change a number of array readers and writers so that they account for
> explicit null-termination:
> - The pscsi_set_inquiry_info() and emulate_model_alias_store() codepaths
>   don't currently explicitly null-terminate; fix this.
> - Existing t10_wwn field dumps use for-loops which step over
>   null-terminators for right-padding.
>   + Use printf with width specifiers instead.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  drivers/target/target_core_configfs.c | 16 +++++++----
>  drivers/target/target_core_device.c   | 46 ++++++++++----------------------
>  drivers/target/target_core_pscsi.c    | 50 +++++++++++------------------------
>  drivers/target/target_core_spc.c      |  7 ++---
>  drivers/target/target_core_stat.c     | 32 +++++-----------------
>  include/target/target_core_base.h     | 14 +++++++---
>  6 files changed, 63 insertions(+), 102 deletions(-)
> 

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

Thank you,
Roman Bolshakov
