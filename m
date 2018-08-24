From: Matthew Wilcox <willy@infradead.org>
Date: Fri, 24 Aug 2018 19:10:24 +0000
Subject: Re: [PATCH 0/3]: iscsi target login fixes
Message-Id: <20180824191024.GA1604@bombadil.infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <1535135833-7454-1-git-send-email-mchristi@redhat.com>
In-Reply-To: <1535135833-7454-1-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Fri, Aug 24, 2018 at 01:37:10PM -0500, Mike Christie wrote:
> The following patchset is a round up of login fixes that have been
> on the list and in Mathew's tree. They fix a couple of bugs in the
> iscsi login failure handling path.
> 
> The patches were made against Martin's 4.19/scsi-queue branch.
> 
> Matthew, the first patch is one that I had sent to you that had a fix
> for the idr issue you asked about on the list. There was a conflict so
> I had to update the patch. I was not sure if you wanted me to keep
> your signed off so to be safe I dropped it.

It should at least have my Reported-by: on it ;-)

But I did review the patch, and it LGTM, so Martin, please include my
Signed-off-by: on patch 1/3.

> Also, it sounded like your ida/idr patches were not going to make 4.19,
> so hopefully the idr iscsi login fix will be merged already when your
> patches get merged for 4.20, so you do not have to carry it anymore.

I'll leave it in my tree for now and drop it again once these fixes are
merged, otherwise I'll have to resolve a marge conflict twice.
