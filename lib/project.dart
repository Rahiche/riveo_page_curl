class Project {
  Project(this.url, this.title);
  final String url;
  final String title;
}

final List<Project> defaultProjects = [
  Project(
    'https://starzplay-img-prod-ssl.akamaized.net/1200w/WarnerBrothers/INTERSTELLARY2014M/INTERSTELLARY2014M-1536x614-DHE.jpg',
    "Interstellar",
  ),
  Project(
    'https://images.squarespace-cdn.com/content/v1/50e46031e4b0c2f49772822a/1518718103077-L98RTBPZVDKXQPWJ01XH/dunkirk-pan-poster.jpg',
    "Dunkirk",
  ),
  Project(
    'https://images5.alphacoders.com/125/1257951.jpeg',
    "Oppenheimer",
  ),
  Project(
    'https://i0.wp.com/jasonsmovieblog.com/wp-content/uploads/2020/09/41eac67d-5b72-44a5-ace1-2d1e32722649-2ba31b620ad97bf40786d713eb53e0e3f2ea708d-e1599031322773.jpg?fit=2000%2C740&ssl=1',
    "Tenet",
  ),
];
