From: David Disseldorp <ddiss@suse.de>
Date: Tue, 17 Oct 2017 23:59:11 +0000
Subject: [PATCH v2 0/2] target: fix file path truncation
Message-Id: <20171017235913.16786-1-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, 16 Oct 2017 23:57:18 -0700, Christoph Hellwig wrote:

> How about simply switching to kasprintf?

Sounds reasonable to me. v2 patchset doing this follows...

FWIW, the script that I'm using to setup a target for path truncation
is at:
https://github.com/ddiss/rapido/blob/ce1ed251abd404f96dac9a0c3500030cb5b9c91a/lio_local_autorun.sh

Cheers, David
