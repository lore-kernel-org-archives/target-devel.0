Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25838C77B78
	for <target-devel@archiver.kernel.org>; Wed, 26 Apr 2023 15:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239361AbjDZPoD (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 26 Apr 2023 11:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbjDZPoB (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 26 Apr 2023 11:44:01 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1716B4ECA
        for <target-devel@vger.kernel.org>; Wed, 26 Apr 2023 08:44:01 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33QEi47N025589;
        Wed, 26 Apr 2023 15:43:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=j7+UtQoKrwmNBG0sNepUwblVp120U2zO1c8ivSzr/vE=;
 b=tAQIWMx8NQDg/QVaohkh2/I721MvqI6R8/9OVvxmkIAh+9lgkV8GX5EZgGicAPKxRwH/
 mkSfo9KLRKkzWX3zEGDtE38wQ5oQFLXGP1yOQJlacpI4itQLncK5wzHDwpB9DC3tOZjM
 BA1FXuF6mgnIW0HArozsCbuW7BHHaQHytmow+kllSWBWWrqQ1x0QBudxeqBXFGgTugcO
 OZ/yzQxNFi5zvmQeYYxkWGbq9eVWq3TvQ1NElrFEngtdq2p/skMUFCHsCuHY/GGu7x9O
 UfJyrUIgLIQIto9Ulqdmxs4xxNfbq9P26kgFiM3SwEw4niIXu3Ah+X1kwahg6ojMrfhO 1Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q46c49u5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Apr 2023 15:43:58 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33QEHdVS032901;
        Wed, 26 Apr 2023 15:43:57 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2044.outbound.protection.outlook.com [104.47.56.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3q4618b1xc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Apr 2023 15:43:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AWCwi6cWEzpk3dvyPBf/EhMaNzgRWbecvOIbHFYqg4LrOet011Xz23AO2ek0yctLlTTngzCHOLSMC7qlRCzT9B/ajt+QsFVfWiiWWfXjo3lKOiO7H3Xl9m126e1+NJY4PVfIjLX/fwDjG9LB8z8V0NHPIGucjp299zjjIcyZ5n/qt4uPWU+P2fNpF2aGVkBkDc7iSR8rSO3Coh8HuMQliSVJDvkX1l3TtKH8lFZ7MDEDLZsWeyHlipSJC7iqALgXL1LqKU1Taeo74FL0ENxE4nrock3sZ8zUEcQBYYFRfEJeyhCaf5Qc+6WanJLOi1fBqXmKISJ0JSCo2UafqWXNOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j7+UtQoKrwmNBG0sNepUwblVp120U2zO1c8ivSzr/vE=;
 b=XQmZp7bVCnk6jxwy1N5He/9gsKEyVjqQAuWHtprSsa8HBk0/qYdC3Gv/W7pA6UX/V5X/IuLlHyv4zm9ItJf+cefM1MHIuMRoEo0KMwWCCTWsvAFBiFxyfYFjy9+hsd1QlnpFu67mIXx7OgdX2K+wd5sAUkJ9+0cDBjCeEL56ppxEjvNIJF9LZUqg1Q2UJ4/oBEs+CC0vCvjCeKN/uSOsWsRkXS/4/VgaLVzdaaLJsRK75+0d0hja4Kv3JW2LSukor7V7zK6lHGJhE9WPuF+BFxIJab9Fcw6lftfDh/MfXh+N4keTWL2lXRK76LboDOJyr0DtCYHqq6vXMCCMIjUzKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j7+UtQoKrwmNBG0sNepUwblVp120U2zO1c8ivSzr/vE=;
 b=k1zeWThLkfMnOHekqr7mAxxASIl60SocTBaQCCrF7h56KtpfD+jDfcayDwzZQNhhEvdo2G6HjZvpooH0S6dv/MhbhjnFVXeL8JjBkfjGXSgh3jNxW7ZI1NsSn41DXaeckDcHjdXX9jhPsTqTwsCSIkzxEO9q+q6IcXb6GTdiTMs=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH7PR10MB6555.namprd10.prod.outlook.com (2603:10b6:510:206::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Wed, 26 Apr
 2023 15:43:54 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::264c:5118:2153:91ef]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::264c:5118:2153:91ef%12]) with mapi id 15.20.6340.020; Wed, 26 Apr
 2023 15:43:54 +0000
Message-ID: <caa4be42-fbfb-8da7-9f2e-79114f5ecb26@oracle.com>
Date:   Wed, 26 Apr 2023 10:43:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH V2 2/3] target: iscsi: remove unused transport_timer
Content-Language: en-US
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org
References: <20230417171801.208122-1-mlombard@redhat.com>
 <20230417171801.208122-3-mlombard@redhat.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230417171801.208122-3-mlombard@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0199.namprd03.prod.outlook.com
 (2603:10b6:5:3b6::24) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH7PR10MB6555:EE_
