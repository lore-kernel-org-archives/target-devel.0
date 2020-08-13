From: David Disseldorp <ddiss@suse.de>
Date: Thu, 13 Aug 2020 11:08:25 +0000
Subject: Re: [RFC PATCH] scsi: target: detect XCOPY NAA descriptor conflicts
Message-Id: <20200813130825.67cf86d0@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20200813002142.13820-1-ddiss@suse.de>
In-Reply-To: <20200813002142.13820-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Mike Christie <michael.christie@oracle.com>

FWIW, tcmu-runner appears to use the same vpd_unit_serial -> NAA WWN
mapping logic. I'll provide a patch for it too, once we decide on the
best way to address this issue.

Cheers, David
