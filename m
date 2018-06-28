From: Mike Christie <mchristi@redhat.com>
Date: Thu, 28 Jun 2018 19:34:38 +0000
Subject: Re: [PATCH v3] target: add emulate_pr backstore attr to toggle PR support
Message-Id: <5B35384E.7030001@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180625185658.31141-1-ddiss@suse.de>
In-Reply-To: <20180625185658.31141-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 06/28/2018 09:48 AM, David Disseldorp wrote:
> On Wed, 27 Jun 2018 13:22:27 -0500, Mike Christie wrote:
> 
>>> So I'd like to propose the following:
>>> 1) Have an attribute to switch between normal mode (pr_support active)
>>>    and new mode (pr_support inactive).
>>> Whether this is done via the existing pr_support attribute or via
>>>    a new attribute is a question of flavor.
>>> 2) If pr_support is inactive, spc_parse_cdb() would reject PR CDBs
>>>    while passthrough_parse_cdb() would pass through those CDBs to
>>>    userspace.
>>> 3) In the "pr_support inactive" mode for devices using
>>> passthrough_parse_cdb() the transport_flag
>>> TRANSPORT_FLAG_PASSTHROUGH_PGR would be set. For devices using
>>>    spc_parse_cdb() a new flag like TRANSPORT_FLAG_REJECT_PGR should be
>>>    used. (See details below regarding dev specific transport_flags.)  
>>
>> I am not sure I got this. How do apps like targetcli that manage tcmu
>> with rtslib tell the tcmu userspace daemon if it should reject PGRs? I
>> think you need 2 device attributes or 1 with a 3rd state:
>>
>> 1. emulate_pr - Controls whether PGRs are executed or failed. Does not
>> matter if in kernel or userspace.
>> 2. pgr_support - Controls if PGRs are executed in the LIO PGR layer in
>> kernel or passed to the backend driver (up to userspace for tcmu or to
>> the physical device for pscsi).
>>
>> So with tcmu and {emulate_pr=0 pgr_support=0} would be pass to userspace
>> and fail PGRs.
> 
> So how should we proceed here? Separate emulate_pr and pgr_support
> interfaces would imply that this change could go in as-is, while a
> multi-state interface would probably require more thought.
> 

I think separate is going to be easier. There is a bug in the
pgr/alua_support files that is going to add a complication we probably
want to limit to that file. The problem is that:

pgr/alua_support=0 means always pass pgr/alua commands to the backend
and do not allow configfs support for operations related to those commands.

For *_support=1 it is mess.

pgr_support = 1 means allow configfs pgr operations and execute pgr
commands in the LIO pgr layer.

alua_support = 1 means allow configfs operations like pgr_support=1
However, for tcmu it means pass alua commands to userspace but for
backends like iblock/file it means execute alua commands in the LIO alua
layer.

We can fix the TRANSPORT_FLAG_PASSTHROUGH_* bits in the kernel so the
names match the behavior they support in the kernel. The problem with
the configfs files is that they are exported to apps already.

If we do multiple files then emulate_pr is very clear what is meant
across all backends and works like other device attributes.
