From: David Disseldorp <ddiss@suse.de>
Date: Sun, 14 Oct 2018 10:09:32 +0000
Subject: Re: [PATCH v3 4/5] target: split out helper for cxn timeout error stashing
Message-Id: <20181014120932.2801e22a@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sun, 14 Oct 2018 11:43:34 +0800, kbuild test robot wrote:

> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on target/master]
> [also build test ERROR on v4.19-rc7 next-20181012]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
...
>    drivers/target/iscsi/iscsi_target_util.c: In function 'iscsit_handle_nopin_response_timeout':
> >> drivers/target/iscsi/iscsi_target_util.c:902:36: error: 'sess' undeclared (first use in this function)

This patch is a v3 respin of an individual patch within the series:
[PATCH v2 0/5] target: improve Data-Out and NOP timeout error reporting
The sess declaration is provided in [PATCH v2 3/5].

I guess I'll resend entire series in future to avoid false kbuild
reports.

Cheers, David
