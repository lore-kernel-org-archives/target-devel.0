From: David Disseldorp <ddiss@suse.de>
Date: Wed, 22 May 2019 13:04:17 +0000
Subject: tcmu-runner libtcmu.so versioning
Message-Id: <20190522150417.0650ed2f@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi,

Some ABI changes went into libtcmu between v1.3.0 and v1.4.0 without a
corresponding .so version bump (e.g. 566c2ad5c8a). This breaks
dependency checking in some package managers, allowing for a v1.4.0
tcmu-runner to be installed alongside a v1.3.0 libtcmu.so

Should we consider adding a 2nd (minor) .so version number to libtcmu,
so that it can be bumped for backwards compatible ABI changes like this
one?

Cheers, David
