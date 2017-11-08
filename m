From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Date: Wed, 08 Nov 2017 21:29:27 +0000
Subject: Re: [PATCH 3/6] target: Fix quiese during transport_write_pending_qf endless loop
Message-Id: <6892cffb-3734-7bd7-aa42-1d91b70ee57b@linux.vnet.ibm.com>
List-Id: <target-devel.vger.kernel.org>
References: <1510115512-15617-1-git-send-email-nab@linux-iscsi.org>
 <1510115512-15617-4-git-send-email-nab@linux-iscsi.org>
In-Reply-To: <1510115512-15617-4-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>, Michael Cyr <mikecyr@linux.vnet.ibm.com>, Potnuri Bharat Teja <bharat@chelsio.com>, Sagi Grimberg <sagi@grimberg.me>


> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch fixes a potential end-less loop during QUEUE_FULL,
> where cmd->se_tfo->write_pending() callback fails repeatedly
> but __transport_wait_for_tasks() has already been invoked to
> quiese the outstanding se_cmd descriptor.
>
> To address this bug, this patch adds a CMD_T_STOP|CMD_T_ABORTED
> check within transport_write_pending_qf() and invokes the
> existing se_cmd->t_transport_stop_comp to signal quiese
> completion back to __transport_wait_for_tasks().
>
> Cc: Mike Christie <mchristi@redhat.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> Cc: Michael Cyr <mikecyr@linux.vnet.ibm.com>
> Cc: Potnuri Bharat Teja <bharat@chelsio.com>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>
Reviewed-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>


