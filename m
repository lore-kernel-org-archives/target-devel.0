From: Chris Leech <cleech@redhat.com>
Date: Wed, 26 Jun 2019 17:33:37 +0000
Subject: Re: [PATCH V2] iscsi: set auth_protocol back to NULL if CHAP_A value is not supported.
Message-Id: <20190626173337.GA14883@localhost.localdomain>
List-Id: <target-devel.vger.kernel.org>
References: <20190626172734.20751-1-mlombard@redhat.com>
In-Reply-To: <20190626172734.20751-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, Jun 26, 2019 at 07:27:34PM +0200, Maurizio Lombardi wrote:
> If the CHAP_A value is not supported, the chap_server_open() function
> should free the auth_protocol pointer and set it to NULL, or
> we will leave a dangling pointer around.
> 
> [   66.010905] Unsupported CHAP_A value
> [   66.011660] Security negotiation failed.
> [   66.012443] iSCSI Login negotiation failed.
> [   68.413924] general protection fault: 0000 [#1] SMP PTI
> [   68.414962] CPU: 0 PID: 1562 Comm: targetcli Kdump: loaded Not tainted 4.18.0-80.el8.x86_64 #1
> [   68.416589] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> [   68.417677] RIP: 0010:__kmalloc_track_caller+0xc2/0x210
> 
> v2: use the chap_close() function and fix yet another dangling pointer
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>

Reviewed-by: Chris Leech <cleech@redhat.com>

> ---
>  drivers/target/iscsi/iscsi_target_auth.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
> index b6e4862cc242..51ddca2033e0 100644
> --- a/drivers/target/iscsi/iscsi_target_auth.c
> +++ b/drivers/target/iscsi/iscsi_target_auth.c
> @@ -81,6 +81,12 @@ static int chap_check_algorithm(const char *a_str)
>  	return CHAP_DIGEST_UNKNOWN;
>  }
>  
> +static void chap_close(struct iscsi_conn *conn)
> +{
> +	kfree(conn->auth_protocol);
> +	conn->auth_protocol = NULL;
> +}
> +
>  static struct iscsi_chap *chap_server_open(
>  	struct iscsi_conn *conn,
>  	struct iscsi_node_auth *auth,
> @@ -118,7 +124,7 @@ static struct iscsi_chap *chap_server_open(
>  	case CHAP_DIGEST_UNKNOWN:
>  	default:
>  		pr_err("Unsupported CHAP_A value\n");
> -		kfree(conn->auth_protocol);
> +		chap_close(conn);
>  		return NULL;
>  	}
>  
> @@ -133,19 +139,13 @@ static struct iscsi_chap *chap_server_open(
>  	 * Generate Challenge.
>  	 */
>  	if (chap_gen_challenge(conn, 1, aic_str, aic_len) < 0) {
> -		kfree(conn->auth_protocol);
> +		chap_close(conn);
>  		return NULL;
>  	}
>  
>  	return chap;
>  }
>  
> -static void chap_close(struct iscsi_conn *conn)
> -{
> -	kfree(conn->auth_protocol);
> -	conn->auth_protocol = NULL;
> -}
> -
>  static int chap_server_compute_md5(
>  	struct iscsi_conn *conn,
>  	struct iscsi_node_auth *auth,
> -- 
> Maurizio Lombardi
> 
