From: Zhu Lingshan <lingshan.zhu@linux.intel.com>
Date: Wed, 15 Jan 2020 09:26:35 +0000
Subject: Re: Cannot log in from BIOS to linux target
Message-Id: <bc2b330a-9624-9e21-6a41-7ad7675b1f63@linux.intel.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200113165128.GC4113@kitsune.suse.cz>
In-Reply-To: <20200113165128.GC4113@kitsune.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

Hi Michal,

Why not give a try on Yast2 iscsi target module? It would be easy to 
config your target with it.

Thanks,
BR
Zhu Lingshan

On 1/15/2020 3:07 PM, Hannes Reinecke wrote:
> On 1/15/20 6:15 AM, Zhu Lingshan wrote:
>> Hi Michal,
>>
>> try demo mode for a experiment? Here is a guide
>> http://www.linux-iscsi.org/wiki/ISCSI#Demo_mode
>> you can also find how to config username /password there.
>>
>> Thanks,
>> Zhu Lingshan
>> On 1/14/2020 12:51 AM, Michal Suchánek wrote:
>>> Hello,
>>>
>>> my system BIOS support booting from iSCSI.
>>>
>>> I set up readonly target with no authentication:
>>>
>>> targetcli shell version 2.1.fb49
>>>
>>> grub
>>> ..................................................................
>>> [/scratch/ISO/GRUB (1.8MiB) write-back activated]
>>>     | |   o- alua
>>> .................................................................................................
>>> [ALUA Groups: 1]
>>>     | |     o- default_tg_pt_gp
>>> .....................................................................
>>> [ALUA state: Active/optimized]
>>>
>>>    | | o- tpg1
>>> ................................................................................................
>>> [gen-acls, no-auth]
>>>     | |   |   o- mapped_lun0
>>> ...............................................................................
>>> [lun0 fileio/grub (rw)]
>>> The readonly flag does not seem to be
>>> honored
>>> ^^^
>>>
>>> Anyway, the initiator cannot log in:
>>>
>>> 3,1360,2329588663878,-;Initiator sent zero length security payload,
>>> login failed
>>> 3,1361,2329588663897,-;iSCSI Login negotiation failed.
>>>
>>> How can I export a LUN without a password?
>>>
>>> Thanks
>>>
>>> Michal
> It's actually not the password that's missing, it's the ACL.
> You have registered your iSCSI initiatorname with the target, right?
>
> Cheers,
>
> Hannes
