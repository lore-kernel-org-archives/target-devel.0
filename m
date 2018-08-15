From: Mike Christie <mchristi@redhat.com>
Date: Wed, 15 Aug 2018 20:30:18 +0000
Subject: Re: iscsi target: Set conn->sess to NULL when iscsi_login_set_conn_values fails
Message-Id: <5B748D5A.7000402@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <009ea1a88311492e651c38ae946f785961a7e1a7.1534328354.git.plr.vincent@gmail.com>
In-Reply-To: <009ea1a88311492e651c38ae946f785961a7e1a7.1534328354.git.plr.vincent@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 08/15/2018 10:59 AM, Mike Christie wrote:
> On 08/15/2018 05:19 AM, Vincent Pelletier wrote:
>> Fixes a use-after-free reported by KASAN when later
>> iscsi_target_login_sess_out gets called and it tries to access
>> conn->sess->se_sess:
>>
>> Disabling lock debugging due to kernel taint
>> iSCSI Login timeout on Network Portal [::]:3260
>> iSCSI Login negotiation failed.
>> =================================
>> BUG: KASAN: use-after-free in iscsi_target_login_sess_out.cold.12+0x58/0xff [iscsi_target_mod]
>> Read of size 8 at addr ffff880109d070c8 by task iscsi_np/980
>>
>> CPU: 1 PID: 980 Comm: iscsi_np Tainted: G           O      4.17.8kasan.sess.connops+ #4
>> Hardware name: To be filled by O.E.M. To be filled by O.E.M./Aptio CRB, BIOS 5.6.5 05/19/2014
>> Call Trace:
>>  dump_stack+0x71/0xac
>>  print_address_description+0x65/0x22e
>>  ? iscsi_target_login_sess_out.cold.12+0x58/0xff [iscsi_target_mod]
>>  kasan_report.cold.6+0x241/0x2fd
>>  iscsi_target_login_sess_out.cold.12+0x58/0xff [iscsi_target_mod]
>>  iscsi_target_login_thread+0x1086/0x1710 [iscsi_target_mod]
>>  ? __sched_text_start+0x8/0x8
>>  ? iscsi_target_login_sess_out+0x250/0x250 [iscsi_target_mod]
>>  ? __kthread_parkme+0xcc/0x100
>>  ? parse_args.cold.14+0xd3/0xd3
>>  ? iscsi_target_login_sess_out+0x250/0x250 [iscsi_target_mod]
>>  kthread+0x1a0/0x1c0
>>  ? kthread_bind+0x30/0x30
>>  ret_from_fork+0x35/0x40
>>
>> Allocated by task 980:
>>  kasan_kmalloc+0xbf/0xe0
>>  kmem_cache_alloc_trace+0x112/0x210
>>  iscsi_target_login_thread+0x816/0x1710 [iscsi_target_mod]
>>  kthread+0x1a0/0x1c0
>>  ret_from_fork+0x35/0x40
>>
>> Freed by task 980:
>>  __kasan_slab_free+0x125/0x170
>>  kfree+0x90/0x1d0
>>  iscsi_target_login_thread+0x1577/0x1710 [iscsi_target_mod]
>>  kthread+0x1a0/0x1c0
>>  ret_from_fork+0x35/0x40
>>
>> The buggy address belongs to the object at ffff880109d06f00
>>  which belongs to the cache kmalloc-512 of size 512
>> The buggy address is located 456 bytes inside of
>>  512-byte region [ffff880109d06f00, ffff880109d07100)
>> The buggy address belongs to the page:
>> page:ffffea0004274180 count:1 mapcount:0 mapping:0000000000000000 index:0x0 compound_mapcount: 0
>> flags: 0x17fffc000008100(slab|head)
>> raw: 017fffc000008100 0000000000000000 0000000000000000 00000001000c000c
>> raw: dead000000000100 dead000000000200 ffff88011b002e00 0000000000000000
>> page dumped because: kasan: bad access detected
>>
>> Memory state around the buggy address:
>>  ffff880109d06f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>  ffff880109d07000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>> ffff880109d07080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>                                               ^
>>  ffff880109d07100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>  ffff880109d07180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> =================================
>>
>> Signed-off-by: Vincent Pelletier <plr.vincent@gmail.com>
>> ---
>>  drivers/target/iscsi/iscsi_target_login.c | 9 ++++-----
>>  1 file changed, 4 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
>> index df81b2f7cad9..c95f4261a089 100644
>> --- a/drivers/target/iscsi/iscsi_target_login.c
>> +++ b/drivers/target/iscsi/iscsi_target_login.c
>> @@ -296,10 +296,8 @@ static int iscsi_login_zero_tsih_s1(
>>  	}
>>  
>>  	ret = iscsi_login_set_conn_values(sess, conn, pdu->cid);
>> -	if (unlikely(ret)) {
>> -		kfree(sess);
>> -		return ret;
>> -	}
>> +	if (unlikely(ret))
>> +		goto free_sess;
>>  	sess->init_task_tag	= pdu->itt;
>>  	memcpy(&sess->isid, pdu->isid, 6);
>>  	sess->exp_cmd_sn	= be32_to_cpu(pdu->cmdsn);
>> @@ -333,6 +331,7 @@ static int iscsi_login_zero_tsih_s1(
>>  		pr_err("idr_alloc() for sess_idr failed\n");
>>  		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
>>  				ISCSI_LOGIN_STATUS_NO_RESOURCES);
>> +		ret = -ENOMEM;

Sorry to cause more confusion. I misunderstood what you were saying in
the other mails.

Here, I think it will be ok to not set ret.

>>  		goto free_sess;
>>  	}

But, you need to set ret = -ENOMEM in the goto remove_idr and goto
free_ops paths below the above chunk, because ret will be set to >= 0 at
those points and the caller checks for ret < 0.

>>  
>> @@ -370,7 +369,7 @@ static int iscsi_login_zero_tsih_s1(
>>  free_sess:
>>  	kfree(sess);
>>  	conn->sess = NULL;
>> -	return -ENOMEM;
>> +	return ret;
>>  }
>>  
>>  static int iscsi_login_zero_tsih_s2(
>>
> 
> Reviewed-by: Mike Christie <mchristi@redhat.com>
> 

Please drop that reviewed-by.
