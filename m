Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3EB26738C
	for <target-devel@vger.kernel.org>; Fri, 17 Jul 2026 15:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784300890; cv=none; b=SmfpdkZIrg0pZt7w8kbtcugEUmfugcvA4Y8z841V/gz5FRaqyO6Z8wcbjgKnrXS2WmGGeRfCo/JsrlDxzQq+TktAlpYBkfCgXRK6cThf/fheqGl9EebqvrfwzsmkSKPg6Se/7cY5q0hHsFeyl5ZW9qi1/bgYEvyUr5VWFHuHZXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784300890; c=relaxed/simple;
	bh=9Q+8BKFJ7b1Ll9DkZrDOL1kJ7ReRPUUWgrPt67MspGg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gpnyysS9n/3+mdLyvwestROVKjcwJOxTYByqDLEBn7nfZ7gXrgSse6mfiJMv0SxZfpRQd5M/CkHROb2NnTtpS+H6xrmR2HaqLTMlTpHCHlxAUtY81p/07XvG2EB+cNMNIUWwEdrui+PUZW96PxJ7llS0DhJt4xsNiyI+wlAagNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KbiM/Bp9; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=mgfxq0Qz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KbiM/Bp9";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="mgfxq0Qz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784300888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9ZIGhUZrxmVDuGBkFKEnaZDUYKIYaKFItE8lWZZKNGU=;
	b=KbiM/Bp9D0hNocewTuB/4CAYIwyM7xIUosFOLhLhwnFSE3YHdo4bQ6GLTqXsZV2z9tkjAI
	GmNZkU0cILH8PQ7DHDKyaraE/RaUEMm86uY4tXXx/q6Vtwx3s21/chv9j920puuu9LHyq2
	PhwtjcppmKyi5XUyq4aVMrZasn3qAiQ=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-369-sUjGvT3UPtWAuSLQEe6-9w-1; Fri, 17 Jul 2026 11:08:07 -0400
X-MC-Unique: sUjGvT3UPtWAuSLQEe6-9w-1
X-Mimecast-MFC-AGG-ID: sUjGvT3UPtWAuSLQEe6-9w_1784300886
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51c1ada6c43so16160251cf.3
        for <target-devel@vger.kernel.org>; Fri, 17 Jul 2026 08:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784300886; x=1784905686; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=9ZIGhUZrxmVDuGBkFKEnaZDUYKIYaKFItE8lWZZKNGU=;
        b=mgfxq0Qzr8/IjIbM8EJe2p/e5lVJgLnRQUbtoARyJZqa90RhUTfUxPcNlpuZfcZXaH
         vzMUTeUsHS+HRSg753NwGXh7FjHsYxmcbOVs3TJaty1DcvW5eGTmS0zgM9CwconILdrl
         CKyGFNKbBHdaijhK04gqwH6ux57UbiYUpWEc9DD0usmBMytXiSLK3hL5WCidy1fv/ETd
         SUnm6CvglIzuMqdpgBwOjZj7RgFhP3xzjaCpaRF2ReioU6fV4SzEX1kXL/aD9fMdQvQq
         KNNp5YHzlvUykDxYvQRffmFnrL+lrmWebOBDGiHFB94xQb9dXNWshcH3cITRAwATRkyi
         X1OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784300886; x=1784905686;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9ZIGhUZrxmVDuGBkFKEnaZDUYKIYaKFItE8lWZZKNGU=;
        b=TgOZak8drD7YqdeGG5cFlcrAec1u3n6AcYPeldnllZe3NJVUpaFjTCB3PTTBforF7/
         6MUcR2MzjLwn+Hskb9xLn1VWtj5iB6utTqaM9dXzDYVKxm4Bi9RrsdnH4q4RNtkSVDxl
         on9JHh+LZxYyvCOd6BJ77hsHJ1lP21BGKf9r64LR0s31ggkpTEtlNk1SzC4tnlfu7npd
         CEV/H9OpUEMGWyI2f4a+p9J/kr21RXTHIEqu78ARdnk4I0VAioJxJx6KlQW9OfJdILaP
         0s3UGXl+6pZEg4ij7XN1Si7PQk9YvahKUZHVQfBPkbujzQlr6E/rfLXRJLNGDX4X7ecn
         pknQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro+q4ZVbZsCsNcjAI+QiFHww0PBMm+2Ks8ssNeJ5frnVnq1vmxESDck6w8DGTDHNU6Uic12in/t5+6ZLBI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJGpoqgJHtFcGs4coWGBc34Y+ZrlfkTTu7VHdliztY+F10v/Ki
	dt9ZX0cynyKGGmdA4pAJCaglomKKyAR/U6I8A6rsDMvDsMF30S3yRD+UUG0DO2Fump/JyNfIefa
	lanU8Ti6+9KFL0E3i6s1/b8aY50+8HlS7x++we26nliMKwEe+3He6EyK6Y/hJqXt4aA==
