From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 11 Nov 2019 19:12:55 +0000
Subject: Re: [PATCH 0/2] Improve SPC-2 reservation support
Message-Id: <13791d8a-6600-a388-2330-9fb2e6689104@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20191111182944.191123-1-bvanassche@acm.org>
In-Reply-To: <20191111182944.191123-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 11/11/19 10:58 AM, Roman Bolshakov wrote:
> On Mon, Nov 11, 2019 at 10:29:42AM -0800, Bart Van Assche wrote:
>> Hi Martin,
>>
>> This patch series improves support for SPC-2 reservations in the SCSI target
>> code. Please consider these patches for inclusion in the v5.5 kernel.
>>
>> Thanks,
>>
>> Bart.
>>
>> Bart Van Assche (2):
>>    target/core: Declare target_release_reservation() 'static'
>>    target/iscsi: Fix a use-after-free while closing a session
>>
>>   drivers/target/target_core_pr.c        |  2 +-
>>   drivers/target/target_core_pr.h        |  1 -
>>   drivers/target/target_core_transport.c | 11 +++++++++++
>>   3 files changed, 12 insertions(+), 2 deletions(-)
> 
> I have missed the second patch, who was it send to?

Hi Roman,

That second patch has also been sent to the target-devel mailing list. 
On the following web page I can see that it has not yet been sent out by 
the mailing list server: https://www.spinics.net/lists/target-devel/. If 
that second patch does not appear on the target-devel mailing list by 
tomorrow I will resend it.

Bart.
