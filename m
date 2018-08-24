From: Mike Christie <mchristi@redhat.com>
Date: Fri, 24 Aug 2018 18:37:10 +0000
Subject: [PATCH 0/3]: iscsi target login fixes
Message-Id: <1535135833-7454-1-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The following patchset is a round up of login fixes that have been
on the list and in Mathew's tree. They fix a couple of bugs in the
iscsi login failure handling path.

The patches were made against Martin's 4.19/scsi-queue branch.

Matthew, the first patch is one that I had sent to you that had a fix
for the idr issue you asked about on the list. There was a conflict so
I had to update the patch. I was not sure if you wanted me to keep
your signed off so to be safe I dropped it.

Also, it sounded like your ida/idr patches were not going to make 4.19,
so hopefully the idr iscsi login fix will be merged already when your
patches get merged for 4.20, so you do not have to carry it anymore.
