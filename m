Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2503C433EF
	for <target-devel@archiver.kernel.org>; Wed, 15 Sep 2021 12:51:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A850060F70
	for <target-devel@archiver.kernel.org>; Wed, 15 Sep 2021 12:51:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbhIOMws (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 15 Sep 2021 08:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233222AbhIOMwr (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 15 Sep 2021 08:52:47 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97BBC061574
        for <target-devel@vger.kernel.org>; Wed, 15 Sep 2021 05:51:28 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id g66-20020a9d12c8000000b0051aeba607f1so3351090otg.11
        for <target-devel@vger.kernel.org>; Wed, 15 Sep 2021 05:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/wPhzkGlnpuY/UGckcJundbhFyqD1c1DL4I0lY6uAKE=;
        b=GBcMS/S5umdEha7mRPgbh7fKb3ig+WenN8RO9yecfqpOBOEi21A0ox64z+MIRqM9kJ
         Eh/AOyux2rfUJCgWp2E4B52eMfRLKKMnUrCPyiMrp2koH2yskINeLOMAZUGEPpTTDva2
         jSvQiC9GzsCJqiJfnP32v0kHKw/CCF5/swTIs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/wPhzkGlnpuY/UGckcJundbhFyqD1c1DL4I0lY6uAKE=;
        b=pBa4l1uNw53ld2X3awDz6G7SbdDnDA/7DmNCpoG8lZzYiHl6R0LwepeHCdsjIFCgdc
         A/b9PswhqrD6wuSSInQYfB/6BmNzxc0er1yGHOY56hGe9HEmFr+7NCfLF6mpO3vFf+rz
         bYXPFKCHX4r9786TbrIieNZW+Bk73UDNwSVnkQS7F7zS3LEdz6VqvhYrCgoL8AIFYhBb
         84kzvf5OP5mOf1AjU2K1yQqez6fCPa6PVtGyVlCK7C0K+om1QdX15Nqa8nMLg5hLIQZu
         aSMVONRLOQGWLeagpiiAyirjwKZ58ZtPcNQRq/x5ZH+Y+BUAg7EQjX+7iQPL46dTCVIO
         AI1w==
X-Gm-Message-State: AOAM532XagwW9nK4OQgZGRexZ2WVu+WEZrgKxGO9/CBv9eqAjZIeQxVt
        Ghp6cSBWI1na9UDxyAt42wsQGbogI6UY46yg185mponkMYKhxnRf/b9gkn48qQ63WA3J59ZcNHN
        pbkiEELhuGWqIC0GC3yGof+kWFT7rv+Q=
X-Google-Smtp-Source: ABdhPJwI3iYGf7rQGXbc5TjTboSuU0oY8Am6GL426ERygGBtwCJgKFqFTIS7lNG7pZax1rz4QZlclu8e5nK9qRPO2Mc=
X-Received: by 2002:a9d:4e0f:: with SMTP id p15mr19227661otf.328.1631710286949;
 Wed, 15 Sep 2021 05:51:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210914105539.6942-1-d.bogdanov@yadro.com> <20210914105539.6942-3-d.bogdanov@yadro.com>
In-Reply-To: <20210914105539.6942-3-d.bogdanov@yadro.com>
From:   Ram Kishore Vegesna <ram.vegesna@broadcom.com>
Date:   Wed, 15 Sep 2021 18:21:16 +0530
Message-ID: <CAF7aS0qtcdu4Z4Jpvgdo8cTOLfecavO53-N5x79ytr+NFHT8vg@mail.gmail.com>
Subject: Re: [PATCH 2/3] scsi: efct: fix nport free
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux@yadro.com, James Smart <james.smart@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000001bc00705cc082886"
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

--0000000000001bc00705cc082886
Content-Type: text/plain; charset="UTF-8"

On Tue, Sep 14, 2021 at 4:25 PM Dmitry Bogdanov <d.bogdanov@yadro.com> wrote:
>
> nport_free for an empty nport hangs the state machine waiting for mbox
> completion if nport is not yet attached thinking that it is attaching
> right now.
> Add a check for nport attaching state and complete nport free.
>
> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
>  drivers/scsi/elx/libefc/efc_cmds.c | 7 ++++++-
>  drivers/scsi/elx/libefc/efclib.h   | 1 +
>  2 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/elx/libefc/efc_cmds.c b/drivers/scsi/elx/libefc/efc_cmds.c
> index 37e6697d86b8..f8665d48904a 100644
> --- a/drivers/scsi/elx/libefc/efc_cmds.c
> +++ b/drivers/scsi/elx/libefc/efc_cmds.c
> @@ -249,6 +249,7 @@ efc_nport_attach_reg_vpi_cb(struct efc *efc, int status, u8 *mqe,
>  {
>         struct efc_nport *nport = arg;
>
> +       nport->attaching = false;
>         if (efc_nport_get_mbox_status(nport, mqe, status)) {
>                 efc_nport_free_resources(nport, EFC_EVT_NPORT_ATTACH_FAIL, mqe);
>                 return -EIO;
> @@ -286,6 +287,8 @@ efc_cmd_nport_attach(struct efc *efc, struct efc_nport *nport, u32 fc_id)
>         if (rc) {
>                 efc_log_err(efc, "REG_VPI command failure\n");
>                 efc_nport_free_resources(nport, EFC_EVT_NPORT_ATTACH_FAIL, buf);
> +       } else {
> +               nport->attaching = true;
>         }
>
>         return rc;
> @@ -302,8 +305,10 @@ efc_cmd_nport_free(struct efc *efc, struct efc_nport *nport)
>         /* Issue the UNREG_VPI command to free the assigned VPI context */
>         if (nport->attached)
>                 efc_nport_free_unreg_vpi(nport);
> -       else
> +       else if (nport->attaching)
>                 nport->free_req_pending = true;
> +       else
> +               efc_sm_post_event(&nport->sm, EFC_EVT_NPORT_FREE_OK, NULL);
>
>         return 0;
>  }
> diff --git a/drivers/scsi/elx/libefc/efclib.h b/drivers/scsi/elx/libefc/efclib.h
> index ee291cabf7e0..dde20891c2dd 100644
> --- a/drivers/scsi/elx/libefc/efclib.h
> +++ b/drivers/scsi/elx/libefc/efclib.h
> @@ -142,6 +142,7 @@ struct efc_nport {
>         bool                    is_vport;
>         bool                    free_req_pending;
>         bool                    attached;
> +       bool                    attaching;
>         bool                    p2p_winner;
>         struct efc_domain       *domain;
>         u64                     wwpn;
> --
> 2.25.1
>
Looks good. Thanks.

Reviewed-by: Ram Vegesna <ram.vegesna@broadcom.com>

-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--0000000000001bc00705cc082886
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
Vxab43fOCbFozIOlzutBV4fhpWlA3FrVNhbPhbwO398TsV3gUkYHkxoS9kLeRXHnNcdOcFMo8Maz
mQF6P67d881N/0Tt0k0MfXGTHytZvfFdayivzlL9nAnyXTzPFU8CAwEAAaOCAdkwggHVMA4GA1Ud
DwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUu
Z2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggr
BgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3
Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4
aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmww
IwYDVR0RBBwwGoEYcmFtLnZlZ2VzbmFAYnJvYWRjb20uY29tMBMGA1UdJQQMMAoGCCsGAQUFBwME
MB8GA1UdIwQYMBaAFJYz0eZYF1s0dYqBVmTVvkjeoY/PMB0GA1UdDgQWBBQt2m9JVe4cejFw9Mog
spXwL7sKWzANBgkqhkiG9w0BAQsFAAOCAQEAARwXxUTPdWpdSOs12BsNVMRlHdaahp3UNv1LW20i
ps55UslOtXjHiznNQr5nyhmnkH0TLxn12NGEV0BnOmb70Ml2klfFLXTw73cp/mxM2eOZX5ho+f8v
TuqwzxbJ+WAoFHzMJfevy9SEdovoE1TeBhc+IgZQR3zCkMt00bsKvKD0SmgNKiSmkHr+WbJCjCq7
tlkydEDuGjuSfbNzIcS0qLpqIHaSh/3WmF7TWzBJ8Ln1HwrvuMZ3Txksjsmpt34GFSubX+CGrYyW
ORNGomSiW66FqRvj0iaYYbNTIfnU7/iJy3CN8Z5SvVroNAQbRfoooT/loWsoiUUNmTR9kebvLzGC
Am0wggJpAgEBMGswWzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExMTAv
BgNVBAMTKEdsb2JhbFNpZ24gR0NDIFIzIFBlcnNvbmFsU2lnbiAyIENBIDIwMjACDCHWmFjgp1UN
rBuhLTANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgyxuw7AEj4TdcLl4bx558QEgM
FwwdDbaK7MQwpoxbDrswGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcN
MjEwOTE1MTI1MTI4WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYw
CwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJYIZI
AWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAAo8myEgR4MUl7rCxQV8yhBkVzoms9AQh/oIBgACSC5l
flC4kAkmzX24RPTc3bZCCNKj5dhLVCcydWGqXsAI/pYD6wq4D0LnD7fyujn1lTIDLogkWkIAK3ve
ELh8l7Tqk4F6SswbUW/ega1P8hjgJthvOXBaI/Jow4P8v0g5ayTKpJMQjIfPBoMJR8GxJZPnhm/U
m/Rh1RCao50IEnThItu029PB7jXMwbJB/6HsKf8e2FDWo861+6lOC22dAucE63TjAlMiI4TDh8K9
FaFbRUqKG36q9sK5w1yydeSDpSv0xk8LwIftcDGScvtnkJltTxngydUQCpmVrt45QLePD1c=
--0000000000001bc00705cc082886--
