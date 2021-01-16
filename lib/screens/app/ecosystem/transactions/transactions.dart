import './index.dart';

class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  ContractModel currentContract = contracts[0];

  Future<List<ActionModel>> fetchActions() async {
    print("fetch actions");

    var abi = await EosService.of(context).getContractAbi(
      currentContract.account,
    );
    var types = getTypesFromAbi(createInitialTypes(), abi);
    var actions = abi.actions
        .map(
          (action) => ActionModel(
              name: action.name,
              fields: types[action.type]
                  .fields
                  .map((field) => field.name)
                  .toList()),
        )
        .toList();
    return actions;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text("Transactions", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 17),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: width * 0.22,
                height: width * 0.22,
                child: SvgPicture.asset("assets/images/harvest.svg"),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        "Choose Contract",
                        style: TextStyle(fontSize: 14, color: AppColors.grey),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: DropdownButton<ContractModel>(
                          isExpanded: true,
                          value: currentContract,
                          onChanged: (ContractModel value) {
                            setState(() {
                              currentContract = value;
                            });
                          },
                          items: contracts
                              .map((contract) => DropdownMenuItem(
                                    child: Text(
                                        "${contract.name} (${contract.account})"),
                                    value: contract,
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: FutureBuilder(
                  future: fetchActions(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      final actions = snapshot.data;

                      if (actions != null && actions.isNotEmpty) {
                        return ActionFields(
                          actions: actions,
                          onSubmit: (transactionData) {
                            NavigationService.of(context).navigateTo(
                              Routes.customTransaction,
                              CustomTransactionArguments(
                                account: currentContract.account,
                                name: currentContract.name,
                                data: transactionData,
                              ),
                            );
                          },
                        );
                      } else {
                        print(snapshot.error.toString());
                        return Text(
                            'Cannot load actions for ${currentContract.account}');
                      }
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
