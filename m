From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Sat, 13 Jan 2018 04:08:08 +0000
Subject: Re: [PATCH 0/5]: Fix target_core_user userspace restarts (v2)
Message-Id: <1515816488.24576.55.camel@haakon3.daterainc.com>
List-Id: <target-devel.vger.kernel.org>
References: <1513677838-6675-1-git-send-email-mchristi@redhat.com>
In-Reply-To: <1513677838-6675-1-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Fri, 2018-01-12 at 16:41 -0600, Mike Christie wrote:
> On 01/12/2018 04:13 PM, Nicholas A. Bellinger wrote:

<SNIP>

> > Was wondering about that..
> > 
> > Why shouldn't these be added as backend device specific configfs
> > attributes, similar to what tcmu does for tcmu_attrib_attrs[]..?
> 
> 
> Hey,
> 
> The problem is that rtslib assumes attrs are things that the user always
> wants to get/set. For example, when you create a device the attrs will
> be read and stored in some config file so later when targetcli
> restoreconfig is run it will write the stored values thinking they are
> the user requested defaults.
> 
> The primary purpose of the files being added in these last patches are
> to allow userspace to tell the backend module to perform some operation.
> For example, when we restart tcmu-runner it is really easy to do if IO
> is not being sent to the daemon at the same time. The block file
> prevents IO from being sent and the reset file makes sure the ring
> (buffer used to pass commands between user/kernel space) is in a good
> state (this is needed for the case where runner crashed).
> 
> We do not want targetcli writing whatever value it found in these
> special files when the device was created because it might for example
> leave a device blocked.

pi_prot_format is a similar case wrt rtslib + se_device creation.

For that one, attr read is always '0' and attr write '0' is considered
a nop.

> 
> I guess the options were:
> 
> 1. This patch that separates this kind of files and tries to make it
> generic.
> 2. Instead of the generic action dir, I could just make a
> target_core_user specific dir.
> 3. I can modify rtslib with a attr file blacklist, and these special
> files can go in it.
> 
> I thought #1 or even #2 was nicer, because attrs seemed like they had a
> specific purpose to get/set info about an object.

If it's purely to avoid block_dev + reset_ring attr write operation upon
rtslib se_device creation, following how pi_prot_format works with
existing tcmu_attrib_attrs[] is an option too.

That said, I'm not against adding a new se_device->dev_action_group, but
want to make sure these new attributes are really considered private to
tcmu's own user-space, separate what rtslib + friends code ever expects
to poke at..

Is that the case..?

