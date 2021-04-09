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

class PUBGUser {}
