From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Thu, 08 Aug 2019 01:52:36 +0000
Subject: Re: [RFC PATCH v2] target: tcmu: clean the nl_cmd of the udev when nl send fails
Message-Id: <yq1sgqcctjv.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <5D446BC2.9000303@redhat.com>
        <20190805004336.16181-1-lizhongfs@gmail.com>
In-Reply-To: <20190805004336.16181-1-lizhongfs@gmail.com> (Li Zhong's message
        of "Mon, 5 Aug 2019 08:43:36 +0800")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zhong <lizhongfs@gmail.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com, mchristi@redhat.com


Li,

> If the userspace process crashes while we send the nl msg, it is
> possible that the cmd in curr_nl_cmd of tcmu_dev never gets reset to
> 0, and and returns busy for other commands after the userspace process
> is restartd.

Applied to 5.4/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
