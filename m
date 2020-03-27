From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Fri, 27 Mar 2020 02:33:36 +0000
Subject: Re: [PATCH RESEND 0/3] Fix a race condition in the target driver
Message-Id: <yq1bloiedbz.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200313170656.9716-1-mlombard@redhat.com>
In-Reply-To: <20200313170656.9716-1-mlombard@redhat.com> (Maurizio Lombardi's
        message of "Fri, 13 Mar 2020 18:06:53 +0100")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: target-devel@vger.kernel.org, martin.petersen@oracle.com, bvanassche@acm.org, ddiss@suse.de, mcoleman@datto.com, linux-scsi@vger.kernel.org


Maurizio,

> Multiple threads may try to destroy the same iscsi session structure
> by calling iscsit_close_session() and then end up hanging.
>
> This patchset modifies the driver so the session structure is
> destroyed by iscsit_close_connection() when the last connection gets
> closed, thus preventing the race condition.

Applied to 5.7/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
