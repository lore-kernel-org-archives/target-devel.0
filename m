From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 30 Nov 2018 16:41:30 +0000
Subject: Re: [PATCH v4 6/7] target: remove hardcoded T10 Vendor ID in INQUIRY response
Message-Id: <1543596090.185366.149.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181129010157.12687-7-ddiss@suse.de>
In-Reply-To: <20181129010157.12687-7-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Fri, 2018-11-30 at 15:41 +-0100, David Disseldorp wrote:
+AD4 On Fri, 30 Nov 2018 14:17:49 +-0100, David Disseldorp wrote:
+AD4 
+AD4 +AD4 +AD4 Where is the code that initializes dev-+AD4-t10+AF8-wwn.vendor to +ACI-LIO-ORG+ACI? Did I
+AD4 +AD4 +AD4 perhaps overlook something?  
+AD4 +AD4 
+AD4 +AD4 This is done in target+AF8-configure+AF8-device() .
+AD4 
+AD4 Hmm, continuing to do it there may cause a bit of confusion if vendor+AF8-id
+AD4 is set before the backstore is enabled, which would cause it to be
+AD4 overwritten. That said, we already have similarly strange behaviour for
+AD4 emulate+AF8-model+AF8-alias / product. E.g.:
+AD4 
+AD4 rapido1:/+ACM cd /sys/kernel/config/target/
+AD4 rapido1:target+ACM mkdir -p core/fileio+AF8-1/testing
+AD4 rapido1:target+ACM echo -n +ACI-fd+AF8-dev+AF8-name+AD0-/asdf,fd+AF8-dev+AF8-size+AD0-4096+ACI +AD4 core/fileio+AF8-1/testing/control
+AD4 rapido1:target+ACM echo -n +ACI-testing1+ACI +AD4 core/fileio+AF8-1/testing/wwn/vendor+AF8-id
+AD4 rapido1:target+ACM cat core/fileio+AF8-1/testing/wwn/vendor+AF8-id
+AD4 testing1
+AD4 rapido1:target+ACM echo 1 +AD4 ./core/fileio+AF8-1/testing/attrib/emulate+AF8-model+AF8-alias
+AD4 rapido1:target+ACM cat ./core/fileio+AF8-1/testing/statistics/scsi+AF8-lu/prod
+AD4 testing
+AD4 rapido1:target+ACM echo 1 +AD4 core/fileio+AF8-1/testing/enable
+AD4 rapido1:target+ACM cat core/fileio+AF8-1/testing/wwn/vendor+AF8-id
+AD4 LIO-ORG
+AD4 rapido1:target+ACM cat ./core/fileio+AF8-1/testing/statistics/scsi+AF8-lu/prod
+AD4 FILEIO
+AD4 rapido1:target+ACM cat ./core/fileio+AF8-1/testing/attrib/emulate+AF8-model+AF8-alias
+AD4 1
+AD4 
+AD4 Not sure how best to handle this...
+AD4 1. move vendor/model/rev initialization into target+AF8-alloc+AF8-device()
+AD4 2. move vendor (only) initialization into target+AF8-alloc+AF8-device()
+AD4 3. fail attempts to set emulate+AF8-model+AF8-alias or vendor+AF8-id before the
+AD4    backstore has been enabled
+AD4 4. leave as-is
+AD4 
+AD4 (1) would IMO be the most straightforward, but it's a slight change to
+AD4 the existing (IMO broken) emulate+AF8-model+AF8-alias user interface.

I'm in favor of moving some of the target+AF8-configure+AF8-device() code into the
target+AF8-alloc+AF8-device() function. Today target+AF8-configure+AF8-device() overwrites
the vendor, model and revision string and is called when +ACI-1+ACI is written
into the +ACI-enable+ACI attribute. Overwriting these attributes when enabling a
backstore seems wrong to me.

Thanks,

Bart.
