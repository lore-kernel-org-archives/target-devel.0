Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794280214;
	b=NzGRXxnvaULy+DPQp4TIa1skZKUGEppGnMBZDPuhhNsCUx8utzIq477RHv2HXG8Pm3BW
	 GwVwC6QxscYIRlSP+jlvbePXWQJ1XyFtqG8atRGHEcsykSPAMaL+ZbBe0pndFv3+YeLwT
	 iuG0BQQ4xz1jc8owiAar2/LF6IsOkA/28WEJ/ugi//LNowzBUodaGmwBJ/17wA6J1CQXl
	 ffjRBPeDMn2v+JSppqr8OizhMoSOnqNsgwKlK+7iej9ZKWM1E1bbVIK9cWWccwcV8EblQ
	 4wt1O9u03nTw1UWfZ0a0geu1f2sRbrCyHPmA0id02no4OCeoJimYUWyE9Mx+C+nIlaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794280214;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6QYJzw9Rr63XbTuPHrN4Cbad1UtYv7xxIdUtWOpl04I=;
	b=c5c+1Xb7Ks/JcBG6Yq02RNe9oQcdBCtu8eTFeyPyavfdb6HBM0zv1xzYm3pUpv6EdBxK
	 xuLMV50SwXu1AEqNErOhDmvYHhTzaFq3wiq2SRCuMS9M/On1ByVDiYXjo3YOsb7WQYaX4
	 PSY6ZsaDrIcMinIIxe37bjO8jYOXH6PdzaylAAcdCa47sc5roz3z3vJb7LX0RIkWOytSA
	 oafI3kcVIlKrpotnUhngwBN/Xmnm12UTeKUDjd0xw62Dcmn6/CMCg/Y87FdjRWqLwjGRr
	 DwLpbLCEBQL9EUM/MdUzvLjdoVK5HWDdZEMoHbEQNvU/WTG7xJyeMacgWW9sG2tGlAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L+yttUZi;
	arc=none smtp.remote-ip=209.85.210.170
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C46606A339
	for <target-devel@vger.kernel.org>; Tue, 10 Nov 2026 03:10:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48C46606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L+yttUZi
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8a0880a46e7so857021b3a.1
        for <target-devel@vger.kernel.org>; Mon, 09 Nov 2026 19:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794280214; x=1794885014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6QYJzw9Rr63XbTuPHrN4Cbad1UtYv7xxIdUtWOpl04I=;
        b=L+yttUZiKSMf9NvCb+E1pLmj8OeGaaYw08dr2RAirE+Lz4npNIabN93ZWVbnQvBOmk
         L/yuJyZBJXk+gbkG3Ff9GbaY/UHwWlFTW80K5LASoZSSlGlA+HKK4+3kty5gpse5xRY4
         TI+pERF8HLHwUyjXVIkZqzQHRQNiZ+4a9ipfpMf/81jymsAP0aUBrdIzokuk4ZY/WnEu
         yxiBGwyFRYuoSKH4xpoBKm6g86uUhQq4pQbB86n6O8c6bHsYhFkKH+5rsFw6uBhO8JV8
         YWitWZAUHAoOpHd6BhxUuy673W5AKuYLbtmnvskoeROhohACc5FBdnN4+re4uTlbXTZ+
         3PnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794280214; x=1794885014;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6QYJzw9Rr63XbTuPHrN4Cbad1UtYv7xxIdUtWOpl04I=;
        b=tJ2qM4jvRrAJM/dH+Z3e+B4CVx6Pxmwp8w1vgUPAPBPmTU7kZvgMCP4E8MuRN009ND
         IsfLHhQ6pvvsGcLHsWO968XHNSJi6jPe8KM/plBOBvBuyDp/gqXYUf+7BUVoCL9/3kCA
         dUoeLuhb6mKXsG0HkFhuYoLyKR9E4uGtvEERw7TW5SjGr03jv8UlHzz1bqtk23M9o85Y
         hbYi+9IZPQvuPKU0KlQu1F4nsbxlcSz0NsdcsttbMWoBBFopVzgq8vajGE61BO/eruzi
         IJDqHTBZzy/GK9pXumAam8Q+JnTSTc+gPVIOly9P9CVMF1zoGbMg+GEyxRhaJsEMvzjz
         1TYg==
