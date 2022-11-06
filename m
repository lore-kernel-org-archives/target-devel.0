Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8AC2C433FE
	for <target-devel@archiver.kernel.org>; Sun,  6 Nov 2022 00:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiKFANL (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Sat, 5 Nov 2022 20:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiKFANL (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Sat, 5 Nov 2022 20:13:11 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC1E12AE4
        for <target-devel@vger.kernel.org>; Sat,  5 Nov 2022 17:13:09 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A5NmOLH003720;
        Sun, 6 Nov 2022 00:13:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=3j5HQ80qzKZ7XEs+RbE1FRV/ow25IrvaZBdNuuKzHyE=;
 b=DSpwMNBkLLZaArk0cWTW6eRs8uG7qJSjw2bwwubzVW2eANRcq6Q3rXgcshuSGKfLGaHS
 SNArM6VshLaavja+9unB4ssqc6UUXuYWw465WftnFg0wN/WjYoNDOIS2DVPmolqC8izd
 ZBcvOdgXe2EaK3yu5BLuvrBT/Lf8hozKAHq2WIMj5DQCBy67X0mCFp7zPferX1b7utdU
 adCvVA+M/i3tRGKT4uau56WBgNoTCNHNZGb7WPLdABCG2pH9grdVSsKjQl4QlBgR+hEB
 CUHWXLDGIdBm8PbGOL87eq0CoZdyEGSN4OY6dH4lcOPAIWTJ6hPElu7mTOvL8xgSYf6b mw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngnurvnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Nov 2022 00:13:07 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A5KwcdL035593;
        Sun, 6 Nov 2022 00:13:06 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kne928tj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Nov 2022 00:13:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KmMzbRdwS8OS4b1F9LnnS1F9CFLE32nYoeMN4zRu83lUwbBKDXOWPvYktmeQ+D0TIrcyGu+YVSZqenFMabDkp/1IfKb5G4zXqII6JDQjAZmYawiqpUxdyzoDzCbangMNXhgCzNGeDRUabbMX14Q9bRTw8NTY7a8/xi+SSh33//hkNH07ninGHfGQnDjjyx/ipzAPIbz//UhEaCgIy8RX0xMVZ4LzVVxFnduQHLxTbmKaKVOTmqlHe0U7HC+dEptw10fyrco5sFr2hLJfFYtMXsXtMLmIOxXZO9wjYLeQFhAa9+sRqizqUE/QxQ9Ro9xJu0CTJld9tut7BhLRitAhSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3j5HQ80qzKZ7XEs+RbE1FRV/ow25IrvaZBdNuuKzHyE=;
 b=B8/arXtiPm00IemFx+G8ZvuIJWs4ZigfzLCJQsoTJbohClLrtVWAgwzBFiHAhnNm+lkWBRBqEO3Upt9UozZSeM+m9+rOIxv7f/ksfiPMRGaxllZk+Xej0p0pdA5WX1oa/z/2+7S+MO8DbnnCvmiPcIrvw6xEkFGBcQk8mriGsR5jMaXXVji3g/HfqHB47xvtEefjMB3LCZNpKL2yZuOqF77hchZm1+9BU29w39KHv6UQ2OVtTHi/UbnePL8lvoY6eBFEyYktnPNxwIHeZpWTGB4pekCnVN23GHXSmMEB14GWl41IELpmz7iTsZ+3HxuJO4H8Ife0xrJbjjGRptNeqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3j5HQ80qzKZ7XEs+RbE1FRV/ow25IrvaZBdNuuKzHyE=;
 b=PzrdK+6MjG7CHwPxhTRAHjm5VDr00fg2K8uLgZzrfyisYY82Rq2WOmo5b13wdCFwHHzMcXPajwRHraXHuU6fP5d5umXdMGmtoWYpA8ZVRGBnrywzINpHcoK/1njawIAO2fOBv/UahLWPqe4nEVjGo86+15alZG4oPF+hoFx7Sj0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB4970.namprd10.prod.outlook.com (2603:10b6:610:dd::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.25; Sun, 6 Nov 2022 00:13:04 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.025; Sun, 6 Nov 2022
 00:13:04 +0000
Message-ID: <9b226985-f6d8-2fd7-6134-83255354e5bf@oracle.com>
Date:   Sat, 5 Nov 2022 19:13:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] target: fix a race condition between login_work and the
 login thread
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org, linux@yadro.com
References: <20221104095041.289643-1-mlombard@redhat.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221104095041.289643-1-mlombard@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR18CA0054.namprd18.prod.outlook.com
 (2603:10b6:610:55::34) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB4970:EE_
X-MS-Office365-Filtering-Correlation-Id: ba7746ce-110e-468d-1306-08dabf8bac4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UIhRD+sCSk3K91vzrT1+vPetaWoQq+/dhV+w9rJxX0t0PX8pDDxmEJB9FuP8o+kib3SrmaMSH1MMTX6Gnz0a0kY613tVeB7drjYs0MZswsY2djtyUr7AfCS1EIoPBQD4FZIJ9ZfAMdSpNYm4n+X6878Iyh30ENZK+fNyfYINtRgZEVAsi+MD8JFXnwdl/AJJjXZyAMcu7ex05/9nmYxpzsn4KvqKhy23sRymFD1HMu2akZu73MTur5/GzSslCMaczEmBeWguQWPYCiKx6mkD8S5n+bdS4x1VQ6uMoxE9tGm3TQ2IFrAsMeJ2i4rdd1OfQlSzrLnOqHZEI2S09elj6uAHbgiFs3px8Ll1gGH7AauG0oUGk4pbqVpRgFMApOeJGukOKQPRDjzGoZyWvR4/g1LnZzGNSNn2DXmXlGXzJmmcx2DXAGSId8/tQFK3ug/fmDHSzTJi9oTxXyePQPRF4DStY6ApRgrm+cAm+dcYJotFO0RdDGOKjEHgykWG1XYASZqeH5GbP5Y2wjSS1A9cxzyotZ1/itf9U4Fi7spYmjMhDxkgoEnSlStHw16TYd6iB8HLsdXkWhGvL//HXqkldxEU6iamg76fFqa+8POAqWKipSEQZ0aGKJwKsVj0VhnXx3zK0ericEL/KyPcJ72IEhUMbCqZqDBfj0dFzN8bY86c4crKlnYeRc9RWKfq63BtGS2l7a3QJDzHSt9HR+p1GseSgSgf4W8k+CdAe1bxOEm6PYzVurugj4ibE6jaXyozxyFV4CINK0aFv599H/xhJJRQtgJU8G9cKS5DRyRSZIk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(136003)(376002)(39860400002)(451199015)(31686004)(478600001)(6486002)(186003)(6636002)(316002)(2906002)(2616005)(6512007)(31696002)(53546011)(36756003)(26005)(86362001)(6506007)(4326008)(8676002)(83380400001)(41300700001)(5660300002)(8936002)(38100700002)(66556008)(66476007)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bzJLcmY2VWVJUFFsT0M3WXU1blp4U2ZJRkp6ejRZRFV1OEZwQzRJSDhudGdw?=
 =?utf-8?B?THpiMWRDRkExeERiclVoVlZUZWlDT0lhZkZtdmE3MnE2dGppRy93U01jWVRK?=
 =?utf-8?B?SVlURFZFZWhQQi96RXg3cjdzbE5rVGtiYitLbFdQaGRmWjBNdWRlUFEwVnZ1?=
 =?utf-8?B?YUJFVHkwdEt3WUJKT0lyYUNuampJM01WUS9va05qVG93bTdsVmNMb2FUejRC?=
 =?utf-8?B?RERUNWRnQ0JWWmIxQnNzMkgybjU2dUtLcm9rSG1IdTAwS1cvR0wvRy96MFFk?=
 =?utf-8?B?dTk1NlNrNFFjdy9SOUxMcWNKcUYvckdYZVIwSk5XVTdlRklEdWdCWEorQlZ1?=
 =?utf-8?B?Wm9EcUY5ckZWeGNNaWtKdGp6M2N4NTJRb0FWRkFqUlNGWWgzMTZ6SG5uNmhB?=
 =?utf-8?B?VmJYWXFMUnBtajl0N0pzdGRnYnFuWlIvSDNLTklkL2tkcmltYnZvaWZNR2tH?=
 =?utf-8?B?Zk8vTTlHbFBhajFycDE5SEJVdlBrM3M2d2ExQ2V0RHVGQWZsb05BWlRJcnBY?=
 =?utf-8?B?ZTk4QU5QaVFUYVY3TWN3dzB3TFV3ejE1WFhLbURCakxXTzl1M2ZuVDlaNFZP?=
 =?utf-8?B?Z2MwcldCZWgyam15RWpNd2xpSUZkVE5pNjNJWVQwMXJKeFY1ckN1eDZlNGJJ?=
 =?utf-8?B?T3BLdm81RWhMRGFQanFKb0k5WlpwSHR3MWxhdWUveEVSK0NHLyswUUZFT0R1?=
 =?utf-8?B?TmVPdWF1YXYwN0VMemZWNlQyUWJrYXg0THFFYmoreXdTRDljOW4ycHR1NFFv?=
 =?utf-8?B?ZDNyWGYxYmxIUi9WaGN5NDh3N0pBSndURFJidDVocEZQZEd3Mm1Ca2xkSVF0?=
 =?utf-8?B?RHR6TzluZHIyK1RDVjc3YndRaWtnVkNoRHNKUzl4TEtRNnZ3MnFLdW01WW5P?=
 =?utf-8?B?cUZwUUZkNkEwOEIxdkgzNmxWaEZpVkNoYUpRSlowRnhMVDJpemtMSzJKdGVv?=
 =?utf-8?B?RE9ENkJRdmZEdUNvQVBNVnVZMTFWSm9jQkcyM1U4emwxVDV0bVVVU3dzYWJV?=
 =?utf-8?B?Uy9FWlVyc1dIVWpRQjZOR3FnZ2N6aWEzYWF4d1ZDS0J6aUF2WWxNNVcyZkdE?=
 =?utf-8?B?TjNYdElvVVZrU2ZqTm5QdkprNVhDN0NMdGF4VG9SemJ3SGVrZjRZdks0d1RF?=
 =?utf-8?B?a3I4OURKeUhzcVkvTll3WGhsRzVKUkE0bHZUdDVyU2gvcG5ITkpTbTlvTzgw?=
 =?utf-8?B?MEtiSFk5aFZEaEJucXZwTm0wZFl4OC9jOHkxdVJ6RG54azRoSjN0am1mZGk0?=
 =?utf-8?B?aGJwWklBWVNBdUU4a0NPcnE0c1E3ZXViTDliUVZFSENZa0lQN1dGZm9CbUlv?=
 =?utf-8?B?SjZDL0lSVS9xWExZeEpGY1cva3Nyd1hUcFdNZ1o1ci9WNlN3WmRsRCtWSS82?=
 =?utf-8?B?RXhCOVpqRmkyd1NQbEZHVGcxWnBNSjZGaHdsekF2b3IrMGpjVGJJcGlEdk9a?=
 =?utf-8?B?aUN1MWRBd1ZkUElhaWFPck1ya3BVekRBVmE5U0NMSmRDZXFFNnlFMUVxN05O?=
 =?utf-8?B?ZkVsTUp4VzZ4UlZtVlVBREVCcEx6czVCQlUzQ0ZMOG01RldtbHFJb0phL1Rr?=
 =?utf-8?B?ZU0xZUtHczhNbW5IZ0V4MWZsbHBYZWt6Ry8wVXE2YTVoMXltVm4xNFMxZ0Mw?=
 =?utf-8?B?SFB4ZlhiWVNtYzB3T1FPaTRyb2p4amlPZkhGS2d1enZNK0l2MUFFTkFXWndO?=
 =?utf-8?B?czdRc2Y3SWJkZXJScEcwOVpBSXJJYnpMWVE5UHE5V1N3T3lJdDQrM1RIL1Qz?=
 =?utf-8?B?NFU4T0RUTkVpcUNHV3owWUkxMGhKUjRGLzZFUEZqbVE3dUh0TVUwTHJDWXVl?=
 =?utf-8?B?MmFpaDVTamdQclNqaTIxM3N4WVBaKzkxMkpHemVHR3BkRllTbDd3c3F6OC9J?=
 =?utf-8?B?aTliV291aStFbVBEUXpjeXNubDVQMnEvOFZjN2pzZ2xpdWVROW9QTFNuOGFk?=
 =?utf-8?B?UytCSWdUYnBMNGZuM2o5Y0s4SDdvN3dZOFBscUtybWJCVHcxWnNsRUYvV3Zl?=
 =?utf-8?B?cWVwczZzOXJWNzhVZnZGYUVYd2FpMWYwWXJMUXJTYWNrd1EwVVM2bklvQ3gv?=
 =?utf-8?B?ZTF2Uys3TXBzM1BuSzZSWGZlOUNYc01FUXBXOHdSSkFBMGdHYWhOaCszYURj?=
 =?utf-8?B?eHY0VHJuTStlcUZTQ3QxbE9pQ3JWdk1rZnlDQ0FwcndOVTBYL1NVcGtvZk1r?=
 =?utf-8?B?MHc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba7746ce-110e-468d-1306-08dabf8bac4f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 00:13:04.0444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fxgB5h7Z5SiPQvA8EerCFw7rr8kaLOtS9LoF/rH8ZMpNEh3hkGPqBlPlBzn+fVznm0FlkvcySUWDZpL6lleUNG3zK4wCg97cOcuCd/hdRms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4970
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-05_13,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211060000
X-Proofpoint-GUID: NehU-S1DZq0UOKA_l2kYXGi4QHn4DpxI
X-Proofpoint-ORIG-GUID: NehU-S1DZq0UOKA_l2kYXGi4QHn4DpxI
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 11/4/22 4:50 AM, Maurizio Lombardi wrote:
> In case a malicious initiator sends some random data immediately after a
> login PDU; the iscsi_target_sk_data_ready() callback will
> schedule the login_work and, at the same time,
> the negotiation may end without clearing the LOGIN_FLAGS_INITIAL_PDU flag
> (because no additional PDU exchanges are required to complete the login).
> 
> The login has been completed but the login_work function
> will find the LOGIN_FLAGS_INITIAL_PDU flag set and will
> never stop from rescheduling itself;
> at this point, if the initiator drops the connection, the iscsit_conn
> structure will be freed, login_work will dereference a released
> socket structure and the kernel crashes.
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000230
> PF: supervisor write access in kernel mode
> PF: error_code(0x0002) - not-present page
> Workqueue: events iscsi_target_do_login_rx [iscsi_target_mod]
> RIP: 0010:_raw_read_lock_bh+0x15/0x30
> Call trace:
>  iscsi_target_do_login_rx+0x75/0x3f0 [iscsi_target_mod]
>  process_one_work+0x1e8/0x3c0
> 
> Fix this bug by forcing login_work to stop after the login has been
> completed and the socket callbacks have been restored.
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/target/iscsi/iscsi_target_nego.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
> index f2919319ad38..e58bdffe2931 100644
> --- a/drivers/target/iscsi/iscsi_target_nego.c
> +++ b/drivers/target/iscsi/iscsi_target_nego.c
> @@ -1058,6 +1058,7 @@ static int iscsi_target_do_login(struct iscsit_conn *conn, struct iscsi_login *l
>  				login->tsih = conn->sess->tsih;
>  				login->login_complete = 1;
>  				iscsi_target_restore_sock_callbacks(conn);
> +				cancel_delayed_work_sync(&conn->login_work);


You can remove the cancel_delayed_work in iscsi_target_do_login_rx
in the chunk that checks for 1 being returned since you do it here
now.

For the error path, I think you could also move the cancel_delayed_work_sync
from them and put it in here.

If we leave it to the callers, in iscsi_target_do_login_rx in the "goto err"
handling should this be reversed and do you want to use the _sync call like above?

        iscsi_target_restore_sock_callbacks(conn);
        cancel_delayed_work(&conn->login_work);


>  				if (iscsi_target_do_tx_login_io(conn,
>  						login) < 0)
>  					return -1;

