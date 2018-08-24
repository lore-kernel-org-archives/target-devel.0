From: Mike Christie <mchristi@redhat.com>
Date: Fri, 24 Aug 2018 16:46:45 +0000
Subject: Re: [PATCHv2] iscsi target: Set conn->sess to NULL when iscsi_login_set_conn_values fails
Message-Id: <5B803675.8030902@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <832b92dcf4838101e944f1394de570642a16faac.1534372918.git.plr.vincent@gmail.com>
In-Reply-To: <832b92dcf4838101e944f1394de570642a16faac.1534372918.git.plr.vincent@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 08/23/2018 09:11 PM, Martin K. Petersen wrote:
> 
> Mike,
> 
>> this was made over that patch that was going through Mathew's tree. I
>> do not know exactly which one though. It is in next here
> 
> Doesn't look like Linus will pull Matthew's tree for 4.19.
>

It looks like there is also going to be a conflict with another patch
upstream. I will just round up all the patches and resend in one set
rebased against your current for-4.19 tree.
