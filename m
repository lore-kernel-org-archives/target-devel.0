From: Xiubo Li <xiubli@redhat.com>
Date: Thu, 03 May 2018 00:34:37 +0000
Subject: Re: tcmu-runner rpm
Message-Id: <4f77a64b-afe4-a792-cbf9-0cded5d875d1@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <CALtL6Bd12N8BOU2+DZh-b8g0GF=hVoMANyVpvMTk-uE+ZGDpMQ@mail.gmail.com>
In-Reply-To: <CALtL6Bd12N8BOU2+DZh-b8g0GF=hVoMANyVpvMTk-uE+ZGDpMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 2018/5/2 22:00, Raghuram Devarakonda wrote:
> I couldn't open github issue right away as I wasn't sure whether this
> was a genuine problem or something to do with my environment.
>
> And the README of tcmu-runner clearly mentions this list for
> discussion so I posted it here. Is it ok if I continue to post here
> about tcmu-runner?
>
> Thanks any way for the link. That does explain the behavior to some extent.
For discussion only about tcmu-runner project, raising one issue or PR 
via github is a better choice.

If you have any problem or question about the tcmu-runner project, you 
could raise an issue via github. Or something related to the LIO/TCMU 
kernel module here is a better choice.

I think it's up to u.

Thanks,
BRs


> Thanks,
> Raghu
>
>
> On Tue, May 1, 2018 at 5:59 PM, Bryant G. Ly <bryantly@linux.ibm.com> wrote:
>>
>> On 5/1/18 3:34 PM, Raghuram Devarakonda wrote:
>>
>>> It turns out that the presence of "/etc/tcmu/tcmu.conf" on the system
>>> trips up the build process.Once I renamed "/etc/tcmu", I could build
>>> RPM successfully. The contents (listed below) of the file
>>> "./extra/rpmbuild/BUILD/tcmu-runner-1.3.0.54.g6684a21/tcmu.conf_install.cmake"
>>> gave me a clue as to what is going on:
>>>
>>> ----
>>> if (NOT EXISTS "/etc/tcmu/tcmu.conf")
>>>          file(INSTALL
>>> "/root/tcmu-runner-orig/extra/rpmbuild/BUILD/tcmu-runner-1.3.0.54.g6684a21/tcmu.conf"
>>> DESTINATION "/etc/tcmu")
>>> endif()
>>> ----
>>>
>>> I think it should really be checking for this file under the buildroot
>>> rather than in "/" but I may be wrong.
>>>
>>> Thanks,
>>> Raghu
>>>
>>>
>> You should be asking these questions under tcmu-runner github issues....
>>
>> But your problem:
>>
>> https://github.com/open-iscsi/tcmu-runner/issues/320#event-1307345921
>>
>> -Bryant
>>
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


