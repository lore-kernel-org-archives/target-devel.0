From: Mike Christie <mchristi@redhat.com>
Date: Thu, 19 Jul 2018 01:02:03 +0000
Subject: Re: [PATCH 02/15] target: fix isid copying and comparision
Message-Id: <5B4FE30B.5040602@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-3-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-3-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 07/18/2018 07:03 PM, Mike Christie wrote:
> On 07/18/2018 05:09 PM, Bart Van Assche wrote:
>> On Sun, 2018-07-15 at 18:16 -0500, Mike Christie wrote:
>>> The isid is 48 bits, and in hex string format it's 12 bytes.
>>> We are currently copying the 12 byte hex string to a u64
>>> so we can easily compare it, but this has the problem that
>>> only 8 bytes of the 12 bytes are copied.
>>>
>>> The next patches will want to print se_session sess_bin_isid
>>> so this has us use hex2bin to when converting from the hex
>>> sting to the bin value.
>>   ^^^^^
>>   string?
>>
>> Which spec defines that an ISID is 48 bits? All I know about SCSI registrations
> 
> The iscsi spec defines it as 48 bits.
> 
>> is that these involve a transport ID and that that transport ID can be up to 228
>> bytes long for iSCSI.
> 
> I am talking about the Initiator Session ID above. That along with the
> iscsi name make up the Initiator Port Transport ID. In spc4r37 checkout
> table 508 or in SAM 5r21 checkout table A.4.
> 
> So in the SCSI specs as part of the Initiator Port Transport ID we have
> this from that SAM table:
> 
> The Initiator Session Identifier (ISID) portion of the string is a UTF-8
> encoded hexadecimal representation of a six byte binary value.
> 
> ---
> 
> In the PR parts of SPC it sometimes mentions only "Transport ID" but
> then clarifies the initiator port so I am assuming in those cases it
> means "Initiator Port Transport ID" so it is both the name and isid for
> iscsi.

It looks like we are supposed to go by what the initiator specifies in
the TPID field, so it can be either the Transport ID or Initiator Port
Transport ID.
