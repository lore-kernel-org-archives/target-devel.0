From: Christoph Hellwig <hch@infradead.org>
Date: Fri, 23 Nov 2018 07:19:10 +0000
Subject: Re: [PATCH] target: drop unnecessary get_fabric_name() accessor from fabric_ops
Message-Id: <20181123071910.GA30518@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181122141623.7507-1-ddiss@suse.de>
In-Reply-To: <20181122141623.7507-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Thu, Nov 22, 2018 at 03:16:23PM +0100, David Disseldorp wrote:
> All fabrics return a const string. In all cases *except* iSCSI the
> get_fabric_name() string matches fabric_ops.name.
>
> Both fabric_ops.get_fabric_name() and fabric_ops.name are user facing,
> with the former being used for PR/ALUA state and the latter for configFS
> (config/target/$name), so we unfortunately need to keep both strings
> around for now.

Would it make sense to just use .name unless .fabric_name is set
to mostly avoid the duplication?
