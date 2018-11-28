From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 28 Nov 2018 23:52:21 +0000
Subject: Re: [PATCH 0/3] target: drop unneeded pi_prot_format and get_fabric_name()
Message-Id: <yq18t1c3glm.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20181123173613.4547-1-ddiss@suse.de>
In-Reply-To: <20181123173613.4547-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


David,

> This patchset removes unneeded se_dev_attrib.pi_prot_format and
> fabric_ops.get_fabric_name() struct members. Removal of the latter
> allowed for further cleanup due to the fact that all fabric modules
> except iscsi_target_mod provide matching strings for fabric_ops.name
> and fabric_ops.get_fabric_name() - use a new fabric_ops.fabric_alias
> member to handle the iscsi_target_mod special case.

Applied to 4.21/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
