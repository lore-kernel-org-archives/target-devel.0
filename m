From: Pavel Zakharov <pavel.zakharov@delphix.com>
Date: Sun, 09 Feb 2020 02:43:32 +0000
Subject: Re: [LIO-target] BUG: Deleting a LUN hangs in transport_clear_lun_ref
Message-Id: <2B6C1870-457C-4754-8E1A-ECBBDFD07083@delphix.com>
List-Id: <target-devel.vger.kernel.org>
References: <9A92D656-A796-4858-85CD-3750BDACFA28@delphix.com>
 <a1291c13-628f-edf3-3778-56b25f02edaf@acm.org>
In-Reply-To: <a1291c13-628f-edf3-3778-56b25f02edaf@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Bart Van Assche <bvanassche@acm.org>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Bart,

I’ve built linux-stable, commit f757165705e92db62f85a1ad287e9251d1f2cd82 and could easily reproduce the issue.
I’ve rebuilt the kernel with patch 83f85b8ec305be9d65284de2921d8eeb6c7fcf12 reverted and that seems to fix the issue.

Regards,
Pavel

> On Feb 7, 2020, at 10:12 PM, Bart Van Assche <bvanassche@acm.org> wrote:
> 
> On 2020-02-07 10:48, Pavel Zakharov wrote:
>> I haven’t yet tried rebuilding the kernel with the patch reverted,> but that is the next step I’m planning to try once I figure out how
>> to do it.
> 
> Hi Pavel,
> 
> How about verifying as follows whether that patch is the root cause:
> 
> git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
> linux-kernel &&
> cd linux-kernel &&
> git revert 83f85b8ec305
> 
> and next configure, build and install the kernel, reboot and rerun your
> test.
> 
> Thanks,
> 
> Bart.
