From: Mike Christie <mchristi@redhat.com>
Date: Fri, 12 Jan 2018 22:41:34 +0000
Subject: Re: [PATCH 0/5]: Fix target_core_user userspace restarts (v2)
Message-Id: <5A59399E.2060804@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1513677838-6675-1-git-send-email-mchristi@redhat.com>
In-Reply-To: <1513677838-6675-1-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 01/12/2018 04:13 PM, Nicholas A. Bellinger wrote:
> Hey MNC,
> 
> Apologies for the delayed follow up.
> 
> On Tue, 2017-12-19 at 04:03 -0600, Mike Christie wrote:
>> The following patches were made over Linus's tree
>> and my tcmu update here
>>
>> https://www.spinics.net/lists/target-devel/msg16283.html
>>
>> The first patch prevents possible corruption with buggy tcmu userspace
>> apps. The other 4 patches allow tcmu apps to restart themselves while
>> IO is being executed. This is needed for management operations like
>> updating the app and handling crashes.
> 
> Thanks.  The prerequisites where applied earlier this week, including
> patch #1-#3 from this series.
> 
>>
>> The last four patches are an update to this RFC:
>> https://www.spinics.net/lists/target-devel/msg16312.html
>> Since that posting I moved the files being added to a new
>> dir "action" which is used for special files that execute
>> a kernel function that does more than just set a param/attrib
>> that is exported from the same file.
>>
> 
> Was wondering about that..
> 
> Why shouldn't these be added as backend device specific configfs
> attributes, similar to what tcmu does for tcmu_attrib_attrs[]..?


Hey,

The problem is that rtslib assumes attrs are things that the user always
wants to get/set. For example, when you create a device the attrs will
be read and stored in some config file so later when targetcli
restoreconfig is run it will write the stored values thinking they are
the user requested defaults.

The primary purpose of the files being added in these last patches are
to allow userspace to tell the backend module to perform some operation.
For example, when we restart tcmu-runner it is really easy to do if IO
is not being sent to the daemon at the same time. The block file
prevents IO from being sent and the reset file makes sure the ring
(buffer used to pass commands between user/kernel space) is in a good
state (this is needed for the case where runner crashed).

We do not want targetcli writing whatever value it found in these
special files when the device was created because it might for example
leave a device blocked.

I guess the options were:

1. This patch that separates this kind of files and tries to make it
generic.
2. Instead of the generic action dir, I could just make a
target_core_user specific dir.
3. I can modify rtslib with a attr file blacklist, and these special
files can go in it.

I thought #1 or even #2 was nicer, because attrs seemed like they had a
specific purpose to get/set info about an object.
