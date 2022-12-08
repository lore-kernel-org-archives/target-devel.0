Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97442C3A5A7
	for <target-devel@archiver.kernel.org>; Thu,  8 Dec 2022 03:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiLHDpd (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 22:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiLHDpc (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 22:45:32 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73E37E412
        for <target-devel@vger.kernel.org>; Wed,  7 Dec 2022 19:45:31 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B7NNiwP008653;
        Thu, 8 Dec 2022 03:45:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Pd5x8A84XQaGXyopRcBFOcedjSFeQYN1pKH6SnPc3uI=;
 b=klfz6JqmhnZfadFAfaZAIV94W0/KTLXHf1dZ40PqKZTv2Vjbd2tGM8jbUzMOWCB0FVQZ
 5TP/3DPlydUfVYMx9HCzHqzQIHhaLp7Uy9ew+oTu0ITYIsIGf71O/dAfsYzjLb+uvng3
 8uW0RZoNP6pM+YreHg7kksy1O053n2/DX7MdVD0mzB8B5zfthmY8rgS/Or4FHnyrKH0Q
 BUo6PQvQYdU1sFLz40kAe7Rj/HDXmSiDXLw9Rn9PpmYsTn3YxEXJPs2WCw/6sbN8ApeJ
 D214BadjNCw8RjtltMWGaKErP6k1MIj4xq8VI7sX6PVD521V12acN+8sEP6PBfsRRRsc UA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mawj6s1ke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 03:45:29 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B81o4cg033800;
        Thu, 8 Dec 2022 03:45:28 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7xnppf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 03:45:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BdeLftJuFNzs3s/ZhOxf8eSkhQEy7FVQnKw0jvTthZUJC66kQGe4diq/MYhTJZrwyJHQJdsktAXaE4/yBW6EuN3OJdMzBpmEqHfzxeej1HbV4fbL/hTZiBWJ39JcaaOJ1msv23hPJFkwqvBQFTKSOdF2EIB3QL9SwoJj/iu4AUsIqHMjMuJi/b6lhrT4o7C+jUM6OPJJ20z//eplMT9++bs6bYGyYo+KCWLLPX+eN/ueI/Xe42/HdojeYCRE5kyi5O8R3AwygM8BV1/rEqC6nevwnRgmwzVZQ4eep5UtW6Q9nFEyaCGyFITWlc84eBs8BG6uBFEJ5nHh6ZNtgZYl2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pd5x8A84XQaGXyopRcBFOcedjSFeQYN1pKH6SnPc3uI=;
 b=iYdQ0BUAfMnnxcbqehryezvZR5YFWZmRWROGce/rUybLm6f//PKhrWfG2Cg7E2ovTz2kI08LazOkOqXnBzFdQM7QUJJZo25lXxaNqOy9MBoUUBuHmRwB68Ofqk+AMXGdDfl+Bor20jbQ2KhqZSKZLjU2be57e6hcVQS9+MJMy7m8kZOl+y/nEGCSSj7g5MdAxLmHs/+3Fv93CFiR6yJXbq4FA2wLB61EAxPbyE/w9SxsLWySOoOd55hvwPMlypuBiyWvxV9z2XjOniGWxmIt9sqsZdh36kOE3v5oHU517QquEEg0uu8DRs/DaWAuImOC6/oxjcNb4vnxhySxpdFI1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pd5x8A84XQaGXyopRcBFOcedjSFeQYN1pKH6SnPc3uI=;
 b=h2Efq/VubKGeeu2BddVhxOp1Ss8bD6JK2irBv6ByLUI9LKLVHcRmOftd/VfoxWSaHQxyQCtvhtLRiZHvTMakxQJt3kUUbCaE/k1kOYjzmLZErvgO6zIqEHw5tW2/sZ2zA9a4oZ2z7VN/R2KC79gNvb54VUvATW9YdyZ8S33NQao=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB4274.namprd10.prod.outlook.com (2603:10b6:a03:206::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 03:45:26 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 03:45:26 +0000
Message-ID: <457f3c8b-87ac-dcf4-6e6e-a41321d2151f@oracle.com>
Date:   Wed, 7 Dec 2022 21:45:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: tcm_loop and aborted TMRs
Content-Language: en-US
To:     Bodo Stroesser <bostroesser@gmail.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Maurizio Lombardi <mlombard@redhat.com>,
        target-devel@vger.kernel.org
References: <CAFL455kjQeqvPqd1CUqs7f6xUjrrDqR1h7edizusAtj130HCPg@mail.gmail.com>
 <caad6a7a-c30c-a3ac-7932-f5a19c877ffc@oracle.com>
 <e07f0fa5-d59d-36f2-d99b-73e32af3282e@gmail.com>
 <20221121133550.GB5248@yadro.com>
 <addec585-4271-cd9c-fcf0-fd780f269aa8@oracle.com>
 <20221125084920.GC5248@yadro.com>
 <0a6eb2d4-1158-5268-27d5-454edbf9f566@oracle.com>
 <87d2d228-a4ac-9103-0f1c-57c691f91f0f@gmail.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <87d2d228-a4ac-9103-0f1c-57c691f91f0f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR13CA0017.namprd13.prod.outlook.com
 (2603:10b6:610:b1::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BY5PR10MB4274:EE_
X-MS-Office365-Filtering-Correlation-Id: cb40044f-d1d8-41f2-2ce5-08dad8cea3c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cx0tG4BAEBzShiOPe2oGR/6iqhMSwXgo0inZLjI/+BmcTa9vj8vA7bxWD4BvPnexEV5ssJW/L1oobwepws4ReQKyG2vcX/80/RQ7O72Ml1yqjw5r6hkwQGYnkVNgCqenTRXOYUUXJnLsG1XNTlKM53YgwnWtkMsS3DXED756B1RA89ojzDsEDaVEHp97n8QcQECCl4J8ZzR2Zxuof01jU0TH9WX4JGNzSiOLY/PdaNM5ObW6gTAacjprleGeKMqumV7DACdBv9jmOy5kaKfzhJ8OHrv8re/wNpyWFqyCCTT/57c12sjNCV5aG7MwX3AJKqcQQ/8lPNH2BCvxO/J0R/YEvrDOp01Z4cUoJIpZ4ZX82o//DxBYsFjcQSsmvl4B855axV/3LJTqv4LDiWAGTmHIvrFV5m1HHPj9wdyB05NAVaQt+yXOPGeFMw3Mv4s5BhllZkfgPSTsF4orLq3mn0X29OqpLxZ6suFKBdYaiwHFoU/rKvXgDSVsAzb1SNmjuhCKpuIaF6ID5m+J9vXid04wTt/YG1Khkd+uBsr74uYLJqUxLF6QJtk1cn58kfYJZiqwXGefSw/nJvWHC3AOYcpyV/WmNbeib7gpRODHmoh0qqH0egRBwrV1N46CCgT6OSLtFsoD+74ykZq54ESBtRABD/wC2WWXZ/AWGSrdGpbH8e2WmLFenYbB9iblDO1TfrB8GVmx27i1e5AMpSgaj8zrLfk4uc0pg7r4I5WirjM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(346002)(396003)(39860400002)(136003)(451199015)(36756003)(31696002)(8936002)(86362001)(41300700001)(4744005)(4326008)(2906002)(5660300002)(83380400001)(31686004)(66476007)(6486002)(316002)(110136005)(8676002)(38100700002)(2616005)(66946007)(66556008)(53546011)(478600001)(186003)(6666004)(6512007)(26005)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WVBWQWRuaUhBd3ZJeUg3TEt1dHVveDlXY29RRk5FMituMUVzcGFDaTRJZG90?=
 =?utf-8?B?eVI5SU8rcjFmeXNTQXBGZHU1VlJLTmFZT1VuczY5WEMranM5RU5saUpRL0pY?=
 =?utf-8?B?L1FJOU9SUjlPYWliOU83RTBEWHV3bS9tWnk3Wmp0aTk4Zy9XZXpYQU5MSlhj?=
 =?utf-8?B?TlNrUzcwR0djYkxKVFUxZ3hKNUJvMi9mV1BJYk9Mb0poYnBsSXFjZUlNK0JH?=
 =?utf-8?B?OEJJb3ZtWElmZUsvTVloTG81ZG5ocVdoVCtmVFNFMzg5ZUhhQk81STZYOG4y?=
 =?utf-8?B?UnBDZ2RBL2YrcDc5T3NCNnc0d0k2Z1B2Z2NhdUsyeHVFcEdxMmZDUzFXT0w5?=
 =?utf-8?B?U1pFRmdPY25rbHhjVEVpc2JSVWRBb0NYcm9XdkhDUkl0dnZwcm9HaEdUSXBu?=
 =?utf-8?B?YmR1UHdrRm5hMTFoUXFDWkpiSmcxR0Q1d1ZxaGEvTDc5NkQ1V2drQzExcUZ2?=
 =?utf-8?B?S3RHN1dsbWFzSVlmK0lRVWlJcnV0cGxmeHRGb3o5aUlHcmZuV1JybFFCdVFa?=
 =?utf-8?B?ZUhSZi9UNFJUQTdOQ2dLOVJVUURXSGxSZDlMVkpSZlMvSGFmUE83djY4cEhN?=
 =?utf-8?B?ME11VjRjV0JxVDZBLys3eW91MmJ5TEU1UFRseS9neS9VdjVwREtBZXN3eDhF?=
 =?utf-8?B?UnFkU1NWQlJLTUtqV0s0VGlGTVp1N01hOE4xL3Zhdk9wSUNBdktyTlFzeWJ4?=
 =?utf-8?B?S0F5UzVyazdhUUFNalRrcHY3SVI3N0pqWEJoaWwrTkpEL3prOEYrcVA2R0Ux?=
 =?utf-8?B?K3hwUG1NcWdiZ2UrYlVXUmIwamY0dzl3R1E3SzNJKzRQYUdTRW9OTWFhbGJC?=
 =?utf-8?B?aDNRU1NrOHhRdm9jWFM4d0duSUUxS2lUMlNrSjNGcnJCc20zeGd0UGp6NXlx?=
 =?utf-8?B?R0lzV2hZTUg5SHhRaHhhRk5wVG1OOS9HNDVmZnBlNGpWeEd6cUp5dE90cDVV?=
 =?utf-8?B?NDVxeTVEV0dIQVlJQmFsL2hBOXp0UVg4L05UWXVuY212VGxzcEZNR1haLzlK?=
 =?utf-8?B?SWIvQlR1MWR5RkdpM2ZEV2FGdVVTdEkremZmaFBYMUdLWWEvU1FDdC9xZ2Ex?=
 =?utf-8?B?cXhVV2Qya2RwUVh3S2pkU0o3NUEwK0ErNGZIL3BQZlhkRFlDaHpMVU9xclI2?=
 =?utf-8?B?SkdjMFdBN3c2UFI2WFBSeTFrMkFZelIveCtDSGpkbjhUM0FjTklXVnlGZE5C?=
 =?utf-8?B?blBsME5sTzJoamlzZW1NTXJkU0xRRE8zVGQwMnZnSThmS2tINUM5d3FZeTlp?=
 =?utf-8?B?RmJRaG9FcHhGck0yVlRuM1hjdTFSYTBQdUNaYTFWc3RLZHpFNXg3dUUrYnp3?=
 =?utf-8?B?YzF0RTQ0c1AxTEJSWGlyNitPbXdQdjBieUhnMHhCdnVaWXNXKys1NmxVS2JJ?=
 =?utf-8?B?NlZsWFcyaHBXR2hnZzRpdSsrbFVMNW80S3BtSnQvV08rUnhEMmdncVJpWlBz?=
 =?utf-8?B?MnpINisvSVpacSs4dlpHSE12WXRSV0VnTjQ1ZksrRXhXUlppVUNYbnBTSGkv?=
 =?utf-8?B?L3Q1WjhaMVZtSlcwMzQvN0NxN2lkcm5iN3prOXI3MHFJdWRhUW1XVjBwWk1C?=
 =?utf-8?B?SXU3ME5tOFYxZkJGTXhXU3RPem1CVzY3eXNOcncxbnBEL0JEMEN6TEE2eWtx?=
 =?utf-8?B?eldBYmJkWmdNVFhjWHBUSlR5aEJVMmFZR3Q4aUsxU0FpNkRHRTU5ZEpYL1Zj?=
 =?utf-8?B?WDMrYWpnK29JMHlpd3c2K3c0OU02dFJQNTMvc0M3RXBtc0pxckJzT0JNODBQ?=
 =?utf-8?B?aHdTYlRFSms2T29xQjdmTkhMZ0JJL05ubXI5Qnc2bUpXMWlETFkyUUlFQWI0?=
 =?utf-8?B?N250aC9sQXlTSFRaSEd2dzczU1dxNC92a1dPT0pydHFqd3FxVjlndFJGT0V4?=
 =?utf-8?B?aG5iSHN2REx4VFUzZzdnRS9IbkJmRXlJVmlQaGdJOUd0ZWczWlRGYy83Tlcw?=
 =?utf-8?B?N3RhTTZQanJ2Qnk4SVJyU0krdVdMUnpXcjF2SXZiSlYvVkNEb2lqRjFhaWRG?=
 =?utf-8?B?T1ZjWnNtTU1NM3k1ZTVIemZBUkk2RFI4MEZieEVPdXVDRndySWltLzBXdDRh?=
 =?utf-8?B?Z1lKRzIzMEY2aVVteTZ0VXl1QTVsYURXY2tvVGRCN0xYOUNJbEVEWDhEZzl6?=
 =?utf-8?B?bEo3aDg0K21mK2tjeCtlSC9nRzVURW9kZmYvYkFFMk9IN0dKSEF4ODBuZUdM?=
 =?utf-8?B?d0E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb40044f-d1d8-41f2-2ce5-08dad8cea3c4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 03:45:26.2813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: osbOacvhTVGaNL8nmQ42nj+iPqjCiRY5z6/5ku/udHbc9elNXUFv+owtFx3v3bQY+mD1HPvfr62fi/iDdqEzrk/uUnwcCDJiBtVH7XSnIxk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4274
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-08_01,2022-12-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxlogscore=842 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212080030
X-Proofpoint-GUID: W6blwC2nsD81FUQfoKt3weVSD9Q9GW4F
X-Proofpoint-ORIG-GUID: W6blwC2nsD81FUQfoKt3weVSD9Q9GW4F
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 12/1/22 8:15 AM, Bodo Stroesser wrote:
> Are we sure qla, loop and xen are the only drivers that handle aborted
> TMRs incorrectly?

I'm not sure now. When we looked at this before I was only checking
for crashes, but didn't check if there could be issues like where
the driver needed to do some cleanup in their aborted_task callout
but hasn't been doing it.

For example ibmvscsi's aborted_task callout won't crash because the
fields it references are ok for a IO or tmr se_cmds. It doesn't do
vio_iu(iue)->srp.tsk_mgmt or vio_iu(iue)->srp.cmd in the aborted_task
callout and just accesses the se_cmd and ibmvscsis_cmd. So we are ok
there. However, I didn't look at the driver to see if maybe it did need
to do some cleanup in the aborted_task callout and we just haven't
been doing it.

Same for the other drivers. I only checked if aborted_task would crash.
Also we have a new driver efct, so we need to review that as well.
