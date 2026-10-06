Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92ED13D967F
	for <target-devel@vger.kernel.org>; Tue,  6 Oct 2026 09:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791279265; cv=none; b=p6P6wJCfskJ8cY1tjdiZNAVWbxV+6fzdXmDDaNEJ0vmyCwJxWfMEex4o2cRwmKLh0K6YY/qajGFJEjNfThK9X9bw5lCKktst7bRWRakTo9BsaY1FD2xhL6dAhjTJF50i4eDXCils6PT/20J2w2ffGQ81cEH4VhQoIMD7v/CN8hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791279265; c=relaxed/simple;
	bh=sRXARn7rltoKuuBkviV7Rzg2hh6wE9w+qedmvZuYEgE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mTfGzKa6FtqLVSnToB/44SZKqTNgnCSF4H0tPUJWTzSaA/Imi96pFXQBL7Oxe9byeCfUwjKYS9/6JIzxNlcYR8KJ+I1xzcps0L8Wx0H5Pj+lAwekkPme58jl7X7LBVGgwg/T6YxjLLvkvztHAr+wfQxIy8hyE6B/rMmfXcVporo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sp7oTk3q; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sp7oTk3q"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-381b831d535so2580761a91.0
        for <target-devel@vger.kernel.org>; Tue, 06 Oct 2026 02:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791279260; x=1791884060; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FfGw4pZW0aV8/Q7fkT5ZBmOHgIkxnICvN7ym0WNBWHU=;
        b=Sp7oTk3qnC/OLANEJH9A17lWUqR5AH8nokqP7i7qKpv5YfDvsiO+qgakWOamLVSKxH
         IHk2DEJ6NExHsD10EK0Ytyr2yBpNWQNVS2uXPxwoSGSUjHlC4L42rWFnb8JByZX7XIzc
         DVuboT198j1uvXvUNG2+nRPeqjC2FVhXu+B+qXkJAGuQRm8wTJvZgQ8NkmytOBo9656D
         uAQ2A9tZ9ThM7pH9A9NU0OyO0nLPeiHK9kJhW6V/nD3U0Wum/4T0WUIJ4l9KJM8ZtfLW
         Ug/j8Gss42kuDW4Ds4AqkIpP/s6bne6Un85XcrGWLNkmHJ6Qq0pL0lw9hrnsmImH2Z7k
         jc/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791279260; x=1791884060;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FfGw4pZW0aV8/Q7fkT5ZBmOHgIkxnICvN7ym0WNBWHU=;
        b=DbJPR7U9iWbdDkzkioq9enLnS25foOMbYz11OopnSPlqsWwrrlIFmVfJ75lSnaDHcT
         C+eqF+bcGnvBCvGN1LVnbhttILrzQ0Wx1K4BMm7YAW5ZFBDJNYgzJpwhu0U2J4A86qL7
         DpZ/Lx72H4BH+9U5CR4OUquP8PJbVd45CHlwTdzZZIBXN42n8AESKKYHzZqBpyLE+YXj
         eQPITaKuY567TQHkUjlLdIpq+Z7kcN7uXkHXj0+Yv2aS/AqL4gxlrlIdyKY8khZTWjgG
         mZvTsTst1eXIhgjHMyBnhIbmnLe6Pto+eZz7Sgi3QhsuOolqUkIDa3JaImFtJVWWy3Tq
         qoVg==
X-Forwarded-Encrypted: i=1; AKwUvBx/QJyv0WlUjyBgxvt8DImc0MM5Jcifg6CoJw4Ykfp0UKOZfMEqZEQtP62GwKt0Jo/Z0noidtcJ0OsvOTk=@vger.kernel.org
X-Gm-Message-State: AFq9FYICcXv8D8sj+post+uAT3FO0KxsjEuVstk+3MF+ssR6HhQNs8jl
	JEg4Ln0/QdEnUn2BntgiNrwFrPoRrCoimFtQwTPqF+54/qfJJh252kS7
