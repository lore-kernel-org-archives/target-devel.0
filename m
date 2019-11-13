From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 13 Nov 2019 17:55:49 +0000
Subject: Re: [PATCH 3/3] target/iscsi: Wait for all commands to finish before freeing a session
Message-Id: <b7b6a08a-cc45-76ca-5797-d3a6648a4171@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20191112035752.8338-4-bvanassche@acm.org>
In-Reply-To: <20191112035752.8338-4-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 11/13/19 9:29 AM, Roman Bolshakov wrote:
> Thanks for the context, would reason code "Waiting for Logout" (0x0c) be
> suffice for the case as documented in 11.9.1. AsyncEvent
> (https://tools.ietf.org/html/rfc7143#section-11.9.1):
> 
>          1 (Logout Request) - the target requests Logout.  This Async
>            Message MUST be sent on the same connection as the one
>            requesting to be logged out.  The initiator MUST honor this
>            request by issuing a Logout as early as possible but no later
>            than Parameter3 seconds.  The initiator MUST send a Logout
>            with a reason code of "close the connection" OR "close the
>            session" to close all the connections.  Once this message is
>            received, the initiator SHOULD NOT issue new iSCSI commands on
>            the connection to be logged out.  The target MAY reject any
>            new I/O requests that it receives after this message with the
>            reason code "Waiting for Logout". If the initiator does not
>            log out in Parameter3 seconds, the target should send an Async
>            PDU with iSCSI event code "Dropped the connection" if possible
>            or simply terminate the transport connection.  Parameter1 and
>            Parameter2 are reserved.

That sounds like a good idea to me. Please have a look at version three 
of this patch series. That version uses reason code 0x0c.

Thanks,

Bart.
