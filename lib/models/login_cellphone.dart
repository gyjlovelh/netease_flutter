class Autogenerated {
	int loginType;
	int code;
	Account account;
	Profile profile;
	List<Bindings> bindings;

	Autogenerated({this.loginType, this.code, this.account, this.profile, this.bindings});

	Autogenerated.fromJson(Map<String, dynamic> json) {
		loginType = json['loginType'];
		code = json['code'];
		account = json['account'] != null ? new Account.fromJson(json['account']) : null;
		profile = json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
		if (json['bindings'] != null) {
			bindings = new List<Bindings>();
			json['bindings'].forEach((v) { bindings.add(new Bindings.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['loginType'] = this.loginType;
		data['code'] = this.code;
		if (this.account != null) {
      data['account'] = this.account.toJson();
    }
		if (this.profile != null) {
      data['profile'] = this.profile.toJson();
    }
		if (this.bindings != null) {
      data['bindings'] = this.bindings.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class Account {
	int id;
	String userName;
	int type;
	int status;
	int whitelistAuthority;
	int createTime;
	String salt;
	int tokenVersion;
	int ban;
	int baoyueVersion;
	int donateVersion;
	int vipType;
	int viptypeVersion;
	bool anonimousUser;

	Account({this.id, this.userName, this.type, this.status, this.whitelistAuthority, this.createTime, this.salt, this.tokenVersion, this.ban, this.baoyueVersion, this.donateVersion, this.vipType, this.viptypeVersion, this.anonimousUser});

	Account.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		userName = json['userName'];
		type = json['type'];
		status = json['status'];
		whitelistAuthority = json['whitelistAuthority'];
		createTime = json['createTime'];
		salt = json['salt'];
		tokenVersion = json['tokenVersion'];
		ban = json['ban'];
		baoyueVersion = json['baoyueVersion'];
		donateVersion = json['donateVersion'];
		vipType = json['vipType'];
		viptypeVersion = json['viptypeVersion'];
		anonimousUser = json['anonimousUser'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['userName'] = this.userName;
		data['type'] = this.type;
		data['status'] = this.status;
		data['whitelistAuthority'] = this.whitelistAuthority;
		data['createTime'] = this.createTime;
		data['salt'] = this.salt;
		data['tokenVersion'] = this.tokenVersion;
		data['ban'] = this.ban;
		data['baoyueVersion'] = this.baoyueVersion;
		data['donateVersion'] = this.donateVersion;
		data['vipType'] = this.vipType;
		data['viptypeVersion'] = this.viptypeVersion;
		data['anonimousUser'] = this.anonimousUser;
		return data;
	}
}

class Profile {
	int userId;
	int vipType;
	int gender;
	int accountStatus;
	int avatarImgId;
	int birthday;
	String nickname;
	int city;
	int backgroundImgId;
	int userType;
	int province;
	bool defaultAvatar;
	String avatarUrl;
	int djStatus;
	Experts experts;
	bool mutual;
	Null remarkName;
	Null expertTags;
	int authStatus;
	String backgroundUrl;
	String avatarImgIdStr;
	String backgroundImgIdStr;
	String detailDescription;
	bool followed;
	String description;
	String signature;
	int authority;
	String avatarImgId_str;
	int followeds;
	int follows;
	int eventCount;
	int playlistCount;
	int playlistBeSubscribedCount;

	Profile({this.userId, this.vipType, this.gender, this.accountStatus, this.avatarImgId, this.birthday, this.nickname, this.city, this.backgroundImgId, this.userType, this.province, this.defaultAvatar, this.avatarUrl, this.djStatus, this.experts, this.mutual, this.remarkName, this.expertTags, this.authStatus, this.backgroundUrl, this.avatarImgIdStr, this.backgroundImgIdStr, this.detailDescription, this.followed, this.description, this.signature, this.authority, this.avatarImgId_str, this.followeds, this.follows, this.eventCount, this.playlistCount, this.playlistBeSubscribedCount});

	Profile.fromJson(Map<String, dynamic> json) {
		userId = json['userId'];
		vipType = json['vipType'];
		gender = json['gender'];
		accountStatus = json['accountStatus'];
		avatarImgId = json['avatarImgId'];
		birthday = json['birthday'];
		nickname = json['nickname'];
		city = json['city'];
		backgroundImgId = json['backgroundImgId'];
		userType = json['userType'];
		province = json['province'];
		defaultAvatar = json['defaultAvatar'];
		avatarUrl = json['avatarUrl'];
		djStatus = json['djStatus'];
		experts = json['experts'] != null ? new Experts.fromJson(json['experts']) : null;
		mutual = json['mutual'];
		remarkName = json['remarkName'];
		expertTags = json['expertTags'];
		authStatus = json['authStatus'];
		backgroundUrl = json['backgroundUrl'];
		avatarImgIdStr = json['avatarImgIdStr'];
		backgroundImgIdStr = json['backgroundImgIdStr'];
		detailDescription = json['detailDescription'];
		followed = json['followed'];
		description = json['description'];
		signature = json['signature'];
		authority = json['authority'];
		avatarImgId_str = json['avatarImgId_str'];
		followeds = json['followeds'];
		follows = json['follows'];
		eventCount = json['eventCount'];
		playlistCount = json['playlistCount'];
		playlistBeSubscribedCount = json['playlistBeSubscribedCount'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['userId'] = this.userId;
		data['vipType'] = this.vipType;
		data['gender'] = this.gender;
		data['accountStatus'] = this.accountStatus;
		data['avatarImgId'] = this.avatarImgId;
		data['birthday'] = this.birthday;
		data['nickname'] = this.nickname;
		data['city'] = this.city;
		data['backgroundImgId'] = this.backgroundImgId;
		data['userType'] = this.userType;
		data['province'] = this.province;
		data['defaultAvatar'] = this.defaultAvatar;
		data['avatarUrl'] = this.avatarUrl;
		data['djStatus'] = this.djStatus;
		if (this.experts != null) {
      data['experts'] = this.experts.toJson();
    }
		data['mutual'] = this.mutual;
		data['remarkName'] = this.remarkName;
		data['expertTags'] = this.expertTags;
		data['authStatus'] = this.authStatus;
		data['backgroundUrl'] = this.backgroundUrl;
		data['avatarImgIdStr'] = this.avatarImgIdStr;
		data['backgroundImgIdStr'] = this.backgroundImgIdStr;
		data['detailDescription'] = this.detailDescription;
		data['followed'] = this.followed;
		data['description'] = this.description;
		data['signature'] = this.signature;
		data['authority'] = this.authority;
		data['avatarImgId_str'] = this.avatarImgIdStr;
		data['followeds'] = this.followeds;
		data['follows'] = this.follows;
		data['eventCount'] = this.eventCount;
		data['playlistCount'] = this.playlistCount;
		data['playlistBeSubscribedCount'] = this.playlistBeSubscribedCount;
		return data;
	}
}

class Experts {

	// Experts({});

	Experts.fromJson(Map<String, dynamic> json);

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		return data;
	}
}

class Bindings {
	String url;
	int userId;
	String tokenJsonStr;
	int bindingTime;
	int expiresIn;
	int refreshTime;
	bool expired;
	int id;
	int type;

	Bindings({this.url, this.userId, this.tokenJsonStr, this.bindingTime, this.expiresIn, this.refreshTime, this.expired, this.id, this.type});

	Bindings.fromJson(Map<String, dynamic> json) {
		url = json['url'];
		userId = json['userId'];
		tokenJsonStr = json['tokenJsonStr'];
		bindingTime = json['bindingTime'];
		expiresIn = json['expiresIn'];
		refreshTime = json['refreshTime'];
		expired = json['expired'];
		id = json['id'];
		type = json['type'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['url'] = this.url;
		data['userId'] = this.userId;
		data['tokenJsonStr'] = this.tokenJsonStr;
		data['bindingTime'] = this.bindingTime;
		data['expiresIn'] = this.expiresIn;
		data['refreshTime'] = this.refreshTime;
		data['expired'] = this.expired;
		data['id'] = this.id;
		data['type'] = this.type;
		return data;
	}
}