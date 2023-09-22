import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: '.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'apiUrl')
  static final String apiUrl = _Env.apiUrl;
  @EnviedField(varName: 'ebookUrl')
  static final String ebookUrl = _Env.ebookUrl;
  @EnviedField(varName: 'ebookLaunchUrl')
  static final String ebookLaunchUrl = _Env.ebookLaunchUrl;
  @EnviedField(varName: 'otpUrl')
  static final String otpUrl = _Env.otpUrl;
  @EnviedField(varName: 'downloadUrl')
  static final String downloadUrl = _Env.downloadUrl;
  @EnviedField(varName: 'launchDownload')
  static final String launchDownload = _Env.launchDownload;
  @EnviedField(varName: 'downloadPath')
  static final String downloadPath = _Env.downloadPath;
  @EnviedField(varName: 'baseStorage')
  static final String baseStorage = _Env.baseStorage;
  @EnviedField(varName: 'vimeoApi')
  static final String vimeoApi = _Env.vimeoApi;
  @EnviedField(varName: 'vimeoToken')
  static final String vimeoToken = _Env.vimeoToken;
  @EnviedField(varName: 'kDownloadsFolder')
  static final String kDownloadsFolder = _Env.kDownloadsFolder;
  @EnviedField(varName: 'publicKey')
  static final String publicKey = _Env.publicKey;
  @EnviedField(defaultValue: '_test')
  static final String key3 = _Env.key3;
}
