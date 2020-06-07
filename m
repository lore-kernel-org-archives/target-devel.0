From: Mike Christie <michael.christie@oracle.com>
Date: Sun, 07 Jun 2020 20:37:40 +0000
Subject: Re: [PATCH v4 0/4] target: fix NULL pointer dereference
Message-Id: <c0aab764-c787-a888-2cce-ff94f8fab949@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1591559913-8388-1-git-send-email-sudhakar.panneerselvam@oracle.com>
In-Reply-To: <1591559913-8388-1-git-send-email-sudhakar.panneerselvam@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>, martin.petersen@oracle.com, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: shirley.ma@oracle.com



On 6/7/20 2:58 PM, Sudhakar Panneerselvam wrote:
> The following set of commits address a NULL pointer dereference and some
> refactoring around this issue.
> 
> v4:
>   - initialize the LUN in transport_init_se_cmd()
> 
> v3:
>   - fix NULL pointer dereference when cdb initialization fails
> 
> v2:
>   - new helper is named as target_cmd_init_cdb()
>   - existing function, target_setup_cmd_from_cdb is renamed as
>     target_cmd_parse_cdb()
> 
> Sudhakar Panneerselvam (4):
>    target: factor out a new helper, target_cmd_init_cdb()
>    target: initialize LUN in transport_init_se_cmd().
>    target: fix NULL pointer dereference
>    target: rename target_setup_cmd_from_cdb() to target_cmd_parse_cdb()
> 
>   drivers/target/iscsi/iscsi_target.c    | 29 ++++++++++--------
>   drivers/target/target_core_device.c    | 19 +++++-------
>   drivers/target/target_core_tmr.c       |  4 +--
>   drivers/target/target_core_transport.c | 55 ++++++++++++++++++++++++++--------
>   drivers/target/target_core_xcopy.c     |  9 ++++--
>   drivers/usb/gadget/function/f_tcm.c    |  6 ++--
>   include/target/target_core_fabric.h    |  9 +++---
>   7 files changed, 83 insertions(+), 48 deletions(-)
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>
