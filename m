Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28E3AC433E0
	for <target-devel@archiver.kernel.org>; Mon,  1 Mar 2021 15:47:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC53064DD2
	for <target-devel@archiver.kernel.org>; Mon,  1 Mar 2021 15:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237358AbhCAPrQ convert rfc822-to-8bit (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Mon, 1 Mar 2021 10:47:16 -0500
Received: from pio-pvt-msa3.bahnhof.se ([79.136.2.42]:42086 "EHLO
        pio-pvt-msa3.bahnhof.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236819AbhCAPrM (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 1 Mar 2021 10:47:12 -0500
X-Greylist: delayed 437 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Mar 2021 10:47:10 EST
Received: from localhost (localhost [127.0.0.1])
        by pio-pvt-msa3.bahnhof.se (Postfix) with ESMTP id 744583F58A;
        Mon,  1 Mar 2021 16:38:53 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at bahnhof.se
Received: from pio-pvt-msa3.bahnhof.se ([127.0.0.1])
        by localhost (pio-pvt-msa3.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id i9-t_67Qj7Uq; Mon,  1 Mar 2021 16:38:52 +0100 (CET)
Received: by pio-pvt-msa3.bahnhof.se (Postfix) with ESMTPA id 2D3143F578;
        Mon,  1 Mar 2021 16:38:52 +0100 (CET)
Received: from [2a00:801:74e:b91e::56a7:abde] (port=44588 helo=[10.81.178.210])
        by tnonline.net with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
        (Exim 4.93.0.4)
        (envelope-from <forza@tnonline.net>)
        id 1lGkdH-000MiN-Jf; Mon, 01 Mar 2021 16:38:51 +0100
Date:   Mon, 1 Mar 2021 16:38:49 +0100 (GMT+01:00)
From:   Forza <forza@tnonline.net>
To:     Mike Christie <michael.christie@oracle.com>,
        target-devel@vger.kernel.org
Message-ID: <2feabdd.b5c9def5.177ee7128e8@tnonline.net>
In-Reply-To: <0d561b83-1bb5-aa4c-8adc-953036e2f003@oracle.com>
References: <af031d3.b2327dec.177db1f2641@tnonline.net> <b4397eb1-db51-7cf2-b881-88fe7bcfa7bb@oracle.com> <24226ad.50248908.177dd3502ec@tnonline.net> <0d561b83-1bb5-aa4c-8adc-953036e2f003@oracle.com>
Subject: Re: Stability of FILEIO as backing store?
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Mailer: R2Mail2
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org



---- From: Mike Christie <michael.christie@oracle.com> -- Sent: 2021-02-26 - 17:12 ----

> On 2/26/21 1:19 AM, Forza wrote:
>> 
>> 
>> ---- From: michael.christie@oracle.com -- Sent: 2021-02-26 - 04:41 ----
>> 
>>> On 2/25/21 3:36 PM, Forza wrote:
>>>> Hi,
>>>>
>>>> I have a weird issue with using a file as backing store with a Win2016 server as initiator. 
>>>>
>>>> Very often if I reboot the Linux server the disk image becomes corrupt so that Windows cannot even detect the gpt partition table on it. It can happen even if I shut down the Windows machine before I reboot the Linux server.
>>>>
>>>> Initially I thought I would be write cache. But I've disabled that with no benefit to this problem. 
>>>>
>>>
>>> How are you disabling the write cache? What tools do you use? Is
>>> it targetcli or are you doing this manually via configfs?
>> 
>> I am using targetcli, using the documentation https://urldefense.com/v3/__http://linux-iscsi.org/Doc/LIO*20Admin*20Manual.pdf__;JSU!!GqivPVa7Brio!OYNbrN3Fseq8PE_-n67Mmb8_JdUUU_yWw_LcbeKvyKgKgP_iVH-X2u1vrU9RasK-Nvhz$ 
>> I created the backstore/fileio with write_back=false but this might not have disabled cache sinze I see in the saveconfig.json that it is still set to true. So I guess this can still be an issue =( 
>> 
>> 
>>>
>>> What is the output of
>>>
>>> cat /sys/kernel/config/target/core/fileio_$N/$name/info
>> 
>> Status: ACTIVATED  Max Queue Depth: 128  SectorSize: 512  HwMaxSectors: 16384
>>         TCM FILEIO ID: 0        File: /media/iscsi-tgt/dx_media_3.img  Size: 429496729600  Mode: Buffered-WCE Async: 0
>> 
> 
> I think you need to ask the people that maintain your tools (fedora or upstream
> https://github.com/open-iscsi/targetcli-fb), because for upstream's master branch
> it looks like doing write_back=false should work, but above we see "Mode: Buffered-WCE"
> and below we see emulate_write_cache=1 kike you mentioned.

I think you might be right.

In the end as I needed to get this to work, I swapped Fedora for Ubuntu Server 20.0.4.2 LTS with the HWE kernel. 

Since I changed to Ubuntu I have not had any issues. I've tested hard reboots and unclean shut downs with no issue. Go figure... 

Fedora automatically loads the saved config using "targetctl restore", while on Ubuntu automatic restore is not enabled, so I added a cron @reboot line to do "targetcli restoreconfig /etc/target/myconfig.json". Perhaps that avoids some race  during boot? 

Are there any technical differences between "targetctl restore" and "targetcli restoreconfig saveconfig.json"

There are some other changes that might be the most important. "Emulate_write_cache" is now false and /sys/config show "mode:o_dsync" instead of "buffered-wce" .

Also, the "aio" attribute  is different. Perhaps I set it manually in Fedora, but I cannot remember. It is not visible in /sys but is in the saveconfig.json.
Ubuntu:
  "storage_objects": [
    {
      "aio": false,
Fedora:
  "storage_objects": [
    {
      "aio": true,

Does "aio" mean Async I/O in this case? I could not find any documentation for this attribute. What implication would this have with false vs true? 

# grep . info
Status: ACTIVATED  Max Queue Depth: 128  SectorSize: 512  HwMaxSectors: 16384
        TCM FILEIO ID: 0        File: /media/iscsi-tgt/dx_media_3.img  Size: 429496729600  Mode: O_DSYNC Async: 0


# grep . attrib/*
attrib/alua_support:1
attrib/block_size:512
attrib/emulate_3pc:1
attrib/emulate_caw:1
attrib/emulate_dpo:1
attrib/emulate_fua_read:1
attrib/emulate_fua_write:1
attrib/emulate_model_alias:1
attrib/emulate_pr:1
attrib/emulate_rest_reord:0
attrib/emulate_tas:1
attrib/emulate_tpu:0
attrib/emulate_tpws:0
attrib/emulate_ua_intlck_ctrl:0
attrib/emulate_write_cache:0
attrib/enforce_pr_isids:1
attrib/force_pr_aptpl:0
attrib/hw_block_size:512
attrib/hw_max_sectors:16384
attrib/hw_pi_prot_type:0
attrib/hw_queue_depth:128
attrib/is_nonrot:0
attrib/max_unmap_block_desc_count:1
attrib/max_unmap_lba_count:8192
attrib/max_write_same_len:4096
attrib/optimal_sectors:16384
attrib/pgr_support:1
attrib/pi_prot_format:0
attrib/pi_prot_type:0
attrib/pi_prot_verify:0
attrib/queue_depth:128
attrib/unmap_granularity:1
attrib/unmap_granularity_alignment:0
attrib/unmap_zeroes_data:0



> 
>> 
>>> cat /sys/kernel/config/target/core/fileio_$N/$name/attrib/write_cache
>> 
>> This does not exist. The curent files are:
>> 
> 
> Sorry, I meant emulate_write_cache.
> 
>> # grep . *
>> alua_support:1
>> block_size:512
>> emulate_3pc:1
>> emulate_caw:1
>> emulate_dpo:1
>> emulate_fua_read:1
>> emulate_fua_write:1
>> emulate_model_alias:1
>> emulate_pr:1
>> emulate_rest_reord:0
>> emulate_tas:1
>> emulate_tpu:0
>> emulate_tpws:0
>> emulate_ua_intlck_ctrl:0
>> emulate_write_cache:1
>> enforce_pr_isids:1
>> force_pr_aptpl:0
>> hw_block_size:512
>> hw_max_sectors:16384
>> hw_pi_prot_type:0
>> hw_queue_depth:128
>> is_nonrot:0
>> max_unmap_block_desc_count:1
>> max_unmap_lba_count:8192
>> max_write_same_len:4096
>> optimal_sectors:16384
>> pgr_support:1
>> pi_prot_format:0
>> pi_prot_type:0
>> pi_prot_verify:0
>> queue_depth:128
>> unmap_granularity:1
>> unmap_granularity_alignment:0
>> unmap_zeroes_data:0


Thank you all for your inputs. I still would like to understand what wasn't right in the Fedora setup so that I might learn and avoid the specific pitfall in the future. 

Regards, 
Forza


