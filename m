From: David Miller <davem@davemloft.net>
Date: Tue, 06 Feb 2018 14:42:53 +0000
Subject: Re: [PATCH 1/3] net/utils: Introduce inet_addr_is_any
Message-Id: <20180206.094253.2191113540764519816.davem@davemloft.net>
List-Id: <target-devel.vger.kernel.org>
References: <20180206094432.12761-1-sagi@grimberg.me>
 <20180206094432.12761-2-sagi@grimberg.me>
In-Reply-To: <20180206094432.12761-2-sagi@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>
Date: Tue,  6 Feb 2018 11:44:30 +0200

> +		if (!memcmp(in6->sin6_addr.s6_addr,
> +			in6_any.sin6_addr.s6_addr, 16))

Please indent this properly.

When a function call spans multiple lines, the second and subsequent
lines of that call must be indented precisely to the column that follows
the openning parenthesis of that call.

You must use the appropriate number of TAB then SPACE characters
necessary to achieve this.

Thank you.
