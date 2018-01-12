From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Fri, 12 Jan 2018 22:30:50 +0000
Subject: Re: [PATCH] target: avoid NULL dereference in CHAP auth error path
Message-Id: <1515796250.21541.5.camel@haakon3.daterainc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi David,

Apologies for the delayed follow up.

On Wed, 2017-12-13 at 18:22 +0100, David Disseldorp wrote:
> If chap_server_compute_md5() fails early, e.g. via CHAP_N mismatch, then
> crypto_free_shash() is called with a NULL pointer which gets
> dereferenced in crypto_shash_tfm().
> 
> Fixes: 69110e3cedbb ("iscsi-target: Use shash and ahash")
> Suggested-by: Markus Elfring <elfring@users.sourceforge.net>
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
> This is a minimal fix, similar to Markus's
> "target/iscsi: Less function calls in chap_server_compute_md5() after error detection"
> patch, but without all of the coding-style changes mixed in.
> 
>  drivers/target/iscsi/iscsi_target_auth.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Applied, with a stable CC' for 4.6.y.

