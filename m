From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Tue, 28 Jan 2020 03:09:41 +0000
Subject: Re: [EXT] [PATCH] tcm_qla2xxx: Make qlt_alloc_qfull_cmd() set cmd->se_cmd.map_tag
Message-Id: <yq1tv4gb7ka.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


> Reduce code duplication by introducing the tcm_qla2xxx_{get,rel}_cmd()
> functions. Introduce these functions in the tcm_qla2xxx.c source files
> such that the qla_target.c source file becomes independent of the SCSI
> target core header files. This patch fixes a bug, namely by ensuring that
> qlt_alloc_qfull_cmd() sets cmd->se_cmd.map_tag.

Applied to 5.7/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
