From: Maurizio Lombardi <mlombard@redhat.com>
Date: Fri, 02 Feb 2018 15:51:32 +0000
Subject: Re: [PATCH] target: move the rx hdr buffer out of the stack
Message-Id: <f9f2a704-a480-f31d-fea8-d3686ed7875f@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1517580954-3329-1-git-send-email-mlombard@redhat.com>
In-Reply-To: <1517580954-3329-1-git-send-email-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org



Dne 2.2.2018 v 15:15 Maurizio Lombardi napsal(a):
> --- a/drivers/target/iscsi/iscsi_target_login.c
> +++ b/drivers/target/iscsi/iscsi_target_login.c
> @@ -129,28 +129,41 @@ int iscsi_login_setup_crypto(struct iscsi_conn *conn)
>  	tfm = crypto_alloc_ahash("crc32c", 0, CRYPTO_ALG_ASYNC);
>  	if (IS_ERR(tfm)) {
>  		pr_err("crypto_alloc_ahash() failed\n");
> -		return -ENOMEM;
> +		goto err_exit;
> +	}
> +
> +	conn->conn_rx_buf = kmalloc(ISCSI_HDR_LEN, GFP_KERNEL);
> +	if (!conn->conn_rx_buf) {
> +		pr_err("kmalloc() failed for conn_rx_buf\n");
> +		goto err_free_ahash;
>  	}
>  

Probably conn_rx_buf should be initialized outside of iscsi_login_setup_crypto()
I will submit a V2 soon.

Maurizio
