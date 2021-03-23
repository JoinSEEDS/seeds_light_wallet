import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static final _t = Translations.byLocale('en_us') +
    {
      'es_es': {
        'Available balance': 'Balance disponible',
        'Paste from clipboard': 'Pegar del portapapeles',
        'ONLINE (connected to %s)': 'EN LÍNEA (conectado a %s)',
        'OFFLINE (trying to reconnect)': 'FUERA DE LÍNEA (intentando reconectar)',

        'Transaction successful': 'Transacción exitosa',
        'Transaction failed': 'Transacción fallida',
        'Done': 'Listo',

        'Page Not Found': 'Página no encontrada',
        'The page you are looking for is not available': 'La página que buscas no está disponible',

        'Delete': 'Borrar',
        'Enter Passcode': 'Ingresar código de acceso',
        'Choose Passcode': 'Escoge código de acceso',
        'Disable Passcode': 'Deshabilita código de acceso',

        'Planted balance': 'Balance plantado',

        'Telos balance': 'Balance Telos',

        'Transaction hash: %s': 'Hash de transacción: %s',
        'Transfer amount': 'Monto a transferir',
        'Send': 'Enviar',
        'Back': 'Atrás',
        'Explore': 'Explorar',
        'Wallet': 'Billetera',
        'Profile': 'Perfil',
      },
      "id_id": {
        'Available balance': "Saldo Tersedia",
        "Paste from clipboard": "Dapatkan dari brankas",
        "ONLINE (connected to %s)": "ONLINE (terhubung ke %s)",
        'OFFLINE (trying to reconnect)': "OFFLINE (coba hubungi kembali)",

        "Transaction successful": "Transaksi sukses",
        "Transaction failed": "Transaksi gagal",
        "Done": "Selesai",

        'Page Not Found': "Halaman tidak ditemukan",
        'The page you are looking for is not available': "Halaman yang Anda cari tidak tersedia",

        "Delete": "Dihapus",
        "Enter Passcode": "Masukan Passkode",
        "Choose Passcode": "Pilih Passkode",
        "Disable Passcode": "Menolak Passkode",

        'Planted balance': "Saldo yang ditanam",

        'Telos balance': "Saldo Telos",

        "Transaction hash: %s": "Pagar Transaki: %s",
        'Transfer amount': "Jumlah transfer",
        'Send': "Mengirim",
        'Back': 'Kembali',
        "Explore": "Jelajahi",
        "Wallet": "Dompet",
        "Profile": "Profil",
      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
