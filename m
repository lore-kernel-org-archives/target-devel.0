From: Hou Pu <houpu@bytedance.com>
Date: Wed, 29 Apr 2020 06:59:10 +0000
Subject: Re: [PATCH v3 1/2] iscsi-target: fix login error when receiving is too fast
Message-Id: <bdaaa620-ff31-baee-9a3e-d6eeccc160a9@bytedance.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200424123528.17627-1-houpu@bytedance.com>
 <20200424123528.17627-2-houpu@bytedance.com>
 <cee3c624-4d43-fd4c-1436-cfc0c08a4321@redhat.com>
 <8f3b123e-1dc3-54ba-ae6d-90e76e5702b5@redhat.com>
 <44a02338-0923-5b57-ed26-8528bf9cde70@bytedance.com>
 <ef4dce23-dca8-c75a-0e18-c4bb49fe503a@bytedance.com>
 <f8e06fd6-d2d5-b237-7d32-86ee3277e85f@redhat.com>
In-Reply-To: <f8e06fd6-d2d5-b237-7d32-86ee3277e85f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <mchristi@redhat.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org



On 2020/4/29 1:50 上午, Mike Christie wrote:
> On 4/26/20 1:09 AM, Hou Pu wrote:
>>
>>>>>> +     */
>>>>>> +    if (conn->sock) {
>>>>>> +        struct sock *sk = conn->sock->sk;
>>>>>> +
>>>>>> +        write_lock_bh(&sk->sk_callback_lock);
>>>>>> +        clear_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags);
>>>>>> +        set_bit(LOGIN_FLAGS_WRITE_ACTIVE, &conn->login_flags);
>>>>>> +        write_unlock_bh(&sk->sk_callback_lock);
>>>>>> +    }
>>>>>> +
>>>>> Hey,
>>>>>
>>>>> I had one more question.
>>>>>
>>>>> With the above code, I think we have a race where if we clear the bit
>>>>> above early and iscsi_target_sk_data_ready runs while
>>>>> iscsi_target_do_login_rx is still running then we could queue the work
>>>>> an extra time and get stuck. Because the bit is now not set, if
>>>>> iscsi_target_sk_data_ready runs it will end up calling
>>>>> schedule_delayed_work which will queue up the work again since the work
>>>>> is running and not pending.
>>>
>>> Yes. I was trying to allow queuing the delayed work early.
>>>
>>>>>
>>>>> If that is correct and we hit the race what happens if this was the
>>>>> last
>>>>> login pdu, and we are supposed to go to full feature phase next? For
>>>>> example if iscsi_target_do_login_rx runs an extra time, will we end up
>>>>> stuck waiting in iscsi_target_do_login_rx's call to:
>>>>>
>>>>> rc = conn->conn_transport->iscsit_get_login_rx(conn, login);
>>>>>
>>>>> ?
>>>
>>> For the last login pdu, we may have race as you said. thanks for
>>> pointing it out.
>>>
>>> I was trying to image a case where we can hit the race, normally it is
>>> case a).
>>>
>>> a). initiator send last login pdu -> target received -> target replied
>>>
>>> b). initiator send last login pdu -> target received -> initiator send
>>> something -> target replied
>>>
>>> in case b). we will queue another delayed work which we should not.
>>> After the target replied
>>>
>>> the last login pdu, conn->conn_login is freed. we might visited it in
>>> the delayed wo>>
>>>
>>>> Just answering my own question. It looks like we do not get stuck. But
>>>> we either get nothing on the session so the login timeout fires and we
>>>> drop the session. Or, we get a PDU and the login thread reads it in
>>>> before the normal rx thread does, but it assumes it is a login related
>>>> and we most likely drop the session due to invalid fields.
>>>>
>>>> I think in iscsi_target_restore_sock_callbacks we want to do a:
>>>>
>>>> cancel_delayed_work(&conn->login_work)
>>>>
>>>> after we reset the callbacks and drop the sk_callback_lock lock.
>>>
>>> I am not very sure if we could or if it is good to cancel_delayed_work
>>> from the work itself.
>>>
>>> If it is ok then i am ok with it. Or in another way, I think we could
>>> just clear
>>>
>>> LOGIN_FLAGS_READ_ACTIVE and set LOGIN_FLAGS_WRITE_ACTIVE
>>>
>>> after iscsi_target_restore_sock_callbacks when finish process last
>>> login pdu.
>>
>> That would look like (in iscsi_target_do_tx_login_io):
>>
>> diff --git a/drivers/target/iscsi/iscsi_target_nego.c
>> b/drivers/target/iscsi/iscsi_target_nego.c
>> index 685d771b51d4..4d0658731382 100644
>> --- a/drivers/target/iscsi/iscsi_target_nego.c
>> +++ b/drivers/target/iscsi/iscsi_target_nego.c
>> @@ -328,6 +328,28 @@ static int iscsi_target_do_tx_login_io(struct
>> iscsi_conn *conn, struct iscsi_log
>>          u32 padding = 0;
>>          struct iscsi_login_rsp *login_rsp;
>>
>> +       /*
>> +        * LOGIN_FLAGS_READ_ACTIVE is cleared so that sk_data_ready
>> +        * could be trigger again after this.
>> +        *
>> +        * LOGIN_FLAGS_WRITE_ACTIVE is cleared after we successfully
>> +        * process a login pdu, so that sk_state_chage could do login
>> +        * cleanup as needed if the socket is closed. If a delayed work is
>> +        * ongoing (LOGIN_FLAGS_WRITE_ACTIVE or LOGIN_FLAGS_READ_ACTIVE),
>> +        * sk_state_change will leave the cleanup to the delayed work or
>> +        * it will schedule a delayed work to do cleanup.
>> +        */
>> +       if (conn->sock) {
>> +               struct sock *sk = conn->sock->sk;
>> +
>> +               write_lock_bh(&sk->sk_callback_lock);
>> +               if (!test_bit(LOGIN_FLAGS_INITIAL_PDU,
>> &conn->login_flags)) {
>> +                       clear_bit(LOGIN_FLAGS_READ_ACTIVE,
>> &conn->login_flags);
>> +                       set_bit(LOGIN_FLAGS_WRITE_ACTIVE,
>> &conn->login_flags);
>> +               }
>> +               write_unlock_bh(&sk->sk_callback_lock);
>> +       }
> 
> You lost me. I didn't understand this part. Would you still be doing the
> above bit manipulation in iscsi_target_do_login_rx too?

By moving this chunk here(from iscsi_target_do_login_rx to 
iscsi_target_do_tx_login_io), we have already
restore sock callbacks(like below in iscsi_target_do_login),
So clearing READ_ACTIVE would not cause another delayed
work being scheduled.

So I think we would not have the race you pointed out
for last login pdu.

[code snippet

iscsi_target_do_login()
...
login->login_complete = 1;
iscsi_target_restore_sock_callbacks(conn);
if (iscsi_target_do_tx_login_io(conn,
                           login) < 0)

...
]



> 
> Is the above code then to handle when
> iscsi_target_start_negotiation->iscsi_target_do_login->iscsi_target_do_tx_login_io
> runs?
> 
> I was thinking when you mentioned the final login PDU you were going to
> do something when you detect login->login_complete is true.
> 

Even if we move above chunk here, I realize that we
could still theoretically have problem.

For login pdus which is not initial or last login pdus,
after enable scheduling delayed work by clearing READ_ACTIVE.
It is possible to queue a delayed work. (i.e. a out of order
initiator could send pdus at any time).
In case we received such out of order pdu, we need
to cancel them when we have an error and later
doing the clean up.

I will try to solve this and resend these patches.
Maybe it's better to cancel_delayed_work() in
iscsi_target_do_login_rx.

I might not express myself very clear. Please
see next version of these patch.


> This code is not my expertise area, so I might just not be understanding
> something simple about how it all works.

Your comments make sense and are helpful for me. Thanks.
> 

Thanks,
Hou
