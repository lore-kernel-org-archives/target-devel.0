From: Matthew Wilcox <willy@infradead.org>
Date: Mon, 27 Aug 2018 05:03:38 +0000
Subject: Re: [PATCH 0/3]: iscsi target login fixes
Message-Id: <20180827050338.GB17478@bombadil.infradead.org>
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
> 
> Also, it sounded like your ida/idr patches were not going to make 4.19,
> so hopefully the idr iscsi login fix will be merged already when your
> patches get merged for 4.20, so you do not have to carry it anymore.

Christmas came early, and Linus decided to pull the updated ida patches.

commit 26abc916a898d34c5ad159315a2f683def3c5555
Author: Mike Christie <mchristi@redhat.com>
Date:   Thu Jul 26 12:13:49 2018 -0500

    iscsi target: fix session creation failure handling

so patch 1 does not need to be added to v4.19/scsi-queue
