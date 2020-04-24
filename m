From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Date: Fri, 24 Apr 2020 04:16:30 +0000
Subject: Re: [PATCH v2 2/2] iscsi-target: Fix inconsistent debug message in __iscsi_target_sk_check_close
Message-Id: <DM6PR04MB4972B3BE33D83FE7BA78570986D00@DM6PR04MB4972.namprd04.prod.outlook.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200424035843.5914-1-houpu@bytedance.com>
 <20200424035843.5914-3-houpu@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hou Pu <houpu@bytedance.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "mchristi@redhat.com" <mchristi@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>

Ho

On 04/23/2020 08:59 PM, Hou Pu wrote:
> commit 25cdda95fda78d22d44157da15aa7ea34be3c804
> Author: Nicholas Bellinger<nab@linux-iscsi.org>
> Date:   Wed May 24 21:47:09 2017 -0700
>
>      iscsi-target: Fix initial login PDU asynchronous socket close OOPs

Thanks for the patch.

Did you get a chance to run checkpatch.pl on this patch ?
