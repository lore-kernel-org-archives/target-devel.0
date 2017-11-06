From: SF Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 06 Nov 2017 21:11:06 +0000
Subject: Re: iSCSI-target: Use common error handling code in iscsi_decode_text_input()
Message-Id: <49e62625-8c1d-5bbe-2ddd-e25e117754db@users.sourceforge.net>
List-Id: <target-devel.vger.kernel.org>
References: <d36d5072-3e35-da39-bc0f-af15deb630a8@users.sourceforge.net>
 <20171106162549.5b2511db@alans-desktop>
In-Reply-To: <20171106162549.5b2511db@alans-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Arun Easi <arun.easi@cavium.com>, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org

>> Add a jump target so that a bit of exception handling can be better reused
>> at the end of this function.
> 
> Why not look at what the C compiler generates before making the code
> less readable ?

* Does the adjusted source code layout fit to information from the section
  “7) Centralized exiting of functions” in the document “coding-style.rst”?

* Would you find a reduction of 16 bytes for the object code useful for
  the affected function implementation?

Regards,
Markus
