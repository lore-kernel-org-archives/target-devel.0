From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Wed, 13 Nov 2019 17:29:49 +0000
Subject: Re: [PATCH 3/3] target/iscsi: Wait for all commands to finish before freeing a session
Message-Id: <20191113172949.dkcantqtx7c2zcpo@SPB-NB-133.local>
List-Id: <target-devel.vger.kernel.org>
References: <20191112035752.8338-4-bvanassche@acm.org>
In-Reply-To: <20191112035752.8338-4-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, Nov 13, 2019 at 09:07:41AM -0800, Bart Van Assche wrote:
> On 11/13/19 5:42 AM, Roman Bolshakov wrote:
> > On Mon, Nov 11, 2019 at 07:57:52PM -0800, Bart Van Assche wrote:
> > > -	target_get_sess_cmd(&cmd->se_cmd, true);
> > > +	if (target_get_sess_cmd(&cmd->se_cmd, true) < 0)
> > > +		return iscsit_add_reject_cmd(cmd,
> > > +				ISCSI_REASON_BOOKMARK_NO_RESOURCES, buf);
> > 
> > Sending the reject reason implies initiator can resend original PDU,
> > according to https://tools.ietf.org/html/rfc7143#section-11.17.1
> > 
> > Is it intended, i.e. do we want the retry?
> 
> Hi Roman,
> 
> The two new iscsit_add_reject_cmd() can only be triggered if the initiator
> sends one or more iSCSI PDUs after the logout PDU. I think that's a
> violation of the iSCSI protocol. Anyway, how about changing the reject
> reason into ISCSI_REASON_PROTOCOL_ERROR?
> 
> Thanks,
> 
> Bart.
> 

Thanks for the context, would reason code "Waiting for Logout" (0x0c) be
suffice for the case as documented in 11.9.1. AsyncEvent
(https://tools.ietf.org/html/rfc7143#section-11.9.1):

        1 (Logout Request) - the target requests Logout.  This Async
          Message MUST be sent on the same connection as the one
          requesting to be logged out.  The initiator MUST honor this
          request by issuing a Logout as early as possible but no later
          than Parameter3 seconds.  The initiator MUST send a Logout
          with a reason code of "close the connection" OR "close the
          session" to close all the connections.  Once this message is
          received, the initiator SHOULD NOT issue new iSCSI commands on
          the connection to be logged out.  The target MAY reject any
          new I/O requests that it receives after this message with the
          reason code "Waiting for Logout". If the initiator does not
          log out in Parameter3 seconds, the target should send an Async
          PDU with iSCSI event code "Dropped the connection" if possible
          or simply terminate the transport connection.  Parameter1 and
          Parameter2 are reserved.


--
Roman
