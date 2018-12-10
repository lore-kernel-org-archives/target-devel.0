From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 10 Dec 2018 19:19:59 +0000
Subject: Re: [RFC PATCH] target: sanitize ALUA and PR state file paths before use
Message-Id: <1544469599.185366.374.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181122133800.1251-1-ddiss@suse.de>
In-Reply-To: <20181122133800.1251-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, 2018-12-10 at 14:36 +-0100, David Disseldorp wrote:
+AD4 Ping - any feedback on this change?
+AD4 
+AD4 On Thu, 22 Nov 2018 14:38:00 +-0100, David Disseldorp wrote:
+AD4 
+AD4 +AD4 Block ALUA and PR state storage if any of the dynamic subdirectory
+AD4 +AD4 components include a path separator.
+AD4 +AD4 
+AD4 +AD4 Fixes: c66ac9db8d4a (+ACIAWw-SCSI+AF0 target: Add LIO target core v4.0.0-rc6+ACI)
+AD4 +AD4 Signed-off-by: David Disseldorp +ADw-ddiss+AEA-suse.de+AD4
+AD4 +AD4 Signed-off-by: Lee Duncan +ADw-lduncan+AEA-suse.com+AD4
+AD4 +AD4 ---
+AD4 +AD4 Note:
+AD4 +AD4 Submitted as an RFC, as I've not properly tested the alua code path.
+AD4 +AD4 I'm also not sure whether it's reasonable to break existing setups
+AD4 +AD4 with a '/' in the configured unit+AF8-serial. Where +ACI-break+ACI means fail
+AD4 +AD4 APTPL PR requests+ADs ALUA state-save failures are ignored internally.
+AD4 
+AD4 I'd also be happy with any pointers on properly testing ALUA.

Embedding SCSI properties like the unit serial number in a file system path
seems wrong to me. I think the path in which these properties are stored
should be derived from configfs item names configured by the user. These
names are guaranteed to be ASCII strings. If you want to see an example of
alternative approach you are welcome to have a look at scst+AF8-pr+AF8-set+AF8-file+AF8-name()
and scst+AF8-pr+AF8-sync+AF8-device+AF8-file() in the SCST source code.

Regarding testing ALUA code: I use sg+AF8-rtpg and sg+AF8-stpg to test SCSI target
ALUA code.

Bart.
