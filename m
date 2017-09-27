From: =?UTF-8?Q?Marc_Sch=c3=b6chlin?= <ms@256bit.org>
Date: Wed, 27 Sep 2017 13:07:28 +0000
Subject: Re: Problems to utilize iscsi volume
Message-Id: <2e2f2cec-0d1c-abf4-a218-85b0a11a7782@256bit.org>
List-Id: <target-devel.vger.kernel.org>
References: <9265b002-be5d-f049-df3d-4e7b09c7c393@256bit.org>
In-Reply-To: <9265b002-be5d-f049-df3d-4e7b09c7c393@256bit.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

Hi,

special thanks to Thunderbird :-)

Why is it not permitted to send HTML mails to the mailinglist? 1998 is back and requests to get its internet back? :-)

My message without wrapped plaintext-lines (hopefully):
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Hi,

i am using XEN server/XEN center 7.2 as and i would like to access a iscsi storage resource from this system.
My target runs on kernel 4.4.0-83-generic on Ubuntu 16.04.

My targetcli output looks like this:

# targetcli
targetcli shell version 2.1.fb43
Copyright 2011-2013 by Datera, Inc and others.
For help on commands, type 'help'.

/> cd /
/> ls
o- / ......................................................................................................................... [...]
  o- backstores .............................................................................................................. [...]
  | o- block .................................................................................................. [Storage Objects: 3]
  | | o- ba-safe-po_k11111-v9988-foobar-monitoringvh1-1  [/dev/ba/ba-safe-po/k11111-v9988-foobar-monitoringvh1-1 (1.0TiB) write-thru activated]
  | | o- ba-safe-po_k11111-v9988-foobar-ba4tt2a-foobar-barfoo1-qt-iscsi-a-0  [/dev/ba/ba-safe-po/k11111-v9988-foobar-ba4tt2a-foobar-barfoo1-qt-iscsi-a-0 (1.0GiB) write-thru activated]
  | | o- ba-safe-po_k11111-v8448-foobarmsctest-0 ........ [/dev/ba/ba-safe-po/k11111-v8448-foobarmsctest-0 (1.0GiB) write-thru activated]
  | o- fileio ................................................................................................. [Storage Objects: 0]
  | o- pscsi .................................................................................................. [Storage Objects: 0]
  | o- ramdisk ................................................................................................ [Storage Objects: 0]
  o- iscsi ............................................................................................................ [Targets: 1]
  | o- iqn.2017-09.barf.net:910f1868 ................................................................................ [TPGs: 1]
  |   o- tpg1 ............................................................................................... [no-gen-acls, no-auth]
  |     o- acls .......................................................................................................... [ACLs: 3]
  |     | o- iqn.1993-08.org.debian:01:12d0b0ef74a8 ............................................................... [Mapped LUNs: 1]
  |     | | o- mapped_lun255 ....................... [lun1 block/ba-safe-po_k11111-v9988-foobar-ba4tt2a-foobar-barfoo1-qt-iscsi-a-0 (rw)]
  |     | o- iqn.2012-04.com.example:910f1868 ..................................................................... [Mapped LUNs: 1]
  |     | | o- mapped_lun1 ........................................... [lun0 block/ba-safe-po_k11111-v9988-foobar-monitoringvh1-1 (rw)]
  |     | o- iqn.2017-09.barf.net:910f1868 .................................................................. [Mapped LUNs: 1]
  |     |   o- mapped_lun254 ................................................ [lun2 block/ba-safe-po_k11111-v8448-foobarmsctest-0 (rw)]
  |     o- luns .......................................................................................................... [LUNs: 3]
  |     | o- lun0 ....... [block/ba-safe-po_k11111-v9988-foobar-monitoringvh1-1 (/dev/ba/ba-safe-po/k11111-v9988-foobar-monitoringvh1-1)]
  |     | o- lun1  [block/ba-safe-po_k11111-v9988-foobar-ba4tt2a-foobar-barfoo1-qt-iscsi-a-0 (/dev/ba/ba-safe-po/k11111-v9988-foobar-ba4tt2a-foobar-barfoo1-qt-iscsi-a-0)]
  |     | o- lun2 ..................... [block/ba-safe-po_k11111-v8448-foobarmsctest-0 (/dev/ba/ba-safe-po/k11111-v8448-foobarmsctest-0)]
  |     o- portals .................................................................................................... [Portals: 1]
  |       o- 0.0.0.0:3260 ..................................................................................................... [OK]
  o- loopback ......................................................................................................... [Targets: 0]
  o- vhost ............................................................................................................ [Targets: 0]

