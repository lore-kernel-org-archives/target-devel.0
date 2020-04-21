From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Tue, 21 Apr 2020 15:48:16 +0000
Subject: Re: [RFC PATCH 07/12] target: add sysfs support
Message-Id: <c34ed5c7-a5a3-666c-c52a-352c19ddaf98@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200420191426.17055-1-mchristi@redhat.com>
 <20200420191426.17055-8-mchristi@redhat.com>
In-Reply-To: <20200420191426.17055-8-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <mchristi@redhat.com>, jsmart2021@gmail.com, bvanassche@acm.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 04/20/20 21:14, Mike Christie wrote:
> configfs does not work well when the kernel is initiating the creation
> of an object we want to export info for and the objects above/below it
> are created by the user. There are races/bugs like seen with this patch
> and the issue the original bug was trying to fix:
> 
> commit f19e4ed1e1edbfa3c9ccb9fed17759b7d6db24c6
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Thu Aug 29 23:13:30 2019 -0400
> 
>      configfs_register_group() shouldn't be (and isn't) called in
> rmdirable parts
> 
> The problem is that for many drivers like qla2xxx, iscsi, etc, session
> creation is done by the kernel when there is a login initiated by an
> initiator, but we need a common way to export the systems sessions so
> tools like targetcli can report basic info like what initaitors are
> logged in and daemons like tcmu-runner can track sessions for load
> balancing and PGRs.
> 
> This patch begins to add a sysfs interface that will initially be used
> to export LIO's sessions. The general layout will mirror the lio
> configfs tree:
> 
> scsi_target /
> `-- $fabric_driver
>      `-- target_name
>          |-- tpgt_1
>          |   `-- sessions
>          `-- tpgt_2
>              `-- sessions
> 
> iscsi example:
> scsi_target /
> `-- iscsi
>      `-- iqn.1999-09.com.lio:tgt1
>          |-- tpgt_1
>          |   `-- sessions
>          `-- tpgt_2
>              `-- sessions
> 

Depending on future implementation of session info passthrough in tcmu,
it might be helpful to have an additional folder "sessions" directly
in scsi_target. This folder should contain one link for each session in
the lower "sessions" folders. The name of the link should be the same as
used for the session and the link should point to the session.

Example:

scsi_target
|- sessions
|  |- session-1 -> ../iscsi/iqn.1999-09.com.lio:tgt1/tpgt_2/session-1
|  `- session-2 -> ../iscsi/iqn.1999-09.com.lio:tgt1/tpgt_1/session-2
`- iscsi
    `- iqn.1999-09.com.lio:tgt1
       |- tpgt_1
       |  `- sessions
       |     `- session-2
       `- tpgt_2
          `- sessions
             `- session-1

The link can help to easily find the session for a given session_id and
also provides the wwn/tpg info for a session which together with the
info exposed by the session attributes completes the nexus info.
