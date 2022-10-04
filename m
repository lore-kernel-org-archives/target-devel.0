Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F29C433F5
	for <target-devel@archiver.kernel.org>; Tue,  4 Oct 2022 11:24:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiJDLYk (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 4 Oct 2022 07:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiJDLYj (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 4 Oct 2022 07:24:39 -0400
X-Greylist: delayed 322 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 04 Oct 2022 04:24:35 PDT
Received: from zimbra.acetelecom.hu (zimbra.acetelecom.hu [109.74.48.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2151D6
        for <target-devel@vger.kernel.org>; Tue,  4 Oct 2022 04:24:34 -0700 (PDT)
Received: from zimbra.acetelecom.hu (localhost [127.0.0.1])
        by zimbra.acetelecom.hu (Postfix) with ESMTPS id 7C9D9320817
        for <target-devel@vger.kernel.org>; Tue,  4 Oct 2022 13:19:09 +0200 (CEST)
Received: from zimbra.acetelecom.hu (localhost [127.0.0.1])
        by zimbra.acetelecom.hu (Postfix) with ESMTPS id 610EA320819
        for <target-devel@vger.kernel.org>; Tue,  4 Oct 2022 13:19:09 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra.acetelecom.hu 610EA320819
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acetelecom.hu;
        s=9709D91E-7624-11E9-BDE6-48C9EA6B7834; t=1664882349;
        bh=SI8Lf44sRIDtoWJ8XAtbRrED1RDBeRvbKmhAwcqrd68=;
        h=Message-ID:Date:MIME-Version:To:From;
        b=kf9/33l9QCRQ4zRnzgpie75JuV1Wt0V1pkDq1WHngM5DbAPr+lUmV/KJorwc7BIbm
         aad3t8GEuMNLKjMxH4NH93WlkWPBa+Ls/ZG7d+8SSh9sXL7fk3+7POwSCclZlxisLo
         UIUCr+ljcQDDL1U3ZuUWCIz+G085Ub7LHQ3W1X1eA3foI40wWqSmmjv+9ONYwkweix
         RfBcuLbyYI3SCHOvq8O2M5gsNJ0cm33g5T9k443V+z3wGd2Tt0vJ1xOuS09Al+UBeO
         UtNeZw56OZQQtxEm649MTE2VHpFotrv/uoHtziocfccSVGP2ki7Bnw3jHinewYkS9V
         HlPUbhAHBTxkg==
Received: from [192.168.124.139] (office.acenet.hu [109.74.48.97])
        by zimbra.acetelecom.hu (Postfix) with ESMTPSA id 56B77320817
        for <target-devel@vger.kernel.org>; Tue,  4 Oct 2022 13:19:09 +0200 (CEST)
Message-ID: <130a94ea-d0e6-ad5d-d8d6-d9c026b05802@acetelecom.hu>
Date:   Tue, 4 Oct 2022 13:19:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
To:     target-devel@vger.kernel.org
Content-Language: en-US
From:   =?UTF-8?Q?Op=c3=a1nszki_G=c3=a1bor?= <gabor.opanszki@acetelecom.hu>
Subject: [Config issue]FCoE target
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hi Members,

in last days i built fcoe fabric based storage on our lab.

In case of heavy load, the initiator lost connection with target. Could 
you please help anybody?

Is it bug or config issue?

Thanks,

Details below:

target: intel x520-DA2

fcoetest:~# fcoeadm -i
     Description:      82599ES 10-Gigabit SFI/SFP+ Network Connection
     Revision:         01
     Manufacturer:     Intel Corporation
     Serial Number:    90E2BAD9D4B8

     Driver:           ixgbe Unknown
     Number of Ports:  1

         Symbolic Name:     fcoe v0.1 over ens1f1
         OS Device Name:    host6
         Node Name:         0x100090e2bad9d4bb
         Port Name:         0x200090e2bad9d4bb
         Fabric Name:        0x20148c604f591ac1
         Speed:             10 Gbit
         Supported Speed:   10 Gbit
         MaxFrameSize:      2112 bytes
         FC-ID (Port ID):   0x880161
         State:             Online
     Description:      82599ES 10-Gigabit SFI/SFP+ Network Connection
     Revision:         01
     Manufacturer:     Intel Corporation
     Serial Number:    90E2BAD9D4B8

     Driver:           ixgbe Unknown
     Number of Ports:  1

         Symbolic Name:     fcoe v0.1 over ens1f0
         OS Device Name:    host7
         Node Name:         0x100090e2bad9d4ba
         Port Name:         0x200090e2bad9d4ba
         Fabric Name:        0x200a8c604f591a41
         Speed:             10 Gbit
         Supported Speed:   10 Gbit
         MaxFrameSize:      2112 bytes
         FC-ID (Port ID):   0x580141
         State:             Online

initiator: Cisco ucs b200 vic1340

root@UCS-Chassis3-Server7:~# rescan-scsi-bus.sh -a -r
Syncing file systems
Scanning SCSI subsystem for new devices and remove devices that have 
disappeared
Scanning host 0 for  SCSI target IDs 0
1
2
3
4
5
6
7, all LUNs
Scanning host 1 for  all SCSI target IDs, all LUNs
  Scanning for device 1 0 0 0 ...
OLD: Host: scsi1 Channel: 00 Id: 00 Lun: 00
       Vendor: LIO-ORG  Model: fcoe-hdd         Rev: 4.0
       Type:   Direct-Access                    ANSI SCSI revision: 05
  Scanning for device 1 0 0 1 ...
OLD: Host: scsi1 Channel: 00 Id: 00 Lun: 01
       Vendor: LIO-ORG  Model: ssd_raid0        Rev: 4.0
       Type:   Direct-Access                    ANSI SCSI revision: 05
Scanning host 2 for  SCSI target IDs 0

[Tue Oct  4 12:48:44 2022] scsi 1:0:0:0: Direct-Access     LIO-ORG  
fcoe-hdd         4.0  PQ: 0 ANSI: 5
[Tue Oct  4 12:48:44 2022] sd 1:0:0:0: Attached scsi generic sg1 type 0
[Tue Oct  4 12:48:44 2022] scsi 1:0:0:1: Direct-Access LIO-ORG  
ssd_raid0        4.0  PQ: 0 ANSI: 5
[Tue Oct  4 12:48:44 2022] sd 1:0:0:0: [sdb] 3906918832 512-byte logical 
blocks: (2.00 TB/1.82 TiB)
[Tue Oct  4 12:48:44 2022] sd 1:0:0:0: [sdb] Write Protect is off
[Tue Oct  4 12:48:44 2022] sd 1:0:0:0: [sdb] Mode Sense: 43 00 00 08
[Tue Oct  4 12:48:44 2022] sd 1:0:0:0: [sdb] Write cache: disabled, read 
cache: enabled, doesn't support DPO or FUA
[Tue Oct  4 12:48:44 2022] sd 1:0:0:0: [sdb] Optimal transfer size 
1048576 bytes
[Tue Oct  4 12:48:44 2022] scsi 1:0:0:1: Attached scsi generic sg2 type 0
[Tue Oct  4 12:48:44 2022] sd 1:0:0:1: Warning! Received an indication 
that the LUN assignments on this target have changed. The Linux SCSI 
layer does not automatical
[Tue Oct  4 12:48:44 2022] sd 1:0:0:1: [sdc] 2344115120 512-byte logical 
blocks: (1.20 TB/1.09 TiB)
[Tue Oct  4 12:48:44 2022] sd 1:0:0:1: [sdc] Write Protect is off
[Tue Oct  4 12:48:44 2022] sd 1:0:0:1: [sdc] Mode Sense: 43 00 00 08
[Tue Oct  4 12:48:44 2022] sd 1:0:0:1: [sdc] Write cache: disabled, read 
cache: enabled, doesn't support DPO or FUA
[Tue Oct  4 12:48:44 2022] sd 1:0:0:1: [sdc] Optimal transfer size 
1048576 bytes
[Tue Oct  4 12:48:44 2022]  sdc: sdc1
[Tue Oct  4 12:48:44 2022]  sdb: sdb1
[Tue Oct  4 12:48:44 2022] sd 1:0:0:1: [sdc] Attached SCSI disk
[Tue Oct  4 12:48:44 2022] sd 1:0:0:0: [sdb] Attached SCSI disk

Initiator:

[Tue Oct  4 01:00:18 2022] perf: interrupt took too long (2506 > 2500), 
lowering kernel.perf_event_max_sample_rate to 79750
[Tue Oct  4 08:50:10 2022] perf: interrupt took too long (3134 > 3132), 
lowering kernel.perf_event_max_sample_rate to 63750
[Tue Oct  4 10:10:32 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:10:32 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:10:53 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:10:54 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:10:56 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:10:59 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:11:01 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:11:12 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:11:13 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:11:13 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:11:14 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:11:14 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:11:18 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:11:18 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:11:24 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:11:24 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:11:46 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:11:46 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:11:46 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:11:46 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:11:59 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:03 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:04 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:04 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:10 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:13 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:45 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:47 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:49 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:49 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:49 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:50 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:50 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:51 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:51 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:51 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:54 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:55 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:55 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:55 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:56 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:56 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:57 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:57 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:57 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:57 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:58 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:58 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:58 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:58 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:58 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:12:58 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:13:00 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:13:08 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:13:16 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:13:17 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:13:22 2022] scsi host1: hdr status = FCPIO_DATA_CNT_MISMATCH
[Tue Oct  4 10:13:58 2022] scsi host1: rport_exch_reset IO not yet 
issued 00000000a5b91543 tag 0x3 flags 274 state 3
[Tue Oct  4 10:13:58 2022] scsi host1: rport_exch_reset IO not yet 
issued 00000000f9b7b332 tag 0xf flags 274 state 3
[Tue Oct  4 10:13:58 2022] scsi host1: rport_exch_reset IO not yet 
issued 000000005a62879e tag 0x1b flags 274 state 3
[Tue Oct  4 10:13:58 2022] scsi host1: rport_exch_reset IO not yet 
issued 0000000010a51b5d tag 0x3b flags 274 state 3
[Tue Oct  4 10:13:58 2022] scsi host1: rport_exch_reset IO not yet 
issued 00000000dd1c1a04 tag 0x4e flags 274 state 3
[Tue Oct  4 10:13:58 2022] scsi host1: rport_exch_reset IO not yet 
issued 000000001945bd50 tag 0x56 flags 274 state 3
[Tue Oct  4 10:13:58 2022] scsi host1: rport_exch_reset IO not yet 
issued 000000007d969e1c tag 0x59 flags 274 state 3
[Tue Oct  4 10:13:58 2022] scsi host1: rport_exch_reset IO not yet 
issued 0000000011a5ef30 tag 0x63 flags 274 state 3
[Tue Oct  4 10:13:58 2022] scsi host1: rport_exch_reset IO not yet 
issued 000000007d98c2db tag 0x9f flags 274 state 3
[Tue Oct  4 10:13:58 2022] scsi host1: rport_exch_reset IO not yet 
issued 00000000f195d2b2 tag 0xa9 flags 274 state 3
[Tue Oct  4 10:13:58 2022] scsi host1: rport_exch_reset IO not yet 
issued 00000000bec7eb64 tag 0xaa flags 274 state 3
[Tue Oct  4 10:13:58 2022] scsi host1: rport_exch_reset IO not yet 
issued 00000000a17581a5 tag 0xcd flags 274 state 3
[Tue Oct  4 10:13:58 2022] scsi host1: rport_exch_reset IO not yet 
issued 000000002c733234 tag 0xd9 flags 274 state 3
[Tue Oct  4 10:14:01 2022] host1: Assigned Port ID 58000c
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: Device offlined - not ready after 
error recovery
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: Device offlined - not ready after 
error recovery
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: Device offlined - not ready after 
error recovery
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: Device offlined - not ready after 
error recovery
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: Device offlined - not ready after 
error recovery
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: Device offlined - not ready after 
error recovery
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: Device offlined - not ready after 
error recovery
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: Device offlined - not ready after 
error recovery
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: Device offlined - not ready after 
error recovery
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: Device offlined - not ready after 
error recovery
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: Device offlined - not ready after 
error recovery
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: Device offlined - not ready after 
error recovery
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: Device offlined - not ready after 
error recovery
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: Device offlined - not ready after 
error recovery
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: [sdb] tag#78 FAILED Result: 
hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=74s
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: [sdb] tag#78 CDB: Write(10) 2a 00 
01 58 5b e3 00 02 00 00
[Tue Oct  4 10:14:23 2022] blk_update_request: I/O error, dev sdb, 
sector 22567907 op 0x1:(WRITE) flags 0x8800 phys_seg 63 prio class 0
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: [sdb] tag#86 FAILED Result: 
hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=74s
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: [sdb] tag#86 CDB: Read(10) 28 00 
01 29 91 47 00 02 00 00
[Tue Oct  4 10:14:23 2022] blk_update_request: I/O error, dev sdb, 
sector 19501383 op 0x0:(READ) flags 0x0 phys_seg 4 prio class 0
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: [sdb] tag#89 FAILED Result: 
hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=74s
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: [sdb] tag#89 CDB: Read(10) 28 00 
01 29 95 47 00 02 00 00
[Tue Oct  4 10:14:23 2022] blk_update_request: I/O error, dev sdb, 
sector 19502407 op 0x0:(READ) flags 0x0 phys_seg 4 prio class 0
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: [sdb] tag#15 FAILED Result: 
hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=83s
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: [sdb] tag#15 CDB: Read(10) 28 00 
01 66 74 60 00 02 00 00
[Tue Oct  4 10:14:23 2022] blk_update_request: I/O error, dev sdb, 
sector 23491680 op 0x0:(READ) flags 0x0 phys_seg 62 prio class 0
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: [sdb] tag#27 FAILED Result: 
hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=84s
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: [sdb] tag#27 CDB: Read(10) 28 00 
01 3a c9 b6 00 02 00 00
[Tue Oct  4 10:14:23 2022] blk_update_request: I/O error, dev sdb, 
sector 20629942 op 0x0:(READ) flags 0x0 phys_seg 4 prio class 0
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: [sdb] tag#3 FAILED Result: 
hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=85s
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: [sdb] tag#3 CDB: Read(10) 28 00 
01 31 f8 7a 00 02 00 00
[Tue Oct  4 10:14:23 2022] blk_update_request: I/O error, dev sdb, 
sector 20052090 op 0x0:(READ) flags 0x0 phys_seg 62 prio class 0
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: [sdb] tag#59 FAILED Result: 
hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=85s
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: [sdb] tag#59 CDB: Read(10) 28 00 
01 53 4a cf 00 02 00 00
[Tue Oct  4 10:14:23 2022] blk_update_request: I/O error, dev sdb, 
sector 22235855 op 0x0:(READ) flags 0x0 phys_seg 4 prio class 0
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: [sdb] tag#159 FAILED Result: 
hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=86s
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: [sdb] tag#159 CDB: Read(10) 28 00 
01 66 4c 03 00 02 00 00
[Tue Oct  4 10:14:23 2022] blk_update_request: I/O error, dev sdb, 
sector 23481347 op 0x0:(READ) flags 0x0 phys_seg 62 prio class 0
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: [sdb] tag#205 FAILED Result: 
hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=86s
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: [sdb] tag#205 CDB: Read(10) 28 00 
01 2b d5 7c 00 02 00 00
[Tue Oct  4 10:14:23 2022] blk_update_request: I/O error, dev sdb, 
sector 19649916 op 0x0:(READ) flags 0x0 phys_seg 4 prio class 0
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: [sdb] tag#169 FAILED Result: 
hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=88s
[Tue Oct  4 10:14:23 2022] sd 1:0:0:0: [sdb] tag#169 CDB: Read(10) 28 00 
01 34 dd 73 00 02 00 00
[Tue Oct  4 10:14:23 2022] blk_update_request: I/O error, dev sdb, 
sector 20241779 op 0x0:(READ) flags 0x0 phys_seg 62 prio class 0
[Tue Oct  4 10:14:30 2022]  rport-1:0-2: blocked FC remote port time 
out: removing target and saving binding
[Tue Oct  4 10:14:30 2022] sd 1:0:0:0: rejecting I/O to offline device
[Tue Oct  4 10:14:30 2022] print_req_error: 4 callbacks suppressed
[Tue Oct  4 10:14:30 2022] blk_update_request: I/O error, dev sdb, 
sector 21227156 op 0x0:(READ) flags 0x0 phys_seg 4 prio class 0
[Tue Oct  4 10:14:30 2022] blk_update_request: I/O error, dev sdb, 
sector 23020044 op 0x0:(READ) flags 0x0 phys_seg 4 prio class 0
[Tue Oct  4 10:14:30 2022] blk_update_request: I/O error, dev sdb, 
sector 19978792 op 0x0:(READ) flags 0x0 phys_seg 8 prio class 0
[Tue Oct  4 10:14:30 2022] blk_update_request: I/O error, dev sdb, 
sector 24057030 op 0x0:(READ) flags 0x0 phys_seg 12 prio class 0
[Tue Oct  4 10:14:30 2022] blk_update_request: I/O error, dev sdb, 
sector 19988992 op 0x0:(READ) flags 0x0 phys_seg 4 prio class 0
[Tue Oct  4 10:14:30 2022] blk_update_request: I/O error, dev sdb, 
sector 20164856 op 0x0:(READ) flags 0x0 phys_seg 4 prio class 0
[Tue Oct  4 10:14:30 2022] blk_update_request: I/O error, dev sdb, 
sector 21045310 op 0x0:(READ) flags 0x0 phys_seg 8 prio class 0
[Tue Oct  4 10:14:30 2022] blk_update_request: I/O error, dev sdb, 
sector 21190164 op 0x0:(READ) flags 0x0 phys_seg 12 prio class 0
[Tue Oct  4 10:14:30 2022] blk_update_request: I/O error, dev sdb, 
sector 21409176 op 0x0:(READ) flags 0x0 phys_seg 4 prio class 0
[Tue Oct  4 10:14:30 2022] blk_update_request: I/O error, dev sdb, 
sector 21478995 op 0x0:(READ) flags 0x0 phys_seg 4 prio class 0
[Tue Oct  4 10:14:30 2022] XFS (sdb1): log I/O error -5
[Tue Oct  4 10:14:30 2022] XFS (sdb1): xfs_do_force_shutdown(0x2) called 
from line 1211 of file fs/xfs/xfs_log.c. Return address = 0000000042d2267d
[Tue Oct  4 10:14:30 2022] XFS (sdb1): Log I/O Error Detected. Shutting 
down filesystem
[Tue Oct  4 10:14:30 2022] XFS (sdb1): Please unmount the filesystem and 
rectify the problem(s)

Target:

[Tue Oct  4 10:17:34 2022] INFO: task kworker/12:1:279 blocked for more 
than 120 seconds.
[Tue Oct  4 10:17:34 2022]       Tainted: G          I 5.10.0-17-amd64 
#1 Debian 5.10.136-1
[Tue Oct  4 10:17:34 2022] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Tue Oct  4 10:17:34 2022] task:kworker/12:1    state:D stack:    0 
pid:  279 ppid:     2 flags:0x00004000
[Tue Oct  4 10:17:34 2022] Workqueue: events fcoe_receive_work [fcoe]
[Tue Oct  4 10:17:34 2022] Call Trace:
[Tue Oct  4 10:17:34 2022]  __schedule+0x282/0x880
[Tue Oct  4 10:17:34 2022]  schedule+0x46/0xb0
[Tue Oct  4 10:17:34 2022]  schedule_preempt_disabled+0xa/0x10
[Tue Oct  4 10:17:34 2022]  __mutex_lock.constprop.0+0x133/0x470
[Tue Oct  4 10:17:34 2022]  fc_rport_recv_req+0x313/0x1110 [libfc]
[Tue Oct  4 10:17:34 2022]  fc_lport_recv_els_req+0x48b/0x580 [libfc]
[Tue Oct  4 10:17:34 2022]  ? sched_clock_cpu+0xc/0xb0
[Tue Oct  4 10:17:34 2022]  fc_lport_recv+0x5e/0xc0 [libfc]
[Tue Oct  4 10:17:34 2022]  fcoe_receive_work+0x204/0x3b0 [fcoe]
[Tue Oct  4 10:17:34 2022]  process_one_work+0x1b6/0x350
[Tue Oct  4 10:17:34 2022]  worker_thread+0x53/0x3e0
[Tue Oct  4 10:17:34 2022]  ? process_one_work+0x350/0x350
[Tue Oct  4 10:17:34 2022]  kthread+0x11b/0x140
[Tue Oct  4 10:17:34 2022]  ? __kthread_bind_mask+0x60/0x60
[Tue Oct  4 10:17:34 2022]  ret_from_fork+0x22/0x30
[Tue Oct  4 10:17:34 2022] INFO: task kworker/18:1:282 blocked for more 
than 120 seconds.
[Tue Oct  4 10:17:34 2022]       Tainted: G          I 5.10.0-17-amd64 
#1 Debian 5.10.136-1
[Tue Oct  4 10:17:34 2022] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Tue Oct  4 10:17:34 2022] task:kworker/18:1    state:D stack:    0 
pid:  282 ppid:     2 flags:0x00004000
[Tue Oct  4 10:17:34 2022] Workqueue: events fcoe_receive_work [fcoe]
[Tue Oct  4 10:17:34 2022] Call Trace:
[Tue Oct  4 10:17:34 2022]  __schedule+0x282/0x880
[Tue Oct  4 10:17:34 2022]  schedule+0x46/0xb0
[Tue Oct  4 10:17:34 2022]  schedule_preempt_disabled+0xa/0x10
[Tue Oct  4 10:17:34 2022]  __mutex_lock.constprop.0+0x133/0x470
[Tue Oct  4 10:17:34 2022]  fc_lport_recv_els_req+0x38/0x580 [libfc]
[Tue Oct  4 10:17:34 2022]  ? dequeue_entity+0xc6/0x450
[Tue Oct  4 10:17:34 2022]  fc_lport_recv+0x5e/0xc0 [libfc]
[Tue Oct  4 10:17:34 2022]  fcoe_receive_work+0x204/0x3b0 [fcoe]
[Tue Oct  4 10:17:34 2022]  process_one_work+0x1b6/0x350
[Tue Oct  4 10:17:34 2022]  worker_thread+0x53/0x3e0
[Tue Oct  4 10:17:34 2022]  ? process_one_work+0x350/0x350
[Tue Oct  4 10:17:34 2022]  kthread+0x11b/0x140
[Tue Oct  4 10:17:34 2022]  ? __kthread_bind_mask+0x60/0x60
[Tue Oct  4 10:17:34 2022]  ret_from_fork+0x22/0x30
[Tue Oct  4 10:17:34 2022] INFO: task kworker/14:1:284 blocked for more 
than 120 seconds.
[Tue Oct  4 10:17:34 2022]       Tainted: G          I 5.10.0-17-amd64 
#1 Debian 5.10.136-1
[Tue Oct  4 10:17:34 2022] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Tue Oct  4 10:17:34 2022] task:kworker/14:1    state:D stack:    0 
pid:  284 ppid:     2 flags:0x00004000
[Tue Oct  4 10:17:34 2022] Workqueue: events fcoe_receive_work [fcoe]
[Tue Oct  4 10:17:34 2022] Call Trace:
[Tue Oct  4 10:17:34 2022]  __schedule+0x282/0x880
[Tue Oct  4 10:17:34 2022]  schedule+0x46/0xb0
[Tue Oct  4 10:17:34 2022]  schedule_preempt_disabled+0xa/0x10
[Tue Oct  4 10:17:34 2022]  __mutex_lock.constprop.0+0x133/0x470
[Tue Oct  4 10:17:34 2022]  fc_lport_recv_els_req+0x38/0x580 [libfc]
[Tue Oct  4 10:17:34 2022]  ? dequeue_entity+0xc6/0x450
[Tue Oct  4 10:17:34 2022]  fc_lport_recv+0x5e/0xc0 [libfc]
[Tue Oct  4 10:17:34 2022]  fcoe_receive_work+0x204/0x3b0 [fcoe]
[Tue Oct  4 10:17:34 2022]  process_one_work+0x1b6/0x350
[Tue Oct  4 10:17:34 2022]  worker_thread+0x53/0x3e0
[Tue Oct  4 10:17:34 2022]  ? process_one_work+0x350/0x350
[Tue Oct  4 10:17:34 2022]  kthread+0x11b/0x140
[Tue Oct  4 10:17:34 2022]  ? __kthread_bind_mask+0x60/0x60
[Tue Oct  4 10:17:34 2022]  ret_from_fork+0x22/0x30
[Tue Oct  4 10:17:34 2022] INFO: task kworker/10:5:322 blocked for more 
than 120 seconds.
[Tue Oct  4 10:17:34 2022]       Tainted: G          I 5.10.0-17-amd64 
#1 Debian 5.10.136-1
[Tue Oct  4 10:17:34 2022] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Tue Oct  4 10:17:34 2022] task:kworker/10:5    state:D stack:    0 
pid:  322 ppid:     2 flags:0x00004000
[Tue Oct  4 10:17:34 2022] Workqueue: events target_tmr_work 
[target_core_mod]
[Tue Oct  4 10:17:34 2022] Call Trace:
[Tue Oct  4 10:17:34 2022]  __schedule+0x282/0x880
[Tue Oct  4 10:17:34 2022]  ? usleep_range+0x90/0x90
[Tue Oct  4 10:17:34 2022]  schedule+0x46/0xb0
[Tue Oct  4 10:17:34 2022]  schedule_timeout+0x107/0x150
[Tue Oct  4 10:17:34 2022]  ? target_show_cmd+0x229/0x420 [target_core_mod]
[Tue Oct  4 10:17:34 2022]  ? __prepare_to_swait+0x4f/0x70
[Tue Oct  4 10:17:34 2022]  __wait_for_common+0xae/0x160
[Tue Oct  4 10:17:34 2022]  target_put_cmd_and_wait+0x6d/0xb0 
[target_core_mod]
[Tue Oct  4 10:17:34 2022]  core_tmr_lun_reset+0x4f6/0x670 [target_core_mod]
[Tue Oct  4 10:17:34 2022]  target_tmr_work+0xb1/0xf0 [target_core_mod]
[Tue Oct  4 10:17:34 2022]  process_one_work+0x1b6/0x350
[Tue Oct  4 10:17:34 2022]  worker_thread+0x53/0x3e0
[Tue Oct  4 10:17:34 2022]  ? process_one_work+0x350/0x350
[Tue Oct  4 10:17:34 2022]  kthread+0x11b/0x140
[Tue Oct  4 10:17:34 2022]  ? __kthread_bind_mask+0x60/0x60
[Tue Oct  4 10:17:34 2022]  ret_from_fork+0x22/0x30
[Tue Oct  4 10:17:34 2022] INFO: task kworker/19:1:1850 blocked for more 
than 120 seconds.
[Tue Oct  4 10:17:34 2022]       Tainted: G          I 5.10.0-17-amd64 
#1 Debian 5.10.136-1
[Tue Oct  4 10:17:34 2022] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Tue Oct  4 10:17:34 2022] task:kworker/19:1    state:D stack:    0 pid: 
1850 ppid:     2 flags:0x00004000
[Tue Oct  4 10:17:34 2022] Workqueue: events fcoe_ctlr_timer_work [libfcoe]
[Tue Oct  4 10:17:34 2022] Call Trace:
[Tue Oct  4 10:17:34 2022]  __schedule+0x282/0x880
[Tue Oct  4 10:17:34 2022]  ? mutex_lock+0xe/0x30
[Tue Oct  4 10:17:34 2022]  schedule+0x46/0xb0
[Tue Oct  4 10:17:34 2022]  schedule_preempt_disabled+0xa/0x10
[Tue Oct  4 10:17:34 2022]  __mutex_lock.constprop.0+0x133/0x470
[Tue Oct  4 10:17:34 2022]  fcoe_ctlr_timer_work+0x2ad/0xb60 [libfcoe]
[Tue Oct  4 10:17:34 2022]  process_one_work+0x1b6/0x350
[Tue Oct  4 10:17:34 2022]  worker_thread+0x53/0x3e0
[Tue Oct  4 10:17:34 2022]  ? process_one_work+0x350/0x350
[Tue Oct  4 10:17:34 2022]  kthread+0x11b/0x140
[Tue Oct  4 10:17:34 2022]  ? __kthread_bind_mask+0x60/0x60
[Tue Oct  4 10:17:34 2022]  ret_from_fork+0x22/0x30
[Tue Oct  4 10:17:34 2022] INFO: task kworker/19:2:2452 blocked for more 
than 120 seconds.
[Tue Oct  4 10:17:34 2022]       Tainted: G          I 5.10.0-17-amd64 
#1 Debian 5.10.136-1
[Tue Oct  4 10:17:34 2022] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Tue Oct  4 10:17:34 2022] task:kworker/19:2    state:D stack:    0 pid: 
2452 ppid:     2 flags:0x00004000
[Tue Oct  4 10:17:34 2022] Workqueue: events fcoe_ctlr_recv_work [libfcoe]
[Tue Oct  4 10:17:34 2022] Call Trace:
[Tue Oct  4 10:17:34 2022]  __schedule+0x282/0x880
[Tue Oct  4 10:17:34 2022]  schedule+0x46/0xb0
[Tue Oct  4 10:17:34 2022]  schedule_preempt_disabled+0xa/0x10
[Tue Oct  4 10:17:34 2022]  __mutex_lock.constprop.0+0x133/0x470
[Tue Oct  4 10:17:34 2022]  fc_lport_reset+0x26/0x40 [libfc]
[Tue Oct  4 10:17:34 2022]  fcoe_ctlr_recv_work+0x932/0xcd0 [libfcoe]
[Tue Oct  4 10:17:34 2022]  process_one_work+0x1b6/0x350
[Tue Oct  4 10:17:34 2022]  worker_thread+0x53/0x3e0
[Tue Oct  4 10:17:34 2022]  ? process_one_work+0x350/0x350
[Tue Oct  4 10:17:34 2022]  kthread+0x11b/0x140
[Tue Oct  4 10:17:34 2022]  ? __kthread_bind_mask+0x60/0x60
[Tue Oct  4 10:17:34 2022]  ret_from_fork+0x22/0x30
[Tue Oct  4 10:17:34 2022] INFO: task kworker/16:1:2514 blocked for more 
than 120 seconds.
[Tue Oct  4 10:17:34 2022]       Tainted: G          I 5.10.0-17-amd64 
#1 Debian 5.10.136-1
[Tue Oct  4 10:17:34 2022] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Tue Oct  4 10:17:34 2022] task:kworker/16:1    state:D stack:    0 pid: 
2514 ppid:     2 flags:0x00004000
[Tue Oct  4 10:17:34 2022] Workqueue: events fcoe_receive_work [fcoe]
[Tue Oct  4 10:17:34 2022] Call Trace:
[Tue Oct  4 10:17:34 2022]  __schedule+0x282/0x880
[Tue Oct  4 10:17:34 2022]  schedule+0x46/0xb0
[Tue Oct  4 10:17:34 2022]  schedule_preempt_disabled+0xa/0x10
[Tue Oct  4 10:17:34 2022]  __mutex_lock.constprop.0+0x133/0x470
[Tue Oct  4 10:17:34 2022]  fc_lport_recv_els_req+0x38/0x580 [libfc]
[Tue Oct  4 10:17:34 2022]  ? sched_clock_cpu+0xc/0xb0
[Tue Oct  4 10:17:34 2022]  fc_lport_recv+0x5e/0xc0 [libfc]
[Tue Oct  4 10:17:34 2022]  fcoe_receive_work+0x204/0x3b0 [fcoe]
[Tue Oct  4 10:17:34 2022]  process_one_work+0x1b6/0x350
[Tue Oct  4 10:17:34 2022]  worker_thread+0x53/0x3e0
[Tue Oct  4 10:17:34 2022]  ? process_one_work+0x350/0x350
[Tue Oct  4 10:17:34 2022]  kthread+0x11b/0x140
[Tue Oct  4 10:17:34 2022]  ? __kthread_bind_mask+0x60/0x60
[Tue Oct  4 10:17:34 2022]  ret_from_fork+0x22/0x30
[Tue Oct  4 10:17:34 2022] INFO: task kworker/19:0:2553 blocked for more 
than 120 seconds.
[Tue Oct  4 10:17:34 2022]       Tainted: G          I 5.10.0-17-amd64 
#1 Debian 5.10.136-1
[Tue Oct  4 10:17:34 2022] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Tue Oct  4 10:17:34 2022] task:kworker/19:0    state:D stack:    0 pid: 
2553 ppid:     2 flags:0x00004000
[Tue Oct  4 10:17:34 2022] Workqueue: events fcoe_receive_work [fcoe]
[Tue Oct  4 10:17:34 2022] Call Trace:
[Tue Oct  4 10:17:34 2022]  __schedule+0x282/0x880
[Tue Oct  4 10:17:34 2022]  schedule+0x46/0xb0
[Tue Oct  4 10:17:34 2022]  schedule_preempt_disabled+0xa/0x10
[Tue Oct  4 10:17:34 2022]  __mutex_lock.constprop.0+0x133/0x470
[Tue Oct  4 10:17:34 2022]  fc_lport_recv_els_req+0x38/0x580 [libfc]
[Tue Oct  4 10:17:34 2022]  ? sched_clock_cpu+0xc/0xb0
[Tue Oct  4 10:17:34 2022]  fc_lport_recv+0x5e/0xc0 [libfc]
[Tue Oct  4 10:17:34 2022]  fcoe_receive_work+0x204/0x3b0 [fcoe]
[Tue Oct  4 10:17:34 2022]  process_one_work+0x1b6/0x350
[Tue Oct  4 10:17:34 2022]  worker_thread+0x53/0x3e0
[Tue Oct  4 10:17:34 2022]  ? process_one_work+0x350/0x350
[Tue Oct  4 10:17:34 2022]  kthread+0x11b/0x140
[Tue Oct  4 10:17:34 2022]  ? __kthread_bind_mask+0x60/0x60
[Tue Oct  4 10:17:34 2022]  ret_from_fork+0x22/0x30
[Tue Oct  4 10:19:35 2022] INFO: task kworker/12:1:279 blocked for more 
than 241 seconds.
[Tue Oct  4 10:19:35 2022]       Tainted: G          I 5.10.0-17-amd64 
#1 Debian 5.10.136-1
[Tue Oct  4 10:19:35 2022] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Tue Oct  4 10:19:35 2022] task:kworker/12:1    state:D stack:    0 
pid:  279 ppid:     2 flags:0x00004000
[Tue Oct  4 10:19:35 2022] Workqueue: events fcoe_receive_work [fcoe]
[Tue Oct  4 10:19:35 2022] Call Trace:
[Tue Oct  4 10:19:35 2022]  __schedule+0x282/0x880
[Tue Oct  4 10:19:35 2022]  schedule+0x46/0xb0
[Tue Oct  4 10:19:35 2022]  schedule_preempt_disabled+0xa/0x10
[Tue Oct  4 10:19:35 2022]  __mutex_lock.constprop.0+0x133/0x470
[Tue Oct  4 10:19:35 2022]  fc_rport_recv_req+0x313/0x1110 [libfc]
[Tue Oct  4 10:19:35 2022]  fc_lport_recv_els_req+0x48b/0x580 [libfc]
[Tue Oct  4 10:19:35 2022]  ? sched_clock_cpu+0xc/0xb0
[Tue Oct  4 10:19:35 2022]  fc_lport_recv+0x5e/0xc0 [libfc]
[Tue Oct  4 10:19:35 2022]  fcoe_receive_work+0x204/0x3b0 [fcoe]
[Tue Oct  4 10:19:35 2022]  process_one_work+0x1b6/0x350
[Tue Oct  4 10:19:35 2022]  worker_thread+0x53/0x3e0
[Tue Oct  4 10:19:35 2022]  ? process_one_work+0x350/0x350
[Tue Oct  4 10:19:35 2022]  kthread+0x11b/0x140
[Tue Oct  4 10:19:35 2022]  ? __kthread_bind_mask+0x60/0x60
[Tue Oct  4 10:19:35 2022]  ret_from_fork+0x22/0x30
[Tue Oct  4 10:19:35 2022] INFO: task kworker/18:1:282 blocked for more 
than 241 seconds.
[Tue Oct  4 10:19:35 2022]       Tainted: G          I 5.10.0-17-amd64 
#1 Debian 5.10.136-1
[Tue Oct  4 10:19:35 2022] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Tue Oct  4 10:19:35 2022] task:kworker/18:1    state:D stack:    0 
pid:  282 ppid:     2 flags:0x00004000
[Tue Oct  4 10:19:35 2022] Workqueue: events fcoe_receive_work [fcoe]
[Tue Oct  4 10:19:35 2022] Call Trace:
[Tue Oct  4 10:19:35 2022]  __schedule+0x282/0x880
[Tue Oct  4 10:19:35 2022]  schedule+0x46/0xb0
[Tue Oct  4 10:19:35 2022]  schedule_preempt_disabled+0xa/0x10
[Tue Oct  4 10:19:35 2022]  __mutex_lock.constprop.0+0x133/0x470
[Tue Oct  4 10:19:35 2022]  fc_lport_recv_els_req+0x38/0x580 [libfc]
[Tue Oct  4 10:19:35 2022]  ? dequeue_entity+0xc6/0x450
[Tue Oct  4 10:19:35 2022]  fc_lport_recv+0x5e/0xc0 [libfc]
[Tue Oct  4 10:19:35 2022]  fcoe_receive_work+0x204/0x3b0 [fcoe]
[Tue Oct  4 10:19:35 2022]  process_one_work+0x1b6/0x350
[Tue Oct  4 10:19:35 2022]  worker_thread+0x53/0x3e0
[Tue Oct  4 10:19:35 2022]  ? process_one_work+0x350/0x350
[Tue Oct  4 10:19:35 2022]  kthread+0x11b/0x140
[Tue Oct  4 10:19:35 2022]  ? __kthread_bind_mask+0x60/0x60
[Tue Oct  4 10:19:35 2022]  ret_from_fork+0x22/0x30

Relevant log on Nexus DC switch:
2022 Oct  4 08:15:34 bp.victorhugo18.vps.nexus1 %PORT-5-IF_TRUNK_DOWN: 
%$VSAN 10%$ Interface vfc131, vsan 10 is down (waiting for flogi)  
c240-fcoe

-- 
Thanks,
Gabor Opanszki