My connection procedure on xenserver is failing like this:

 1. I add a new storage ressource
 2. I enter the ip address of the target
 3. I execute "Scan Target Host", this is confirmed by a green hook
 4. I select the discovered IQN "iqn.2017-09.barf.net:910f1868"
    (i see two IQNs: 1. "*: 10.1.1.1:3260" and my "iqn.2017-09.barf.net:910f1868")
 5. I check the option "Use CHAP" and enter "CHAP Username" and "CHAP Password" but in was not able to finalize the creation from this step

Alternatively to perform the following procedure:

As you can see, this works pretty good on a plain Ubuntu 16.04 system.

# iscsiadm -m discovery -t sendtargets -p 10.1.1.1:3260
10.1.1.1:3260,1 iqn.2017-09.barf.net:910f1868
# iscsiadm -m discovery -t st -p '10.1.1.1:3260' --op=new --name node.session.auth.authmethod --value=CHAP --name node.session.auth.username --value='H11111111' --name node.session.auth.password --value='48X1111111111FAKE'
10.1.1.1:3260,1 iqn.2017-09.barf.net:910f1868
# iscsiadm --mode node  --targetname 'iqn.2017-09.barf.net:910f1868'  -p '10.1.1.1:3260' --login
Logging in to [iface: default, target: iqn.2017-09.barf.net:910f1868, portal: 10.1.1.1,3260] (multiple)
Login to [iface: default, target: iqn.2017-09.barf.net:910f1868, portal: 10.1.1.1,3260] successful.


The same procedure fails on my xen 7.2 host:

#  iscsiadm -m discovery -t sendtargets -p 10.1.1.1:3260
10.1.1.1:3260,1 iqn.2017-09.barf.net:910f1868
# iscsiadm -m discovery -t st -p '10.1.1.1:3260' --op=new --name node.session.auth.authmethod --value=CHAP --name node.session.auth.username --value='H11111111' --name node.session.auth.password --value='48X1111111111FAKE'
10.1.1.1:3260,1 iqn.2017-09.barf.net:910f1868
# iscsiadm --mode node  --targetname 'iqn.2017-09.barf.net:910f1868'  -p '10.1.1.1:3260' --login
Logging in to [iface: default, target: iqn.2017-09.barf.net:910f1868, portal: 10.1.1.1,3260] (multiple)
iscsiadm: Could not login to [iface: default, target: iqn.2017-09.barf.net:910f1868, portal: 10.1.1.1,3260].
iscsiadm: initiator reported error (24 - iSCSI login failed due to authorization failure)
iscsiadm: Could not log into all portals

On targetside i can see the following messages in th dmesg/journal:

Sep 25 14:57:26 foobar-barfoo1-qt-iscsi-a2 kernel: rx_data returned 0, expecting 48.
Sep 25 14:57:26 foobar-barfoo1-qt-iscsi-a2 kernel: iSCSI Login negotiation failed.
Sep 25 14:57:26 foobar-barfoo1-qt-iscsi-a2 kernel: CHAP user or password not set for Initiator ACL
Sep 25 14:57:26 foobar-barfoo1-qt-iscsi-a2 kernel: Security negotiation failed.
Sep 25 14:57:26 foobar-barfoo1-qt-iscsi-a2 kernel: iSCSI Login negotiation failed.

Do you have any hints whats going wrong here or how to find out more details?

I also performed a tcp dump for the failing procedure, here you can see a the relevant details of the login procedure:
(i suppose procedure step 1-3 above maps to step 1-2 beyond)

*** Step 1: Login Command*

