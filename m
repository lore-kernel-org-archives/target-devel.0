From: Mike Christie <mchristi@redhat.com>
Date: Mon, 11 Jun 2018 21:19:41 +0000
Subject: Re: [PATCH 00/14] SCSI target patches for kernel v4.17
Message-Id: <5B1EE76D.7090909@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180301222632.31507-1-bart.vanassche@wdc.com>
In-Reply-To: <20180301222632.31507-1-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 03/01/2018 04:26 PM, Bart Van Assche wrote:
> Hello Nic,
> 
> This patch series simplifies task management function handling in the SCSI
> target core considerably. The following tests have been run against this patch
> series for both the iSCSI and SRPT target drivers:
> - Run the libiscsi conformance tests.
> - Run fio ${dev} in one shell and while sg_reset -d ${dev}; do :; done from
>   another shell. This is a good way to stress test TMF handling.
> - For the SRP target driver: run the srp-test software.
> 
> Please consider this patch series for kernel v4.17.
> 

The patches look ok to me.

Reviewed-by: Mike Christie <mchristi@redhat.com>

