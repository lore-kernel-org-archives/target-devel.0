From: David Disseldorp <ddiss@suse.de>
Date: Fri, 23 Nov 2018 18:31:28 +0000
Subject: Re: [PATCH] target: drop unnecessary get_fabric_name() accessor from fabric_ops
Message-Id: <20181123193128.40c20eba@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181122141623.7507-1-ddiss@suse.de>
In-Reply-To: <20181122141623.7507-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Fri, 23 Nov 2018 11:22:08 +0100, David Disseldorp wrote:

> > > Both fabric_ops.get_fabric_name() and fabric_ops.name are user facing,
> > > with the former being used for PR/ALUA state and the latter for configFS
> > > (config/target/$name), so we unfortunately need to keep both strings
> > > around for now.    
> > 
> > Would it make sense to just use .name unless .fabric_name is set
> > to mostly avoid the duplication?  
> 
> Yeah, was thinking more along the lines of renaming .name to
> .fabric_alias and only setting it for the "iscsi" configfs case.
> What's your preference?

I've sent a follow-up patchset which includes this change as:
[PATCH 3/3] target: replace fabric_ops.name with fabric_alias

Feedback appreciated.

Cheers, David
