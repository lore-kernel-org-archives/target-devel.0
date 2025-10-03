Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B572326E70E
	for <target-devel@vger.kernel.org>; Fri,  3 Oct 2025 08:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759480842; cv=none; b=U0Y2QdHGdlFgemhLuJQyoqUi13maTxSx/+V3BJplAWmbSfWmgFIVreckeNxJH5C8J6B51Dy/DKzMEjF+8i/A5wZZgBX3oobGHrsRPa11gfbbAaLp8SQH4TMAtWBbkd+FDyLtn4RpMrVSaSAq4/ZO22bGB5V2Akfmm5x4oqZ/oYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759480842; c=relaxed/simple;
	bh=TFNuXojUxQ5sowkUWUwt/Zu4E1KP3EXf4UKwN5nr/50=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=m/G/Ggi0I7ohJeMiZDICAqu2MH/Dj3jbmhfT3JPEasEKAq1JJ0v3FKK7V4wt/XXRsjReXImywfZ+QFYO0l+LCOCegs0WVc2uWyZsxHbyDXZ9G+KgM/9o0fcJ/iUqnda7IyRwjAdpCZmXn8Avne1ugUWtqV8I3ugLpLzA1UzZ7vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SBlvPCnt; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SBlvPCnt"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-41174604d88so1000444f8f.2
        for <target-devel@vger.kernel.org>; Fri, 03 Oct 2025 01:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759480837; x=1760085637; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cio2lKvCKgwpMaSFyqyjcKvDHCLeYNpkbQFBjUDPl20=;
        b=SBlvPCntmLN/DwWuyu63Uo0ZEy32iPg2Hfqtx7bsAhr1F0JeKgdghkpLJY7nHxPCp3
         DWn3ecYs/fwFZGziPH6DFzf1qsTwfFyztEiMCq3ORoFsiFPeVomzL9vtNwgiWDap1Ju8
         8u43obXZjxFWnEP6fPGTlnsS9nMnQct0JEOcNA7oWNsAhd3mlEuf+bF37c6jiLvXwLCC
         CN2fJQ6KK0mqaIwNpw0jhYwjn7vHK7XB65z1a0NU0BzIRzjOLVmLqtg+TQ4K6TtlwOYW
         XGmvpZT4ytWokzDH7BqXKx++Dke5xOvOKR6T7fIKH+lvbesA5cAmeQtqZKNkb7uVB0bs
         I/VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759480837; x=1760085637;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cio2lKvCKgwpMaSFyqyjcKvDHCLeYNpkbQFBjUDPl20=;
        b=GaY4JIs4SgP5FezFRqw5uIiLHZDtF1vcvHi/YngiNFSTO3lvTY8WbZN2W3SwecFo4U
         u2eJM4+TlR2jLxvUpavq6mvKdTgmB/TAxcTmVfu0GML70Q6DjLXOCx+THikSgZWy+XFb
         nEWeyAINUEsxrw3K5QIH3Bqc5zwd7cKq8qXT4BujwVDtPe8ued7E7DY5BUe4xbD6/AhU
         ttl4UL2CD4VquD85/boY8u8bda0BwJr0oAeKurmTnLWxToXJaWMg/KO3RSb1Cm7ZSYRR
         9AX1gJPkIEN7JH+vG/ayGvo+ZDwJc7huu6nHVNC77N7iLQeXmbZtoYez7DpKh8fsOpWX
         uTLw==
X-Forwarded-Encrypted: i=1; AJvYcCWCI+9z0x2HkjzSGg73m/QY6ClTZZ2l3RELQWiCEGQI6ac4wYRrUW8ekiMbl1dxuKpp7xQeQPTAWbbIKZM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy24p3RG/hh26A8nlDS+tBdC/gSLWs5dV+4Us+EQripgoZbHJkf
	tQEULmarOSpGteY4nrPeJug6QTHDqr4vbeM9V4PMiEzT5EuCZ8/b64ar7z1T9Eua5EM=
X-Gm-Gg: ASbGnctBH6rA+bc9EZdPNQrzfDqVm7O1/ZZFvvYIgDiyyHA29H86AWBe2CEI98BYNdt
	V2QY91+1oYmqcQp/nny2eAEUPI8wEa1nuQfScB3DggSUvfrNHQ0Vw26aS71gqao7iRaWg4LIsS5
	FaNeYjIedQpt7H+dPJqxkZr8o1pCZMajAnUrqMV3wIlq7xpi/3hjt0i41NfpZOrD6g+M2Yr7xCN
	qNfE/KDbopdFvQzpMmkxDP4gLW70sPi8/2mI471mIzqfEfGauVaLdLNbTK2yLZRm2ZIbVDmO1Sn
	VVWUn+jG/XoKC0RvVRV74zxJttuYEmiQZVuDFoMOykidGtX+WLVyP6kJl+7HhSCtdDZ9Vq64QKj
	tOv/1g37FxAKVL0zDp8AQgpOFF80qsoOWNpeJEYgVbW8T1uSwElq4xnBb
X-Google-Smtp-Source: AGHT+IGFZM0FLnmzxxN+Lk4wUetj5MlaFNlOjNUzYIpmA97eR6LNDB8/moRk0p2yC0M/4i827Faq9Q==
X-Received: by 2002:a5d:5f94:0:b0:3ee:15b4:174c with SMTP id ffacd0b85a97d-42567159241mr1462331f8f.3.1759480836867;
        Fri, 03 Oct 2025 01:40:36 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4255d8a8542sm6954756f8f.9.2025.10.03.01.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 01:40:36 -0700 (PDT)
