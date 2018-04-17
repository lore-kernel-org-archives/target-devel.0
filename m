From: Raghuram Devarakonda <draghuram@gmail.com>
Date: Tue, 17 Apr 2018 21:07:07 +0000
Subject: Re: tcmu-runner info
Message-Id: <CALtL6BeduiAa80p42nvgVUO0o7zRa5wFSvBVPQUuCGJ65OL+kA@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <CALtL6BdjcZeqMQFmiLum3HR3MdAZieyBmiFRMYHgLzd22RmD5g@mail.gmail.com>
In-Reply-To: <CALtL6BdjcZeqMQFmiLum3HR3MdAZieyBmiFRMYHgLzd22RmD5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Tue, Apr 17, 2018 at 12:43 PM, Mike Christie <mchristi@redhat.com> wrote:
> On 04/17/2018 09:54 AM, Raghuram Devarakonda wrote:
>> I am working on a plugin based on tcmu-runner and would appreciate
>> some help. I took the sample file plugin (file_example.c) and modified
>> it. In my testing, I noticed that reads/writes to the TCMU device hang
>> and in all these cases, tcmu-runner daemon crashed. I understand that
>> the crashes are most probably due to the code I added but I am
>> wondering if there is any way to prevent the hang. For example, is
>> there a timeout in lio that would eventually fails the reads and
>> writes?
>
> Each tcmu device has a cmd_time_out attribute which is 30 seconds by
> default. If we do not get a response within that time out the command
> gets failed.
>
> When runner restarts and when using 4.16, it will fail all out standing
> commands in case you have cmd_time_out disabled.

Thanks for the info. As for 4.16, you are referring to Linux kernel
version. Right? What happens pre-4.16?

Thanks,
Raghu
