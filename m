Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43FB0EE49A3
	for <target-devel@archiver.kernel.org>; Wed, 23 Aug 2023 04:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbjHWEYJ (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 23 Aug 2023 00:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbjHWEYB (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 23 Aug 2023 00:24:01 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006E6E58
        for <target-devel@vger.kernel.org>; Tue, 22 Aug 2023 21:23:57 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id e9e14a558f8ab-34ca22e3b3dso11024185ab.3
        for <target-devel@vger.kernel.org>; Tue, 22 Aug 2023 21:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1692764637; x=1693369437;
        h=cc:to:subject:message-id:date:thread-index:mime-version:in-reply-to
         :references:from:from:to:cc:subject:date:message-id:reply-to;
        bh=z1fFs+lnRruoiOyyr7E1duaOVZKhsH1f+mX6Ch+BowM=;
        b=UBtXToa0pLAzad99DMQL2UQf91+YKdnGg8MZLAebfc2TiE36HQu3pt+3CkZElZqpVJ
         ewRZtwQMPXwvYaLjPptm4cQ0yoNsrWSj8eXCFCqigR2N1dy1exWMx0dQXzrIjvasitC5
         RgVjSeAKqDpvxdYPdY9TWybRw9n9Ng97whGdU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692764637; x=1693369437;
        h=cc:to:subject:message-id:date:thread-index:mime-version:in-reply-to
         :references:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z1fFs+lnRruoiOyyr7E1duaOVZKhsH1f+mX6Ch+BowM=;
        b=c8GkT4CGYlWCwZXBUzkSOUgLcQYWGABQd9xo4bGbN5DOXS9Vw73Avitz1O5yB8cweo
         QqC1hBcF2eB5rj3BEi45qSEtdXGASJ5uxpL/C5y7AF+j5eiGb8Na0Oae2dUg6HwW1q2T
         v2SAG/MVBBxy0cJyenzPXG0P278BMsYQg+VIeqbx9t9f4YrLG8LejWSE+rmT1FZ6vdtM
         M2rYkqdIMVJip83uKntzSM+0sdIhGXJbK3zjxUcVgIyidMrCfWumWqBT9wlB3I7v28ds
         /P4TP9unnZ2+iVoswPYxFiJQhqGuhLghqzLqeWDqSg3wVq06ZiKk93PZxZZxb0Bomt3U
         71tA==
X-Gm-Message-State: AOJu0Yyn0C+GfT+L981gAK6JV9tEwC1yH7W5UPDIBvFcJ2BVAsOldWcJ
        SuJ6wneFMnzLDbnmX5pmlz82uHOjzy4WlAH6RYl1yg==
X-Google-Smtp-Source: AGHT+IEsNs8hOs3fOyhwP1HMyY5PYxlsMlrmHt/ZMq5FEO2PpVOCIg4B013vL4Cq4vcZ5NzN1K2RCSoMA4l0HN7VxbA=
X-Received: by 2002:a05:6e02:e02:b0:348:8125:acd with SMTP id
 a2-20020a056e020e0200b0034881250acdmr1448643ilk.27.1692764637262; Tue, 22 Aug
 2023 21:23:57 -0700 (PDT)
From:   Saravanan Vajravel <saravanan.vajravel@broadcom.com>
References: <a27982d3235005c58f6d321f3fad5eb6e1beaf9e.1692604607.git.leonro@nvidia.com>
 <38350699-ce4c-4298-8ebf-c9c6b5a72c2e@oracle.com>
In-Reply-To: <38350699-ce4c-4298-8ebf-c9c6b5a72c2e@oracle.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJUpkyY4JkGVHQVNbDj8t6aTN99owHUgEfZrvMCIYA=
Date:   Wed, 23 Aug 2023 09:53:55 +0530
Message-ID: <585c99d058aabfafaed44a1bb5645423@mail.gmail.com>
Subject: RE: [PATCH rdma-next] Revert "IB/isert: Fix incorrect release of
 isert connection"
To:     Mike Christie <michael.christie@oracle.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        linux-rdma@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        target-devel@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e98e4006038f7a09"
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

--000000000000e98e4006038f7a09
Content-Type: text/plain; charset="UTF-8"

Agree with you Mike. I came to a wrong conclusion based on assumption that
kref_init() is initializing the refcount to zero.

Thanks & Regards,
Saravanan Vajravel
+91-80-46116256


-----Original Message-----
From: Mike Christie <michael.christie@oracle.com>
Sent: Monday, August 21, 2023 9:56 PM
To: Leon Romanovsky <leon@kernel.org>; Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>; Dennis Dalessandro
<dennis.dalessandro@cornelisnetworks.com>; linux-rdma@vger.kernel.org; Sagi
Grimberg <sagi@grimberg.me>; Saravanan Vajravel
<saravanan.vajravel@broadcom.com>; Selvin Xavier
<selvin.xavier@broadcom.com>; target-devel@vger.kernel.org
Subject: Re: [PATCH rdma-next] Revert "IB/isert: Fix incorrect release of
isert connection"

On 8/21/23 2:57 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com> Commit: 699826f4e30a
> ("IB/isert: Fix incorrect release of isert connection") is

Was the issue described in that commit just not correct? Or was it supposed
to be for some sort of race'y error path?

It looks like that analysis was wrong for the normal login/logout path where
we call:

1. isert_init_conn sets kref to 1.
2. If we are connected we set kref to 2 via isert_connected_handler ->
kref_get 3. When we logout from there then isert_wait_conn -> queue_work
release_work and release_work does isert_put_conn so kref = 1.
4. Then we do isert_free_conn which does isert_put_conn to set the kref to 0
and then free the conn.

So the patch in this mail looks ok.

I checked most of the error paths, but I might have missed some. It looks ok
for them as well.

--000000000000e98e4006038f7a09
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBV4wggRGoAMCAQICDDPW1cVntFGljCZAOzANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjA5MTAwOTE0NTZaFw0yNTA5MTAwOTE0NTZaMIGa
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGzAZBgNVBAMTElNhcmF2YW5hbiBWYWpyYXZlbDEuMCwGCSqG
SIb3DQEJARYfc2FyYXZhbmFuLnZhanJhdmVsQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBAOWUDY8+1Pq6qzzsf5oTzGO7etyb0HT08NkGz7Ymb6gL2BcSxf00xj2f
fgOR3x1R5vZCQL+NXGnk27IMYe6P1jT2e49wq24CtJxpjbdCgiY+wM0iowrqj+xHJyGEyFK7BEOB
1cEV+/7fNvlT+wzsiB6LI7YO2jnJoqRyxiuCXWXQteLT5u5dJd79gUxenL2sOdzc9QDElI3VQMfh
lU2WOYSpsHwmuzI2n56f4qqAd0KTzesYpT4jUkHrpARqokmK62nwak/mVjpP1xxKkerBRTDplTRj
PPaP6wQe1OY7fOWrqgKUrMkQ8uzH68KFHiA/+zIzyFmYwY+S3kdoi+SvK08CAwEAAaOCAeAwggHc
MA4GA1UdDwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9z
ZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
dDBBBggrBgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFs
c2lnbjJjYTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBz
Oi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+
oDygOoY4aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MC5jcmwwKgYDVR0RBCMwIYEfc2FyYXZhbmFuLnZhanJhdmVsQGJyb2FkY29tLmNvbTATBgNVHSUE
DDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU
0Bq3qvsz+PB5FAu5iL1KRdtSBTgwDQYJKoZIhvcNAQELBQADggEBAHXOk8r6/lLV2Fb8uE3tUP2E
MFD67H9X0roxhLywKzY+SM6abiUqsRxlcBwNgp0r/SwFG1o+frLlj7gynwfkzfsRzLRf//DYTUOF
qs8Os28DFCa/KvX0e56+c7xOOP9cwgHO3Tl2ri3MAGpxEB5r4PcgmWd4f9zmlmBGE9oNyoyntToB
pb/Gi74xj8wc5zCrVpXS1UNVJ8B6Jib+vas1cAtL6RFi0RDtFbUXe9U4wB07Ker1yMtBA6QzfZW2
d0VRyjqv9NL22cjJ4ffotr8ZKbiSVEHbnDRxAgeuMxkkpjQQk/y1S1fk0wDOYNfV0zIkWtVMNBzY
Ttmt2pp+/hwLYVAxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
aWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAy
MDIwAgwz1tXFZ7RRpYwmQDswDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIAyerOar
R8tAx3zS491ZLdCIM+4x1NdfKQOevGIMbPasMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTIzMDgyMzA0MjM1N1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAZmddC9+I5bDyILfw5BFYJQXb/
A1HLqsL1+wpVVQ5C5f+fbiPo6Xivhsda1KR2LN3LufEdRLk1oQoR6NiJ6wUpF6sp8Big0unrSLWo
kBJWIeihgRZ6r5CQNAzXfE9qECGmUz1nD2iX5LGavJrb7VfUZeeMfy3ex2JVia4aUuFW1CP4Y5aX
q1ZbCaGvlsJctj+63fr0ZsY3NGpH3S/9L/ti+MYVJkyuQPJZX1K5bqB+GhlI4Pnl2Zn7m/UkJJRI
XufsUCV0kZBLc0LXw6IMB6UTZ49GCCFOGNQBgqkOT97W3u7aS4IAk5BXVexxPHHS5jJ+k9Iuegp+
9TL56ljIjaPl
--000000000000e98e4006038f7a09--
