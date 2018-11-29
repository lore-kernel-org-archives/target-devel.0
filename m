From: "Ly, Bryant" <bly@catalogicsoftware.com>
Date: Thu, 29 Nov 2018 01:17:54 +0000
Subject: Re: [PATCH v4 2/7] target: consistently null-terminate t10_wwn.vendor
Message-Id: <94CA0DC7-559A-4893-A589-0C18AFD2D4AD@catalogicsoftware.com>
List-Id: <target-devel.vger.kernel.org>
References: <20181129010157.12687-3-ddiss@suse.de>
In-Reply-To: <20181129010157.12687-3-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org



> On Nov 28, 2018, at 7:01 PM, David Disseldorp <ddiss@suse.de> wrote:
> 
> In preparation for supporting user provided vendor strings, add an extra
> byte to t10_wwn.vendor which will ensure null string termination when an
> eight byte vendor string is provided by the user.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
> drivers/target/target_core_device.c | 6 ++++--
> drivers/target/target_core_pscsi.c  | 6 ++++--
> drivers/target/target_core_stat.c   | 4 ++--
> include/target/target_core_base.h   | 8 +++++++-
> 4 files changed, 17 insertions(+), 7 deletions(-)
> 
> 

Reviewed-by: Bryant G. Ly bly@catalogicsoftware.com