X-Gm-Gg: AYBFou3oSot5n0j82h106+Yah3T/+AD6N+nwAN9KY5C0gCxiJJc7OmDvcxiHiyqwvYV
	m3UrdcW65Lg774D5yPMiTzk0HJcBJMbyOJMQHj8mmpjozuMeGLs/fVNz7znr5JIJhMWDIdHod9C
	yrtqyXWV55qwdBJJSSv0IoqrgipvlJKpoA7+qP1gygzvYqTd5teVrRgfZDm5ZWDMilayjiE5IeV
	Sc1UvegbfVXEqEPn+BTSkljBBf1AdJTsdXeqE6fZTmDIySCDEEL1078tE4Xz0cf3DefATakEWSu
	70skc+njmmiSR4ijOdOBG/dGJ6COl8QLTXoZ6s02iflK+t4MWuaXWYwwev8oO5Lo0jGBM9Z7lsA
	K/US86Mo/O11uuI5fzMY5rO9NzztGOqlA5vl345rl7zT65PRVlCmvgAlTdfLMF0o1C//w+r38nF
	THrCtIgQf2R0vkNYH5JkMXPVcOzJMoFkedcXAwWgJcjZbblF7Obs7Jc8uBWLWojurFKl3XAQ==
X-Received: by 2002:a17:90b:164b:b0:3a4:d338:4136 with SMTP id 98e67ed59e1d1-3a78779e4e0mr8312336a91.66.1791279259449;
        Tue, 06 Oct 2026 02:34:19 -0700 (PDT)
Received: from gmail.com ([188.253.12.30])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8543ab76bsm3905277a91.13.2026.10.06.02.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 02:34:19 -0700 (PDT)
From: Jia Jia <physicalmtea@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>
Cc: Jan Engelhardt <jengelh@inai.de>,
	Hannes Reinecke <hare@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	James Bottomley <James.Bottomley@suse.de>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jia Jia <physicalmtea@gmail.com>
Subject: [PATCH 0/8] scsi: target: keep command bytes inside the sg
Date: Tue,  6 Oct 2026 17:33:30 +0800
Message-Id: <20261006093338.27342-1-physicalmtea@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Eight fixes for target core reading or writing past an sg.  Patches 4
through 6 and patch 8 share the DIF sg walk and apply in order.  The
others stand alone.  vhost-scsi keeps one sg inside one page, so those
bytes land on the next physical page.  The commands reach the host
through a guest virtqueue.

Patch 1 takes the COMPARE AND WRITE write half from its own sg entries.
Adding the compare length to the first entry's offset loses the sg
boundary when the two halves are split across pages.  The replacement
table is released with sg_free_table().

Patch 2 keeps each REPORT REFERRALS LBA store inside the data-in
buffer.  The existing data_length checks cover one-byte fields, not the
eight-byte LBA.

Patch 3 rejects a SET TARGET PORT GROUPS list that ends on a partial
four-byte descriptor.

Patch 4 copies an 8 byte protection tuple across sg entries in
sbc_dif_generate().  A tuple that starts at the end of one entry is
written into the next entry as well.

Patch 5 does the same read in sbc_dif_verify().  A tuple that runs off
the end of the protection list fails the command.  The generate change
does not cover this function.

Patch 6 limits the block CRC in both functions to the bytes each data
sg actually holds.

Patch 7 reads the pscsi MODE SENSE write-protect byte and the tape
MODE SELECT block descriptor from the whole data buffer.  A short
buffer is left unchanged.

Patch 8 makes sbc_dif_verify() advance the data cursor across every sg
entry of a logical block whose application tag is 0xffff.  The cursor
uses the same kmap_local_page() calls as the CRC walk.

Jia Jia (8):
  scsi: target: take COMPARE AND WRITE data from the write half
  scsi: target: keep REPORT REFERRALS stores inside the buffer
  scsi: target: reject a short SET TARGET PORT GROUPS list
  scsi: target: copy a DIF insert tuple across prot sgs
  scsi: target: copy a DIF verify tuple across prot sgs
  scsi: target: limit DIF block CRC to each data sg
  scsi: target: keep pscsi mode bytes inside the data sgs
  scsi: target: skip an escaped DIF block inside the data sg

 drivers/target/target_core_alua.c      |  29 +++++++---
 drivers/target/target_core_pscsi.c     |  98 +++++++++++++++++++++++---------
 drivers/target/target_core_sbc.c       | 474 ++++++++++++++++++++++++++++---------
 drivers/target/target_core_transport.c |  11 +++-
 4 files changed, 439 insertions(+), 173 deletions(-)

-- 
2.43.0
