// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get vicyos_radio => 'Vicyos Radio';

  @override
  String get vicyos_music => 'Vicyos Music';

  @override
  String get welcome_to => 'Welcome to...';

  @override
  String get just_a_sec => 'Just a sec...';

  @override
  String get no_search_results => 'No search results';

  @override
  String get streaming_all_capitalized => 'STREAMING';

  @override
  String get prepositionOf => 'of';

  @override
  String get the_radio_is_turned_off => 'The radio is turned off';

  @override
  String get ellipsis => '...';

  @override
  String get folder_name => 'Folder:';

  @override
  String get add_folder_to_the_current_playlist => 'Add folder to the current playlist';

  @override
  String get added_to_the_current_playlist => 'Added to the current playlist';

  @override
  String get play_all_the_songs_from_this_folder => 'Play all the songs from this folder';

  @override
  String get playing_all_the_songs_from_this_folder => 'Playing all the songs from this folder';

  @override
  String get add_to_playlist_all_capitalized => 'ADD TO PLAYLIST';

  @override
  String get import_folder => 'Import folder';

  @override
  String get add_songs => 'Add songs';

  @override
  String get song_name => 'Song Name:';

  @override
  String get add_to_play_next => 'Add to Play Next';

  @override
  String get share => 'Share';

  @override
  String get delete_from_device => 'Delete from device';

  @override
  String get clear_playlist_all_capitalized => 'CLEAR PLAYLIST';

  @override
  String get song_preview => 'Song Preview';

  @override
  String get playback_speed_all_capitalized => 'PLAYBACK SPEED';

  @override
  String get default_playback_speed => 'Default';

  @override
  String get delete_from_device_all_capitalized => 'DELETE FILE FROM DEVICE';

  @override
  String get are_you_sure => 'Are you sure?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete\'';

  @override
  String get search_with_ellipsis => 'Search...';

  @override
  String get online => 'Online';

  @override
  String get radio => 'Radio';

  @override
  String get error_to_play_radio_station_all_capitalized => 'ERROR TO PLAY RADIO STATION';

  @override
  String get the_song_folder_will_be_displayed_here => 'The song folder will be displayed here...';

  @override
  String get unknown_album => 'Unknown Album';

  @override
  String get the_playlist_is_empty => 'The playlist is empty';

  @override
  String get unknown_artist => 'Unknown Artist';

  @override
  String get added_to_the_playlist => 'Added to the playlist';

  @override
  String get repeat_mode_all_capitalized => 'REPEAT MODE:';

  @override
  String get repeating_one => 'Repeating one';

  @override
  String get playback_is_shuffled => 'Playback is shuffled';

  @override
  String get repeating_off => 'Repeating off';

  @override
  String get repeating_all => 'Repeating all';

  @override
  String get no_songs_have_been_found_in_the_music_folder => 'No songs have been found in the music folder.';

  @override
  String get there_is_no_music_folder_on_your_device => 'There is no music folder on your device.';

  @override
  String get no_audio_permission_has_been_granted => 'No permission to access\nthe music folder has been granted.';

  @override
  String get grant_permission => 'Grant Permission';

  @override
  String get deleted_successfully => 'Deleted successfully';

  @override
  String get removed_from_the_playlist => 'Removed from the playlist';

  @override
  String get this_file_was_shared_using_the_vicyos_music_app => 'This file was shared via the Vicyos Music app.';

  @override
  String number_of_songs_in_folder(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count songs',
      one: '1 song',
      zero: 'No songs',
    );
    return '$_temp0';
  }
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr(): super('pt_BR');

  @override
  String get vicyos_radio => 'Vicyos Rádio';

  @override
  String get vicyos_music => 'Vicyos Music';

  @override
  String get welcome_to => 'Bem-vindo ao...';

  @override
  String get just_a_sec => 'Só um segundo...';

  @override
  String get no_search_results => 'Nenhum resultado encontrado';

  @override
  String get streaming_all_capitalized => 'TRANSMITINDO';

  @override
  String get prepositionOf => 'de';

  @override
  String get the_radio_is_turned_off => 'O rádio está desligado';

  @override
  String get ellipsis => '...';

  @override
  String get folder_name => 'Pasta:';

  @override
  String get add_folder_to_the_current_playlist => 'Adicionar pasta à playlist atual';

  @override
  String get added_to_the_current_playlist => 'Adicionada à playlist atual';

  @override
  String get play_all_the_songs_from_this_folder => 'Reproduzir todas as músicas desta pasta';

  @override
  String get playing_all_the_songs_from_this_folder => 'Reproduzindo todas as músicas desta pasta';

  @override
  String get add_to_playlist_all_capitalized => 'ADICIONAR À PLAYLIST';

  @override
  String get import_folder => 'Importar pasta';

  @override
  String get add_songs => 'Adicionar músicas';

  @override
  String get song_name => 'Nome da música:';

  @override
  String get add_to_play_next => 'Adicionar para tocar em seguida';

  @override
  String get share => 'Compartilhar';

  @override
  String get delete_from_device => 'Excluir do dispositivo';

  @override
  String get clear_playlist_all_capitalized => 'LIMPAR PLAYLIST';

  @override
  String get song_preview => 'Prévia da música';

  @override
  String get playback_speed_all_capitalized => 'VELOCIDADE DE REPRODUÇÃO';

  @override
  String get default_playback_speed => 'Padrão';

  @override
  String get delete_from_device_all_capitalized => 'EXCLUIR DO DISPOSITIVO';

  @override
  String get are_you_sure => 'Tem certeza?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String get search_with_ellipsis => 'Pesquisar...';

  @override
  String get online => 'Rádio';

  @override
  String get radio => 'Online';

  @override
  String get error_to_play_radio_station_all_capitalized => 'ERRO AO REPRODUZIR ESTAÇÃO DE RÁDIO';

  @override
  String get the_song_folder_will_be_displayed_here => 'A pasta da música será exibida aqui...';

  @override
  String get unknown_album => 'Álbum desconhecido';

  @override
  String get the_playlist_is_empty => 'A playlist está vazia';

  @override
  String get unknown_artist => 'Artista desconhecido';

  @override
  String get added_to_the_playlist => 'Adicionada à playlist';

  @override
  String get repeat_mode_all_capitalized => 'MODO DE REPETIÇÃO:';

  @override
  String get repeating_one => 'Repetindo uma';

  @override
  String get playback_is_shuffled => 'Reprodução aleatória ativada';

  @override
  String get repeating_off => 'Repetição desativada';

  @override
  String get repeating_all => 'Repetindo todas';

  @override
  String get no_songs_have_been_found_in_the_music_folder => 'Nenhuma música foi encontrada na pasta de músicas.';

  @override
  String get there_is_no_music_folder_on_your_device => 'A pasta \'Music\' ou \'Músicas\' não existe no seu dispositivo.';

  @override
  String get no_audio_permission_has_been_granted => 'Nenhuma permissão para acessar\na pasta de músicas foi concedida.';

  @override
  String get grant_permission => 'Conceder permissão';

  @override
  String get deleted_successfully => 'Deletado com sucesso!';

  @override
  String get removed_from_the_playlist => 'Removido da playlist';

  @override
  String get this_file_was_shared_using_the_vicyos_music_app => 'Este arquivo foi compartilhado usando o aplicativo Vicyos Music.';

  @override
  String number_of_songs_in_folder(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count músicas',
      one: '1 música',
      zero: 'Nenhuma música',
    );
    return '$_temp0';
  }
}
