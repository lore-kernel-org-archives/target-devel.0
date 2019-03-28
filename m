From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Thu, 28 Mar 2019 00:33:55 +0000
Subject: Re: [PATCH V2] target:alua: fix the tg_pt_gps_count
Message-Id: <yq1d0mbx2fg.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1553695146-4352-1-git-send-email-hndksztwj@163.com>
In-Reply-To: <1553695146-4352-1-git-send-email-hndksztwj@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


tangwenji,

> Reducing the count should be alua_tg_pt_gps_count instead of
> alua_tg_pt_gps_counter when free alua group.

Applied to 5.2/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
