Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B61C6FD1D
	for <target-devel@archiver.kernel.org>; Thu, 30 Mar 2023 20:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjC3U7m (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Thu, 30 Mar 2023 16:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjC3U7l (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 30 Mar 2023 16:59:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10121CDFD
        for <target-devel@vger.kernel.org>; Thu, 30 Mar 2023 13:59:40 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32UHOEop027093;
        Thu, 30 Mar 2023 20:59:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=wJlY+z+KWidZU9/MWazW6Dg4FPgPZbkd0p/vqUguRYE=;
 b=rBxrWjYZkTci8Hi76XdKjyocgFm0tX/hf3VBORDjpqnLsmXZHwJ9WlLcrTderXBEJwcK
 QhFBy4dmOVenyDCjD/TFDVVzbSrEewLrR7zKrbb46KRsRfi0sg1BRSxYqi/gAPQjCUQD
 BKcjD+VV1F3IcReuQjcvJu9MZCmnC+JJZxl00I5zUgaFYMi5OD1rnH8xPSxkVj05PVxL
 ehXOEyA7d3kUZ3+SCuZ8UHWpbD3gNJHMs6JUPyF4xAVP/ciCj7z8130Zv4E790x6QU/Y
 ZZ4ChkiYLtm22mXexOdpNjHPD3SfjEzvAeBIh2wHYo+0LW9BB8n8LKDJMN0G0kKUWqqu Vw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pmq53bwqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Mar 2023 20:59:37 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32UKUDlj036404;
        Thu, 30 Mar 2023 20:59:36 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3phqdhud4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Mar 2023 20:59:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KoELZNjAjTy2HoYdBQb4ZV4eqCAacc6Uo2iWWOZD9t7TSW/LWu2SJEuoNwMrxL4R9gV0VbzBOhvbPAn898sXTEudNy+Cjbtx4QNp5oXgfQUg+7pMHq03b1S1csnLy8YdajI1KVXBnTyEOx4LVr9Uswtp3gGqdWYTmStTsnDjC5pLcLGK22CP8975FzXGT9+k9HI+RHWQ1x0Y0c1AcbFTGQUX/4H4KkEX2K62geu0vDSoXOHiow49OaBwFa1PzJ8EpOhBgj0AcYCHgEvThkgBT9q+LzRlAfLpyHb/1/nfk3kbpZVjYRY1QkVIYnTLau4tYj6rQ17fx/I9E2gbJVb2dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wJlY+z+KWidZU9/MWazW6Dg4FPgPZbkd0p/vqUguRYE=;
 b=IKlnttQcbgp0ck04S+4jto47dpYW7igWYJq+4qxZdAJznPIur8KFXZk7RYf2aXlWemAYe/dmEN75DhYmJEBgQZVpEpqmLkprfnGtZNmCfFhmEf7IGxQdkPpxGzS2SH9+uVzjPbpt5A2CSgEQPnu2F7LL5kJs1Pn+mMRn/osX1p9F5VeuNSYmGrDIshutwz2wxwVmqTLrB95wwHPbX3sIrGTyNIy2I1W9MV7TTJDtfn7UOS0sfeFygFp6vLK5VYofZwg3TJvZVeUlztI4PAzk15+PrBZBE1yWOlwd5M34fNQc55t1dVdfWhGC3wlDd8hwZG8nlZGJlOOqwV+WEx3++A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wJlY+z+KWidZU9/MWazW6Dg4FPgPZbkd0p/vqUguRYE=;
 b=A+gDQTnaF8jUVaing2l60mL1BkmEZh7YrqksZF5/iDs9B+mGXplx77hooGRIAM6SMIRU0U81xZxlCHYPV6QmNjd7OqbLHtrriJ2rkyt+6LHpq1EmM9NItLLXqta1m++bVVI+wzgAsCZUU8XCFi4kN++zQH8Jfm5f+8ClTLxPQ54=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB7166.namprd10.prod.outlook.com (2603:10b6:208:3f4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.33; Thu, 30 Mar 2023 20:59:33 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::dcf6:889b:21f3:7425]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::dcf6:889b:21f3:7425%6]) with mapi id 15.20.6222.035; Thu, 30 Mar 2023
 20:59:31 +0000
Message-ID: <4a13281e-6076-c8be-3bb2-341e50f0973f@oracle.com>
Date:   Thu, 30 Mar 2023 15:59:30 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
From:   michael.christie@oracle.com
Subject: Re: [PATCH V2] target: iscsi: use GFP_NOIO with loopback connections
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org
References: <20230327104535.20984-1-mlombard@redhat.com>
Content-Language: en-US
In-Reply-To: <20230327104535.20984-1-mlombard@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0093.namprd03.prod.outlook.com
 (2603:10b6:5:3b7::8) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA1PR10MB7166:EE_
