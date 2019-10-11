From: Mike Christie <mchristi@redhat.com>
Date: Fri, 11 Oct 2019 19:38:12 +0000
Subject: Re: Wrong resetting of Logical Unit Number field in CDB
Message-Id: <5DA0DA24.3080707@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <ac680e032540400a8cd7b1bf03361df3@R01UKEXCASM125.r01.fujitsu.local>
In-Reply-To: <ac680e032540400a8cd7b1bf03361df3@R01UKEXCASM125.r01.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 10/11/2019 12:13 PM, Bart Van Assche wrote:
> On 10/11/19 3:12 AM, Bodo Stroesser wrote:
>> If I understood correctly, we all would prefer to make TCMU completely
>> transparent regarding the CDB.
>>
>> For pscsi I think we all agree, that the code is wrong or incomplete.
>> But for pscsi up to now no one complained. So I'm wondering whether we
>> should spend much effort for pscsi to discuss / find out the right
>> solution? Especially as the original comment in the code, as posted by
>> Mike, as well as the current comment are not very clear. Thus 'fixing'
>> pscsi would mean to change or remove something we don't understand
>> completely.
>>
>> So I agree to Hannes: we should simply move that code from
>> passthrough_parse_cdb() to pscsi_parse_cdb(), at least as a first step.
> 
> Hannes wrote "[ ... ] delegate it to pscsi if there is a need." Is there
> really a need for such code in the SCSI passthrough driver? The upstream
> SCSI target code is one of the four Linux SCSI target stacks that I know
> of. I haven't found any SCSI-2 LUN number filtering code in the tgt
> project (http://stgt.sourceforge.net/). I'm not sure about IET. SCST is
> around since 2006 and has SCSI-2 LUN number filtering code in its CDROM
> and MODISK passthrough drivers. That LUN number filtering code is there
> since the initial commit so it is not the result of a recent request of
> a user. SCST does not have LUN filtering code in its disk passthrough
> driver nor in its tape passthrough driver. In other words, I do not
> expect that anyone's setup will be broken by removing
> passthrough_parse_cdb() entirely.

I originally thought it was for a really specific case Nick hit a long
time ago because the code is so odd. However, the original code's
comment sounds like Nick might have read the specs incorrectly or was
working off a older iscsi rfc draft. I think this happened in some
persistent reservation code that is wrong too.

I think if the code it was for a specific initiator then he would have
added that in the code comments. For example for a while we had a really
specific comment about the mac os initiator or qlogic on windows or
something, and there is still a comment about solaris. If on the other
hand it was a spec thing then it seems he writes the scsi spec name like
he did in the original comment.
