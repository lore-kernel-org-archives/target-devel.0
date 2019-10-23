From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 23 Oct 2019 02:30:24 +0000
Subject: Re: [bug report] target/cxgbit: Fix endianness annotations
Message-Id: <2cf646a5-3853-b07d-9b02-c0e5dbb9a91d@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20191014115025.GA9350@mwanda>
In-Reply-To: <20191014115025.GA9350@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 2019-10-22 19:05, Martin K. Petersen wrote:
> 
> Bart?
> 
>> This is a semi-automatic email about new static checker warnings.
>>
>> The patch 5cadafb236df: "target/cxgbit: Fix endianness annotations"
>> from Jan 13, 2017, leads to the following Smatch complaint:
>>
>>     drivers/target/iscsi/cxgbit/cxgbit_cm.c:1836 cxgbit_fw4_ack()
>>     warn: variable dereferenced before check 'p' (see line 1834)
>>

Hi Martin,

Thanks for the reminder - Dan's email had escaped from my attention. I
will submit a patch.

Bart.
