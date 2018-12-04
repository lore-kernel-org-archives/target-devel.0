From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 04 Dec 2018 00:35:49 +0000
Subject: Re: [PATCH v5 5/5] target: perform t10_wwn ID initialisation in target_alloc_device()
Message-Id: <1543883749.185366.177.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181130233423.26556-6-ddiss@suse.de>
In-Reply-To: <20181130233423.26556-6-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sat, 2018-12-01 at 15:59 +-0100, Hannes Reinecke wrote:
+AD4 On 12/1/18 12:34 AM, David Disseldorp wrote:
+AD4 +AD4 Initialise the t10+AF8-wwn vendor, model and revision defaults when a
+AD4 +AD4 device is allocated instead of when it's enabled. This ensures that
+AD4 +AD4 custom vendor or model strings set prior to enablement are not later
+AD4 +AD4 overwritten with default values.
+AD4 +AD4 
+AD4 +AD4 Signed-off-by: David Disseldorp +ADw-ddiss+AEA-suse.de+AD4
+AD4 +AD4 ---
+AD4 +AD4   drivers/target/target+AF8-core+AF8-device.c +AHw 34 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+------------------
+AD4 +AD4   1 file changed, 17 insertions(+-), 17 deletions(-)
+AD4 +AD4  +AD4 diff --git a/drivers/target/target+AF8-core+AF8-device.c 
+AD4 
+AD4 b/drivers/target/target+AF8-core+AF8-device.c
+AD4 +AD4 index 5512871f50e4..6318d59a1564 100644
+AD4 +AD4 --- a/drivers/target/target+AF8-core+AF8-device.c
+AD4 +AD4 +-+-+- b/drivers/target/target+AF8-core+AF8-device.c
+AD4 +AD4 +AEAAQA -810,6 +-810,23 +AEAAQA struct se+AF8-device +ACo-target+AF8-alloc+AF8-device(struct se+AF8-hba +ACo-hba, const char +ACo-name)
+AD4 +AD4   	mutex+AF8-init(+ACY-xcopy+AF8-lun-+AD4-lun+AF8-tg+AF8-pt+AF8-md+AF8-mutex)+ADs
+AD4 +AD4   	xcopy+AF8-lun-+AD4-lun+AF8-tpg +AD0 +ACY-xcopy+AF8-pt+AF8-tpg+ADs
+AD4 +AD4   
+AD4 +AD4 +-	/+ACo
+AD4 +AD4 +-	 +ACo Preload the initial INQUIRY const values if we are doing
+AD4 +AD4 +-	 +ACo anything virtual (IBLOCK, FILEIO, RAMDISK), but not for TCM/pSCSI
+AD4 +AD4 +-	 +ACo passthrough because this is being provided by the backend LLD.
+AD4 +AD4 +-	 +ACo-/
+AD4 +AD4 +-	BUILD+AF8-BUG+AF8-ON(sizeof(dev-+AD4-t10+AF8-wwn.vendor) +ACEAPQ INQUIRY+AF8-VENDOR+AF8-LEN +- 1)+ADs
+AD4 +AD4 +-	BUILD+AF8-BUG+AF8-ON(sizeof(dev-+AD4-t10+AF8-wwn.model) +ACEAPQ INQUIRY+AF8-MODEL+AF8-LEN +- 1)+ADs
+AD4 +AD4 +-	BUILD+AF8-BUG+AF8-ON(sizeof(dev-+AD4-t10+AF8-wwn.revision) +ACEAPQ INQUIRY+AF8-REVISION+AF8-LEN +- 1)+ADs
+AD4 +AD4 +-	if (+ACE(dev-+AD4-transport-+AD4-transport+AF8-flags +ACY TRANSPORT+AF8-FLAG+AF8-PASSTHROUGH)) +AHs
+AD4 +AD4 +-		strlcpy(dev-+AD4-t10+AF8-wwn.vendor, +ACI-LIO-ORG+ACI,
+AD4 +AD4 +-			sizeof(dev-+AD4-t10+AF8-wwn.vendor))+ADs
+AD4 +AD4 +-		strlcpy(dev-+AD4-t10+AF8-wwn.model, dev-+AD4-transport-+AD4-inquiry+AF8-prod,
+AD4 +AD4 +-			sizeof(dev-+AD4-t10+AF8-wwn.model))+ADs
+AD4 +AD4 +-		strlcpy(dev-+AD4-t10+AF8-wwn.revision, dev-+AD4-transport-+AD4-inquiry+AF8-rev,
+AD4 +AD4 +-			sizeof(dev-+AD4-t10+AF8-wwn.revision))+ADs
+AD4 +AD4 +-	+AH0
+AD4 +AD4 +-
+AD4 +AD4   	return dev+ADs
+AD4 +AD4   +AH0
+AD4 +AD4   
+AD4 
+AD4 This is odd. I'd rather have it consistent across backends, ie either 
+AD4 move the initialisation into the backends, or provide a means to check 
+AD4 if the inquiry data has already been pre-filled.
+AD4 But this check really is awkward.

Agreed. I also would like to see that that if-condition is removed ...

Thanks,

Bart.
