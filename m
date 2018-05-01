From: "Bryant G. Ly" <bryantly@linux.ibm.com>
Date: Tue, 01 May 2018 21:59:52 +0000
Subject: Re: tcmu-runner rpm
Message-Id: <02f04fce-37d9-2759-e56c-ce905ddbf092@linux.ibm.com>
List-Id: <target-devel.vger.kernel.org>
References: <CALtL6Bd12N8BOU2+DZh-b8g0GF=hVoMANyVpvMTk-uE+ZGDpMQ@mail.gmail.com>
In-Reply-To: <CALtL6Bd12N8BOU2+DZh-b8g0GF=hVoMANyVpvMTk-uE+ZGDpMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org



On 5/1/18 3:34 PM, Raghuram Devarakonda wrote:

> It turns out that the presence of "/etc/tcmu/tcmu.conf" on the system
> trips up the build process.Once I renamed "/etc/tcmu", I could build
> RPM successfully. The contents (listed below) of the file
> "./extra/rpmbuild/BUILD/tcmu-runner-1.3.0.54.g6684a21/tcmu.conf_install.cmake"
> gave me a clue as to what is going on:
>
> ----
> if (NOT EXISTS "/etc/tcmu/tcmu.conf")
>         file(INSTALL
> "/root/tcmu-runner-orig/extra/rpmbuild/BUILD/tcmu-runner-1.3.0.54.g6684a21/tcmu.conf"
> DESTINATION "/etc/tcmu")
> endif()
> ----
>
> I think it should really be checking for this file under the buildroot
> rather than in "/" but I may be wrong.
>
> Thanks,
> Raghu
>
>
You should be asking these questions under tcmu-runner github issues....

But your problem:

https://github.com/open-iscsi/tcmu-runner/issues/320#event-1307345921

-Bryant

