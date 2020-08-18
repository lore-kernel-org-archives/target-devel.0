From: David Disseldorp <ddiss@suse.de>
Date: Tue, 18 Aug 2020 14:11:25 +0000
Subject: Re: [PATCH] target:iscsi-target:Fix null pointer access while logout the iscsi session
Message-Id: <20200818161125.359383ef@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <1597749370-631500-1-git-send-email-wubo40@huawei.com>
In-Reply-To: <1597749370-631500-1-git-send-email-wubo40@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wu Bo <wubo40@huawei.com>
Cc: martin.petersen@oracle.com, michael.christie@oracle.com, bvanassche@acm.org, sudhakar.panneerselvam@oracle.com, mlombard@redhat.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linfeilong@huawei.com, liuzhiqiang26@huawei.com

Hi,

On Tue, 18 Aug 2020 19:16:10 +0800, Wu Bo wrote:

> From: Wu Bo <wubo40@huawei.com>
> 
> When I use fio to test the iscsi volumes and logout of the iscsi session
> at the same time, the following crash occurs:

The change looks reasonable here, but I'd like get a reproducer for it.
I've attempted something via:
https://github.com/ddiss/libiscsi/tree/async_logout_during_write
(run iscsi-test-cu --test iSCSI.iSCSITMF.LogoutDuringIOAsync)

Do you have any ideas why I'm not able to hit this oops?

Thanks, David
