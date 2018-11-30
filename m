From: David Disseldorp <ddiss@suse.de>
Date: Fri, 30 Nov 2018 14:41:14 +0000
Subject: Re: [PATCH v4 6/7] target: remove hardcoded T10 Vendor ID in INQUIRY response
Message-Id: <20181130154114.1ea06b33@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181129010157.12687-7-ddiss@suse.de>
In-Reply-To: <20181129010157.12687-7-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Fri, 30 Nov 2018 14:17:49 +0100, David Disseldorp wrote:

> > Where is the code that initializes dev->t10_wwn.vendor to "LIO-ORG"? Did I
> > perhaps overlook something?  
> 
> This is done in target_configure_device() .

Hmm, continuing to do it there may cause a bit of confusion if vendor_id
is set before the backstore is enabled, which would cause it to be
overwritten. That said, we already have similarly strange behaviour for
emulate_model_alias / product. E.g.:

rapido1:/# cd /sys/kernel/config/target/
rapido1:target# mkdir -p core/fileio_1/testing
rapido1:target# echo -n "fd_dev_name=/asdf,fd_dev_size@96" > core/fileio_1/testing/control
rapido1:target# echo -n "testing1" > core/fileio_1/testing/wwn/vendor_id
rapido1:target# cat core/fileio_1/testing/wwn/vendor_id
testing1
rapido1:target# echo 1 > ./core/fileio_1/testing/attrib/emulate_model_alias
rapido1:target# cat ./core/fileio_1/testing/statistics/scsi_lu/prod
testing
rapido1:target# echo 1 > core/fileio_1/testing/enable
rapido1:target# cat core/fileio_1/testing/wwn/vendor_id
LIO-ORG
rapido1:target# cat ./core/fileio_1/testing/statistics/scsi_lu/prod
FILEIO
rapido1:target# cat ./core/fileio_1/testing/attrib/emulate_model_alias
1

Not sure how best to handle this...
1. move vendor/model/rev initialization into target_alloc_device()
2. move vendor (only) initialization into target_alloc_device()
3. fail attempts to set emulate_model_alias or vendor_id before the
   backstore has been enabled
4. leave as-is

(1) would IMO be the most straightforward, but it's a slight change to
the existing (IMO broken) emulate_model_alias user interface.

Cheers, David
