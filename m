From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 09 Apr 2019 17:25:15 +0000
Subject: Re: [PATCH 03/11] target/core: Release SPC-2 reservation upon initiator logout
Message-Id: <1554830715.161891.11.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20190402195815.254796-4-bvanassche@acm.org>
In-Reply-To: <20190402195815.254796-4-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Tue, 2019-04-09 at 00:47 -0500, Mike Christie wrote:
+AD4 I don't know.
+AD4 
+AD4 For the hard reset/reset event case, if we go by SAM 2 which iscsi RFC
+AD4 7143 and 3720 say they are based on at the beginning of their
+AD4 definitions then it sounds like it depends on the transport spec for
+AD4 what is a hard reset. We have this from SAM 2:
+AD4 
+AD4 5.9.6 Hard reset:
+AD4 
+AD4 A hard reset is a SCSI target port action in response to a reset event
+AD4 within the service delivery subsystem. A wakeup event (see 3.1.132) is a
+AD4 reset event. The definition of additional reset events is SCSI transport
+AD4 protocol specific. Each SCSI transport protocol standard that defines
+AD4 reset events shall specify the SCSI target port+IBk-s action
+AD4 in response to reset events.
+AD4 
+AD4 --------
+AD4 
+AD4 That might sound like a wake event is a hard reset defined by SAM 2, and
+AD4 the transport defines others. In the iscsi RFC the only mention of reset
+AD4 events is when handling the iSCSI TARGET COLD RESET TMF. However, the
+AD4 RFC does define the session reinstatement case as a I+AF8-T nexus loss
+AD4 event, so if that is considered a hard reset by the SAM 2 definition
+AD4 then I think your patch is correct. I have no idea if other software
+AD4 writers read the specs/rfcs like maybe Nick did though.

Hi Mike,

I'm fine with leaving out patch 3/11. But even if this patch is left out
that still leaves the question open what the behavior of RESERVE/RELEASE
should be ...

Bart.
