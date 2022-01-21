Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21408C433F5
	for <target-devel@archiver.kernel.org>; Fri, 21 Jan 2022 15:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381509AbiAUPVe (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Fri, 21 Jan 2022 10:21:34 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:23976 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1381510AbiAUPVX (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 21 Jan 2022 10:21:23 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20LDE67U020375;
        Fri, 21 Jan 2022 15:21:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=Pj+GVAkp8XRzMDlZTCc0U0wclV6qWIL0WUjA7hz9VNM=;
 b=SNRlu4lgOl4uSBIoUq9BynPLaJX42KNKG0vdY5nR9adQQ3iWmw0mdTV28cgnf/iGxjtr
 lkeNbm9FZNOtgdlud/KZe4mFr00dM1p8P62yzOwQBpZconjyq20K2OMuugPP3kASIwON
 iVqHGbjvgj8CYJHAo3FMZR++1O1+wD5clBlAlZiK6ZsTExV0EwbpNxYxp6OixO6/hYJA
 8Q3ZfQPVGyAhKwIDhYTD6uU6ogzHt+lDgiakGsXY43PaY1l149oo+fY9cgNiohn5/zg4
 /XKcXVmO6/OJtR/ogD7lA/7B1f1HHEiL83jgbwl1DVC+5RqSFMZ25fRXiXT6LeFPvsjs yQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhychmmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 15:21:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20LFGiVK033058;
        Fri, 21 Jan 2022 15:21:14 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3030.oracle.com with ESMTP id 3dqj0w1qd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 15:21:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LNhLhTje53LXhsKbbHxDKEydmkEVfH7CHMfTuXg89XicTDwWdeR5cWuO6rc/+j5wv35himX6WSEgJIS02y7Gn9VFOUSeUcb7eqSDvDZMfR+uVp6XyUI8xbADnPmO78x9FIrAS5ci6AbeKo+cF1zR5Bm1QRJ+10kjpeZ2EDsYnRw3Hk84H137bwtd0ixB9yWRqCJoz5CmaX7K/wXTdbzqTOn7FI/tXOCAWhlCt3Up9/CvKG89EAzSLGPOVfP7WXHoKYX3n2iPmjPltLMQ/5egKh+nPPgl9xpsPYv7rgqp8Xt2ye466y2HxRaVnhHtIllLHVPouuFkDs5o1XF8Ds9QBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pj+GVAkp8XRzMDlZTCc0U0wclV6qWIL0WUjA7hz9VNM=;
 b=JTxV9efoZQUzFcFYuFeTk+4OOvqaFxF0sX05KWydLRlbgm1D3JENMxLqaMv1vQxh/CW8Dc3PRLdG80gyDmBqx9XtXnWQag/1LnHycICGpZ8BroDZoZwQrwxj4VOJpvk+KmZK++lfYeYkFtpWfSzBFSVlk3mttlU5zEJtJafLEUmc/tlRf8GDZ56BbC7D3JDOcSPHN/EoJrmzJ8vZ+fCwQEPVmuKMLeGWiJW5o22JnKfSmoYlWW/ZTp0eYKzUCJSO/7DFPqAnjfjU+0wJTn3sH/jYufoDbTwMWgaKTwHtpE3BZLK15/MX+SNrvq8mXAKlTmeD5vkVVg4Ss71/1CPE9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pj+GVAkp8XRzMDlZTCc0U0wclV6qWIL0WUjA7hz9VNM=;
 b=YqBmCjESNVEDOxSmQ/X5JkT0UaSAmiQOCIu9Lz8mSefveX9wLucBBlIZpzBQd3CpZaU/e1KzRqtotZRC+RT56WE3J9yEon24VyGHwDNsndOhIgoKeAp2xCZfXW1BSVo5QFhLJY1l4n+7sh6rjj6LkwnZ3U3TcYQD3KoS8H+AVqw=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1565.namprd10.prod.outlook.com
 (2603:10b6:300:24::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Fri, 21 Jan
 2022 15:21:12 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::c13b:5812:a403:6d96]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::c13b:5812:a403:6d96%6]) with mapi id 15.20.4909.012; Fri, 21 Jan 2022
 15:21:12 +0000
