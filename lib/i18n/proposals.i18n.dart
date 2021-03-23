import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static final _t = Translations.byLocale('en_us') +
    {
      'es_es': {
        
        'Proposals': 'Propuestas',
        'Staged': 'Planeadas',
        'Evaluate': 'Evaluar',
        'Open': 'Abiertas',
        'Passed': 'Aprobadas',
        'Failed': 'Fallidas',

        'Created by:': 'Creada por',
        'total\n%s': 'votos\n%s',
        'Voted': 'Votado',
        'Yes': 'Sí',
        'No': 'No',

        'Recipient: %s ': 'Recipiente: %s ',
        'Requested: %s SEEDS': 'Monto solicitado: %s SEEDS',
        'Type: %s ': 'Tipo %s ',
        'Alliance': 'Alliance',
        'Campaign': 'Campaign',
        'Status: %s ': 'Estado: %s ',
        'Stage: %s ': 'Etapa: %s ',
        'URL: ': 'URL: ',
        "Couldn't open this url": 'No se pudo abrir este url',
        'Description': 'Descripción',
        'Voting': 'Votación',
        'Vote': 'Votar',
        'Unexpected error, please try again': 'Error inesperado, por favor intenta de nuevo',
        'You have no trust tokens': 'No tienes tokens de confianza',
      },
      "id_id": {
        
        "Proposals": "Proposal",
        'Staged': "Bertahap",
        'Evaluate': "Evaluate",
        "Open": "Buka",
        'Passed': "Disetujui",
        'Failed': "Gagal",

        'Created by:': "Dibuat oleh",
        'total\n%s': "total\n%s",
        'Voted': "memilih",
        'Yes': "Iya",
        'No': "Tidak",

        'Recipient: %s ': "Penerima: %s ",
        'Requested: %s SEEDS': "Diminta: %s SEEDS",
        'Type: %s ': "Tipe %s ",
        'Alliance': "Persekutuan",
        'Campaign': "Kampanye",
        'Status: %s ': "Status: %s ",
        'Stage: %s ': "Tahap: %s ",
        'URL: ': "URL: ",
        "Couldn't open this url": "Tidak dapat membuka url ini",
        'Description': "Deskripsi",
        'Voting': "Pemungutan suara",
        'Vote': "Pilih",
        "Unexpected error, please try again": "Galat tak terduga, harap coba lagi",
        "You have no trust tokens": "Anda tidak memiliki token kepercayaan",
      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
