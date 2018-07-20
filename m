From: Mike Christie <mchristi@redhat.com>
Date: Fri, 20 Jul 2018 21:08:21 +0000
Subject: Re: [PATCH 02/15] target: fix isid copying and comparision
Message-Id: <5B524F45.8020200@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-3-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-3-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 07/19/2018 11:13 AM, Mike Christie wrote:
> On 07/19/2018 10:15 AM, Bart Van Assche wrote:
>> On Wed, 2018-07-18 at 20:02 -0500, Mike Christie wrote:
>>> On 07/18/2018 07:03 PM, Mike Christie wrote:
>>>> On 07/18/2018 05:09 PM, Bart Van Assche wrote:
>>>>> [ ... ]
>>>>> is that these involve a transport ID and that that transport ID can be up to 228
>>>>> bytes long for iSCSI.
>>>>
>>>> I am talking about the Initiator Session ID above. That along with the
>>>> iscsi name make up the Initiator Port Transport ID. In spc4r37 checkout
>>>> table 508 or in SAM 5r21 checkout table A.4.
>>>>
>>>> So in the SCSI specs as part of the Initiator Port Transport ID we have
>>>> this from that SAM table:
>>>>
>>>> The Initiator Session Identifier (ISID) portion of the string is a UTF-8
>>>> encoded hexadecimal representation of a six byte binary value.
>>>>
>>>> ---
>>>>
>>>> In the PR parts of SPC it sometimes mentions only "Transport ID" but
>>>> then clarifies the initiator port so I am assuming in those cases it
>>>> means "Initiator Port Transport ID" so it is both the name and isid for
>>>> iscsi.
>>>
>>> It looks like we are supposed to go by what the initiator specifies in
>>> the TPID field, so it can be either the Transport ID or Initiator Port
>>> Transport ID.
>>
>> Hello Mike,
>>
>> Since the ISID is iSCSI-specific I think that all code that knows about the
>> ISID and its encoding should be in the iSCSI target driver instead of the
>> target core. Do you think an approach similar to that of the SCST function
>> iscsi_get_initiator_port_transport_id() can be implemented in LIO? The caller
> 
> Yeah, I can make that work.

Hey Bart and Christoph,

Bart, I noticed we basically had what you are requesting but Christoph
had moved the id code from the fabric drivers to lio core in this commit:

commit 2650d71e244fb3637b5f58a0080682a8bf9c7091
Author: Christoph Hellwig <hch@lst.de>
Date: Fri May 1 17:47:58 2015 +0200

target: move transport ID handling to the core


So what do you guys want to do here? Revert Christoph's patch and go
back to that style or have lio core do the transport ID processing?


> 
>> of that function is in source file scst/src/scst_targ.c:
>>
>> 		res = sess->tgt->tgtt->get_initiator_port_transport_id(
>> 					sess->tgt, sess, &sess->transport_id);
>>
>> Thanks,
>>
>> Bart.--
>> To unsubscribe from this list: send the line "unsubscribe target-devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

