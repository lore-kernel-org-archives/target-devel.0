From: Mike Christie <mchristi@redhat.com>
Date: Wed, 18 Jul 2018 23:04:30 +0000
Subject: Re: [PATCH 11/15] target: export initiator port values for all sessions
Message-Id: <5B4FC77E.6080206@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-12-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-12-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 07/18/2018 05:41 PM, Bart Van Assche wrote:
> On Sun, 2018-07-15 at 18:16 -0500, Mike Christie wrote:
>> Export the initiator port info in configfs
> 
> Does configfs support soft links? Can this information be exported as a
> soft link from the session directory to the struct se_portal_group configfs
> object?
> 

If you just needed to export the initiator name or if a single session
per initiator can be connected to a tpg then it would work ok.

The problem is for iscsi the scsi initiator port / transport id, is the
initiator name and isid. The isid is just a 48 bit number and the
initiator will allocate a new value for every session. So on the
initiator side if there are multiple nics, then it is common to create a
session through nic and each session will have the same initiator name
but different isids. So at some place you need to put multiple files to
export the different isids or indicate to userspace tools that there is
more than one session connected to that tpg.


