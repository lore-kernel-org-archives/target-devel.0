From: Mike Christie <mchristi@redhat.com>
Date: Sun, 28 Apr 2019 04:17:18 +0000
Subject: [PATCH 0/2] iscsi target: fix login negotiation
Message-Id: <20190428041720.9119-1-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The following patches fix login negotiation when the user has disabled
authentication, and the initiator is presenting CHAP,None. The problem
is that the target initializes AuthMethod to CHAP (normal session) or
CHAP,None (discovery session), but when the user does authentication=0/
enforce_discovery_auth=0 we can end up setting AuthMethod to CHAP,None.
The user would then have not setup CHAP settings like userid/password
since they disabled it, so later the login will fail if the initiator
presents CHAP,None, because the target sees CHAP and tries to do that since
it had set CHAP,None when disabling auth but there are not valid values.

As an alternative to these patches we could also have the configfs file
update the AuthMethod when it is written to. For example when userid,
password, authentication, enforce_discovery_auth, etc are written to
we could update AuthMethod, but I was worried that userspace apps/users
could set these in funky orders like initializing the CHAP values then
setting authentication/enforce=0 and in that case we might end up not
using CHAP when we used to.
