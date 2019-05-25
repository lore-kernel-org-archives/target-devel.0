From: Mike Christie <mchristi@redhat.com>
Date: Sat, 25 May 2019 23:10:44 +0000
Subject: Re: tcmu-runner libtcmu.so versioning
Message-Id: <5CE9CB74.8070109@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190522150417.0650ed2f@suse.de>
In-Reply-To: <20190522150417.0650ed2f@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 05/22/2019 08:04 AM, David Disseldorp wrote:
> Hi,
> 
> Some ABI changes went into libtcmu between v1.3.0 and v1.4.0 without a
> corresponding .so version bump (e.g. 566c2ad5c8a). This breaks
> dependency checking in some package managers, allowing for a v1.4.0
> tcmu-runner to be installed alongside a v1.3.0 libtcmu.so
> 
> Should we consider adding a 2nd (minor) .so version number to libtcmu,
> so that it can be bumped for backwards compatible ABI changes like this
> one?
> 

That seems ok to me.
