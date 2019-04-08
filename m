From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 08 Apr 2019 23:17:07 +0000
Subject: Re: [PATCH 03/11] target/core: Release SPC-2 reservation upon initiator logout
Message-Id: <1554765427.118779.292.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20190402195815.254796-4-bvanassche@acm.org>
In-Reply-To: <20190402195815.254796-4-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, 2019-04-08 at 17:41 -0500, Mike Christie wrote:
+AD4 On 04/08/2019 03:17 PM, Bart Van Assche wrote:
+AD4 +AD4 On Mon, 2019-04-08 at 15:04 -0500, Mike Christie wrote:
+AD4 +AD4 +AD4 Was the original code done for iscsi? We have this in
+AD4 +AD4 +AD4 https://tools.ietf.org/html/rfc7143:
+AD4 +AD4 +AD4 
+AD4 +AD4 +AD4 4.4.3.2. Reservations
+AD4 +AD4 +AD4 
+AD4 +AD4 +AD4 ....
+AD4 +AD4 +AD4 
+AD4 +AD4 +AD4 In contrast, +AFs-SPC2+AF0 does not specify detailed persistence
+AD4 +AD4 +AD4 requirements for reserve/release reservation state after an I+AF8-T nexus
+AD4 +AD4 +AD4 failure. Nonetheless, when reserve/release reservations are
+AD4 +AD4 +AD4 supported by an iSCSI target, the preferred implementation approach
+AD4 +AD4 +AD4 is to preserve reserve/release reservation state for iSCSI session
+AD4 +AD4 +AD4 reinstatement (see Section 6.3.5) or session continuation (see
+AD4 +AD4 +AD4 Section 6.3.6).
+AD4 +AD4 +AD4 
+AD4 +AD4 +AD4 
+AD4 +AD4 +AD4 So for example for session reinstatement if you pull a network cable
+AD4 +AD4 +AD4 then plug it back in the iscsi target can do a
+AD4 +AD4 +AD4 iscsit+AF8-close+AF8-session-+AD4-transport+AF8-deregister+AF8-session -+AD4
+AD4 +AD4 +AD4 transport+AF8-free+AF8-session. Above we will now release the reservation.
+AD4 +AD4 
+AD4 +AD4 Hello Mike,
+AD4 +AD4 
+AD4 +AD4 Was that paragraph from the iSCSI RFC perhaps written before it was made clear
+AD4 +AD4 in SPC-2 that reserve/release reservations do not persist? I think the name of
+AD4 
+AD4 Do you know when that was added to SPC 2?
+AD4 
+AD4 The iscsi text above is from RFC 7143 which I think was ratified in
+AD4 2014. I think it was added in that version to clarify the issue. I am
+AD4 not sure though.
+AD4 
+AD4 The original 3720 ratified in 2004 did not have that chunk and only had
+AD4 limited references/info on reservations.

Hello Mike,

From spc2r01 (1997-11-13): +ACI-Reservations managed using the Reserve/Release
method do not persist across some recovery actions (e.g., hard resets), so
most systems require significant reinitialization after a failure that
results in a hard reset. Reserve/Release managed reservations are retained
by the device server until released or until reset by mechanisms specified
in this standard.+ACI

Although the words differ from later versions of SPC2, the intention has not
changed.

Other vendors seem to agree with what has been defined in SPC2. From
https://kb.netapp.com/app/answers/answer+AF8-view/a+AF8-id/1001463/+AH4-/what-are-scsi-reservations-and-scsi-persistent-reservations+ACU-3F-:
+ACI-Thus, a SCSI bus reset performed due to an error recovery would cause the
reservation to be released.+ACI

Does this mean that the authors of the iSCSI RFC chose behavior that
contradicts established behavior for the SCSI reserve and release commands?

Thanks,

Bart.
