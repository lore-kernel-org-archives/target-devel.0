Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4F21B3721
	for <target-devel@vger.kernel.org>; Wed, 31 Jul 2024 13:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722433760; cv=none; b=kO0T0lqsTBsmUErtmLbrFxPKK93DdT23pMPilblQcrbYaDzy7Wf/qrIdKViHvbbpUfZ1PUu86wMamvssTN90QWWeE0yVpBUSYHdGw8wK6dk/ODCr2GcZLYbAWHKYut9o3KtdQyCPSbBclXyIZaYbn+SCTn/LhriE1PGJwFcbH64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722433760; c=relaxed/simple;
	bh=o4l74PQcXPReDyKF5WVrGtH8cUWVMWA/ZKWC8LIyVv4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aNuy0RjcKvzT6umHXZf8/2kJkW+csED03/rBoiCu0U+/M0yU+ywaxZhG9fAoYyWam3zprAUn4/Wgpc6keRdKbzYxxRd3KoD9Asjfod6V0C9vX6pPO3kbAYjpYa8nkQcT5y0QGqwrvDPTMCnUQhCdbfT1WF4Q7I9enF/i3IFzTxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=DcQ1eJzH; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="DcQ1eJzH"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1722433750; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=8m2qCK6hh7qpZ9jvzAw3NzYjF0bUP9h6o0tkL93yLHo=;
	b=DcQ1eJzHNZS3Bp6IYBayIbgI0wdPl/wrYF4DnBRmVXUJldlWwdeLXhHaWyBLr3/XLMK5auzdMUViRCQgqq7qISkz5aqsjmkSgxLNSspZpEsieFSD+h/k+AZ3a95HjUsKrDls0bE3AOGJjb9xwPYdfM0RUciYJSvPG11nKno42hQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067113;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0WBjX-SE_1722433746;
Received: from 30.27.95.6(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WBjX-SE_1722433746)
          by smtp.aliyun-inc.com;
          Wed, 31 Jul 2024 21:49:09 +0800
Message-ID: <7393595f-f0a4-4351-834f-4668ca4fa475@linux.alibaba.com>
Date: Wed, 31 Jul 2024 21:49:06 +0800
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: tcm_loop and aborted TMRs
To: michael.christie@oracle.com
Cc: Maurizio Lombardi <mlombard@redhat.com>, target-devel@vger.kernel.org,
 Bodo Stroesser <bostroesser@gmail.com>,
 Dmitry Bogdanov <d.bogdanov@yadro.com>
References: <CAFL455kjQeqvPqd1CUqs7f6xUjrrDqR1h7edizusAtj130HCPg@mail.gmail.com>
 <caad6a7a-c30c-a3ac-7932-f5a19c877ffc@oracle.com>
 <e07f0fa5-d59d-36f2-d99b-73e32af3282e@gmail.com>
 <20221121133550.GB5248@yadro.com>
 <addec585-4271-cd9c-fcf0-fd780f269aa8@oracle.com>
 <20221125084920.GC5248@yadro.com>
 <0a6eb2d4-1158-5268-27d5-454edbf9f566@oracle.com>
 <87d2d228-a4ac-9103-0f1c-57c691f91f0f@gmail.com>
 <457f3c8b-87ac-dcf4-6e6e-a41321d2151f@oracle.com>
 <0d7112bb-f6f1-455f-9351-26b09fdebf7c@linux.alibaba.com>
 <043c42de-be25-40b6-8f10-3ce02099b00d@oracle.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <043c42de-be25-40b6-8f10-3ce02099b00d@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Michael,

