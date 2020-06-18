From: Mike Christie <michael.christie@oracle.com>
Date: Thu, 18 Jun 2020 16:04:20 +0000
Subject: Re: [PATCH v2 0/2] scsi: target: tcmu: fix crashes on ARM
Message-Id: <97507025-12ac-d58d-6929-20ba6599451b@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200618131632.32748-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200618131632.32748-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: JiangYu <lnsyyj@hotmail.com>, Daniel Meyerholt <dxm523@gmail.com>

On 6/18/20 8:16 AM, Bodo Stroesser wrote:
> This small series of patches consists of:
>     [PATCH 1/2 v2] scsi: target: tcmu: Optimize use of flush_dcache_page
>     [PATCH 2/2 v2] scsi: target: tcmu: Fix crash in tcmu_flush_dcache_range
> 
> Together with commit
>     8c4e0f212398 scsi: target: tcmu: Fix size in calls to tcmu_flush_dcache_range
> these patches fix crashes in tcmu on ARM.
> 
> The first patch of this series already was sent some weeks ago
> as "PATCH RFC", since it was untested at that time.
> 
> Meanwhile I added patch 2 of the series to fix the crash reported in:
>     https://urldefense.com/v3/__https://github.com/open-iscsi/tcmu-runner/issues/627__;!!GqivPVa7Brio!Nzsi6AfJJQIssE3tLed42r5EKmR0PmlYozji6dVy16oPnVKLMTCsE87jNrIgx6hasnfy$
>     https://urldefense.com/v3/__https://bugzilla.kernel.org/show_bug.cgi?id 8045__;!!GqivPVa7Brio!Nzsi6AfJJQIssE3tLed42r5EKmR0PmlYozji6dVy16oPnVKLMTCsE87jNrIgx9cTxaSo$
> 
> All three patches together were tested on ARM with kernel
> 4.19.118 and 5.7.2 (see github issue and bugzilla).
> 
> ---
> v2: sent with a valid subject line.
> 

Acked-by: Mike Christie <michael.christie@oracle.com>
