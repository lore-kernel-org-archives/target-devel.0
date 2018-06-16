From: Zhu Lingshan <lszhu@suse.de>
Date: Sat, 16 Jun 2018 11:08:31 +0000
Subject: Re: [PATCH 01/33] TCMU PR: first commit to implement TCMU PR
Message-Id: <cd5d6523-00a7-bde0-8e6c-682217011126@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20180615182342.6239-1-lszhu@suse.com>
In-Reply-To: <20180615182342.6239-1-lszhu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hello Maged,

Thanks for your comment and help, please give me some time to process this.

Thanks,
BR
Zhu Lingshan

On 2018/6/16 19:04, Maged Mokhtar wrote:
> Hi Zhu,
>
> These are my comments for the patch set:
>
> 1) patches 18-24, 28, 30,32 (+ the yet to be implemented pr functions) :
> instead of bypassing target_core_pr.c and re-writing all the existing pr
> logic again, can we use existing code but just have get/set functions to
> read/write the pr data from/to the backend. Example of
> target_scsi3_emulate_pr_out:
>
> sense_reason_t target_scsi3_emulate_pr_out(struct se_cmd *cmd) {
> 	get pr data callback  /* new code */
> 	switch (sa) {
> 	case PRO_REGISTER:
> 		ret = core_scsi3_emulate_pro_register(..)
> 		break;
> 	case PRO_RESERVE:
> 		ret = core_scsi3_emulate_pro_reserve(..);
> 	..........
> 	}
> 	set pr data callback  /* new code */
> }
>
> This is over-simplified as there could be extra locking but should be
> relatively minor. target_core_pr.c can have default implementation to
> get/set from static variable. Backends can over-ride this to support
> clustered distribution but they would not need to re-implement pr logic.
>
> 2) patch 4: existing set pr function
> static int tcmu_set_dev_pr_info(struct tcmu_dev *udev, void *val)
> better use char* than void* since it is a null terminated string rather
> than a buffer with length
>
> 3) patch 4: existing set pr function
> static int tcmu_set_dev_pr_info(struct tcmu_dev *udev, void *val)
> better is
> static int tcmu_set_dev_pr_info(struct tcmu_dev *udev, char *val_old, char
> *val_new)
> so in addition to the new pr we also include the old pr, this will allow
> backends that support atomic operations like ceph to implement this via an
> atomic compare and set. This is the method used in existing SUSE
> target_core_rbd and is more robust in a clustered environment.
>
> 4) patch 20 tcmu_execute_pr_register_existing: the update key should also
> update any reservation by the old key (if any) in addition to the
> registration. Point 1) would avoid this.
>
> 5) patch 24 tcmu_execute_pr_read_keys: the add_len should reflect the
> total needed length rather than the truncated length. This was fixed
> recently in target_core_pr.c by David. Again Point 1) would avoid this.
>
> 6) patch 15:
> #define TCMU_PR_INFO_XATTR_MAX_SIZE 8192
> 	buf_remain = TCMU_PR_INFO_XATTR_ENCODED_MAXLEN(pr_info->num_regs);
> 	if (buf_remain > TCMU_PR_INFO_XATTR_MAX_SIZE) {
> 		pr_err("PR info too large for encoding: %zd\n", buf_remain);
> 		return -EINVAL;
> 	}
> should probably increase TCMU_PR_INFO_XATTR_MAX_SIZE, 8k limits
> registrations to 16 nexus
>
>
> 7) Minor observation, some patches could be combined, for example patches
> 5-17 deal with string decode/encode could be made in fewer patches.
>
> Maged
>
>
>
>

