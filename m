From: Xiubo Li <lixiubo@cmss.chinamobile.com>
Date: Thu, 26 Oct 2017 06:51:19 +0000
Subject: Re: [PATCH 17/17] tcmu: allow max block and global max blocks tobesettable
Message-Id: <0e7a76aa-b6bf-eae7-ba19-875e8f1c5365@cmss.chinamobile.com>
List-Id: <target-devel.vger.kernel.org>
References: <1508310852-15366-18-git-send-email-mchristi@redhat.com>
In-Reply-To: <1508310852-15366-18-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org



On 2017年10月26日 13:30, Mike Christie wrote:
> On 10/25/2017 08:03 PM, Xiubo Li wrote:
>>>> For now I'm using the targetcli tool by just adding ',' support in
>>>> configshell, and test this patch works well.
>>>>
>>> Thanks. I will do a PR for configshell if you do not beat me to it.
>>>
>> Yeah go ahead and i will test it for you.
> Here is a patch for targetcli:
>
> https://github.com/open-iscsi/targetcli-fb/pull/95
>
> There is also a updated rtslib patch:
>
> https://github.com/open-iscsi/rtslib-fb/pull/112
Yes, test this and works for me.

/> /backstores/user:file create name=file1 size=1G cfgstring=file1 
max_data_area_mb 48
/> /backstores/user:file/file1/ get attribute max_data_area_mb
max_data_area_mb 48 [ro]

Thanks,
BRs







