import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale('en_us') +
      {
        'es_es': {
          'Full Name': 'Nombre completo',
          'Enter your name': 'Ingresa tu nombre',
          'Name cannot be empty': 'Nombre no puede estar vacío',
          'Save': 'Guardar',
          'Terms & Conditions': 'Términos y condiciones',
          'Privacy Policy': 'Política de privacidad',
          'Export private key': 'Exportar llave privada',
          'Logout': 'Cerrar sesión',
          'Choose Picture': 'Escoger foto',
          'Take a picture': 'Tomar foto',
          'Profile updated successfully.': 'Perfil actualizado con éxito',
          'An error occured, please try again.': 'Ocurrió un error, por favor intentar de nuevo',
          'Save private key in secure place - to be able to restore access to your wallet later':
              'Guarda la llave privada en un lugar seguro - para poder recuperar acceso a tu billetera luego',
          'Save private key': 'Guarda la llave privada',
          'Key Guardians': 'Guardianes de Llave',
          // profile_v2
          'Contribution Score': 'Puntaje de contribución',
          'Badges Earned': 'Insignias ganadas',
          'Bioregion': 'Bioregion',
          'Currency': 'Moneda',
          'Skills & Interest': 'Habilidades e interés',
          'You are on the way from': 'Estás en el camino de',
          'Resident': 'Residente',
          'to': 'a',
          'Citizen': 'Ciudadano',
          'View your progress': 'Ver tu progreso',
          'Security': 'Seguridad',
          'Support': 'Soporte'
        },
        "id_id": {
          'Full Name': "nama lengkap",
          'Enter your name': "Masukkan nama Anda",
          "Name cannot be empty": "Nama tidak boleh kosong",
          'Save': "Menyimpan",
          "Terms & Conditions": "Syarat & Ketentuan",
          'Privacy Policy': "'Rahasia pribadi'",
          'Export private key': "Ekspor kunci pribadi",
          'Logout': "Keluar",
          'Choose Picture': "Pilih foto",
          'Take a picture': "Mengambil foto",
          'Profile updated successfully.': "Profil berhasil diperbarui",
          'An error occured, please try again.':
              "Terjadi kesalahan, coba lagi",
          'Save private key in secure place - to be able to restore access to your wallet later':
              "Simpan kunci pribadi di tempat aman - untuk dapat memulihkan akses ke dompet Anda nanti",
          "Save private key": "Simpan kunci pribadi",
          "Key Guardians": "Penjaga Kunci",
          // profile_v2
          "Contribution Score": "Skor Kontribusi",
          "Badges Earned": "Mendapatkan Lencana",
          "Bioregion": "Bioregion",
          "Currency": "Mata uang",
          "Skills & Interest": "Keterampilan & Minat",
          "You are on the way from": "Anda sedang dalam perjalanan dari",
          "Resident": "Residen",
          "to": "ke",
          "Citizen": "Warga",
          "View your progress": "Lihat kemajuan Anda",
          "Settings": "Konfigurasi",
          "Security": "Keamanan",
          "Support": "Dukung"
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