X-MS-Office365-Filtering-Correlation-Id: e8679e3a-33cc-4565-19d6-08db3161a8a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2l0J1314MjVDeM3RvFZ1XdQVV45f7jb1LyfV4emC8KwNGR1Id/HaPoLz949dhE7RJ/+pXxpMSS8HeV+EAtIz6uoNrO/cV8KtmPqcJoJmoz2TQOI4hvc1cVDF5idIxPlGjWaBSpqP9STXFP2nTynDL4mHEJprk3E6Rx6SdTJAw/4mUV8b91O9/7/TawzOiuxat66Gj5cV0gkMsAZIUGsl5UESf/cFofGLheHG/3ZuNOHY6pa/pUrNysbvqMTj992DMzloMPCZA/JGUmgundm7TwVDot6IWK0ykXinuDMCRi7fBlnExz0XJ9pYh4j52TPTSD0FpvLkBRcEqSxOllTkrY8naCK+OOllFfvdpWcPuhYzQXyr2bjcNtsg2uRfPuCBkY4jcXEp4buDI4VLaBiHLv4rj2w9CJ2/t184Q8WXj/pDcYouE3fL1GDXz7zZtAeS8xcvtpe1cLIW8/GitclDJS2stNqafQk0DIKbchaSDGWbYcAzF1JShdG7k1vperlITSDwKkpQvcyPBL2UTLTEbXzqOzQdxaB65hXUrmRDv1E9InyQFYvQmBYAT0zORrAQ8y7cFxBWvKn9xxjl2CjeLBx4SWUzbTytArySqq7YgxCnAz9LqcPfKSb9KfA2HMBr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(396003)(136003)(366004)(451199021)(31686004)(31696002)(86362001)(9686003)(36756003)(83380400001)(53546011)(2616005)(5660300002)(186003)(8936002)(2906002)(6512007)(26005)(6506007)(6486002)(41300700001)(4326008)(38100700002)(66946007)(316002)(66556008)(8676002)(478600001)(66476007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TFV1SGxPM0VnaXFJSzZmQmcrTzRlTzUvandHQ21ETkcrQThTTjFORmhhRjAr?=
 =?utf-8?B?b2JwbHVsK1lDdnU5VFBsN1hkZ25GamlOR0I5cUhXQjg4ejlWQ2syeThWWldh?=
 =?utf-8?B?SEJpUld0SjBuUVhEcUhMZzd2dmIvYnE4cU9mRWk5bm92Y09CK2dUVEUvZG1G?=
 =?utf-8?B?cFhhYS9abWU4NzZEaWtpWjhkUk1kaE82ZUdqc3BRdWRFMXRjNHJQVW1DeWR3?=
 =?utf-8?B?ZnNQQWpsd0p0cjh6eE91cFlncldwcmdsUmRKRUtMRS8zUTVtMkdVSzNFNWgr?=
 =?utf-8?B?ekRjZTBicGQ0SFdlVzI1MytCbVVFa1BlZ01NSFFKa2FCNDR6Z1B6Ym9XeitD?=
 =?utf-8?B?N0JmbWRvT0dUWDZnbWdDcHc0VytHRWxOeFBxdi8yYVFYaGdSVmF4eTl4RW9F?=
 =?utf-8?B?NGhiV29PaFJYY3lkbVZHUGc4N203SmxJMEJNZXRZWlgvNmFzeks0bmFMS1ov?=
 =?utf-8?B?RWxaMGd4NlJ3WFVxcGppREkrWUxKTGdhUHAwZnZzRWhwZU41NzdidXZUbTVY?=
 =?utf-8?B?NGdYTldidmZHQ0xIa0M4cEQwNFNQSXFRc0pFakVUTnV4aW1xTEVPdHo0ZmVw?=
 =?utf-8?B?MEZoTXdFeno0bVYxanliOGxwT0FiZVJybkF3S3ViYTVGWUR4Z3V2QzRkcTZB?=
 =?utf-8?B?Nm1pVzJ1U1FnQUhjRmduTm1JUWhuRkRCb0xzcFIxWTZkNkxobnhzYUk1Y09x?=
 =?utf-8?B?Z0RtcFUyS0FBSkxVVlFFOWUvd0YzY1dreHpnTnlmbjZwWjJwVmFVZ2pnVmt6?=
 =?utf-8?B?TzNiMkk0TXhia0t2eUhEenROSTl6aWkxZi9XelA0eXlRSTZIUk5obEZtdGZv?=
 =?utf-8?B?T0xuMVAwazdxeExTa2lMclQrQWxFTG1vYVhYcWNxMmhzNFFWUitjSWdlY1Rz?=
 =?utf-8?B?U0h0eFFibmgwTmVSdzRQbVZ0SmdnYlBtb3BuWlE3TG1qelRNb2t6OVNqaVl0?=
 =?utf-8?B?VENqd29HTk94ZTRITm1kOE5MUGJRaHlJS2gvUU1tcGZEUE1YVTFRenc4SGJP?=
 =?utf-8?B?ZVdWSlR1dC9UM1ZQczkybzdXZlVFSDRzbWNUM1JTcU9WMGZwdFJSQ1l3QkJu?=
 =?utf-8?B?MWZRNW5yUGxyYVc2a3F4OVkrRlFMU1pubDJ3Vjd5bFdkWE42anAvUjdIMFM5?=
 =?utf-8?B?RlVyNU1vVXpqNkRXUWdUZEZTZitNY3hCV0lzZGhSNDhZYitma3ovU0JVMkhN?=
 =?utf-8?B?YTJpeE9TOEFHMVUyUUtXOUQxUkJKWERSMHViNW5lQVduWjIyc0VSMDVES1My?=
 =?utf-8?B?am04MUNFRDlWNmNZdm9pRnZvdEtmRXdkcHpncTBFZVE2OGM1TFNpUDRZcm9G?=
 =?utf-8?B?eFp1aWhqdnNaZEE3V1p4VjhaOHp5TW1GR21rNjRuVFJZdEFHWlRLODh3M2Vp?=
 =?utf-8?B?MjZWN3RtWXVHSHR1NjB1cjlwaTY2bllPN04xd21DRWhTVExJZnlSZ29henpz?=
 =?utf-8?B?blQxVFBxLzhQYTJNVVpGdW1pazU4SmNOUC9HWmFoUUVCMXFQelUyaTRpRU9p?=
 =?utf-8?B?WGMxOWl0Yys1bU14elJLQjVUYlBOUjdvS1o0bkQ2NHU5NU92L05hcFhGL0Qw?=
 =?utf-8?B?eUFZcCsyNnpHZ2pzUGUreHp4UTE2YkdhSy9vZnBGUHNsRlV5RVlBQ25BWWFW?=
 =?utf-8?B?ME1oVVc3ZUFnbjBxc05ScURFRENpaXJlMS9odnQzS2FHV2IzYUhtaThOVVI1?=
 =?utf-8?B?Y01wbG5acFlVTy9RVGpXWHQwc29aMlRoUm85aHYzVWhNT2Y5OFlnWmkwWXFm?=
 =?utf-8?B?QkdHZmtVUDNiTytiSWcxZWo3dmlzZEZaaEcrUkFVVEc2UUlyc0pWZmYvc1Zl?=
 =?utf-8?B?cjRRM0VtTktLNGUzUGFkZ2l5UFhIb05mUElBZm1zUWlLMUIzQVBrQkJLbFBu?=
 =?utf-8?B?eXZJL1c0UGo1WmwwU2V2cFNQd1RSZzdCVHlCNVZWUUx0ZHIzVHd3MjBzUWZx?=
 =?utf-8?B?T1BicTJmUDk0VUtYcFBtNnZMdXU3bHRUc2lGejFIOU83VW5LRXdmUGY1dlhV?=
 =?utf-8?B?bzhUQmFRbkRBQVZPT2dCU1ZFdmdtMWJYK2VSbEc1eHlLNENlanVMQkRFcjBp?=
 =?utf-8?B?VGV4elNCSEkrVHZ4enc5czJXSk45aUw3cENuekpzaklyMDFzY1RIaThvNTJU?=
 =?utf-8?B?MkNURGN6cy9hK3JrWFM2U2V5RGs1Z0huWDFtcy8vSlJQbWlIclNGM1RZTi9k?=
 =?utf-8?B?L0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: qkjbBLMtfy2UT97drPkV6SMlqbugwfPe87BtA+TwVOXWQTK7xHCS++i8GCgxqhUpk12Zdbid40mUIf3FZNpQd/UTOHieJx0pgbIILJWAqyC+KpLSW1mCepGiVFm4Qyp8Ck+1bjZjKGcWssAYK95xA7nD1WxiobXBIS4+Iie+fLMScQqwGM30/AUh7+mmKFJOFF/o7+WwVJ2lWahSG2zTZNNiAy+oNRMQF/qE91D2LD2ImahDwv9eYLbbaexPaxHVd61QmvzcdmGfBROUnebcpitDCSunB6920lBye3rJE4ZAncJNQttzKc6/aGhUsigm3ydB/nKNcH+cZnqL6RqLlVpw//vOdplY/dcRuJZMVmm7haWbUiI3aX6DGWvp3GcHGoxtFI/BHATyJiDGtUrAPDNKefcllAto5RHILEkw1Eq0zLyVwjaUcvtuUI1SXbSnEB9iiGJWWpd9qMd+KHu4DVRQA6KiWIjrrB4/qYuvXHuXfOhu2Rgac/YrXp9jkGDexFJVdwjTBOg/e1/uSVE6n8L2pXAfm0m3BL4Jp2GAQa5v9XwXQsEGsdHhLDUI4A4hnV2uAeJcQpM95i8pahM2bsBskKGKI/FA1MR7RDg1HVAaSivrRDZrkTsMVx72PwqBKuaUbN3V7v5wUGZVvoAkStApPBEAIM0/zTs5I35j4zgvZKumeZ8dmeO1npbj9o+fpsWsMrUY+586vzuFBiqvYgTxP7o+zq7rL/c6A9o2y1VHEFAO8UpacX3NM54SWGSgOv7o+SiYPO4tATsVlxFBPUguEzEnEiol5wvAwqfsnpA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8679e3a-33cc-4565-19d6-08db3161a8a8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 20:59:31.6336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 60x8w2ffn4Ee4bfr4REs+v4wyk2BqiJUMYytOvsL1RlZROcA5S92LYTOEdqwUX4sCM996MsKttCBYc+SqV4qXTeGuM66BvHGePmMTwh8xZk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7166
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_13,2023-03-30_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303300166
X-Proofpoint-GUID: q3kzlLlWFlWfyJIOJ2il6zJd5KDZgkNo
X-Proofpoint-ORIG-GUID: q3kzlLlWFlWfyJIOJ2il6zJd5KDZgkNo
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 3/27/23 5:45 AM, Maurizio Lombardi wrote:
> When an iscsi initiator is connected to a target running on the
> same machine, the system may trigger a deadlock when working
> under memory pressure.
> This may happen, for example, when the iscsi rx thread tries to
> allocate memory and a memory reclaim is performed, the rx thread may
> therefore end up waiting for the initiator to complete I/O operations,
> causing a deadlock.
> 

I'm still not sure this patch is the right way to go. Here are my issues:

1. We have a driver for local use, tcm loop. IMO, you should be using
that.

I don't really buy into the argument about it makes the tooling easier,
because the tools have to create a local LIO target. They can just as easily
make a loop one vs a iscsi one. For the iscsi discovery/login phase, you don't
need to run the iscsiadm command for the loop case so that saves you a step.

I would also not want to add another user that needs to dip in the memory
pools for skbs on the same system.


2. Block drivers in linux have to be able to make forward progress.

	2.A We use mempools, preallocate, etc to make sure we have the resources
	needed to be able to handle writes out to our device.

	For the iscsit side of things we use the memalloc related flags to
	dip into pools.

	For the LIO side of things, we don't have anything with or without
	this patch, so the iblock_req allocation could fail for example.

	2.B We can't swing back on our self in the main IO path, so we don't
	use GFP_KERNEL there.

	For the iscsit side of things and for iscsit's specific implementation
	this patch handles the LIO side issue. The drawback for the LIO side
	of things is that it relies on iscsit rx thread submitting and
	executing IO from that thread. If we ever do something like fix the
	issue where we can block in the submission path by deferring to the
	submission thread, then the patch does not work.

	For the general LIO side of things for loop the patch does not help.


I think if I'm wrong about #1, and we are going to support this then we:

1. need to handle the iscsit allocations using whatever we are supposed to use
like you are doing in this patch (memalloc_noio_save from the tx/rx thread and/or
sk_set_memalloc on the sock).

2. We also should fix the issue of LIO core using the wrong flags for this type
of setup so it works for loop and also for iscsit. For this, we should have a
gfp_t allocation field or flag on the se_cmd or se_session so LIO core and use
the right gfp_t.

3. For the second part of the problem of making forward progress in LIO
core/backends by using pools/preallocation then I'm not sure what to do.
	

