import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_tables.dart';
import 'package:seeds/datasource/remote/api/profile_repository.dart';
import 'package:seeds/datasource/remote/model/organization_model.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/datasource/remote/model/score_model.dart';
import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/domain-shared/base_use_case.dart';
import 'package:seeds/utils/result_extension.dart';

const int _profileResultIndex = 0;
const int _contributionScoreResultIndex = 1;
const int _organizationResultIndex = 2;
const int _canResidentResultIndex = 3;
const int _canCitizenResultIndex = 4;

class GetProfileValuesUseCase extends NoInputUseCase<GetProfileValuesResponse> {
  final ProfileRepository _profileRepository = ProfileRepository();

  @override
  Future<Result<GetProfileValuesResponse>> run() async {
    final account = settingsStorage.accountName;
    final futures = [
      _profileRepository.getProfile(account),
      _profileRepository.getScore(account: account, tableName: SeedsTable.tableCspoints),
      _profileRepository.getOrganizationAccount(account),
      _profileRepository.canResident(account),
      _profileRepository.canCitizen(account),
    ];

    final List<Result> response = await Future.wait(futures);

    if (areAllResultsError(response)) {
      return Result.error("Error fetching Profile Data");
    } else {
      final GetProfileValuesResponse result = GetProfileValuesResponse(
        profileModel: response[_profileResultIndex].valueOrNull as ProfileModel?,
        scoreModel: response[_contributionScoreResultIndex].valueOrNull as ScoreModel?,
        organizationModel: response[_organizationResultIndex].valueOrNull as List<OrganizationModel>?,
        canResident: response[_canResidentResultIndex].valueOrNull as TransactionResponse?,
        canCitizen: response[_canCitizenResultIndex].valueOrNull as TransactionResponse?,
      );

      return Result.value(result);
    }
  }
}

class GetProfileValuesResponse {
  final ProfileModel? profileModel;
  final ScoreModel? scoreModel;
  final List<OrganizationModel>? organizationModel;
  final TransactionResponse? canResident;
  final TransactionResponse? canCitizen;

  GetProfileValuesResponse({
    required this.profileModel,
    required this.scoreModel,
    required this.organizationModel,
    required this.canResident,
    required this.canCitizen,
  });
}
