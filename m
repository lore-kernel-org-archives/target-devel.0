From: Bart Van Assche <Bart.VanAssche@wdc.com>
Date: Thu, 19 Jul 2018 15:23:33 +0000
Subject: Re: [PATCH 04/15] target/iscsi: move session_index to common se_session
Message-Id: <3b18d0ff1b32155a9a936c42979a4341aa48a961.camel@wdc.com>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-5-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-5-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, 2018-07-18 at 22:47 -0500, Mike Christie wrote:
+AD4- Hey Bart, I looked into this some more and this value is also being used
+AD4- as the scsiAttIntrPortIndex. For that use, does it need to be unique
+AD4- across a target when the target has multiple ports?
+AD4- 
+AD4- So I think it needs to be on the se+AF8-wwn right?

Hello Mike,

I think the best solution would be to decouple the session index that is used
to export session information through configfs from the session index used by
the SCSI-MIB (scsiAttIntrPortIndex). That approach would allow to make both
indexes consecutive integers in all cases for both interfaces. However, neither
configfs nor the SCSI-MIB requires that session indexes are consecutive
integers. So I think moving se+AF8-sess+AF8-idr+AF8-lock and se+AF8-sess+AF8-idr into struct
se+AF8-wwn is fine.

Bart.