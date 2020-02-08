From: Bart Van Assche <bvanassche@acm.org>
Date: Sat, 08 Feb 2020 03:12:06 +0000
Subject: Re: [LIO-target] BUG: Deleting a LUN hangs in transport_clear_lun_ref
Message-Id: <a1291c13-628f-edf3-3778-56b25f02edaf@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <9A92D656-A796-4858-85CD-3750BDACFA28@delphix.com>
In-Reply-To: <9A92D656-A796-4858-85CD-3750BDACFA28@delphix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Pavel Zakharov <pavel.zakharov@delphix.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

On 2020-02-07 10:48, Pavel Zakharov wrote:
> I haven’t yet tried rebuilding the kernel with the patch reverted,> but that is the next step I’m planning to try once I figure out how
> to do it.

Hi Pavel,

How about verifying as follows whether that patch is the root cause:

git clone
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
linux-kernel &&
cd linux-kernel &&
git revert 83f85b8ec305

and next configure, build and install the kernel, reboot and rerun your
test.

Thanks,

Bart.