On 2024/7/31 05:40, michael.christie@oracle.com wrote:
> On 7/24/24 8:42 AM, Gao Xiang wrote:
>> Hi all,
>>
>> On 2022/12/8 11:45, Mike Christie wrote:
>>> On 12/1/22 8:15 AM, Bodo Stroesser wrote:
>>>> Are we sure qla, loop and xen are the only drivers that handle aborted
>>>> TMRs incorrectly?
>>>
>>> I'm not sure now. When we looked at this before I was only checking
>>> for crashes, but didn't check if there could be issues like where
>>> the driver needed to do some cleanup in their aborted_task callout
>>> but hasn't been doing it.
>>>
>>> For example ibmvscsi's aborted_task callout won't crash because the
>>> fields it references are ok for a IO or tmr se_cmds. It doesn't do
>>> vio_iu(iue)->srp.tsk_mgmt or vio_iu(iue)->srp.cmd in the aborted_task
>>> callout and just accesses the se_cmd and ibmvscsis_cmd. So we are ok
>>> there. However, I didn't look at the driver to see if maybe it did need
>>> to do some cleanup in the aborted_task callout and we just haven't
>>> been doing it.
>>>
>>> Same for the other drivers. I only checked if aborted_task would crash.
>>> Also we have a new driver efct, so we need to review that as well.
>>
>>
>> Sorry I have very little knowledge of TCMU, but currently we have
>> some call traces stuck as below:
>>
>> [811824.868078] task:kworker/u256:1  state:D stack:    0 pid:213661
>> ppid:     2 flags:0x00004000
>> [811824.868084] Workqueue: scsi_tmf_24 scmd_eh_abort_handler
>> [811824.868085] Call Trace:
>> [811824.868091]  __schedule+0x1ac/0x480
>> [811824.868092]  schedule+0x46/0xb0
>> [811824.868095]  schedule_timeout+0xe5/0x130
>> [811824.868110]  ? transport_generic_handle_tmr+0xb9/0xd0 [target_core_mod]
>> [811824.868112]  ? __prepare_to_swait+0x4f/0x70
>> [811824.868114]  wait_for_completion+0x71/0xc0
>> [811824.868118]  tcm_loop_issue_tmr+0xbb/0x100 [tcm_loop]
>> [811824.868120]  tcm_loop_abort_task+0x3d/0x50 [tcm_loop]
>> [811824.868121]  scmd_eh_abort_handler+0x7b/0x210
>> [811824.868124]  process_one_work+0x1a8/0x340
>> [811824.868125]  worker_thread+0x49/0x2f0
>> [811824.868126]  ? rescuer_thread+0x350/0x350
>> [811824.868127]  kthread+0x118/0x140
>> [811824.868129]  ? __kthread_bind_mask+0x60/0x60
>> [811824.868131]  ret_from_fork+0x1f/0x30
>> [811824.868166] task:kworker/121:2   state:D stack:    0 pid:242954
>> ppid:     2 flags:0x00004000
>> [811824.868172] Workqueue: events target_tmr_work [target_core_mod]
>> [811824.868172] Call Trace:
>> [811824.868174]  __schedule+0x1ac/0x480
>> [811824.868175]  schedule+0x46/0xb0
>> [811824.868176]  schedule_timeout+0xe5/0x130
>> [811824.868177]  ? asm_sysvec_apic_timer_interrupt+0x12/0x20
>> [811824.868178]  ? __prepare_to_swait+0x4f/0x70
>> [811824.868179]  wait_for_completion+0x71/0xc0
>> [811824.868184]  target_put_cmd_and_wait+0x5d/0xb0 [target_core_mod]
>> [811824.868192]  core_tmr_abort_task.cold+0x187/0x21a [target_core_mod]
>> [811824.868198]  target_tmr_work+0xa3/0xf0 [target_core_mod]
>> [811824.868200]  process_one_work+0x1a8/0x340
>> [811824.868201]  worker_thread+0x49/0x2f0
>> [811824.868202]  ? rescuer_thread+0x350/0x350
>> [811824.868202]  kthread+0x118/0x140
>> [811824.868203]  ? __kthread_bind_mask+0x60/0x60
>> [811824.868204]  ret_from_fork+0x1f/0x30
>>
>> I'm not sure how to recover from this state.  Is it resolved upstream?
>>
> 
> It's not.
> 
> I think the safest thing is to just revert the patch which caused this
> 
> commit db5b21a24e01d354  "scsi: target/core: Use system workqueues for TMF".
> 
> because we don't currently have the resources to fix qla.
> 
> Do you want to send the patch? If not, I can send it.

Thanks for the reply.

I have very little knowledge and no time on this, just confirm its
current status.  But yeah, it'd be better to resolve, anyway.

Thanks,
Gao Xiang
