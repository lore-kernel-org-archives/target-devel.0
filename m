From: Mike Christie <mchristi@redhat.com>
Date: Thu, 03 May 2018 15:31:59 +0000
Subject: Re: [PATCHv4 1/3] target/configfs: add module wide action support
Message-Id: <5AEB2B6F.3080206@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1524123964-21347-2-git-send-email-xiubli@redhat.com>
In-Reply-To: <1524123964-21347-2-git-send-email-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 05/02/2018 08:03 PM, Xiubo Li wrote:
> On 2018/5/3 2:27, Mike Christie wrote:
>> On 04/19/2018 02:46 AM, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> For some case we need some module wide configfs to contol some
>>> attributes of the whole transport module.
>> When I suggested to move it module wide I just meant to add another mod
>> param like the global max data area param. I like the approach below
>> though, because rtslib can work similar to how it does for other
>> objects. However for tcmu we will have a mix of types, so I am not sure
>> how you are going to deal with compat. Maybe add a module level attrs
>> attr and add a max data area there that calls the same mod param code.
>> There would still be a kernel where it is not supported though.
> But from currently after the tcmu-runner is crashed the
> target_core_user.ko will still be kept inserted, something like:
> 
> [root@gblock2 ~]# lsmod |grep target
> target_core_pscsi      18799  0
> target_core_file       18217  0
> target_core_iblock     18282  0
> iscsi_target_mod      291661  8
> target_core_user       24557  2
> target_core_mod       340729  18
> target_core_iblock,target_core_pscsi,iscsi_target_mod,target_core_file,target_core_user
> 
> uio                    19259  1 target_core_user
> crc_t10dif             12912  2 target_core_mod,sd_mod
> 
> If make it a mod param, like this issue how could it be work when the
> tcmu-runner is crashed and try to start again?

When you do a module_param_cb it creates a sysfs file in
/sys/module/target_core_user/parameters that you can read/write to like
any other sysfs file.

