Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C3C3546C7
	for <target-devel@vger.kernel.org>; Thu,  3 Sep 2026 03:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788405032; cv=none; b=kuKQ8CsdnIQdMUM5rvnSdMKxu64BfSWIqOc7gVCTPo0G24oZWAz3gCu2YGtrc9PM4xZZKCNmdcjEdZmVp0DxjVjYy46L3b0Lok7vgt5wGyW71LGvzUylbiBddG8TLw2I2gWKPdviVU9GUibwtr8woADo52ff/L4pa2BmaQ+qvfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788405032; c=relaxed/simple;
	bh=i+nwXSTWQ6RWH56RSu2sQo2iXQu49QTXe4ku+jVE6FM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k1/s+piNKvAKNXgtv+6QlYBC4r/Wr03u65AG/mK5misxMJTGI87+t2PcQcD5qcnpMUZUG7kxXvhU5Znb8ORLgXmH6Ns0HZy14qDyzb6wOq8GkTX6mvQujiGrmFjGxF4azAM/+fVntxScMAsAeHfNgar01j9StdtM60rVCIG/QIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=etcksbjM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="etcksbjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B4A1F00A3D;
	Thu,  3 Sep 2026 03:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788405031;
	bh=jx/zU5AJpILI5G0FZ+r7TZ+PkVwGj2RC2q3lkgDjIms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=etcksbjMbNAdpfCWzPyfF6DBK/5nY51Xx1EPfMTX5OQPdu/8ATU1vOsOg5eKdEGT8
	 O5z05Tsnt8f77j0IPEkXBS9RTSdLHTT/JoLWMJHTZTu15enAPWnACcwz0jbkU31MKk
	 IjFOyTeH/b5iHRNcRHE1HZVJLl44B/dMscwBZpGEfIyZnE/csFmda6u+TiOZmRMFoe
	 EOhDiwCYOEdSD90ZEgUwy7+oE3eOz8ND8UkczwY96uJr38CcQItZMBHUwzmQcL2tli
	 AbUGqTcDadH3R8JebWK5KFOXHL86/nhr1ZLuTyvOu0M7/kwgQQgTeY/stbITKavZX3
	 dLA8FYq80L8yg==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>,
	Maurizio Lombardi <mlombard@redhat.com>
Cc: mlombard@arkamax.eu,
	michael.christie@oracle.com,
	target-devel@vger.kernel.org,
	loberman@redhat.com
Subject: Re: [PATCH 1/1] target: iscsi: Fix hang for aborted WRITE_PENDING commands
Date: Wed,  2 Sep 2026 23:10:10 -0400
Message-ID: <178840472593.670675.10791972189795446509.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260717143828.76291-2-mlombard@redhat.com>
References: <20260717143828.76291-2-mlombard@redhat.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 17 Jul 2026 16:38:28 +0200, Maurizio Lombardi wrote:

> When a LUN_RESET aborts a WRITE command that is in the
> TRANSPORT_WRITE_PENDING state, the target core sets CMD_T_ABORTED and waits
> for the frontend to finish processing.
> 
> If the initiator subsequently sends the remaining dataout PDUs,
> __iscsit_check_dataout_hdr() catches the payload, stops the dataout timer
> if the sequence is final and finally dumps the data.
> However, the iSCSI target doesn't trigger the completion process for these
> aborted commands. Because of this, the abort path hangs indefinitely in
> target_put_cmd_and_wait(), leading to a deadlocked target worker thread.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] target: iscsi: Fix hang for aborted WRITE_PENDING commands
      https://git.kernel.org/mkp/scsi/c/d5869dae5080

-- 
Martin K. Petersen
