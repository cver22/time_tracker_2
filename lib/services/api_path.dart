class APIPath {
  //path for jobs, usable across the app
  static String job({String uid, String jobId}) => 'users/$uid/jobs/$jobId';
  static String jobs({String uid}) => 'users/$uid/jobs';
}