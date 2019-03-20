From: Mike Christie <mchristi@redhat.com>
Date: Wed, 20 Mar 2019 16:59:04 +0000
Subject: Re: [PATCH] target:iscsi:fix np_ip_proto and np_sock_type in iscsit_setup_np
Message-Id: <5C927158.7050706@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1552488998-3604-1-git-send-email-hndksztwj@163.com>
In-Reply-To: <1552488998-3604-1-git-send-email-hndksztwj@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 03/13/2019 09:56 AM, tangwenji wrote:
> From: tangwenji <tang.wenji@zte.com.cn>
> 
> In the switch, np_ip_proto and np_sock_type set different values according to np_network_transport, and then uniformly assign values, so the previous values are overwritten.
> 
> Signed-off-by: tangwenji <tang.wenji@zte.com.cn>
> ---
>  drivers/target/iscsi/iscsi_target_login.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
> index ae3209e..c526e66 100644
> --- a/drivers/target/iscsi/iscsi_target_login.c
> +++ b/drivers/target/iscsi/iscsi_target_login.c
> @@ -883,9 +883,6 @@ int iscsit_setup_np(
>  		return -EINVAL;
>  	}
>  
> -	np->np_ip_proto = IPPROTO_TCP;
> -	np->np_sock_type = SOCK_STREAM;
> -
>  	ret = sock_create(sockaddr->ss_family, np->np_sock_type,
>  			np->np_ip_proto, &sock);
>  	if (ret < 0) {
> 

This got added in 2013:

commit baa4d64b147a4064626f6597646ae8a330d9e2ed
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Wed Mar 6 21:54:13 2013 -0800

    iscsi-target: Initial traditional TCP conversion to iscsit_transport

so I guess SCTP does not get used a lot, or it somehow worked still. I
do not have a SCTP initiator to test, but it looks ok to me since it
looks like the original code.


Reviewed-by: Mike Christie <mchristi@redhat.com>
