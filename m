From: Mike Christie <mchristi@redhat.com>
Date: Mon, 23 Apr 2018 17:04:16 +0000
Subject: Re: Requirements for tcmu-runner on CentOS 7.4
Message-Id: <5ADE1210.7060302@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <CALtL6BefZxCFDU284iho5ZQvnHiJ2vY44cfYB9jhtvfC4i9=Yg@mail.gmail.com>
In-Reply-To: <CALtL6BefZxCFDU284iho5ZQvnHiJ2vY44cfYB9jhtvfC4i9=Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 04/22/2018 01:43 PM, Raghuram Devarakonda wrote:
> Hi,
> 
> I am developing a tcmu-runner plugin that would run on CentOS 7.4. The
> kernel version on my test CentOS box shows up as
> "3.10.0-693.17.1.el7.x86_64" which might be too old from what I have
> been reading. Are there any recommendations on the minimum version for
> kernel as well as tcmu-runner? Also, I see targetcli's version as

The RHEL 7.5 kernel is probably best to use. We did a rebase of LIO so
there are lots of bug fixes.

> "2.1.fb46" and I do see my plugin show up in the backstores. Is this
> version sufficient or do I need to use a different one?
> 

Are these the versions installed by Centos?

I think it is best to use the upstream releases:

https://github.com/open-iscsi/rtslib-fb/releases
https://github.com/open-iscsi/targetcli-fb/releases

because upstream has been moving quickly and the rhel/centos runner
support for rtslib/targetcli has not been.
