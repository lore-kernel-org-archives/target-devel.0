From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 07 Feb 2020 16:29:14 +0000
Subject: Re: IOZONE fails intermittently while toggling the interface
Message-Id: <a42fd32c-ff04-6bd9-508c-25ad38212d4e@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <CH2PR12MB4005D671F3D274C4D5FA0BAEDD1C0@CH2PR12MB4005.namprd12.prod.outlook.com>
In-Reply-To: <CH2PR12MB4005D671F3D274C4D5FA0BAEDD1C0@CH2PR12MB4005.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 2/7/20 6:00 AM, Dakshaja Uppalapati wrote:
> While testing iser with kernel 5.5, I see attached soft lockups.
> Logged in and ran iozone on mounted disks. While the traffic is running, toggled the initiators interface down to up for 13 secs.
> I see the attached hung task warnings in the target dmesg.
> # iozone -a -I -+d -g 32m
> 
> The same test with kernel-5.4 runs fine. I have suspected the following three commits which are all correlated, so removed these commits from 5.5 kernel, rebuilt the kernel and ran the same test then no issue is seen. Iozone is running successfully.
> 
> 80647a89eaf3f2: scsi: target: core: Release SPC-2 reservations when closing a session
> e9d3009cb936b: scsi: target: iscsi: Wait for all commands to finish before freeing a session
> 04060db41178c: scsi: RDMA/isert: Fix a recently introduced regression related to logout
> 
> I am trying to root cause the issue. Please do suggest me if you want me to  check some thing specific.

Hi Dakshaja,

Thanks for having included a call trace; that's very useful. I will try 
to reproduce this issue this weekend and will keep you posted.

Bart.
