From: Mike Christie <mchristi@redhat.com>
Date: Thu, 21 Jun 2018 20:04:15 +0000
Subject: Re: [RFC PATCH] target: add emulate_pr backstore attr to toggle PR support
Message-Id: <5B2C04BF.5020603@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180601000532.11058-1-ddiss@suse.de>
In-Reply-To: <20180601000532.11058-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 06/21/2018 10:26 AM, David Disseldorp wrote:
> On Mon, 4 Jun 2018 12:13:22 -0500, Mike Christie wrote:
> 
>>> AFAICT, targetcli (via rtslib-fb) only makes use of the
>>> res_aptpl_metadata path. I'm not aware of any other consumers, so happy
>>> to go with whatever the community preference is here.
>>>   
>>
>> I just seems odd to have a file use 2 different formats for no reason
>> except there were 2 different people coding it.
> 
> It's already a bit inconsistent, in that res_holder_show() returns human
> readable strings and res_type_show() opts for enum type strings. I've
> changed both to use "SPC_RESERVATIONS_DISABLED" for the disabled case
> for now.
> 

I was only asking that we at least have the same format within a file,
so we do not have messes like the backend info file.

