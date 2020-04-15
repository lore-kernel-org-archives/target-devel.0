From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 15 Apr 2020 02:23:03 +0000
Subject: Re: [RFC PATCH 1/5] target: add sysfs support
Message-Id: <b6b87cff-c359-b7f6-ffd0-ff5b49dccbb8@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200414051514.7296-1-mchristi@redhat.com>
 <20200414051514.7296-2-mchristi@redhat.com>
In-Reply-To: <20200414051514.7296-2-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <mchristi@redhat.com>, jsmart2021@gmail.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org

On 2020-04-13 22:15, Mike Christie wrote:
> target_core/
> `-- $fabric_driver
>     `-- target_name
>         |-- tpgt_1
>         |   `-- sessions
>         `-- tpgt_2
>             `-- sessions
> 
> iscsi example:
> target_core/
> `-- iscsi
>     `-- iqn.1999-09.com.lio:tgt1
>         |-- tpgt_1
>         |   `-- sessions
>         `-- tpgt_2
>             `-- sessions

After the SCSI target core was added to the kernel tree an NVMe target
core was added. How about using the name "scsi_target" for the top-level
directory instead of "target_core" to prevent confusion with the NVMe
target?

Thanks,

Bart.