iSCSI (Login Command)
    Opcode: Login Command (0x03)
    1... .... = T: Transit to next login stage
    .0.. .... = C: Text is complete
    .... 00.. = CSG: Security negotiation (0x0)
    .... ..01 = NSG: Operational negotiation (0x1)
    VersionMax: 0x00
    VersionMin: 0x00
    TotalAHSLength: 0x00
    DataSegmentLength: 119 (0x00000077)
    ISID: 00023d000000
        00.. .... = ISID_t: IEEE OUI (0x0)
        ..00 0000 = ISID_a: 0x00
        ISID_b: 0x023d
        ISID_c: 0x00
        ISID_d: 0x0000
    TSIH: 0x0000
    InitiatorTaskTag: 0x00000000
    CID: 0x0000
    CmdSN: 0x00000001
    ExpStatSN: 0x00000000
    Key/Value Pairs
        KeyValue: InitiatorName=iqn.2012-04.com.example:f353602c
        KeyValue: InitiatorAlias=monitoringvh2
        KeyValue: SessionType=Discovery
        KeyValue: AuthMethod=CHAP,None
    Padding: 00

*** Step 2: Login Response (Success)

*iSCSI (Login Response)
    Opcode: Login Response (0x23)
    0... .... = T: Stay in current login stage
    .0.. .... = C: Text is complete
    .... 00.. = CSG: Security negotiation (0x0)
    VersionMax: 0x00
    VersionActive: 0x00
    TotalAHSLength: 0x00
    DataSegmentLength: 62 (0x0000003e)
    ISID: 00023d000000
        00.. .... = ISID_t: IEEE OUI (0x0)
        ..00 0000 = ISID_a: 0x00
        ISID_b: 0x023d
        ISID_c: 0x00
        ISID_d: 0x0000
    TSIH: 0x0000
    InitiatorTaskTag: 0x00000000
    StatSN: 0x28aa1401
    ExpCmdSN: 0x00000001
    MaxCmdSN: 0x00000001
    Status: Success (0x0000)
    Key/Value Pairs
        KeyValue: AuthMethod=CHAP
        KeyValue: TargetAlias=LIO Target
        KeyValue: TargetPortalGroupTag=1
    Padding: 0000*

** Step 3: Login Command

*iSCSI (Login Command)
    Opcode: Login Command (0x03)
    0... .... = T: Stay in current login stage
    .0.. .... = C: Text is complete
    .... 00.. = CSG: Security negotiation (0x0)
    VersionMax: 0x00
    VersionMin: 0x00
    TotalAHSLength: 0x00
    DataSegmentLength: 9 (0x00000009)
    ISID: 00023d000000
        00.. .... = ISID_t: IEEE OUI (0x0)
        ..00 0000 = ISID_a: 0x00
        ISID_b: 0x023d
        ISID_c: 0x00
        ISID_d: 0x0000
    TSIH: 0x0000
    InitiatorTaskTag: 0x00000000
    CID: 0x0000
    CmdSN: 0x00000001
    ExpStatSN: 0x28aa1402
    Key/Value Pairs
        KeyValue: CHAP_A=5
    Padding: 000000

*Step 4: Login Response (Authentification failed)*

iSCSI (Login Response)
    Opcode: Login Response (0x23)
    0... .... = T: Stay in current login stage
    .0.. .... = C: Text is complete
    .... 00.. = CSG: Security negotiation (0x0)
    VersionMax: 0x00
    VersionActive: 0x00
    TotalAHSLength: 0x00
    DataSegmentLength: 0 (0x00000000)
    ISID: 000000000000
        00.. .... = ISID_t: IEEE OUI (0x0)
        ..00 0000 = ISID_a: 0x00
        ISID_b: 0x0000
        ISID_c: 0x00
        ISID_d: 0x0000
    TSIH: 0x0000
    InitiatorTaskTag: 0x00000000
    StatSN: 0x00000000
    ExpCmdSN: 0x00000000
    MaxCmdSN: 0x00000000
    Status: Authentication failed (0x0201)

Regards
Marc




