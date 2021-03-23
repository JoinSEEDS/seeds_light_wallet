import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

static final _t = Translations.byLocale('en_us') +
    {
      'es_es': {
        'Enter user name or account': 'Ingresa nombre de cuenta',
        'Transfer': 'Transferir',
        'Choose existing Seeds Member to transfer': 'Escoge un miembro de Seeds para transferir',
        'Transaction hash: %s': 'Hash de transacción: %s',
        'Available balance': 'Balance disponible',
        'Transfer amount': 'Monto a transferir',
        'Amount cannot be 0.': 'Monto no puede ser 0.',
        'Amount cannot be negative.': 'Monto no puede ser negativa.',
        'Amount cannot be greater than availabe balance.': 'Monto no puede ser mayor al balance disponible',
        'available': 'disponible',
        'Invalid Amount': 'Monto invalido',
        'Send': 'Enviar',
        'Receive': 'Recibir',

         'Enter amount': 'Ingresa monto',
         'Confirm': 'Confirmar',
         'Pay %s SEEDS to %s':'Pagar %s SEEDS a %s',
         'Done': 'Hecho',

         'Your private key has not been backed up!': '¡Tu llave privada no ha sido respaldada en copia de seguridad!',
         'Backup': 'Copia de seguridad',
         'Later': 'Luego',
         'Latest transactions': 'Últimas transacciones',
         'Transactions History': 'Historia de transacciones',

         'Network error': 'Error de red',
         'Pull to update': 'Tire para actualizar',
         'Exchange rate load error': 'Error de red',

         'Add Product': 'Agregar Producto',
         'Price needs to be a number': 'Precio tiene que ser un numero',
         'Price field is empty': 'Ingrese un numero',
         'Price': 'Precio',
         'Name cannot be empty': 'Ingrese un nombre',
         'Name': 'Nombre',
         'Edit Product': 'Editar Producto',
         'Add Picture': 'Agregar Foto',
         'Change Picture': 'Cambiar Foto',
         'Delete': 'Eliminar',
        
         'Memo (optional)': 'Memo (opcional)',
         "What's it for?": 'Para que es?',

        'Your Products': 'Tus Productos',
        'Next': 'siguiente',
        'Custom Amount': 'Monto personalizado',
        'Total': 'Total'
      },
      "id_id": {
        'Enter user name or account': "Masukkan nama pengguna atau akun",
        "Transfer": "Transfer",
        "Choose existing Seeds Member to transfer": "Pilih Anggota SEEDS yang ada untuk ditransfer",
        "Transaction hash: %s": "Pagar Transakik: %s",
        'Available balance': "Saldo Tersidia",
        'Transfer amount': "Jumlah transfer",
        "Amount cannot be 0.": "Jumlah tidak boleh 0.",
        "Amount cannot be negative.": "Jumlah tidak boleh negatif.",
        "Amount cannot be greater than availabe balance.": "Jumlah tidak boleh lebih besar dari saldo yang tersedia.",
        "available": "Tersidia",
        "Invalid Amount": "Jumlah tidak valid",
        'Send': "Mengirim",
        'Receive': "Menerima",

         "Enter amount": "Masukan jumlah",
         "Confirm": "Konfirmasi",
         'Pay %s SEEDS to %s':'Membayar %s SEEDS a %s',
         "Done": "Selesai",

         'Your private key has not been backed up!': "Kunci pribadi Anda belum dicadangkan!",
         'Backup': "Cadangkan",
         'Later': "Nanti",
         'Latest transactions': "Terbaru transaksi",

         'Network error': 'Kesalahan jaringan',
         'Pull to update': 'Tarik untuk memperbarui',
         'Exchange rate load error': 'Kesalahan pemuatan nilai tukar',

         'Add Product': 'Tambahkan Produk',
         'Price needs to be a number': 'Harga harus berupa angka',
         'Price field is empty': 'Bidang harga kosong',
         'Price': 'Harga',
         'Name cannot be empty': 'Nama tidak boleh kosong',
         'Name': 'Nama',
         'Edit Product': 'Edit Produk',
         'Add Picture': 'Tambahkan Gambar',
         'Change Photo': 'Ganti foto',
         'Delete': 'Hapus',
        
         'Memo (optional)': 'Memo (opsional)',
         "What's it for?": "Untuk apa ini?",

        "Your Products": "Produk kamu",
        "Next": "Lanjut",
        "Custom Amount": "Jumlah Kustom",
        "Total": "Total"
      }
    };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);       

}
