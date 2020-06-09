
import 'package:rxdart/rxdart.dart';
import 'package:seeds/features/account/account_generator_service.dart';
import 'package:seeds/features/account/account_commands.dart';
import 'package:seeds/utils/bloc/cmd_common.dart';

class CreateAccountBloc {

  AccountGeneratorService _accountGeneratorService;
  final _userName = BehaviorSubject<String>();
  final _userAccount = BehaviorSubject<String>();
  final _selectedAccount = BehaviorSubject<String>();
  final _validAccounts = BehaviorSubject<ValidAccounts>.seeded(ValidAccounts(false, []));
  final _available = BehaviorSubject<bool>();
  final _execute = PublishSubject<AccountCmd>();

  Stream<ValidAccounts> get validAccounts => _validAccounts.stream;
  Stream<bool> get available => _available.stream.distinct();
  Stream<String> get userName => _userName.stream.debounceTime(Duration(milliseconds: 500)).where((value) => value.length > 0);
  Stream<String> get userAccount => _userAccount.stream.debounceTime(Duration(milliseconds: 500)).where((value) => value.length > 0);
  Function(String) get setUserName => _userName.add;
  Function(String) get setUserAccount => _userAccount.add;
  Function(UpdateSuggestionCmd) get execute => _execute.add;

  CreateAccountBloc() {
    _execute.listen(_executeCommand);
    _initGenerateAccountFromUserName();
    _initGenerateAccountFromUserAccount();
    _initValidateLatestAccountUnlessAlreadyValid();
  }

  void update(AccountGeneratorService accountGeneratorService) {
    this._accountGeneratorService = accountGeneratorService;
  }

  void _initGenerateAccountFromUserName() {
    userName
      .flatMap((name) => generateList(name))
      .listen(_addValidAccounts);
  }

  Stream<List<String>> generateList(String name) {
    _validAccounts.add(_validAccounts.value.switchToInProgress());
    return _accountGeneratorService.generateList(name).asStream();
  }

  void _initGenerateAccountFromUserAccount() {
    userAccount
      .where((account) => _accountGeneratorService.validate(account).invalid)
      .flatMap((account) => generateList(account))
      .listen(_addValidAccounts);
  }

  void _initValidateLatestAccountUnlessAlreadyValid() {
    CombineLatestStream
      .combine2(userAccount, _validAccounts, (account, alreadyValidated) => stuff(account, alreadyValidated))
      .flatMap((value) => value)
      .listen(_available.add);
  }

  Stream<bool> stuff(String account, ValidAccounts alreadyValidated) {
    if(alreadyValidated.contains(account)) {
      return Stream.value(true);
    } else if(_accountGeneratorService.validate(account).valid) {
      return _accountGeneratorService.availableOnChain(account).asStream();
    }
    return Stream.value(false);
  }

  _addValidAccounts(List<String> accounts) {
    final distinctList = (_validAccounts.value.accounts + accounts).toSet().toList();
    _validAccounts.add(ValidAccounts(false, distinctList));
  }

  _executeCommand(AccountCmd cmd) {
    switch(cmd.runtimeType) {
      /*case UpdateSuggestionCmd:
        final update = cmd as UpdateSuggestionCmd;
        _accountGeneratorService.generateList(update.value).then(_validAccounts.add);
        _validAccounts.add([update.value]);
        break;*/

      default:
        throw UnknownCmd(cmd);
    }
  }

  void discard() {
    _userName.close();
    _userAccount.close();
    _selectedAccount.close();
    _validAccounts.close();
    _available.close();
    _execute.close();
  }

}

class ValidAccounts {

  final bool inProgress;
  final List<String> accounts;
  
  ValidAccounts(this.inProgress, List<String> accounts) :
      this.accounts = accounts == null ? [] : accounts;

  ValidAccounts.empty() : this(true, []);

  ValidAccounts switchToInProgress() => ValidAccounts(!inProgress, accounts);

  bool contains(String account) => accounts.contains(account);

  Iterable<String> latest(int count) => accounts
    .reversed
    .take(count);

}