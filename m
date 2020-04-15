From: Mike Christie <mchristi@redhat.com>
Date: Wed, 15 Apr 2020 17:35:25 +0000
Subject: Re: [RFC PATCH 2/5] target: add sysfs session helper functions
Message-Id: <5E9745DD.2060009@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200414051514.7296-1-mchristi@redhat.com>
 <20200414051514.7296-3-mchristi@redhat.com>
 <20ecaf0e-698c-fb9c-26fd-a1f2dc79392e@acm.org>
In-Reply-To: <20ecaf0e-698c-fb9c-26fd-a1f2dc79392e@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>, jsmart2021@gmail.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org

On 04/14/2020 09:30 PM, Bart Van Assche wrote:
> On 2020-04-13 22:15, Mike Christie wrote:
>> @@ -537,8 +538,15 @@ void transport_deregister_session_configfs(struct se_session *se_sess)
>>  }
>>  EXPORT_SYMBOL(transport_deregister_session_configfs);
>>  
>> +
> 
> A single blank line is probably sufficient here?
> 

Yes. That was a cut and paste mistake when I was separating the code
into patches. Will fix.


>>  void transport_free_session(struct se_session *se_sess)
>>  {
>> +	kobject_put(&se_sess->kobj);
>> +}
>> +EXPORT_SYMBOL(transport_free_session);
>> +
>> +void __target_free_session(struct se_session *se_sess)
>> +{
>>  	struct se_node_acl *se_nacl = se_sess->se_node_acl;
>>  
>>  	/*
>> @@ -582,7 +590,6 @@ void transport_free_session(struct se_session *se_sess)
>>  	percpu_ref_exit(&se_sess->cmd_count);
>>  	kmem_cache_free(se_sess_cache, se_sess);
>>  }
>> -EXPORT_SYMBOL(transport_free_session);
> 
> Does this patch defer execution of the code inside
> transport_free_session() from when transport_free_session() is called to
> when the last reference to a session is dropped? Can that have

Yes.

> unintended side effects? How about keeping most of the code that occurs

Yes. For example, we drop the refcount on the ACL in
__target_free_session so that is now not done until the last session
rerfcount is done. I did this because we reference the acl in a sysfs file.


> in transport_free_session() in that function and only freeing the memory
> associated with the session if the last reference is dropped?
> 

I tried to minimize it already.

That is why I have the new session->fabric_free_cb in the next patch.
That way we do not need refcounts on structs like the tpg and can detach
that like normal in
transport_deregister_session/transport_deregister_session_configfs.

I will double check about what I can do about the ACL ref. We can do
things like copy the acl's name to the session, so we do not have to
reference the acl in sysfs.



> Thanks,
> 
> Bart.
> 
