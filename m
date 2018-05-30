From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Wed, 30 May 2018 10:04:27 +0000
Subject: Re: [RESEND] TCMUser: add read length support
Message-Id: <e94ffcc1-257a-53c6-2da5-8743904e5878@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <5b06ed25.3Xi5BduJFP9OUO6V%bstroesser@ts.fujitsu.com>
In-Reply-To: <5b06ed25.3Xi5BduJFP9OUO6V%bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 05/26/18 19:14, kbuild test robot wrote:

> Hi Bodo,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on linus/master]
> [also build test ERROR on v4.17-rc6]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
Sorry for the late response.

The missing 'SCF_TREAT_READ_AS_NORMAL'is defined in another patch from 
Lee Duncan.
The title of the patch is '[PATCH v4] target: transport should handle st 
FM/EOM/ILI reads'
Link: https://www.spinics.net/lists/target-devel/msg16738.html

According to an email from Martin K. Petersen from 05/18/18 18:26 he 
applied this patch to 4.18/scsi-queue.
Link: https://www.spinics.net/lists/target-devel/msg16743.html

HTH

Bodo

> url:    https://github.com/0day-ci/linux/commits/Bodo-Stroesser/TCMUser-add-read-length-support/20180526-231412
> config: x86_64-randconfig-x003-201820 (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-16) 7.3.0
> reproduce:
>          # save the attached .config to linux build tree
>          make ARCH=x86_64
>
> All errors (new ones prefixed by >>):
>
>     drivers//target/target_core_user.c: In function 'tcmu_handle_completion':
>>> drivers//target/target_core_user.c:1077:28: error: 'SCF_TREAT_READ_AS_NORMAL' undeclared (first use in this function)
>         se_cmd->se_cmd_flags |= SCF_TREAT_READ_AS_NORMAL;
>                                 ^~~~~~~~~~~~~~~~~~~~~~~~
>     drivers//target/target_core_user.c:1077:28: note: each undeclared identifier is reported only once for each function it appears in
>

