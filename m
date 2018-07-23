From: Mike Christie <mchristi@redhat.com>
Date: Mon, 23 Jul 2018 19:07:42 +0000
Subject: [PATCH 0/9] tcmu: configuration fixes and cleanups
Message-Id: <1532372871-7128-1-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The following patches were made over Martin's for-next branch.

The first patch fixes a locking bug in the command setup path. The rest
of the patches fix several bugs and cleanup the setup and configuration
code paths.


