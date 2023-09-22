Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 747F0E7D0BD
	for <target-devel@archiver.kernel.org>; Fri, 22 Sep 2023 02:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjIVCVX (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Thu, 21 Sep 2023 22:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjIVCVX (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 21 Sep 2023 22:21:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F47818F
        for <target-devel@vger.kernel.org>; Thu, 21 Sep 2023 19:21:17 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38LIsUH2009895;
        Fri, 22 Sep 2023 02:21:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=VnE/PXXfB60yrjHqVKnSC51qgZjaCWtc2C45dKvF3Es=;
 b=rKM9dP5B8DaT/4cyWAbBnCD4zhhDDKnKx+rFY1sa0wMqfak7htQpAXnmXv0lyspDUbB/
 GNfw8moLDfsZSBQK+gDBK5tNXLcITJ+rSOGyMf/53J1vydHp9SHfGLcjoB0Ju11/z80z
 vJ4bjNfuFXg/Kildo8KfZgjl2845MrO4uUKu+31ml6qGFgn6I+uIvYwutO8qmhydwY9p
 IahBuI2jeg2ArmqP10gYKlaANwCqqsZ3bEbv/XR4kuKvBtw7Y90JP9NS7WtNM4dGd5Hu
 aGxNEo99gUWCnWuQY61w6+NYP2ATvCSmmoXgJqA6aoa/Gml1y4JmbuvJiWVT8BHtjeq7 XA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tswgnb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Sep 2023 02:21:11 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38M1sMaa040636;
        Fri, 22 Sep 2023 02:21:10 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t8u19d9fv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Sep 2023 02:21:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dSfPOvYtcL0GxFavCe6/f24uTj8Q5SxsBWThg2ZPL5ou5nLYUfnkp3tzZ9eHn0V8ZukJgcozKE9gKQ4ga/+62PX7tfyZN/dcXNyG91XNdK0lA0y+7tYwJ+uKSRx1i+NRFO+Z8sVGrrTMFcvCYU/H3VqBfoSLj7U2bRGy57O8FM0fMcEG4tZ+VrHKeon2ke6sE6j/sIvIm33Jap33FiWo4AmvqVQDUo+epzIm9IAjxy2+xNe7MIeKjznhdCRMTiBRlsNYz+GA6Xvw144360TB6H8RWj8t8oX+ZG/07Kp1rLvTIITQb0nrSLbS4exDF79U4W6itIdFsc7cIVII2BeIWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VnE/PXXfB60yrjHqVKnSC51qgZjaCWtc2C45dKvF3Es=;
 b=lMlbEa8Hwmn2BwCnYf0KiEghzOh0x7DtLRttM1qeDe3AT9d3iZbCnS/WVRevJKTYu4nM3QQ8ux58FaUkbddu6uMhB8PXAJBEYDCQiCDLl5I59OJSt8HBpk+YAeELZkXLbK9a4h1UA99cARaS5pUSYkAm6PHy8P2j2sUDWii4H6WzRbQh64okcwH+WQ14F+TVFez7/nTfmhtDK/eOpZXWxXfvMTDIPOhKff32eTtfzFv+A7Z9WlpS2JwQ5ixNQppSVUT8Bs7Xl//aPLGs7Vi9zC5c0ShqkKSooOR+z22QRMNZIb1WqA7XENWfbVkX2+tZCXdvdn1mOS6zX4PDjmNH7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VnE/PXXfB60yrjHqVKnSC51qgZjaCWtc2C45dKvF3Es=;
 b=kMiRfsssFlEc+csjN/DjNTNmcbXONHYvGyxUcnwXVd5IiYDG+co4VDBLDV5I2apL/+NYND7hPX0Xxu3Y1UBRn3roT0ZAt8j7Lz3rInlIRmzeD4Tkqj67ywO9PKx+Y1qgRVZbQEBuTf4cvLoK4nLah1ycQJwsP6+pC7JAQD2HfTY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by LV3PR10MB7981.namprd10.prod.outlook.com (2603:10b6:408:21e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Fri, 22 Sep
 2023 02:21:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6813.017; Fri, 22 Sep 2023
 02:21:08 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Mike Christie <mchristi@redhat.com>,
        Christoph Hellwig <hch@lst.de>, target-devel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] Replace most references to linux-iscsi.org
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14jjn3q80.fsf@ca-mkp.ca.oracle.com>
References: <20230920200232.3721784-1-bvanassche@acm.org>
Date:   Thu, 21 Sep 2023 22:21:06 -0400
In-Reply-To: <20230920200232.3721784-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Wed, 20 Sep 2023 13:00:18 -0700")
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0034.namprd07.prod.outlook.com
 (2603:10b6:510:2cf::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|LV3PR10MB7981:EE_
X-MS-Office365-Filtering-Correlation-Id: acbc7478-eaf4-4662-3144-08dbbb1294db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0vSGqIUasDRDmM4i2GGUgCDNiGzm386omd1n+DBilq8ZvgXzd7Z4BoSIMU8rgs3LNWz9RmxyhQmmaLwxAPD4vFthPaSiU/vJdZ7P9/nOaBzGJ5wxR843gpmYqJIT1r5FnAWi2xk0bECcrGrH/7VI/40x8DdmaGILddMdA4qeZo8E+WpAbqK9r4kg8X0HaJmwnOuy6pBRieJeaPFnfWIavNm9G+fhjACoNDNQgEoHW/lu0AUsb8cAsHoa/DvjYjqUN4/ic8jMMeVz3Su+dxPjN8zRu5XuF6HXTErzB6W9obm2v0U3BF70s0FasfzGkl6Zy6gcrVXn3z/ytWw6nqupyCw1e+jCKMaAAxhf1BGqqLIwowpgf7zMMVtjwxu5D2X5DEZZ4eSsTI5QL+uae4IlWMDq2RxIPMceqhalN7PzWVxlqzl0iieWE9BUfz/gJVbMpAH9r6FQI+0tKNYn4nfZ0MwjnUZFAvz1Gmkw9NU7a5SaleGIM/NiTa+IO9iANk7tR2HoJlwvbgtIG1u9D6CefgJxgJp+cmmeXZhJ1a23ZGc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(366004)(136003)(396003)(39860400002)(186009)(1800799009)(451199024)(54906003)(6512007)(316002)(26005)(38100700002)(66946007)(6916009)(66556008)(66476007)(41300700001)(478600001)(36916002)(6506007)(6486002)(2906002)(83380400001)(4744005)(86362001)(15974865002)(8676002)(8936002)(4326008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TmYrCRcBs845WfoosGQyGDUFjMxL1qBj9743RH3MMVwBDmWPb/TbT/ZzWwXv?=
 =?us-ascii?Q?0dtnkAAHyliBqsq76zQix1dcI+lyWcezac0SgL3uv5zsm51BgHuUOXZa0XoI?=
 =?us-ascii?Q?f8O2uZevBSTmo4aRthM1cmCzKvSPekl5EWiB+ykmxB/GaXi0oNIEm7GWkCOz?=
 =?us-ascii?Q?X7MijqHpKG7W7Z4Gt3rRMi2Zf8UuXi/Y56ft1MkipIjJGZ/lJBxTJ31ZEXNH?=
 =?us-ascii?Q?Icug1ofTY7gjCBHvfSzPcbNudqNWA1r6NF0ta6VGDMo3DVBZMsRMWyzV/7MG?=
 =?us-ascii?Q?01nxamWmE7TtUblZPCg7wP4/1lG7M1JkADNNvp2zK89LgSwZYqpMVSw6Weqc?=
 =?us-ascii?Q?HOxYWuhmufxlBedy6B5sNNex44nwo5S0wA/E6kxsN6o4ECKpK+UTGHTVzs0A?=
 =?us-ascii?Q?Be8KRkHPI7PDqMlJMLZtllhwXM7tAl8qrZrskhLllnKAcb8irmNl8cCJwiXn?=
 =?us-ascii?Q?kkGo8a3C3c+ZtZuQJB6VtPZesC987MsASYBusm5DnXqfE1hIsWv8PdIQAJg/?=
 =?us-ascii?Q?agYA6u8ybMy/tMDEMYLsLK0/1Uz6KuRKmyCQbxBFNc4+o86fzu4m7SvrgmNn?=
 =?us-ascii?Q?QVk/g/QcqQeNzxg4coKCCE1Q7PEBfAR839jz5PqyvYDDiCn4hSxUH4AfekZc?=
 =?us-ascii?Q?4YU0+zKpru6xGkAfo5dV1G4TYO0buoU5CnSq8aesfkp7HDSFyK1IdfWIt3tq?=
 =?us-ascii?Q?WD36d4/wk8qXPTkzbOvXZfhTtB+uxNB0GK1eIL3C06zGP7DzvRrk0yajpdL5?=
 =?us-ascii?Q?QyVkRJtsVU8U1vt64ZpRWeKt6fP5O9UTlw4hb+fwJK5qJzKFN93dleBIa7hy?=
 =?us-ascii?Q?qBTTms4Yg4RbtnCPZ2fHZOoXkuW1Kja5hCNu2B4RrEmByHYeJKbsbMYauKrE?=
 =?us-ascii?Q?D48++nXDwPlx+Ku/cgoSlBkkDQLPePSXo4J6POvgAozh0hivmLow5MxFYm9i?=
 =?us-ascii?Q?KxExuFr5qZxeyTBhfQJPcMPGvX0lsa/VGYZ/njjrXnnWXXhr0GnUY8N0+MMB?=
 =?us-ascii?Q?MO5l+lzh/XDgOzs1A0cx4VvPVeGnlio6cLRSiEMmi9s3kT+E7kPaOUiq0Sl/?=
 =?us-ascii?Q?IzZvZR4nsCjoi0Z1QU023wM0C+1W2JqCy6tRY4Z0iKbwnjoLi/uOufqB58sb?=
 =?us-ascii?Q?qr+wDxlTOQ2shGcSDSGY+0vCGJ8bimBTVQTHm3BRYFyKmWESxdCV7/fRbOC+?=
 =?us-ascii?Q?eO1JIoHKqSWPmj1Lfg1WCUoU1tU+9B/aiPCEdLNkMzVByHJSMNfX4uCYggxJ?=
 =?us-ascii?Q?Im+oZJB+YNEyfk5wAzj0k7fKXu14OKb0hzdyofZz1NyCwjDA48ciUgiz2WaX?=
 =?us-ascii?Q?so5SabziLBrIBezNV6/y03xU2lef4kaCn3V2rUEYRQkyJTB3eSOl+LeyPZje?=
 =?us-ascii?Q?7Q+Ud+9495RkJGfyVK+lmj8xLUunoUUGOx8bdVCCYPotG+wOQ9TJMiUdjw+u?=
 =?us-ascii?Q?7aoFNIqWI4p3mnXjd+PAJnccuO7pbOBRVgurkISimYgxeoeYgSMHbWvtuM4G?=
 =?us-ascii?Q?sy86/5nXeG2P5hX2m4zqgaeGSca57OW59s/YOwIMbZanYb8RTLJlL1cbnppo?=
 =?us-ascii?Q?hO7iO6dHj27Fy+Q0hL/fCwhyDB2obCjvrMS94P3lEKwo0/DRXA/+YVjPB6bA?=
 =?us-ascii?Q?Qg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: sPk6GbBaDm7ifpXQHeAA1VV82RD9yQmDItPljBQFdDkVLaOwTk/Ks0BFY1j9C9z0WXN2qNDokaJPfrbn+NG9yoYna2uItLc01GGa+ripKrU1wjw6iP8z1jbpfZqFAbkyIfJITHISuXFogLqs3lROC2RRwBEno77vogjdEEaCfLwGotLaVnhDBDV+LJwuj2MfDCTs1kPnNureX0g3f/y5TEFIC5Flqs/O6ha90oRfeMipGjfCf8qFClGd0/gdigg/nbFphpAomvjth3lMHuVS8H+pK71Dm04Iay/IfwGOKh+sWpBY1/q40NE5uC+ehK0pX+Ij0CaHHkeFhRwPDEC83uEBGmrB5fvGcyvvQxOGpezeJh5002grDnZVUSAkwnUqOwXyA6SQifkUrHVYixdwjB0DuniiQSAFyekBhFTxcM0EEsaabc8DVGEL3iTQGQ8QK5B9koyI1VITkHgdMomDuHzx88uWUjRnWMeobEqAXZd0/FmXW7htBqkDpYBIqJvJWBW7OeryJH7Rel34ZANsYFvZBwMuKm9QBO/wdKzDTL8pT5t18WyjR3CFPzHcPCj1qe7Z5PMzzV0GF0f8noFMKX+3z5EKwaXBSS+wJkd9SoDBogTrbFr9BKdU22CT0NVxKrmfWccu5WFcGeOwQWLJuo5IEZ6F1P4SJVhoyab1wLcQSbncxw9Pvj5ekKL/oOJLcOa6UzX8mOegBhKNaLGpwTY22rVtc65Pgu1jLDCGpsGsbg40z85j00sfidojsJJxI4rYgOwRYpTNTtFUsjO9Q2a0ySol17zZ2w+6tb/ZMdG1qawjhQUu4iqGg9ZLc7qhNDr7Cmbq3MOpOPizyxnlQg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acbc7478-eaf4-4662-3144-08dbbb1294db
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2023 02:21:08.5182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PEB1wbpkk466gMXYnfTLCIgph7QW6pzMzT5lvd+6AXuZltmpGbUJgBvD6Phjua37XWL+YN/xkbkdCMqKhPVRj71m4ET5v9hx17xbhyKsbUg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7981
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-22_01,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 suspectscore=0 mlxlogscore=916 phishscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309220019
X-Proofpoint-GUID: xcfSNzwVt-AxY68655ya_4dKDRhQ2BD9
X-Proofpoint-ORIG-GUID: xcfSNzwVt-AxY68655ya_4dKDRhQ2BD9
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org


Bart,

> Since the website www.linux-iscsi.org no longer exists, this patch
> series removes the references to that website. Please consider this
> patch series for the next merge window.

I applied patch #1.

I am not keen on updating copyright notices.

For nab's email I prefer the mailmap approach (even though the
kernel.org address currently bounces).

-- 
Martin K. Petersen	Oracle Linux Engineering
