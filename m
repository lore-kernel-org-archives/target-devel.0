From: David Disseldorp <ddiss@suse.de>
Date: Mon, 02 Sep 2019 08:36:22 +0000
Subject: Re: [PATCH] target: compare full CHAP_A Algorithm strings
Message-Id: <20190902103622.0e6e6d54@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20190830171611.32540-1-ddiss@suse.de>
In-Reply-To: <20190830171611.32540-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Fri, 30 Aug 2019 19:16:11 +0200, David Disseldorp wrote:

...
> LIO currently checks for this value by only comparing a single byte in
> the tokenized Algorithm string, which means that any value starting with
> a '5' (e.g. "55") is interpreted as "CHAP with MD5".

FWIW, this can be triggered via a simple libiscsi hack:
https://github.com/ddiss/libiscsi/commit/a6a41fd002c18edaad5d7df320373ec0232b460d.patch

Cheers, David
