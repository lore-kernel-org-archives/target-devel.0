From: Mike Christie <mchristi@redhat.com>
Date: Mon, 05 Aug 2019 17:15:50 +0000
Subject: Re: [RFC PATCH v2] target: tcmu: clean the nl_cmd of the udev when nl send fails
Message-Id: <5D486446.8010807@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190805004336.16181-1-lizhongfs@gmail.com>
In-Reply-To: <20190805004336.16181-1-lizhongfs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 08/04/2019 07:43 PM, Li Zhong wrote:
> If the userspace process crashes while we send the nl msg, it is possible
> that the cmd in curr_nl_cmd of tcmu_dev never gets reset to 0, and
> and returns busy for other commands after the userspace process is
> restartd.
> 
> More details below:
> 
> /backstores/user:file/file> set attribute dev_size 48
> Cannot set attribute dev_size: [Errno 3] No such process
> /backstores/user:file/file> set attribute dev_size 48
> Cannot set attribute dev_size: [Errno 16] Device or resource busy
> 
> with following kernel messages:
> [173605.747169] Unable to reconfigure device
> [173616.686674] tcmu daemon: command reply support 1.
> [173623.866978] netlink cmd 3 already executing on file
> [173623.866984] Unable to reconfigure device
> 
> Also, it is not safe to leave the nl_cmd in the list, and not get
> deleted.
> 
> This patch removes the nl_cmd from the list, and clear its data if
> it is not sent successfully.
> 
> Signed-off-by: Li Zhong <lizhongfs@gmail.com>


Acked-by: Mike Christie <mchristi@redhat.com>
