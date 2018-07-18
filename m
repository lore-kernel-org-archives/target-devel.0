From: Bart Van Assche <Bart.VanAssche@wdc.com>
Date: Wed, 18 Jul 2018 22:09:45 +0000
Subject: Re: [PATCH 02/15] target: fix isid copying and comparision
Message-Id: <e5291c30c0ab109a474e8205771f7e104b22ed30.camel@wdc.com>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-3-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-3-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sun, 2018-07-15 at 18:16 -0500, Mike Christie wrote:
+AD4- The isid is 48 bits, and in hex string format it's 12 bytes.
+AD4- We are currently copying the 12 byte hex string to a u64
+AD4- so we can easily compare it, but this has the problem that
+AD4- only 8 bytes of the 12 bytes are copied.
+AD4- 
+AD4- The next patches will want to print se+AF8-session sess+AF8-bin+AF8-isid
+AD4- so this has us use hex2bin to when converting from the hex
+AD4- sting to the bin value.
  +AF4AXgBeAF4AXg-
  string?

Which spec defines that an ISID is 48 bits? All I know about SCSI registrations
is that these involve a transport ID and that that transport ID can be up to 228
bytes long for iSCSI.

+AD4-  	if (isid +ACEAPQ- NULL) +AHs-
+AD4- -		pr+AF8-reg-+AD4-pr+AF8-reg+AF8-bin+AF8-isid +AD0- get+AF8-unaligned+AF8-be64(isid)+ADs-
+AD4- +-		if (hex2bin((u8 +ACo-)+ACY-pr+AF8-reg-+AD4-pr+AF8-reg+AF8-bin+AF8-isid, isid, 6)) +AHs-
+AD4- +-			pr+AF8-err(+ACI-Invalid isid +ACU-s+AFw-n+ACI-, isid)+ADs-
+AD4- +-			goto free+AF8-reg+ADs-
+AD4- +-		+AH0-

Why is it necessary to convert the ISID from hex to binary format? If this
conversion is necessary, isn't that something that should be handled by the
iSCSI target driver instead of the target core?

Thanks,

Bart.