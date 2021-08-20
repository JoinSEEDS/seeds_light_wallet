import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/interactor/usecases/get_guardians_usecase.dart';

class GuardiansUseCase {
  Stream<List<GuardianModel>> get guardians {
    final GetGuardiansUseCase _userCase = GetGuardiansUseCase();
    return _userCase.getGuardians();
  }
}
