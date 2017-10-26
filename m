From: Mike Christie <mchristi@redhat.com>
Date: Thu, 26 Oct 2017 05:30:59 +0000
Subject: Re: [PATCH 17/17] tcmu: allow max block and global max blocks to besettable
Message-Id: <59F17313.9090803@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1508310852-15366-18-git-send-email-mchristi@redhat.com>
In-Reply-To: <1508310852-15366-18-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 10/25/2017 08:03 PM, Xiubo Li wrote:
>>
>>> For now I'm using the targetcli tool by just adding ',' support in
>>> configshell, and test this patch works well.
>>>
>> Thanks. I will do a PR for configshell if you do not beat me to it.
>>
> Yeah go ahead and i will test it for you.

Here is a patch for targetcli:

https://github.com/open-iscsi/targetcli-fb/pull/95

There is also a updated rtslib patch:

https://github.com/open-iscsi/rtslib-fb/pull/112
