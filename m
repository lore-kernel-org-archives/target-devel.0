From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Fri, 18 Oct 2019 01:41:57 +0000
Subject: Re: [PATCH] target: do not overwrite CDB byte 1
Message-Id: <yq1r23akexm.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <12498eab-76fd-eaad-1316-c2827badb76a@ts.fujitsu.com>
In-Reply-To: <12498eab-76fd-eaad-1316-c2827badb76a@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Bodo,

> passthrough_parse_cdb() - used by TCMU and PSCSI - attepts to reset
> the LUN field of SCSI-2 CDBs (bits 5,6,7 of byte 1).  The current code
> is wrong, as for newer commands not having the LUN field it overwrites
> relevant command bits (e.g. for SECURITY PROTOCOL IN / OUT) We think
> this code was unnecessary from the beginning or at least it is no
> longer useful. So we remove it entirely.

Applied to 5.4/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
