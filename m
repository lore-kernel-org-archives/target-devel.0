From: Mike Christie <mchristi@redhat.com>
Date: Thu, 19 Jul 2018 21:30:36 +0000
Subject: Re: [PATCH 11/15] target: export initiator port values for all sessions
Message-Id: <5B5102FC.8090204@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-12-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-12-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 07/19/2018 03:47 PM, Christoph Hellwig wrote:
> On Thu, Jul 19, 2018 at 05:07:59PM +0000, Bart Van Assche wrote:
>> Initially configfs did not support creation of a directory from the kernel
>> side. Last time I brought this up with Christoph he replied that this
>> functionality has been added to configfs (if I understood Christoph
>> correctly).
> 
> I don't think the functionality was ever missing, but I might be
> mistaken.  You can always call config_group_init_type_name() +
> configfs_add_default_group to add a directory.  nvmet makes heavy
> use of that.

Just to clarify. We can create a dir from the kernel already. It is no
problem. I am doing that in this patchset with configfs_register_group.

What Bart was requesting originally and what is missing is being able to
add a symlink from the kernel.

I have not fully looked into it, but I think it would be something like
taking part of configfs_symlink and making it so we can call it with
config_items for the 2 items to be symlinked.

