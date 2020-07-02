From: Mike Christie <michael.christie@oracle.com>
Date: Thu, 02 Jul 2020 01:43:16 +0000
Subject: [PATCH 0/7] target: misc fixes for 5.9
Message-Id: <1593654203-12442-1-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, bstroesser@ts.fujitsu.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

The following patches were made over Martin's 5.9 queue branch. They fix
some bugs that intersect with the sysfs/configfs patchset I've been
posting

These patches are not critical so are best for 5.9 or later. They fix
the SPEC_I_PT handling and how we report the iscsi inititor transport id
which seems to have always been broken and I do not think anyone uses.
There is also a fix for a leak during target_core_mod rmmod which is
rare.
