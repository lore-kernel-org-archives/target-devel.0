From: Bart Van Assche <Bart.VanAssche@wdc.com>
Date: Thu, 19 Jul 2018 15:15:12 +0000
Subject: Re: [PATCH 02/15] target: fix isid copying and comparision
Message-Id: <58ed00dc093675ce511ae5f8d6e30489a8479f0b.camel@wdc.com>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-3-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-3-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, 2018-07-18 at 20:02 -0500, Mike Christie wrote:
+AD4- On 07/18/2018 07:03 PM, Mike Christie wrote:
+AD4- +AD4- On 07/18/2018 05:09 PM, Bart Van Assche wrote:
+AD4- +AD4- +AD4- +AFs- ... +AF0-
+AD4- +AD4- +AD4- is that these involve a transport ID and that that transport ID can be up to 228
+AD4- +AD4- +AD4- bytes long for iSCSI.
+AD4- +AD4- 
+AD4- +AD4- I am talking about the Initiator Session ID above. That along with the
+AD4- +AD4- iscsi name make up the Initiator Port Transport ID. In spc4r37 checkout
+AD4- +AD4- table 508 or in SAM 5r21 checkout table A.4.
+AD4- +AD4- 
+AD4- +AD4- So in the SCSI specs as part of the Initiator Port Transport ID we have
+AD4- +AD4- this from that SAM table:
+AD4- +AD4- 
+AD4- +AD4- The Initiator Session Identifier (ISID) portion of the string is a UTF-8
+AD4- +AD4- encoded hexadecimal representation of a six byte binary value.
+AD4- +AD4- 
+AD4- +AD4- ---
+AD4- +AD4- 
+AD4- +AD4- In the PR parts of SPC it sometimes mentions only +ACI-Transport ID+ACI- but
+AD4- +AD4- then clarifies the initiator port so I am assuming in those cases it
+AD4- +AD4- means +ACI-Initiator Port Transport ID+ACI- so it is both the name and isid for
+AD4- +AD4- iscsi.
+AD4- 
+AD4- It looks like we are supposed to go by what the initiator specifies in
+AD4- the TPID field, so it can be either the Transport ID or Initiator Port
+AD4- Transport ID.

Hello Mike,

Since the ISID is iSCSI-specific I think that all code that knows about the
ISID and its encoding should be in the iSCSI target driver instead of the
target core. Do you think an approach similar to that of the SCST function
iscsi+AF8-get+AF8-initiator+AF8-port+AF8-transport+AF8-id() can be implemented in LIO? The caller
of that function is in source file scst/src/scst+AF8-targ.c:

		res +AD0- sess-+AD4-tgt-+AD4-tgtt-+AD4-get+AF8-initiator+AF8-port+AF8-transport+AF8-id(
					sess-+AD4-tgt, sess, +ACY-sess-+AD4-transport+AF8-id)+ADs-

Thanks,

Bart.