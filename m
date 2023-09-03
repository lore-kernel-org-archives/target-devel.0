Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 226CCC83F2D
	for <target-devel@archiver.kernel.org>; Sun,  3 Sep 2023 22:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348029AbjICWfs (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Sun, 3 Sep 2023 18:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240826AbjICWfr (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Sun, 3 Sep 2023 18:35:47 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8168C4
        for <target-devel@vger.kernel.org>; Sun,  3 Sep 2023 15:35:44 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 383JSVPX007922;
        Sun, 3 Sep 2023 22:35:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=p43pRvKz9oNMT6rrC/e8+xyRQz01cRsI34g3YMDdS/k=;
 b=0HzpjNGIkdeUuovpOpptRClM3svWbXniMzmnmPLIsQNXe7tcSrTihv3UI74/NMUZES4H
 4TIsrubHAhPw3/hX6f+6kiAFacn2LECrpoQnJwrzlSKjzQ0dhllEd4IOI7KBNgJ21P+4
 Bmb51ODUD3XNUP2DmItrdqZJiaecGvpF2+DXPhPKB04anCtjX2ajPtAYV9fOVpdXvq6P
 KfdQiaIPMccJvVAroj5ePuDTB2Dtu2atptq5uEV3UZSQpHMAUvK0MH2mENwtfCCE6PP6
 VCUSlczzFB4al/1Xo8dwzn+bp6SZuK6X8O4wsKte0pejnftmhHuBxtcx9VBPMqcBxKf0 5w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3suuu3j1c0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 03 Sep 2023 22:35:40 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 383JUa9r030732;
        Sun, 3 Sep 2023 22:35:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3suug3h6kh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 03 Sep 2023 22:35:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U8xuLxW+4P5FphehUbiaUIlTdZo1JwEnrFtY6blXciMl88xKR5PBbV2CnCwpI6ZxRxWYaccVIutt7idXgVTZJKkx4PpzREy0PKF1gL5wrKI/yTo4P6ZIflZRoHfz6HRQHQe3S50ppcEru6mCm79VMSggItvpNJI1B1eh+dyulRzB9wpNT3I/IlK6V0kUkZid5nuQ8lmU4uVcgk9zXeSHA6OsJ9RmaGdRHdnJSaXhTXf+D/46skyqAhJsOUHPFSH62nLefO/+hMoW2kNpTxSXwwIz6RGrwZysBmQuy5Ia+0fqi3BiKG35/hxOFBd/zDq3jMPFk5+itcfBiv4fH4yzKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p43pRvKz9oNMT6rrC/e8+xyRQz01cRsI34g3YMDdS/k=;
 b=ZVsmGRqkw6JoWo/kZq+4XCOabnWfBaJQlam4HUEza8hTefgZXQeUJnvi27SnZBteuMERSbPiEceteVz5QYcPt1Q+Yz8Fd59pii/WHHLEz35jdmr5DgDF244lp177G1F3SCRyNONi/ei2tBXLSYM5mJIX+baw5Zsa0Dr1I+lpAq0uNZSQ0C6XcZeaa6e3UdVcyaDujLuwp79eN3eqs5X3urtMMol3itD1V0FdjLKIOuwGGHsYO3wci7pKH7F5pqiozJjM3JJWdRTsswivISr7o36+PI+eO25/fJV1uoOye7JO9E0imYrXh1na9pMc6NghBzKABfHxISjLNF5gV6vv2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p43pRvKz9oNMT6rrC/e8+xyRQz01cRsI34g3YMDdS/k=;
 b=JxXJJFX+FvQNZ983uYI0MFXYPAKwxqdzY/zADY/YioyAJO9l8LxUd2LONgGVIB3hLe7asKeQd52cONzQNmU/ODpBcH//bLpz3f/Knvvsm69lXU21kWtJKjnzi2VpAI54sO2Gp0N+rxIdgJ3A8Ew7AtGqBccHo4VQ7ixdDbpynNg=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB4969.namprd10.prod.outlook.com (2603:10b6:610:c8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.30; Sun, 3 Sep
 2023 22:35:37 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Sun, 3 Sep 2023
 22:35:37 +0000
Message-ID: <e0d275bc-8a6c-409d-9e5f-c6aeaed1b6d3@oracle.com>
Date:   Sun, 3 Sep 2023 17:35:35 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: target: fix target_cmd_counter leak
To:     David Disseldorp <ddiss@suse.de>, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com
References: <20230831183459.6938-1-ddiss@suse.de>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230831183459.6938-1-ddiss@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR08CA0039.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::13) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB4969:EE_
X-MS-Office365-Filtering-Correlation-Id: 00e395c9-9807-4825-bca0-08dbacce1839
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mIHwSmHLIBsb/BCfHUyNcMMYLZUFCgrU+aVh+mlnRrRpbtNijZGtylQmxyc9JWB94cyadmxrScT2Ap+moMj9CRY1OGDneeERPAytwzGo/S8HjcAsNeKopVRgwmtnbIHYXF/mPL+B/3LHLZ/iacmYsoz07N66Dkrm+It48O1L1g+4RsPKgoqrflXNgpmdUOS2kvSbD1bQcOMETx0l6TPYO7MDQ5zWAkbunJNvkuDV364CuwplDFy2i59Md7SzrU503rS0M7BBS4EVIRvzNmd5vSVwf+7gL4kV4+EcnwtXFrakXHKsAqptJLOetzTPd4z03um8RSEtdb+idV/O00mM5jyy5x9CLqN86XnEphn/GbbdC9Xal/6xmIEXc3sna4XgzWCDwRAacKVn0Pgu+87nxfKB/T4JVxbr+3Utyb9KS9Tdmp8iauRlDWBc2E8aWZS9a7MJgZYtjmflLjezBaLa+R4IHfmFLkts6A4ccIJq7AhzFPbauejX7nTZ9Pb1Pjd5w2Gk3R/j/K4d4lxFchhPD/SLh4AeoChqhcoposuyfod3TGtsINsNTDDN7VmmuyRIPzjFxm2o9wFxhJiqG1ieoc3jILkdNFtA+g5ZV5itOi4Pakbewj/HkgBTBmBGAnILlAC/oxW+Egr/4bZZsfh8/jnTeIfd+1Np5dNTRE2H1nYVnuLJ4Bsv8Uo4FaPM3ucU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(366004)(396003)(39860400002)(346002)(451199024)(186009)(1800799009)(31686004)(26005)(8936002)(4326008)(8676002)(2616005)(5660300002)(107886003)(6512007)(53546011)(6486002)(6506007)(41300700001)(478600001)(66476007)(66946007)(66556008)(86362001)(31696002)(316002)(38100700002)(36756003)(2906002)(45980500001)(43740500002)(505234007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ODdZaXBmbEV5RlhzQTNUTlFUTVhvT3NTN0Zrdk1KUTNFb3lhZjJQWXhydWh1?=
 =?utf-8?B?RlRIeVROa0NOVHVkU0dNM3dIN2Y2bTVpd2d5ZHF3Q2dpSVRGOERwVmVhaDMr?=
 =?utf-8?B?Z0R0RXUyZ2ErMlZlcVBwbDFWRll5aFdyVy9mNE1tMW1PeGgvc25CVFY5YmQz?=
 =?utf-8?B?V3NlaVVKd2E1TnA4RmFSL1R4djB1MmFkRHVHbmdvTVNpZ1p0MVVDRW81cU1t?=
 =?utf-8?B?SmNXM3k5UWNCVVRxL0FaRWlQdXY1L2lQTkxUTWcvWGFwam4xSjJXRWhmdHVK?=
 =?utf-8?B?SHNoa201Z2NqNFkxVVYrRllsYUJLL3I2M29tQkpCVzMwUjdjWUdRTmpTQVhQ?=
 =?utf-8?B?ZEdZN0p6TEIzMDltTkp1VmRQL002MkQ4bzFLQ0xPQXFKbXpvVXBOSkh4eHRU?=
 =?utf-8?B?cjlsRzJqMzJGUEkyd0JGbldCbGNOaUN0TEJNUHZCR281aWFPc1NTUmU2S1RF?=
 =?utf-8?B?MlFTSFFtMGJrTGFvWVYvUUlYNk81WTk5YU9nVmVkUi9ycXBrbTA0L3ZCb2RL?=
 =?utf-8?B?dzBmR3p5VG9GK0I0NXh4UEx6VEpMWGEybkIzd2FYSTNhWFJsdFE3dmZzNnE5?=
 =?utf-8?B?OUUvT2NqbkV3d1VmTmlPZDNvcEhCU1FwMFdyODdvYWZZeWI0ZUFrQ29GZ1Qv?=
 =?utf-8?B?MFd3b3JUTFZHVlhNdjBFUzI1bHlHTFdTaVBWSysyTFZocTQzUzNDVTVLbmlT?=
 =?utf-8?B?YjVjMERUY09YLzZBdmRiU3ZiRjdSNW9FTC9mcStNZSsxbTI3dlhpdklXc1lF?=
 =?utf-8?B?V1VZSmJrVGp3dnkwcnZUWEhoQnI4NGFzQXNHWERkZzJKS2FRVGFWQ2luUHl0?=
 =?utf-8?B?VkdXVTVLTVpzbVllWmg5UkdlaUNiRTRpODY5VWdSL0ltZS9CeUI4Z3Q3MzRC?=
 =?utf-8?B?bVFiaElYdW1VMmdxSjdyenR5RG12aHpsTm5oeHl0VEM4d2w2aElnWDRjb3ZJ?=
 =?utf-8?B?NW9Gdmw3NUNmZWhpUXd0UnRYRHFVTHVsbGFEcWw1cUZEaVhIemdhR2F0R0d3?=
 =?utf-8?B?MEZRajhOTE9IbHV5UTNKbURURmhFb1dPUGFubnJCMVFFSElNWm1MSFNXcjV0?=
 =?utf-8?B?elRJMDFDbGEzNTdyQWQ0VWZNbEd4czFJelJmWmxodk5BU2hzdUZ4eTFRTnZZ?=
 =?utf-8?B?MHFkU1lmc2d5bEg3ZElzVFJEUElKODFURjFJeXpFUEUyeTB5VS82MEdkaGNY?=
 =?utf-8?B?b2IvQWVKbjA0NTRUTzR6SHZCdVEvS3NLUUIxTUxEY1hVcUx1bXZlQ0YxM3NN?=
 =?utf-8?B?TXAvbm90RlliRlgzTWJ3SnV0ME5QazdUSnNlYU9odHV5WG55UlFJOVMzaFVQ?=
 =?utf-8?B?SlNWUWRrdDkzckVPSVlXcmpQMjNjcnd6MHhJK3EwUGVyVmtNbG83RXhGdXQy?=
 =?utf-8?B?Mzh1Z1BtN1BmSzdzWVhMUk1LRCt4MEE2QXUxT210d2owRkthMG12bmYvY3VU?=
 =?utf-8?B?ZjAxME4ycDlRakpCWCtFYWZIanUrVGxUNlhpQlhtcTZaUDJGQjdaQUUvMFlk?=
 =?utf-8?B?VktnRlhQNVlrVHRvNnE0QmNTaVI1TVBtUSs3NmNySmVEMFZvbGVEN2lIdjRJ?=
 =?utf-8?B?dWZIZGVrdFVZSlVMQzUyQTVzKzJhcXhOTUFqMHNDWXV3ZkE3WW45UG9MMnUv?=
 =?utf-8?B?aFpaditVZU5IT1dvc3FjcG5uL1EwTnlkemtiTDR0OGY1b0YyekcwTW45dEpG?=
 =?utf-8?B?ZU1NZG42MWJnc3RQZEQvN0ZIMHZDNHo0eGtHVVlUSVY2NG5kWjBGUkw3bnpx?=
 =?utf-8?B?WHdSajVTc3FFS3JxRXdRRUJOZTBwUTQ3T1hmSVM4bzg0MEZ4dU1VbXZwdkdG?=
 =?utf-8?B?TXZvUmRFK2JBN1h4d2lWQlRwT3VQQjdYSjNlN253VzRoaG1Qd0RPY1Z4MjJU?=
 =?utf-8?B?clltV2k5NWt6MHI3WlIxeG10Z0h4cGIvWndPSnNzbzZoZVd3UjQwcE1MNHZK?=
 =?utf-8?B?NGYxdFhnZE9ZVm90NFdybC8xZEFPVUoxR0xsMlgwdS9Qa3d6OEduSzl6K0Nv?=
 =?utf-8?B?L09hZ3NJUmR3WTZOQk8vOThhc1B1cUQwZFRRdmliS2pvY1B0RWNPbHJRNmlK?=
 =?utf-8?B?cFNBZmtPOWg0L2pJSXNsT29mOU9sTXpJcC93am5MSXhuL25Ha0FXVjJVK2Ji?=
 =?utf-8?B?V3YxcDhEQWRGNWRBL2o1cC9KbTVHRUpFTy9qTTdCRVlHNU0vZ1lSdmQ4cEY0?=
 =?utf-8?B?U2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: aI6XvbduN/Gwl3+8OWl9KQZ11ZCFQUlP07ylFQsHQiQdDsQtoYJJdT0OlSxgieDvedGk7k928k9gvUbQvMQ/RBMEw+mcmJhzwteO0TE8mIvzJPm1Z2ZekcMkyv4n25GXp7+CezPh+OMc+fJgqZ3wZjKlyomTrvDpyJBSLQE2+eKcVigAk4gDxqcjdWXjNq2Y1ouPR12x+NSw5UGjymgKo0g0F7TRxYpSfx9SY+wnleraPpOM+9K9TU8xhXd1dMia+lUVVU+D8C/vm2wwIsjJLy82NrrdE4oPDIfle/AI/1Waf9/ytIqIhqhFkB16LUcOhpPaT0S0SE/nEVoq9ScN7GKakiklsaqzCGMGB3vPTTI5YfOFn2UoL2Ij992HmtyalI9ivWt9ZdxE+EHYmB6xQlaHj/hcI3TV3tfFxWRe18UjkxQykzE9+fSrxz5mGAuDC7HGRNnnWPwxOVj1/U6WbxHOsJGhL1gb9r27rDCJYowiSoghYIWKFenHSOgCk3Zwuay32ekmt0lLqbcZpwfGfZS+Af7UxghLMVepY1N0ul8vdxaImWZlh3886Babdoy2/WzdeiB45tdSqz5MTxXFqFDWAJNYN6EvmNUkna45lseY/upp8R7DrKv8O2rriRjnV5lij9HbXJZ5gxoGXJjas1h+iCent9oM7sXeDXQrgmVxAocAwFNab7b4JwAs2WaEgYocJ0K/3gKu814ncMg2jlDGWgel1dWPQQUY1IB+vAVjDWRHqoqjRuxGntjxZNFfmxjUyfX06QHeaEJa8Rzjs41fmO8LCMm2Dlwd5wl0wEI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00e395c9-9807-4825-bca0-08dbacce1839
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2023 22:35:37.4445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N5Xrva5lXoUQfpcIgfoyM1sD4eLTiAOmuv48BPN2Wuc78KKuPjbtnDdwjJISs6/HpsF23cuoJljYd0Enstza5QU1V6UDKjQzh5wwWwDoisk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4969
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-03_21,2023-08-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309030213
X-Proofpoint-ORIG-GUID: QukMnCz8vbSgKTauN40Tx1YgVaCIq-g_
X-Proofpoint-GUID: QukMnCz8vbSgKTauN40Tx1YgVaCIq-g_
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 8/31/23 1:34 PM, David Disseldorp wrote:
> The target_cmd_counter struct allocated via target_alloc_cmd_counter()
> is never free'd, resulting in leaks across various transport types,
> e.g.:
> 
>  unreferenced object 0xffff88801f920120 (size 96):
>   comm "sh", pid 102, jiffies 4294892535 (age 713.412s)
>   hex dump (first 32 bytes):
>     07 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 38 01 92 1f 80 88 ff ff  ........8.......
>   backtrace:
>     [<00000000e58a6252>] kmalloc_trace+0x11/0x20
>     [<0000000043af4b2f>] target_alloc_cmd_counter+0x17/0x90 [target_core_mod]
>     [<000000007da2dfa7>] target_setup_session+0x2d/0x140 [target_core_mod]
>     [<0000000068feef86>] tcm_loop_tpg_nexus_store+0x19b/0x350 [tcm_loop]
>     [<000000006a80e021>] configfs_write_iter+0xb1/0x120
>     [<00000000e9f4d860>] vfs_write+0x2e4/0x3c0
>     [<000000008143433b>] ksys_write+0x80/0xb0
>     [<00000000a7df29b2>] do_syscall_64+0x42/0x90
>     [<0000000053f45fb8>] entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> 
> Free the structure alongside the corresponding iscsit_conn / se_sess
> parent.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---

Reviewed-by: Mike Christie <michael.christie@oracle.com>

