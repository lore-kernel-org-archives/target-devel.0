From: Mike Christie <mchristi@redhat.com>
Date: Mon, 21 Oct 2019 16:06:18 +0000
Subject: Re: [PATCH 0/3] target: minor iSCSI parameter parsing fixes
Message-Id: <5DADD77A.6010903@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190912095547.22427-1-ddiss@suse.de>
In-Reply-To: <20190912095547.22427-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 09/12/2019 04:55 AM, David Disseldorp wrote:
> This patchset includes some minor fixes for parsing iSCSI CHAP_A and
> SendTargets fields. Patch 1/3 was already submitted and reviewed by
> Lee.
> I used the following libiscsi hacks to test for these bugs:
> https://github.com/ddiss/libiscsi/commits/bogus_chap_a
> https://github.com/ddiss/libiscsi/commits/bogus_sendtarget_key
> https://github.com/ddiss/libiscsi/commits/bogus_sendtarget_val
> I'll work on turning these into propper libiscsi regression tests
> (pending https://github.com/sahlberg/libiscsi/issues/297).
> 
> Cheers, David
> 
>  drivers/target/iscsi/iscsi_target.c            | 14 ++++++--------
>  drivers/target/iscsi/iscsi_target_auth.c       |  2 +-
>  drivers/target/iscsi/iscsi_target_parameters.h |  3 ---
>  3 files changed, 7 insertions(+), 12 deletions(-)
> 

Reviewed-by: Mike Christie <mchristi@redhat.com>
