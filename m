From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 08 Apr 2019 20:17:38 +0000
Subject: Re: [PATCH 03/11] target/core: Release SPC-2 reservation upon initiator logout
Message-Id: <1554754658.118779.281.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20190402195815.254796-4-bvanassche@acm.org>
In-Reply-To: <20190402195815.254796-4-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, 2019-04-08 at 15:04 -0500, Mike Christie wrote:
+AD4 On 04/02/2019 02:58 PM, Bart Van Assche wrote:
+AD4 +AD4 While testing with the libiscsi tool I noticed after the tool had stopped
+AD4 +AD4 and hence after it had logged out that an SPC-2 reservation was still active:
+AD4 +AD4 
+AD4 +AD4 +ACQ (cd /sys/kernel/config/target/core +ACYAJg find -name res+AF8-holder+AHw-xargs grep -aH .)
+AD4 +AD4 ./pscsi+AF8-0/vdev3/pr/res+AF8-holder:Passthrough
+AD4 +AD4 ./iblock+AF8-0/vdev2/pr/res+AF8-holder:No SPC-3 Reservation holder
+AD4 +AD4 ./fileio+AF8-1/vdev1/pr/res+AF8-holder:SPC-2 Reservation: iSCSI Initiator: iqn.2007-10.com.github:sahlberg:libiscsi:iscsi-test-2
+AD4 +AD4 ./fileio+AF8-0/vdev0/pr/res+AF8-holder:No SPC-3 Reservation holder
+AD4 +AD4 
+AD4 +AD4 This is a bug. SPC-2 reservations must be cleared when an initiator
+AD4 +AD4 logs out. This patch fixes that bug. A quote from SPC-2 illustrates this:
+AD4 +AD4 +ACI-Reservations managed using the reserve/release method do not persist
+AD4 +AD4 across some recovery actions (e.g., hard resets). When a target performs
+AD4 +AD4 one of these recovery actions, the application client(s) have to rediscover
+AD4 +AD4 the configuration and re-establish the required reservations.+ACI
+AD4 +AD4 
+AD4 +AD4 Cc: Mike Christie +ADw-mchristi+AEA-redhat.com+AD4
+AD4 +AD4 Cc: Christoph Hellwig +ADw-hch+AEA-lst.de+AD4
+AD4 +AD4 Cc: Hannes Reinecke +ADw-hare+AEA-suse.com+AD4
+AD4 +AD4 Cc: Nicholas Bellinger +ADw-nab+AEA-linux-iscsi.org+AD4
+AD4 +AD4 Signed-off-by: Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4
+AD4 +AD4 ---
+AD4 +AD4  drivers/target/target+AF8-core+AF8-transport.c +AHw 10 +-+-+-+-+-+-+-+-+-+-
+AD4 +AD4  1 file changed, 10 insertions(+-)
+AD4 +AD4 
+AD4 +AD4 diff --git a/drivers/target/target+AF8-core+AF8-transport.c b/drivers/target/target+AF8-core+AF8-transport.c
+AD4 +AD4 index e3f7e21e6614..93ef5c6362d6 100644
+AD4 +AD4 --- a/drivers/target/target+AF8-core+AF8-transport.c
+AD4 +AD4 +-+-+- b/drivers/target/target+AF8-core+AF8-transport.c
+AD4 +AD4 +AEAAQA -550,6 +-550,15 +AEAAQA void transport+AF8-deregister+AF8-session+AF8-configfs(struct se+AF8-session +ACo-se+AF8-sess)
+AD4 +AD4  +AH0
+AD4 +AD4  EXPORT+AF8-SYMBOL(transport+AF8-deregister+AF8-session+AF8-configfs)+ADs
+AD4 +AD4  
+AD4 +AD4 +-static int target+AF8-sess+AF8-release+AF8-reservation(struct se+AF8-device +ACo-dev, void +ACo-data)
+AD4 +AD4 +-+AHs
+AD4 +AD4 +-	struct se+AF8-session +ACo-sess +AD0 data+ADs
+AD4 +AD4 +-
+AD4 +AD4 +-	if (dev-+AD4-reservation+AF8-holder +AD0APQ sess)
+AD4 +AD4 +-		target+AF8-release+AF8-reservation(dev)+ADs
+AD4 +AD4 +-	return 0+ADs
+AD4 +AD4 +-+AH0
+AD4 +AD4 +-
+AD4 +AD4  void transport+AF8-free+AF8-session(struct se+AF8-session +ACo-se+AF8-sess)
+AD4 +AD4  +AHs
+AD4 +AD4  	struct se+AF8-node+AF8-acl +ACo-se+AF8-nacl +AD0 se+AF8-sess-+AD4-se+AF8-node+AF8-acl+ADs
+AD4 +AD4 +AEAAQA -592,6 +-601,7 +AEAAQA void transport+AF8-free+AF8-session(struct se+AF8-session +ACo-se+AF8-sess)
+AD4 +AD4  		sbitmap+AF8-queue+AF8-free(+ACY-se+AF8-sess-+AD4-sess+AF8-tag+AF8-pool)+ADs
+AD4 +AD4  		kvfree(se+AF8-sess-+AD4-sess+AF8-cmd+AF8-map)+ADs
+AD4 +AD4  	+AH0
+AD4 +AD4 +-	target+AF8-for+AF8-each+AF8-device(target+AF8-sess+AF8-release+AF8-reservation, se+AF8-sess)+ADs
+AD4 +AD4  	percpu+AF8-ref+AF8-exit(+ACY-se+AF8-sess-+AD4-cmd+AF8-count)+ADs
+AD4 +AD4  	kmem+AF8-cache+AF8-free(se+AF8-sess+AF8-cache, se+AF8-sess)+ADs
+AD4 +AD4  +AH0
+AD4 +AD4 
+AD4 
+AD4 Was the original code done for iscsi? We have this in
+AD4 https://tools.ietf.org/html/rfc7143:
+AD4 
+AD4 4.4.3.2. Reservations
+AD4 
+AD4 ....
+AD4 
+AD4 In contrast, +AFs-SPC2+AF0 does not specify detailed persistence
+AD4 requirements for reserve/release reservation state after an I+AF8-T nexus
+AD4 failure. Nonetheless, when reserve/release reservations are
+AD4 supported by an iSCSI target, the preferred implementation approach
+AD4 is to preserve reserve/release reservation state for iSCSI session
+AD4 reinstatement (see Section 6.3.5) or session continuation (see
+AD4 Section 6.3.6).
+AD4 
+AD4 
+AD4 So for example for session reinstatement if you pull a network cable
+AD4 then plug it back in the iscsi target can do a
+AD4 iscsit+AF8-close+AF8-session-+AD4-transport+AF8-deregister+AF8-session -+AD4
+AD4 transport+AF8-free+AF8-session. Above we will now release the reservation.

Hello Mike,

Was that paragraph from the iSCSI RFC perhaps written before it was made clear
in SPC-2 that reserve/release reservations do not persist? I think the name of
the successor concept, +ACI-persistent reservations+ACI, makes it clear that the
majority of the implementations of the old reserve/release mechanism did not
persist these reservations across sessions.

Bart.
