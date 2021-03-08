//Order by Most traded currencies: https://en.wikipedia.org/wiki/Template:Most_traded_currencies
List<Map<String, String>> currencies = [
  {"code": "USD", "name": "United States Dollar", "symbol": "\$", "flag": "USD", "number": "840"},
  {"code": "EUR", "name": "Euro", "symbol": "€", "flag": "EUR", "number": "978"},
  {"code": "JPY", "name": "Japanese Yen", "symbol": "¥", "flag": "JPY", "number": "392"},
  {"code": "GBP", "name": "British Pound", "symbol": "£", "flag": "GBP", "number": "826"},
  {"code": "AUD", "name": "Australian Dollar", "symbol": "\$", "flag": "AUD", "number": "036"},
  {"code": "CAD", "name": "Canada Dollar", "symbol": "\$", "flag": "CAD", "number": "124"},
  {"code": "CHF", "name": "Switzerland Franc", "symbol": "CHF", "flag": "CHF", "number": "756"},
  {"code": "CNY", "name": "China Yuan Renminbi", "symbol": "¥", "flag": "CNY", "number": "156"},
  {"code": "HKD", "name": "Hong Kong Dollar", "symbol": "\$", "flag": "HKD", "number": "344"},
  {"code": "NZD", "name": "New Zealand Dollar", "symbol": "\$", "flag": "NZD", "number": "554"},
  {"code": "SEK", "name": "Sweden Krona", "symbol": "kr", "flag": "SEK", "number": "752"},
  {"code": "KRW", "name": "Korea (South) Won", "symbol": "₩", "flag": "KRW", "number": "410"},
  {"code": "SGD", "name": "Singapore Dollar", "symbol": "\$", "flag": "SGD", "number": "702"},
  {"code": "NOK", "name": "Norway Krone", "symbol": "kr", "flag": "NOK", "number": "578"},
  {"code": "MXN", "name": "Mexico Peso", "symbol": "\$", "flag": "MXN", "number": "484"},
  {"code": "INR", "name": "Indian Rupee", "symbol": "₹", "flag": "INR", "number": "356"},
  {"code": "RUB", "name": "Russia Ruble", "symbol": "₽", "flag": "RUB", "number": "643"},
  {"code": "ZAR", "name": "South Africa Rand", "symbol": "R", "flag": "ZAR", "number": "710"},
  {"code": "TRY", "name": "Turkish Lira", "symbol": "₺", "flag": "TRY", "number": "949"},
  {"code": "BRL", "name": "Brazil Real", "symbol": "R\$", "flag": "BRL", "number": "986"},
  {"code": "TWD", "name": "Taiwan New Dollar", "symbol": "NT\$", "flag": "TWD", "number": "901"},
  {"code": "DKK", "name": "Denmark Krone", "symbol": "kr", "flag": "DKK", "number": "208"},
  {"code": "PLN", "name": "Poland Zloty", "symbol": "zł", "flag": "PLN", "number": "985"},
  {"code": "THB", "name": "Thailand Baht", "symbol": "฿", "flag": "THB", "number": "764"},
  {"code": "IDR", "name": "Indonesia Rupiah", "symbol": "Rp", "flag": "IDR", "number": "360"},
  {"code": "HUF", "name": "Hungary Forint", "symbol": "Ft", "flag": "HUF", "number": "348"},
  {"code": "CZK", "name": "Czech Koruna", "symbol": "Kč", "flag": "CZK", "number": "203"},
  {"code": "ILS", "name": "Israel Shekel", "symbol": "₪", "flag": "ILS", "number": "376"},
  {"code": "CLP", "name": "Chile Peso", "symbol": "\$", "flag": "CLP", "number": "152"},
  {"code": "PHP", "name": "Philippines Peso", "symbol": "₱", "flag": "PHP", "number": "608"},
  {"code": "AED", "name": "Emirati Dirham", "symbol": "د.إ", "flag": "AED", "number": "784"},
  {"code": "COP", "name": "Colombia Peso", "symbol": "\$", "flag": "COP", "number": "170"},
  {"code": "SAR", "name": "Saudi Arabia Riyal", "symbol": "﷼", "flag": "SAR", "number": "682"},
  {"code": "MYR", "name": "Malaysia Ringgit", "symbol": "RM", "flag": "MYR", "number": "458"},
  {"code": "RON", "name": "Romania Leu", "symbol": "lei", "flag": "RON", "number": "946"},
  {"code": "AFN", "name": "Afghanistan Afghani", "symbol": "؋", "flag": "AFN", "number": "971"},
  {"code": "ARS", "name": "Argentine Peso", "symbol": "\$", "flag": "ARS", "number": "032"},
  {"code": "BBD", "name": "Barbados Dollar", "symbol": "\$", "flag": "BBD", "number": "052"},
  {"code": "BDT", "name": "Bangladeshi Taka", "symbol": " Tk", "flag": "BDT", "number": "050"},
  {"code": "BGN", "name": "Bulgarian Lev", "symbol": "лв", "flag": "BGN", "number": "975"},
  {"code": "BHD", "name": "Bahraini Dinar", "symbol": "BD", "flag": "BHD", "number": "048"},
  {"code": "BMD", "name": "Bermuda Dollar", "symbol": "\$", "flag": "BMD", "number": "060"},
  {"code": "BND", "name": "Brunei Darussalam Dollar", "symbol": "\$", "flag": "BND", "number": "096"},
  {"code": "BOB", "name": "Bolivia Bolíviano", "symbol": "\$b", "flag": "BOB", "number": "068"},
  {"code": "BTN", "name": "Bhutanese Ngultrum", "symbol": "Nu.", "flag": "BTN", "number": "064"},
  {"code": "BZD", "name": "Belize Dollar", "symbol": "BZ\$", "flag": "BZD", "number": "084"},
  {"code": "CRC", "name": "Costa Rica Colon", "symbol": "₡", "flag": "CRC", "number": "188"},
  {"code": "DOP", "name": "Dominican Republic Peso", "symbol": "RD\$", "flag": "DOP", "number": "214"},
  {"code": "EGP", "name": "Egypt Pound", "symbol": "£", "flag": "EGP", "number": "818"},
  {"code": "ETB", "name": "Ethiopian Birr", "symbol": "Br", "flag": "ETB", "number": "230"},
  {"code": "GEL", "name": "Georgian Lari", "symbol": "₾", "flag": "GEL", "number": "981"},
  {"code": "GHS", "name": "Ghana Cedi", "symbol": "¢", "flag": "GHS", "number": "936"},
  {"code": "GMD", "name": "Gambian dalasi", "symbol": "D", "flag": "GMD", "number": "270"},
  {"code": "GYD", "name": "Guyana Dollar", "symbol": "\$", "flag": "GYD", "number": "328"},
  {"code": "HRK", "name": "Croatia Kuna", "symbol": "kn", "flag": "HRK", "number": "191"},
  {"code": "ISK", "name": "Iceland Krona", "symbol": "kr", "flag": "ISK", "number": "352"},
  {"code": "JMD", "name": "Jamaica Dollar", "symbol": "J\$", "flag": "JMD", "number": "388"},
  {"code": "KES", "name": "Kenyan Shilling", "symbol": "KSh", "flag": "KES", "number": "404"},
  {"code": "KWD", "name": "Kuwaiti Dinar", "symbol": "د.ك", "flag": "KWD", "number": "414"},
  {"code": "KYD", "name": "Cayman Islands Dollar", "symbol": "\$", "flag": "KYD", "number": "136"},
  {"code": "KZT", "name": "Kazakhstan Tenge", "symbol": "лв", "flag": "KZT", "number": "398"},
  {"code": "LAK", "name": "Laos Kip", "symbol": "₭", "flag": "LAK", "number": "418"},
  {"code": "LKR", "name": "Sri Lanka Rupee", "symbol": "₨", "flag": "LKR", "number": "144"},
  {"code": "LRD", "name": "Liberia Dollar", "symbol": "\$", "flag": "LRD", "number": "430"},
  {"code": "LTL", "name": "Lithuanian Litas", "symbol": "Lt", "flag": "LTL", "number": "440"},
  {"code": "MAD", "name": "Moroccan Dirham", "symbol": "MAD", "flag": "MAD", "number": "504"},
  {"code": "MDL", "name": "Moldovan Leu", "symbol": "MDL", "flag": "MDL", "number": "498"},
  {"code": "MKD", "name": "Macedonia Denar", "symbol": "ден", "flag": "MKD", "number": "807"},
  {"code": "MNT", "name": "Mongolia Tughrik", "symbol": "₮", "flag": "MNT", "number": "496"},
  {"code": "MUR", "name": "Mauritius Rupee", "symbol": "₨", "flag": "MUR", "number": "480"},
  {"code": "MWK", "name": "Malawian Kwacha", "symbol": "MK", "flag": "MWK", "number": "454"},
  {"code": "MZN", "name": "Mozambique Metical", "symbol": "MT", "flag": "MZN", "number": "943"},
  {"code": "NAD", "name": "Namibia Dollar", "symbol": "\$", "flag": "NAD", "number": "516"},
  {"code": "NGN", "name": "Nigeria Naira", "symbol": "₦", "flag": "NGN", "number": "566"},
  {"code": "NIO", "name": "Nicaragua Cordoba", "symbol": "C\$", "flag": "NIO", "number": "558"},
  {"code": "NPR", "name": "Nepal Rupee", "symbol": "₨", "flag": "NPR", "number": "524"},
  {"code": "OMR", "name": "Oman Rial", "symbol": "﷼", "flag": "OMR", "number": "512"},
  {"code": "PEN", "name": "Peru Sol", "symbol": "S/.", "flag": "PEN", "number": "604"},
  {"code": "PGK", "name": "Papua New Guinean Kina", "symbol": "K", "flag": "PGK", "number": "598"},
  {"code": "PKR", "name": "Pakistan Rupee", "symbol": "₨", "flag": "PKR", "number": "586"},
  {"code": "PYG", "name": "Paraguay Guarani", "symbol": "Gs", "flag": "PYG", "number": "600"},
  {"code": "QAR", "name": "Qatar Riyal", "symbol": "﷼", "flag": "QAR", "number": "634"},
  {"code": "RSD", "name": "Serbia Dinar", "symbol": "Дин.", "flag": "RSD", "number": "941"},
  {"code": "SOS", "name": "Somalia Shilling", "symbol": "S", "flag": "SOS", "number": "706"},
  {"code": "SRD", "name": "Suriname Dollar", "symbol": "\$", "flag": "SRD", "number": "968"},
  {"code": "TTD", "name": "Trinidad and Tobago Dollar", "symbol": "TT\$", "flag": "TTD", "number": "780"},
  {"code": "TZS", "name": "Tanzanian Shilling", "symbol": "TSh", "flag": "TZS", "number": "834"},
  {"code": "UAH", "name": "Ukraine Hryvnia", "symbol": "₴", "flag": "UAH", "number": "980"},
  {"code": "UGX", "name": "Ugandan Shilling", "symbol": "USh", "flag": "UGX", "number": "800"},
  {"code": "UYU", "name": "Uruguay Peso", "symbol": "\$U", "flag": "UYU", "number": "858"},
  {"code": "VEF", "name": "Venezuela Bolívar", "symbol": "Bs", "flag": "VEF", "number": "937"},
  {"code": "VND", "name": "Viet Nam Dong", "symbol": "₫", "flag": "VND", "number": "704"},
  {"code": "YER", "name": "Yemen Rial", "symbol": "﷼", "flag": "YER", "number": "886"},
];

class Currency {
  ///The currency code
  final String code;

  ///The currency name in English
  final String name;

  ///The currency symbol
  final String symbol;

  ///The currency flag code
  ///
  /// To get flag unicode(Emoji) use [countryCodeToEmoji]
  final String flag;

  ///The currency number
  final String number;

  Currency({this.code, this.name, this.symbol, this.flag, this.number});

  Currency.from({Map<String, String> json})
      : code = json['code'],
        name = json['name'],
        symbol = json['symbol'],
        number = json['number'],
        flag = json['flag'];
}
