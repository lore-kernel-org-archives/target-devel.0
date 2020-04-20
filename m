From: Mike Christie <mchristi@redhat.com>
Date: Mon, 20 Apr 2020 17:43:19 +0000
Subject: Re: [RFC PATCH 2/5] target: add sysfs session helper functions
Message-Id: <5E9DDF37.2020102@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200414051514.7296-1-mchristi@redhat.com>
 <20200414051514.7296-3-mchristi@redhat.com>
 <4416ba8f-5eae-9dfd-7e39-0f91d37d62e3@ts.fujitsu.com>
In-Reply-To: <4416ba8f-5eae-9dfd-7e39-0f91d37d62e3@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>, jsmart2021@gmail.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org

On 04/20/2020 12:39 PM, Bodo Stroesser wrote:
> 
> 
> On 04/14/20 07:15, Mike Christie wrote:
>> +static ssize_t session_acl_show(struct se_session *se_sess, char *page)
>> +{
>> +    struct se_node_acl *acl;
>> +    ssize_t len;
>> +
>> +    acl = se_sess->se_node_acl;
>> +    if (!acl)
>> +        return -ENOTCONN;
>> +
>> +    if (acl->dynamic_node_acl) {
>> +        page[0] = '\0';
>> +        len = 0;
>> +    } else {
>> +        len = snprintf(page, PAGE_SIZE, "%s\n", acl->initiatorname);
>> +    }
>> +
>> +    return len;
>> +}
> 
> Would it be a good idea to provide more info about initiators using
> dynamic acl?
> 
> For example the file could be named "initiatorname" instead of "acl" and

I added this info in another dir/file. I was just about to post a update.

The acl is just a way to reference the configfs dir the info would be
located in since you can symlink.

> always provide the initiatorname, while a boolean file "acl" could
> return "Y" or "1" for explicit acls, but "N" or "0" for dynamic acls.

I was trying to not duplicate what is already in configfs.
