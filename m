From: Mike Christie <mchristi@redhat.com>
Date: Tue, 17 Apr 2018 16:43:40 +0000
Subject: Re: tcmu-runner info
Message-Id: <5AD6243C.9000309@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <CALtL6BdjcZeqMQFmiLum3HR3MdAZieyBmiFRMYHgLzd22RmD5g@mail.gmail.com>
In-Reply-To: <CALtL6BdjcZeqMQFmiLum3HR3MdAZieyBmiFRMYHgLzd22RmD5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 04/17/2018 09:54 AM, Raghuram Devarakonda wrote:
> I am working on a plugin based on tcmu-runner and would appreciate
> some help. I took the sample file plugin (file_example.c) and modified
> it. In my testing, I noticed that reads/writes to the TCMU device hang
> and in all these cases, tcmu-runner daemon crashed. I understand that
> the crashes are most probably due to the code I added but I am
> wondering if there is any way to prevent the hang. For example, is
> there a timeout in lio that would eventually fails the reads and
> writes?

Each tcmu device has a cmd_time_out attribute which is 30 seconds by
default. If we do not get a response within that time out the command
gets failed.

When runner restarts and when using 4.16, it will fail all out standing
commands in case you have cmd_time_out disabled.

> 
> More over, any help in debugging crashes would also be greatly
> appreciated. It would be great if someone can share any pointers in
> working with tcmu-runner in general.
> 
> Thanks for the help,
> Raghu
> 
> PS. I hope this is the right mailing list for "tcmu-runner".
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

