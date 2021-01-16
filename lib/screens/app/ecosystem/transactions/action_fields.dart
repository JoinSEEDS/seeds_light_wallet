import './index.dart';

class ActionFields extends StatefulWidget {
  final List<ActionModel> actions;
  final Function(Map<String, dynamic>) onSubmit;

  ActionFields({this.actions, this.onSubmit});

  @override
  _ActionFieldsState createState() => _ActionFieldsState();
}

class _ActionFieldsState extends State<ActionFields> {
  ActionModel currentAction;
  Map<String, String> transactionData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 150,
              child: Text(
                "Choose Action",
                style: TextStyle(fontSize: 14, color: AppColors.grey),
              ),
            ),
            Expanded(
              child: DropdownButton<ActionModel>(
                isExpanded: true,
                value: currentAction,
                onChanged: (ActionModel value) {
                  setState(() {
                    currentAction = value;
                  });
                },
                items: widget.actions
                    .map(
                      (action) => DropdownMenuItem(
                        child: Text(action.name),
                        value: action,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
        currentAction != null
            ? Column(
                children: [
                  ...currentAction.fields
                      .map(
                        (field) => Row(
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text(field,
                                  style: TextStyle(
                                      fontSize: 14, color: AppColors.grey)),
                            ),
                            Expanded(
                              child: TextField(
                                  // onChanged: (value) {
                                  //   transactionData[field] = value;
                                  // },
                                  ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: MainButton(
                        title: "Send Transaction",
                        onPressed: () {
                          widget.onSubmit(transactionData);
                        }),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
}
