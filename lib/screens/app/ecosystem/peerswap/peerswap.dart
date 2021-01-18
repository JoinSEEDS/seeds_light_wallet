import './index.dart';

class PeerSwap extends StatefulWidget {
  @override
  _PeerSwapState createState() => _PeerSwapState();
}

class _PeerSwapState extends State<PeerSwap> {
  bool hasActiveSwap = HttpMockResponse.hasActiveSwap;

  @override
  Widget build(BuildContext context) {
    return hasActiveSwap ? ActiveSwap() : OrderBook();
  }
}

class OrderBook extends StatefulWidget {
  @override
  _OrderBookState createState() => _OrderBookState();
}

class _OrderBookState extends State<OrderBook>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void newBuyOrder() {}

  void newSellOrder() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        title: Text(
          "Order Book",
          style: TextStyle(color: Colors.black),
        ),
        bottom: TabBar(
          controller: tabController,
          tabs: [
            Tab(text: "Buyers"),
            Tab(text: "Sellers"),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Buyers(),
          Sellers(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          if (tabController.index == 0) {
            newSellOrder();
          } else {
            newBuyOrder();
          }
        },
      ),
    );
  }
}

enum OrderType { Buy, Sell }

class PeerModel {
  String account;
  int deals;
  int reputation;
}

class SwapModel {
  PeerModel buyer;
  PeerModel seller;
  int rate;
  bool done;
}

class OrderModel {
  PeerModel peer;
  OrderType type;
  int reputation;
  int minAmount;
  int maxAmount;
}

class Buyers extends StatefulWidget {
  @override
  _BuyersState createState() => _BuyersState();
}

class _BuyersState extends State<Buyers> {
  final buyers = <PeerModel>[];

  void startSwap() {
    showDialog(
      TextField(), // how much seeds you want to sell ? (check less than your balance)
      Text('Receive in dollars ...'), // equal amount in dollars for this rate,
      Text('Your PayPal email'), // what is your paypal email
      OutlineButton(
        child: Text('Start Swap'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(label: Text('Account')),
        DataColumn(label: Text('Deals')),
        DataColumn(label: Text('Reputation')),
        DataColumn(label: Text('Rate')),
        DataColumn(label: Text('Min. Amount')),
        DataColumn(label: Text('Max. Amount')),
        DataColumn(label: Text('Actions')),
      ],
      rows: buyers.map((buyer) => DataRow(
            cells: [
              DataCell(Text(buyer.account)),
              DataCell(Text(buyer.deals.toString())),
              DataCell(Text(buyer.reputation.toString())),
              DataCell(Text(buyer.rate.toString())),
              DataCell(Text(buyer.minAmount.toString())),
              DataCell(Text(buyer.maxAmount.toString())),
              DataCell(
                OutlineButton(
                    child: Text('Sell'),
                    onPressed: () {
                      startSwap();
                    }),
              ),
            ],
          )),
    );
  }
}

class Sellers extends StatefulWidget {
  @override
  _SellersState createState() => _SellersState();
}

class _SellersState extends State<Sellers> {
  final sellers = <PeerModel>[];

  void startSwap() {}

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(label: Text('Account')),
        DataColumn(label: Text('Deals')),
        DataColumn(label: Text('Reputation')),
        DataColumn(label: Text('Rate')),
        DataColumn(label: Text('Min. Amount')),
        DataColumn(label: Text('Max. Amount')),
        DataColumn(label: Text('Actions')),
      ],
      rows: sellers.map((seller) => DataRow(
            cells: [
              DataCell(Text(seller.account)),
              DataCell(Text(seller.deals.toString())),
              DataCell(Text(seller.reputation.toString())),
              DataCell(Text(seller.rate.toString())),
              DataCell(Text(seller.minAmount.toString())),
              DataCell(Text(seller.maxAmount.toString())),
              DataCell(OutlineButton(
                  child: Text('Buy'),
                  onPressed: () {
                    startSwap();
                  }))
            ],
          )),
    );
  }
}

class ActiveSwap extends StatefulWidget {
  @override
  _ActiveSwapState createState() => _ActiveSwapState();
}

class _ActiveSwapState extends State<ActiveSwap> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
