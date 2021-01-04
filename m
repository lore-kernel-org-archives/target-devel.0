Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C5ADC433E6
	for <target-devel@archiver.kernel.org>; Mon,  4 Jan 2021 16:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 369E720578
	for <target-devel@archiver.kernel.org>; Mon,  4 Jan 2021 16:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbhADQHj (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 11:07:39 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53948 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728716AbhADQHa (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 11:07:30 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 104G1c8W160756;
        Mon, 4 Jan 2021 11:06:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=XP2NgddM/WrYYdKPAGZP2evPECnBpY2OuFrOwbIfmIM=;
 b=Gn80gsEYtDthijcKQR91aMrdEZM09fk5VY4xe7t+r7C+/D6Ax9CoRVZnvr+TtoRF6AFq
 nAbXrb+/H5n/nsKd1oNWGp4/BfN25WfD5Llm7OF5HNzRSFZEIv85HVVIVaOCKHieTuDg
 I7arwYCM+T5U8kmdk5xxVO50AmT64n2TMtTqggB7Hrr3JsLJBB+asYbJrSH2tGlMp0PJ
 Ny3SkU+zF7wjUvJEwpnYLRV9ocWbyFi+n+OYNtvdYVlt7EgqExrg7uj6uMRYY8eLff//
 I8BHtGrupulNsWUK1xUydsrvJ0isgP00LIkT1nW3i7NHqf0wMVzjZjd7xe8tDO7lIim3 dg== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35v55w23fa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 11:06:42 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 104Fvo5b026242;
        Mon, 4 Jan 2021 16:06:41 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03dal.us.ibm.com with ESMTP id 35tgf8k0dn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 16:06:41 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 104G6elS11338032
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Jan 2021 16:06:40 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2970D7805C;
        Mon,  4 Jan 2021 16:06:40 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04A277805F;
        Mon,  4 Jan 2021 16:06:38 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.85.172.80])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  4 Jan 2021 16:06:38 +0000 (GMT)
Message-ID: <92ab516c9493accb64630e7e86033a87be018458.camel@linux.ibm.com>
Subject: Re: About the tcm_fc FCoE target driver
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Bart Van Assche <bvanassche@acm.org>, target-devel@vger.kernel.org,
        Hannes Reinecke <hare@suse.com>,
        Mike Christie <michael.christie@oracle.com>
Date:   Mon, 04 Jan 2021 08:06:37 -0800
In-Reply-To: <f5808b3e-0434-9d8b-93fe-94d48d657926@acm.org>
References: <f5808b3e-0434-9d8b-93fe-94d48d657926@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-04_10:2021-01-04,2021-01-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=858
 suspectscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1031 malwarescore=0 mlxscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101040101
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Mon, 2021-01-04 at 07:51 -0800, Bart Van Assche wrote:
> Hi,
> 
> My understanding is that the ft_queue_data_in() function in the
> tcm_fc driver gets called while processing SCSI READ commands. That
> function queues data for sending by calling fc_seq_send(). The FCoE
> driver translates that call into a dev_queue_xmit(skb) which sends
> the data asynchronously.  ft_queue_data_in() frees the data buffer
> synchronously from inside ft_queue_status(). I believe that this race
> condition can trigger data corruption. Since nobody ever reported
> this race condition, does this mean that the FCoE target driver has
> no users and hence that it can be removed from the kernel tree?

It could just mean the race condition is so rare no user has ever
triggered it reliably enough to report ... have you managed to trigger
it?

James


