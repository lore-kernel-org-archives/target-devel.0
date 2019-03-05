From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 05 Mar 2019 20:38:30 +0000
Subject: Re: [PATCH v1] scsi: tcmu: Switch to bitmap_zalloc()
Message-Id: <1551818310.31902.265.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20190304094434.57965-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20190304094434.57965-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, 2019-03-04 at 11:44 +-0200, Andy Shevchenko wrote:
+AD4 Switch to bitmap+AF8-zalloc() to show clearly what we are allocating.
+AD4 Besides that it returns pointer of bitmap type instead of opaque void +ACo.

Reviewed-by: Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4