X-Gm-Gg: AfdE7cl3eLnKE9YVyrWwHc0PayLMsG5IHTKaC+UIuqZmljEERPDBVGWXaz6QMX1BlKt
	Ep0SBEtJBmtuIqWqoXkp0pTOB/ZYWUk9nZEPtioaXDzXKe8XqvvCn5/tjeFU4vmandxLSF3uRFu
	/ieUIUkf1eUsJul+R+MQM1SQ4Id7v07PdxKgapnB0VTN1AoSObdQJboUmt6SoMc2u4GvYCuuT6p
	PxzwqSvJzFTjEZPOoY1wi0CwZyq8uig+8wlji/BTK+0Xdphlpa0VE04awGYwnw2hJn5Jywrksu9
	yctecqZw5IZRsV/NP5RNOmlMbBCSd5XP14tia3FXZXn5y9OGQsUPl3JmfKTIK2yRT8JXPuuR3bw
	kZIhJiI/NgXHRd10aFm86vLuFK8Zkoc8FRee3
X-Received: by 2002:ac8:7d16:0:b0:51c:b91a:3406 with SMTP id d75a77b69052e-5213cfc590cmr28504541cf.75.1784300886274;
        Fri, 17 Jul 2026 08:08:06 -0700 (PDT)
X-Received: by 2002:ac8:7d16:0:b0:51c:b91a:3406 with SMTP id d75a77b69052e-5213cfc590cmr28503681cf.75.1784300885411;
        Fri, 17 Jul 2026 08:08:05 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:dbb1:97f1:a6e6:766b])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5214f0162a7sm13620411cf.15.2026.07.17.08.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 08:08:04 -0700 (PDT)
Message-ID: <5bf0b6088edae251c23750497b6e334405f3b6b7.camel@redhat.com>
Subject: Re: [PATCH 1/1] target: iscsi: Fix hang for aborted WRITE_PENDING
 commands
From: Laurence Oberman <loberman@redhat.com>
To: Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc: mlombard@arkamax.eu, michael.christie@oracle.com, 
	target-devel@vger.kernel.org
Date: Fri, 17 Jul 2026 11:08:03 -0400
In-Reply-To: <20260717143828.76291-2-mlombard@redhat.com>
References: <20260717143828.76291-1-mlombard@redhat.com>
	 <20260717143828.76291-2-mlombard@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-07-17 at 16:38 +0200, Maurizio Lombardi wrote:
> When a LUN_RESET aborts a WRITE command that is in the
> TRANSPORT_WRITE_PENDING state, the target core sets CMD_T_ABORTED and
> waits
> for the frontend to finish processing.
>=20
> If the initiator subsequently sends the remaining dataout PDUs,
> __iscsit_check_dataout_hdr() catches the payload, stops the dataout
> timer
> if the sequence is final and finally dumps the data.
> However, the iSCSI target doesn't trigger the completion process for
> these
> aborted commands. Because of this, the abort path hangs indefinitely
> in
> target_put_cmd_and_wait(), leading to a deadlocked target worker
> thread.
>=20
> Fix this by explicitly calling target_complete_cmd() when the final
> dataout
> PDU is received for an aborted WRITE command. target_complete_cmd()
> detects
> the CMD_T_ABORTED flag and cleanly routes the command into
> target_abort_work,
> allowing the abort completion to successfully unblock.
>=20
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
> =C2=A0drivers/target/iscsi/iscsi_target.c | 4 +++-
> =C2=A01 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/target/iscsi/iscsi_target.c
> b/drivers/target/iscsi/iscsi_target.c
> index 62ada3a52210..124ff269b8e7 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1533,8 +1533,10 @@ __iscsit_check_dataout_hdr(struct iscsit_conn
> *conn, void *buf,
> =C2=A0		 */
> =C2=A0		if (se_cmd->transport_state & CMD_T_ABORTED) {
> =C2=A0			if (hdr->flags & ISCSI_FLAG_CMD_FINAL &&
> -			=C2=A0=C2=A0=C2=A0 --cmd->outstanding_r2ts < 1)
> +			=C2=A0=C2=A0=C2=A0 --cmd->outstanding_r2ts < 1) {
> =C2=A0				iscsit_stop_dataout_timer(cmd);
> +				target_complete_cmd(se_cmd,
> SAM_STAT_TASK_ABORTED);
> +			}
> =C2=A0
> =C2=A0			return iscsit_dump_data_payload(conn,
> payload_length, 1);
> =C2=A0		}

This took a long time to solve with many attempts that did not help
until Maurizio's solution. This patch was tested fully at a customer to
fully resolve the issue for over a week with no negative impacts.

Looks good.

Reviewed-by: Laurence Oberman <loberman@redhat.com>

