Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD448C433DB
	for <target-devel@archiver.kernel.org>; Fri, 26 Feb 2021 07:20:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 721B864EE1
	for <target-devel@archiver.kernel.org>; Fri, 26 Feb 2021 07:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbhBZHUw convert rfc822-to-8bit (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Fri, 26 Feb 2021 02:20:52 -0500
Received: from ste-pvt-msa1.bahnhof.se ([213.80.101.70]:25613 "EHLO
        ste-pvt-msa1.bahnhof.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbhBZHUj (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 26 Feb 2021 02:20:39 -0500
Received: from localhost (localhost [127.0.0.1])
        by ste-pvt-msa1.bahnhof.se (Postfix) with ESMTP id C24FA3F3AE;
        Fri, 26 Feb 2021 08:19:37 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at bahnhof.se
Received: from ste-pvt-msa1.bahnhof.se ([127.0.0.1])
        by localhost (ste-pvt-msa1.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3xl7NOrUF8Ww; Fri, 26 Feb 2021 08:19:36 +0100 (CET)
Received: by ste-pvt-msa1.bahnhof.se (Postfix) with ESMTPA id 8CF733F36E;
        Fri, 26 Feb 2021 08:19:36 +0100 (CET)
Received: from [192.168.0.126] (port=55406)
        by tnonline.net with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
        (Exim 4.93.0.4)
        (envelope-from <forza@tnonline.net>)
        id 1lFXPT-000E9r-UC; Fri, 26 Feb 2021 08:19:35 +0100
Date:   Fri, 26 Feb 2021 08:19:34 +0100 (GMT+01:00)
From:   Forza <forza@tnonline.net>
To:     michael.christie@oracle.com, target-devel@vger.kernel.org
Message-ID: <24226ad.50248908.177dd3502ec@tnonline.net>
In-Reply-To: <b4397eb1-db51-7cf2-b881-88fe7bcfa7bb@oracle.com>
References: <af031d3.b2327dec.177db1f2641@tnonline.net> <b4397eb1-db51-7cf2-b881-88fe7bcfa7bb@oracle.com>
Subject: Re: Stability of FILEIO as backing store?
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Mailer: R2Mail2
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org



---- From: michael.christie@oracle.com -- Sent: 2021-02-26 - 04:41 ----

> On 2/25/21 3:36 PM, Forza wrote:
>> Hi,
>> 
>> I have a weird issue with using a file as backing store with a Win2016 server as initiator. 
>> 
>> Very often if I reboot the Linux server the disk image becomes corrupt so that Windows cannot even detect the gpt partition table on it. It can happen even if I shut down the Windows machine before I reboot the Linux server.
>> 
>> Initially I thought I would be write cache. But I've disabled that with no benefit to this problem. 
>> 
> 
> How are you disabling the write cache? What tools do you use? Is
> it targetcli or are you doing this manually via configfs?

I am using targetcli, using the documentation http://linux-iscsi.org/Doc/LIO%20Admin%20Manual.pdf
I created the backstore/fileio with write_back=false but this might not have disabled cache sinze I see in the saveconfig.json that it is still set to true. So I guess this can still be an issue =( 


> 
> What is the output of
> 
> cat /sys/kernel/config/target/core/fileio_$N/$name/info

Status: ACTIVATED  Max Queue Depth: 128  SectorSize: 512  HwMaxSectors: 16384
        TCM FILEIO ID: 0        File: /media/iscsi-tgt/dx_media_3.img  Size: 429496729600  Mode: Buffered-WCE Async: 0


> cat /sys/kernel/config/target/core/fileio_$N/$name/attrib/write_cache

This does not exist. The curent files are:

# grep . *
alua_support:1
block_size:512
emulate_3pc:1
emulate_caw:1
emulate_dpo:1
emulate_fua_read:1
emulate_fua_write:1
emulate_model_alias:1
emulate_pr:1
emulate_rest_reord:0
emulate_tas:1
emulate_tpu:0
emulate_tpws:0
emulate_ua_intlck_ctrl:0
emulate_write_cache:1
enforce_pr_isids:1
force_pr_aptpl:0
hw_block_size:512
hw_max_sectors:16384
hw_pi_prot_type:0
hw_queue_depth:128
is_nonrot:0
max_unmap_block_desc_count:1
max_unmap_lba_count:8192
max_write_same_len:4096
optimal_sectors:16384
pgr_support:1
pi_prot_format:0
pi_prot_type:0
pi_prot_verify:0
queue_depth:128
unmap_granularity:1
unmap_granularity_alignment:0
unmap_zeroes_data:0


> 
> ?
> 
> If you do a sync manually after shutting down windows does it help?

No. 

> 
> Are you accessing this from multiple windows machines at the same time?

Only one client.


> What target driver are you using?
I am using FILEIO target. 


Here is the output of saveconfig.json. Originally I have two exports (dxdep2 dxmedia2) but added two more to test different settings (block size and aio). 

{
  "fabric_modules": [],
  "storage_objects": [
    {
      "aio": false,
      "alua_tpgs": [
        {
          "alua_access_state": 0,
          "alua_access_status": 0,
          "alua_access_type": 3,
          "alua_support_active_nonoptimized": 1,
          "alua_support_active_optimized": 1,
          "alua_support_offline": 1,
          "alua_support_standby": 1,
          "alua_support_transitioning": 1,
          "alua_support_unavailable": 1,
          "alua_write_metadata": 0,
          "implicit_trans_secs": 0,
          "name": "default_tg_pt_gp",
          "nonop_delay_msecs": 100,
          "preferred": 0,
          "tg_pt_gp_id": 0,
          "trans_delay_msecs": 0
        }
      ],
      "attributes": {
        "alua_support": 1,
        "block_size": 512,
        "emulate_3pc": 1,
        "emulate_caw": 1,
        "emulate_dpo": 1,
        "emulate_fua_read": 1,
        "emulate_fua_write": 1,
        "emulate_model_alias": 1,
        "emulate_pr": 1,
        "emulate_rest_reord": 0,
        "emulate_tas": 1,
        "emulate_tpu": 0,
        "emulate_tpws": 0,
        "emulate_ua_intlck_ctrl": 0,
        "emulate_write_cache": 1,
        "enforce_pr_isids": 1,
        "force_pr_aptpl": 0,
        "is_nonrot": 0,
        "max_unmap_block_desc_count": 1,
        "max_unmap_lba_count": 8192,
        "max_write_same_len": 4096,
        "optimal_sectors": 16384,
        "pgr_support": 1,
        "pi_prot_format": 0,
        "pi_prot_type": 0,
        "pi_prot_verify": 0,
        "queue_depth": 128,
        "unmap_granularity": 1,
        "unmap_granularity_alignment": 0,
        "unmap_zeroes_data": 0
      },
      "dev": "/media/iscsi-tgt/dx_media_3.img",
      "name": "dxmedia3",
      "plugin": "fileio",
      "size": 429496729600,
      "write_back": true,
      "wwn": "a53bd5cc-85d7-47dc-a4d2-9682e9a7b82a"
    },
    {
      "aio": false,
      "alua_tpgs": [
        {
          "alua_access_state": 0,
          "alua_access_status": 0,
          "alua_access_type": 3,
          "alua_support_active_nonoptimized": 1,
          "alua_support_active_optimized": 1,
          "alua_support_offline": 1,
          "alua_support_standby": 1,
          "alua_support_transitioning": 1,
          "alua_support_unavailable": 1,
          "alua_write_metadata": 0,
          "implicit_trans_secs": 0,
          "name": "default_tg_pt_gp",
          "nonop_delay_msecs": 100,
          "preferred": 0,
          "tg_pt_gp_id": 0,
          "trans_delay_msecs": 0
        }
      ],
      "attributes": {
        "alua_support": 1,
        "block_size": 512,
        "emulate_3pc": 1,
        "emulate_caw": 1,
        "emulate_dpo": 1,
        "emulate_fua_read": 1,
        "emulate_fua_write": 1,
        "emulate_model_alias": 1,
        "emulate_pr": 1,
        "emulate_rest_reord": 0,
        "emulate_tas": 1,
        "emulate_tpu": 0,
        "emulate_tpws": 0,
        "emulate_ua_intlck_ctrl": 0,
        "emulate_write_cache": 1,
        "enforce_pr_isids": 1,
        "force_pr_aptpl": 0,
        "is_nonrot": 0,
        "max_unmap_block_desc_count": 1,
        "max_unmap_lba_count": 8192,
        "max_write_same_len": 4096,
        "optimal_sectors": 16384,
        "pgr_support": 1,
        "pi_prot_format": 0,
        "pi_prot_type": 0,
        "pi_prot_verify": 0,
        "queue_depth": 128,
        "unmap_granularity": 1,
        "unmap_granularity_alignment": 0,
        "unmap_zeroes_data": 0
      },
      "dev": "/media/iscsi-tgt/dx_dep_3.img",
      "name": "dxdep3",
      "plugin": "fileio",
      "size": 966367641600,
      "write_back": true,
      "wwn": "253f2cc0-209c-4a93-b110-9dc45e52229e"
    },
    {
      "aio": true,
      "alua_tpgs": [
        {
          "alua_access_state": 0,
          "alua_access_status": 0,
          "alua_access_type": 3,
          "alua_support_active_nonoptimized": 1,
          "alua_support_active_optimized": 1,
          "alua_support_offline": 1,
          "alua_support_standby": 1,
          "alua_support_transitioning": 1,
          "alua_support_unavailable": 1,
          "alua_write_metadata": 0,
          "implicit_trans_secs": 0,
          "name": "default_tg_pt_gp",
          "nonop_delay_msecs": 100,
          "preferred": 0,
          "tg_pt_gp_id": 0,
          "trans_delay_msecs": 0
        }
      ],
      "attributes": {
        "alua_support": 1,
        "block_size": 4096,
        "emulate_3pc": 1,
        "emulate_caw": 1,
        "emulate_dpo": 1,
        "emulate_fua_read": 1,
        "emulate_fua_write": 1,
        "emulate_model_alias": 1,
        "emulate_pr": 1,
        "emulate_rest_reord": 0,
        "emulate_tas": 1,
        "emulate_tpu": 0,
        "emulate_tpws": 0,
        "emulate_ua_intlck_ctrl": 0,
        "emulate_write_cache": 1,
        "enforce_pr_isids": 1,
        "force_pr_aptpl": 0,
        "is_nonrot": 0,
        "max_unmap_block_desc_count": 1,
        "max_unmap_lba_count": 8192,
        "max_write_same_len": 4096,
        "optimal_sectors": 2048,
        "pgr_support": 1,
        "pi_prot_format": 0,
        "pi_prot_type": 0,
        "pi_prot_verify": 0,
        "queue_depth": 128,
        "unmap_granularity": 1,
        "unmap_granularity_alignment": 0,
        "unmap_zeroes_data": 0
      },
      "dev": "/media/iscsi-tgt/dx_media_2.img",
      "name": "dxmedia2",
      "plugin": "fileio",
      "size": 858993459200,
      "write_back": true,
      "wwn": "da09b66d-5b23-4540-ab4a-f00b03af294f"
    },
    {
      "aio": true,
      "alua_tpgs": [
        {
          "alua_access_state": 0,
          "alua_access_status": 0,
          "alua_access_type": 3,
          "alua_support_active_nonoptimized": 1,
          "alua_support_active_optimized": 1,
          "alua_support_offline": 1,
          "alua_support_standby": 1,
          "alua_support_transitioning": 1,
          "alua_support_unavailable": 1,
          "alua_write_metadata": 0,
          "implicit_trans_secs": 0,
          "name": "default_tg_pt_gp",
          "nonop_delay_msecs": 100,
          "preferred": 0,
          "tg_pt_gp_id": 0,
          "trans_delay_msecs": 0
        }
      ],
      "attributes": {
        "alua_support": 1,
        "block_size": 4096,
        "emulate_3pc": 1,
        "emulate_caw": 1,
        "emulate_dpo": 1,
        "emulate_fua_read": 1,
        "emulate_fua_write": 1,
        "emulate_model_alias": 1,
        "emulate_pr": 1,
        "emulate_rest_reord": 0,
        "emulate_tas": 1,
        "emulate_tpu": 0,
        "emulate_tpws": 0,
        "emulate_ua_intlck_ctrl": 0,
        "emulate_write_cache": 1,
        "enforce_pr_isids": 1,
        "force_pr_aptpl": 0,
        "is_nonrot": 0,
        "max_unmap_block_desc_count": 1,
        "max_unmap_lba_count": 8192,
        "max_write_same_len": 4096,
        "optimal_sectors": 2048,
        "pgr_support": 1,
        "pi_prot_format": 0,
        "pi_prot_type": 0,
        "pi_prot_verify": 0,
        "queue_depth": 128,
        "unmap_granularity": 1,
        "unmap_granularity_alignment": 0,
        "unmap_zeroes_data": 0
      },
      "dev": "/media/iscsi-tgt/dx_dep_2.img",
      "name": "dxdep2",
      "plugin": "fileio",
      "size": 858993459200,
      "write_back": true,
      "wwn": "924a476a-482f-414e-8011-83909d8b3b6e"
    }
  ],
  "targets": [
    {
      "fabric": "iscsi",
      "tpgs": [
        {
          "attributes": {
            "authentication": 0,
            "cache_dynamic_acls": 1,
            "default_cmdsn_depth": 64,
            "default_erl": 0,
            "demo_mode_discovery": 1,
            "demo_mode_write_protect": 1,
            "fabric_prot_type": 0,
            "generate_node_acls": 0,
            "login_keys_workaround": 1,
            "login_timeout": 15,
            "netif_timeout": 2,
            "prod_mode_write_protect": 0,
            "t10_pi": 0,
            "tpg_enabled_sendtargets": 1
          },
          "chap_password": "{redacted}",
          "chap_userid": "iqn.1991-05.com.microsoft:{redacted}",
          "enable": true,
          "luns": [
            {
              "alias": "0cc1743f36",
              "alua_tg_pt_gp_name": "default_tg_pt_gp",
              "index": 1,
              "storage_object": "/backstores/fileio/dxmedia3"
            },
            {
              "alias": "3d56464288",
              "alua_tg_pt_gp_name": "default_tg_pt_gp",
              "index": 0,
              "storage_object": "/backstores/fileio/dxdep3"
            },
            {
              "alias": "5f63b78f76",
              "alua_tg_pt_gp_name": "default_tg_pt_gp",
              "index": 3,
              "storage_object": "/backstores/fileio/dxmedia2"
            },
            {
              "alias": "aa08fefd1d",
              "alua_tg_pt_gp_name": "default_tg_pt_gp",
              "index": 2,
              "storage_object": "/backstores/fileio/dxdep2"
            }
          ],
          "node_acls": [
            {
              "attributes": {
                "dataout_timeout": 5,
                "dataout_timeout_retries": 5,
                "default_erl": 0,
                "nopin_response_timeout": 30,
                "nopin_timeout": 15,
                "random_datain_pdu_offsets": 0,
                "random_datain_seq_offsets": 0,
                "random_r2t_offsets": 0
              },
              "chap_mutual_password": "{redacted}",
              "chap_mutual_userid": "{redacted}",
              "chap_password": "{redacted}",
              "chap_userid": "iqn.1991-05.com.microsoft:{redacted}",
              "mapped_luns": [
                {
                  "alias": "a2cce5a7e4",
                  "index": 1,
                  "tpg_lun": 1,
                  "write_protect": false
                },
                {
                  "alias": "5e0c5884fa",
                  "index": 0,
                  "tpg_lun": 0,
                  "write_protect": false
                },
                {
                  "alias": "3fb61f1c01",
                  "index": 3,
                  "tpg_lun": 3,
                  "write_protect": false
                },
                {
                  "alias": "ff50cee375",
                  "index": 2,
                  "tpg_lun": 2,
                  "write_protect": false
                }
              ],
              "node_wwn": "iqn.1991-05.com.microsoft:{redacted}"
            }
          ],
          "parameters": {
            "AuthMethod": "CHAP,None",
            "DataDigest": "CRC32C",
            "DataPDUInOrder": "Yes",
            "DataSequenceInOrder": "Yes",
            "DefaultTime2Retain": "20",
            "DefaultTime2Wait": "4",
            "ErrorRecoveryLevel": "2",
            "FirstBurstLength": "65536",
            "HeaderDigest": "CRC32C",
            "IFMarkInt": "Reject",
            "IFMarker": "No",
            "ImmediateData": "Yes",
            "InitialR2T": "Yes",
            "MaxBurstLength": "262144",
            "MaxConnections": "2",
            "MaxOutstandingR2T": "1",
            "MaxRecvDataSegmentLength": "8192",
            "MaxXmitDataSegmentLength": "262144",
            "OFMarkInt": "Reject",
            "OFMarker": "No",
            "TargetAlias": "LIO Target"
          },
          "portals": [
            {
              "ip_address": "{redacted}",
              "iser": false,
              "offload": false,
              "port": 3260
            }
          ],
          "tag": 1
        }
      ],
      "wwn": "iqn.2020-02.{redacted}:san01"
    }
  ]
}


Thanks! 

/Forza


