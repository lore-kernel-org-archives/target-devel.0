From: David Disseldorp <ddiss@suse.de>
Date: Tue, 28 May 2019 08:20:49 +0000
Subject: Re: [Patch v2] target/iscsi: fix possible condition with no effect (if == else)
Message-Id: <20190528102049.4927905e@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20190528012151.GA4845@hari-Inspiron-1545>
In-Reply-To: <20190528012151.GA4845@hari-Inspiron-1545>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Tue, 28 May 2019 06:51:52 +0530, Hariprasad Kelam wrote:

> fix below warning reported by coccicheck
> 
> drivers/target/iscsi/iscsi_target_nego.c:175:6-8: WARNING: possible
> condition with no effect (if = else)
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
> ---
> Changes in v2: treat SRP as unsupported authtype.
>                Remove unnecessary else
>                return 2 in all unsupported cases

Reviewed-by: David Disseldorp <ddiss@suse.de>

Cheers, David
