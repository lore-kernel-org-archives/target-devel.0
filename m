From: Bart Van Assche <bvanassche@acm.org>
Date: Sat, 25 Jan 2020 05:55:43 +0000
Subject: Re: [PATCH] tcm_qla2xxx: Make qlt_alloc_qfull_cmd() set cmd->se_cmd.map_tag
Message-Id: <b21b981b-bbb3-2362-63a6-39cb0e7ddfbb@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200103192719.205158-1-bvanassche@acm.org>
In-Reply-To: <20200103192719.205158-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 2020-01-03 11:27, Bart Van Assche wrote:
> Reduce code duplication by introducing the tcm_qla2xxx_{get,rel}_cmd()
> functions. Introduce these functions in the tcm_qla2xxx.c source files
> such that the qla_target.c source file becomes independent of the SCSI
> target core header files. This patch fixes a bug, namely by ensuring that
> qlt_alloc_qfull_cmd() sets cmd->se_cmd.map_tag.

Ping?
