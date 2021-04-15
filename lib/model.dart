class LOLUser {
  String id;
  String name;
  int profileIconId;
  int summonerLevel;
  String soloTier;
  String soloRank;
  int soloLeaguePoints;
  String flexTier;
  String flexRank;
  int flexLeaguePoints;

  LOLUser(
      {this.id,
      this.name,
      this.profileIconId,
      this.summonerLevel,
      this.soloTier,
      this.soloRank,
      this.soloLeaguePoints,
      this.flexTier,
      this.flexRank,
      this.flexLeaguePoints});

  @override
  String toString() {
    return "SUMMONER INFO:\n[id: $id\nname: $name\nprofileIconId: $profileIconId\nsummonerLevel: $summonerLevel\nsoloTier: $soloTier\nsoloRank: $soloRank\nsoloLeaguePoints: $soloLeaguePoints\nflexTier: $flexTier\nflexRank: $flexRank\nflexLeaguePoints: $flexLeaguePoints]";
  }
}

class PUBGUser {
  String accountId;
  String name;
  String soloTier;
  String soloRank;
  int soloPoints;
  String squadTier;
  String squadRank;
  int squadPoints;

  PUBGUser(
      {this.accountId,
      this.name,
      this.soloTier,
      this.soloRank,
      this.soloPoints,
      this.squadTier,
      this.squadRank,
      this.squadPoints});

  @override
  String toString() {
    return "USER INFO:\n[name: $name\naccountId: $accountId\nsoloTier: $soloTier\nsoloRank: $soloRank\nsoloPoints: $soloPoints\nsquadTier: $squadTier\nsquadRank: $squadRank\nrankPoints: $squadPoints";
  }
}
