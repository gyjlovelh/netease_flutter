class VideoGroupModel {
	int type;
	bool displayed;
	VideoData data;
  
	VideoGroupModel({this.type, this.displayed, this.data});

	VideoGroupModel.fromJson(Map<String, dynamic> json) {
		type = json['type'];
		displayed = json['displayed'];
		data = json['data'] != null ? new VideoData.fromJson(json['data']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['type'] = this.type;
		data['displayed'] = this.displayed;
		if (this.data != null) {
      data['data'] = this.data.toJson();
    }
		return data;
	}
}

class VideoData {
	String alg;
	String scm;
	String threadId;
	String coverUrl;
	int height;
	int width;
	String title;
	String description;
	int commentCount;
	int shareCount;
	Creator creator;
	UrlInfo urlInfo;
	String previewUrl;
	int previewDurationms;
	bool hasRelatedGameAd;
	String relatedInfo;
	String videoUserLiveInfo;
	String vid;
	int durationms;
	int playTime;
	int praisedCount;
	bool praised;
	bool subscribed;

	VideoData({this.alg, this.scm, this.threadId, this.coverUrl, this.height, this.width, this.title, this.description, this.commentCount, this.shareCount, this.creator, this.urlInfo, this.previewUrl, this.previewDurationms, this.hasRelatedGameAd, this.relatedInfo, this.videoUserLiveInfo, this.vid, this.durationms, this.playTime, this.praisedCount, this.praised, this.subscribed});

	VideoData.fromJson(Map<String, dynamic> json) {
		alg = json['alg'];
		scm = json['scm'];
		threadId = json['threadId'];
		coverUrl = json['coverUrl'];
		height = json['height'];
		width = json['width'];
		title = json['title'];
		description = json['description'];
		commentCount = json['commentCount'];
		shareCount = json['shareCount'];
		creator = json['creator'] != null ? new Creator.fromJson(json['creator']) : null;
		urlInfo = json['urlInfo'] != null ? new UrlInfo.fromJson(json['urlInfo']) : null;
		previewUrl = json['previewUrl'];
		previewDurationms = json['previewDurationms'];
		hasRelatedGameAd = json['hasRelatedGameAd'];
		relatedInfo = json['relatedInfo'];
		videoUserLiveInfo = json['videoUserLiveInfo'];
		vid = json['vid'];
		durationms = json['durationms'];
		playTime = json['playTime'];
		praisedCount = json['praisedCount'];
		praised = json['praised'];
		subscribed = json['subscribed'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['alg'] = this.alg;
		data['scm'] = this.scm;
		data['threadId'] = this.threadId;
		data['coverUrl'] = this.coverUrl;
		data['height'] = this.height;
		data['width'] = this.width;
		data['title'] = this.title;
		data['description'] = this.description;
		data['commentCount'] = this.commentCount;
		data['shareCount'] = this.shareCount;
		if (this.creator != null) {
      data['creator'] = this.creator.toJson();
    }
		if (this.urlInfo != null) {
      data['urlInfo'] = this.urlInfo.toJson();
    }
		data['previewUrl'] = this.previewUrl;
		data['previewDurationms'] = this.previewDurationms;
		data['hasRelatedGameAd'] = this.hasRelatedGameAd;
		data['relatedInfo'] = this.relatedInfo;
		data['videoUserLiveInfo'] = this.videoUserLiveInfo;
		data['vid'] = this.vid;
		data['durationms'] = this.durationms;
		data['playTime'] = this.playTime;
		data['praisedCount'] = this.praisedCount;
		data['praised'] = this.praised;
		data['subscribed'] = this.subscribed;
		return data;
	}
}

class Creator {
	int province;
	String avatarUrl;
	int accountStatus;
	int gender;
	int city;
	int birthday;
	int userId;
	int userType;
	String nickname;
	String signature;
	String description;
	String detailDescription;
	int avatarImgId;
	int backgroundImgId;
	String backgroundUrl;
	int djStatus;
	int vipType;
	String remarkName;
	String backgroundImgIdStr;
	String avatarImgIdStr;

	Creator({this.province, this.avatarUrl, this.accountStatus, this.gender, this.city, this.birthday, this.userId, this.userType, this.nickname, this.signature, this.description, this.detailDescription, this.avatarImgId, this.backgroundImgId, this.backgroundUrl, this.djStatus, this.vipType, this.remarkName, this.backgroundImgIdStr, this.avatarImgIdStr});

	Creator.fromJson(Map<String, dynamic> json) {
		province = json['province'];
		avatarUrl = json['avatarUrl'];
		accountStatus = json['accountStatus'];
		gender = json['gender'];
		city = json['city'];
		birthday = json['birthday'];
		userId = json['userId'];
		userType = json['userType'];
		nickname = json['nickname'];
		signature = json['signature'];
		description = json['description'];
		detailDescription = json['detailDescription'];
		avatarImgId = json['avatarImgId'];
		backgroundImgId = json['backgroundImgId'];
		backgroundUrl = json['backgroundUrl'];
		djStatus = json['djStatus'];
		vipType = json['vipType'];
		remarkName = json['remarkName'];
		backgroundImgIdStr = json['backgroundImgIdStr'];
		avatarImgIdStr = json['avatarImgIdStr'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['province'] = this.province;
		data['avatarUrl'] = this.avatarUrl;
		data['accountStatus'] = this.accountStatus;
		data['gender'] = this.gender;
		data['city'] = this.city;
		data['birthday'] = this.birthday;
		data['userId'] = this.userId;
		data['userType'] = this.userType;
		data['nickname'] = this.nickname;
		data['signature'] = this.signature;
		data['description'] = this.description;
		data['detailDescription'] = this.detailDescription;
		data['avatarImgId'] = this.avatarImgId;
		data['backgroundImgId'] = this.backgroundImgId;
		data['backgroundUrl'] = this.backgroundUrl;
		data['djStatus'] = this.djStatus;
		data['vipType'] = this.vipType;
		data['remarkName'] = this.remarkName;
		data['backgroundImgIdStr'] = this.backgroundImgIdStr;
		data['avatarImgIdStr'] = this.avatarImgIdStr;
		return data;
	}
}

class UrlInfo {
	String id;
	String url;
	int size;
	int validityTime;
	bool needPay;
	String payInfo;
	int r;

	UrlInfo({this.id, this.url, this.size, this.validityTime, this.needPay, this.payInfo, this.r});

	UrlInfo.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		url = json['url'];
		size = json['size'];
		validityTime = json['validityTime'];
		needPay = json['needPay'];
		payInfo = json['payInfo'];
		r = json['r'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['url'] = this.url;
		data['size'] = this.size;
		data['validityTime'] = this.validityTime;
		data['needPay'] = this.needPay;
		data['payInfo'] = this.payInfo;
		data['r'] = this.r;
		return data;
	}
}
