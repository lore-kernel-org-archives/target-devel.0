From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 12 Feb 2020 23:51:24 +0000
Subject: Re: [PATCH] Revert "target/core: Inline transport_lun_remove_cmd()"
Message-Id: <yq1wo8rs6tf.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200210051202.12934-1-bvanassche@acm.org>
In-Reply-To: <20200210051202.12934-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Sun, 9 Feb 2020 21:12:02 -0800")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, target-devel@vger.kernel.org, Pavel Zakharov <pavel.zakharov@delphix.com>, Mike Christie <mchristi@redhat.com>, stable@vger.kernel.org


Bart,

> Commit 83f85b8ec305 postponed the percpu_ref_put(&se_cmd->se_lun->lun_ref)
> call from command completion to the time when the final command reference is
> dropped. That approach is not compatible with the iSCSI target driver
> because the iSCSI target driver keeps the command with the highest stat_sn
> after it has completed until the next command is received (see also
> iscsit_ack_from_expstatsn()). Fix this regression by reverting commit
> 83f85b8ec305.

Applied to 5.6/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
