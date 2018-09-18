From: Mike Christie <mchristi@redhat.com>
Date: Tue, 18 Sep 2018 16:42:31 +0000
Subject: Re: [PATCH] scsi: tcmu: setup one timeout timer for each cmd
Message-Id: <5BA12AF7.7090004@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180918103255.15209-1-xiubli@redhat.com>
In-Reply-To: <20180918103255.15209-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 09/18/2018 05:32 AM, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Currently there has one cmd timeout timer for each udev, and whenever
> there has any new coming cmd it will update the timer. And for some
> corner case the timer is always working only for the ringbuffer's
> newest cmd. That's to say the timer won't be fired even there has one
> cmd stuck for a very long time.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  drivers/target/target_core_user.c | 69 +++++++++++++++----------------
>  1 file changed, 34 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 9cd404acdb82..ed3d6f055037 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -157,7 +157,6 @@ struct tcmu_dev {
>  
>  	struct idr commands;
>  
> -	struct timer_list cmd_timer;
>  	unsigned int cmd_time_out;
>  
>  	struct timer_list qfull_timer;
> @@ -190,6 +189,7 @@ struct tcmu_cmd {
>  	uint32_t *dbi;
>  
>  	unsigned long deadline;
> +	struct timer_list cmd_timer;
>  

I think you can fix this for qfull at the same time and we will not have
to do a mix of per cmd timer along with per device handling.

In tcmu_check_expired_cmd/check_timedout_devices add a next_deadline
variable and when we loop over all the cmds with the idr_for_each have
tcmu_check_expired_cmd return the cmd->deadline. check_timedout_devices
will then track the next timeout value to use and do a mod_timer to set it.

In tcmu_setup_cmd_timer you would only mod_timer if the timer is not
already pending already, so we do not keep resetting it like we do today.
