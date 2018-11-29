From: "Ly, Bryant" <bly@catalogicsoftware.com>
Date: Thu, 29 Nov 2018 01:15:31 +0000
Subject: Re: [PATCH v4 6/7] target: remove hardcoded T10 Vendor ID in INQUIRY response
Message-Id: <D254F3B4-F29E-493A-BDA2-C709E20673DF@catalogicsoftware.com>
List-Id: <target-devel.vger.kernel.org>
References: <20181129010157.12687-7-ddiss@suse.de>
In-Reply-To: <20181129010157.12687-7-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org



> On Nov 28, 2018, at 7:01 PM, David Disseldorp <ddiss@suse.de> wrote:
> 
> Use the value stored in t10_wwn.vendor, which defaults to "LIO-ORG", but
> can be reconfigured via the vendor_id ConfigFS attribute.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
> drivers/target/target_core_spc.c | 8 +++++---
> 1 file changed, 5 insertions(+), 3 deletions(-)
> 

Reviewed-by: Bryant G. Ly bly@catalogicsoftware.com
