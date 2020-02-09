From: Bart Van Assche <bvanassche@acm.org>
Date: Sun, 09 Feb 2020 05:14:18 +0000
Subject: Re: [LIO-target] BUG: Deleting a LUN hangs in transport_clear_lun_ref
Message-Id: <c8f4816c-8cb5-04ab-f992-e137ea9b4a56@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <9A92D656-A796-4858-85CD-3750BDACFA28@delphix.com>
 <a1291c13-628f-edf3-3778-56b25f02edaf@acm.org>
 <2B6C1870-457C-4754-8E1A-ECBBDFD07083@delphix.com>
In-Reply-To: <2B6C1870-457C-4754-8E1A-ECBBDFD07083@delphix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Pavel Zakharov <pavel.zakharov@delphix.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

On 2020-02-08 18:43, Pavel Zakharov wrote:
> Hi Bart,
> 
> I’ve built linux-stable, commit f757165705e92db62f85a1ad287e9251d1f2cd82 and could easily reproduce the issue.
> I’ve rebuilt the kernel with patch 83f85b8ec305be9d65284de2921d8eeb6c7fcf12 reverted and that seems to fix the issue.

Hi Pavel,

Thanks for having run these tests. I will post a revert of commit
83f85b8ec305.

Bart.
