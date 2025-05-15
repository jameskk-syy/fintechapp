import 'package:xml/xml.dart';

class AccountBalanceResponse {
  final String balance;
  final String loanBalance;
  final String additionalInfo;
  final String bankResponseCode;

  AccountBalanceResponse({
    required this.balance,
    required this.loanBalance,
    required this.additionalInfo,
    required this.bankResponseCode,
  });

  factory AccountBalanceResponse.fromXml(XmlDocument doc) {
    getText(String tag) =>
        doc.findAllElements(tag).isNotEmpty ? doc.findAllElements(tag).first.text : '';

    return AccountBalanceResponse(
      balance: getText('c4:Balance'),
      loanBalance: getText('c4:LoanBalance'),
      additionalInfo: getText('c4:AdditionalInformation'),
      bankResponseCode: getText('c4:BankResponseCode'),
    );
  }
}