Date:   Fri, 21 Jan 2022 18:21:01 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     varun@chelsio.com
Cc:     target-devel@vger.kernel.org
Subject: [bug report] cxgbit: add files for cxgbit.ko
Message-ID: <20220121152101.GA4116@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0016.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::26) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd6cacd5-36fe-4b7e-ee8e-08d9dcf1a88c
X-MS-TrafficTypeDiagnostic: MWHPR10MB1565:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1565CBBB92D41BAE0C62B5818E5B9@MWHPR10MB1565.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /SwxW6+mMoihdLcC1K522Lf6gC2+AccNksS3IIDmuv0PPUZMP2QcluD2la0jqBw8I8EKkMR2Hvwr2ACXhsAC/FQMKKoP+2P2MaWZLtH+xDSl3MFsHs3nhAmS0p4ERmOk2t+n0D+yVi7ASiP4X6PxJnUMvmlxG9wfFXpOjVfuEBAvXpZXOlrOkA3XTvkAoTB0ZDxd6ETj32NzZFQJLeoUSW9GklDXl6XRbC9RwC4+hyrU71gXLhwT7pv61Mpi5Y7X6KKxYNb5VCEOGNha8LU+PB3j6kV51b5y370iZgFXWco7LUBIYY0Me8lEzWjwO3agn7OHho3rcn59nSnF0OFMm4P+/LSQTmZjHkmPRc8j7ElKwtAfw2gOSUUZPeSLJR+WvjgdlhmdzvA09VFPAJOMglTBsAsB3CwcZ686x9+AcSMPM/gOVtYhZHotccaq4/YS3h8GEmZKgPg/e75oOmkFh3K5ft842gNU9ZBhDypM2rRdZ2iJ+PRvwpNAgIy5+V5CYbnTHAo7uuQfmAbkq/upEDfMf7y794WpzFa7pp5ulHSIfATueCvtimotHy94hSE414SxIzpXVKlT1uuoeyfW4gOKSGieE1mA+uRPiXfd4zYvtZWK0nX5IwhbkvqvuKCXoF5IyU4i2JfO3YBoS4y2vATLGC0ViXOEKnd62zQ9KPo2+y8Y2e4Lzs98q1uGO1WmT9fSscp41Nj2HJoi9Tc7hA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(1076003)(2906002)(316002)(6916009)(508600001)(33656002)(52116002)(9686003)(6666004)(6486002)(26005)(6512007)(6506007)(4326008)(66946007)(33716001)(8936002)(66556008)(83380400001)(86362001)(38100700002)(66476007)(44832011)(8676002)(38350700002)(5660300002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jn3iVhehpZ2RAaHFhkPAYMDLhT+2c7wq7psgJuxtAFoc32zN5I6ogL3bNpop?=
 =?us-ascii?Q?4FPebS3q7DeFFx7it2V6uLblBt576ouHawfJc3IztV17J59dm7GU1xK+QiCM?=
 =?us-ascii?Q?jpYEL4UqD9e3lBKTkGjYrKVradbVPJmhlhLn5r6zSQznPJ/o56CrR0Btg9q1?=
 =?us-ascii?Q?mFVME/ZUBpj6j7uslZvToBOv1V7KWK7y2gILNrB85SmgpHimpq+giRbAzo5E?=
 =?us-ascii?Q?UR9W/nAZLqaXKbvLvHBCT33qtVoIHynGUjRZKScq8KkZ9Sx8IrEdV8TSgzS/?=
 =?us-ascii?Q?+DsIfu3aSWWZOmQECi2V/FctdGIyC+BBbTC+HpGipbcc2+wO8awNWeL0JolB?=
 =?us-ascii?Q?WZASH8ianZsgWkxyYMz+beryhlBLkZ1Mh+345bxn2+R8gS+WYzDmoYgIBFKN?=
 =?us-ascii?Q?uyTckbwMIjdNiQuxdwH4R8kNVb3ZALvsT3r5CpIFkwVLYx9hBkojqBdHHyIH?=
 =?us-ascii?Q?EcnfP355xirnRAKG2DuMrI/C1/sSv37frVWYCJ2l/nNPrWfxb+IxDmKWvwEk?=
 =?us-ascii?Q?qnBZoi1+Nl1WQgAsR+xQon95YrPp0YgFX3t08wvCPPNpX7/RZsWAz7Crd8Xx?=
 =?us-ascii?Q?g9VfAlm1ZL5qi0SLA/5Al0sbTMlTuKBGFSPAnWnSRbrPxubVPBzCO2c2/F+F?=
 =?us-ascii?Q?BJLsSMSDYkSSCtwvEDrdMvF4seT9WpG8lReqgBu42XsKvqNPBCcI8bfl82Hx?=
 =?us-ascii?Q?py2+0b6Eiq5wjB365h6PuAImwW5h1VxaVgyreP4i9lEutuFrBlyAKwL5zKoc?=
 =?us-ascii?Q?ffj0Ezz+t8xT7HFfVhf1QX5ln3m9TLSTTa1JV2v3D0+ImT+dwSsgQqki7y9J?=
 =?us-ascii?Q?yZhzUHX6g7tBpvCx18fEGHVkhGpLMC5rjqt1NBWcxfw+sfgJ/GSZJkKwKG6I?=
 =?us-ascii?Q?PXsD7g4Ej2o/ol5iEdCIcwObAnH+dWfOjTJsBtJkKwvAxG8joCxnMklZeh45?=
 =?us-ascii?Q?Zh1xVfFvTfTgnFkQrmLYOaImFcFmtaMGgu1FymUyAloZ42TA57WsGA5OerFN?=
 =?us-ascii?Q?e37D5rvMSiXL+CIpI2EkAlWaZT3a937UGtPgpbMzz26qtgSN42kuHH5ioDcB?=
 =?us-ascii?Q?C2DlrEYiHTFfbq++TGz+TMCHs7lClEQjxYb4ycWkyGKHD+hr5j4SyNiPCy6e?=
 =?us-ascii?Q?sSpItMuAsMIyGXD/BKO4ZfI5hZHs6xjPBQ0Ueud2QmrtZycPw+N12ABSZCJD?=
 =?us-ascii?Q?+UHQHxILmhUAnIl4MffANbyiXVfiCUSKp7mNAqtM0fke9zv2pjLKnyEhkzt6?=
 =?us-ascii?Q?dCwh0Qvq5HQZfjfLBCZuDF4P4sT/0gPYTSQlbxG5ivQfzTaKWxVElj9jFKRx?=
 =?us-ascii?Q?QB/JDL9FPR0CjIdMmkSvIrpAGXv8zJ/enVUcv1PSXPTPiIVYMs5Jp1Y0JFpl?=
 =?us-ascii?Q?4wt1Dx65x+Jr5+Tg8wSnxamfHhLhl7dNdhND5B1l3IlHMHG0kr86SnNohHEe?=
 =?us-ascii?Q?M7yK4RetN1Uf59JR1JeN2NwlsfpfcwQiY0W46/Dw1r34PQ1xfUnl/1qFVNht?=
 =?us-ascii?Q?6SWVMJYyot78GSYHx60ff+FJlCzgvp3i8Q/U2YgsitvlyNuOJAis70zraCRs?=
 =?us-ascii?Q?CcCOF1RMPvoaNhR0sHIP6lnJS1PSeZKGXrs3Bc9K267TiJH2g2hkSjo/YVwq?=
 =?us-ascii?Q?ggbUdB1ut07CvPuGROCB5yuYt10OQPVrnNYSvOVf53AFSQV8PpqGSd+bceLx?=
 =?us-ascii?Q?qFfHF/Cx4+87SC8uevh0GFOwvn0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd6cacd5-36fe-4b7e-ee8e-08d9dcf1a88c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 15:21:12.5954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9zejCHZ+FApiJu5c4iYOxGt63D//wzAlnc7gpyUi3H6R6gZ6O8Sh8ogszVmLacXnaGAQImZKeVZCY/LpNgjqDdJsTcWV5zuCm/pgMHH//VA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1565
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 mlxlogscore=857 bulkscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210104
X-Proofpoint-ORIG-GUID: 7N7HRdxdQu_5T6AGKxqlXFUCeGydy2yE
X-Proofpoint-GUID: 7N7HRdxdQu_5T6AGKxqlXFUCeGydy2yE
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hello Varun Prakash,

The patch 9730ffcb8957: "cxgbit: add files for cxgbit.ko" from Apr
20, 2016, leads to the following Smatch static checker warning:

drivers/target/iscsi/cxgbit/cxgbit_cm.c:561 __cxgbit_free_cdev_np()
warn: inconsistent refcounting 'cnp->kref.refcount.refs.counter'
  inc on: 548
  dec on: 542

drivers/target/iscsi/cxgbit/cxgbit_cm.c
   517        static int
   518        __cxgbit_free_cdev_np(struct cxgbit_device *cdev, struct cxgbit_np *cnp)
   519        {
   520                int stid, ret;
   521                bool ipv6 = false;
   522
   523                stid = cxgbit_np_hash_del(cdev, cnp);
   524                if (stid < 0)
   525                        return -EINVAL;
   526                if (!test_bit(CDEV_STATE_UP, &cdev->flags))
   527                        return -EINVAL;
   528
   529                if (cnp->np->np_sockaddr.ss_family == AF_INET6)
   530                        ipv6 = true;
   531
   532                cxgbit_get_cnp(cnp);

get here

   533                cxgbit_init_wr_wait(&cnp->com.wr_wait);
   534                ret = cxgb4_remove_server(cdev->lldi.ports[0], stid,
   535                                          cdev->lldi.rxq_ids[0], ipv6);
   536
   537                if (ret > 0)
   538                        ret = net_xmit_errno(ret);
   539
   540                if (ret) {
   541                        cxgbit_put_cnp(cnp);

put here

   542                        return ret;
   543                }
   544
   545                ret = cxgbit_wait_for_reply(cdev, &cnp->com.wr_wait,
   546                                            0, 10, __func__);
   547                if (ret == -ETIMEDOUT)
   548                        return ret;

Should this error path put as well?

   549
   550                if (ipv6 && cnp->com.cdev) {
   551                        struct sockaddr_in6 *sin6;
   552
   553                        sin6 = (struct sockaddr_in6 *)&cnp->com.local_addr;
   554                        cxgb4_clip_release(cdev->lldi.ports[0],
   555                                           (const u32 *)&sin6->sin6_addr.s6_addr,
   556                                           1);
   557                }
   558
   559                cxgb4_free_stid(cdev->lldi.tids, stid,
   560                                cnp->com.local_addr.ss_family);
   561                return 0;


regards,
dan carpenter
