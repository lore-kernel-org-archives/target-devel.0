From: Wu Bo <wubo40@huawei.com>
Date: Thu, 20 Aug 2020 10:36:36 +0000
Subject: Re: [PATCH] target:iscsi-target:Fix null pointer access while logout the iscsi session
Message-Id: <49026bef-fb57-208d-c08c-cbdc3d166200@huawei.com>
List-Id: <target-devel.vger.kernel.org>
References: <1597749370-631500-1-git-send-email-wubo40@huawei.com>
 <20200818161125.359383ef@suse.de>
In-Reply-To: <20200818161125.359383ef@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Disseldorp <ddiss@suse.de>
Cc: martin.petersen@oracle.com, michael.christie@oracle.com, bvanassche@acm.org, sudhakar.panneerselvam@oracle.com, mlombard@redhat.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linfeilong@huawei.com, liuzhiqiang26@huawei.com

On 2020/8/18 22:11, David Disseldorp wrote:
> Hi,
> 
> On Tue, 18 Aug 2020 19:16:10 +0800, Wu Bo wrote:
> 
>> From: Wu Bo <wubo40@huawei.com>
>>
>> When I use fio to test the iscsi volumes and logout of the iscsi session
>> at the same time, the following crash occurs:
> 
> The change looks reasonable here, but I'd like get a reproducer for it.
> I've attempted something via:
> https://github.com/ddiss/libiscsi/tree/async_logout_during_write
> (run iscsi-test-cu --test iSCSI.iSCSITMF.LogoutDuringIOAsync)
> 
> Do you have any ideas why I'm not able to hit this oops?
> 
> Thanks, David
> 
> .
> 

Hi,

This is more difficult to reproduce it,
I found that the upstream already has a similar solution.

commit: e9d3009cb936bd0faf0719f68d98ad8afb1e613b
scsi: target: iscsi: Wait for all commands to finish before freeing a 
session.

Thanks, Wu Bo
