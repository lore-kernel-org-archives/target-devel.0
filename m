From: Greg-KH <gregkh@linuxfoundation.org>
Date: Thu, 16 Nov 2017 16:44:30 +0000
Subject: Re: [PATCH-4.9.y 2/2] qla2xxx: Fix incorrect tcm_qla2xxx_free_cmd use during TMR ABORT (v2)
Message-Id: <20171116164430.GF24442@kroah.com>
List-Id: <target-devel.vger.kernel.org>
References: <1510812307-14530-1-git-send-email-nab@linux-iscsi.org>
 <1510812307-14530-3-git-send-email-nab@linux-iscsi.org>
In-Reply-To: <1510812307-14530-3-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, stable <stable@vger.kernel.org>, Pascal de Bruijn <p.debruijn@unilogic.nl>, Lukasz Engel <lukasz.engel@softax.pl>, Quinn Tran <quinn.tran@cavium.com>

On Thu, Nov 16, 2017 at 06:05:07AM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> commit 6bcbb3174caa5f1ccc894f8ae077631659d5a629 upstream.
> 
> This patch drops two incorrect usages of tcm_qla2xxx_free_cmd()
> during TMR ABORT within tcm_qla2xxx_handle_data_work() and
> tcm_qla2xxx_aborted_task(), which where attempting to dispatch
> into workqueue context to do tcm_qla2xxx_complete_free() and
> subsequently invoke transport_generic_free_cmd().
> 
> This is incorrect because during TMR ABORT target-core will
> drop the outstanding se_cmd->cmd_kref references once it has
> quiesced the se_cmd via transport_wait_for_tasks(), and in
> the case of qla2xxx it should not attempt to do it's own
> transport_generic_free_cmd() once the abort has occured.
> 
> As reported by Pascal, this was originally manifesting as a
> BUG_ON(cmd->cmd_in_wq) in qlt_free_cmd() during TMR ABORT,
> with a LIO backend that had sufficently high enough WRITE
> latency to trigger a host side TMR ABORT_TASK.
> 
> (v2: Drop the qla_tgt_cmd->write_pending_abort_comp changes,
>      as they will be addressed in a seperate series)
> 
> Reported-by: Pascal de Bruijn <p.debruijn@unilogic.nl>
> Tested-by: Pascal de Bruijn <p.debruijn@unilogic.nl>
> Cc: Pascal de Bruijn <p.debruijn@unilogic.nl>
> Reported-by: Lukasz Engel <lukasz.engel@softax.pl>
> Cc: Lukasz Engel <lukasz.engel@softax.pl>
> Acked-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> Cc: Quinn Tran <quinn.tran@cavium.com>
> Cc: <stable@vger.kernel.org> # 3.10+
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c | 33 ---------------------------------
>  1 file changed, 33 deletions(-)

Thanks for this, but how about a backport for it for 4.4 and 3.18?

thanks,

greg k-h
