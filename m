From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 13 Nov 2019 17:07:41 +0000
Subject: Re: [PATCH 3/3] target/iscsi: Wait for all commands to finish before freeing a session
Message-Id: <04168d9b-bd0e-0fb0-1977-8671ab9db282@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20191112035752.8338-4-bvanassche@acm.org>
In-Reply-To: <20191112035752.8338-4-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 11/13/19 5:42 AM, Roman Bolshakov wrote:
> On Mon, Nov 11, 2019 at 07:57:52PM -0800, Bart Van Assche wrote:
>> -	target_get_sess_cmd(&cmd->se_cmd, true);
>> +	if (target_get_sess_cmd(&cmd->se_cmd, true) < 0)
>> +		return iscsit_add_reject_cmd(cmd,
>> +				ISCSI_REASON_BOOKMARK_NO_RESOURCES, buf);
> 
> Sending the reject reason implies initiator can resend original PDU,
> according to https://tools.ietf.org/html/rfc7143#section-11.17.1
> 
> Is it intended, i.e. do we want the retry?

Hi Roman,

The two new iscsit_add_reject_cmd() can only be triggered if the 
initiator sends one or more iSCSI PDUs after the logout PDU. I think 
that's a violation of the iSCSI protocol. Anyway, how about changing the 
reject reason into ISCSI_REASON_PROTOCOL_ERROR?

Thanks,

Bart.
