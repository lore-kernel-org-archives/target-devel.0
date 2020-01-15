From: Hannes Reinecke <hare@suse.de>
Date: Wed, 15 Jan 2020 07:07:59 +0000
Subject: Re: Cannot log in from BIOS to linux target
Message-Id: <9c1d4e16-4cb6-5c78-46b1-f3f88158037d@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20200113165128.GC4113@kitsune.suse.cz>
In-Reply-To: <20200113165128.GC4113@kitsune.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

On 1/15/20 6:15 AM, Zhu Lingshan wrote:
> Hi Michal,
> 
> try demo mode for a experiment? Here is a guide
> http://www.linux-iscsi.org/wiki/ISCSI#Demo_mode
> you can also find how to config username /password there.
> 
> Thanks,
> Zhu Lingshan
> On 1/14/2020 12:51 AM, Michal Suchánek wrote:
>> Hello,
>>
>> my system BIOS support booting from iSCSI.
>>
>> I set up readonly target with no authentication:
>>
>> targetcli shell version 2.1.fb49
>>
>> grub
>> ..................................................................
>> [/scratch/ISO/GRUB (1.8MiB) write-back activated]
>>    | |   o- alua
>> .................................................................................................
>> [ALUA Groups: 1]
>>    | |     o- default_tg_pt_gp
>> .....................................................................
>> [ALUA state: Active/optimized]
>>
>>   | | o- tpg1
>> ................................................................................................
>> [gen-acls, no-auth]
>>    | |   |   o- mapped_lun0
>> ...............................................................................
>> [lun0 fileio/grub (rw)]
>> The readonly flag does not seem to be
>> honored                                                                                
>> ^^^
>>
>> Anyway, the initiator cannot log in:
>>
>> 3,1360,2329588663878,-;Initiator sent zero length security payload,
>> login failed
>> 3,1361,2329588663897,-;iSCSI Login negotiation failed.
>>
>> How can I export a LUN without a password?
>>
>> Thanks
>>
>> Michal

It's actually not the password that's missing, it's the ACL.
You have registered your iSCSI initiatorname with the target, right?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
