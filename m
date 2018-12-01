From: Hannes Reinecke <hare@suse.com>
Date: Sat, 01 Dec 2018 14:55:26 +0000
Subject: Re: [PATCH v5 2/5] target: consistently null-terminate t10_wwn strings
Message-Id: <36643ca6-0097-a68d-646c-ac6a637a6f1d@suse.com>
List-Id: <target-devel.vger.kernel.org>
References: <20181130233423.26556-3-ddiss@suse.de>
In-Reply-To: <20181130233423.26556-3-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 12/1/18 12:34 AM, David Disseldorp wrote:
> In preparation for supporting user provided vendor strings, add an extra
> byte to the vendor, model and revision arrays in struct t10_wwn. This
> ensures that the full INQUIRY data can be carried in the arrays along
> with a null-terminator.
> 
> Change a number of array readers and writers so that they account for
> explicit null-termination:
> - The pscsi_set_inquiry_info() and emulate_model_alias_store() codepaths
>    don't currently explicitly null-terminate; fix this.
> - Existing t10_wwn field dumps use for-loops which step over
>    null-terminators for right-padding.
>    + Use printf with width specifiers instead.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>   drivers/target/target_core_configfs.c | 14 +++++++---
>   drivers/target/target_core_device.c   | 49 ++++++++++++-----------------------
>   drivers/target/target_core_pscsi.c    | 18 ++++++++-----
>   drivers/target/target_core_spc.c      |  7 ++---
>   drivers/target/target_core_stat.c     | 32 +++++------------------
>   include/target/target_core_base.h     | 14 +++++++---
>   6 files changed, 61 insertions(+), 73 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
