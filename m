Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA7C440F
	for <target-devel@vger.kernel.org>; Thu, 23 Nov 2023 02:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ti32kRWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F24AC433C7;
	Thu, 23 Nov 2023 02:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700707975;
	bh=rRbIXqjq8DKBA6vW+7glleky65j8TQodsqrm6IeWtY0=;
	h=Date:From:To:Subject:From;
	b=Ti32kRWVHfrQGjBaWggmCW+u43SIqwKpTvOhvelCELB9SkY+vV7b1LJS9FsGaZwHO
	 mzZjlW4Ed1v3j8+KDl25JShMh/pGhBEGuJkmYkTEEFgfEtVqzdgBmsNaiNpPfo52N4
	 r0HhVlDiybSDyPl1U3dTpHEScJ3zdvYSVD4pxxBU=
Date: Wed, 22 Nov 2023 21:52:54 -0500
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: target-devel@vger.kernel.org
Subject: PSA: this list has moved to new vger infra (no action required)
Message-ID: <20231122-hopping-radiant-ermine-ae8c11@nitro>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello, all:

This list has been migrated to the new vger infrastructure. No action is
required on your part and there should be no change in how you interact with
this list.

This message acts as a verification test that the archives are properly
updating.

If something isn't working or looking right, please reach out to
helpdesk@kernel.org.

Best regards,
-K
