From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Fri, 12 Jan 2018 22:13:05 +0000
Subject: Re: [PATCH 0/5]: Fix target_core_user userspace restarts (v2)
Message-Id: <1515795185.21541.2.camel@haakon3.daterainc.com>
List-Id: <target-devel.vger.kernel.org>
References: <1513677838-6675-1-git-send-email-mchristi@redhat.com>
In-Reply-To: <1513677838-6675-1-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hey MNC,

Apologies for the delayed follow up.

On Tue, 2017-12-19 at 04:03 -0600, Mike Christie wrote:
> The following patches were made over Linus's tree
> and my tcmu update here
> 
> https://www.spinics.net/lists/target-devel/msg16283.html
> 
> The first patch prevents possible corruption with buggy tcmu userspace
> apps. The other 4 patches allow tcmu apps to restart themselves while
> IO is being executed. This is needed for management operations like
> updating the app and handling crashes.

Thanks.  The prerequisites where applied earlier this week, including
patch #1-#3 from this series.

> 
> The last four patches are an update to this RFC:
> https://www.spinics.net/lists/target-devel/msg16312.html
> Since that posting I moved the files being added to a new
> dir "action" which is used for special files that execute
> a kernel function that does more than just set a param/attrib
> that is exported from the same file.
> 

Was wondering about that..

Why shouldn't these be added as backend device specific configfs
attributes, similar to what tcmu does for tcmu_attrib_attrs[]..?

