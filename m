From: Sagi Grimberg <sagi@grimberg.me>
Date: Wed, 07 Feb 2018 13:05:16 +0000
Subject: [PATCH v2 1/3] net/utils: Introduce inet_addr_is_any
Message-Id: <20180207130518.22803-2-sagi@grimberg.me>
List-Id: <target-devel.vger.kernel.org>
References: <20180207130518.22803-1-sagi@grimberg.me>
In-Reply-To: <20180207130518.22803-1-sagi@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Can be useful to check INET_ANY address for both ipv4/ipv6 addresses.

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 include/linux/inet.h |  1 +
 net/core/utils.c     | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/linux/inet.h b/include/linux/inet.h
index 636ebe87e6f8..97defc1139e9 100644
--- a/include/linux/inet.h
+++ b/include/linux/inet.h
@@ -59,5 +59,6 @@ extern int in6_pton(const char *src, int srclen, u8 *dst, int delim, const char
 
 extern int inet_pton_with_scope(struct net *net, unsigned short af,
 		const char *src, const char *port, struct sockaddr_storage *addr);
+extern bool inet_addr_is_any(struct sockaddr *addr);
 
 #endif	/* _LINUX_INET_H */
diff --git a/net/core/utils.c b/net/core/utils.c
index 93066bd0305a..6e331a7904e7 100644
--- a/net/core/utils.c
+++ b/net/core/utils.c
@@ -403,6 +403,29 @@ int inet_pton_with_scope(struct net *net, __kernel_sa_family_t af,
 }
 EXPORT_SYMBOL(inet_pton_with_scope);
 
+bool inet_addr_is_any(struct sockaddr *addr)
+{
+	if (addr->sa_family = AF_INET6) {
+		struct sockaddr_in6 *in6 = (struct sockaddr_in6 *)addr;
+		static const struct sockaddr_in6 in6_any +			{ .sin6_addr = IN6ADDR_ANY_INIT };
+
+		if (!memcmp(in6->sin6_addr.s6_addr,
+			    in6_any.sin6_addr.s6_addr, 16))
+			return true;
+	} else if (addr->sa_family = AF_INET) {
+		struct sockaddr_in *in = (struct sockaddr_in *)addr;
+
+		if (in->sin_addr.s_addr = htonl(INADDR_ANY))
+			return true;
+	} else {
+		pr_warn("unexpected address family %u\n", addr->sa_family);
+	}
+
+	return false;
+}
+EXPORT_SYMBOL(inet_addr_is_any);
+
 void inet_proto_csum_replace4(__sum16 *sum, struct sk_buff *skb,
 			      __be32 from, __be32 to, bool pseudohdr)
 {
-- 
2.14.1

