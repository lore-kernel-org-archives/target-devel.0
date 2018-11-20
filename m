From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 20 Nov 2018 17:24:39 +0000
Subject: Re: [PATCH v3 3/4] target: add device vendor_id configfs attribute
Message-Id: <1542734679.185366.76.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181119210636.22979-4-ddiss@suse.de>
In-Reply-To: <20181119210636.22979-4-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, 2018-11-19 at 22:06 +-0100, David Disseldorp wrote:
+AD4  /+ACo
+AD4 +- +ACo STANDARD and VPD page 0x80 T10 Vendor Identification
+AD4 +- +ACo-/
+AD4 +-static ssize+AF8-t target+AF8-wwn+AF8-vendor+AF8-id+AF8-show(struct config+AF8-item +ACo-item,
+AD4 +-		char +ACo-page)
+AD4 +-+AHs
+AD4 +-	return sprintf(page, +ACI-T10 Vendor Identification: +ACU.+ACI
+AD4 +-		       +AF8AXw-stringify(INQUIRY+AF8-VENDOR+AF8-IDENTIFIER+AF8-LEN) +ACI-s+AFw-n+ACI,
+AD4 +-		       +ACY-to+AF8-t10+AF8-wwn(item)-+AD4-vendor+AFs-0+AF0)+ADs
+AD4 +-+AH0

This doesn't follow the convention used by other configfs attributes,
namely that only the value should be reported and no prefix. Please leave
out the +ACI-T10 Vendor Identification: +ACI prefix.

+AD4 +-static ssize+AF8-t target+AF8-wwn+AF8-vendor+AF8-id+AF8-store(struct config+AF8-item +ACo-item,
+AD4 +-		const char +ACo-page, size+AF8-t count)
+AD4 +-+AHs
+AD4 +-	struct t10+AF8-wwn +ACo-t10+AF8-wwn +AD0 to+AF8-t10+AF8-wwn(item)+ADs
+AD4 +-	struct se+AF8-device +ACo-dev +AD0 t10+AF8-wwn-+AD4-t10+AF8-dev+ADs
+AD4 +-	/+ACo +-1 to ensure buf is zero terminated for stripping +ACo-/
+AD4 +-	unsigned char buf+AFs-INQUIRY+AF8-VENDOR+AF8-IDENTIFIER+AF8-LEN +- 1+AF0AOw
+AD4 +-
+AD4 +-	if (strlen(page) +AD4 INQUIRY+AF8-VENDOR+AF8-IDENTIFIER+AF8-LEN) +AHs
+AD4 +-		pr+AF8-err(+ACI-Emulated T10 Vendor Identification exceeds+ACI
+AD4 +-			+ACI INQUIRY+AF8-VENDOR+AF8-IDENTIFIER+AF8-LEN: +ACU-d+AFw-n+ACI,
+AD4 +-			INQUIRY+AF8-VENDOR+AF8-IDENTIFIER+AF8-LEN)+ADs
+AD4 +-		return -EOVERFLOW+ADs
+AD4 +-	+AH0

Trailing newline(s) should be stripped before the length check is performed. I
don't think that you want to force users to use +ACI-echo -n+ACI instead of +ACI-echo+ACI when
setting this attribute.

+AD4 +-	strncpy(buf, page, sizeof(buf))+ADs

Isn't strncpy() deprecated? How about using strlcpy() instead?

+AD4 +-	/+ACo
+AD4 +-	 +ACo Check to see if any active +ACQ-FABRIC+AF8-MOD exports exist.  If they
+AD4 +-	 +ACo do exist, fail here as changing this information on the fly
+AD4 +-	 +ACo (underneath the initiator side OS dependent multipath code)
+AD4 +-	 +ACo could cause negative effects.
+AD4 +-	 +ACo-/
+AD4 +-	if (dev-+AD4-export+AF8-count) +AHs
+AD4 +-		pr+AF8-err(+ACI-Unable to set T10 Vendor Identification while+ACI
+AD4 +-			+ACI active +ACU-d +ACQ-FABRIC+AF8-MOD exports exist+AFw-n+ACI,
+AD4 +-			dev-+AD4-export+AF8-count)+ADs
+AD4 +-		return -EINVAL+ADs
+AD4 +-	+AH0

Are there any users who understand what +ACIAJA-FABRIC+AF8-MOD+ACI means? Please leave out that
string or change it into the name of the fabric driver followed by the name of the
target port associated with 'item'.

+AD4 +-
+AD4 +-	/+ACo
+AD4 +-	 +ACo Assume ASCII encoding. Strip any newline added from userspace.
+AD4 +-	 +ACo The result may +ACo-not+ACo be null terminated.
+AD4 +-	 +ACo-/
+AD4 +-	strncpy(dev-+AD4-t10+AF8-wwn.vendor, strstrip(buf),
+AD4 +-		INQUIRY+AF8-VENDOR+AF8-IDENTIFIER+AF8-LEN)+ADs

Keeping strings around that are not '+AFw-0'-terminated is a booby trap. It is very
easy for anyone who modifies or reviews code that uses such strings to overlook
that the string is not '+AFw-0'-terminated. Please increase the size of the vendor+AFsAXQ
array by one and make sure that that string is '+AFw-0'-terminated.

Thanks,

Bart.
