From: Raghuram Devarakonda <draghuram@gmail.com>
Date: Tue, 17 Apr 2018 14:54:14 +0000
Subject: tcmu-runner info
Message-Id: <CALtL6BdjcZeqMQFmiLum3HR3MdAZieyBmiFRMYHgLzd22RmD5g@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

I am working on a plugin based on tcmu-runner and would appreciate
some help. I took the sample file plugin (file_example.c) and modified
it. In my testing, I noticed that reads/writes to the TCMU device hang
and in all these cases, tcmu-runner daemon crashed. I understand that
the crashes are most probably due to the code I added but I am
wondering if there is any way to prevent the hang. For example, is
there a timeout in lio that would eventually fails the reads and
writes?

More over, any help in debugging crashes would also be greatly
appreciated. It would be great if someone can share any pointers in
working with tcmu-runner in general.

Thanks for the help,
Raghu

PS. I hope this is the right mailing list for "tcmu-runner".