X-MS-Office365-Filtering-Correlation-Id: 06127dd1-2ec5-4629-183a-08db466d0a81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E7GY56O4nPlRovP8WYT4oNalyHZ5GS0MlNSBpJU0hm8CuIdTE4fGQYGkZN+pvM6mT/L4RHB4+Wxp/mN3nJD06ebistvrJ5N3rUx4F9VZm36iDrDs58zVFZbeh1gZPOEuuOphdrP9rWUL12savL0cDR5QLqt/MCE/ULaTR9gsT9ycJnVi3iWODtdRWs2NrFX0mqyI/42saLTPE9U+Yk2XTVfyY/FIK598b+mzuxxvxGKrknEsIZp2+alZuqWIa2GM6MyNsG0j2kfZtCpA54BWFx0aIbxFjjGQTdFBEhNF3/ybwtTlBiTM31qkHpVN1zdlNeN2jxNGDNHGieewzo4H2mqUHkezGHeFT4QhTz+szx2stqjEv1U8oCpERywReplstTeumM5mUUjAGSxPCrly7MNlM52uqmp7m/RetN2tu4uPyswb0yefOKFe8tjuLBIjH9bRIKSel5uK1xlfosA9PEuwbPao9jpCq/mOpnouBUhofS/CpVe2Br0ibBmNLYF7M/cCK0DYlAhWiOuAa3izMs7Wt1p/KXovsP5FqIvUIqMa2vWF2fbkRErOUwkuftg4aq89Ni2abCaQuLHwgnRcWXJZ7IQYRJWmE+3HUPG9S3ZyhJWdr04a0c+S/Dt0mnYYM1NwxmiDuiVzVipPKlgNhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(366004)(376002)(136003)(451199021)(186003)(38100700002)(2906002)(4744005)(2616005)(6512007)(53546011)(26005)(6506007)(6486002)(83380400001)(86362001)(36756003)(5660300002)(31696002)(41300700001)(66946007)(478600001)(66556008)(8936002)(66476007)(8676002)(316002)(4326008)(31686004)(6636002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OHBRTzN6RlV2K3RiNnZLREZXdlNSN3hESXV6ZHJCaU5lbHk0UVNhRlVaajdl?=
 =?utf-8?B?VWErNWptd0J3MzZSRkFGdkxLM2RWSFVPbWd3N2JWZi9kcHBnWXFmYVhyTGF3?=
 =?utf-8?B?d0poa1JBd21DRXorVHdLREZhN05hbmxwcU5RbEJ6MVpHQW1abmluK3dqQm04?=
 =?utf-8?B?b3A2OW1hOGRxejVKaERza3lsVlhJY3dFKzB1bFNTN01LQVg5RmJqaXQwbHJp?=
 =?utf-8?B?NnBNaUlHK2dsOEtNaUM5dmZKcDU2Sy9MRmZSditDdkhKREQ1WTJ6MVQzNGJO?=
 =?utf-8?B?SUgxUUxNWXFQWGtVRTZNTTd3TzJoakRjbmxZR1k5bm9FZGo1NFU1VTZYaUdx?=
 =?utf-8?B?SWI0VElKY0JsM1lweWRhZ016a1NibnViRjZwdmpTTUJFbkk1RkhxRmdRN2pu?=
 =?utf-8?B?cERVME5yRmNEWHc0LzRSdGxDQzlMc1R6WWVYQm9Nb3pQYllwamYxYWtRVDdi?=
 =?utf-8?B?UWVNdWI3QkRvNzVmSDFuL01rQmtHRE5XV1lGcmp5UXFZaXJIakxSU0dzc0pp?=
 =?utf-8?B?U3dLNDJBclk5VE5mSlc4K2VPL2JXcjZ5Z3o5QUJMQmRLUjhncnBCcVZmc0hl?=
 =?utf-8?B?ODJ4cFV6OWtTVklENlBVVys5aEMyZGtXL2hvRFdBZHFqa3B5bEJZQ3paV2Vh?=
 =?utf-8?B?OW01OVNvYWg5RDBtT3VUalJyNWhnSHpzZCtNbWY1QVRnVU1CZ1paNjFmZ3lk?=
 =?utf-8?B?NjdVaWp5SkhVRTJNT3M4UHBpUHpESVdGbmhGV2NML2Y4MlAydUl5bXFrUVk3?=
 =?utf-8?B?azNxV2ljTFJYOGNLbGFyWklsanRRY1UxQzFoWkhiQkNFRUxoYWdJNy8wUE93?=
 =?utf-8?B?RmlNWk9xZFVRdmdDTXNrQUcvVEJJNGVXYjcwakR6UHUzTndFdkc3cW0vTWt6?=
 =?utf-8?B?Z0ptQVpQWmw0dlJ2bXd6ejNFVDZXMFdMTFFzR3lwQ0N0aG4rM1RCSndtUC9H?=
 =?utf-8?B?Vi9qd2hSQ3p5bWdEbmkxdVdDRitNcjRkNVFsSll6eVpDSFBEdEs3OFgxMFNm?=
 =?utf-8?B?MFBuWWVtWUw1a21SdVBhNWRZMFVaWGsxbC8yeGNjNy82SnVmQ1FqanZJM1pv?=
 =?utf-8?B?dVYya2ttRTh1UnM5OE9scXRKcTZKM21PQ3o5andlSkhUZ2NPNW9zMnFCeEFt?=
 =?utf-8?B?TnBpZG85azZIUDFqWU0xc2pURnV6dThuNzlBb1NPNkRCMVJEZEh6UGdGaTF6?=
 =?utf-8?B?eGdZNmk0MlhEeTB2bWdDMm9kQ0tmVXMxdTRUZDIvT2dUeFlSZ2RRaUQ4V1Zw?=
 =?utf-8?B?VDBsNlNldzR1QTY2VUJoK1JEazgzVEp1WmhXZ0g3VUdVS21YL2pMcTNCVnlh?=
 =?utf-8?B?bXFJL0pRaWM4Qjl0QW1SV2JHTVA4Z0VQd1FpSVg4S0NNdmZheU41L2pXcmw1?=
 =?utf-8?B?d3poQ3pydDVTRU1RaFdwS2dLeDFCUGRZZFBRQjBWb29sTFN5K1VuZzN2RGZi?=
 =?utf-8?B?MTFDdmYyNGdMSnB2d0dEOEt1UHhQclpSbDJrcDVEMy9ySXZhNEFRNFdBZTR2?=
 =?utf-8?B?NFhhOHJZandpZFA4dWZwT1ljUE41YjFMQVpnU0NrNEFIR2J3eUZqUDNjeWY3?=
 =?utf-8?B?RmlNUHdLQmkwektXT3JNcGNmVy9qdFREZnBENXRLb21ybjRwdHN4cTlKVDdl?=
 =?utf-8?B?TGxKR3JXVDBYZE5ZWWl5T2ZQNlpuZlhKTGh6KzdyVVVhZ2lyb1VQaC90dDly?=
 =?utf-8?B?MlZWTUttWC9WbEUzTndBeUpnd3djaklhTmp2a2hWdG1WU0piS2JpU3cwalZD?=
 =?utf-8?B?TnZPTVBFN3FiSW5yMm5JbnovaW5XdktIOEtINnZHWUs3RTJ6UFkyZnpPd0t3?=
 =?utf-8?B?QWxPVkRYY2hWZC9RR0lXQWFKdzloejFsWGphcHBGUjM5NUlMNjlBMGd1bnpI?=
 =?utf-8?B?alpwdzdJSUJNM05SQkRneVpHc2oycXRYdkZjK1kvL0hHNGcybGljS1cwcGZq?=
 =?utf-8?B?b0FJQWdORitXMFMwUjA1cXJQYnQrOXgrT0ZHOWhlWTZxcWE1bDlXdTRHR29X?=
 =?utf-8?B?VU9aVlhMYnlWelVUQ2hXZ3RxVzViVldhc3ZZZ3U4YnU1c1RJZGlYVk83dkgr?=
 =?utf-8?B?aGVHZkZ4M2ZMTlV4eTBQMHhrYWxlbkVhZXlrbHN5Tlpob0hBTitVRzFEWm5l?=
 =?utf-8?B?cjgzcE5XVVVqOStzUHI0NEdWUzBsSFBuS0xvZFpaeVVsWUdMMGFjKzc4MUpG?=
 =?utf-8?B?VFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ASwQxVrNzWEsGSRXqzpoWi6NEC8S533KUibtc1OhxJGZKs5pnxSESvJvPpn7BWIkawVO0nWQGWBL00Cp9XD9eb5bjG+Gd33Ih9VGGv4rli7hbvFHfd6uV6/lfuClQZrEI02kVTqeDlaWC3IjbaD6QQHPM+BoJEDGoEROsTGZn0MkL0MYGSkDWyQYlNOTpztoyEYrrLl1ehICji2ugM7+xVxXmeQqYdnFKY0fBiG9zCx2T0CFV32gfXxYopf5oRXK+trOksnee7gH6nYHC0xl/lVAXXENArtIqZBmRToRoQ+qGX3GOFP19OiSXZfBq+e8zdWNKjtYGImHAYvX9LODxiF3TABQJDWkcw5Iq3x8qkH93CSafbiwNdiUcvMDSg3T4s/b68+hzaQaos50Ig4CbC1SzKqOzvbAXMvMrpWZq0zFdGcGm80SBtKMMPfrhEkaxqRFm5CRZi3vqF//NZyBARY5LsW91O5g+P/xcokChXILlDwANb3ZGBjPDWAlFmg+vCNnns6N4poGnLlyghiqCa2XYtj8YlZI+RGyDULJVv8DgPQ1zso0x7+boWZJRIkMpZ0WVY1lGlKIR8XyQl85iKPaJifxAf8uZbuQDtRFuosT8dL5VM0rp4oOSZOFppAg++ft76yYV8+N01LyN1mvnhQBaGSWIVFFhxkPMfI3cVSu2hihm39CgI7kG6jWnQeSwm+VFPAc7Bm7DDVF2yhYNBW9SmAN2kc71UX0Bni+dxOG/8uCaQXCNOksMzxG6W8Z9wt69XAAhssqz94MfB6OpaHR8FaTZdPN12P1oklEZ/k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06127dd1-2ec5-4629-183a-08db466d0a81
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 15:43:54.5962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +qXSSfNcYaYE9JKcXPZIN1VXlZDZORtTbLtcGFc3EDDV52ILuaGl8uvqu2nHH9io4d1PyWdk2OR2u2z3xY64xnzO5MmI6pAxcoQTrO2iDt4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6555
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_07,2023-04-26_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304260140
X-Proofpoint-GUID: stUNfc-j77LxYAk-x992sFehVzh8cUxx
X-Proofpoint-ORIG-GUID: stUNfc-j77LxYAk-x992sFehVzh8cUxx
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 4/17/23 12:18 PM, Maurizio Lombardi wrote:
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  include/target/iscsi/iscsi_target_core.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
> index 082aaad8ef1b..b550056a38fd 100644
> --- a/include/target/iscsi/iscsi_target_core.h
> +++ b/include/target/iscsi/iscsi_target_core.h
> @@ -568,7 +568,6 @@ struct iscsit_conn {
>  	struct iscsi_login	*login;
>  	struct timer_list	nopin_timer;
>  	struct timer_list	nopin_response_timer;
> -	struct timer_list	transport_timer;
>  	struct timer_list	login_timer;
>  	struct task_struct	*login_kworker;
>  	/* Spinlock used for add/deleting cmd's from conn_cmd_list */

Reviewed-by: Mike Christie <michael.christie@oracle.com>
