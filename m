From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 13 Mar 2020 17:39:28 +0000
Subject: Re: [PATCH 0/3] Fix a race condition in the target driver
Message-Id: <650e95a9-c055-304c-6f91-4b9f7c046bb4@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200313161253.5507-1-mlombard@redhat.com>
In-Reply-To: <20200313161253.5507-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 3/13/20 9:12 AM, Maurizio Lombardi wrote:
> Multiple threads may try to destroy the same iscsi session
> structure by calling iscsit_close_session() and then end
> up hanging.
> 
> This patchset modifies the driver so the session
> structure is destroyed by iscsit_close_connection() when
> the last connection gets closed, thus preventing
> the race condition.
> 
> Maurizio Lombardi (3):
>    target: remove boilerplate code
>    target: fix target hang when multiple threads try to destroy the same
>      iscsi session.
>    iscsi target: calling iscsit_stop_session() inside
>      iscsit_close_session() has no effect
> 
>   drivers/target/iscsi/iscsi_target.c          | 82 ++++++--------------
>   drivers/target/iscsi/iscsi_target.h          |  1 -
>   drivers/target/iscsi/iscsi_target_configfs.c |  5 +-
>   drivers/target/iscsi/iscsi_target_login.c    |  5 +-
>   include/target/iscsi/iscsi_target_core.h     |  2 +-
>   5 files changed, 32 insertions(+), 63 deletions(-)
> 

Hi Mike, Varun and Rahul,

This patch series may affect the iSER target driver so you may want to 
verify this patch series on your test setups.

Thanks,

Bart.