X-Forwarded-Encrypted: i=1; AL+hErGN95FjSzjOx1kmna+mmDe0WbOcsmWGEKprHrrzw0X74LDkje2g1iWGCc2oqNZo+uXwDMs2FXfiVwgfUso=@vger.kernel.org
X-Gm-Message-State: APuU4Z8Vzc9JZxbyH2V+Qw1j8pTDdzJ0mw9Gvzu2qmsC7D9giAz5mmCt
	MlhWalXUjUFvCw5CJrJAJ091IJhPTQBI2J1owAw94D8hECa4PS/ty+132rv+dcYGxNM=
X-Gm-Gg: AYBFou2d97vzJrTtxQlf+o4RSvTVFPJsh3x8yYpxRVN16Sdm9NFuWygumJC/7zdUjju
	wHlPdsHs0T2qh/KsO3e3CjJSvDlVxULjyMyjnCSaPS3/REjriUpR5GD562jAKATquIjLSN9gabU
	lYwjjza+aSyBh9Hy+A5ahA4rT2DYM+HfT92GqKuGxz6sNJHtWZKKNvCf4bGIE/EpDQm7vbIyJS1
	JjQm+ZtQMHpLu2tERBBZ+Nc57k1zY9RI7ZAXmc090/8K3jvIwk1+8RpD3PXtuoCQSMFUv29r4/g
	hP3sjeRcWVU6hcRfVodKS4Vt93+/sYNlf/fI/EqZ9adGywlD924t0AK+sSwDI0XsBMNQ0D+WABD
	Q2TbjzseJwI+SdPfk9VrbQyuWFkLGjg5GOa3Xkr3P+Sh1AoAw1jQSPEn7CFG97hH47/VWDQy7De
	YTEABPyVhDLAR50MO8vt8HVnIWll1TpqOxrUNKs/x0FrQiEikTXjF9hrV7/9HQI/dg2zbrBTsbS
	/+4AE19OM2gAs8eaWKFKo5LuqqSws2ekt4LIYKgYvhKwiQhokHtL7qUdjoi/pG9hUQ197LN/0W4
	1VqDGsTbDYDRFk/YqkqonDF4k9ES6sbLyvftvpCkfg==
X-Received: by 2002:a05:6a00:9287:b0:8a0:12ab:e29 with SMTP id d2e1a72fcca58-8ba97ac0667mr920272b3a.9.1794280213567;
        Mon, 09 Nov 2026 19:10:13 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab8dffb5sm308939b3a.55.2026.11.09.19.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 19:10:13 -0800 (PST)
From: liuyong <pkfxxxing@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH 0/1] RDMA/srpt: Fix read underflow information disclosure
Date: Tue, 10 Nov 2026 11:08:05 +0800
Message-ID: <20261110030809.913063-1-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This patch fixes an SRPT information disclosure that allows a remote
initiator with LUN access to read uninitialized target kernel memory,
potentially exposing sensitive data from previous uses of those pages.

SRPT creates RDMA contexts from the initiator's buffer descriptors before
parsing the CDB. For a READ underflow, target core reduces
cmd->data_length, and a backend such as rd_mcp fills only that length.
The prebuilt RDMA WRITE requests still send the full descriptor-sized
buffer, including the uninitialized tail. The underflow itself is valid;
the problem is transferring more data than the command provides.

The fix caps the data SGEs at cmd->data_length in srpt_queue_response().

The patch is based on Linux 7.4.0-rc1 commit
f66469d9905b39d2c260a15d7d6db450f4db67c1. The issue was reproduced on
the same commit using software RoCE and an rd_mcp RAMDISK with an explicit
ACL-LUN mapping. The triggering READ(10) requests one 512-byte block but
provides an 8192-byte data-in descriptor.

Relevant target kernel log excerpt:

[    7.496367] ib_srpt Received SRP_LOGIN_REQ with i_port_id 5352:502d:4556:494c:2d49:4e49:542d:3031, t_port_id 5054:00ff:fe12:3456:5054:00ff:fe12:3456 and it_iu_len 512 on port 1 (guid=fe80:0000:0000:0000:5054:00ff:fe12:3456); pkey 0xffff
[    7.528685] TARGET_CORE[srpt]: Expected Transfer Length: 8192 does not match SCSI CDB Length: 512 for SAM Opcode: 0x28

The patch has been compiled and verified to fix the reported issue.

A reproducer and additional reproduction materials are available.
Please contact me privately if you need them.

The issue was discovered and fixed by Qihoo 360's Tulongfeng multi-agent
system.

Regards,
liuyong
360 Vulnerability Research Institute

liuyong (1):
  RDMA/srpt: Limit read data transfers to the command length

 drivers/infiniband/ulp/srpt/ib_srpt.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

