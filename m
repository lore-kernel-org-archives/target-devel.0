From: Mike Christie <mchristi@redhat.com>
Date: Mon, 13 Aug 2018 21:42:31 +0000
Subject: Re: BUG in slab_free after iSCSI login timeout
Message-Id: <5B71FB47.5030208@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180811093655.42922d8e@gmail.com>
In-Reply-To: <20180811093655.42922d8e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 08/13/2018 02:48 PM, Mike Christie wrote:
> On 08/11/2018 10:51 PM, Vincent Pelletier wrote:
>> On Sun, 12 Aug 2018 02:55:31 +0000, Vincent Pelletier
>> <plr.vincent@gmail.com> wrote:
>>> Aug 12 04:44:53 boke kernel: [   64.737069] BUG: KASAN: use-after-free in iscsi_target_login_sess_out.cold.11+0x58/0x123 [iscsi_target_mod]
>>> Aug 12 04:44:53 boke kernel: [   64.771148] BUG: KASAN: double-free or invalid-free in iscsi_target_login_sess_out.cold.11+0x103/0x123 [iscsi_target_mod]
>>
>> If I'm reading the code correctly, the double-free would be
>> iscsi_login_init_conn and iscsi_target_login_sess_out both calling
>> kfree(conn->conn_ops), with the latter called by
>> __iscsi_target_login_thread precisely when the former fails (returns
>> NULL after freeing).
>>
> 
> I think I fixed that with this patch:
> 
> https://www.spinics.net/lists/target-devel/msg17018.html
> 
> It fixes a mix of problems double free of the ops, session and reference
> after free.

Ignore this. I see you said conn. My patch fixed basically the same
issue but with the session.
