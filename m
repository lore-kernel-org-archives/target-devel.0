From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 29 Nov 2018 16:32:47 +0000
Subject: Re: [PATCH v4 5/7] target: add device vendor_id configfs attribute
Message-Id: <1543509167.185366.127.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181129010157.12687-6-ddiss@suse.de>
In-Reply-To: <20181129010157.12687-6-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Thu, 2018-11-29 at 02:01 +-0100, David Disseldorp wrote:
+AD4 +-static ssize+AF8-t target+AF8-wwn+AF8-vendor+AF8-id+AF8-show(struct config+AF8-item +ACo-item,
+AD4 +-		char +ACo-page)
+AD4 +-+AHs
+AD4 +-	return sprintf(page, +ACIAJQ-s+AFw-n+ACI, +ACY-to+AF8-t10+AF8-wwn(item)-+AD4-vendor+AFs-0+AF0)+ADs
+AD4 +-+AH0

The +ACIAJgAi and +ACIAWw-0+AF0AIg are superfluous in the above sprintf() statement.

+AD4 +-static ssize+AF8-t target+AF8-wwn+AF8-vendor+AF8-id+AF8-store(struct config+AF8-item +ACo-item,
+AD4 +-		const char +ACo-page, size+AF8-t count)
+AD4 +-+AHs
+AD4 +-	struct t10+AF8-wwn +ACo-t10+AF8-wwn +AD0 to+AF8-t10+AF8-wwn(item)+ADs
+AD4 +-	struct se+AF8-device +ACo-dev +AD0 t10+AF8-wwn-+AD4-t10+AF8-dev+ADs
+AD4 +-	unsigned char buf+AFs-INQUIRY+AF8-VENDOR+AF8-LEN +- 1+AF0AOw
+AD4 +-
+AD4 +-	if (strlen(page) +AD4 INQUIRY+AF8-VENDOR+AF8-LEN) +AHs
+AD4 +-		pr+AF8-err(+ACI-Emulated T10 Vendor Identification exceeds+ACI
+AD4 +-			+ACI INQUIRY+AF8-VENDOR+AF8-LEN: +ACI +AF8AXw-stringify(INQUIRY+AF8-VENDOR+AF8-LEN)
+AD4 +-			+ACIAXA-n+ACI)+ADs
+AD4 +-		return -EOVERFLOW+ADs
+AD4 +-	+AH0

Does this force users to use +ACI-echo -n+ACI to configure vendor IDs that are
INQUIRY+AF8-VENDOR+AF8-LEN bytes long?

Bart.