Am 27.09.2017 um 14:27 schrieb Marc Schöchlin:
> Hi,
>
> i am using XEN server/XEN center 7.2 as and i would like to access a
> iscsi storage resource from this system.
> My target runs on kernel 4.4.0-83-generic on Ubuntu 16.04.
>
> My targetcli output looks like this:
>
> # targetcli
> targetcli shell version 2.1.fb43
> Copyright 2011-2013 by Datera, Inc and others.
> For help on commands, type 'help'.
>
> /> cd /
> /> ls
> o- /
> .........................................................................................................................
> [...]
>   o- backstores
> ..............................................................................................................
> [...]
>   | o- block
> ..................................................................................................
> [Storage Objects: 3]
>   | | o- ba-safe-po_k11111-v9988-foobar-monitoringvh1-1 
> [/dev/ba/ba-safe-po/k11111-v9988-foobar-monitoringvh1-1 (1.0TiB)
> write-thru activated]
>   | | o-
> ba-safe-po_k11111-v9988-foobar-ba4tt2a-foobar-barfoo1-qt-iscsi-a-0 
> [/dev/ba/ba-safe-po/k11111-v9988-foobar-ba4tt2a-foobar-barfoo1-qt-iscsi-a-0
> (1.0GiB) write-thru activated]
>   | | o- ba-safe-po_k11111-v8448-foobarmsctest-0 ........
> [/dev/ba/ba-safe-po/k11111-v8448-foobarmsctest-0 (1.0GiB) write-thru
> activated]
>   | o- fileio
> .................................................................................................
> [Storage Objects: 0]
>   | o- pscsi
> ..................................................................................................
> [Storage Objects: 0]
>   | o- ramdisk
> ................................................................................................
> [Storage Objects: 0]
>   o- iscsi
> ............................................................................................................
> [Targets: 1]
>   | o- iqn.2017-09.barf.net:910f1868
> ................................................................................
> [TPGs: 1]
>   |   o- tpg1
> ...............................................................................................
> [no-gen-acls, no-auth]
>   |     o- acls
> ..........................................................................................................
> [ACLs: 3]
>   |     | o- iqn.1993-08.org.debian:01:12d0b0ef74a8
> ............................................................... [Mapped
> LUNs: 1]
>   |     | | o- mapped_lun255 ....................... [lun1
> block/ba-safe-po_k11111-v9988-foobar-ba4tt2a-foobar-barfoo1-qt-iscsi-a-0
> (rw)]
>   |     | o- iqn.2012-04.com.example:910f1868
> .....................................................................
> [Mapped LUNs: 1]
>   |     | | o- mapped_lun1 ...........................................
> [lun0 block/ba-safe-po_k11111-v9988-foobar-monitoringvh1-1 (rw)]
>   |     | o- iqn.2017-09.barf.net:910f1868
> ..................................................................
> [Mapped LUNs: 1]
>   |     |   o- mapped_lun254
> ................................................ [lun2
> block/ba-safe-po_k11111-v8448-foobarmsctest-0 (rw)]
>   |     o- luns
> ..........................................................................................................
> [LUNs: 3]
>   |     | o- lun0 .......
> [block/ba-safe-po_k11111-v9988-foobar-monitoringvh1-1
> (/dev/ba/ba-safe-po/k11111-v9988-foobar-monitoringvh1-1)]
>   |     | o- lun1 
> [block/ba-safe-po_k11111-v9988-foobar-ba4tt2a-foobar-barfoo1-qt-iscsi-a-0
> (/dev/ba/ba-safe-po/k11111-v9988-foobar-ba4tt2a-foobar-barfoo1-qt-iscsi-a-0)]
>   |     | o- lun2 .....................
> [block/ba-safe-po_k11111-v8448-foobarmsctest-0
> (/dev/ba/ba-safe-po/k11111-v8448-foobarmsctest-0)]
>   |     o- portals
> ....................................................................................................
> [Portals: 1]
>   |       o- 0.0.0.0:3260
> .....................................................................................................
> [OK]
>   o- loopback
> .........................................................................................................
> [Targets: 0]
>   o- vhost
> ............................................................................................................
> [Targets: 0]
>

