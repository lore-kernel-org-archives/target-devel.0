From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Thu, 30 Aug 2018 11:19:10 +0000
Subject: Re: [PATCHv2] iscsi-target: Don't use stack buffer for scatterlist
Message-Id: <yq18t4o5cgh.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180823203626.15108-1-labbott@redhat.com>
In-Reply-To: <20180823203626.15108-1-labbott@redhat.com> (Laura Abbott's
        message of "Thu, 23 Aug 2018 13:36:26 -0700")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Laura Abbott <labbott@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>, Mike Christie <mchristi@redhat.com>, Maurizio Lombardi <mlombard@redhat.com>, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org


> Fedora got a bug report of a crash with iSCSI:
>
> kernel BUG at include/linux/scatterlist.h:143!
> ...
> RIP: 0010:iscsit_do_crypto_hash_buf+0x154/0x180 [iscsi_target_mod]
> ...
>  Call Trace:
>   ? iscsi_target_tx_thread+0x200/0x200 [iscsi_target_mod]
>   iscsit_get_rx_pdu+0x4cd/0xa90 [iscsi_target_mod]
>   ? native_sched_clock+0x3e/0xa0
>   ? iscsi_target_tx_thread+0x200/0x200 [iscsi_target_mod]
>   iscsi_target_rx_thread+0x81/0xf0 [iscsi_target_mod]
>   kthread+0x120/0x140
>   ? kthread_create_worker_on_cpu+0x70/0x70
>   ret_from_fork+0x3a/0x50
>
> This is a BUG_ON for using a stack buffer with a scatterlist.  There
> are two cases that trigger this bug. Switch to using a dynamically
> allocated buffer for one case and do not assign a NULL buffer in
> another case.

Mike: Please review. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