Date: Fri, 3 Oct 2025 11:40:33 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Tony Battersby <tonyb@cybernetics.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	linux-scsi <linux-scsi@vger.kernel.org>,
	target-devel@vger.kernel.org, scst-devel@lists.sourceforge.net,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH v2 11/16] scsi: qla2xxx: fix TMR failure handling
Message-ID: <202510031227.18psESZQ-lkp@intel.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f52cda16-4952-4b28-bbf7-d44f4e054490@cybernetics.com>

Hi Tony,

kernel test robot noticed the following build warnings:

url:    https://github.com/intel-lab-lkp/linux/commits/Tony-Battersby/Revert-scsi-qla2xxx-Perform-lockless-command-completion-in-abort-path/20250930-024814
base:   e5f0a698b34ed76002dc5cff3804a61c80233a7a
patch link:    https://lore.kernel.org/r/f52cda16-4952-4b28-bbf7-d44f4e054490%40cybernetics.com
patch subject: [PATCH v2 11/16] scsi: qla2xxx: fix TMR failure handling
config: i386-randconfig-141-20251002 (https://download.01.org/0day-ci/archive/20251003/202510031227.18psESZQ-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202510031227.18psESZQ-lkp@intel.com/

New smatch warnings:
drivers/scsi/qla2xxx/qla_target.c:5735 qlt_handle_abts_completion() error: we previously assumed 'mcmd' could be null (see line 5723)

Old smatch warnings:
drivers/scsi/qla2xxx/qla_target.c:671 qla24xx_delete_sess_fn() warn: can 'fcport' even be NULL?

vim +/mcmd +5735 drivers/scsi/qla2xxx/qla_target.c

6b0431d6fa20bd1 Quinn Tran      2018-09-04  5706  static void qlt_handle_abts_completion(struct scsi_qla_host *vha,
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5707  	struct rsp_que *rsp, response_t *pkt)
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5708  {
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5709  	struct abts_resp_from_24xx_fw *entry =
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5710  		(struct abts_resp_from_24xx_fw *)pkt;
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5711  	u32 h = pkt->handle & ~QLA_TGT_HANDLE_MASK;
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5712  	struct qla_tgt_mgmt_cmd *mcmd;
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5713  	struct qla_hw_data *ha = vha->hw;
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5714  
81bcf1c5cf0ee87 Bart Van Assche 2019-04-11  5715  	mcmd = qlt_ctio_to_cmd(vha, rsp, pkt->handle, pkt);
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5716  	if (mcmd == NULL && h != QLA_TGT_SKIP_HANDLE) {
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5717  		ql_dbg(ql_dbg_async, vha, 0xe064,
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5718  		    "qla_target(%d): ABTS Comp without mcmd\n",
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5719  		    vha->vp_idx);
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5720  		return;
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5721  	}
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5722  
6b0431d6fa20bd1 Quinn Tran      2018-09-04 @5723  	if (mcmd)
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5724  		vha  = mcmd->vha;

mcmd can be NULL

6b0431d6fa20bd1 Quinn Tran      2018-09-04  5725  	vha->vha_tgt.qla_tgt->abts_resp_expected--;
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5726  
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5727  	ql_dbg(ql_dbg_tgt, vha, 0xe038,
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5728  	    "ABTS_RESP_24XX: compl_status %x\n",
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5729  	    entry->compl_status);
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5730  
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5731  	if (le16_to_cpu(entry->compl_status) != ABTS_RESP_COMPL_SUCCESS) {
7ffa5b939751b66 Bart Van Assche 2020-05-18  5732  		if (le32_to_cpu(entry->error_subcode1) == 0x1E &&
7ffa5b939751b66 Bart Van Assche 2020-05-18  5733  		    le32_to_cpu(entry->error_subcode2) == 0) {
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5734  			if (qlt_chk_unresolv_exchg(vha, rsp->qpair, entry)) {
74dabbbd8bb833e Tony Battersby  2025-09-29 @5735  				qlt_free_ul_mcmd(ha, mcmd);
                                                                                                     ^^^^
But here it is dereferenced without checking.  Previously it called
tcm_qla2xxx_free_mcmd() which checks for NULL.

6b0431d6fa20bd1 Quinn Tran      2018-09-04  5736  				return;
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5737  			}
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5738  			qlt_24xx_retry_term_exchange(vha, rsp->qpair,
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5739  			    pkt, mcmd);
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5740  		} else {
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5741  			ql_dbg(ql_dbg_tgt, vha, 0xe063,
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5742  			    "qla_target(%d): ABTS_RESP_24XX failed %x (subcode %x:%x)",
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5743  			    vha->vp_idx, entry->compl_status,
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5744  			    entry->error_subcode1,
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5745  			    entry->error_subcode2);
74dabbbd8bb833e Tony Battersby  2025-09-29  5746  			qlt_free_ul_mcmd(ha, mcmd);
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5747  		}
e752a04e1bd14cc Bart Van Assche 2019-08-08  5748  	} else if (mcmd) {
74dabbbd8bb833e Tony Battersby  2025-09-29  5749  		qlt_free_ul_mcmd(ha, mcmd);
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5750  	}
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5751  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

